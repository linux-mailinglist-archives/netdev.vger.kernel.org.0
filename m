Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B97236B9C8
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 21:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240265AbhDZTJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 15:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240229AbhDZTJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 15:09:10 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F8FC061574;
        Mon, 26 Apr 2021 12:08:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 99DD74F21C303;
        Mon, 26 Apr 2021 12:08:26 -0700 (PDT)
Date:   Mon, 26 Apr 2021 12:08:22 -0700 (PDT)
Message-Id: <20210426.120822.232032630973964712.davem@davemloft.net>
To:     jay.vosburgh@canonical.com
Cc:     jinyiting@huawei.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, netdev@vger.kernel.org, security@kernel.org,
        linux-kernel@vger.kernel.org, xuhanbing@huawei.com,
        wangxiaogang3@huawei.com
Subject: Re: [PATCH] bonding: 3ad: Fix the conflict between
 bond_update_slave_arr and the state machine
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20034.1619450557@famine>
References: <1618994301-1186-1-git-send-email-jinyiting@huawei.com>
        <20210423.130748.1071901004935481894.davem@davemloft.net>
        <20034.1619450557@famine>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 26 Apr 2021 12:08:27 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jay Vosburgh <jay.vosburgh@canonical.com>
Date: Mon, 26 Apr 2021 08:22:37 -0700

> David Miller <davem@davemloft.net> wrote:
> 
>>From: jinyiting <jinyiting@huawei.com>
>>Date: Wed, 21 Apr 2021 16:38:21 +0800
>>
>>> The bond works in mode 4, and performs down/up operations on the bond
>>> that is normally negotiated. The probability of bond-> slave_arr is NULL
>>> 
>>> Test commands:
>>>    ifconfig bond1 down
>>>    ifconfig bond1 up
>>> 
>>> The conflict occurs in the following process：
>>> 
>>> __dev_open (CPU A)
>>> --bond_open
>>>   --queue_delayed_work(bond->wq,&bond->ad_work,0);
>>>   --bond_update_slave_arr
>>>     --bond_3ad_get_active_agg_info
>>> 
>>> ad_work(CPU B)
>>> --bond_3ad_state_machine_handler
>>>   --ad_agg_selection_logic
>>> 
>>> ad_work runs on cpu B. In the function ad_agg_selection_logic, all
>>> agg->is_active will be cleared. Before the new active aggregator is
>>> selected on CPU B, bond_3ad_get_active_agg_info failed on CPU A,
>>> bond->slave_arr will be set to NULL. The best aggregator in
>>> ad_agg_selection_logic has not changed, no need to update slave arr.
>>> 
>>> The conflict occurred in that ad_agg_selection_logic clears
>>> agg->is_active under mode_lock, but bond_open -> bond_update_slave_arr
>>> is inspecting agg->is_active outside the lock.
>>> 
>>> Also, bond_update_slave_arr is normal for potential sleep when
>>> allocating memory, so replace the WARN_ON with a call to might_sleep.
>>> 
>>> Signed-off-by: jinyiting <jinyiting@huawei.com>
>>> ---
>>> 
>>> Previous versions:
>>>  * https://lore.kernel.org/netdev/612b5e32-ea11-428e-0c17-e2977185f045@huawei.com/
>>> 
>>>  drivers/net/bonding/bond_main.c | 7 ++++---
>>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>> 
>>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>>> index 74cbbb2..83ef62d 100644
>>> --- a/drivers/net/bonding/bond_main.c
>>> +++ b/drivers/net/bonding/bond_main.c
>>> @@ -4406,7 +4404,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
>>>  	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
>>>  		struct ad_info ad_info;
>>>  
>>> +		spin_lock_bh(&bond->mode_lock);
>>
>>The code paths that call this function with mode_lock held will now deadlock.
> 
> 	No path should be calling bond_update_slave_arr with mode_lock
> already held (it expects RTNL only); did you find one?
> 
> 	My concern is that there's something else that does the opposite
> order, i.e., mode_lock first, then RTNL, but I haven't found an example.
> 

This patch is removing a lockdep assertion masking sure that mode_lock was held
when this function was called.  That should have been triggering all the time, right?

Thanks.
