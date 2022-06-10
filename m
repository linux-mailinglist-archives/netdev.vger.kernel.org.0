Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E964546629
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 14:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245383AbiFJMAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 08:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241978AbiFJMAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 08:00:45 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D85B3E0E9
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 05:00:41 -0700 (PDT)
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 25AC03lS003098;
        Fri, 10 Jun 2022 14:00:09 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id C42A612005F;
        Fri, 10 Jun 2022 13:59:58 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1654862398; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+dL/FaE19RRrceGAE72bOAXe+DXrZsDQ/akjhWLokNk=;
        b=Pxf+RZWTBJBActMhgCq7npVRHkQXyBkHlns2KHx3hhMPK7XPlvcBzwtDo8gQF/IfZtX/zO
        jdtZjSQsf8jY/hDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1654862398; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+dL/FaE19RRrceGAE72bOAXe+DXrZsDQ/akjhWLokNk=;
        b=F7NCghCmLK3HG+tZ2Cz0k2I6qs4RnDIohHGVaDUtgGIVgfWqQt0maC9IqfKAXU8ZAf1gJ/
        ZxKPeMZ7e/djyDi+/flEij5swWug4C39nfDbE6hnE95H+igw56fI+pKQLI9tfts7AkfKsN
        X0lztF5HXyRb/mAPIbT2nscabbktFnNmhxLdi2CbGePg/lxUK2IoWUH0fvXo3f5Pul+4xG
        WDA9JOKdlKgmFYT+NRL9ujQkyNpAtEmG4UMZjtolCVGElEbchSYUkZPHweQgPJflgyAIrw
        Dx9R/rDXM1/op53MECNryOnL+FjH/gpZiwTKsh56VD/5Nth8b5BiSxFoNh3e4A==
Date:   Fri, 10 Jun 2022 13:59:58 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Anton Makarov <antonmakarov11235@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, david.lebrun@uclouvain.be,
        netdev@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next v2 1/1] net: seg6: Add support for SRv6 Headend
 Reduced Encapsulation
Message-Id: <20220610135958.cb99b9122925b62eba634337@uniroma2.it>
In-Reply-To: <20220609132750.4917-1-anton.makarov11235@gmail.com>
References: <20220609132750.4917-1-anton.makarov11235@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Anton,
please see my comments inline, thanks.

On Thu,  9 Jun 2022 16:27:50 +0300
Anton Makarov <antonmakarov11235@gmail.com> wrote:

> SRv6 Headend H.Encaps.Red and H.Encaps.L2.Red behaviors are implemented
> accordingly to RFC 8986. The H.Encaps.Red is an optimization of
> The H.Encaps behavior. The H.Encaps.L2.Red is an optimization of
> the H.Encaps.L2 behavior. Both new behaviors reduce the length of
> the SRH by excluding the first SID in the SRH of the pushed IPv6 header.
> The first SID is only placed in the Destination Address field
> of the pushed IPv6 header.
> 
> The push of the SRH is omitted when the SRv6 Policy only contains
> one segment.
> 
> Signed-off-by: Anton Makarov <anton.makarov11235@gmail.com>
> 
> ...
>  
> +/* encapsulate an IPv6 packet within an outer IPv6 header with reduced SRH */
> +int seg6_do_srh_encap_red(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
> +{
> +	struct dst_entry *dst = skb_dst(skb);
> +	struct net *net = dev_net(dst->dev);
> +	struct ipv6hdr *hdr, *inner_hdr6;
> +	struct iphdr *inner_hdr4;
> +	struct ipv6_sr_hdr *isrh;
> +	int hdrlen = 0, tot_len, err;

I suppose we should stick with the reverse XMAS tree code style.

> +	__be32 flowlabel = 0;

this initialization is unnecessary since the variable is accessed for the first
time in writing, later in the code.

> +	if (osrh->first_segment > 0)
> +		hdrlen = (osrh->hdrlen - 1) << 3;
> +
> +	tot_len = hdrlen + sizeof(struct ipv6hdr);
> +
> +	err = skb_cow_head(skb, tot_len + skb->mac_len);
> +	if (unlikely(err))
> +		return err;
> +
> +	inner_hdr6 = ipv6_hdr(skb);
> +	inner_hdr4 = ip_hdr(skb);

inner_hdr4 is only used in the *if* block that follows later on.

> +	flowlabel = seg6_make_flowlabel(net, skb, inner_hdr6);
> +
> +	skb_push(skb, tot_len);
> +	skb_reset_network_header(skb);
> +	skb_mac_header_rebuild(skb);
> +	hdr = ipv6_hdr(skb);
> +
> +	memset(skb->cb, 0, sizeof(skb->cb));

is there a specific reason why we should consider the whole CB size and not
only the part covered by the struct inet6_skb_parm?

> +	IP6CB(skb)->iif = skb->skb_iif;
> +
> +	if (skb->protocol == htons(ETH_P_IPV6)) {
> +		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr6)),
> +			     flowlabel);
> +		hdr->hop_limit = inner_hdr6->hop_limit;
> +	} else if (skb->protocol == htons(ETH_P_IP)) {
> +		ip6_flow_hdr(hdr, (unsigned int) inner_hdr4->tos, flowlabel);
> +		hdr->hop_limit = inner_hdr4->ttl;
> +	}
> +

Don't IPv4 and IPv6 cover all possible cases?

> +	skb->protocol = htons(ETH_P_IPV6);
> +
> +	hdr->daddr = osrh->segments[osrh->first_segment];
> +	hdr->version = 6;
> +
> +	if (osrh->first_segment > 0) {
> +		hdr->nexthdr = NEXTHDR_ROUTING;
> +
> +		isrh = (void *)hdr + sizeof(struct ipv6hdr);
> +		memcpy(isrh, osrh, hdrlen);
> +
> +		isrh->nexthdr = proto;
> +		isrh->first_segment--;
> +		isrh->hdrlen -= 2;
> +	} else {
> +		hdr->nexthdr = proto;
> +	}
> +
> +	set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
> +
> +#ifdef CONFIG_IPV6_SEG6_HMAC
> +	if (osrh->first_segment > 0 && sr_has_hmac(isrh)) {
> +		err = seg6_push_hmac(net, &hdr->saddr, isrh);
> +		if (unlikely(err))
> +			return err;
> +	}
> +#endif
> +

When there is only one SID and HMAC is configured, the SRH is not kept.
Aren't we losing information this way?

Andrea
