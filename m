Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDAB2BA0B1
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 04:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgKTDAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 22:00:09 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8005 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgKTDAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 22:00:09 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cch9K3p0XzhcbH;
        Fri, 20 Nov 2020 10:59:49 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Nov 2020
 10:59:59 +0800
Subject: Re: [RFC net-next 1/2] ethtool: add support for controling the type
 of adaptive coalescing
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     Andrew Lunn <andrew@lunn.ch>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <kuba@kernel.org>
References: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
 <1605758050-21061-2-git-send-email-tanhuazhong@huawei.com>
 <20201119041557.GR1804098@lunn.ch>
 <e43890d1-5596-3439-f4a7-d704c069a035@huawei.com>
 <20201119220203.fv2uluoeekyoyxrv@lion.mk-sys.cz>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <8e9ba4c4-3ef4-f8bc-ab2f-92d695f62f12@huawei.com>
Date:   Fri, 20 Nov 2020 10:59:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201119220203.fv2uluoeekyoyxrv@lion.mk-sys.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/20 6:02, Michal Kubecek wrote:
> On Thu, Nov 19, 2020 at 04:56:42PM +0800, tanhuazhong wrote:
>> On 2020/11/19 12:15, Andrew Lunn wrote:
>>>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>>>> index 9ca87bc..afd8de2 100644
>>>> --- a/include/uapi/linux/ethtool.h
>>>> +++ b/include/uapi/linux/ethtool.h
>>>> @@ -433,6 +433,7 @@ struct ethtool_modinfo {
>>>>     *	a TX interrupt, when the packet rate is above @pkt_rate_high.
>>>>     * @rate_sample_interval: How often to do adaptive coalescing packet rate
>>>>     *	sampling, measured in seconds.  Must not be zero.
>>>> + * @use_dim: Use DIM for IRQ coalescing, if adaptive coalescing is enabled.
>>>>     *
>>>>     * Each pair of (usecs, max_frames) fields specifies that interrupts
>>>>     * should be coalesced until
>>>> @@ -483,6 +484,7 @@ struct ethtool_coalesce {
>>>>    	__u32	tx_coalesce_usecs_high;
>>>>    	__u32	tx_max_coalesced_frames_high;
>>>>    	__u32	rate_sample_interval;
>>>> +	__u32	use_dim;
>>>>    };
>>>
>>> You cannot do this.
>>>
>>> static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
>>>                                                      void __user *useraddr)
>>> {
>>>           struct ethtool_coalesce coalesce;
>>>           int ret;
>>>
>>>           if (!dev->ethtool_ops->set_coalesce)
>>>                   return -EOPNOTSUPP;
>>>
>>>           if (copy_from_user(&coalesce, useraddr, sizeof(coalesce)))
>>>                   return -EFAULT;
>>>
>>> An old ethtool binary is not going to set this extra last byte to
>>> anything meaningful. You cannot tell if you have an old or new user
>>> space, so you have no idea if it put anything into use_dim, or if it
>>> is random junk.
> 
> Even worse, as there is no indication of data length, ETHTOOL_GCOALESCE
> ioctl request from old ethtool on new kernel would result in kernel
> writing past the end of userspace buffer.
> 
>>> You have to leave the IOCTL interface unchanged, and limit this new
>>> feature to the netlink API.
>>>
>>
>> Hi, Andrew.
>> thanks for pointing out this problem, i will fix it.
>> without callling set_coalesce/set_coalesce of ethtool_ops, do you have any
>> suggestion for writing/reading this new attribute to/from the driver? add a
>> new field in net_device or a new callback function in ethtool_ops seems not
>> good.
> 
> We could use a similar approach as struct ethtool_link_ksettings, e.g.
> 
> 	struct kernel_ethtool_coalesce {
> 		struct ethtool_coalesce base;
> 		/* new members which are not part of UAPI */
> 	}
> 
> get_coalesce() and set_coalesce() would get pointer to struct
> kernel_ethtool_coalesce and ioctl code would be modified to only touch
> the base (legacy?) part.
>  > While already changing the ops arguments, we could also add extack
> pointer, either as a separate argument or as struct member (I slightly
> prefer the former).
> 


Hi, Michal.

If changing the ops arguments, each driver who implement 
set_coalesce/get_coalesce of ethtool_ops need to be updated. Is it 
acceptable adding two new ops to get/set ext_coalesce info (like 
ecc31c60240b ("ethtool: Add link extended state") does)? Maybe i can 
send V2 in this way, and then could you help to see which one is more 
suitable?


> BtW, please don't forget to update the message descriptions in
> Documentation/networking/ethtool-netlink.rst
> 
> Michal
> 
> .
> 

