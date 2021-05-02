Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6602A370DEC
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 18:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhEBQZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 12:25:51 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56579 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhEBQZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 12:25:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 02C7A5C0139;
        Sun,  2 May 2021 12:24:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 02 May 2021 12:24:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=rvJu9s7cYpH3BPPQQUlSTGl8+7ztPDbXW/o2v3PzryY=; b=pBBHKj6Y
        fP7lzarn+5DOicQoqOqAU981brpaUq+IYWdTwTrhgr+9p2ajChYn7aS4q+Driyze
        v10CDeZlGf9jkeUJ3DnTPEmmbg0j3cQPLPptlpCR1lpIUd4LLBTq30IuS/qoGuw7
        iYMo8KuglIo13MwWZ5WDfyy6NUg28wjh+duhAfv9mPwKIaXTfuR9LpYP7cotu+Jn
        UmFADJ1oOsldgDI6lDdbU3I4iZkGZwRXL1oN4K9RDTOug2O1UvW9QgmVTQEWnO/q
        IWhGXt1KZoI3/S5e57WCQP2TQtd6deL1LptNCZKSWC7eYLjUwJIokTRkZN+pBMWR
        zZpPsUabnb3C3g==
X-ME-Sender: <xms:WtKOYEUdNh6rv_A5nyVsBjUXbV6Ft2aIm4BLfZ6h6sbmAIf6V9bVzw>
    <xme:WtKOYImQ6JSkaxahavVRd5VlvoS8jF0xQl_8wgFEHJFqFCQn8y6Il0JDOKp41K91y
    yzseieUolEoxzo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefvddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:WtKOYIb4jFybsUqlx6zNHpXeiqOXdo1mF_l2hQMInHdLAWYD72xtXg>
    <xmx:WtKOYDWhuaORNRlKX6IU7IExjiF9WIMOQTp_CUycpe9UkOvPOSocFg>
    <xmx:WtKOYOkF_0tQUj7h3O_Jy8dgg9771AuRXU8hUP66Gl282shCYGHmuw>
    <xmx:W9KOYMZdqeaOcx09o_cr0RQF6S02GP2VY8LoKIevvfr2uLZ-_o-uVA>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 12:24:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 07/10] ipv6: Add custom multipath hash policy
Date:   Sun,  2 May 2021 19:22:54 +0300
Message-Id: <20210502162257.3472453-8-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502162257.3472453-1-idosch@idosch.org>
References: <20210502162257.3472453-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add a new multipath hash policy where the packet fields used for hash
calculation are determined by user space via the
fib_multipath_hash_fields sysctl that was introduced in the previous
patch.

The current set of available packet fields includes both outer and inner
fields, which requires two invocations of the flow dissector. Avoid
unnecessary dissection of the outer or inner flows by skipping
dissection if the 'need_outer' or 'need_inner' variables are not set.
These fields are set / cleared as part of the control path when the
fib_multipath_hash_fields sysctl is configured.

In accordance with the existing policies, when an skb is not available,
packet fields are extracted from the provided flow key. In which case,
only outer fields are considered.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst |   2 +
 net/ipv6/route.c                       | 125 +++++++++++++++++++++++++
 net/ipv6/sysctl_net_ipv6.c             |   3 +-
 3 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 5289336227b3..8b88499fe555 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1774,6 +1774,8 @@ fib_multipath_hash_policy - INTEGER
 	- 0 - Layer 3 (source and destination addresses plus flow label)
 	- 1 - Layer 4 (standard 5-tuple)
 	- 2 - Layer 3 or inner Layer 3 if present
+	- 3 - Custom multipath hash. Fields used for multipath hash calculation
+	  are determined by fib_multipath_hash_fields sysctl
 
 fib_multipath_hash_fields - list of comma separated ranges
 	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 9935e18146e5..b4c65c5baf35 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2326,6 +2326,125 @@ static void ip6_multipath_l3_keys(const struct sk_buff *skb,
 	}
 }
 
+static u32 rt6_multipath_custom_hash_outer(const struct net *net,
+					   const struct sk_buff *skb,
+					   bool *p_has_inner)
+{
+	unsigned long *hash_fields = ip6_multipath_hash_fields(net);
+	struct flow_keys keys, hash_keys;
+
+	if (!net->ipv6.sysctl.multipath_hash_fields_need_outer)
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	skb_flow_dissect_flow_keys(skb, &keys, FLOW_DISSECTOR_F_STOP_AT_ENCAP);
+
+	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_IP, hash_fields))
+		hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_IP, hash_fields))
+		hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(IP_PROTO, hash_fields))
+		hash_keys.basic.ip_proto = keys.basic.ip_proto;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(FLOWLABEL, hash_fields))
+		hash_keys.tags.flow_label = keys.tags.flow_label;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_PORT, hash_fields))
+		hash_keys.ports.src = keys.ports.src;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_PORT, hash_fields))
+		hash_keys.ports.dst = keys.ports.dst;
+
+	*p_has_inner = !!(keys.control.flags & FLOW_DIS_ENCAPSULATION);
+	return flow_hash_from_keys(&hash_keys);
+}
+
+static u32 rt6_multipath_custom_hash_inner(const struct net *net,
+					   const struct sk_buff *skb,
+					   bool has_inner)
+{
+	unsigned long *hash_fields = ip6_multipath_hash_fields(net);
+	struct flow_keys keys, hash_keys;
+
+	/* We assume the packet carries an encapsulation, but if none was
+	 * encountered during dissection of the outer flow, then there is no
+	 * point in calling the flow dissector again.
+	 */
+	if (!has_inner)
+		return 0;
+
+	if (!net->ipv6.sysctl.multipath_hash_fields_need_inner)
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	skb_flow_dissect_flow_keys(skb, &keys, 0);
+
+	if (!(keys.control.flags & FLOW_DIS_ENCAPSULATION))
+		return 0;
+
+	if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_SRC_IP, hash_fields))
+			hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
+		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_DST_IP, hash_fields))
+			hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
+	} else if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_SRC_IP, hash_fields))
+			hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
+		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_DST_IP, hash_fields))
+			hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
+		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_FLOWLABEL, hash_fields))
+			hash_keys.tags.flow_label = keys.tags.flow_label;
+	}
+
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_IP_PROTO, hash_fields))
+		hash_keys.basic.ip_proto = keys.basic.ip_proto;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_SRC_PORT, hash_fields))
+		hash_keys.ports.src = keys.ports.src;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_DST_PORT, hash_fields))
+		hash_keys.ports.dst = keys.ports.dst;
+
+	return flow_hash_from_keys(&hash_keys);
+}
+
+static u32 rt6_multipath_custom_hash_skb(const struct net *net,
+					 const struct sk_buff *skb)
+{
+	u32 mhash, mhash_inner;
+	bool has_inner = true;
+
+	mhash = rt6_multipath_custom_hash_outer(net, skb, &has_inner);
+	mhash_inner = rt6_multipath_custom_hash_inner(net, skb, has_inner);
+
+	return jhash_2words(mhash, mhash_inner, 0);
+}
+
+static u32 rt6_multipath_custom_hash_fl6(const struct net *net,
+					 const struct flowi6 *fl6)
+{
+	unsigned long *hash_fields = ip6_multipath_hash_fields(net);
+	struct flow_keys hash_keys;
+
+	if (!net->ipv6.sysctl.multipath_hash_fields_need_outer)
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_IP, hash_fields))
+		hash_keys.addrs.v6addrs.src = fl6->saddr;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_IP, hash_fields))
+		hash_keys.addrs.v6addrs.dst = fl6->daddr;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(IP_PROTO, hash_fields))
+		hash_keys.basic.ip_proto = fl6->flowi6_proto;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(FLOWLABEL, hash_fields))
+		hash_keys.tags.flow_label = (__force u32)flowi6_get_flowlabel(fl6);
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_PORT, hash_fields))
+		hash_keys.ports.src = fl6->fl6_sport;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_PORT, hash_fields))
+		hash_keys.ports.dst = fl6->fl6_dport;
+
+	return flow_hash_from_keys(&hash_keys);
+}
+
 /* if skb is set it will be used and fl6 can be NULL */
 u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 		       const struct sk_buff *skb, struct flow_keys *flkeys)
@@ -2416,6 +2535,12 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 		}
 		mhash = flow_hash_from_keys(&hash_keys);
 		break;
+	case 3:
+		if (skb)
+			mhash = rt6_multipath_custom_hash_skb(net, skb);
+		else
+			mhash = rt6_multipath_custom_hash_fl6(net, fl6);
+		break;
 	}
 
 	return mhash >> 1;
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 8d94a1d621d0..38d444b1bb60 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -23,6 +23,7 @@
 #endif
 
 static int two = 2;
+static int three = 3;
 static int flowlabel_reflect_max = 0x7;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
 
@@ -174,7 +175,7 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler   = proc_rt6_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= &three,
 	},
 	{
 		.procname	= "fib_multipath_hash_fields",
-- 
2.30.2

