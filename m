Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4AA6EAB1F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 14:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjDUM6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 08:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbjDUM6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 08:58:04 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D22D310
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 05:57:37 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q2vG52zS9zcd6j;
        Fri, 21 Apr 2023 20:38:37 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 21 Apr
 2023 20:40:10 +0800
Subject: Re: [PATCH net-next v3 1/5] net: wangxun: libwx add tx offload
 functions
To:     Mengyuan Lou <mengyuanlou@net-swift.com>, <netdev@vger.kernel.org>
CC:     <jiawenwu@trustnetic.com>
References: <20230420103742.43168-1-mengyuanlou@net-swift.com>
 <20230420103742.43168-2-mengyuanlou@net-swift.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c4b9765d-7213-2718-5de3-5e8231753b95@huawei.com>
Date:   Fri, 21 Apr 2023 20:40:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230420103742.43168-2-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/20 18:37, Mengyuan Lou wrote:
> +static u8 wx_get_ipv6_proto(struct sk_buff *skb, int offset)
> +{
> +	struct ipv6hdr *hdr = (struct ipv6hdr *)(skb->data + offset);
> +	u8 nexthdr = hdr->nexthdr;
> +
> +	offset += sizeof(struct ipv6hdr);
> +
> +	while (ipv6_ext_hdr(nexthdr)) {
> +		struct ipv6_opt_hdr _hdr, *hp;
> +
> +		if (nexthdr == NEXTHDR_NONE)
> +			break;
> +
> +		hp = skb_header_pointer(skb, offset, sizeof(_hdr), &_hdr);
> +		if (!hp)
> +			break;

Isn't this a error, which need to be propagated to the caller?

Also, it is a rare case, maybe add a unlikely() for that. Same for other
error handling.

> +
> +		if (nexthdr == NEXTHDR_FRAGMENT)
> +			break;
> +		else if (nexthdr == NEXTHDR_AUTH)
> +			offset +=  ipv6_authlen(hp);
> +		else
> +			offset +=  ipv6_optlen(hp);
> +		nexthdr = hp->nexthdr;
> +	}
> +
> +	return nexthdr;
> +}
> +
>
...

>  static netdev_tx_t wx_xmit_frame_ring(struct sk_buff *skb,
>  				      struct wx_ring *tx_ring)
>  {
>  	u16 count = TXD_USE_COUNT(skb_headlen(skb));
> +	__be16 protocol = skb->protocol;
>  	struct wx_tx_buffer *first;
> +	u8 hdr_len = 0, ptype;
>  	unsigned short f;
> +	u32 tx_flags = 0;
> +	int tso;
>  
>  	/* need: 1 descriptor per page * PAGE_SIZE/WX_MAX_DATA_PER_TXD,
>  	 *       + 1 desc for skb_headlen/WX_MAX_DATA_PER_TXD,
> @@ -864,7 +1327,41 @@ static netdev_tx_t wx_xmit_frame_ring(struct sk_buff *skb,
>  	first->bytecount = skb->len;
>  	first->gso_segs = 1;
>  
> -	wx_tx_map(tx_ring, first);
> +	/* if we have a HW VLAN tag being added default to the HW one */
> +	if (skb_vlan_tag_present(skb)) {
> +		tx_flags |= skb_vlan_tag_get(skb) << WX_TX_FLAGS_VLAN_SHIFT;
> +		tx_flags |= WX_TX_FLAGS_HW_VLAN;
> +	/* else if it is a SW VLAN check the next protocol and store the tag */
> +	} else if (eth_type_vlan(protocol)) {
> +		struct vlan_hdr *vhdr, _vhdr;
> +
> +		vhdr = skb_header_pointer(skb, ETH_HLEN, sizeof(_vhdr), &_vhdr);
> +		if (!vhdr)
> +			goto out_drop;
> +
> +		protocol = vhdr->h_vlan_encapsulated_proto;

isn't the protocol set here overrided by "protocol = vlan_get_protocol(skb)"
a few line below?

Also, Is "__be16 protocol = skb->protocol" necessary if
"protocol = vlan_get_protocol(skb)" is called unconditionally a few line below
and no one is using it before that?

> +		tx_flags |= ntohs(vhdr->h_vlan_TCI) << WX_TX_FLAGS_VLAN_SHIFT;
> +		tx_flags |= WX_TX_FLAGS_SW_VLAN;

WX_TX_FLAGS_SW_VLAN is set here, but it seems that wx_tx_cmd_type() does not use it?
It that intended? what is it used for?

> +	}
> +	protocol = vlan_get_protocol(skb);
> +
> +	/* record initial flags and protocol */
> +	first->tx_flags = tx_flags;
> +	first->protocol = protocol;
> +

...

> +
> +#define WX_SET_FLAG(_input, _flag, _result) \
> +	(((_flag) <= (_result)) ? \
> +	 ((u32)((_input) & (_flag)) * ((_result) / (_flag))) : \
> +	 ((u32)((_input) & (_flag)) / ((_flag) / (_result))))

Perhaps add a comment for the above macro, it seems a little hard to
understand it.


>  /* iterator for handling rings in ring container */
>  #define wx_for_each_ring(posm, headm) \
>  	for (posm = (headm).ring; posm; posm = posm->next)
> @@ -580,6 +693,9 @@ struct wx_ring {
>  
>  	struct wx_queue_stats stats;
>  	struct u64_stats_sync syncp;
> +	union {
> +		struct wx_tx_queue_stats tx_stats;

It does not seem to be used?

> +	};
>  } ____cacheline_internodealigned_in_smp;
>  
>  struct wx_q_vector {
> 
