Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD90D5033EB
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiDPDgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 23:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiDPDgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 23:36:31 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617CB50E01
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 20:34:00 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KgJhN6sRbzYXF5;
        Sat, 16 Apr 2022 11:33:56 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 16 Apr
 2022 11:33:58 +0800
Subject: Re: [RFCv5 PATCH net-next 02/20] net: introduce operation helpers for
 netdev features
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, <lipeng321@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
 <20220324154932.17557-3-shenjian15@huawei.com>
 <20220324180931.7e6e5188@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <752c07fc-2417-1685-5950-8d8770b9f048@huawei.com>
Date:   Sat, 16 Apr 2022 11:33:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220324180931.7e6e5188@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/3/25 9:09, Jakub Kicinski 写道:
> On Thu, 24 Mar 2022 23:49:14 +0800 Jian Shen wrote:
>> Introduce a set of bitmap operation helpers for netdev features,
>> then we can use them to replace the logical operation with them.
>> As the nic driversare not supposed to modify netdev_features
>> directly, it also introduces wrappers helpers to this.
>>
>> The implementation of these helpers are based on the old prototype
>> of netdev_features_t is still u64. I will rewrite them on the last
>> patch, when the prototype changes.
>>
>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>> ---
>>   include/linux/netdevice.h | 597 ++++++++++++++++++++++++++++++++++++++
> Please move these helpers to a new header file which won't be included
> by netdevice.h and include it at users appropriately.
I introduced a new header file "netdev_features_helper",  and moved 
thses helpers
to it.  Some helpers need to include struct  net_device which defined in 
netdevice.h,
but there are also some inline functions in netdevice.h need to use 
these netdev_features
helpers. It's conflicted.

So far I thought 3 ways to solved it, but all of them are not satisfactory.
1) Split netdevice.h, move the definition of struct net_device and its 
relative definitions to
a new header file A( haven't got a reasonable name).  Both the 
netdev_features_helper.h
and the netdevice include A.

2) Split netdevice.h, move the inline functions to a new header file B. 
The netdev_features_helper.h
inlucde netdevice.h， and B include netdev_features_helper.h and 
netdevice.h. All the source files
which using these ininline functions should include B.

3) Split netdevice.h, move the inline functions to to 
netdev_featurer_helper.h. The netdev_features_helper.h
inlucde netdevice.h, All the source files which using these ininline 
functions should include netde_features_helper.h.

I'd like to get more advice to this.

Thanks!
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 7307b9553bcf..0af4b26896d6 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -2295,6 +2295,603 @@ struct net_device {
>>   };
>>   #define to_net_dev(d) container_of(d, struct net_device, dev)
>>   
>> +static inline void netdev_features_zero(netdev_features_t *dst)
>> +{
>> +	*dst = 0;
>> +}
>> +
>> +static inline void netdev_features_fill(netdev_features_t *dst)
>> +{
>> +	*dst = ~0ULL;
>> +}
>> +
>> +static inline bool netdev_features_empty(const netdev_features_t src)
> Don't pass by value something larger than 64 bit.
>
>> +{
>> +	return src == 0;
>> +}
>> +
>> +/* helpers for netdev features '==' operation */
>> +static inline bool netdev_features_equal(const netdev_features_t src1,
>> +					 const netdev_features_t src2)
>> +{
>> +	return src1 == src2;
>> +}
>> +/* helpers for netdev features '&=' operation */
>> +static inline void
>> +netdev_features_direct_and(netdev_features_t *dst,
>> +			   const netdev_features_t features)
>> +{
>> +	*dst = netdev_features_and(*dst, features);
>> +}
>> +
>> +static inline void
>> +netdev_active_features_direct_and(struct net_device *ndev,
> s/direct_and/mask/ ?
>
>> +				  const netdev_features_t features)
>> +{
>> +	ndev->active_features = netdev_active_features_and(ndev, features);
>> +}
>> +
>> +/* helpers for netdev features '|' operation */
>> +static inline netdev_features_t
>> +netdev_features_or(const netdev_features_t a, const netdev_features_t b)
>> +{
>> +	return a | b;
>> +}
>> +/* helpers for netdev features '|=' operation */
>> +static inline void
>> +netdev_features_direct_or(netdev_features_t *dst,
> s/direct_or/set/ ?
>
>> +			  const netdev_features_t features)
>> +{
>> +	*dst = netdev_features_or(*dst, features);
>> +}
>> +/* helpers for netdev features '^' operation */
>> +static inline netdev_features_t
>> +netdev_features_xor(const netdev_features_t a, const netdev_features_t b)
>> +{
>> +	return a ^ b;
>> +}
>> +/* helpers for netdev features '^=' operation */
>> +static inline void
>> +netdev_active_features_direct_xor(struct net_device *ndev,
> s/direct_xor/toggle/ ?
>
>> +/* helpers for netdev features '& ~' operation */
>> +static inline netdev_features_t
>> +netdev_features_andnot(const netdev_features_t a, const netdev_features_t b)
>> +{
>> +	return a & ~b;
>> +}
>> +static inline void
>> +netdev_features_direct_andnot(netdev_features_t *dst,
> s/andnot/clear/ ?
>
>> +			     const netdev_features_t features)
>> +{
>> +	*dst = netdev_features_andnot(*dst, features);
>> +}
>> +/* helpers for netdev features 'set bit' operation */
>> +static inline void netdev_features_set_bit(int nr, netdev_features_t *src)
> s/features_set_bit/feature_add/ ?
>
>> +{
>> +	*src |= __NETIF_F_BIT(nr);
>> +}
>> +/* helpers for netdev features 'set bit array' operation */
>> +static inline void netdev_features_set_array(const int *array, int array_size,
>> +					     netdev_features_t *dst)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < array_size; i++)
>> +		netdev_features_set_bit(array[i], dst);
>> +}
>> +
>> +#define netdev_active_features_set_array(ndev, array, array_size) \
>> +		netdev_features_set_array(array, array_size, &ndev->active_features)
>> +
>> +#define netdev_hw_features_set_array(ndev, array, array_size) \
>> +		netdev_features_set_array(array, array_size, &ndev->hw_features)
>> +
>> +#define netdev_wanted_features_set_array(ndev, array, array_size) \
>> +		netdev_features_set_array(array, array_size, &ndev->wanted_features)
>> +
>> +#define netdev_vlan_features_set_array(ndev, array, array_size) \
>> +		netdev_features_set_array(array, array_size, &ndev->vlan_features)
>> +
>> +#define netdev_hw_enc_features_set_array(ndev, array, array_size) \
>> +		netdev_features_set_array(array, array_size, &ndev->hw_enc_features)
>> +
>> +#define netdev_mpls_features_set_array(ndev, array, array_size) \
>> +		netdev_features_set_array(array, array_size, &ndev->mpls_features)
>> +
>> +#define netdev_gso_partial_features_set_array(ndev, array, array_size) \
>> +		netdev_features_set_array(array, array_size, &ndev->gso_partial_features)
>> +
>> +/* helpers for netdev features 'clear bit' operation */
>> +static inline void netdev_features_clear_bit(int nr, netdev_features_t *src)
> All the mentions of '_bit' are unnecessary IMHO.
> .
>

