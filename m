Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249DA21C6F5
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 03:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgGLBkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 21:40:07 -0400
Received: from smtp.netregistry.net ([202.124.241.204]:55158 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgGLBkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 21:40:07 -0400
Received: from pa49-197-151-134.pa.qld.optusnet.com.au ([49.197.151.134]:25673 helo=localhost)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1juQyJ-0001vL-3R; Sun, 12 Jul 2020 11:40:05 +1000
Date:   Sun, 12 Jul 2020 11:40:01 +1000
From:   Russell Strong <russell@strong.id.au>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: amplifying qdisc
Message-ID: <20200712114001.27b6399c@strong.id.au>
In-Reply-To: <20200708232634.0fa0ca19@hermes.lan>
References: <20200709161034.71bf8e09@strong.id.au>
        <20200708232634.0fa0ca19@hermes.lan>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated-User: russell@strong.id.au
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jul 2020 23:26:34 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Thu, 9 Jul 2020 16:10:34 +1000
> Russell Strong <russell@strong.id.au> wrote:
> 
> > Hi,
> > 
> > I'm attempting to fill a link with background traffic that is sent
> > whenever the link is idle.  To do this I've creates a qdisc that
> > will repeat the last packet in the queue for a defined number of
> > times (possibly infinite in the future). I am able to control the
> > contents of the fill traffic by sending the occasional packet
> > through this qdisc.
> > 
> > This is works as the root qdisc and below a TBF.  When I try it as a
> > leaf of HTB unexpected behaviour ensues.  I suspect my approach is
> > violating some rules for qdiscs?  Any help/ideas/pointers would be
> > appreciated.  
> 
> Netem can already do things like this. Why not add to that
> 

Hi,

Tried doing this within netem as follows; but run into similar
problems.  Works as the root qdisc (except for "Route cache is full:
consider increasing sysctl net.ipv[4|6].route.max_size.") but not under
htb.  I am attempting to duplicate at dequeue, rather than enqueue to
get an infinite stream of packets rather than a fixed number of
duplicates. Is this possible?

Thanks
Russell


diff --git a/sch_netem.c b/sch_netem.c
index 42e557d..9a674df 100644
--- a/sch_netem.c
+++ b/sch_netem.c
@@ -98,6 +98,7 @@ struct netem_sched_data {
        u32 cell_size;
        struct reciprocal_value cell_size_reciprocal;
        s32 cell_overhead;
+       u32 repeat_last;
 
        struct crndstate {
                u32 last;
@@ -697,9 +698,13 @@ deliver:
                        get_slot_next(q, now);
 
                if (time_to_send <= now && q->slot.slot_next <= now) {
-                       netem_erase_head(q, skb);
-                       sch->q.qlen--;
-                       qdisc_qstats_backlog_dec(sch, skb);
+                       if (sch->q.qlen == 1 && q->repeat_last)
+                               skb = skb_clone(skb, GFP_ATOMIC);
+                       else {
+                               netem_erase_head(q, skb);
+                               sch->q.qlen--;
+                               qdisc_qstats_backlog_dec(sch, skb);
+                       }
                        skb->next = NULL;
                        skb->prev = NULL;
                        /* skb->dev shares skb->rbnode area,
@@ -1061,6 +1066,7 @@ static int netem_init(struct Qdisc *sch, struct
nlattr *opt, return -EINVAL;
 
        q->loss_model = CLG_RANDOM;
+       q->repeat_last = 1;
        ret = netem_change(sch, opt, extack);
        if (ret)
                pr_info("netem: change failed\n");
