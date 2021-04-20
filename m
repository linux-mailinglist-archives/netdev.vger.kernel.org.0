Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E33B3650D3
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhDTDXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:23:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16140 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhDTDXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 23:23:20 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FPTSh5TwJzmdTc;
        Tue, 20 Apr 2021 11:19:48 +0800 (CST)
Received: from [10.174.177.26] (10.174.177.26) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 20 Apr 2021 11:22:41 +0800
Subject: Re: [PATCH] bonding: 3ad: update slave arr after initialize
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     <vfalico@gmail.com>, <andy@greyhouse.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>, <security@kernel.org>,
        <linux-kernel@vger.kernel.org>, <xuhanbing@huawei.com>,
        <wangxiaogang3@huawei.com>
References: <1618537982-454-1-git-send-email-jinyiting@huawei.com>
 <17733.1618547307@famine>
From:   jin yiting <jinyiting@huawei.com>
Message-ID: <1165c45f-ae7f-48c1-5c65-a879c7bf978a@huawei.com>
Date:   Tue, 20 Apr 2021 11:22:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <17733.1618547307@famine>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.26]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/4/16 12:28, Jay Vosburgh 写道:
> jinyiting <jinyiting@huawei.com> wrote:
> 
>> From: jin yiting <jinyiting@huawei.com>
>>
>> The bond works in mode 4, and performs down/up operations on the bond
>> that is normally negotiated. The probability of bond-> slave_arr is NULL
>>
>> Test commands:
>>     ifconfig bond1 down
>>     ifconfig bond1 up
>>
>> The conflict occurs in the following process：
>>
>> __dev_open (CPU A)
>> --bond_open
>>    --queue_delayed_work(bond->wq,&bond->ad_work,0);
>>    --bond_update_slave_arr
>>      --bond_3ad_get_active_agg_info
>>
>> ad_work(CPU B)
>> --bond_3ad_state_machine_handler
>>    --ad_agg_selection_logic
>>
>> ad_work runs on cpu B. In the function ad_agg_selection_logic, all
>> agg->is_active will be cleared. Before the new active aggregator is
>> selected on CPU B, bond_3ad_get_active_agg_info failed on CPU A,
>> bond->slave_arr will be set to NULL. The best aggregator in
>> ad_agg_selection_logic has not changed, no need to update slave arr.
>>
>> Signed-off-by: jin yiting <jinyiting@huawei.com>
>> ---
>> drivers/net/bonding/bond_3ad.c | 6 ++++++
>> 1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
>> index 6908822..d100079 100644
>> --- a/drivers/net/bonding/bond_3ad.c
>> +++ b/drivers/net/bonding/bond_3ad.c
>> @@ -2327,6 +2327,12 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
>>
>> 			aggregator = __get_first_agg(port);
>> 			ad_agg_selection_logic(aggregator, &update_slave_arr);
>> +			if (!update_slave_arr) {
>> +				struct aggregator *active = __get_active_agg(aggregator);
>> +
>> +				if (active && active->is_active)
>> +					update_slave_arr = true;
>> +			}
>> 		}
>> 		bond_3ad_set_carrier(bond);
>> 	}
> 
> 	The described issue is a race condition (in that
> ad_agg_selection_logic clears agg->is_active under mode_lock, but
> bond_open -> bond_update_slave_arr is inspecting agg->is_active outside
> the lock).  I don't see how the above change will reliably manage this;
> the real issue looks to be that bond_update_slave_arr is committing
> changes to the array (via bond_reset_slave_arr) based on a racy
> inspection of the active aggregator state while it is in flux.
> 
> 	Also, the description of the issue says "The best aggregator in
> ad_agg_selection_logic has not changed, no need to update slave arr,"
> but the change above does the opposite, and will set update_slave_arr
> when the aggregator has not changed (update_slave_arr remains false at
> return of ad_agg_selection_logic).
> 
> 	I believe I understand the described problem, but I don't see
> how the patch fixes it.  I suspect (but haven't tested) that the proper
> fix is to acquire mode_lock in bond_update_slave_arr while calling
> bond_3ad_get_active_agg_info to avoid conflict with the state machine.
> 
> 	-J
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
> .
> 

	Thank you for your reply. The last patch does have redundant update 
slave arr.Thank you for your correction.

         As you said, holding mode_lock in bond_update_slave_arr while 
calling bond_3ad_get_active_agg_info can avoid conflictwith the state 
machine. I have tested this patch, with ifdown/ifup operations for bond 
or slaves.

         But bond_update_slave_arr is expected to hold RTNL only and NO 
other lock. And it have WARN_ON(lockdep_is_held(&bond->mode_lock)); in 
bond_update_slave_arr. I'm not sure that holding mode_lock in 
bond_update_slave_arr while calling bond_3ad_get_active_agg_info is a 
correct action.


diff --git a/drivers/net/bonding/bond_main.c 
b/drivers/net/bonding/bond_main.c
index 74cbbb2..db988e5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4406,7 +4406,9 @@ int bond_update_slave_arr(struct bonding *bond, 
struct slave *skipslave)
     if (BOND_MODE(bond) == BOND_MODE_8023AD) {
         struct ad_info ad_info;

+       spin_lock_bh(&bond->mode_lock);
         if (bond_3ad_get_active_agg_info(bond, &ad_info)) {
+           spin_unlock_bh(&bond->mode_lock);
             pr_debug("bond_3ad_get_active_agg_info failed\n");
             /* No active aggragator means it's not safe to use
              * the previous array.
@@ -4414,6 +4416,7 @@ int bond_update_slave_arr(struct bonding *bond, 
struct slave *skipslave)
             bond_reset_slave_arr(bond);
             goto out;
         }
+       spin_unlock_bh(&bond->mode_lock);
         agg_id = ad_info.aggregator_id;
     }
     bond_for_each_slave(bond, slave, iter) {














