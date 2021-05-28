Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBCA3948C1
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 00:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhE1Wkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 18:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhE1Wkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 18:40:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E4CA61157;
        Fri, 28 May 2021 22:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622241552;
        bh=uG4s31DpKayXAPTteOWnmGY5hDn3xiD3UBYNhVzc0Hw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HICgey24gB093zItTGBzUZedwbzITwl4I5q/fdjnXFM2kRAnsQpsgdBIiLN758w+y
         MyD7SbdhJ7dSJRQyBQ7Q4ZgHRI5RcU7UFtSnLoX/eQz58U3QebZR4GKNt518j1Cqb0
         5OAK9h5RZqX8A2cfCGaFoNR34B/t3f7Afu5O5SqQUa5XQhEAdWeCSWnSC3LzUuShAb
         +DdScFMR9l3oDrR5Qb98X6llXk3V0c+XuhHTlrPWMwqoW/5l99e5btp9Xkb0nq1MzI
         A4H7xbmmWZJx4vqRKCNFJBLmERK+fOaacRPIc2rMf9JCGCcRzU3ndeTGZ8QjCUZMdd
         v8TxHTCcZWYIw==
Date:   Fri, 28 May 2021 15:39:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] udp: fix the len check in udp_lib_getsockopt
Message-ID: <20210528153911.4f67a691@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CADvbK_e0PkKBYAUyg6iYyUwUp+owpv1r9_cnS7pbkLSjwX+VWg@mail.gmail.com>
References: <04cb0c7f6884224c99fbf656579250896af82d5b.1622142759.git.lucien.xin@gmail.com>
        <CADvbK_e0PkKBYAUyg6iYyUwUp+owpv1r9_cnS7pbkLSjwX+VWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 15:13:32 -0400 Xin Long wrote:
> On Thu, May 27, 2021 at 3:12 PM Xin Long <lucien.xin@gmail.com> wrote:
> > Currently, when calling UDP's getsockopt, it only makes sure 'len'
> > is not less than 0, then copys 'len' bytes back to usespace while
> > all data is 'int' type there.
> >
> > If userspace sets 'len' with a value N (N < sizeof(int)), it will
> > only copy N bytes of the data to userspace with no error returned,
> > which doesn't seem right.

I'm not so sure of that. In cases where the value returned may grow
with newer kernel releases truncating the output to the size of buffer
user space provided is pretty normal. I think this code is working as
intended.

> > Like in Chen Yi's case where N is 0, it
> > called getsockopt and got an incorrect value but with no error
> > returned.
> >
> > The patch is to fix the len check and make sure it's not less than
> > sizeof(int). Otherwise, '-EINVAL' is returned, as it does in other
> > protocols like SCTP/TIPC.
> >
> > Reported-by: Chen Yi <yiche@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/ipv4/udp.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 15f5504adf5b..90de2ac70ea9 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -2762,11 +2762,11 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
> >         if (get_user(len, optlen))
> >                 return -EFAULT;
> >
> > -       len = min_t(unsigned int, len, sizeof(int));
> > -
> > -       if (len < 0)
> > +       if (len < sizeof(int))
> >                 return -EINVAL;
> >
> > +       len = sizeof(int);
> > +
> >         switch (optname) {
> >         case UDP_CORK:
> >                 val = up->corkflag;
>
> Note I'm not sure if this fix may break any APP, but the current
> behavior definitely is not correct and doesn't match the man doc
> of getsockopt, so please review.

Can you quote the part of man getsockopt you're referring to?
