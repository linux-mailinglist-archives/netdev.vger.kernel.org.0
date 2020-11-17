Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C597F2B5664
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgKQBq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:46:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbgKQBq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 20:46:57 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9315A2222C;
        Tue, 17 Nov 2020 01:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605577616;
        bh=q0TWMXxie6C1dfxG7ZyM3lbwjNmuOM8CEhzv2beVk5g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iBEvnRtOqoYFGVQb5MrgtJdbu4eHnqAiJmqMoZMQ6zq5oSQ8hpoqODXPbvtjgcZ+6
         s0CsPT3A51hfvyfvMlAFbSUJSizCVIBEc39QVRoaRcLC+9ZKczDVbGhqDdr+FZqIfJ
         o458ZuIA1sbvDNUeV/O3SgYkFwW1znSVaWj2zMbI=
Date:   Mon, 16 Nov 2020 17:46:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Herms <oliver.peter.herms@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] IPv6: RTM_GETROUTE: Add RTA_ENCAP to result
Message-ID: <20201116174655.57f5e35a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201115105527.GA11569@tws>
References: <20201115105527.GA11569@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 11:55:27 +0100 Oliver Herms wrote:
> This patch adds an IPv6 routes encapsulation attribute
> to the result of netlink RTM_GETROUTE requests
> (e.g. ip route get 2001:db8::).
> 
> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> ---
>  net/ipv6/route.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 82cbb46a2a4f..4d45696a70eb 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -5489,6 +5489,11 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
>  	rtm->rtm_scope = RT_SCOPE_UNIVERSE;
>  	rtm->rtm_protocol = rt->fib6_protocol;
>  
> +	if (dst && dst->lwtstate &&
> +	    lwtunnel_fill_encap(skb, dst->lwtstate, RTA_ENCAP, RTA_ENCAP_TYPE) < 0) {
> +		goto nla_put_failure;
> +	}

curly brackets are not required around a single statement

Please fix and CC David Ahern, since he reviewed your corresponding
IPv4 patch.

Thanks!
