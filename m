Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0802E4E8C6E
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 05:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbiC1DHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 23:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbiC1DHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 23:07:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A9550B10
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 20:05:30 -0700 (PDT)
Received: from kwepemi100012.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KRcvn2q5kzCrDl;
        Mon, 28 Mar 2022 11:03:17 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100012.china.huawei.com (7.221.188.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Mar 2022 11:05:28 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 28 Mar
 2022 11:05:27 +0800
Subject: Re: [RFCv2 PATCH net-next 1/2] net-next: ethtool: extend ringparam
 set/get APIs for tx_push
To:     Jakub Kicinski <kuba@kernel.org>
References: <20220326085102.14111-1-wangjie125@huawei.com>
 <20220326085102.14111-2-wangjie125@huawei.com>
 <20220326125042.216c9054@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
CC:     <mkubecek@suse.cz>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <3bc30bb8-f318-3e15-e61f-b430375b3739@huawei.com>
Date:   Mon, 28 Mar 2022 11:05:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220326125042.216c9054@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/3/27 3:50, Jakub Kicinski wrote:
> On Sat, 26 Mar 2022 16:51:01 +0800 Jie Wang wrote:
>> Currently tx push is a standard driver feature which controls use of a fast
>> path descriptor push. So this patch extends the ringparam APIs and data
>> structures to support set/get tx push by ethtool -G/g.
>>
>> Signed-off-by: Jie Wang <wangjie125@huawei.com>
>> ---
>>  include/linux/ethtool.h              | 3 +++
>>  include/uapi/linux/ethtool_netlink.h | 1 +
>>  net/ethtool/netlink.h                | 2 +-
>>  net/ethtool/rings.c                  | 9 +++++++--
>
> You need to add documentation in:
> Documentation/networking/ethtool-netlink.rst
>
OK, i will add it in next version RFC version.
>> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
>> index 4af58459a1e7..096771ee8586 100644
>> --- a/include/linux/ethtool.h
>> +++ b/include/linux/ethtool.h
>> @@ -72,11 +72,13 @@ enum {
>>   * @rx_buf_len: Current length of buffers on the rx ring.
>>   * @tcp_data_split: Scatter packet headers and data to separate buffers
>>   * @cqe_size: Size of TX/RX completion queue event
>> + * @tx_push: The flag of tx push mode
>>   */
>>  struct kernel_ethtool_ringparam {
>>  	u32	rx_buf_len;
>>  	u8	tcp_data_split;
>>  	u32	cqe_size;
>> +	u32	tx_push;
>
> Can we make this a u8 and move it up above cqe_size?
> u8 should be enough. You can use ethnl_update_u8().
>
yes, u8 is enough, next RFC version i will change it.
>>  };
>>
>>  /**
>> @@ -87,6 +89,7 @@ struct kernel_ethtool_ringparam {
>>  enum ethtool_supported_ring_param {
>>  	ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
>>  	ETHTOOL_RING_USE_CQE_SIZE   = BIT(1),
>> +	ETHTOOL_RING_USE_TX_PUSH    = BIT(2),
>
> You need to actually use this constant to reject the setting for
> drivers which don't support the feature.
>
I will use this constant next version.
>>  };
>>
>>  #define __ETH_RSS_HASH_BIT(bit)	((u32)1 << (bit))
>
>> @@ -94,7 +95,8 @@ static int rings_fill_reply(struct sk_buff *skb,
>>  	     (nla_put_u8(skb, ETHTOOL_A_RINGS_TCP_DATA_SPLIT,
>>  			 kr->tcp_data_split))) ||
>>  	    (kr->cqe_size &&
>> -	     (nla_put_u32(skb, ETHTOOL_A_RINGS_CQE_SIZE, kr->cqe_size))))
>> +	     (nla_put_u32(skb, ETHTOOL_A_RINGS_CQE_SIZE, kr->cqe_size))) ||
>> +	    nla_put_u8(skb, ETHTOOL_A_RINGS_TX_PUSH, !!kr->tx_push))
>>
>>  		return -EMSGSIZE;
>>
>>  	return 0;
>> @@ -123,6 +125,7 @@ const struct nla_policy ethnl_rings_set_policy[] = {
>>  	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_U32 },
>>  	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = NLA_POLICY_MIN(NLA_U32, 1),
>>  	[ETHTOOL_A_RINGS_CQE_SIZE]		= NLA_POLICY_MIN(NLA_U32, 1),
>> +	[ETHTOOL_A_RINGS_TX_PUSH]		= { .type = NLA_U8 },
>
> This can only be 0 and 1, right? Set a policy to to that effect please.
>
I will use NLA_POLICY_MAX(NLA_U8, 1), is this ok?
>>  };
>>
>>  int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
>> @@ -165,6 +168,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
>>  			 tb[ETHTOOL_A_RINGS_RX_BUF_LEN], &mod);
>>  	ethnl_update_u32(&kernel_ringparam.cqe_size,
>>  			 tb[ETHTOOL_A_RINGS_CQE_SIZE], &mod);
>> +	ethnl_update_bool32(&kernel_ringparam.tx_push,
>> +			    tb[ETHTOOL_A_RINGS_TX_PUSH], &mod);
>>  	ret = 0;
>>  	if (!mod)
>>  		goto out_ops;
>
>
> .
>

