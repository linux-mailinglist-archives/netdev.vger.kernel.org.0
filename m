Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F39A3000CD
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbhAVJ3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 04:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbhAVJKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:10:19 -0500
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8758FC061794;
        Fri, 22 Jan 2021 01:09:33 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 059FE102A88C8;
        Fri, 22 Jan 2021 10:06:48 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id AEEB86017D32;
        Fri, 22 Jan 2021 10:06:47 +0100 (CET)
X-Mailbox-Line: From 979835dc887d3affc4e76464aa21da0e298fd638 Mon Sep 17 00:00:00 2001
Message-Id: <979835dc887d3affc4e76464aa21da0e298fd638.1611304190.git.lukas@wunner.de>
In-Reply-To: <cover.1611304190.git.lukas@wunner.de>
References: <cover.1611304190.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Fri, 22 Jan 2021 09:47:04 +0100
Subject: [PATCH nf-next v4 4/5] netfilter: Introduce egress hook
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
handle_ing() under unique static key") introduced the ability to
classify packets with netfilter on ingress.

Support the same on egress to satisfy user requirements such as:
* outbound security policies for containers (Laura)
* filtering and mangling intra-node Direct Server Return (DSR) traffic
  on a load balancer (Laura)
* filtering locally generated traffic coming in through AF_PACKET,
  such as local ARP traffic generated for clustering purposes or DHCP
  (Laura; the AF_PACKET plumbing is contained in a separate commit)
* L2 filtering from ingress and egress for AVB (Audio Video Bridging)
  and gPTP with nftables (Pablo)
* in the future: in-kernel NAT64/NAT46 (Pablo)

A patch for nftables to hook up egress rules from user space has been
submitted separately, so users may immediately take advantage of the
feature.

The hook is positioned after packet handling by traffic control.
Thus, if packets are redirected into and out of containers with tc,
the data path is:
ingress: host tc -> container tc -> container nft
egress:  container tc -> host tc -> host nft

This was done to address an objection from Daniel Borkmann:  If desired,
nft does not get into tc's way performance-wise.  The host is able to
firewall malicious packets coming out of a container, but only after tc
has done its duty.  An implication is that tc may set skb->mark on
egress for nft to act on it, but not the other way round.

If egress netfilter handling is not enabled on any interface, it is
patched out of the data path by way of a static_key and doesn't make a
performance difference that is discernible from noise:

Before:             2076 2076 2076 2077 2077 2074 Mb/sec
After:              2080 2078 2078 2079 2079 2077 Mb/sec
Before + tc accept: 1877 1875 1878 1874 1882 1873 Mb/sec
After  + tc accept: 1874 1877 1881 1875 1876 1876 Mb/sec
Before + tc drop:   2167 2182 2168 2171 2164 2171 Mb/sec
After  + tc drop:   2176 2180 2184 2178 2178 2180 Mb/sec

Measurements were performed on a Core i7-3615QM.  Commands to reproduce:
ip link add dev foo type dummy
ip link set dev foo up
modprobe pktgen
echo "add_device foo" > /proc/net/pktgen/kpktgend_3
samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh -i foo -n 400000000 -m "11:11:11:11:11:11" -d 1.1.1.1

Accept all traffic with tc:
tc qdisc add dev foo clsact
tc filter add dev foo egress bpf da bytecode '1,6 0 0 0,'

Drop all traffic with tc:
tc qdisc add dev foo clsact
tc filter add dev foo egress bpf da bytecode '1,6 0 0 2,'

Apply this patch when measuring packet drops to avoid errors in dmesg:
https://lore.kernel.org/netdev/a73dda33-57f4-95d8-ea51-ed483abd6a7a@iogearbox.net/

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Laura García Liébana <nevola@gmail.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Thomas Graf <tgraf@suug.ch>
---
 include/linux/netdevice.h        |  4 +++
 include/linux/netfilter_netdev.h | 52 ++++++++++++++++++++++++++++++++
 include/uapi/linux/netfilter.h   |  1 +
 net/core/dev.c                   | 11 +++++--
 net/netfilter/Kconfig            |  8 +++++
 net/netfilter/core.c             | 34 +++++++++++++++++++--
 net/netfilter/nft_chain_filter.c |  4 ++-
 7 files changed, 108 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1ec3ac5d5bbf..af0774cc20d2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1764,6 +1764,7 @@ enum netdev_priv_flags {
  *	@xps_maps:	XXX: need comments on this one
  *	@miniq_egress:		clsact qdisc specific data for
  *				egress processing
+ *	@nf_hooks_egress:	netfilter hooks executed for egress packets
  *	@qdisc_hash:		qdisc hash table
  *	@watchdog_timeo:	Represents the timeout that is used by
  *				the watchdog (see dev_watchdog())
@@ -2057,6 +2058,9 @@ struct net_device {
 #ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc __rcu	*miniq_egress;
 #endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	struct nf_hook_entries __rcu *nf_hooks_egress;
+#endif
 
 #ifdef CONFIG_NET_SCHED
 	DECLARE_HASHTABLE	(qdisc_hash, 4);
diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index 5812b0fb0278..5ed6e90d46f6 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -50,11 +50,63 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 }
 #endif /* CONFIG_NETFILTER_INGRESS */
 
+#ifdef CONFIG_NETFILTER_EGRESS
+static inline bool nf_hook_egress_active(void)
+{
+#ifdef CONFIG_JUMP_LABEL
+	if (!static_key_false(&nf_hooks_needed[NFPROTO_NETDEV][NF_NETDEV_EGRESS]))
+		return false;
+#endif
+	return true;
+}
+
+/* caller must hold rcu_read_lock */
+static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
+					     struct net_device *dev)
+{
+	struct nf_hook_entries *e = rcu_dereference(dev->nf_hooks_egress);
+	struct nf_hook_state state;
+	int ret;
+
+	if (!e)
+		return skb;
+
+	nf_hook_state_init(&state, NF_NETDEV_EGRESS,
+			   NFPROTO_NETDEV, dev, NULL, NULL,
+			   dev_net(dev), NULL);
+	ret = nf_hook_slow(skb, &state, e, 0);
+
+	if (ret == 1) {
+		return skb;
+	} else if (ret < 0) {
+		*rc = NET_XMIT_DROP;
+		return NULL;
+	} else { /* ret == 0 */
+		*rc = NET_XMIT_SUCCESS;
+		return NULL;
+	}
+}
+#else /* CONFIG_NETFILTER_EGRESS */
+static inline bool nf_hook_egress_active(void)
+{
+	return false;
+}
+
+static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
+					     struct net_device *dev)
+{
+	return skb;
+}
+#endif /* CONFIG_NETFILTER_EGRESS */
+
 static inline void nf_hook_netdev_init(struct net_device *dev)
 {
 #ifdef CONFIG_NETFILTER_INGRESS
 	RCU_INIT_POINTER(dev->nf_hooks_ingress, NULL);
 #endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	RCU_INIT_POINTER(dev->nf_hooks_egress, NULL);
+#endif
 }
 
 #endif /* _NETFILTER_NETDEV_H_ */
diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index ef9a44286e23..53411ccc69db 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -51,6 +51,7 @@ enum nf_inet_hooks {
 
 enum nf_dev_hooks {
 	NF_NETDEV_INGRESS,
+	NF_NETDEV_EGRESS,
 	NF_NETDEV_NUMHOOKS
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 931149bd654a..ecf881515b62 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3870,6 +3870,7 @@ EXPORT_SYMBOL(dev_loopback_xmit);
 static struct sk_buff *
 sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 {
+#ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
 	struct tcf_result cl_res;
 
@@ -3904,6 +3905,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	default:
 		break;
 	}
+#endif /* CONFIG_NET_CLS_ACT */
 
 	return skb;
 }
@@ -4096,13 +4098,18 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	qdisc_pkt_len_init(skb);
 #ifdef CONFIG_NET_CLS_ACT
 	skb->tc_at_ingress = 0;
-# ifdef CONFIG_NET_EGRESS
+#endif
+#ifdef CONFIG_NET_EGRESS
 	if (static_branch_unlikely(&egress_needed_key)) {
 		skb = sch_handle_egress(skb, &rc, dev);
 		if (!skb)
 			goto out;
+		if (nf_hook_egress_active()) {
+			skb = nf_hook_egress(skb, &rc, dev);
+			if (!skb)
+				goto out;
+		}
 	}
-# endif
 #endif
 	/* If device/qdisc don't need skb->dst, release it right now while
 	 * its hot in this cpu cache.
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 49fbef0d99be..ade86afa3b1b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -10,6 +10,14 @@ config NETFILTER_INGRESS
 	  This allows you to classify packets from ingress using the Netfilter
 	  infrastructure.
 
+config NETFILTER_EGRESS
+	bool "Netfilter egress support"
+	default y
+	select NET_EGRESS
+	help
+	  This allows you to classify packets before transmission using the
+	  Netfilter infrastructure.
+
 config NETFILTER_NETLINK
 	tristate
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 63d032191e62..3a32a813fcde 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -316,6 +316,12 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
 		if (dev && dev_net(dev) == net)
 			return &dev->nf_hooks_ingress;
 	}
+#endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	if (hooknum == NF_NETDEV_EGRESS) {
+		if (dev && dev_net(dev) == net)
+			return &dev->nf_hooks_egress;
+	}
 #endif
 	WARN_ON_ONCE(1);
 	return NULL;
@@ -344,6 +350,11 @@ static inline bool nf_ingress_hook(const struct nf_hook_ops *reg, int pf)
 	return false;
 }
 
+static inline bool nf_egress_hook(const struct nf_hook_ops *reg, int pf)
+{
+	return pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_EGRESS;
+}
+
 static void nf_static_key_inc(const struct nf_hook_ops *reg, int pf)
 {
 #ifdef CONFIG_JUMP_LABEL
@@ -383,9 +394,18 @@ static int __nf_register_net_hook(struct net *net, int pf,
 
 	switch (pf) {
 	case NFPROTO_NETDEV:
-		err = nf_ingress_check(net, reg, NF_NETDEV_INGRESS);
-		if (err < 0)
-			return err;
+#ifndef CONFIG_NETFILTER_INGRESS
+		if (reg->hooknum == NF_NETDEV_INGRESS)
+			return -EOPNOTSUPP;
+#endif
+#ifndef CONFIG_NETFILTER_EGRESS
+		if (reg->hooknum == NF_NETDEV_EGRESS)
+			return -EOPNOTSUPP;
+#endif
+		if ((reg->hooknum != NF_NETDEV_INGRESS &&
+		     reg->hooknum != NF_NETDEV_EGRESS) ||
+		    !reg->dev || dev_net(reg->dev) != net)
+			return -EINVAL;
 		break;
 	case NFPROTO_INET:
 		if (reg->hooknum != NF_INET_INGRESS)
@@ -417,6 +437,10 @@ static int __nf_register_net_hook(struct net *net, int pf,
 #ifdef CONFIG_NETFILTER_INGRESS
 	if (nf_ingress_hook(reg, pf))
 		net_inc_ingress_queue();
+#endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	if (nf_egress_hook(reg, pf))
+		net_inc_egress_queue();
 #endif
 	nf_static_key_inc(reg, pf);
 
@@ -474,6 +498,10 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 #ifdef CONFIG_NETFILTER_INGRESS
 		if (nf_ingress_hook(reg, pf))
 			net_dec_ingress_queue();
+#endif
+#ifdef CONFIG_NETFILTER_EGRESS
+		if (nf_egress_hook(reg, pf))
+			net_dec_egress_queue();
 #endif
 		nf_static_key_dec(reg, pf);
 	} else {
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index ff8528ad3dc6..c9dc5f36569b 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -310,9 +310,11 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
 	.family		= NFPROTO_NETDEV,
-	.hook_mask	= (1 << NF_NETDEV_INGRESS),
+	.hook_mask	= (1 << NF_NETDEV_INGRESS) |
+			  (1 << NF_NETDEV_EGRESS),
 	.hooks		= {
 		[NF_NETDEV_INGRESS]	= nft_do_chain_netdev,
+		[NF_NETDEV_EGRESS]	= nft_do_chain_netdev,
 	},
 };
 
-- 
2.29.2

