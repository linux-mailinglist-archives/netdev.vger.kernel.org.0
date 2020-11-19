Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25E52B8E53
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 10:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgKSI4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:56:55 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7654 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgKSI4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:56:54 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CcD7S2nw0z15MgJ;
        Thu, 19 Nov 2020 16:56:36 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 19 Nov 2020
 16:56:42 +0800
Subject: Re: [RFC net-next 1/2] ethtool: add support for controling the type
 of adaptive coalescing
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <kuba@kernel.org>
References: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
 <1605758050-21061-2-git-send-email-tanhuazhong@huawei.com>
 <20201119041557.GR1804098@lunn.ch>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <e43890d1-5596-3439-f4a7-d704c069a035@huawei.com>
Date:   Thu, 19 Nov 2020 16:56:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201119041557.GR1804098@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/19 12:15, Andrew Lunn wrote:
>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>> index 9ca87bc..afd8de2 100644
>> --- a/include/uapi/linux/ethtool.h
>> +++ b/include/uapi/linux/ethtool.h
>> @@ -433,6 +433,7 @@ struct ethtool_modinfo {
>>    *	a TX interrupt, when the packet rate is above @pkt_rate_high.
>>    * @rate_sample_interval: How often to do adaptive coalescing packet rate
>>    *	sampling, measured in seconds.  Must not be zero.
>> + * @use_dim: Use DIM for IRQ coalescing, if adaptive coalescing is enabled.
>>    *
>>    * Each pair of (usecs, max_frames) fields specifies that interrupts
>>    * should be coalesced until
>> @@ -483,6 +484,7 @@ struct ethtool_coalesce {
>>   	__u32	tx_coalesce_usecs_high;
>>   	__u32	tx_max_coalesced_frames_high;
>>   	__u32	rate_sample_interval;
>> +	__u32	use_dim;
>>   };
> 
> You cannot do this.
> 
> static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
>                                                     void __user *useraddr)
> {
>          struct ethtool_coalesce coalesce;
>          int ret;
> 
>          if (!dev->ethtool_ops->set_coalesce)
>                  return -EOPNOTSUPP;
> 
>          if (copy_from_user(&coalesce, useraddr, sizeof(coalesce)))
>                  return -EFAULT;
> 
> An old ethtool binary is not going to set this extra last byte to
> anything meaningful. You cannot tell if you have an old or new user
> space, so you have no idea if it put anything into use_dim, or if it
> is random junk.
> 
> You have to leave the IOCTL interface unchanged, and limit this new
> feature to the netlink API.
> 

Hi, Andrew.
thanks for pointing out this problem, i will fix it.
without callling set_coalesce/set_coalesce of ethtool_ops, do you have 
any suggestion for writing/reading this new attribute to/from the 
driver? add a new field in net_device or a new callback function in 
ethtool_ops seems not good.

>> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
>> index e2bf36e..e3458d9 100644
>> --- a/include/uapi/linux/ethtool_netlink.h
>> +++ b/include/uapi/linux/ethtool_netlink.h
>> @@ -366,6 +366,7 @@ enum {
>>   	ETHTOOL_A_COALESCE_TX_USECS_HIGH,		/* u32 */
>>   	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,		/* u32 */
>>   	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
>> +	ETHTOOL_A_COALESCE_USE_DIM,			/* u8 */
> 
> This appears to be a boolean? So /* flag */ would be better. Or do you
> think there is scope for a few different algorithms, and an enum would
> be better. If so, you should add the enum with the two current
> options.
> 
> 	Andrew
> 

ok, boolean seems enough.

Thanks.
Huazhong.
> .
> 

