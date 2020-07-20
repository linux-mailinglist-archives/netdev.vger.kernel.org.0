Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3084E225586
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGTBj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:39:57 -0400
Received: from smtp.netregistry.net ([202.124.241.204]:57796 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgGTBj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 21:39:57 -0400
Received: from 193-116-245-241.tpgi.com.au ([193.116.245.241]:42245 helo=localhost)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1jxKmF-0006qs-J6; Mon, 20 Jul 2020 11:39:54 +1000
Date:   Mon, 20 Jul 2020 11:39:33 +1000
From:   Russell Strong <russell@strong.id.au>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: amplifying qdisc
Message-ID: <20200720113933.15bf482c@strong.id.au>
In-Reply-To: <20200713095228.5867b7ec@hermes.lan>
References: <20200709161034.71bf8e09@strong.id.au>
        <20200708232634.0fa0ca19@hermes.lan>
        <20200712114001.27b6399c@strong.id.au>
        <20200713095228.5867b7ec@hermes.lan>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated-User: russell@strong.id.au
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 09:52:28 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Sun, 12 Jul 2020 11:40:01 +1000
> Russell Strong <russell@strong.id.au> wrote:
> 
> > On Wed, 8 Jul 2020 23:26:34 -0700
> > Stephen Hemminger <stephen@networkplumber.org> wrote:
> >   
> > > On Thu, 9 Jul 2020 16:10:34 +1000
> > > Russell Strong <russell@strong.id.au> wrote:
> > >     
> > > > Hi,
> > > > 
> > > > I'm attempting to fill a link with background traffic that is
> > > > sent whenever the link is idle.  To do this I've creates a
> > > > qdisc that will repeat the last packet in the queue for a
> > > > defined number of times (possibly infinite in the future). I am
> > > > able to control the contents of the fill traffic by sending the
> > > > occasional packet through this qdisc.
> > > > 
> > > > This is works as the root qdisc and below a TBF.  When I try it
> > > > as a leaf of HTB unexpected behaviour ensues.  I suspect my
> > > > approach is violating some rules for qdiscs?  Any
> > > > help/ideas/pointers would be appreciated.      
> > > 
> > > Netem can already do things like this. Why not add to that
> > >     
> > 
> > Hi,
> > 
> > Tried doing this within netem as follows; but run into similar
> > problems.  Works as the root qdisc (except for "Route cache is full:
> > consider increasing sysctl net.ipv[4|6].route.max_size.") but not
> > under htb.  I am attempting to duplicate at dequeue, rather than
> > enqueue to get an infinite stream of packets rather than a fixed
> > number of duplicates. Is this possible?
> > 
> > Thanks
> > Russell  
> 
> HTB expects any thing under it to be work conserving.

Thanks for the tip.  I've tried a new approach using tasklets that
appears to be working fine both as the root qdisc and under htb.

Basically, at dequeue, if the qlen drops below 1/2, a tasklet is
scheduled that generates more packets to fill the queue via
dev_queue_xmit.  By generating off the queue length I can avoid the
dropped packets I was getting from pktgen. Sound sane?

Next I would like to add netlink control over the packet size mix and
contents that would be dynamically updated.

This code is big hands, small map stuff to see how it might work.
Does this kind of functionality fit well with netem?

I was always intending to use it in conjunction with other qdiscs and
IPSec to obscure traffic patterns without adding too much latency or
load that might interfere with the real traffic.

diff --git a/sch_netem.c b/sch_netem.c
index 42e557d..a6eef95 100644
--- a/sch_netem.c
+++ b/sch_netem.c
@@ -145,6 +145,9 @@ struct netem_sched_data {
        } slot;
 
        struct disttable *slot_dist;
+
+       u32 fill_imix;
+       struct tasklet_struct tasklet;
 };
 
 /* Time stamp put into socket buffer control block
@@ -673,6 +676,70 @@ static void netem_erase_head(struct netem_sched_data *q, struct sk_buff *skb)
        }
 }
 
+static unsigned char template_packet[] = {
+        0x32, 0xf2, 0xa9, 0x7d, 0xfe, 0xeb,     // dst mac
+        0x06, 0x1d, 0x01, 0x59, 0x3d, 0x20,     // src mac
+
+        0x86, 0xdd,                             // eth type
+
+        0x61, 0x00, 0x00, 0x00,                 // ipv6 version + tclass + flowlabel
+
+        0x00, 0x00,                             // payload length
+
+        0x3b,                                   // next header ( no next header )
+
+        0x01,                                   // hop limit
+
+        0xfe, 0x80, 0x00, 0x00,                 // source
+        0x00, 0x00, 0x00, 0x00,
+        0x00, 0x00, 0x00, 0x00,
+        0x00, 0x00, 0x00, 0x01,
+
+        0xfe, 0x80, 0x00, 0x00,                 // destination
+        0x00, 0x00, 0x00, 0x00,
+        0x00, 0x00, 0x00, 0x00,
+        0x00, 0x00, 0x00, 0x02,
+
+        0x00, 0x00                              // pad to 8 align
+};
+
+static void generate_packets(unsigned long data)
+{
+        int i;
+        struct sk_buff *skb;
+        struct Qdisc *sch = (struct Qdisc *)data;
+
+        for (i = 0; i < sch->limit - sch->q.qlen; i++) {
+                u16 r, len;
+
+                get_random_bytes(&r, sizeof(r));
+
+                // perturbed IMIX
+                if (r % 12 < 7)
+                        len = 14 + 40 + 30 + (r % 20);
+                else if (r % 12 < 11)
+                        len = 14 + 40 + 526 + (r % 100);
+                else
+                        len = qdisc_dev(sch)->mtu;
+
+                skb = alloc_skb(len + 512, GFP_ATOMIC);
+                if (!skb)
+                        return;
+
+                skb_reserve(skb, 256);
+                skb_reset_mac_header(skb);
+                skb_put(skb, len);
+                template_packet[18] = (len - (14 + 40)) / 256;
+                template_packet[19] = (len - (14 + 40)) % 256;
+                memcpy(skb_mac_header(skb), template_packet, sizeof(template_packet));
+
+                skb->dev = qdisc_dev(sch);
+                skb->priority = 0x10;
+
+                dev_queue_xmit(skb);
+        }
+}
+
 static struct sk_buff *netem_dequeue(struct Qdisc *sch)
 {
        struct netem_sched_data *q = qdisc_priv(sch);
@@ -683,6 +750,8 @@ tfifo_dequeue:
        if (skb) {
                qdisc_qstats_backlog_dec(sch, skb);
 deliver:
+               if (q->fill_imix && sch->q.qlen < sch->limit / 2)
+                       tasklet_schedule(&q->tasklet);
                qdisc_bstats_update(sch, skb);
                return skb;
        }
@@ -1055,6 +1124,10 @@ static int netem_init(struct Qdisc *sch, struct nlattr *opt,
        struct netem_sched_data *q = qdisc_priv(sch);
        int ret;
 
+       tasklet_init(&q->tasklet, generate_packets, (unsigned long)sch);
+       tasklet_schedule(&q->tasklet);
+       q->fill_imix = 1;
+
        qdisc_watchdog_init(&q->watchdog, sch);
 
        if (!opt)
@@ -1071,6 +1144,8 @@ static void netem_destroy(struct Qdisc *sch)
 {
        struct netem_sched_data *q = qdisc_priv(sch);
 
+       tasklet_kill(&q->tasklet);
+
        qdisc_watchdog_cancel(&q->watchdog);
        if (q->qdisc)
                qdisc_put(q->qdisc);
