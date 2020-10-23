Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8C82978B1
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 23:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755356AbgJWVM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 17:12:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752905AbgJWVM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 17:12:56 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E82422137B;
        Fri, 23 Oct 2020 21:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603487576;
        bh=OTNmX4ghfPdYmJbLGw9rtSBwMt+mJBGMIVj5y1WC+9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sk/vT52JK3bgacsaFmnB5dzBd06SIdtqHibh3IzgNz3vifQdSDvYYpnBsVxhGuB85
         Hug7ZjJPzWKXs79nw4nIGBvkSnlVym4Na4TSpzfyr8jc1RIM3f90Gi0QXAje5OjkHx
         dd0u71S3irIaf0FN9s9hL2fsulNATKrEPCbWZpNE=
Date:   Fri, 23 Oct 2020 14:12:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ip_tunnel: fix over-mtu packet send fail without
 TUNNEL_DONT_FRAGMENT flags
Message-ID: <20201023141254.7102795d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1603272115-25351-1-git-send-email-wenxu@ucloud.cn>
References: <1603272115-25351-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 17:21:55 +0800 wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The TUNNEL_DONT_FRAGMENT flags specific the tunnel outer ip can do
> fragment or not in the md mode. Without the TUNNEL_DONT_FRAGMENT
> should always do fragment. So it should not care the frag_off in
> inner ip.

Can you describe the use case better? My understanding is that we
should propagate DF in normally functioning networks, and let PMTU 
do its job.

> Fixes: cfc7381b3002 ("ip_tunnel: add collect_md mode to IPIP tunnel")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/ipv4/ip_tunnel.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index 8b04d1d..ee65c92 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -608,9 +608,6 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
>  			ttl = ip4_dst_hoplimit(&rt->dst);
>  	}
>  
> -	if (!df && skb->protocol == htons(ETH_P_IP))
> -		df = inner_iph->frag_off & htons(IP_DF);
> -
>  	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
>  	if (headroom > dev->needed_headroom)
>  		dev->needed_headroom = headroom;

