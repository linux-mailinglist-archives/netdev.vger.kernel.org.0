Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD46658EE9C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 16:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiHJOlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 10:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiHJOlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 10:41:17 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A58C4F695
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 07:41:07 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M2syC3yTfzmVPP;
        Wed, 10 Aug 2022 22:38:59 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 10 Aug
 2022 22:41:03 +0800
Subject: Re: [RFCv7 PATCH net-next 23/36] net: adjust the build check for
 net_gso_ok()
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <20220810030624.34711-1-shenjian15@huawei.com>
 <20220810030624.34711-24-shenjian15@huawei.com>
 <20220810110917.1307697-1-alexandr.lobakin@intel.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <b0442451-f800-f09f-d767-c3ca6a49622f@huawei.com>
Date:   Wed, 10 Aug 2022 22:41:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220810110917.1307697-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/8/10 19:09, Alexander Lobakin 写道:
> From: Jian Shen <shenjian15@huawei.com>
> Date: Wed, 10 Aug 2022 11:06:11 +0800
>
>> Introduce macro GSO_INDEX(x) to replace the NETIF_F_XXX
>> feature shift check, for all the macroes NETIF_F_XXX will
>> be remove later.
>>
>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>> ---
>>   include/linux/netdevice.h | 40 ++++++++++++++++++++-------------------
>>   1 file changed, 21 insertions(+), 19 deletions(-)
>>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 1bd5dcbc884d..b01af2a3838d 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -4886,28 +4886,30 @@ netdev_features_t netif_skb_features(struct sk_buff *skb);
>>   
>>   static inline bool net_gso_ok(netdev_features_t features, int gso_type)
>>   {
>> +#define GSO_INDEX(x)	((1ULL << (x)) >> NETIF_F_GSO_SHIFT)
> What if we get a new GSO offload which's corresponding bit will be
> higher than 64?
> You could instead do
>
> #define __SKB_GSO_FLAG(x)	(1ULL << (x))
>
> enum {
> 	SKB_GSO_TCPV4_BIT	= 0,
> 	SKB_GSO_DODGY_BIT	= 1,
> 	...,
> };
> enum {
> 	SKB_GSO_TCPV4		= __SKB_GSO_FLAG(TCPV4),
> 	SKB_GSO_DODGY		= __SKB_GSO_FLAG(DODGY),
> 	...,
> };
>
> and then just
>
> #define ASSERT_GSO_TYPE(fl, feat)	\
> 	static_assert((fl) == (feat) - NETIF_F_GSO_SHIFT)
>
> 	...
> 	ASSERT_GSO_TYPE(SKB_GSO_TCPV4_BIT, NETIF_F_TSO_BIT);
> 	ASSERT_GSO_TYPE(SKB_GSO_DODGY, NETIF_F_GSO_ROBUST_BIT);
> 	...
Yes, it may be misused for new GSO offload bit higher than 64, the macro
__SKB_GSO_FLAG(x) is better.

>> +
>>   	netdev_features_t feature = (netdev_features_t)gso_type << NETIF_F_GSO_SHIFT;
>>   
>>   	/* check flags correspondence */
>> -	BUILD_BUG_ON(SKB_GSO_TCPV4   != (NETIF_F_TSO >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_DODGY   != (NETIF_F_GSO_ROBUST >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_TCP_ECN != (NETIF_F_TSO_ECN >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_TCP_FIXEDID != (NETIF_F_TSO_MANGLEID >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_TCPV6   != (NETIF_F_TSO6 >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_FCOE    != (NETIF_F_FSO >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_GRE     != (NETIF_F_GSO_GRE >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_GRE_CSUM != (NETIF_F_GSO_GRE_CSUM >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_IPXIP4  != (NETIF_F_GSO_IPXIP4 >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_IPXIP6  != (NETIF_F_GSO_IPXIP6 >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL != (NETIF_F_GSO_UDP_TUNNEL >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL_CSUM != (NETIF_F_GSO_UDP_TUNNEL_CSUM >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_PARTIAL != (NETIF_F_GSO_PARTIAL >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_TUNNEL_REMCSUM != (NETIF_F_GSO_TUNNEL_REMCSUM >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_SCTP    != (NETIF_F_GSO_SCTP >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_ESP != (NETIF_F_GSO_ESP >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_UDP != (NETIF_F_GSO_UDP >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_UDP_L4 != (NETIF_F_GSO_UDP_L4 >> NETIF_F_GSO_SHIFT));
>> -	BUILD_BUG_ON(SKB_GSO_FRAGLIST != (NETIF_F_GSO_FRAGLIST >> NETIF_F_GSO_SHIFT));
>> +	BUILD_BUG_ON(SKB_GSO_TCPV4   != GSO_INDEX(NETIF_F_TSO_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_DODGY   != GSO_INDEX(NETIF_F_GSO_ROBUST_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_TCP_ECN != GSO_INDEX(NETIF_F_TSO_ECN_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_TCP_FIXEDID != GSO_INDEX(NETIF_F_TSO_MANGLEID_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_TCPV6   != GSO_INDEX(NETIF_F_TSO6_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_FCOE    != GSO_INDEX(NETIF_F_FSO_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_GRE     != GSO_INDEX(NETIF_F_GSO_GRE_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_GRE_CSUM != GSO_INDEX(NETIF_F_GSO_GRE_CSUM_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_IPXIP4  != GSO_INDEX(NETIF_F_GSO_IPXIP4_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_IPXIP6  != GSO_INDEX(NETIF_F_GSO_IPXIP6_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL != GSO_INDEX(NETIF_F_GSO_UDP_TUNNEL_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL_CSUM != GSO_INDEX(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_PARTIAL != GSO_INDEX(NETIF_F_GSO_PARTIAL_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_TUNNEL_REMCSUM != GSO_INDEX(NETIF_F_GSO_TUNNEL_REMCSUM_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_SCTP    != GSO_INDEX(NETIF_F_GSO_SCTP_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_ESP != GSO_INDEX(NETIF_F_GSO_ESP_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_UDP != GSO_INDEX(NETIF_F_GSO_UDP_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_UDP_L4 != GSO_INDEX(NETIF_F_GSO_UDP_L4_BIT));
>> +	BUILD_BUG_ON(SKB_GSO_FRAGLIST != GSO_INDEX(NETIF_F_GSO_FRAGLIST_BIT));
>>   
>>   	return (features & feature) == feature;
>>   }
>> -- 
>> 2.33.0
> Thanks,
> Olek
> .
>

