Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2213D87C0
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 08:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhG1GQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 02:16:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12414 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbhG1GQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 02:16:13 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GZNcS4qD6zcjfD;
        Wed, 28 Jul 2021 14:12:40 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 14:16:08 +0800
Received: from [10.67.103.6] (10.67.103.6) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 28 Jul
 2021 14:16:08 +0800
Subject: Re: [PATCH RFC net-next] bonding: 3ad: fix the conflict between
 __bond_release_one and bond_3ad_state_machine_handler
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
References: <1627025171-18480-1-git-send-email-moyufeng@huawei.com>
 <10703.1627449228@famine>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, <shenjian15@huawei.com>,
        <lipeng321@huawei.com>, <yisen.zhuang@huawei.com>,
        <linyunsheng@huawei.com>, <zhangjiaran@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>,
        <salil.mehta@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
From:   moyufeng <moyufeng@huawei.com>
Message-ID: <758d4a2d-2e35-6fd3-4c61-60ca871545df@huawei.com>
Date:   Wed, 28 Jul 2021 14:16:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <10703.1627449228@famine>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/7/28 13:13, Jay Vosburgh wrote:
> Yufeng Mo <moyufeng@huawei.com> wrote:
> 
>> Some time ago, I reported a calltrace issue
>> "did not find a suitable aggregator", please see[1].
>> After a period of analysis and reproduction, I find
>> that this problem is caused by concurrency.
>>
>> Before the problem occurs, the bond structure is like follows:
>>
>> bond0 - slaver0(eth0) - agg0.lag_ports -> port0 - port1
>>                      \
>>                        port0
>>      \
>>        slaver1(eth1) - agg1.lag_ports -> NULL
>>                      \
>>                        port1
>>
>> If we run 'ifenslave bond0 -d eth1', the process is like below:
>>
>> excuting __bond_release_one()
>> |
>> bond_upper_dev_unlink()[step1]
>> |                       |                       |
>> |                       |                       bond_3ad_lacpdu_recv()
>> |                       |                       ->bond_3ad_rx_indication()
>> |                       |                       ->ad_rx_machine()
>> |                       |                       ->__record_pdu()[step2]
>> |                       |                       |
>> |                       bond_3ad_state_machine_handler()
>> |                       ->ad_port_selection_logic()
>> |                       ->try to find free aggregator[step3]
>> |                       ->try to find suitable aggregator[step4]
>> |                       ->did not find a suitable aggregator[step5]
>> |                       |
>> |                       |
>> bond_3ad_unbind_slave() |
>>
>> step1: already removed slaver1(eth1) from list, but port1 remains
>> step2: receive a lacpdu and update port0
>> step3: port0 will be removed from agg0.lag_ports. The struct is
>>       "agg0.lag_ports -> port1" now, and agg0 is not free. At the
>>       same time, slaver1/agg1 has been removed from the list by step1.
>>       So we can't find a free aggregator now.
>> step4: can't find suitable aggregator because of step2
>> step5: cause a calltrace since port->aggregator is NULL
>>
>> To solve this concurrency problem, the range of bond->mode_lock
>> is extended from only bond_3ad_unbind_slave() to both
>> bond_upper_dev_unlink() and bond_3ad_unbind_slave().
>>
>> [1]https://lore.kernel.org/netdev/10374.1611947473@famine/
>>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> 
> 	This looks good to me, and explains the previously reported
> issue.  If Jakub or Davem are comfortable applying this even though it
> was posted as RFC (it applies cleanly to today's net-next, although I
> did not build it) I'm fine with that; otherwise, please repost and
> include:
> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> 
> 	-J
> 
> 
Thanks for your review. I found a lock-up issue with this RFC in testing.
This is because I also put netdev_rx_handler_unregister() inside spin_lock().
I will fix it and then repost an official version.

Thanks

>> ---
>> drivers/net/bonding/bond_3ad.c  | 7 +------
>> drivers/net/bonding/bond_main.c | 3 +++
>> 2 files changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
>> index 6908822..f0f5adb 100644
>> --- a/drivers/net/bonding/bond_3ad.c
>> +++ b/drivers/net/bonding/bond_3ad.c
>> @@ -2099,15 +2099,13 @@ void bond_3ad_unbind_slave(struct slave *slave)
>> 	struct list_head *iter;
>> 	bool dummy_slave_update; /* Ignore this value as caller updates array */
>>
>> -	/* Sync against bond_3ad_state_machine_handler() */
>> -	spin_lock_bh(&bond->mode_lock);
>> 	aggregator = &(SLAVE_AD_INFO(slave)->aggregator);
>> 	port = &(SLAVE_AD_INFO(slave)->port);
>>
>> 	/* if slave is null, the whole port is not initialized */
>> 	if (!port->slave) {
>> 		slave_warn(bond->dev, slave->dev, "Trying to unbind an uninitialized port\n");
>> -		goto out;
>> +		return;
>> 	}
>>
>> 	slave_dbg(bond->dev, slave->dev, "Unbinding Link Aggregation Group %d\n",
>> @@ -2239,9 +2237,6 @@ void bond_3ad_unbind_slave(struct slave *slave)
>> 		}
>> 	}
>> 	port->slave = NULL;
>> -
>> -out:
>> -	spin_unlock_bh(&bond->mode_lock);
>> }
>>
>> /**
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 0ff7567..00a501c 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -2129,6 +2129,8 @@ static int __bond_release_one(struct net_device *bond_dev,
>> 	/* recompute stats just before removing the slave */
>> 	bond_get_stats(bond->dev, &bond->bond_stats);
>>
>> +	/* Sync against bond_3ad_state_machine_handler() */
>> +	spin_lock_bh(&bond->mode_lock);
>> 	bond_upper_dev_unlink(bond, slave);
>> 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
>> 	 * for this slave anymore.
>> @@ -2137,6 +2139,7 @@ static int __bond_release_one(struct net_device *bond_dev,
>>
>> 	if (BOND_MODE(bond) == BOND_MODE_8023AD)
>> 		bond_3ad_unbind_slave(slave);
>> +	spin_unlock_bh(&bond->mode_lock);
>>
>> 	if (bond_mode_can_use_xmit_hash(bond))
>> 		bond_update_slave_arr(bond, slave);
>> -- 
>> 2.8.1
>>
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
> .
> 
