Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB9F17FD3D
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 17:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388518AbfHBPPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 11:15:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39050 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbfHBPPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 11:15:09 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so24394083wrt.6
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 08:15:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=cqxm2KiKVjsjAtUFJ1sTG6D7W241tUcM9JxqzFoB3PY=;
        b=cfAYlhTtMlJ6cXiTWH1LsZr+EiNDgkHKwFAR9kQNAdp/6s6b61sjyLQm2Mn81ZoC+v
         if02WiBeh6pJHPURqiXh4dEAwjRWmpwP0DTWpn8mTRLVHb+yFiq9M3gBTEDJnK8zQbwz
         5hm3HPIAQj7qCbeWRlzASaz9oX1RGRUutBMb/pdDs4JqaRH5liMRAtZrUgfejg96dLZT
         Z4txXlhbuAQRVHagQoty797kw1xWP68nRAkYEYnkHD7+wlUAECEdt2hs79tiaw+8MGup
         udg6/wR2Mnpq4/lMvu0jjwwQDrk+hilZEao0TQwmEb9L17unuupidA5U8VWEM6x7bu5s
         9JEQ==
X-Gm-Message-State: APjAAAVMMp4xYVFjZzJR98rgwG/29lhVZIEEJQB5QJ0zR86XsM8nKxmi
        fi87KArUnqeOaI1PxDHPncp19gyCuLc=
X-Google-Smtp-Source: APXvYqxJDdZVTqV89j9SLSFQLKUZCiMnnJGpZQAxW5N4A7szx293BlUPes0qobtLborF61Ij9QYYTQ==
X-Received: by 2002:adf:e2c1:: with SMTP id d1mr154299118wrj.283.1564758905850;
        Fri, 02 Aug 2019 08:15:05 -0700 (PDT)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id r15sm80593618wrj.68.2019.08.02.08.15.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 08:15:05 -0700 (PDT)
Date:   Fri, 2 Aug 2019 17:15:03 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        Peter Oskolkov <posk@google.com>,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCH net] inet: frags: re-introduce skb coalescing for local
 delivery
Message-ID: <22d8da10c97214edd0677e6478093ad9376180ef.1564758715.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before commit d4289fcc9b16 ("net: IP6 defrag: use rbtrees for IPv6
defrag"), a netperf UDP_STREAM test[0] using big IPv6 datagrams (thus
generating many fragments) and running over an IPsec tunnel, reported
more than 6Gbps throughput. After that patch, the same test gets only
9Mbps when receiving on a be2net nic (driver can make a big difference
here, for example, ixgbe doesn't seem to be affected).

By reusing the IPv4 defragmentation code, IPv6 lost fragment coalescing
(IPv4 fragment coalescing was dropped by commit 14fe22e33462 ("Revert
"ipv4: use skb coalescing in defragmentation"")).

Without fragment coalescing, be2net runs out of Rx ring entries and
starts to drop frames (ethtool reports rx_drops_no_frags errors). Since
the netperf traffic is only composed of UDP fragments, any lost packet
prevents reassembly of the full datagram. Therefore, fragments which
have no possibility to ever get reassembled pile up in the reassembly
queue, until the memory accounting exeeds the threshold. At that point
no fragment is accepted anymore, which effectively discards all
netperf traffic.

When reassembly timeout expires, some stale fragments are removed from
the reassembly queue, so a few packets can be received, reassembled
and delivered to the netperf receiver. But the nic still drops frames
and soon the reassembly queue gets filled again with stale fragments.
These long time frames where no datagram can be received explain why
the performance drop is so significant.

Re-introducing fragment coalescing is enough to get the initial
performances again (6.6Gbps with be2net): driver doesn't drop frames
anymore (no more rx_drops_no_frags errors) and the reassembly engine
works at full speed.

This patch is quite conservative and only coalesces skbs for local
IPv4 and IPv6 delivery (in order to avoid changing skb geometry when
forwarding). Coalescing could be extended in the future if need be, as
more scenarios would probably benefit from it.

[0]: Test configuration
Sender:
ip xfrm policy flush
ip xfrm state flush
ip xfrm state add src fc00:1::1 dst fc00:2::1 proto esp spi 0x1000 aead 'rfc4106(gcm(aes))' 0x0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b 96 mode transport sel src fc00:1::1 dst fc00:2::1
ip xfrm policy add src fc00:1::1 dst fc00:2::1 dir in tmpl src fc00:1::1 dst fc00:2::1 proto esp mode transport action allow
ip xfrm state add src fc00:2::1 dst fc00:1::1 proto esp spi 0x1001 aead 'rfc4106(gcm(aes))' 0x0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b 96 mode transport sel src fc00:2::1 dst fc00:1::1
ip xfrm policy add src fc00:2::1 dst fc00:1::1 dir out tmpl src fc00:2::1 dst fc00:1::1 proto esp mode transport action allow
netserver -D -L fc00:2::1

Receiver:
ip xfrm policy flush
ip xfrm state flush
ip xfrm state add src fc00:2::1 dst fc00:1::1 proto esp spi 0x1001 aead 'rfc4106(gcm(aes))' 0x0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b 96 mode transport sel src fc00:2::1 dst fc00:1::1
ip xfrm policy add src fc00:2::1 dst fc00:1::1 dir in tmpl src fc00:2::1 dst fc00:1::1 proto esp mode transport action allow
ip xfrm state add src fc00:1::1 dst fc00:2::1 proto esp spi 0x1000 aead 'rfc4106(gcm(aes))' 0x0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b 96 mode transport sel src fc00:1::1 dst fc00:2::1
ip xfrm policy add src fc00:1::1 dst fc00:2::1 dir out tmpl src fc00:1::1 dst fc00:2::1 proto esp mode transport action allow
netperf -H fc00:2::1 -f k -P 0 -L fc00:1::1 -l 60 -t UDP_STREAM -I 99,5 -i 5,5 -T5,5 -6

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/inet_frag.h                 |  2 +-
 net/ieee802154/6lowpan/reassembly.c     |  2 +-
 net/ipv4/inet_fragment.c                | 39 ++++++++++++++++++-------
 net/ipv4/ip_fragment.c                  |  8 ++++-
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 net/ipv6/reassembly.c                   |  2 +-
 6 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 010f26b31c89..bac79e817776 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -171,7 +171,7 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 			      struct sk_buff *parent);
 void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
-			    void *reasm_data);
+			    void *reasm_data, bool try_coalesce);
 struct sk_buff *inet_frag_pull_head(struct inet_frag_queue *q);
 
 #endif
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index e4aba5d485be..bbe9b3b2d395 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -170,7 +170,7 @@ static int lowpan_frag_reasm(struct lowpan_frag_queue *fq, struct sk_buff *skb,
 	reasm_data = inet_frag_reasm_prepare(&fq->q, skb, prev_tail);
 	if (!reasm_data)
 		goto out_oom;
-	inet_frag_reasm_finish(&fq->q, skb, reasm_data);
+	inet_frag_reasm_finish(&fq->q, skb, reasm_data, false);
 
 	skb->dev = ldev;
 	skb->tstamp = fq->q.stamp;
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index a999451345f9..10d31733297d 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -475,11 +475,12 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 EXPORT_SYMBOL(inet_frag_reasm_prepare);
 
 void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
-			    void *reasm_data)
+			    void *reasm_data, bool try_coalesce)
 {
 	struct sk_buff **nextp = (struct sk_buff **)reasm_data;
 	struct rb_node *rbn;
 	struct sk_buff *fp;
+	int sum_truesize;
 
 	skb_push(head, head->data - skb_network_header(head));
 
@@ -487,25 +488,41 @@ void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
 	fp = FRAG_CB(head)->next_frag;
 	rbn = rb_next(&head->rbnode);
 	rb_erase(&head->rbnode, &q->rb_fragments);
+
+	sum_truesize = head->truesize;
 	while (rbn || fp) {
 		/* fp points to the next sk_buff in the current run;
 		 * rbn points to the next run.
 		 */
 		/* Go through the current run. */
 		while (fp) {
-			*nextp = fp;
-			nextp = &fp->next;
-			fp->prev = NULL;
-			memset(&fp->rbnode, 0, sizeof(fp->rbnode));
-			fp->sk = NULL;
-			head->data_len += fp->len;
-			head->len += fp->len;
+			struct sk_buff *next_frag = FRAG_CB(fp)->next_frag;
+			bool stolen;
+			int delta;
+
+			sum_truesize += fp->truesize;
 			if (head->ip_summed != fp->ip_summed)
 				head->ip_summed = CHECKSUM_NONE;
 			else if (head->ip_summed == CHECKSUM_COMPLETE)
 				head->csum = csum_add(head->csum, fp->csum);
-			head->truesize += fp->truesize;
-			fp = FRAG_CB(fp)->next_frag;
+
+			if (try_coalesce && skb_try_coalesce(head, fp, &stolen,
+							     &delta)) {
+				kfree_skb_partial(fp, stolen);
+			} else {
+				fp->prev = NULL;
+				memset(&fp->rbnode, 0, sizeof(fp->rbnode));
+				fp->sk = NULL;
+
+				head->data_len += fp->len;
+				head->len += fp->len;
+				head->truesize += fp->truesize;
+
+				*nextp = fp;
+				nextp = &fp->next;
+			}
+
+			fp = next_frag;
 		}
 		/* Move to the next run. */
 		if (rbn) {
@@ -516,7 +533,7 @@ void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
 			rbn = rbnext;
 		}
 	}
-	sub_frag_mem_limit(q->fqdir, head->truesize);
+	sub_frag_mem_limit(q->fqdir, sum_truesize);
 
 	*nextp = NULL;
 	skb_mark_not_on_list(head);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 4385eb9e781f..cfeb8890f94e 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -393,6 +393,11 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	return err;
 }
 
+static bool ip_frag_coalesce_ok(const struct ipq *qp)
+{
+	return qp->q.key.v4.user == IP_DEFRAG_LOCAL_DELIVER;
+}
+
 /* Build a new IP datagram from all its fragments. */
 static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 			 struct sk_buff *prev_tail, struct net_device *dev)
@@ -421,7 +426,8 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 	if (len > 65535)
 		goto out_oversize;
 
-	inet_frag_reasm_finish(&qp->q, skb, reasm_data);
+	inet_frag_reasm_finish(&qp->q, skb, reasm_data,
+			       ip_frag_coalesce_ok(qp));
 
 	skb->dev = dev;
 	IPCB(skb)->frag_max_size = max(qp->max_df_size, qp->q.max_size);
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 0f82c150543b..fed9666a2f7d 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -348,7 +348,7 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 
 	skb_reset_transport_header(skb);
 
-	inet_frag_reasm_finish(&fq->q, skb, reasm_data);
+	inet_frag_reasm_finish(&fq->q, skb, reasm_data, false);
 
 	skb->ignore_df = 1;
 	skb->dev = dev;
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index ca05b16f1bb9..1f5d4d196dcc 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -282,7 +282,7 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 
 	skb_reset_transport_header(skb);
 
-	inet_frag_reasm_finish(&fq->q, skb, reasm_data);
+	inet_frag_reasm_finish(&fq->q, skb, reasm_data, true);
 
 	skb->dev = dev;
 	ipv6_hdr(skb)->payload_len = htons(payload_len);
-- 
2.20.1

