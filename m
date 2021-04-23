Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD00D369B1F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 22:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243935AbhDWUIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 16:08:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58130 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWUIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 16:08:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A3F7C4D25BD9B;
        Fri, 23 Apr 2021 13:07:52 -0700 (PDT)
Date:   Fri, 23 Apr 2021 13:07:48 -0700 (PDT)
Message-Id: <20210423.130748.1071901004935481894.davem@davemloft.net>
To:     jinyiting@huawei.com
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, netdev@vger.kernel.org, security@kernel.org,
        linux-kernel@vger.kernel.org, xuhanbing@huawei.com,
        wangxiaogang3@huawei.com
Subject: Re: [PATCH] bonding: 3ad: Fix the conflict between
 bond_update_slave_arr and the state machine
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1618994301-1186-1-git-send-email-jinyiting@huawei.com>
References: <1618994301-1186-1-git-send-email-jinyiting@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 23 Apr 2021 13:07:53 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jinyiting <jinyiting@huawei.com>
Date: Wed, 21 Apr 2021 16:38:21 +0800

> The bond works in mode 4, and performs down/up operations on the bond
> that is normally negotiated. The probability of bond-> slave_arr is NULL
> 
> Test commands:
>    ifconfig bond1 down
>    ifconfig bond1 up
> 
> The conflict occurs in the following process：
> 
> __dev_open (CPU A)
> --bond_open
>   --queue_delayed_work(bond->wq,&bond->ad_work,0);
>   --bond_update_slave_arr
>     --bond_3ad_get_active_agg_info
> 
> ad_work(CPU B)
> --bond_3ad_state_machine_handler
>   --ad_agg_selection_logic
> 
> ad_work runs on cpu B. In the function ad_agg_selection_logic, all
> agg->is_active will be cleared. Before the new active aggregator is
> selected on CPU B, bond_3ad_get_active_agg_info failed on CPU A,
> bond->slave_arr will be set to NULL. The best aggregator in
> ad_agg_selection_logic has not changed, no need to update slave arr.
> 
> The conflict occurred in that ad_agg_selection_logic clears
> agg->is_active under mode_lock, but bond_open -> bond_update_slave_arr
> is inspecting agg->is_active outside the lock.
> 
> Also, bond_update_slave_arr is normal for potential sleep when
> allocating memory, so replace the WARN_ON with a call to might_sleep.
> 
> Signed-off-by: jinyiting <jinyiting@huawei.com>
> ---
> 
> Previous versions:
>  * https://lore.kernel.org/netdev/612b5e32-ea11-428e-0c17-e2977185f045@huawei.com/
> 
>  drivers/net/bonding/bond_main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 74cbbb2..83ef62d 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -4406,7 +4404,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
>  	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
>  		struct ad_info ad_info;
>  
> +		spin_lock_bh(&bond->mode_lock);

The code paths that call this function with mode_lock held will now deadlock.
