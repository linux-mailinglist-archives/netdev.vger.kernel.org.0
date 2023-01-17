Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA5D66E3BA
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 17:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbjAQQhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 11:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbjAQQgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 11:36:33 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8BE40BD9;
        Tue, 17 Jan 2023 08:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673973387; x=1705509387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nn2BkIRNIFmmDApFWjskyFFViHGsos8gqmoxmmwOQL8=;
  b=ZGoyXkzgsYkOSZTqulzSvhNH/vbntzjEWf+GKWXsbIxWW7Ca9ItSK+0k
   UIeU9itRooz6v//JqxYkn11cm7PDVzUwS/4lVYR/UE9YvGtV69I64c2gi
   jRaq6M/79NhxWvTgzsLoCosuEn1swfjRnzp+o6jFVkEpefbQu6UWcWM/R
   Y=;
X-IronPort-AV: E=Sophos;i="5.97,224,1669075200"; 
   d="scan'208";a="171991209"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 16:34:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id 3BED5C1A38;
        Tue, 17 Jan 2023 16:34:24 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 17 Jan 2023 16:34:24 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.56) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Tue, 17 Jan 2023 16:34:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kerneljasonxing@gmail.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kernelxing@tencent.com>, <kuba@kernel.org>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v5 net] tcp: avoid the lookup process failing to get sk in ehash table
Date:   Tue, 17 Jan 2023 08:34:13 -0800
Message-ID: <20230117163413.6162-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAL+tcoB1-MqMf3Yn_qBTbTC9UNBhVW+93j30KJ9zaangkfQHWA@mail.gmail.com>
References: <CAL+tcoB1-MqMf3Yn_qBTbTC9UNBhVW+93j30KJ9zaangkfQHWA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D44UWB004.ant.amazon.com (10.43.161.205) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 17 Jan 2023 10:15:45 +0800
> On Tue, Jan 17, 2023 at 12:54 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Jason Xing <kerneljasonxing@gmail.com>
> > Date:   Mon, 16 Jan 2023 18:33:41 +0800
> > > From: Jason Xing <kernelxing@tencent.com>
> > >
> > > While one cpu is working on looking up the right socket from ehash
> > > table, another cpu is done deleting the request socket and is about
> > > to add (or is adding) the big socket from the table. It means that
> > > we could miss both of them, even though it has little chance.
> > >
> > > Let me draw a call trace map of the server side.
> > >    CPU 0                           CPU 1
> > >    -----                           -----
> > > tcp_v4_rcv()                  syn_recv_sock()
> > >                             inet_ehash_insert()
> > >                             -> sk_nulls_del_node_init_rcu(osk)
> > > __inet_lookup_established()
> > >                             -> __sk_nulls_add_node_rcu(sk, list)
> > >
> > > Notice that the CPU 0 is receiving the data after the final ack
> > > during 3-way shakehands and CPU 1 is still handling the final ack.
> > >
> > > Why could this be a real problem?
> > > This case is happening only when the final ack and the first data
> > > receiving by different CPUs. Then the server receiving data with
> > > ACK flag tries to search one proper established socket from ehash
> > > table, but apparently it fails as my map shows above. After that,
> > > the server fetches a listener socket and then sends a RST because
> > > it finds a ACK flag in the skb (data), which obeys RST definition
> > > in RFC 793.
> > >
> > > Besides, Eric pointed out there's one more race condition where it
> > > handles tw socket hashdance. Only by adding to the tail of the list
> > > before deleting the old one can we avoid the race if the reader has
> > > already begun the bucket traversal and it would possibly miss the head.
> > >
> > > Many thanks to Eric for great help from beginning to end.
> > >
> > > Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
> > > Suggested-by: Eric Dumazet <edumazet@google.com>
> > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > Link: https://lore.kernel.org/lkml/20230112065336.41034-1-kerneljasonxing@gmail.com/
> >
> > I guess there could be regression if a workload has many long-lived
> 
> Sorry, I don't understand. This patch does not add two kinds of
> sockets into the ehash table all the time, but reverses the order of
> deleting and adding sockets only.

Not really.  It also reverses the order of sockets in ehash.  We were
able to find newer sockets faster than older ones.  If a workload has
many long-lived sockets, they would add constant time on newer socket's
lookup.


> The final result is the same as the
> old time. I'm wondering why it could cause some regressions if there
> are loads of long-lived connections.
> 
> > connections, but the change itself looks good.  I left a minor comment
> > below.
> >
> > Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> >
> 
> Thanks for reviewing :)
> 
> >
> > > ---
> > > v5:
> > > 1) adjust the style once more.
> > >
> > > v4:
> > > 1) adjust the code style and make it easier to read.
> > >
> > > v3:
> > > 1) get rid of else-if statement.
> > >
> > > v2:
> > > 1) adding the sk node into the tail of list to prevent the race.
> > > 2) fix the race condition when handling time-wait socket hashdance.
> > > ---
> > >  net/ipv4/inet_hashtables.c    | 17 +++++++++++++++--
> > >  net/ipv4/inet_timewait_sock.c |  6 +++---
> > >  2 files changed, 18 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > > index 24a38b56fab9..f58d73888638 100644
> > > --- a/net/ipv4/inet_hashtables.c
> > > +++ b/net/ipv4/inet_hashtables.c
> > > @@ -650,8 +650,20 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> > >       spin_lock(lock);
> > >       if (osk) {
> > >               WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> > > -             ret = sk_nulls_del_node_init_rcu(osk);
> > > -     } else if (found_dup_sk) {
> > > +             ret = sk_hashed(osk);
> > > +             if (ret) {
> > > +                     /* Before deleting the node, we insert a new one to make
> > > +                      * sure that the look-up-sk process would not miss either
> > > +                      * of them and that at least one node would exist in ehash
> > > +                      * table all the time. Otherwise there's a tiny chance
> > > +                      * that lookup process could find nothing in ehash table.
> > > +                      */
> > > +                     __sk_nulls_add_node_tail_rcu(sk, list);
> > > +                     sk_nulls_del_node_init_rcu(osk);
> > > +             }
> > > +             goto unlock;
> > > +     }
> > > +     if (found_dup_sk) {
> > >               *found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
> > >               if (*found_dup_sk)
> > >                       ret = false;
> > > @@ -660,6 +672,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> > >       if (ret)
> > >               __sk_nulls_add_node_rcu(sk, list);
> > >
> > > +unlock:
> > >       spin_unlock(lock);
> > >
> > >       return ret;
> > > diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> > > index 1d77d992e6e7..6d681ef52bb2 100644
> > > --- a/net/ipv4/inet_timewait_sock.c
> > > +++ b/net/ipv4/inet_timewait_sock.c
> > > @@ -91,10 +91,10 @@ void inet_twsk_put(struct inet_timewait_sock *tw)
> > >  }
> > >  EXPORT_SYMBOL_GPL(inet_twsk_put);
> > >
> > > -static void inet_twsk_add_node_rcu(struct inet_timewait_sock *tw,
> > > +static void inet_twsk_add_node_tail_rcu(struct inet_timewait_sock *tw,
> > >                                  struct hlist_nulls_head *list)
> >
> > nit: Please indent here.
> >
> 
> Before I submitted the patch, I did the check through
> ./script/checkpatch.py and it outputted some information (no warning,
> no error) as you said.
> The reason I didn't change that is I would like to leave this part
> untouch as it used to be. I have no clue about whether I should send a
> v7 patch to adjust the format if necessary.

checkpatch.pl does not check everything.  You will find most functions
under net/ipv4/*.c have same indentation in arguments.  I would recommend
enforcing such styles on editor like

  $ cat ~/.emacs.d/init.el
  (setq-default c-default-style "linux")

Thanks,
Kuniyuki

> 
> Thanks,
> Jason
> 
> >
> > >  {
> > > -     hlist_nulls_add_head_rcu(&tw->tw_node, list);
> > > +     hlist_nulls_add_tail_rcu(&tw->tw_node, list);
> > >  }
> > >
> > >  static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
> > > @@ -147,7 +147,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
> > >
> > >       spin_lock(lock);
> > >
> > > -     inet_twsk_add_node_rcu(tw, &ehead->chain);
> > > +     inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
> > >
> > >       /* Step 3: Remove SK from hash chain */
> > >       if (__sk_nulls_del_node_init_rcu(sk))
> > > --
> > > 2.37.3
