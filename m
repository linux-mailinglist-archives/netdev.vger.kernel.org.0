Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A8A306321
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 19:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbhA0SVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 13:21:53 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:58181 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbhA0SVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 13:21:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1611771705; x=1643307705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=0PJy0cKEfx2WalfT8psJXM4GjVBoYuSqD130k7giwwY=;
  b=AvssmrAEhOY98qJ0KY3S4F/dpuFmcis6zDSL6sNkIxC5Qfj84/oa9NQY
   x00ZM0tkgndnciUHs5ruTjGOuiPXDiyiiUqG/3IqSfARzIF5g+dmI20LH
   kSdnMpT2+mBt+8dBkIQdgB+6ipdBd0Sp3M0wcbvW8J66fLStm+vcDULkE
   o=;
X-IronPort-AV: E=Sophos;i="5.79,380,1602547200"; 
   d="scan'208";a="80551244"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 27 Jan 2021 18:21:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 4AB14A186C;
        Wed, 27 Jan 2021 18:21:02 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 27 Jan 2021 18:21:01 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.132) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 27 Jan 2021 18:20:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <edumazet@google.com>
CC:     <aams@amazon.de>, <borisp@mellanox.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <tariqt@mellanox.com>
Subject: Re: [PATCH net] net: Remove redundant calls of sk_tx_queue_clear().
Date:   Thu, 28 Jan 2021 03:20:54 +0900
Message-ID: <20210127182054.64774-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <CANn89iJbtbMJ1gC2e8P7v+rB+EON=Y-i0B2mQ5kGQOqJMk=G=A@mail.gmail.com>
References: <CANn89iJbtbMJ1gC2e8P7v+rB+EON=Y-i0B2mQ5kGQOqJMk=G=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.132]
X-ClientProxiedBy: EX13D35UWB002.ant.amazon.com (10.43.161.154) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Jan 2021 19:07:51 +0100
> On Wed, Jan 27, 2021 at 6:56 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Wed, 27 Jan 2021 18:34:35 +0100
> > > On Wed, Jan 27, 2021 at 6:32 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > >
> > > > From:   Eric Dumazet <edumazet@google.com>
> > > > Date:   Wed, 27 Jan 2021 18:05:24 +0100
> > > > > On Wed, Jan 27, 2021 at 5:52 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > > > >
> > > > > > From:   Eric Dumazet <edumazet@google.com>
> > > > > > Date:   Wed, 27 Jan 2021 15:54:32 +0100
> > > > > > > On Wed, Jan 27, 2021 at 1:50 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > > > > > >
> > > > > > > > The commit 41b14fb8724d ("net: Do not clear the sock TX queue in
> > > > > > > > sk_set_socket()") removes sk_tx_queue_clear() from sk_set_socket() and adds
> > > > > > > > it instead in sk_alloc() and sk_clone_lock() to fix an issue introduced in
> > > > > > > > the commit e022f0b4a03f ("net: Introduce sk_tx_queue_mapping"). However,
> > > > > > > > the original commit had already put sk_tx_queue_clear() in sk_prot_alloc():
> > > > > > > > the callee of sk_alloc() and sk_clone_lock(). Thus sk_tx_queue_clear() is
> > > > > > > > called twice in each path currently.
> > > > > > >
> > > > > > > Are you sure ?
> > > > > > >
> > > > > > > I do not clearly see the sk_tx_queue_clear() call from the cloning part.
> > > > > > >
> > > > > > > Please elaborate.
> > > > > >
> > > > > > If sk is not NULL in sk_prot_alloc(), sk_tx_queue_clear() is called [1].
> > > > > > Also the callers of sk_prot_alloc() are only sk_alloc() and sk_clone_lock().
> > > > > > If they finally return not NULL pointer, sk_tx_queue_clear() is called in
> > > > > > each function [2][3].
> > > > > >
> > > > > > In the cloning part, sock_copy() is called after sk_prot_alloc(), but
> > > > > > skc_tx_queue_mapping is defined between skc_dontcopy_begin and
> > > > > > skc_dontcopy_end in struct sock_common [4]. So, sock_copy() does not
> > > > > > overwrite skc_tx_queue_mapping, and thus we can initialize it in
> > > > > > sk_prot_alloc().
> > > > >
> > > > > That is a lot of assumptions.
> > > > >
> > > > > What guarantees do we have that skc_tx_queue_mapping will never be
> > > > > moved out of this section ?
> > > > > AFAIK it was there by accident, for cache locality reasons, that might
> > > > > change in the future as we add more stuff in socket.
> > > > >
> > > > > I feel this optimization is risky for future changes, for a code path
> > > > > that is spending thousands of cycles anyway.
> > > >
> > > > If someone try to move skc_tx_queue_mapping out of the section, should
> > > > they take care about where it is used ?
> >
> > I'm sorry if it might be misleading, I would like to mean someone/they is
> > the author of a patch to move skc_tx_queue_mapping.
> >
> >
> > > Certainly not. You hide some knowledge, without a comment or some runtime check.
> >
> > It was my bad, I should have written about sock_copy() in the changelog.
> 
> I think you also want to add some compile time check.
> 
> BUILD_BUG_ON( skc_tx_queue_mapping is in the no copy area)
> 
> Because maintainers do not remember changelogs in their mind.

I understand.

The proper place to add BUILD_BUG_ON() is sock_copy() or sk_clone_lock() ?


> >
> >
> > > You can not ask us (maintainers) to remember thousands of tricks.
> >
> > I'll keep this in mind.
> >
> >
> > > >
> > > > But I agree that we should not write error-prone code.
> > > >
> > > > Currently, sk_tx_queue_clear() is the only initialization code in
> > > > sk_prot_alloc(). So, does it make sense to remove sk_tx_queue_clear() in
> > > > sk_prot_alloc() so that it does only allocation and other fields are
> > > > initialized in each caller ?
> >
> > Can I ask what you think about this ?
> 
> Yes, this would be fine.

Thank you, I will remove the sk_tx_queue_clear() in sk_prot_alloc().


> >
> > > > > >
> > > > > > [1] sk_prot_alloc
> > > > > > https://github.com/torvalds/linux/blob/master/net/core/sock.c#L1693
> > > > > >
> > > > > > [2] sk_alloc
> > > > > > https://github.com/torvalds/linux/blob/master/net/core/sock.c#L1762
> > > > > >
> > > > > > [3] sk_clone_lock
> > > > > > https://github.com/torvalds/linux/blob/master/net/core/sock.c#L1986
> > > > > >
> > > > > > [4] struct sock_common
> > > > > > https://github.com/torvalds/linux/blob/master/include/net/sock.h#L218-L240
> > > > > >
> > > > > >
> > > > > > > In any case, this seems to be a candidate for net-next, this is not
> > > > > > > fixing a bug,
> > > > > > > this would be an optimization at most, and potentially adding a bug.
> > > > > > >
> > > > > > > So if you resend this patch, you can mention the old commit in the changelog,
> > > > > > > but do not add a dubious Fixes: tag
> > > > > >
> > > > > > I see.
> > > > > >
> > > > > > I will remove the tag and resend this as a net-next candidate.
> > > > > >
> > > > > > Thank you,
> > > > > > Kuniyuki
> > > > > >
> > > > > >
> > > > > > > >
> > > > > > > > This patch removes the redundant calls of sk_tx_queue_clear() in sk_alloc()
> > > > > > > > and sk_clone_lock().
> > > > > > > >
> > > > > > > > Fixes: 41b14fb8724d ("net: Do not clear the sock TX queue in sk_set_socket()")
> > > > > > > > CC: Tariq Toukan <tariqt@mellanox.com>
> > > > > > > > CC: Boris Pismenny <borisp@mellanox.com>
> > > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > > > > > Reviewed-by: Amit Shah <aams@amazon.de>
> > > > > > > > ---
> > > > > > > >  net/core/sock.c | 2 --
> > > > > > > >  1 file changed, 2 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > > > > > > index bbcd4b97eddd..5c665ee14159 100644
> > > > > > > > --- a/net/core/sock.c
> > > > > > > > +++ b/net/core/sock.c
> > > > > > > > @@ -1759,7 +1759,6 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
> > > > > > > >                 cgroup_sk_alloc(&sk->sk_cgrp_data);
> > > > > > > >                 sock_update_classid(&sk->sk_cgrp_data);
> > > > > > > >                 sock_update_netprioidx(&sk->sk_cgrp_data);
> > > > > > > > -               sk_tx_queue_clear(sk);
> > > > > > > >         }
> > > > > > > >
> > > > > > > >         return sk;
> > > > > > > > @@ -1983,7 +1982,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
> > > > > > > >                  */
> > > > > > > >                 sk_refcnt_debug_inc(newsk);
> > > > > > > >                 sk_set_socket(newsk, NULL);
> > > > > > > > -               sk_tx_queue_clear(newsk);
> > > > > > > >                 RCU_INIT_POINTER(newsk->sk_wq, NULL);
> > > > > > > >
> > > > > > > >                 if (newsk->sk_prot->sockets_allocated)
> > > > > > > > --
> > > > > > > > 2.17.2 (Apple Git-113)
> > > > > > > >
