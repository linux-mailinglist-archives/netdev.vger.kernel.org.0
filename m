Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C5A11D628
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbfLLSrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:47:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:45478 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730258AbfLLSrl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 13:47:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E4DDDAFDF;
        Thu, 12 Dec 2019 18:47:38 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id BC731E0404; Thu, 12 Dec 2019 19:47:37 +0100 (CET)
Date:   Thu, 12 Dec 2019 19:47:37 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Firo Yang <firo.yang@suse.com>
Subject: Re: [PATCH net] tcp/dccp: fix possible race
 __inet_lookup_established()
Message-ID: <20191212184737.GB21497@unicorn.suse.cz>
References: <20191211170943.134769-1-edumazet@google.com>
 <20191212173156.GA21497@unicorn.suse.cz>
 <CANn89i+16zwKepVcHX8a0pz6GrxS+B9y6RiYHL0M-Sn_+Gv1zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+16zwKepVcHX8a0pz6GrxS+B9y6RiYHL0M-Sn_+Gv1zg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 09:43:15AM -0800, Eric Dumazet wrote:
> On Thu, Dec 12, 2019 at 9:32 AM Michal Kubecek <mkubecek@suse.cz> wrote:
> >
> > On Wed, Dec 11, 2019 at 09:09:43AM -0800, Eric Dumazet wrote:
> > > Michal Kubecek and Firo Yang did a very nice analysis of crashes
> > > happening in __inet_lookup_established().
> > >
> > > Since a TCP socket can go from TCP_ESTABLISH to TCP_LISTEN
> > > (via a close()/socket()/listen() cycle) without a RCU grace period,
> > > I should not have changed listeners linkage in their hash table.
> > >
> > > They must use the nulls protocol (Documentation/RCU/rculist_nulls.txt),
> > > so that a lookup can detect a socket in a hash list was moved in
> > > another one.
> > >
> > > Since we added code in commit d296ba60d8e2 ("soreuseport: Resolve
> > > merge conflict for v4/v6 ordering fix"), we have to add
> > > hlist_nulls_add_tail_rcu() helper.
> > >
> > > Fixes: 3b24d854cb35 ("tcp/dccp: do not touch listener sk_refcnt under synflood")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Reported-by: Michal Kubecek <mkubecek@suse.cz>
> > > Reported-by: Firo Yang <firo.yang@suse.com>
> > > Link: https://lore.kernel.org/netdev/20191120083919.GH27852@unicorn.suse.cz/
> > > ---
> > >  include/linux/rculist_nulls.h | 37 +++++++++++++++++++++++++++++++++++
> > >  include/net/inet_hashtables.h | 11 +++++++++--
> > >  include/net/sock.h            |  5 +++++
> > >  net/ipv4/inet_diag.c          |  3 ++-
> > >  net/ipv4/inet_hashtables.c    | 16 +++++++--------
> > >  net/ipv4/tcp_ipv4.c           |  7 ++++---
> > >  6 files changed, 65 insertions(+), 14 deletions(-)
> > >
> > [...]
> > > diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> > > index af2b4c065a042e36135fe6fdcee9833b6b353364..29ef5b7f4005a8e67fd358c136ee6532974efcab 100644
> > > --- a/include/net/inet_hashtables.h
> > > +++ b/include/net/inet_hashtables.h
> > > @@ -105,11 +105,18 @@ struct inet_bind_hashbucket {
> > >
> > >  /*
> > >   * Sockets can be hashed in established or listening table
> > > - */
> > > + * We must use different 'nulls' end-of-chain value for listening
> > > + * hash table, or we might find a socket that was closed and
> > > + * reallocated/inserted into established hash table
> > > +  */
> >
> > Just a nitpick: I don't think this comment is still valid because
> > listening sockets now have RCU protection so that listening socket
> > cannot be freed and reallocated without RCU grace period. (But we still
> > need disjoint ranges to handle the reallocation in the opposite
> > direction.)
> 
> Hi Michal
> 
> I am not a native English speaker, but I was trying to say :
> 
> A lookup in established sockets might go through a socket that
> was in this bucket but has been closed, reallocated and became a listener.

I'm not a native speaker either. What I wanted to point out was that the
comment rather seems to talk about the other direction, i.e. looking up
in listener hashtable and ending up in established due to reallocation.
That was an issue back when the offset was introduced (and when there
was a check of end marker value in __inet_lookup_listener()) but it
cannot happen any more.

> Maybe the comment needs to be refined, but I am not sure how, considering
> that most people reading it will not understand it anyway, given the
> complexity of the nulls stuff.

I guess it can stay as it is. After all, one needs to see the lookup
code to understand the purpose of the offset and then it's easier to see
in the code what is it for.

Michal

> > Other than that, the patch looks good (and better than my
> > work-in-progress patch which I didn't manage to test properly).
> >
> > Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> >
> > > +#define LISTENING_NULLS_BASE (1U << 29)
> > >  struct inet_listen_hashbucket {
> > >       spinlock_t              lock;
> > >       unsigned int            count;
> > > -     struct hlist_head       head;
> > > +     union {
> > > +             struct hlist_head       head;
> > > +             struct hlist_nulls_head nulls_head;
> > > +     };
> > >  };
