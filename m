Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE9757E868
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 22:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiGVUhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 16:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiGVUhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 16:37:42 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EE99E290
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 13:37:37 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2ef5380669cso59161947b3.9
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 13:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6kQ9ks2TEgw64nHcDskFzfZcfxon7lLCFMHEZUNDlUc=;
        b=Yq6DhR7YwwBsetVvd/yTEbsGLNiwCjYt9+kDdwjVvRVFjsHXxMLWf8XqU2wwyZ/rAo
         jaKTEMg5G4l7XirJuElYGoUlOXICzKSqfmUSF7QdbdTnKg5qRiPq7hhwV2wXIjSC/n7+
         SIxt/08NnrdxBhBQuTK9dDWFzMRmQsuW7SOw7V5WqP12KmWkDrbSjI/1XsSqHDwam4h+
         jGwIxvM/uCF1L12bkUipsVqgtMwc/tmQ6+9z0VqEteU9qQbRURmvBrXY++0GxrshBB6t
         sFuYYuWTcY6Y1TgsXsSAmK1ayH68oW4btVE31bU/cH8kaAOwbjyelVI8q+qim9wUwyml
         cnAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6kQ9ks2TEgw64nHcDskFzfZcfxon7lLCFMHEZUNDlUc=;
        b=v2InR+VRUT2UHgqAbbVtZYxY8G4PNgtPeejxSHaALSbS5n0YuCKgx1Woxc7bxjpbrt
         jtegWKMznFAZE1CtilVkvvOp/HOpm/RCoeVSFWNPWQPfkALUvl11IObl/mXF2dbUN4L4
         qRTmz+T/bar9MSI7HLllWvCEYTR/5n+d9Hb8oxVISc2emt3A0NBG+Qc0U/rvAwuJTiHD
         P7RBARVd+elu2uvYUpXW7yqoYnApPu5tpVg1Q219HQ0UOXHrXcOVOAUsYmvMLzTwZmUI
         LM/AD4mPe2WB0tAu05ArewcTKeyBlFUE9axN26toEFOMbvgWffTAnEbRJ0Hz2Bew5Mm3
         DJUA==
X-Gm-Message-State: AJIora+QrsPwYFLlTfsOy9PnB63qLiLDIfbYYP6aQLoBGiN6RmrcOz1j
        em9thPou6pKGGLhYFiw2d8uMZHUa7h/Lk8L/skrw9g==
X-Google-Smtp-Source: AGRyM1uU6CydkWSxoOcjcggzsgJz0Y9reyDKTDEcftYWl0tkM7pSpo6ic2cgcHaedOmJ+/q9sgPdoo9lC5veZmXY924=
X-Received: by 2002:a81:23ce:0:b0:31e:65c1:f4f with SMTP id
 j197-20020a8123ce000000b0031e65c10f4fmr1445966ywj.255.1658522256410; Fri, 22
 Jul 2022 13:37:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com> <20220623043449.1217288-9-edumazet@google.com>
 <20220722193432.zdcnnxyigq2yozok@skbuf>
In-Reply-To: <20220722193432.zdcnnxyigq2yozok@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Jul 2022 22:37:24 +0200
Message-ID: <CANn89iK+UO=FevJxnHN0ua17jwR__MfB_RZ_DavLdJz79eyCBw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 08/19] ipmr: do not acquire mrt_lock while
 calling ip_mr_forward()
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 9:34 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Eric,
>
> On Thu, Jun 23, 2022 at 04:34:38AM +0000, Eric Dumazet wrote:
> > ip_mr_forward() uses standard RCU protection already.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  net/ipv4/ipmr.c | 9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> >
> > diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> > index 6ea54bc3d9b6555aaa9974d81ba4acd47481724f..b0f2e6d79d62273c8c2682f28cb45fe5ec3df6f3 100644
> > --- a/net/ipv4/ipmr.c
> > +++ b/net/ipv4/ipmr.c
> > @@ -1817,7 +1817,7 @@ static bool ipmr_forward_offloaded(struct sk_buff *skb, struct mr_table *mrt,
> >  }
> >  #endif
> >
> > -/* Processing handlers for ipmr_forward */
> > +/* Processing handlers for ipmr_forward, under rcu_read_lock() */
> >
> >  static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
> >                           int in_vifi, struct sk_buff *skb, int vifi)
> > @@ -1839,9 +1839,7 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
> >               WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
> >               vif_dev->stats.tx_bytes += skb->len;
> >               vif_dev->stats.tx_packets++;
> > -             rcu_read_lock();
> >               ipmr_cache_report(mrt, skb, vifi, IGMPMSG_WHOLEPKT);
> > -             rcu_read_unlock();
> >               goto out_free;
> >       }
> >
> > @@ -1936,6 +1934,7 @@ static int ipmr_find_vif(const struct mr_table *mrt, struct net_device *dev)
> >  }
> >
> >  /* "local" means that we should preserve one skb (for local delivery) */
> > +/* Called uner rcu_read_lock() */
> >  static void ip_mr_forward(struct net *net, struct mr_table *mrt,
> >                         struct net_device *dev, struct sk_buff *skb,
> >                         struct mfc_cache *c, int local)
> > @@ -1992,12 +1991,10 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
> >                              c->_c.mfc_un.res.last_assert +
> >                              MFC_ASSERT_THRESH)) {
> >                       c->_c.mfc_un.res.last_assert = jiffies;
> > -                     rcu_read_lock();
> >                       ipmr_cache_report(mrt, skb, true_vifi, IGMPMSG_WRONGVIF);
> >                       if (mrt->mroute_do_wrvifwhole)
> >                               ipmr_cache_report(mrt, skb, true_vifi,
> >                                                 IGMPMSG_WRVIFWHOLE);
> > -                     rcu_read_unlock();
> >               }
> >               goto dont_forward;
> >       }
> > @@ -2169,9 +2166,7 @@ int ip_mr_input(struct sk_buff *skb)
> >               return -ENODEV;
> >       }
> >
> > -     read_lock(&mrt_lock);
> >       ip_mr_forward(net, mrt, dev, skb, cache, local);
> > -     read_unlock(&mrt_lock);
> >
> >       if (local)
> >               return ip_local_deliver(skb);
> > --
> > 2.37.0.rc0.104.g0611611a94-goog
> >
>
> Sorry for reporting this late, but there seems to be 1 call path from
> which RCU is not watching in ip_mr_forward(). It's via ipmr_mfc_add() ->
> ipmr_cache_resolve() -> ip_mr_forward().
>
> The warning looks like this:
>
> [  632.062382] =============================
> [  632.068568] WARNING: suspicious RCU usage
> [  632.073702] 5.19.0-rc7-07010-ga9b9500ffaac-dirty #3374 Not tainted
> [  632.081098] -----------------------------
> [  632.086216] net/ipv4/ipmr.c:1080 suspicious rcu_dereference_check() usage!
> [  632.094152]
> [  632.094152] other info that might help us debug this:
> [  632.103349]
> [  632.103349] rcu_scheduler_active = 2, debug_locks = 1
> [  632.111011] 1 lock held by smcrouted/359:
> [  632.116079]  #0: ffffd27b44d23770 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x1c/0x30
> [  632.124703]
> [  632.124703] stack backtrace:
> [  632.129681] CPU: 0 PID: 359 Comm: smcrouted Not tainted 5.19.0-rc7-07010-ga9b9500ffaac-dirty #3374
> [  632.143426] Call trace:
> [  632.160542]  lockdep_rcu_suspicious+0xf8/0x10c
> [  632.165014]  ipmr_cache_report+0x2f0/0x530
> [  632.169137]  ip_mr_forward+0x364/0x38c
> [  632.172909]  ipmr_mfc_add+0x894/0xc90
> [  632.176592]  ip_mroute_setsockopt+0x6ac/0x950
> [  632.180973]  ip_setsockopt+0x16a0/0x16ac
> [  632.184921]  raw_setsockopt+0x110/0x184
> [  632.188780]  sock_common_setsockopt+0x1c/0x2c
> [  632.193163]  __sys_setsockopt+0x94/0x170
> [  632.197111]  __arm64_sys_setsockopt+0x2c/0x40
> [  632.201492]  invoke_syscall+0x48/0x114
>
> I don't exactly understand the data structures that are used inside ip_mr_forward(),
> so I'm unable to say what needs RCU protection and what is fine with the rtnl_mutex
> that we are holding, just annotated poorly. Could you please take a look?

Thanks for the report.

I guess there are multiple ways to solve this issue, one being:

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 73651d17e51f31c8755da6ac3c1c2763a99b1117..1c288a7b60132365c072874d1f811b70679a2bcb
100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1004,7 +1004,9 @@ static void ipmr_cache_resolve(struct net *net,
struct mr_table *mrt,

                        rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
                } else {
+                       rcu_read_lock();
                        ip_mr_forward(net, mrt, skb->dev, skb, c, 0);
+                       rcu_read_unlock();
                }
        }
 }
@@ -1933,7 +1935,7 @@ static int ipmr_find_vif(const struct mr_table
*mrt, struct net_device *dev)
 }

 /* "local" means that we should preserve one skb (for local delivery) */
-/* Called uner rcu_read_lock() */
+/* Called under rcu_read_lock() */
 static void ip_mr_forward(struct net *net, struct mr_table *mrt,
                          struct net_device *dev, struct sk_buff *skb,
                          struct mfc_cache *c, int local)
