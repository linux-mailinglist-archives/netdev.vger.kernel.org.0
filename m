Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B4F4D66F3
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350333AbiCKQ76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350441AbiCKQ7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:59:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D7E673DC;
        Fri, 11 Mar 2022 08:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8400FB82C20;
        Fri, 11 Mar 2022 16:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB580C340E9;
        Fri, 11 Mar 2022 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647017928;
        bh=OG0J3GojgmzIoNZPBok++aiZW+CyroBNvFpFTQVCZXA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=X7F+/9epy+hJ4kGnQUwkPj8TVU5IFVZly1jBpzHAfBq4aEFsMmZvEsADN86iHN8sM
         sK9mTrmzjVGnuiIV4deFKbIPZhCpI17XVz3apKJctv0OHWdiq3rfUZOTNPzNgQuIko
         HvPuL1R1Z9c2Uum9fRpRyPQ4LQgEobayFYlPB2Yi/E+4fYGnpppQ+He6dGcDNmPxKo
         6DVxfPgBqkLXQu+9OYVEGQIZuyyGXXGNBR65zMqk3GdE+xsoqGnRsVdyvII+F4muhB
         G32xX7aPwFizSGUYaJUuFjzG2TObanmerouHSrJR6jeodVH4NX8hp2IyFnGlf8H8bQ
         zqhHIShglvKQg==
Message-ID: <b0ef55ef-234f-63a4-7cc3-fd4acde2f011@kernel.org>
Date:   Fri, 11 Mar 2022 09:58:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH 1/3] net:ipv6:Add ndisc_bond_send_na to support sending na
 by slave directly
Content-Language: en-US
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
References: <20220311024958.7458-1-sunshouxin@chinatelecom.cn>
 <20220311024958.7458-2-sunshouxin@chinatelecom.cn>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220311024958.7458-2-sunshouxin@chinatelecom.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/22 7:49 PM, Sun Shouxin wrote:
> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index fcb288b0ae13..c59a110e9b10 100644
> --- a/net/ipv6/ndisc.c
> +++ b/net/ipv6/ndisc.c
> @@ -572,6 +572,67 @@ void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
>  	ndisc_send_skb(skb, daddr, src_addr);
>  }
>  
> +void ndisc_bond_send_na(struct net_device *dev, const struct in6_addr *daddr,

This ipv6 code, not bond code


> +			const struct in6_addr *solicited_addr,
> +			bool router, bool solicited, bool override,
> +			bool inc_opt, unsigned short vlan_id,
> +			const void *mac_dst, const void *mac_src)
> +{
> +	struct sk_buff *skb;
> +	const struct in6_addr *src_addr;
> +	struct nd_msg *msg;
> +	struct net *net = dev_net(dev);
> +	struct sock *sk = net->ipv6.ndisc_sk;
> +	int optlen = 0;
> +	int ret;
> +
> +	src_addr = solicited_addr;
> +	if (!dev->addr_len)
> +		inc_opt = false;
> +	if (inc_opt)
> +		optlen += ndisc_opt_addr_space(dev,
> +					       NDISC_NEIGHBOUR_ADVERTISEMENT);
> +
> +	skb = ndisc_alloc_skb(dev, sizeof(*msg) + optlen);
> +	if (!skb)
> +		return;
> +
> +	msg = skb_put(skb, sizeof(*msg));
> +	*msg = (struct nd_msg) {
> +		.icmph = {
> +			.icmp6_type = NDISC_NEIGHBOUR_ADVERTISEMENT,
> +			.icmp6_router = router,
> +			.icmp6_solicited = solicited,
> +			.icmp6_override = override,
> +		},
> +		.target = *solicited_addr,
> +	};
> +
> +	if (inc_opt)
> +		ndisc_fill_addr_option(skb, ND_OPT_TARGET_LL_ADDR,
> +				       dev->dev_addr,
> +				       NDISC_NEIGHBOUR_ADVERTISEMENT);
> +
> +	if (vlan_id)
> +		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
> +				       vlan_id);
> +
> +	msg->icmph.icmp6_cksum = csum_ipv6_magic(src_addr, daddr, skb->len,
> +						 IPPROTO_ICMPV6,
> +						 csum_partial(&msg->icmph,
> +							      skb->len, 0));
> +
> +	ip6_nd_hdr(skb, src_addr, daddr, inet6_sk(sk)->hop_limit, skb->len);
> +
> +	skb->protocol = htons(ETH_P_IPV6);
> +	skb->dev = dev;
> +	if (dev_hard_header(skb, dev, ETH_P_IPV6, mac_dst, mac_src, skb->len) < 0)
> +		return;
> +
> +	ret = dev_queue_xmit(skb);
> +}
> +EXPORT_SYMBOL(ndisc_bond_send_na);

It would be better to refactor ndisc_send_na and extract what you think
you need into a new helper that gets exported for bond.

