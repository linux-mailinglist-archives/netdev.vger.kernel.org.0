Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863A829BC0
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390627AbfEXQEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:04:16 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:44910 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389962AbfEXQEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:04:16 -0400
Received: by mail-pl1-f201.google.com with SMTP id y9so6141572plt.11
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CJ+LP54QfULMdfw+Ct+zNy5hiAI0v+ufYZUDXjVlfHc=;
        b=s+o21qczdsXj7VN3SgvV+Cb7xjml+z702+uQt8b/WO4sIj7eK/rL1zuP4nmPjRZtps
         pc3dHZ+1LzMxxtZMMPOxM4FeB3bIm/46fdt0j5/4th4HbmbFczNFz3xM3eReeGNprEuV
         LPWe/C5Pa8I3lp/HMf0Q+eD/1M1pksuqtYyxMjfUgtblKU7Tfka+ni+IncQQjZ+dSN5T
         O9Nwoj1OACjnQXrYUaluPPRuxL+LgyWWCwo3gw2tKU8ewt3IXYIF/z0eD3sTIt8vADnh
         qi9QYdlO463CZ76VRa1i0PhEQvNoX+bNmv4q5vX7aoYednAGP01wbsyY5q+nddLfD+ON
         JHBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CJ+LP54QfULMdfw+Ct+zNy5hiAI0v+ufYZUDXjVlfHc=;
        b=YISwkLSyqcBZD/4e1fwF4sPlj/UjeJ67r0rGfkTuMYu6+T58NSzQuGi7TZgclXZGAl
         HdRaGaW87u8kIA28s9zqQ941ls//aIfZrizOGfXc9ilWArlfcHL0/CzWLyfvrdUsqegC
         tbfvE4fe4QfF9xPWqvLzB12EqgFP4swXxbvM3CePEYNt1uumthyMelYtnQTJKsKr8HrP
         7h5/oP/LjDvCjPXA2gm917gvF9n19+JcDT7H0qF7PcugFekU9fqXvyx37CgaU4rVH7Ii
         bERke8zhTe/mdnnXFTo2qG76d4B+cXumKqCcZf+KGKzNTTomEflApmWFVxpO28Kekiny
         O6UQ==
X-Gm-Message-State: APjAAAUGwoKpSX7qRbrIaxDg8OIsqq0r6ypYOIup76l5rqtMzmvumHzS
        2/jDwJ6KTIpeEiVmC07n2f2gEvlA2IP8vQ==
X-Google-Smtp-Source: APXvYqxcBQ9kRFm8xhgUVfxFXLaj7UW03j5F11CnWkX7VQ4cAmJcVIQQzjMhgDRhbLZ0NZcUoy1yhe/mdsFf8A==
X-Received: by 2002:a63:2107:: with SMTP id h7mr34334533pgh.330.1558713854293;
 Fri, 24 May 2019 09:04:14 -0700 (PDT)
Date:   Fri, 24 May 2019 09:03:39 -0700
In-Reply-To: <20190524160340.169521-1-edumazet@google.com>
Message-Id: <20190524160340.169521-11-edumazet@google.com>
Mime-Version: 1.0
References: <20190524160340.169521-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 10/11] net: dynamically allocate fqdir structures
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

Following patch will add rcu grace period before fqdir
rhashtable destruction, so we need to dynamically allocate
fqdir structures to not force expensive synchronize_rcu() calls
in netns dismantle path.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_frag.h                 | 17 ++++++++++---
 include/net/netns/ieee802154_6lowpan.h  |  2 +-
 include/net/netns/ipv4.h                |  2 +-
 include/net/netns/ipv6.h                |  4 ++--
 net/ieee802154/6lowpan/reassembly.c     | 24 ++++++++++---------
 net/ipv4/inet_fragment.c                |  1 +
 net/ipv4/ip_fragment.c                  | 32 ++++++++++++-------------
 net/ipv4/proc.c                         |  4 ++--
 net/ipv6/netfilter/nf_conntrack_reasm.c | 27 +++++++++++----------
 net/ipv6/proc.c                         |  4 ++--
 net/ipv6/reassembly.c                   | 24 +++++++++----------
 11 files changed, 78 insertions(+), 63 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 37cde5c1498c30ee6ddf8ac7defd55e73ef296dc..5f754c660cfa34898e48d5dbbf17a3508fb8b3ba 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -105,14 +105,25 @@ struct inet_frags {
 int inet_frags_init(struct inet_frags *);
 void inet_frags_fini(struct inet_frags *);
 
-static inline int fqdir_init(struct fqdir *fqdir, struct inet_frags *f,
+static inline int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f,
 			     struct net *net)
 {
+	struct fqdir *fqdir = kzalloc(sizeof(*fqdir), GFP_KERNEL);
+	int res;
+
+	if (!fqdir)
+		return -ENOMEM;
 	fqdir->f = f;
 	fqdir->net = net;
-	atomic_long_set(&fqdir->mem, 0);
-	return rhashtable_init(&fqdir->rhashtable, &fqdir->f->rhash_params);
+	res = rhashtable_init(&fqdir->rhashtable, &fqdir->f->rhash_params);
+	if (res < 0) {
+		kfree(fqdir);
+		return res;
+	}
+	*fqdirp = fqdir;
+	return 0;
 }
+
 void fqdir_exit(struct fqdir *fqdir);
 
 void inet_frag_kill(struct inet_frag_queue *q);
diff --git a/include/net/netns/ieee802154_6lowpan.h b/include/net/netns/ieee802154_6lowpan.h
index d27ac64f8dfefcc2253c14c04af193e6265b9e02..95406e1342cb54ee1f421b68e2feb1c421b2a768 100644
--- a/include/net/netns/ieee802154_6lowpan.h
+++ b/include/net/netns/ieee802154_6lowpan.h
@@ -16,7 +16,7 @@ struct netns_sysctl_lowpan {
 
 struct netns_ieee802154_lowpan {
 	struct netns_sysctl_lowpan sysctl;
-	struct fqdir		fqdir;
+	struct fqdir		*fqdir;
 };
 
 #endif
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 3c270baa32e030b36594627a77abe3b4ffc775f5..c07cee1e0c9ea21cfab457a90287358ed7650d72 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -72,7 +72,7 @@ struct netns_ipv4 {
 
 	struct inet_peer_base	*peers;
 	struct sock  * __percpu	*tcp_sk;
-	struct fqdir		fqdir;
+	struct fqdir		*fqdir;
 #ifdef CONFIG_NETFILTER
 	struct xt_table		*iptable_filter;
 	struct xt_table		*iptable_mangle;
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 3dd2ae2a38e2aead40f2bcf13e40b79ca492ad48..022a0fd1a5a466bd35fed5deab4fa901e2d5b1d3 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -58,7 +58,7 @@ struct netns_ipv6 {
 	struct ipv6_devconf	*devconf_all;
 	struct ipv6_devconf	*devconf_dflt;
 	struct inet_peer_base	*peers;
-	struct fqdir		fqdir;
+	struct fqdir		*fqdir;
 #ifdef CONFIG_NETFILTER
 	struct xt_table		*ip6table_filter;
 	struct xt_table		*ip6table_mangle;
@@ -116,7 +116,7 @@ struct netns_ipv6 {
 
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 struct netns_nf_frag {
-	struct fqdir	fqdir;
+	struct fqdir	*fqdir;
 };
 #endif
 
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index 03a444c9e191925c2b35c805f2b982739ca499f2..e59c3b7089691ef95ce3b7ce02afe68ffc256dcc 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -79,7 +79,7 @@ fq_find(struct net *net, const struct lowpan_802154_cb *cb,
 	key.src = *src;
 	key.dst = *dst;
 
-	q = inet_frag_find(&ieee802154_lowpan->fqdir, &key);
+	q = inet_frag_find(ieee802154_lowpan->fqdir, &key);
 	if (!q)
 		return NULL;
 
@@ -377,11 +377,11 @@ static int __net_init lowpan_frags_ns_sysctl_register(struct net *net)
 			table[0].procname = NULL;
 	}
 
-	table[0].data	= &ieee802154_lowpan->fqdir.high_thresh;
-	table[0].extra1	= &ieee802154_lowpan->fqdir.low_thresh;
-	table[1].data	= &ieee802154_lowpan->fqdir.low_thresh;
-	table[1].extra2	= &ieee802154_lowpan->fqdir.high_thresh;
-	table[2].data	= &ieee802154_lowpan->fqdir.timeout;
+	table[0].data	= &ieee802154_lowpan->fqdir->high_thresh;
+	table[0].extra1	= &ieee802154_lowpan->fqdir->low_thresh;
+	table[1].data	= &ieee802154_lowpan->fqdir->low_thresh;
+	table[1].extra2	= &ieee802154_lowpan->fqdir->high_thresh;
+	table[2].data	= &ieee802154_lowpan->fqdir->timeout;
 
 	hdr = register_net_sysctl(net, "net/ieee802154/6lowpan", table);
 	if (hdr == NULL)
@@ -449,16 +449,18 @@ static int __net_init lowpan_frags_init_net(struct net *net)
 		net_ieee802154_lowpan(net);
 	int res;
 
-	ieee802154_lowpan->fqdir.high_thresh = IPV6_FRAG_HIGH_THRESH;
-	ieee802154_lowpan->fqdir.low_thresh = IPV6_FRAG_LOW_THRESH;
-	ieee802154_lowpan->fqdir.timeout = IPV6_FRAG_TIMEOUT;
 
 	res = fqdir_init(&ieee802154_lowpan->fqdir, &lowpan_frags, net);
 	if (res < 0)
 		return res;
+
+	ieee802154_lowpan->fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
+	ieee802154_lowpan->fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
+	ieee802154_lowpan->fqdir->timeout = IPV6_FRAG_TIMEOUT;
+
 	res = lowpan_frags_ns_sysctl_register(net);
 	if (res < 0)
-		fqdir_exit(&ieee802154_lowpan->fqdir);
+		fqdir_exit(ieee802154_lowpan->fqdir);
 	return res;
 }
 
@@ -468,7 +470,7 @@ static void __net_exit lowpan_frags_exit_net(struct net *net)
 		net_ieee802154_lowpan(net);
 
 	lowpan_frags_ns_sysctl_unregister(net);
-	fqdir_exit(&ieee802154_lowpan->fqdir);
+	fqdir_exit(ieee802154_lowpan->fqdir);
 }
 
 static struct pernet_operations lowpan_frags_ops = {
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index a5ec5d9567931d03cfa3fbe1a370857ed8dc3b3d..b4432f209c715dd09b0b201fdae16d5332770c85 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -150,6 +150,7 @@ void fqdir_exit(struct fqdir *fqdir)
 	fqdir->high_thresh = 0; /* prevent creation of new frags */
 
 	rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
+	kfree(fqdir);
 }
 EXPORT_SYMBOL(fqdir_exit);
 
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index d59269bbe1b610c4a34c7b09ab15d05ab13b7afa..1ffaec056821b8e0bd0915403b0a3a1d449690ec 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -209,7 +209,7 @@ static struct ipq *ip_find(struct net *net, struct iphdr *iph,
 	};
 	struct inet_frag_queue *q;
 
-	q = inet_frag_find(&net->ipv4.fqdir, &key);
+	q = inet_frag_find(net->ipv4.fqdir, &key);
 	if (!q)
 		return NULL;
 
@@ -589,12 +589,12 @@ static int __net_init ip4_frags_ns_ctl_register(struct net *net)
 			goto err_alloc;
 
 	}
-	table[0].data	= &net->ipv4.fqdir.high_thresh;
-	table[0].extra1	= &net->ipv4.fqdir.low_thresh;
-	table[1].data	= &net->ipv4.fqdir.low_thresh;
-	table[1].extra2	= &net->ipv4.fqdir.high_thresh;
-	table[2].data	= &net->ipv4.fqdir.timeout;
-	table[3].data	= &net->ipv4.fqdir.max_dist;
+	table[0].data	= &net->ipv4.fqdir->high_thresh;
+	table[0].extra1	= &net->ipv4.fqdir->low_thresh;
+	table[1].data	= &net->ipv4.fqdir->low_thresh;
+	table[1].extra2	= &net->ipv4.fqdir->high_thresh;
+	table[2].data	= &net->ipv4.fqdir->timeout;
+	table[3].data	= &net->ipv4.fqdir->max_dist;
 
 	hdr = register_net_sysctl(net, "net/ipv4", table);
 	if (!hdr)
@@ -642,6 +642,9 @@ static int __net_init ipv4_frags_init_net(struct net *net)
 {
 	int res;
 
+	res = fqdir_init(&net->ipv4.fqdir, &ip4_frags, net);
+	if (res < 0)
+		return res;
 	/* Fragment cache limits.
 	 *
 	 * The fragment memory accounting code, (tries to) account for
@@ -656,30 +659,27 @@ static int __net_init ipv4_frags_init_net(struct net *net)
 	 * we will prune down to 3MB, making room for approx 8 big 64K
 	 * fragments 8x128k.
 	 */
-	net->ipv4.fqdir.high_thresh = 4 * 1024 * 1024;
-	net->ipv4.fqdir.low_thresh  = 3 * 1024 * 1024;
+	net->ipv4.fqdir->high_thresh = 4 * 1024 * 1024;
+	net->ipv4.fqdir->low_thresh  = 3 * 1024 * 1024;
 	/*
 	 * Important NOTE! Fragment queue must be destroyed before MSL expires.
 	 * RFC791 is wrong proposing to prolongate timer each fragment arrival
 	 * by TTL.
 	 */
-	net->ipv4.fqdir.timeout = IP_FRAG_TIME;
+	net->ipv4.fqdir->timeout = IP_FRAG_TIME;
 
-	net->ipv4.fqdir.max_dist = 64;
+	net->ipv4.fqdir->max_dist = 64;
 
-	res = fqdir_init(&net->ipv4.fqdir, &ip4_frags, net);
-	if (res < 0)
-		return res;
 	res = ip4_frags_ns_ctl_register(net);
 	if (res < 0)
-		fqdir_exit(&net->ipv4.fqdir);
+		fqdir_exit(net->ipv4.fqdir);
 	return res;
 }
 
 static void __net_exit ipv4_frags_exit_net(struct net *net)
 {
 	ip4_frags_ns_ctl_unregister(net);
-	fqdir_exit(&net->ipv4.fqdir);
+	fqdir_exit(net->ipv4.fqdir);
 }
 
 static struct pernet_operations ip4_frags_ops = {
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 3927e00084e8eacc237c4bb46554458ad0266dcf..b613572c66168c0fa56b8051d63959727f65f04e 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -72,8 +72,8 @@ static int sockstat_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "RAW: inuse %d\n",
 		   sock_prot_inuse_get(net, &raw_prot));
 	seq_printf(seq,  "FRAG: inuse %u memory %lu\n",
-		   atomic_read(&net->ipv4.fqdir.rhashtable.nelems),
-		   frag_mem_limit(&net->ipv4.fqdir));
+		   atomic_read(&net->ipv4.fqdir->rhashtable.nelems),
+		   frag_mem_limit(net->ipv4.fqdir));
 	return 0;
 }
 
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index b6f7385ed93c264f60f3e92fc0ce2cdbe9af7fca..c5d59fa568d6a361fbd58d920ebb61e45c9e515f 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -90,12 +90,12 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 			goto err_alloc;
 	}
 
-	table[0].data	= &net->nf_frag.fqdir.timeout;
-	table[1].data	= &net->nf_frag.fqdir.low_thresh;
-	table[1].extra2	= &net->nf_frag.fqdir.high_thresh;
-	table[2].data	= &net->nf_frag.fqdir.high_thresh;
-	table[2].extra1	= &net->nf_frag.fqdir.low_thresh;
-	table[2].extra2	= &init_net.nf_frag.fqdir.high_thresh;
+	table[0].data	= &net->nf_frag.fqdir->timeout;
+	table[1].data	= &net->nf_frag.fqdir->low_thresh;
+	table[1].extra2	= &net->nf_frag.fqdir->high_thresh;
+	table[2].data	= &net->nf_frag.fqdir->high_thresh;
+	table[2].extra1	= &net->nf_frag.fqdir->low_thresh;
+	table[2].extra2	= &init_net.nf_frag.fqdir->high_thresh;
 
 	hdr = register_net_sysctl(net, "net/netfilter", table);
 	if (hdr == NULL)
@@ -162,7 +162,7 @@ static struct frag_queue *fq_find(struct net *net, __be32 id, u32 user,
 	};
 	struct inet_frag_queue *q;
 
-	q = inet_frag_find(&net->nf_frag.fqdir, &key);
+	q = inet_frag_find(net->nf_frag.fqdir, &key);
 	if (!q)
 		return NULL;
 
@@ -489,23 +489,24 @@ static int nf_ct_net_init(struct net *net)
 {
 	int res;
 
-	net->nf_frag.fqdir.high_thresh = IPV6_FRAG_HIGH_THRESH;
-	net->nf_frag.fqdir.low_thresh = IPV6_FRAG_LOW_THRESH;
-	net->nf_frag.fqdir.timeout = IPV6_FRAG_TIMEOUT;
-
 	res = fqdir_init(&net->nf_frag.fqdir, &nf_frags, net);
 	if (res < 0)
 		return res;
+
+	net->nf_frag.fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
+	net->nf_frag.fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
+	net->nf_frag.fqdir->timeout = IPV6_FRAG_TIMEOUT;
+
 	res = nf_ct_frag6_sysctl_register(net);
 	if (res < 0)
-		fqdir_exit(&net->nf_frag.fqdir);
+		fqdir_exit(net->nf_frag.fqdir);
 	return res;
 }
 
 static void nf_ct_net_exit(struct net *net)
 {
 	nf_ct_frags6_sysctl_unregister(net);
-	fqdir_exit(&net->nf_frag.fqdir);
+	fqdir_exit(net->nf_frag.fqdir);
 }
 
 static struct pernet_operations nf_ct_net_ops = {
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index f3e3118393c4b4841228797c168e757585dbb17b..0bbefc440bcdd9fdbca1bd9258eaa9e6d315c0eb 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -48,8 +48,8 @@ static int sockstat6_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "RAW6: inuse %d\n",
 		       sock_prot_inuse_get(net, &rawv6_prot));
 	seq_printf(seq, "FRAG6: inuse %u memory %lu\n",
-		   atomic_read(&net->ipv6.fqdir.rhashtable.nelems),
-		   frag_mem_limit(&net->ipv6.fqdir));
+		   atomic_read(&net->ipv6.fqdir->rhashtable.nelems),
+		   frag_mem_limit(net->ipv6.fqdir));
 	return 0;
 }
 
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index a6f26aa648fbee592ac1102e3ff1341df09d6385..836ea964cf140d8b0134894455f18addc069e13e 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -98,7 +98,7 @@ fq_find(struct net *net, __be32 id, const struct ipv6hdr *hdr, int iif)
 					    IPV6_ADDR_LINKLOCAL)))
 		key.iif = 0;
 
-	q = inet_frag_find(&net->ipv6.fqdir, &key);
+	q = inet_frag_find(net->ipv6.fqdir, &key);
 	if (!q)
 		return NULL;
 
@@ -443,11 +443,11 @@ static int __net_init ip6_frags_ns_sysctl_register(struct net *net)
 			goto err_alloc;
 
 	}
-	table[0].data	= &net->ipv6.fqdir.high_thresh;
-	table[0].extra1	= &net->ipv6.fqdir.low_thresh;
-	table[1].data	= &net->ipv6.fqdir.low_thresh;
-	table[1].extra2	= &net->ipv6.fqdir.high_thresh;
-	table[2].data	= &net->ipv6.fqdir.timeout;
+	table[0].data	= &net->ipv6.fqdir->high_thresh;
+	table[0].extra1	= &net->ipv6.fqdir->low_thresh;
+	table[1].data	= &net->ipv6.fqdir->low_thresh;
+	table[1].extra2	= &net->ipv6.fqdir->high_thresh;
+	table[2].data	= &net->ipv6.fqdir->timeout;
 
 	hdr = register_net_sysctl(net, "net/ipv6", table);
 	if (!hdr)
@@ -510,24 +510,24 @@ static int __net_init ipv6_frags_init_net(struct net *net)
 {
 	int res;
 
-	net->ipv6.fqdir.high_thresh = IPV6_FRAG_HIGH_THRESH;
-	net->ipv6.fqdir.low_thresh = IPV6_FRAG_LOW_THRESH;
-	net->ipv6.fqdir.timeout = IPV6_FRAG_TIMEOUT;
-
 	res = fqdir_init(&net->ipv6.fqdir, &ip6_frags, net);
 	if (res < 0)
 		return res;
 
+	net->ipv6.fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
+	net->ipv6.fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
+	net->ipv6.fqdir->timeout = IPV6_FRAG_TIMEOUT;
+
 	res = ip6_frags_ns_sysctl_register(net);
 	if (res < 0)
-		fqdir_exit(&net->ipv6.fqdir);
+		fqdir_exit(net->ipv6.fqdir);
 	return res;
 }
 
 static void __net_exit ipv6_frags_exit_net(struct net *net)
 {
 	ip6_frags_ns_sysctl_unregister(net);
-	fqdir_exit(&net->ipv6.fqdir);
+	fqdir_exit(net->ipv6.fqdir);
 }
 
 static struct pernet_operations ip6_frags_ops = {
-- 
2.22.0.rc1.257.g3120a18244-goog

