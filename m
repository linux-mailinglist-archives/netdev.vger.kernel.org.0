Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37B536B5A9
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhDZPXa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Apr 2021 11:23:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55586 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbhDZPX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 11:23:29 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lb34L-0006HG-0u; Mon, 26 Apr 2021 15:22:41 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 9A1AF5FDD5; Mon, 26 Apr 2021 08:22:37 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 930239FC56;
        Mon, 26 Apr 2021 08:22:37 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     David Miller <davem@davemloft.net>
cc:     jinyiting@huawei.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, netdev@vger.kernel.org, security@kernel.org,
        linux-kernel@vger.kernel.org, xuhanbing@huawei.com,
        wangxiaogang3@huawei.com
Subject: Re: [PATCH] bonding: 3ad: Fix the conflict between bond_update_slave_arr and the state machine
In-reply-to: <20210423.130748.1071901004935481894.davem@davemloft.net>
References: <1618994301-1186-1-git-send-email-jinyiting@huawei.com> <20210423.130748.1071901004935481894.davem@davemloft.net>
Comments: In-reply-to David Miller <davem@davemloft.net>
   message dated "Fri, 23 Apr 2021 13:07:48 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date:   Mon, 26 Apr 2021 08:22:37 -0700
Message-ID: <20034.1619450557@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

>From: jinyiting <jinyiting@huawei.com>
>Date: Wed, 21 Apr 2021 16:38:21 +0800
>
>> The bond works in mode 4, and performs down/up operations on the bond
>> that is normally negotiated. The probability of bond-> slave_arr is NULL
>> 
>> Test commands:
>>    ifconfig bond1 down
>>    ifconfig bond1 up
>> 
>> The conflict occurs in the following process：
>> 
>> __dev_open (CPU A)
>> --bond_open
>>   --queue_delayed_work(bond->wq,&bond->ad_work,0);
>>   --bond_update_slave_arr
>>     --bond_3ad_get_active_agg_info
>> 
>> ad_work(CPU B)
>> --bond_3ad_state_machine_handler
>>   --ad_agg_selection_logic
>> 
>> ad_work runs on cpu B. In the function ad_agg_selection_logic, all
>> agg->is_active will be cleared. Before the new active aggregator is
>> selected on CPU B, bond_3ad_get_active_agg_info failed on CPU A,
>> bond->slave_arr will be set to NULL. The best aggregator in
>> ad_agg_selection_logic has not changed, no need to update slave arr.
>> 
>> The conflict occurred in that ad_agg_selection_logic clears
>> agg->is_active under mode_lock, but bond_open -> bond_update_slave_arr
>> is inspecting agg->is_active outside the lock.
>> 
>> Also, bond_update_slave_arr is normal for potential sleep when
>> allocating memory, so replace the WARN_ON with a call to might_sleep.
>> 
>> Signed-off-by: jinyiting <jinyiting@huawei.com>
>> ---
>> 
>> Previous versions:
>>  * https://lore.kernel.org/netdev/612b5e32-ea11-428e-0c17-e2977185f045@huawei.com/
>> 
>>  drivers/net/bonding/bond_main.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 74cbbb2..83ef62d 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -4406,7 +4404,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
>>  	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
>>  		struct ad_info ad_info;
>>  
>> +		spin_lock_bh(&bond->mode_lock);
>
>The code paths that call this function with mode_lock held will now deadlock.

	No path should be calling bond_update_slave_arr with mode_lock
already held (it expects RTNL only); did you find one?

	My concern is that there's something else that does the opposite
order, i.e., mode_lock first, then RTNL, but I haven't found an example.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
