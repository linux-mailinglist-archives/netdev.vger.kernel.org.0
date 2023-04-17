Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D0F6E47DE
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDQMfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjDQMfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:35:11 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC61EE
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:35:07 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q0RH93nrMzSr5Z;
        Mon, 17 Apr 2023 20:31:01 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 17 Apr
 2023 20:35:05 +0800
Subject: Re: [PATCH net-next v2 1/5] net: wangxun: libwx add tx offload
 functions
To:     Mengyuan Lou <mengyuanlou@net-swift.com>, <netdev@vger.kernel.org>
CC:     <jiawenwu@trustnetic.com>
References: <20230417105457.82127-1-mengyuanlou@net-swift.com>
 <20230417105457.82127-2-mengyuanlou@net-swift.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <630e590e-fac3-5f69-688e-ac140ab3464e@huawei.com>
Date:   Mon, 17 Apr 2023 20:35:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230417105457.82127-2-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/17 18:54, Mengyuan Lou wrote:
> +
> +static u8 wx_encode_tx_desc_ptype(const struct wx_tx_buffer *first)
> +{
> +	u8 tun_prot = 0, l4_prot = 0, ptype = 0;
> +	struct sk_buff *skb = first->skb;
> +
> +	if (skb->encapsulation) {
> +		union network_header hdr;
> +
> +		switch (first->protocol) {
> +		case htons(ETH_P_IP):
> +			tun_prot = ip_hdr(skb)->protocol;
> +			if (ip_is_fragment(ip_hdr(skb)))
> +				goto encap_frag;

It seems you can do below:
	if (ip_is_fragment(ip_hdr(skb)))
		return WX_PTYPE_PKT_IP | WX_PTYPE_TYP_IPFRAG;

Instead of goto encap_frag to do the first->protocol and
ip_is_fragment() checking again?

> +			ptype = WX_PTYPE_TUN_IPV4;
> +			break;
> +		case htons(ETH_P_IPV6):
> +			tun_prot = wx_get_ipv6_proto(skb, skb_network_offset(skb));
> +			if (tun_prot == NEXTHDR_FRAGMENT)
> +				goto encap_frag;

Similar handling here?

> +			ptype = WX_PTYPE_TUN_IPV6;
> +			break;
> +		default:
> +			goto exit;

Return 0 or return ptype directly instead of goto?

Similar comment as other 'goto exit'.

> +		}
> +
> +		if (tun_prot == IPPROTO_IPIP) {

...

> +			goto exit;
> +		}
> +	} else {
> +encap_frag:
> +		switch (first->protocol) {
> +		case htons(ETH_P_IP):
> +			l4_prot = ip_hdr(skb)->protocol;
> +			ptype = WX_PTYPE_PKT_IP;
> +			if (ip_is_fragment(ip_hdr(skb))) {
> +				ptype |= WX_PTYPE_TYP_IPFRAG;
> +				goto exit;
> +			}
> +			break;
> +		case htons(ETH_P_IPV6):
> +			l4_prot = wx_get_ipv6_proto(skb, skb_network_offset(skb));
> +			ptype = WX_PTYPE_PKT_IP | WX_PTYPE_PKT_IPV6;
> +			if (l4_prot == NEXTHDR_FRAGMENT) {
> +				ptype |= WX_PTYPE_TYP_IPFRAG;
> +				goto exit;
> +			}
> +			break;
> +		case htons(ETH_P_1588):
> +			ptype = WX_PTYPE_L2_TS;
> +			goto exit;
> +		case htons(ETH_P_FIP):
> +			ptype = WX_PTYPE_L2_FIP;
> +			goto exit;
> +		case htons(ETH_P_LLDP):
> +			ptype = WX_PTYPE_L2_LLDP;
> +			goto exit;
> +		case htons(ETH_P_CNM):
> +			ptype = WX_PTYPE_L2_CNM;
> +			goto exit;
> +		case htons(ETH_P_PAE):
> +			ptype = WX_PTYPE_L2_EAPOL;
> +			goto exit;
> +		case htons(ETH_P_ARP):
> +			ptype = WX_PTYPE_L2_ARP;
> +			goto exit;
> +		default:
> +			ptype = WX_PTYPE_L2_MAC;

Is it ok to set ptype to WX_PTYPE_L2_MAC for first->protocol != ETH_P_IP
&& first->protocol != ETH_P_IPV6? Does hw need to do checksum/tso or other thing
about those packet? if not, setting WX_PTYPE_L2_MAC seems enough?

Also, some macro and variable are still not used, such as WX_PTYPE_L2_FCOE_VFT_FCRDY
and vft_shadow, it would be better to remove it for now, and add it as needed.
