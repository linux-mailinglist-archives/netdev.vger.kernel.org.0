Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596D62B1180
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727759AbgKLW1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbgKLW1I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 17:27:08 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D39A206FB;
        Thu, 12 Nov 2020 22:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605220027;
        bh=kZGYKOnp3QwnS9OhLwTVPmSlbPZRfbiKAT7VQVYN91o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ot80wdzGNOdQ3TvVdv0HXwJxAy7IyVWoYoEvpZSz3to0hSQQ3d8xCPShbuWunnsGE
         cuN6TyWvj5i6ttUge/rLqBv1SBKXSV6bpW0wz+jQyrZnKatNA2ay9qUqkAIdQaLgTA
         eGEgbzbM62XNb46tJMPCfXqOFBfJ/lOccx2v0FUM=
Date:   Thu, 12 Nov 2020 14:27:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Herms <oliver.peter.herms@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] IPv4: RTM_GETROUTE: Add RTA_ENCAP to result
Message-ID: <20201112142706.63a1816b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112081008.GA57799@tws>
References: <20201112081008.GA57799@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 09:10:08 +0100 Oliver Herms wrote:
> This patch adds an IPv4 routes encapsulation attribute
> to the result of netlink RTM_GETROUTE requests
> (e.g. ip route get 192.0.2.1).
> 
> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> ---
>  net/ipv4/route.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index dc2a399cd9f4..b4d3384697cb 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2872,6 +2872,9 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
>  	if (rt->dst.dev &&
>  	    nla_put_u32(skb, RTA_OIF, rt->dst.dev->ifindex))
>  		goto nla_put_failure;
> +	if (rt->dst.lwtstate && lwtunnel_fill_encap(skb, rt->dst.lwtstate,
> +		RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
> +		goto nla_put_failure;

Please fix this checkpatch warning:

CHECK: Alignment should match open parenthesis
#25: FILE: net/ipv4/route.c:2876:
+	if (rt->dst.lwtstate && lwtunnel_fill_encap(skb, rt->dst.lwtstate,
+		RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
