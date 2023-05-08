Return-Path: <netdev+bounces-806-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE846F9FC4
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 878D9280F3E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86E7125D5;
	Mon,  8 May 2023 06:17:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F7D33E3
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EEBC433D2;
	Mon,  8 May 2023 06:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683526673;
	bh=ddHAy9UC1X9JjQHkiCLrIPWReu3wmufMe4BtZeIcT4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jFRKWCBjoKDB9L/XUi9CzhJ30P9F8WS/nyPwWH/KrOjSyTwS5n3aWZtID/aq5qgAU
	 LN7HTvKMCO0bjrUuKNN/csCJWmyqBa2yd/TLac/WzQWtOvWG/0AnwHNfyQ/FeHlarE
	 /1ABGJ+Bhw+b6fyQdiBxW2NCikwJy4aGtdlROtHu7H/QnMGP6mFwPrTikm4clkbjvU
	 oUB9N53IYGHohIMEVKMFV1b0iLK3x0EQaabiT+A2PpHZ3rpXVmlPsLsulWPG0bj+Lr
	 vk4Fu/X6rjNVOaKCkxWEPMOlalhiCzVKzB4VEfxr097BCgqPLgl6BGJuzFfOrsgl0h
	 b4jIp25ExvtIw==
Date: Mon, 8 May 2023 09:17:49 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Patryk Sondej <patryk.sondej@gmail.com>
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH net] inet_diag: fix inet_diag_msg_attrs_fill() for
 net_cls cgroup
Message-ID: <20230508061749.GC6195@unreal>
References: <20230508033232.69793-1-patryk.sondej@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508033232.69793-1-patryk.sondej@gmail.com>

On Mon, May 08, 2023 at 05:32:33AM +0200, Patryk Sondej wrote:
> This commit fixes inet_diag_msg_attrs_fill() function in the ipv4/inet_diag.c file.
> The problem was that the function was using CONFIG_SOCK_CGROUP_DATA to check for the net_cls cgroup.
> However, the net_cls cgroup is defined by CONFIG_CGROUP_NET_CLASSID instead.
> 
> Therefore, this commit updates the #ifdef statement to CONFIG_CGROUP_NET_CLASSID,
> and uses the sock_cgroup_classid() function to retrieve the classid from the socket cgroup.
> 
> This change ensures that the function correctly retrieves the classid for the net_cls cgroup
> and fixes any issues related to the use of the function in this context.
> 

Please add Fixes line here.

> Signed-off-by: Patryk Sondej <patryk.sondej@gmail.com>
> ---
>  net/ipv4/inet_diag.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> index b812eb36f0e3..7017f88911a6 100644
> --- a/net/ipv4/inet_diag.c
> +++ b/net/ipv4/inet_diag.c
> @@ -157,7 +157,7 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
>  	    ext & (1 << (INET_DIAG_TCLASS - 1))) {
>  		u32 classid = 0;
>  
> -#ifdef CONFIG_SOCK_CGROUP_DATA
> +#ifdef CONFIG_CGROUP_NET_CLASSID

This ifdef should be deleted as sock_cgroup_classid() already has right ifdef.

  809 static inline u32 sock_cgroup_classid(const struct sock_cgroup_data *skcd)
  810 {
  811 #ifdef CONFIG_CGROUP_NET_CLASSID
  812         return READ_ONCE(skcd->classid);
  813 #else
  814         return 0;
  815 #endif
  816 }
  817


>  		classid = sock_cgroup_classid(&sk->sk_cgrp_data);
>  #endif
>  		/* Fallback to socket priority if class id isn't set.
> -- 
> 2.37.1 (Apple Git-137.1)
> 
> 

