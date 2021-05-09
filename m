Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56605377738
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 17:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhEIPTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 11:19:01 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37291 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229768AbhEIPS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 11:18:59 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 432AF5C00E8;
        Sun,  9 May 2021 11:17:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 09 May 2021 11:17:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=wUMb2p5zynoYXo2InA/UgzAhuwA5/8jhzhO/0g6JiXM=; b=gTx3YRNZ
        njEpWwcs9L5JEEKDYpQa+hDXyDo8nEDlYjjzqfv3IBzFyNokxAacE78OO8RHGQSO
        rlfsD9EfmUVHchobaV3Ux87o49fyV+tVeazuUi2z8HlmPIuyQIb2Oi4MfVB5uhSm
        RF3TQF01ID+cEs76RoUqMMb4EFUKHHbyqzThYXmKeYLsiQb8dEzTjYq+8VHZtKBx
        ct93iVXg/Bv2HgBXQ9mx2m+nOVaq5XDjelWUkEE5rMRQnC7IIRNvYcMxzDPySLzH
        d75BzmAqCanzW4HfZqSF8xBSF89Pmp8WH3uliW56y532WOmOklsvwCrtayjdaMKI
        MsdPMhuYAp+EIA==
X-ME-Sender: <xms:JP2XYJz1PGqA2k4IB6F-zBaspXUVr4MvjTAfREQbgNSu5BmrTeUUog>
    <xme:JP2XYJTXZPwTt-SqGJkQfxkEKl9p3yIvh73OEhzI6Vwb5ln0YizlXhZ5IAtntNYjR
    FYKVHSjQ7o-s6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:JP2XYDUabxwn7QKUh017gUJqpy4UJN0XfwlG_1m9trqoCmuPkGjP_Q>
    <xmx:JP2XYLgymVCb80jLRnGn3Y2ycItxoK17zNi6II38f8EOLKcwStBwbw>
    <xmx:JP2XYLCsr4LetPu5ZyuBuwlenhXbrwFZyo1EkcwpQ7gaRBbjJtG_Bg>
    <xmx:JP2XYN35guklj4QR7Gi5xOsLhcGhC8jKu5V2VDDrkXzWw5bta0VuGQ>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 11:17:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 07/10] ipv6: Add custom multipath hash policy
Date:   Sun,  9 May 2021 18:16:12 +0300
Message-Id: <20210509151615.200608-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509151615.200608-1-idosch@idosch.org>
References: <20210509151615.200608-1-idosch@idosch.org>
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
dissection if none of the outer or inner fields are required.

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
index f7ae65524ff3..3d5f17d3c4f6 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1772,6 +1772,8 @@ fib_multipath_hash_policy - INTEGER
 	- 0 - Layer 3 (source and destination addresses plus flow label)
 	- 1 - Layer 4 (standard 5-tuple)
 	- 2 - Layer 3 or inner Layer 3 if present
+	- 3 - Custom multipath hash. Fields used for multipath hash calculation
+	  are determined by fib_multipath_hash_fields sysctl
 
 fib_multipath_hash_fields - UNSIGNED INTEGER
 	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 9935e18146e5..c46889381ae4 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2326,6 +2326,125 @@ static void ip6_multipath_l3_keys(const struct sk_buff *skb,
 	}
 }
 
+static u32 rt6_multipath_custom_hash_outer(const struct net *net,
+					   const struct sk_buff *skb,
+					   bool *p_has_inner)
+{
+	u32 hash_fields = ip6_multipath_hash_fields(net);
+	struct flow_keys keys, hash_keys;
+
+	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	skb_flow_dissect_flow_keys(skb, &keys, FLOW_DISSECTOR_F_STOP_AT_ENCAP);
+
+	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
+		hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
+		hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
+		hash_keys.basic.ip_proto = keys.basic.ip_proto;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_FLOWLABEL)
+		hash_keys.tags.flow_label = keys.tags.flow_label;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
+		hash_keys.ports.src = keys.ports.src;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
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
+	u32 hash_fields = ip6_multipath_hash_fields(net);
+	struct flow_keys keys, hash_keys;
+
+	/* We assume the packet carries an encapsulation, but if none was
+	 * encountered during dissection of the outer flow, then there is no
+	 * point in calling the flow dissector again.
+	 */
+	if (!has_inner)
+		return 0;
+
+	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_MASK))
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
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP)
+			hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP)
+			hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
+	} else if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP)
+			hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP)
+			hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_FLOWLABEL)
+			hash_keys.tags.flow_label = keys.tags.flow_label;
+	}
+
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_IP_PROTO)
+		hash_keys.basic.ip_proto = keys.basic.ip_proto;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_PORT)
+		hash_keys.ports.src = keys.ports.src;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_PORT)
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
+	u32 hash_fields = ip6_multipath_hash_fields(net);
+	struct flow_keys hash_keys;
+
+	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
+		hash_keys.addrs.v6addrs.src = fl6->saddr;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
+		hash_keys.addrs.v6addrs.dst = fl6->daddr;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
+		hash_keys.basic.ip_proto = fl6->flowi6_proto;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_FLOWLABEL)
+		hash_keys.tags.flow_label = (__force u32)flowi6_get_flowlabel(fl6);
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
+		hash_keys.ports.src = fl6->fl6_sport;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
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
index fb73d9839bc8..fe608f619ffd 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -23,6 +23,7 @@
 #endif
 
 static int two = 2;
+static int three = 3;
 static int flowlabel_reflect_max = 0x7;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
 static u32 rt6_multipath_hash_fields_all_mask =
@@ -152,7 +153,7 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler   = proc_rt6_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= &three,
 	},
 	{
 		.procname	= "fib_multipath_hash_fields",
-- 
2.31.1

