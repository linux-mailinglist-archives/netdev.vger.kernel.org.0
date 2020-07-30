Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD094233C3D
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730773AbgG3Xo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgG3Xo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:44:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CBDC061574;
        Thu, 30 Jul 2020 16:44:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D563126C050A;
        Thu, 30 Jul 2020 16:27:39 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:44:24 -0700 (PDT)
Message-Id: <20200730.164424.85007408369570229.davem@davemloft.net>
To:     ahabdels@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andrea.mayer@uniroma2.it
Subject: Re: [net-next] seg6: using DSCP of inner IPv4 packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728122044.1900-1-ahabdels@gmail.com>
References: <20200728122044.1900-1-ahabdels@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:27:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ahmed Abdelsalam <ahabdels@gmail.com>
Date: Tue, 28 Jul 2020 12:20:44 +0000

> This patch allows copying the DSCP from inner IPv4 header to the
> outer IPv6 header, when doing SRv6 Encapsulation.
> 
> This allows forwarding packet across the SRv6 fabric based on their
> original traffic class.
> 
> Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>

The conditionals in this function are now a mess.

> -	inner_hdr = ipv6_hdr(skb);
> +	if (skb->protocol == htons(ETH_P_IPV6))
> +		inner_hdr = ipv6_hdr(skb);
> +	else
> +		inner_ipv4_hdr = ip_hdr(skb);
> +

You assume that if skb->protocol is not ipv6 then it is ipv4.

> @@ -138,6 +143,10 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
>  		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr)),
>  			     flowlabel);
>  		hdr->hop_limit = inner_hdr->hop_limit;
> +	} else if (skb->protocol == htons(ETH_P_IP)) {
> +		ip6_flow_hdr(hdr, inner_ipv4_hdr->tos, flowlabel);
> +		hdr->hop_limit = inner_ipv4_hdr->ttl;
> +		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
>  	} else {
>  		ip6_flow_hdr(hdr, 0, flowlabel);
>  		hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));

But this code did not make that assumption at all.

Only one of the two can be correct.

The conditional assignment is also very ugly, you have two pointers
conditionally initialized.  The compiler is going to have a hard time
figuring out that each pointer is only used in the code path where it
is guaranteed to be initialiazed.

And it can't do that, as far as the compiler knows, skb->protocol can
change between those two locations.  It MUST assume that can happen if
there are any functions calls whatsoever between these two code points.

This function has to be sanitized, with better handling of access to
the inner protocol header values, before I am willing to apply this.
