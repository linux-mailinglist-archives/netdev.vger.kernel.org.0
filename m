Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1E53062C9
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 18:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343785AbhA0R5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 12:57:22 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:50981 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbhA0R5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 12:57:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1611770222; x=1643306222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=oBCmx3FdugHPO+GPjRs4/lzepwzePrY6ez6VzFxf4w8=;
  b=aj1kVp1TrnHUu/nNcanAVUY+tPwjnhM6MbHv1B4ttmSwPf/MG9W7LsZF
   OREI5WYBEA9XgEQueilyBuyQN5Tz8FyoEeFSKHSd8Otu2xW4xtguJkdYa
   rsJ/H0kpbDFLT3IwvgPzTZFn1jwL5CMXJv1bNgoNxS6MEwDXfY5ETQ6Em
   8=;
X-IronPort-AV: E=Sophos;i="5.79,380,1602547200"; 
   d="scan'208";a="113919538"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 27 Jan 2021 17:56:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 0475DC05B7;
        Wed, 27 Jan 2021 17:56:19 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 27 Jan 2021 17:56:19 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.66) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 27 Jan 2021 17:56:15 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <edumazet@google.com>
CC:     <aams@amazon.de>, <borisp@mellanox.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <tariqt@mellanox.com>
Subject: Re: [PATCH net] net: Remove redundant calls of sk_tx_queue_clear().
Date:   Thu, 28 Jan 2021 02:56:11 +0900
Message-ID: <20210127175611.62871-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <CANn89iKE0GFK1UzQvqYxKKy8E4Qcc57=JFFWCGmtpfgWRhpOpA@mail.gmail.com>
References: <CANn89iKE0GFK1UzQvqYxKKy8E4Qcc57=JFFWCGmtpfgWRhpOpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D14UWB003.ant.amazon.com (10.43.161.162) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Jan 2021 18:34:35 +0100
> On Wed, Jan 27, 2021 at 6:32 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Wed, 27 Jan 2021 18:05:24 +0100
> > > On Wed, Jan 27, 2021 at 5:52 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > >
> > > > From:   Eric Dumazet <edumazet@google.com>
> > > > Date:   Wed, 27 Jan 2021 15:54:32 +0100
> > > > > On Wed, Jan 27, 2021 at 1:50 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > > > >
> > > > > > The commit 41b14fb8724d ("net: Do not clear the sock TX queue in
> > > > > > sk_set_socket()") removes sk_tx_queue_clear() from sk_set_socket() and adds
> > > > > > it instead in sk_alloc() and sk_clone_lock() to fix an issue introduced in
> > > > > > the commit e022f0b4a03f ("net: Introduce sk_tx_queue_mapping"). However,
> > > > > > the original commit had already put sk_tx_queue_clear() in sk_prot_alloc():
> > > > > > the callee of sk_alloc() and sk_clone_lock(). Thus sk_tx_queue_clear() is
> > > > > > called twice in each path currently.
> > > > >
> > > > > Are you sure ?
> > > > >
> > > > > I do not clearly see the sk_tx_queue_clear() call from the cloning part.
> > > > >
> > > > > Please elaborate.
> > > >
> > > > If sk is not NULL in sk_prot_alloc(), sk_tx_queue_clear() is called [1].
> > > > Also the callers of sk_prot_alloc() are only sk_alloc() and sk_clone_lock().
> > > > If they finally return not NULL pointer, sk_tx_queue_clear() is called in
> > > > each function [2][3].
> > > >
> > > > In the cloning part, sock_copy() is called after sk_prot_alloc(), but
> > > > skc_tx_queue_mapping is defined between skc_dontcopy_begin and
> > > > skc_dontcopy_end in struct sock_common [4]. So, sock_copy() does not
> > > > overwrite skc_tx_queue_mapping, and thus we can initialize it in
> > > > sk_prot_alloc().
> > >
> > > That is a lot of assumptions.
> > >
> > > What guarantees do we have that skc_tx_queue_mapping will never be
> > > moved out of this section ?
> > > AFAIK it was there by accident, for cache locality reasons, that might
> > > change in the future as we add more stuff in socket.
> > >
> > > I feel this optimization is risky for future changes, for a code path
> > > that is spending thousands of cycles anyway.
> >
> > If someone try to move skc_tx_queue_mapping out of the section, should
> > they take care about where it is used ?

I'm sorry if it might be misleading, I would like to mean someone/they is
the author of a patch to move skc_tx_queue_mapping.


> Certainly not. You hide some knowledge, without a comment or some runtime check.

It was my bad, I should have written about sock_copy() in the changelog.


> You can not ask us (maintainers) to remember thousands of tricks.

I'll keep this in mind.


> >
> > But I agree that we should not write error-prone code.
> >
> > Currently, sk_tx_queue_clear() is the only initialization code in
> > sk_prot_alloc(). So, does it make sense to remove sk_tx_queue_clear() in
> > sk_prot_alloc() so that it does only allocation and other fields are
> > initialized in each caller ?

Can I ask what you think about this ?


> > > >
> > > > [1] sk_prot_alloc
> > > > https://github.com/torvalds/linux/blob/master/net/core/sock.c#L1693
> > > >
> > > > [2] sk_alloc
> > > > https://github.com/torvalds/linux/blob/master/net/core/sock.c#L1762
> > > >
> > > > [3] sk_clone_lock
> > > > https://github.com/torvalds/linux/blob/master/net/core/sock.c#L1986
> > > >
> > > > [4] struct sock_common
> > > > https://github.com/torvalds/linux/blob/master/include/net/sock.h#L218-L240
> > > >
> > > >
> > > > > In any case, this seems to be a candidate for net-next, this is not
> > > > > fixing a bug,
> > > > > this would be an optimization at most, and potentially adding a bug.
> > > > >
> > > > > So if you resend this patch, you can mention the old commit in the changelog,
> > > > > but do not add a dubious Fixes: tag
> > > >
> > > > I see.
> > > >
> > > > I will remove the tag and resend this as a net-next candidate.
> > > >
> > > > Thank you,
> > > > Kuniyuki
> > > >
> > > >
> > > > > >
> > > > > > This patch removes the redundant calls of sk_tx_queue_clear() in sk_alloc()
> > > > > > and sk_clone_lock().
> > > > > >
> > > > > > Fixes: 41b14fb8724d ("net: Do not clear the sock TX queue in sk_set_socket()")
> > > > > > CC: Tariq Toukan <tariqt@mellanox.com>
> > > > > > CC: Boris Pismenny <borisp@mellanox.com>
> > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > > > Reviewed-by: Amit Shah <aams@amazon.de>
> > > > > > ---
> > > > > >  net/core/sock.c | 2 --
> > > > > >  1 file changed, 2 deletions(-)
> > > > > >
> > > > > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > > > > index bbcd4b97eddd..5c665ee14159 100644
> > > > > > --- a/net/core/sock.c
> > > > > > +++ b/net/core/sock.c
> > > > > > @@ -1759,7 +1759,6 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
> > > > > >                 cgroup_sk_alloc(&sk->sk_cgrp_data);
> > > > > >                 sock_update_classid(&sk->sk_cgrp_data);
> > > > > >                 sock_update_netprioidx(&sk->sk_cgrp_data);
> > > > > > -               sk_tx_queue_clear(sk);
> > > > > >         }
> > > > > >
> > > > > >         return sk;
> > > > > > @@ -1983,7 +1982,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
> > > > > >                  */
> > > > > >                 sk_refcnt_debug_inc(newsk);
> > > > > >                 sk_set_socket(newsk, NULL);
> > > > > > -               sk_tx_queue_clear(newsk);
> > > > > >                 RCU_INIT_POINTER(newsk->sk_wq, NULL);
> > > > > >
> > > > > >                 if (newsk->sk_prot->sockets_allocated)
> > > > > > --
> > > > > > 2.17.2 (Apple Git-113)
> > > > > >
