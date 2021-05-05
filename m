Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677FD373D77
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 16:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbhEEOSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 10:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232079AbhEEOSQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 10:18:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A935661182;
        Wed,  5 May 2021 14:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620224240;
        bh=DrNaLqn2PFOVFBQ6CF6a5Ta2mnjboXyqN3hk8DOmA6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bk6tFrb9PrWfEFoP4ivCfvM0w9K6K7wwi+MfXVl1TnuJpdV6I2KP5ZM19Xae/1VPl
         uWF3QAtMqOOfoUnUx8k71h0MSkUsF+t9Ucin0UfH85k/H6LiaRg+P0pRIplIE0+XSs
         6sNG2TAjyCc9EpYQ6f15K7bTPXk/4yB6O36FnEZW2cHLyWdcxjgayNm9VtCz/Efk39
         BMDch7ROKZtvh3+geYlT+q/HbdsltmAlb29pD2Wkm79QK3iexEVrTpggHolnoDzQlr
         XVfjB+/7dVHIFsvBNb3cXWHUfToAmaDwmCrEntG2EpbY8wCLQwt40T2DSEWam1PNbY
         CaqvX6AlAiA5A==
Date:   Wed, 5 May 2021 17:17:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Nadav Markus <nmarkus@paloaltonetworks.com>
Cc:     Or Cohen <orcohen@paloaltonetworks.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org,
        Xiaoming Ni <nixiaoming@huawei.com>,
        matthieu.baerts@tessares.net, mkl@pengutronix.de
Subject: Re: [PATCH] net/nfc: fix use-after-free llcp_sock_bind/connect
Message-ID: <YJKo7IWyBk3PK2oS@unreal>
References: <20210504071525.28342-1-orcohen@paloaltonetworks.com>
 <YJEB6+K0RaPg8KD6@unreal>
 <CAM6JnLe=ZoHrpX8_i=_s5P-Q4h=mZxU=RN5pQuHbxq8pdZhYRQ@mail.gmail.com>
 <YJIjN6MTRdQ7Bvcp@unreal>
 <CABV_C9OJ6v1deEknc+V3cJaT+CPjmzg6Wb06_Rsey3AXqOBNYg@mail.gmail.com>
 <YJKEC6/AsN5dVClk@unreal>
 <CABV_C9PscjqNPTbK0JuNGsgCAX-xYg9=GG1KNyOh3hQU1TuzWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABV_C9PscjqNPTbK0JuNGsgCAX-xYg9=GG1KNyOh3hQU1TuzWQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 04:36:05PM +0300, Nadav Markus wrote:
> On Wed, May 5, 2021 at 2:40 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, May 05, 2021 at 12:35:48PM +0300, Nadav Markus wrote:
> > > On Wed, May 5, 2021 at 7:46 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > > On Tue, May 04, 2021 at 07:01:01PM +0300, Or Cohen wrote:
> > > > > Hi, can you please elaborate?
> > > > >
> > > > > We don't understand why using kref_get_unless_zero will solve the
> > > > problem.
> > > >
> > > > Please don't reply in top-posting format.
> > > > ------
> > > >
> > > > The rationale behind _put()/_get() wrappers over kref is to allow
> > > > delayed release after all consumers are gone.
> > > >
> > > > In order to make it happen, the developer should ensure that consumers
> > > > don't have an access to the kref-ed struct. This is done with
> > > > kref_get_unless_zero().
> > > >
> > > > In your case, you simply increment some counter without checking if
> > > > nfc_llcp_local_get() actually succeeded.
> > > >
> > >
> > > Hi Leon - as far as we understand, the underlying issue is not
> incrementing
> > > the kref counter without checking if the function nfc_llcp_local_get
> > > succeeded or not. The function itself increments the reference count.
> > >
> > > The issue is that the nfc_llcp_local_put might be called twice on the
> > > llcp_sock->local field, however only one reference (the one that was
> gotten
> > > via nfc_llcp_local_get) is incremented. llcp_local_put will be called in
> > > two locations. The first one is just inside the bind function, if
> > > nfc_llcp_get_local_ssap fails. The second one is called
> unconditionally, at
> > > the socket destruction, at the function nfc_llcp_sock_free.
> > >
> > > Hence, our proposed solution is to prevent the second nfc_llcp_local_put
> > > from attempting to decrement the kref count, by setting local to NULL.
> This
> > > makes sense, as we immediately do so after decrementing the single ref
> > > count we took when calling nfc_llcp_local_get. Since we are under the
> sock
> > > lock, this also should be race safe, as no one should access the
> > > llcp_sock->local field without this lock's protection.
> > >
> > > >
> > > > For example, what protection do you have from races between
> > > > llcp_sock_bind(),
> > > > nfc_llcp_sock_free() and llcp_sock_connect()?
> > > >
> > >
> > > As we replied, the llcp_sock->local field is protected under the lock
> sock,
> > > as far as we understand.
> > >
> > > >
> > > > So in case you have some lock outside, it is unclear how
> use-after-free
> > > > is possible, because nfc_llcp_find_local() should return NULL.
> > > > In case, no lock exists, except reducing race window, you didn't fix
> > > > anything
> > > > and didn't sanitize lcp_sock too.
> > > >
> > >
> > > We don't quite get what race are we talking about here - our trigger
> > > program doesn't even utilize threads. All it has to do is to
> > > cause nfc_llcp_local_get to fail - this can be seen clearly in our
> original
> > > trigger program. To clarify, the two sockets that are created there
> point
> > > to the same nfc_llcp_local struct (via their local field). The
> destruction
> > > of the first socket causes the reference count of the pointed object to
> > > drop to zero (since the code increments the ref count of the object
> from 1
> > > to 2, but dercements it twice). The second socket later attempts to
> > > decrement the ref count of the same (already freed) nfc_llcp_local
> object,
> > > causing a kernel crash.
> >
> >
> > So at the end, we are talking about situation where _get()/_put() are
> > protected by the lock and local can't disappear. Can you please help me
> to find
> > this socket lock? Did I miss it in bind path?
> 
> The lock we are talking about is the lock_sock - lock_sock(sk). It appears
> near the start of the function.
> 
> >
> >
> > net/socket.c:
> >   int __sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen)
> >     sock->ops->bind(..)
> >      llcp_sock_bind(..)
> >
> > And if we put lock issue aside, all your change can be squeezed to the
> following:
> >
> > diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
> > index a3b46f888803..cc9ee634269d 100644
> > --- a/net/nfc/llcp_sock.c
> > +++ b/net/nfc/llcp_sock.c
> > @@ -99,7 +99,6 @@ static int llcp_sock_bind(struct socket *sock, struct
> sockaddr *addr, int alen)
> >         }
> >
> >         llcp_sock->dev = dev;
> > -       llcp_sock->local = nfc_llcp_local_get(local);
> >         llcp_sock->nfc_protocol = llcp_addr.nfc_protocol;
> >         llcp_sock->service_name_len = min_t(unsigned int,
> >                                             llcp_addr.service_name_len,
> > @@ -108,13 +107,11 @@ static int llcp_sock_bind(struct socket *sock,
> struct sockaddr *addr, int alen)
> >                                           llcp_sock->service_name_len,
> >                                           GFP_KERNEL);
> >         if (!llcp_sock->service_name) {
> > -               nfc_llcp_local_put(llcp_sock->local);
> >                 ret = -ENOMEM;
> >                 goto put_dev;
> >         }
> >         llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
> >         if (llcp_sock->ssap == LLCP_SAP_MAX) {
> > -               nfc_llcp_local_put(llcp_sock->local);
> >                 kfree(llcp_sock->service_name);
> >                 llcp_sock->service_name = NULL;
> >                 ret = -EADDRINUSE;
> > @@ -122,6 +119,7 @@ static int llcp_sock_bind(struct socket *sock, struct
> sockaddr *addr, int alen)
> >         }
> >
> >         llcp_sock->reserved_ssap = llcp_sock->ssap;
> > +       llcp_sock->local = nfc_llcp_local_get(local);
> >
> >         nfc_llcp_sock_link(&local->sockets, sk);
> >
> >
> > Thanks
> 
> While your suggested fix will work for the bind path (it implicitly makes
> sure that the 'local' field is always NULL, up until the point that
> everything is initialized properly), we have a problem in the 'connect'
> path.

It is a mess.

> 
> If we try to take the same approach inside the function llcp_sock_connect,
> there is a call to nfc_llcp_send_connect, which requires the local field to
> be set inside the socket. We thought about changing its interface to just
> accept the 'local' as an argument, but this function is exported in the .h
> file, and we are afraid of breaking external interfaces. Therefore, we
> think that we should take a consistent approach of explicitly setting the
> local field to NULL in all paths. Note that this explicit assignment should
> achieve the same result as your approach, of implicitly letting it stay
> NULL up until we can safely assign to it.
> 
> Please let us know WDYT.

It is in-kernel API with only one user, I would personally use that
opportunity and cleaned nfc_llcp_send_connect() from ridiculous checks.

This is always false:
  401         local = sock->local;
  402         if (local == NULL)

Always true:
  405         if (sock->service_name != NULL)

However the more I look on that code the more I come to the conclusion that it
is not worth to change it.

Thanks
