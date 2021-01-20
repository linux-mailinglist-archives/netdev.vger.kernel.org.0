Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6DE2FD640
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 17:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391687AbhATQ6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 11:58:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:57048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391595AbhATQ6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 11:58:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F299123358;
        Wed, 20 Jan 2021 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611161852;
        bh=u+6rcQmeDhL1NAyEhUPgZGBH+HZF9sOcBSQlmtfRPWo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V/URu8awx9yzmkYvPFKklqQ7tQj7q4CDNsT/zOBhHyo6NihSBIXoSn+SFVyAspNXK
         /+7qzh9zdlTdfaiq9ygDbIZlHhwW4XXv3MCvNludWOn344dSVniW6NV91pUu4Y4aBI
         /hnjEMjW55gFaBl7vR9+3eGUGl3PRxsHiPI5DnHpIQw5KM4atP4q8LPpkGVq2e32Lf
         OH0xfDWI+tLIHpxzH8XeLvs8dgc4hCtfN/JKSO8SN3XeCiiWTZJOU2rjuIz6FufXvs
         2xhnzTnYqcq43LRPa/QfebRKk6Ug738GH0MPhsalf4ygTb/S9VEGL8c0NWnnRvw6JM
         TBpWByWIkQArA==
Date:   Wed, 20 Jan 2021 08:57:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Ricardo Dias <rdias@singlestore.com>
Subject: Re: [PATCH net] tcp: Fix potential use-after-free due to double
 kfree().
Message-ID: <20210120085730.54e74b59@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iLF4SA_En=sLzEdXByA=m93+EoWKngSZtb4SfeE=8uO9A@mail.gmail.com>
References: <20210118055920.82516-1-kuniyu@amazon.co.jp>
        <20210119171745.6840e3a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iLF4SA_En=sLzEdXByA=m93+EoWKngSZtb4SfeE=8uO9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 14:07:35 +0100 Eric Dumazet wrote:
> On Wed, Jan 20, 2021 at 2:17 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 18 Jan 2021 14:59:20 +0900 Kuniyuki Iwashima wrote:  
> > > Receiving ACK with a valid SYN cookie, cookie_v4_check() allocates struct
> > > request_sock and then can allocate inet_rsk(req)->ireq_opt. After that,
> > > tcp_v4_syn_recv_sock() allocates struct sock and copies ireq_opt to
> > > inet_sk(sk)->inet_opt. Normally, tcp_v4_syn_recv_sock() inserts the full
> > > socket into ehash and sets NULL to ireq_opt. Otherwise,
> > > tcp_v4_syn_recv_sock() has to reset inet_opt by NULL and free the full
> > > socket.
> > >
> > > The commit 01770a1661657 ("tcp: fix race condition when creating child
> > > sockets from syncookies") added a new path, in which more than one cores
> > > create full sockets for the same SYN cookie. Currently, the core which
> > > loses the race frees the full socket without resetting inet_opt, resulting
> > > in that both sock_put() and reqsk_put() call kfree() for the same memory:
> > >
> > >   sock_put
> > >     sk_free
> > >       __sk_free
> > >         sk_destruct
> > >           __sk_destruct
> > >             sk->sk_destruct/inet_sock_destruct
> > >               kfree(rcu_dereference_protected(inet->inet_opt, 1));
> > >
> > >   reqsk_put
> > >     reqsk_free
> > >       __reqsk_free
> > >         req->rsk_ops->destructor/tcp_v4_reqsk_destructor
> > >           kfree(rcu_dereference_protected(inet_rsk(req)->ireq_opt, 1));
> > >
> > > Calling kmalloc() between the double kfree() can lead to use-after-free, so
> > > this patch fixes it by setting NULL to inet_opt before sock_put().
> > >
> > > As a side note, this kind of issue does not happen for IPv6. This is
> > > because tcp_v6_syn_recv_sock() clones both ipv6_opt and pktopts which
> > > correspond to ireq_opt in IPv4.
> > >
> > > Fixes: 01770a166165 ("tcp: fix race condition when creating child sockets from syncookies")
> > > CC: Ricardo Dias <rdias@singlestore.com>
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>  
> >
> > Ricardo, Eric, any reason this was written this way?  
> 
> Well, I guess that was a plain bug.
> 
> IPv4 options are not used often I think.

I see.

> Reviewed-by: Eric Dumazet <edumazet@google.com>

Applied, thank you!
