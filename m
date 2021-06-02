Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D7E399013
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhFBQiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhFBQiP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 12:38:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 477AA6198F;
        Wed,  2 Jun 2021 16:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622651792;
        bh=yxmMBrVLhMXxjOEKOtD+84IT4h6Nyzauv28CSHSree8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lUuNX/KvAS+G97NJOWoQdA4NbnanBK7e2ZO685NZylnaoLYCMRw9CUy3tpDiyoMUX
         GZamfPuvk8O78eNkrpRFUGyAir2XmYsMo1yNFTULCl53WtJGEODuRxymZuRyKM5lQC
         Ru6lSoA2cJlbjEiVYqU9Ah+o1WwZfYrtPD9uoPqjGnGFGZG3z1ELowyWyRpuuRZ16P
         tAWATspjzooXE373vulMByXcnoly+QqtomlIgaDzfS10nxquF3ygDEHNfHxjX87LRj
         xa37wmRlwWhNWum5V4PqMxEPUi2QLucRzsRyDVJKsiNpzeAcnkf5fNzN9Q2Uie4c2j
         9I33WjZS2g6mw==
Date:   Wed, 2 Jun 2021 09:36:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Changbin Du <changbin.du@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH] nsfs: fix oops when ns->ops is not provided
Message-ID: <20210602093631.797db58f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210602091632.qijrpc2z6z44wu54@wittgenstein>
References: <20210531153410.93150-1-changbin.du@gmail.com>
        <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20210601080654.cl7caplm7rsagl6u@wittgenstein>
        <20210601132602.02e92678@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20210602091632.qijrpc2z6z44wu54@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Jun 2021 11:16:32 +0200 Christian Brauner wrote:
> > diff --git a/net/socket.c b/net/socket.c
> > index 27e3e7d53f8e..3b44f2700e0c 100644
> > --- a/net/socket.c
> > +++ b/net/socket.c
> > @@ -1081,6 +1081,8 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
> >  
> >  struct ns_common *get_net_ns(struct ns_common *ns)
> >  {
> > +       if (!IS_ENABLED(CONFIG_NET_NS))
> > +               return ERR_PTR(-EOPNOTSUPP);
> >         return &get_net(container_of(ns, struct net, ns))->ns;
> >  }
> >  EXPORT_SYMBOL_GPL(get_net_ns);  
> 
> Yeah, that's better than my hack. :) Maybe this function should simply
> move over to net/core/net_namespace.c with the other netns getters, e.g.
> get_net_ns_by_fd()?

SGTM!
