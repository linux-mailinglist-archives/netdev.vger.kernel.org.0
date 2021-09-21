Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A75C4133C8
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 15:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhIUNKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 09:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232868AbhIUNKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 09:10:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6C7E60E08;
        Tue, 21 Sep 2021 13:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632229751;
        bh=qVghV2pCPTeNfVYVE4nMXXbuu6o/x8de5E6Cyw6CEUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gX94Yc+uVW8q+5qHRiYMO2Xwj5z5fDglxWSC+3ya1I3cBkvDlDU1Uv6fx/r1YjPHM
         zjyFK4FXSigdwniuFkF9HIzDMYJUVR/fd3H/32/I3dKTQLykI3KAz2anW5r0HimNvd
         ZMJHSQM7ymxRcvwhYGxxS1Yln4FXul0/P6m5kkDis3okYEzF8AQ2VewHf+RxOlGMdU
         b1fYKEbfjnwuYRPp3B+XghYousYF0uD2RxpErWScI1mH92UBiDyKR6jhN5QjZyEwhN
         +aw4VfxdNJZFbyEyxzH7RS6afjGUvBEzgSh7TzupQmtZhLKz/ZwhBnWx9lt3f+73Gp
         N3YwjyODhkGWg==
Date:   Tue, 21 Sep 2021 06:09:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Kuznetsov <wwfq@yandex-team.ru>
Cc:     netdev@vger.kernel.org, zeil@yandex-team.ru
Subject: Re: [PATCH] ipv6: enable net.ipv6.route sysctls in network
 namespace
Message-ID: <20210921060909.380179f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210921062204.16571-1-wwfq@yandex-team.ru>
References: <20210921062204.16571-1-wwfq@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Sep 2021 09:22:04 +0300 Alexander Kuznetsov wrote:
> We want to increase route cache size in network namespace
> created with user namespace. Currently ipv6 route settings
> are disabled for non-initial network namespaces.
> Since routes are per network namespace it is safe
> to enable these sysctls.
> 
> Signed-off-by: Alexander Kuznetsov <wwfq@yandex-team.ru>
> Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>

Your CC list is very narrow. IMO you should CC Eric B on this, 
at the very least.

Why only remove this part and not any other part of 464dc801c76aa?

> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index b6ddf23..de85e3b 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -6415,10 +6415,6 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
>  		table[8].data = &net->ipv6.sysctl.ip6_rt_min_advmss;
>  		table[9].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
>  		table[10].data = &net->ipv6.sysctl.skip_notify_on_dev_down;
> -
> -		/* Don't export sysctls to unprivileged users */
> -		if (net->user_ns != &init_user_ns)
> -			table[0].procname = NULL;
>  	}
>  
>  	return table;

I don't know much about user ns, are we making an assumption here that
this user ns corresponds to a net ns? Or just because it's _possible_
to make them 1:1 we can shift the decision to the admin?
