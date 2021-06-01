Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B841D397B38
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 22:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhFAU1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 16:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234671AbhFAU1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 16:27:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34158610A8;
        Tue,  1 Jun 2021 20:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622579163;
        bh=2RGqqaOEnSd0LK0+wop5EnOkhn2/+LvTDRenEweUGCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=djNg89bVRT2X8/E139AuGWE1ZZALT5AxuAvwokQs5Byl/Cw1MYoj6M/nPQN2DbiP8
         lnmlkWsLux5OaHlDn4JalilUMCedb8EairBL6gCQiJzvBe2zGEnjD/fljz8olQU2XD
         FrVxdBbAoLHnqUjtZCZ1byR/8kEy1g6Fg26pwCJtywpW9gpPhg9H+0gUwl3Lk1iT0h
         UMp3Adx2iTAglKIIzVfXzOLbZmnjCEtJXqCVzSpxpocQY5p9GGx+xxCpFGWnp0gCMl
         ZLgWepdtKHRSrfkTZm89AbctlsqYYfbcIZnMfzjTNvzdLisLzBmJHECu3ffdVu4Bq0
         fFfeVj4+oZlEg==
Date:   Tue, 1 Jun 2021 13:26:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Changbin Du <changbin.du@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH] nsfs: fix oops when ns->ops is not provided
Message-ID: <20210601132602.02e92678@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210601080654.cl7caplm7rsagl6u@wittgenstein>
References: <20210531153410.93150-1-changbin.du@gmail.com>
        <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20210601080654.cl7caplm7rsagl6u@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021 10:06:54 +0200 Christian Brauner wrote:
> > I'm not sure why we'd pick runtime checks for something that can be
> > perfectly easily solved at compilation time. Networking should not
> > be asking for FDs for objects which don't exist.  
> 
> Agreed!
> This should be fixable by sm like:
> 
> diff --git a/net/socket.c b/net/socket.c
> index 27e3e7d53f8e..2484466d96ad 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -1150,10 +1150,12 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>                         break;
>                 case SIOCGSKNS:
>                         err = -EPERM;
> +#ifdef CONFIG_NET_NS
>                         if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
>                                 break;
> 
>                         err = open_related_ns(&net->ns, get_net_ns);
> +#endif
>                         break;
>                 case SIOCGSTAMP_OLD:
>                 case SIOCGSTAMPNS_OLD:

Thanks! You weren't CCed on v1, so FWIW I was suggesting
checking in get_net_ns(), to catch other callers:

diff --git a/net/socket.c b/net/socket.c
index 27e3e7d53f8e..3b44f2700e0c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1081,6 +1081,8 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
 
 struct ns_common *get_net_ns(struct ns_common *ns)
 {
+       if (!IS_ENABLED(CONFIG_NET_NS))
+               return ERR_PTR(-EOPNOTSUPP);
        return &get_net(container_of(ns, struct net, ns))->ns;
 }
 EXPORT_SYMBOL_GPL(get_net_ns);
