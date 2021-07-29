Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C8B3D9BD3
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 04:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhG2Ccu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 22:32:50 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12420 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhG2Cct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 22:32:49 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GZvcD4Vrvzcjlt;
        Thu, 29 Jul 2021 10:29:16 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 10:32:41 +0800
Received: from [10.67.103.6] (10.67.103.6) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 29 Jul
 2021 10:32:41 +0800
Subject: Re: [PATCH net-next] bonding: 3ad: fix the concurrency between
 __bond_release_one() and bond_3ad_state_machine_handler()
To:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <1627453192-54463-1-git-send-email-moyufeng@huawei.com>
 <47d9f710-59f7-0ccc-d41b-ee7ee0f69017@nvidia.com> <3528.1627499144@famine>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, <shenjian15@huawei.com>,
        <lipeng321@huawei.com>, <yisen.zhuang@huawei.com>,
        <linyunsheng@huawei.com>, <zhangjiaran@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>,
        <salil.mehta@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
From:   moyufeng <moyufeng@huawei.com>
Message-ID: <bca516cf-1174-22c9-215f-4463713edd52@huawei.com>
Date:   Thu, 29 Jul 2021 10:32:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <3528.1627499144@famine>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/7/29 3:05, Jay Vosburgh wrote:
> Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
> 
>> On 28/07/2021 09:19, Yufeng Mo wrote:
>>> Some time ago, I reported a calltrace issue
>>> "did not find a suitable aggregator", please see[1].
>>> After a period of analysis and reproduction, I find
>>> that this problem is caused by concurrency.
>>>
>>> Before the problem occurs, the bond structure is like follows:
>>>
>>> bond0 - slaver0(eth0) - agg0.lag_ports -> port0 - port1
>>>                       \
>>>                         port0
>>>       \
>>>         slaver1(eth1) - agg1.lag_ports -> NULL
>>>                       \
>>>                         port1
>>>
>>> If we run 'ifenslave bond0 -d eth1', the process is like below:
>>>
>>> excuting __bond_release_one()
>>> |
>>> bond_upper_dev_unlink()[step1]
>>> |                       |                       |
>>> |                       |                       bond_3ad_lacpdu_recv()
>>> |                       |                       ->bond_3ad_rx_indication()
>>> |                       |                       spin_lock_bh()
>>> |                       |                       ->ad_rx_machine()
>>> |                       |                       ->__record_pdu()[step2]
>>> |                       |                       spin_unlock_bh()
>>> |                       |                       |
>>> |                       bond_3ad_state_machine_handler()
>>> |                       spin_lock_bh()
>>> |                       ->ad_port_selection_logic()
>>> |                       ->try to find free aggregator[step3]
>>> |                       ->try to find suitable aggregator[step4]
>>> |                       ->did not find a suitable aggregator[step5]
>>> |                       spin_unlock_bh()
>>> |                       |
>>> |                       |
>>> bond_3ad_unbind_slave() |
>>> spin_lock_bh()
>>> spin_unlock_bh()
>>>
>>> step1: already removed slaver1(eth1) from list, but port1 remains
>>> step2: receive a lacpdu and update port0
>>> step3: port0 will be removed from agg0.lag_ports. The struct is
>>>        "agg0.lag_ports -> port1" now, and agg0 is not free. At the
>>> 	   same time, slaver1/agg1 has been removed from the list by step1.
>>> 	   So we can't find a free aggregator now.
>>> step4: can't find suitable aggregator because of step2
>>> step5: cause a calltrace since port->aggregator is NULL
>>>
>>> To solve this concurrency problem, the range of bond->mode_lock
>>> is extended from only bond_3ad_unbind_slave() to both
>>> bond_upper_dev_unlink() and bond_3ad_unbind_slave().
>>>
>>> [1]https://lore.kernel.org/netdev/10374.1611947473@famine/
>>>
>>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>>> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>>> ---
>>>  drivers/net/bonding/bond_3ad.c  | 7 +------
>>>  drivers/net/bonding/bond_main.c | 6 +++++-
>>>  2 files changed, 6 insertions(+), 7 deletions(-)
>>>
>> [snip]
>>>  /**
>>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>>> index 0ff7567..deb019e 100644
>>> --- a/drivers/net/bonding/bond_main.c
>>> +++ b/drivers/net/bonding/bond_main.c
>>> @@ -2129,14 +2129,18 @@ static int __bond_release_one(struct net_device *bond_dev,
>>>  	/* recompute stats just before removing the slave */
>>>  	bond_get_stats(bond->dev, &bond->bond_stats);
>>>  
>>> -	bond_upper_dev_unlink(bond, slave);
>>>  	/* unregister rx_handler early so bond_handle_frame wouldn't be called
>>>  	 * for this slave anymore.
>>>  	 */
>>>  	netdev_rx_handler_unregister(slave_dev);
>>>  
>>> +	/* Sync against bond_3ad_state_machine_handler() */
>>> +	spin_lock_bh(&bond->mode_lock);
>>> +	bond_upper_dev_unlink(bond, slave);
>>
>> this calls netdev_upper_dev_unlink() which calls call_netdevice_notifiers_info() for
>> NETDEV_PRECHANGEUPPER and NETDEV_CHANGEUPPER, both of which are allowed to sleep so you
>> cannot hold the mode lock
> 
> 	Indeed it does, I missed that the callbacks can sleep.
> 

Yes, I missed that too.

>> after netdev_rx_handler_unregister() the bond's recv_probe cannot be executed
>> so you don't really need to unlink it under mode_lock or move mode_lock at all
> 
> 	I don't think moving the call to netdev_rx_handler_unregister is
> sufficient to close the race.  If it's moved above the call to
> bond_upper_dev_unlink, the probe won't be called afterwards, but the
> LACPDU could have arrived just prior to the unregister and changed the
> port state in the bond_3ad_lacpdu_recv call sequence ("step 2",
> something in the LACPDU causes AD_PORT_SELECTED to be cleared).  Later,
> bond_3ad_state_machine_handler runs in a separate work queue context,
> and could process the effect of the LACPDU after the rx_handler
> unregister, and still race with the upper_dev_unlink.
> 
> 	I suspect the solution is to rework ad_port_selection_logic to
> correctly handle the situation where no aggregator is available.  Off
> the top of my head, I think something along the lines of:
> 
> diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
> index 6908822d9773..eb6223e4510e 100644
> --- a/drivers/net/bonding/bond_3ad.c
> +++ b/drivers/net/bonding/bond_3ad.c
> @@ -1537,6 +1537,10 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
>  			slave_err(bond->dev, port->slave->dev,
>  				  "Port %d did not find a suitable aggregator\n",
>  				  port->actor_port_number);
> +			aggregator = __get_first_agg(port);
> +			ad_agg_selection_logic(aggregator, update_slave_arr);
> +
> +			return;
>  		}
>  	}
>  	/* if all aggregator's ports are READY_N == TRUE, set ready=TRUE
> 
> 	I've not compiled or tested this, but the theory is that it will
> reselect a new aggregator for the bond (which happens anyway later in
> the function), then returns, leaving "port" as not AD_PORT_SELECTED.
> The next run of the state machine should attempt to select it again, and
> presumably succeed at that time.
> 
> 	This may leave the bond with no active ports for one interval
> between runs of the state machine, unfortunately, but it should
> eliminate the panic.
> 
> 	Another possibility might be netdev_rx_handler_unregister, then
> , and finally bond_upper_dev_unlink, but I'm not
> sure right off if that would have other side effects.
> 

This may cause "%s: Warning: Found an uninitialized port\n" to be
printed in bond_3ad_state_machine_handler(). But it doesn't matter.

In addition, I have analyzed the code in bond_3ad_unbind_slave().
Even if the slaver is not deleted from the list, the process is
not affected. This seems to work. Anyway, I will test it.

> 	Yufeng, would you be able to test the above and see if it
> resolves the issue in your test?
> 

Sure，I will test both these two solution and report then.

Thanks Nikolay and Jay for the comments.

> 	-J
> 
> 
>>>  	if (BOND_MODE(bond) == BOND_MODE_8023AD)
>>>  		bond_3ad_unbind_slave(slave);
>>> +	spin_unlock_bh(&bond->mode_lock);
>>>  
>>>  	if (bond_mode_can_use_xmit_hash(bond))
>>>  		bond_update_slave_arr(bond, slave);
>>>
>>
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
> .
> 
