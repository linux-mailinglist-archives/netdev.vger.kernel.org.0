Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8AF377733
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 17:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhEIPSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 11:18:47 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39547 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229737AbhEIPSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 11:18:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C7CEB5C00F9;
        Sun,  9 May 2021 11:17:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 09 May 2021 11:17:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=WMhxOASiDj22LId35WsJz4anmBeYehIc99P8W9T+ZtE=; b=UtIjj1bl
        wcsi89cgdXqRaHJUfZ72boEDtajV7tK16w8vmsuUxq85UJ7+gWwd9YD3KaHxI9vx
        3TikSyX+8AMdwcbtl23t4aQMKi07JWeuEOXRw9E6YtHHgPZ5Giu//S1e65vserw4
        XcaRa6Lk12tZrqwNvBIyVPvrVmRY4Yz2zdkShTZ4FZCGJLDT6ugI/yDWUHXXfOg0
        cEuj/sg3e8WmDn5bR4GB8GDnV9YgjabpCtJKqXSIEuQR5ngxbUtjc6B8Cs5BQgIM
        9jiKVvZLb7FWwgceDT29bV++MjchOJx/U6VturdpK8ZOcv9Im6M99lAHbxAipqUR
        7zGzTvO5hIpfjQ==
X-ME-Sender: <xms:FP2XYPXoDsRdwwUqw3W0Jpx1NxqO4cNvEdePFamqWycrY8s0D02dmQ>
    <xme:FP2XYHlqd1_ZQ1aP0CrYAIdGqfye353BXrdBrI2RNYwKbBpLbiN0wO1oynraMpl9V
    HjrcnrnQvrdhio>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:FP2XYLZjbfzOFvdYjEgguPksut0E8BAqesFZ6oeny2rIeuKwoqP3pw>
    <xmx:FP2XYKVk1Ma-4rbdt4h3z0DICsLVWyAk3IysEW-UwaI9Bo6e9yMOxA>
    <xmx:FP2XYJncOpUVLpHWgkWuFgj3PUN7fe5CCNkchPTy-Qqu55Y7QT3Fug>
    <xmx:FP2XYHZ1DABDSZVHKGpS3JcBnmP7xgax9QavsLPnxv2RtMwhDwqmbg>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 11:17:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 02/10] ipv4: Add a sysctl to control multipath hash fields
Date:   Sun,  9 May 2021 18:16:07 +0300
Message-Id: <20210509151615.200608-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509151615.200608-1-idosch@idosch.org>
References: <20210509151615.200608-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

A subsequent patch will add a new multipath hash policy where the packet
fields used for multipath hash calculation are determined by user space.
This patch adds a sysctl that allows user space to set these fields.

The packet fields are represented using a bitmask and are common between
IPv4 and IPv6 to allow user space to use the same numbering across both
protocols. For example, to hash based on standard 5-tuple:

 # sysctl -w net.ipv4.fib_multipath_hash_fields=0x0037
 net.ipv4.fib_multipath_hash_fields = 0x0037

The kernel rejects unknown fields, for example:

 # sysctl -w net.ipv4.fib_multipath_hash_fields=0x1000
 sysctl: setting key "net.ipv4.fib_multipath_hash_fields": Invalid argument

More fields can be added in the future, if needed.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst | 27 ++++++++++++++++
 include/net/ip_fib.h                   | 43 ++++++++++++++++++++++++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/fib_frontend.c                |  6 ++++
 net/ipv4/sysctl_net_ipv4.c             | 11 +++++++
 5 files changed, 88 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c2ecc9894fd0..15982f830abc 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -100,6 +100,33 @@ fib_multipath_hash_policy - INTEGER
 	- 1 - Layer 4
 	- 2 - Layer 3 or inner Layer 3 if present
 
+fib_multipath_hash_fields - UNSIGNED INTEGER
+	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
+	fields used for multipath hash calculation are determined by this
+	sysctl.
+
+	This value is a bitmask which enables various fields for multipath hash
+	calculation.
+
+	Possible fields are:
+
+	====== ============================
+	0x0001 Source IP address
+	0x0002 Destination IP address
+	0x0004 IP protocol
+	0x0008 Unused
+	0x0010 Source port
+	0x0020 Destination port
+	0x0040 Inner source IP address
+	0x0080 Inner destination IP address
+	0x0100 Inner IP protocol
+	0x0200 Inner Flow Label
+	0x0400 Inner source port
+	0x0800 Inner destination port
+	====== ============================
+
+	Default: 0x0007 (source IP, destination IP and IP protocol)
+
 fib_sync_mem - UNSIGNED INTEGER
 	Amount of dirty memory from fib entries that can be backlogged before
 	synchronize_rcu is forced.
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index a914f33f3ed5..3ab2563b1a23 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -466,6 +466,49 @@ int fib_sync_up(struct net_device *dev, unsigned char nh_flags);
 void fib_sync_mtu(struct net_device *dev, u32 orig_mtu);
 void fib_nhc_update_mtu(struct fib_nh_common *nhc, u32 new, u32 orig);
 
+/* Fields used for sysctl_fib_multipath_hash_fields.
+ * Common to IPv4 and IPv6.
+ *
+ * Add new fields at the end. This is user API.
+ */
+#define FIB_MULTIPATH_HASH_FIELD_SRC_IP			BIT(0)
+#define FIB_MULTIPATH_HASH_FIELD_DST_IP			BIT(1)
+#define FIB_MULTIPATH_HASH_FIELD_IP_PROTO		BIT(2)
+#define FIB_MULTIPATH_HASH_FIELD_FLOWLABEL		BIT(3)
+#define FIB_MULTIPATH_HASH_FIELD_SRC_PORT		BIT(4)
+#define FIB_MULTIPATH_HASH_FIELD_DST_PORT		BIT(5)
+#define FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP		BIT(6)
+#define FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP		BIT(7)
+#define FIB_MULTIPATH_HASH_FIELD_INNER_IP_PROTO		BIT(8)
+#define FIB_MULTIPATH_HASH_FIELD_INNER_FLOWLABEL	BIT(9)
+#define FIB_MULTIPATH_HASH_FIELD_INNER_SRC_PORT		BIT(10)
+#define FIB_MULTIPATH_HASH_FIELD_INNER_DST_PORT		BIT(11)
+
+#define FIB_MULTIPATH_HASH_FIELD_OUTER_MASK		\
+	(FIB_MULTIPATH_HASH_FIELD_SRC_IP |		\
+	 FIB_MULTIPATH_HASH_FIELD_DST_IP |		\
+	 FIB_MULTIPATH_HASH_FIELD_IP_PROTO |		\
+	 FIB_MULTIPATH_HASH_FIELD_FLOWLABEL |		\
+	 FIB_MULTIPATH_HASH_FIELD_SRC_PORT |		\
+	 FIB_MULTIPATH_HASH_FIELD_DST_PORT)
+
+#define FIB_MULTIPATH_HASH_FIELD_INNER_MASK		\
+	(FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP |	\
+	 FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP |	\
+	 FIB_MULTIPATH_HASH_FIELD_INNER_IP_PROTO |	\
+	 FIB_MULTIPATH_HASH_FIELD_INNER_FLOWLABEL |	\
+	 FIB_MULTIPATH_HASH_FIELD_INNER_SRC_PORT |	\
+	 FIB_MULTIPATH_HASH_FIELD_INNER_DST_PORT)
+
+#define FIB_MULTIPATH_HASH_FIELD_ALL_MASK		\
+	(FIB_MULTIPATH_HASH_FIELD_OUTER_MASK |		\
+	 FIB_MULTIPATH_HASH_FIELD_INNER_MASK)
+
+#define FIB_MULTIPATH_HASH_FIELD_DEFAULT_MASK		\
+	(FIB_MULTIPATH_HASH_FIELD_SRC_IP |		\
+	 FIB_MULTIPATH_HASH_FIELD_DST_IP |		\
+	 FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
+
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		       const struct sk_buff *skb, struct flow_keys *flkeys);
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index f6af8d96d3c6..746c80cd4257 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -210,6 +210,7 @@ struct netns_ipv4 {
 #endif
 #endif
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
+	u32 sysctl_fib_multipath_hash_fields;
 	u8 sysctl_fib_multipath_use_neigh;
 	u8 sysctl_fib_multipath_hash_policy;
 #endif
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 84bb707bd88d..129213b7d834 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1516,6 +1516,12 @@ static int __net_init ip_fib_net_init(struct net *net)
 	if (err)
 		return err;
 
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+	/* Default to 3-tuple */
+	net->ipv4.sysctl_fib_multipath_hash_fields =
+		FIB_MULTIPATH_HASH_FIELD_DEFAULT_MASK;
+#endif
+
 	/* Avoid false sharing : Use at least a full cache line */
 	size = max_t(size_t, size, L1_CACHE_BYTES);
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index a62934b9f15a..da627c4d633a 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -19,6 +19,7 @@
 #include <net/snmp.h>
 #include <net/icmp.h>
 #include <net/ip.h>
+#include <net/ip_fib.h>
 #include <net/route.h>
 #include <net/tcp.h>
 #include <net/udp.h>
@@ -48,6 +49,8 @@ static int ip_ping_group_range_min[] = { 0, 0 };
 static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
 static u32 u32_max_div_HZ = UINT_MAX / HZ;
 static int one_day_secs = 24 * 3600;
+static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
+	FIB_MULTIPATH_HASH_FIELD_ALL_MASK;
 
 /* obsolete */
 static int sysctl_tcp_low_latency __read_mostly;
@@ -1052,6 +1055,14 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
+	{
+		.procname	= "fib_multipath_hash_fields",
+		.data		= &init_net.ipv4.sysctl_fib_multipath_hash_fields,
+		.maxlen		= sizeof(u32),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra2		= &fib_multipath_hash_fields_all_mask,
+	},
 #endif
 	{
 		.procname	= "ip_unprivileged_port_start",
-- 
2.31.1

