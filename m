Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B7129BBF
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390605AbfEXQEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:04:12 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:43335 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389962AbfEXQEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:04:12 -0400
Received: by mail-yw1-f73.google.com with SMTP id t2so8826365ywc.10
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HyDAUn0lZ+1rT74rjWmlpnwwvLW6vGV4wvJk/rKoo8c=;
        b=oaB4SsrojQ5EjNT/fcFBjpCYymmRhpH1tE96pk+nH8eN3or2MfE/dbzEWqesBUB7KI
         Fh88rBjbgElJg9Og8bPYV5exmE+FLlwsbVu5HO/4ZBxON92Fl7qwYwGbCn4iCe4J+LGy
         4va6uQ13VVjEUB6vg2tUX6NcdUbyiyKV+iWZkg4ApDpBfcv02clk4QFLx7Pwi20mrvHM
         xsfYS674rlYcDJn0e73cTtwAvjd55PA6YIls5wQ0oToQlU98LWIl1vXq+7NXyvBzYI7R
         moNzwFP3munTIGmv3UQb5wZET3hHDx22+zcZ9ShoDNk84LBONbCpYUIolyBATPm2o2/b
         RUEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HyDAUn0lZ+1rT74rjWmlpnwwvLW6vGV4wvJk/rKoo8c=;
        b=OeJUTevsqzi0DvShiV0NTgVsvsoiSunNi1sy+CwKopwVsjPIhNU04DtHsKcxmmrWi3
         G+ViE7K7Juj/b0rkEUzloAukUr8ZVa7mu/fA91NvoPk6t5mo8x8YUUV0kL3fl8K0dW7Y
         vZDtmRxh3nVJpLbPJTMxeZ7/jlY2dPjU9PhaBuVxJ4g2C4FdJb/mGLpKF3d9jNVnEvYY
         Iv75/FQ9k5yEF1L8jrPW0Ei5Nw9iDBaa9J23MQJ87aFteKdzBHkfwFf6+W5VDsECUuo9
         XAGVXdfeOABAy0Q8vaHGGm9deQge4vyCZZvuvdMjaCwvSua7sTPkBgm5ZeMUvoVvTTTI
         iKCA==
X-Gm-Message-State: APjAAAU/AZk7PUva6l7ffIcXj1Z259YGoKtFv90sqi9VNMvYknWDEO/i
        xsJDdjvXOuMEGHLDKCq6M6IGQbiPntozyA==
X-Google-Smtp-Source: APXvYqy+xetYgb2F9cZ/RzkR7HhrbFhY322V1AycI8PY89srtvEAqoOleURHkrKSpPEdegMVGRFCBxxDV/jA6w==
X-Received: by 2002:a81:924f:: with SMTP id j76mr45938184ywg.199.1558713851435;
 Fri, 24 May 2019 09:04:11 -0700 (PDT)
Date:   Fri, 24 May 2019 09:03:38 -0700
In-Reply-To: <20190524160340.169521-1-edumazet@google.com>
Message-Id: <20190524160340.169521-10-edumazet@google.com>
Mime-Version: 1.0
References: <20190524160340.169521-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 09/11] net: add a net pointer to struct fqdir
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fqdir will soon be dynamically allocated.

We need to reach the struct net pointer from fqdir,
so add it, and replace the various container_of() constructs
by direct access to the new field.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_frag.h                 |  5 ++++-
 net/ieee802154/6lowpan/reassembly.c     |  2 +-
 net/ipv4/ip_fragment.c                  | 20 +++++++-------------
 net/ipv6/netfilter/nf_conntrack_reasm.c |  6 ++----
 net/ipv6/reassembly.c                   |  8 +++-----
 5 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index fca246b0abd84d354c6ca1902af9867732ff49cc..37cde5c1498c30ee6ddf8ac7defd55e73ef296dc 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -12,6 +12,7 @@ struct fqdir {
 	int			timeout;
 	int			max_dist;
 	struct inet_frags	*f;
+	struct net		*net;
 
 	struct rhashtable       rhashtable ____cacheline_aligned_in_smp;
 
@@ -104,9 +105,11 @@ struct inet_frags {
 int inet_frags_init(struct inet_frags *);
 void inet_frags_fini(struct inet_frags *);
 
-static inline int fqdir_init(struct fqdir *fqdir, struct inet_frags *f)
+static inline int fqdir_init(struct fqdir *fqdir, struct inet_frags *f,
+			     struct net *net)
 {
 	fqdir->f = f;
+	fqdir->net = net;
 	atomic_long_set(&fqdir->mem, 0);
 	return rhashtable_init(&fqdir->rhashtable, &fqdir->f->rhash_params);
 }
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index 82db76ce0e61c06c6e56a00999530c7b47b49143..03a444c9e191925c2b35c805f2b982739ca499f2 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -453,7 +453,7 @@ static int __net_init lowpan_frags_init_net(struct net *net)
 	ieee802154_lowpan->fqdir.low_thresh = IPV6_FRAG_LOW_THRESH;
 	ieee802154_lowpan->fqdir.timeout = IPV6_FRAG_TIMEOUT;
 
-	res = fqdir_init(&ieee802154_lowpan->fqdir, &lowpan_frags);
+	res = fqdir_init(&ieee802154_lowpan->fqdir, &lowpan_frags, net);
 	if (res < 0)
 		return res;
 	res = lowpan_frags_ns_sysctl_register(net);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index d95592d5298136d852d9bb07a6f2091865f83e35..d59269bbe1b610c4a34c7b09ab15d05ab13b7afa 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -82,9 +82,7 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 static void ip4_frag_init(struct inet_frag_queue *q, const void *a)
 {
 	struct ipq *qp = container_of(q, struct ipq, q);
-	struct netns_ipv4 *ipv4 = container_of(q->fqdir, struct netns_ipv4,
-					       fqdir);
-	struct net *net = container_of(ipv4, struct net, ipv4);
+	struct net *net = q->fqdir->net;
 
 	const struct frag_v4_compare_key *key = a;
 
@@ -142,7 +140,7 @@ static void ip_expire(struct timer_list *t)
 	int err;
 
 	qp = container_of(frag, struct ipq, q);
-	net = container_of(qp->q.fqdir, struct net, ipv4.fqdir);
+	net = qp->q.fqdir->net;
 
 	rcu_read_lock();
 	spin_lock(&qp->q.lock);
@@ -236,12 +234,8 @@ static int ip_frag_too_far(struct ipq *qp)
 
 	rc = qp->q.fragments_tail && (end - start) > max;
 
-	if (rc) {
-		struct net *net;
-
-		net = container_of(qp->q.fqdir, struct net, ipv4.fqdir);
-		__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
-	}
+	if (rc)
+		__IP_INC_STATS(qp->q.fqdir->net, IPSTATS_MIB_REASMFAILS);
 
 	return rc;
 }
@@ -273,7 +267,7 @@ static int ip_frag_reinit(struct ipq *qp)
 /* Add new segment to existing queue. */
 static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 {
-	struct net *net = container_of(qp->q.fqdir, struct net, ipv4.fqdir);
+	struct net *net = qp->q.fqdir->net;
 	int ihl, end, flags, offset;
 	struct sk_buff *prev_tail;
 	struct net_device *dev;
@@ -399,7 +393,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 			 struct sk_buff *prev_tail, struct net_device *dev)
 {
-	struct net *net = container_of(qp->q.fqdir, struct net, ipv4.fqdir);
+	struct net *net = qp->q.fqdir->net;
 	struct iphdr *iph;
 	void *reasm_data;
 	int len, err;
@@ -673,7 +667,7 @@ static int __net_init ipv4_frags_init_net(struct net *net)
 
 	net->ipv4.fqdir.max_dist = 64;
 
-	res = fqdir_init(&net->ipv4.fqdir, &ip4_frags);
+	res = fqdir_init(&net->ipv4.fqdir, &ip4_frags, net);
 	if (res < 0)
 		return res;
 	res = ip4_frags_ns_ctl_register(net);
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index e72a1cc42163cc801e441e18b3a10a4c9f578aa3..b6f7385ed93c264f60f3e92fc0ce2cdbe9af7fca 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -143,12 +143,10 @@ static void nf_ct_frag6_expire(struct timer_list *t)
 {
 	struct inet_frag_queue *frag = from_timer(frag, t, timer);
 	struct frag_queue *fq;
-	struct net *net;
 
 	fq = container_of(frag, struct frag_queue, q);
-	net = container_of(fq->q.fqdir, struct net, nf_frag.fqdir);
 
-	ip6frag_expire_frag_queue(net, fq);
+	ip6frag_expire_frag_queue(fq->q.fqdir->net, fq);
 }
 
 /* Creation primitives. */
@@ -495,7 +493,7 @@ static int nf_ct_net_init(struct net *net)
 	net->nf_frag.fqdir.low_thresh = IPV6_FRAG_LOW_THRESH;
 	net->nf_frag.fqdir.timeout = IPV6_FRAG_TIMEOUT;
 
-	res = fqdir_init(&net->nf_frag.fqdir, &nf_frags);
+	res = fqdir_init(&net->nf_frag.fqdir, &nf_frags, net);
 	if (res < 0)
 		return res;
 	res = nf_ct_frag6_sysctl_register(net);
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 8235c5a8e8fe8d99c339e3f39979d8fe388f7c0a..a6f26aa648fbee592ac1102e3ff1341df09d6385 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -76,12 +76,10 @@ static void ip6_frag_expire(struct timer_list *t)
 {
 	struct inet_frag_queue *frag = from_timer(frag, t, timer);
 	struct frag_queue *fq;
-	struct net *net;
 
 	fq = container_of(frag, struct frag_queue, q);
-	net = container_of(fq->q.fqdir, struct net, ipv6.fqdir);
 
-	ip6frag_expire_frag_queue(net, fq);
+	ip6frag_expire_frag_queue(fq->q.fqdir->net, fq);
 }
 
 static struct frag_queue *
@@ -254,7 +252,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 			  struct sk_buff *prev_tail, struct net_device *dev)
 {
-	struct net *net = container_of(fq->q.fqdir, struct net, ipv6.fqdir);
+	struct net *net = fq->q.fqdir->net;
 	unsigned int nhoff;
 	void *reasm_data;
 	int payload_len;
@@ -516,7 +514,7 @@ static int __net_init ipv6_frags_init_net(struct net *net)
 	net->ipv6.fqdir.low_thresh = IPV6_FRAG_LOW_THRESH;
 	net->ipv6.fqdir.timeout = IPV6_FRAG_TIMEOUT;
 
-	res = fqdir_init(&net->ipv6.fqdir, &ip6_frags);
+	res = fqdir_init(&net->ipv6.fqdir, &ip6_frags, net);
 	if (res < 0)
 		return res;
 
-- 
2.22.0.rc1.257.g3120a18244-goog

