Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9C23E4F4B
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbhHIWdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 18:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233675AbhHIWdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 18:33:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43CA060E76;
        Mon,  9 Aug 2021 22:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628548372;
        bh=xXqBnT2glCcN1LrdDZFL0noW64vg4x2wLurWXjIrCZE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sv5JqZafThkJ55HJPd/tc0dS0kHCpZcjOB5csPwDFbxKT3EbeJ3/greDkvxkInLIm
         CkvQXJcCJcFs0Aqe0Lv+DpRDeE88Fzfwapi4+SQ/7hQ8im6gDsjyO6sZoVo2JrFv57
         vQ4Es96hc15qyFulz+V0eZPDB+uD7pj2BZhB+CBA+rRPE7KkMabl8biU1Ms9d9ONkX
         FrXaJo9woe2hX50qcitsVAaZfi1sQzX8GreH5uRMeDB9sJhlLRvZRt4JUkU4AQwnH7
         TSLTdxA8h8bV6WolT7ckn7105xtK7KWBBpXL5cgYhDXYpu1AfqM1NTWEAtyxaQB77O
         XJ2c2UP5XQ7fw==
Date:   Mon, 9 Aug 2021 15:32:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     davem@davemloft.net, David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Baoyou Xie <baoyou.xie@alibaba-inc.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: return early for possible invalid uaddr
Message-ID: <20210809153251.4c51c3cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210807171938.38501-1-wenyang@linux.alibaba.com>
References: <20210807171938.38501-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  8 Aug 2021 01:19:38 +0800 Wen Yang wrote:
> The inet_dgram_connect() first calls inet_autobind() to select an
> ephemeral port, then checks uaddr in udp_pre_connect() or
> __ip4_datagram_connect(), but the port is not released until the socket
> is closed.
> 
> We should return early for invalid uaddr to improve performance and
> simplify the code a bit,

The performance improvement would be if the benchmark is calling
connect with invalid arguments? That seems like an extremely rare
scenario in real life.

> and also switch from a mix of tabs and spaces to just tabs.

Please never mix unrelated whitespace cleanup into patches making real
code changes.

> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 5464818..97b6fc4 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -569,6 +569,11 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
>  	if (uaddr->sa_family == AF_UNSPEC)
>  		return sk->sk_prot->disconnect(sk, flags);
>  
> +	if (uaddr->sa_family != AF_INET)
> +		return -EAFNOSUPPORT;

And what about IPv6 which also calls this function?

> +	if (addr_len < sizeof(struct sockaddr_in))
> +		return -EINVAL;
> +
>  	if (BPF_CGROUP_PRE_CONNECT_ENABLED(sk)) {
>  		err = sk->sk_prot->pre_connect(sk, uaddr, addr_len);
>  		if (err)

