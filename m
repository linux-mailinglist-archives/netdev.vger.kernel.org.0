Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA024415DF
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 10:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhKAJNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 05:13:41 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:30889 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbhKAJNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 05:13:41 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HjRwZ1rtpzcZyr;
        Mon,  1 Nov 2021 17:06:22 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 1 Nov 2021 17:11:05 +0800
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Mon, 1 Nov
 2021 17:11:04 +0800
Subject: Re: [RFCv3 PATCH net-next] net: extend netdev_features_t
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <20211101010535.32575-1-shenjian15@huawei.com>
 <YX9RCqTOAHtiGD3n@lunn.ch>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <0c45431b-ad76-87c6-c498-f19584ae6840@huawei.com>
Date:   Mon, 1 Nov 2021 17:11:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <YX9RCqTOAHtiGD3n@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

     Thanks for your comments!


在 2021/11/1 10:29, Andrew Lunn 写道:
>> +#define HNS3_DEFAULT_ACTIVE_FEATURES   \
>> +	(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX |  \
>> +	NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_RXCSUM | NETIF_F_SG |  \
>> +	NETIF_F_GSO | NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | \
>> +	NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM | NETIF_F_SCTP_CRC \
>> +	NETIF_F_GSO_UDP_TUNNEL | NETIF_F_FRAGLIST)
> This is a problem, it only works for the existing 64 bit values, but
> not for the values added afterwards. I would suggest you change this
> into an array of u8 bit values. That scales to 256 feature flags. And
> when that overflows, we can change from an array of u8 to u16, without
> any major API changes.
OK, I will change it like features_init() in drivers/net/phy/phy_device.c

I used this at fist until I add helpers for handling existing 64 bits.

>>   static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
>> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
>> index 16f778887e14..9b3ab11e19c8 100644
>> --- a/include/linux/netdev_features.h
>> +++ b/include/linux/netdev_features.h
>> @@ -101,12 +101,12 @@ enum {
>>   
>>   typedef struct {
>>   	DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
>> -} netdev_features_t;
>> +} netdev_features_t;
> That hunk looks odd.
Yes, but it can be return directly, so we don't have to change
the prototype of functions which return netdev_features_t,
like  ndo_features_check.

>>   
>>   #define NETDEV_FEATURE_DWORDS	DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 64)
>>   
>>   /* copy'n'paste compression ;) */
>> -#define __NETIF_F_BIT(bit)	((netdev_features_t)1 << (bit))
>> +#define __NETIF_F_BIT(bit)	((u64)1 << (bit))
> You need to get away from this representation. It does not scale.
>
> At the end of this conversion, either all NETIF_F_* macros need to be
> gone, or they need to be aliases for NETIF_F_*_BIT.

I kept them for I use helpers for handling existing 64 bit.


>> -static inline void netdev_feature_zero(netdev_features_t *dst)
>> +static inline void netdev_features_zero(netdev_features_t *dst)
>>   {
>>   	bitmap_zero(dst->bits, NETDEV_FEATURE_COUNT);
>>   }
>>   
>> -static inline void netdev_feature_fill(netdev_features_t *dst)
>> +static inline void netdev_features_fill(netdev_features_t *dst)
>>   {
>>   	bitmap_fill(dst->bits, NETDEV_FEATURE_COUNT);
>>   }
> I'm wondering that the value here is? What do we gain by added the s.
> These changes cause a lot of churn in the users of these functions.
This function is used to expression like below:

"lowerdev_features &= (features | ~NETIF_F_LRO);"  in drivers/net/macvlan.c


>>   
>> -static inline void netdev_feature_and(netdev_features_t *dst,
>> -				      const netdev_features_t a,
>> -				      const netdev_features_t b)
>> +static inline netdev_features_t netdev_features_and(netdev_features_t a,
>> +						    netdev_features_t b)
>>   {
>> -	bitmap_and(dst->bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
>> +	netdev_features_t dst;
>> +
>> +	bitmap_and(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
>> +	return dst;
>>   }
> The implementation needs to change, but do we need to change the
> function signature? Why remove dst as a parameter?
>
> It can be good to deliberately break the API so the compiler tells us
> when we fail to update something. But do we actually need that here?
> The API is nicely abstract, so i don't think a breaking change is
> required.

Yes, not quite necessary. The original motivation is "netdev_features_t"
can be return directly, and more  close to "A = B & C".
I will change it to keep the style as bitmap_and.

>> +/* only be used for the first 64 bits features */
>> +static inline void netdev_features_set_bits(u64 bits, netdev_features_t *src)
> Do we really want this special feature which only works for some
> values? Does it clearly explode at compile time when used for bits
> above 64?
These special helpers for existing 64 bits are defined to reduce the work
of defining features groups, and peoples may get used to for using
featureA |  featureB | featureC.

The main problem  is the compiler can't report error when mistake passing
NETIF_F_XXX_BIT to   netdev_features_set_bits.

So the solution is removing these helpers and the NETIF_F_XXX macroes ?

>>   {
>> -	return (addr & __NETIF_F_BIT(nr)) > 0;
>> +	netdev_features_t tmp;
>> +
>> +	bitmap_from_u64(tmp.bits, bits);
>> +	*src = netdev_features_or(*src, tmp);
>>   }
>> +static inline void netdev_set_active_features(struct net_device *netdev,
>> +					      netdev_features_t src)
>> +{
>> +	netdev->features = src;
>> +}
> _active_ is new here?
_active is used to differentiate "netdev_active_features_xxx" with 
"netdev_features_xxx"


>> +static inline void netdev_set_hw_features(struct net_device *netdev,
>> +					  netdev_features_t src)
>> +{
>> +	netdev->hw_features = src;
>> +}
> Here _hw_ makes sense. But i think we need some sort of
> consistency. Either drop the _active_ from the function name, or
> rename the netdev field active_features.
>
>         Andrew
> .
  I prefered to rename the netdev field active_features .


Jian
>

