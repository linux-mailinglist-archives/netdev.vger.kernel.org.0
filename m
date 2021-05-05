Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D121373476
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 06:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhEEErr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 00:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229895AbhEEErq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 00:47:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4732461185;
        Wed,  5 May 2021 04:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620190011;
        bh=U3xktmERGgs61YBkmKu2uwkDBPsklzyzFJNk3Wk5Koo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mXY2dsIJFg8Dn89ArSr0hzpPuTWJNhJ/dCrwuOLqEJo3dtcGgkmyCYkw/A9CYuy09
         Gbu+Xj0Uu7cZYl6B3pbnDerXJOEG2gpbEY8b3q7bHW3JD1yJH8AjRYsQbNVjNCWySu
         y5WtcfyCwp/+ktYT3yrpkewdqimWhyE3cXcPhQcHZWv0rsKGVTToq9rl30m//epcwR
         cTuYUrxq4nG6s1OjT6ixXvv9VOwNrwsZsWBVRpUsYW3HIN25Tv5UMpPXIFaVHVlCZS
         Bwp0e2cgWSswGxzORUh0GQ44L0SnPwW4YmAHy/GSdFPXLNG7HuEU+LtjjKyk0vz178
         A62RObyCwmpzg==
Date:   Wed, 5 May 2021 07:46:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Or Cohen <orcohen@paloaltonetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Xiaoming Ni <nixiaoming@huawei.com>,
        matthieu.baerts@tessares.net, mkl@pengutronix.de,
        Nadav Markus <nmarkus@paloaltonetworks.com>
Subject: Re: [PATCH] net/nfc: fix use-after-free llcp_sock_bind/connect
Message-ID: <YJIjN6MTRdQ7Bvcp@unreal>
References: <20210504071525.28342-1-orcohen@paloaltonetworks.com>
 <YJEB6+K0RaPg8KD6@unreal>
 <CAM6JnLe=ZoHrpX8_i=_s5P-Q4h=mZxU=RN5pQuHbxq8pdZhYRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM6JnLe=ZoHrpX8_i=_s5P-Q4h=mZxU=RN5pQuHbxq8pdZhYRQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 07:01:01PM +0300, Or Cohen wrote:
> Hi, can you please elaborate?
> 
> We don't understand why using kref_get_unless_zero will solve the problem.

Please don't reply in top-posting format.
------

The rationale behind _put()/_get() wrappers over kref is to allow
delayed release after all consumers are gone. 

In order to make it happen, the developer should ensure that consumers
don't have an access to the kref-ed struct. This is done with
kref_get_unless_zero().

In your case, you simply increment some counter without checking if
nfc_llcp_local_get() actually succeeded.

For example, what protection do you have from races between llcp_sock_bind(),
nfc_llcp_sock_free() and llcp_sock_connect()?

So in case you have some lock outside, it is unclear how use-after-free
is possible, because nfc_llcp_find_local() should return NULL.
In case, no lock exists, except reducing race window, you didn't fix anything
and didn't sanitize lcp_sock too.

Thanks

> 
> On Tue, May 4, 2021 at 11:12 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, May 04, 2021 at 10:15:25AM +0300, Or Cohen wrote:
> > > Commits 8a4cd82d ("nfc: fix refcount leak in llcp_sock_connect()")
> > > and c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
> > > fixed a refcount leak bug in bind/connect but introduced a
> > > use-after-free if the same local is assigned to 2 different sockets.
> > >
> > > This can be triggered by the following simple program:
> > >     int sock1 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
> > >     int sock2 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
> > >     memset( &addr, 0, sizeof(struct sockaddr_nfc_llcp) );
> > >     addr.sa_family = AF_NFC;
> > >     addr.nfc_protocol = NFC_PROTO_NFC_DEP;
> > >     bind( sock1, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
> > >     bind( sock2, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
> > >     close(sock1);
> > >     close(sock2);
> > >
> > > Fix this by assigning NULL to llcp_sock->local after calling
> > > nfc_llcp_local_put.
> > >
> > > This addresses CVE-2021-23134.
> > >
> > > Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
> > > Reported-by: Nadav Markus <nmarkus@paloaltonetworks.com>
> > > Fixes: c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
> > > Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
> > > ---
> > >
> > >  net/nfc/llcp_sock.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
> > > index a3b46f888803..53dbe733f998 100644
> > > --- a/net/nfc/llcp_sock.c
> > > +++ b/net/nfc/llcp_sock.c
> > > @@ -109,12 +109,14 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
> > >                                         GFP_KERNEL);
> > >       if (!llcp_sock->service_name) {
> > >               nfc_llcp_local_put(llcp_sock->local);
> > > +             llcp_sock->local = NULL;
> >
> > This "_put() -> set to NULL" pattern can't be correct.
> >
> > You need to fix nfc_llcp_local_get() to use kref_get_unless_zero()
> > and prevent any direct use of llcp_sock->local without taking kref
> > first. The nfc_llcp_local_put() isn't right either.
> >
> > Thanks
