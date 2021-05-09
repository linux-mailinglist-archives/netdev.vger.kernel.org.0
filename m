Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CFF377734
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 17:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhEIPSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 11:18:51 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49459 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229753AbhEIPSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 11:18:47 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 6F6A65C00E7;
        Sun,  9 May 2021 11:17:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 09 May 2021 11:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=vPofoYkw+TbS8iE1GoEmPlWBECL2qARPrf6pOzpHnRY=; b=aJ20o7KV
        EStUxkGFmkIUGklDn8g8NCqexYvIgIdkih4Nxs67F1LssbpR1EBR7oVn1sx9F4ht
        cUn88kLtjWWtEXohqB345OdiNIVdo29fzAkfSgo+xst9BPgGcK3+K5T53Aq8qnc7
        swa/hRJM68HaSiRRg9H/eGxbZtFu5DitWXPo3gSustPVX24rFqsxnCGUN1hGHHZ7
        WfX/jOEolomUR2lqBW8r/mK/VG8tWjJ7uSvs8nNqqEh+MwBmeQjQeQ85Vw+KMIXl
        LCAtTXq7XwVuHD86shyRpTaMH4kjk6Yhp1TZ4TDuBfhPE13ivTW2r0cMPRgt0S7u
        bwbRDUGy41JpdQ==
X-ME-Sender: <xms:F_2XYJCsKMujVOHO2J7dhT3sctJZ8Mtk0GjYklKuUvms2-bsqlN3Pw>
    <xme:F_2XYHj1EEi_Qzv8Uw6M414PJb4YcPFbEnF5KO1F3fiAp11RwSjnuXMfs-Rghm0vW
    hiQcjzwtcnK3SI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:F_2XYEmswj1jtFiNh3pmxjAetux9M-GR0O3znw5zKZHUdGn3QbIvyQ>
    <xmx:F_2XYDxd3JjKEuPbpRDcxy7Fsf4CCgdjdL6ePhNa2vKaY_KBPCd3yg>
    <xmx:F_2XYOReK0kaLsCogvm6nqo5oQY5Sv2k_QEu6mP0SEtY65P221kv3A>
    <xmx:GP2XYNFVWsOsaCA3d_xxiJu_UebNMA_2pxtT3tiyiSZYp2iiSrCE9g>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 11:17:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 03/10] ipv4: Add custom multipath hash policy
Date:   Sun,  9 May 2021 18:16:08 +0300
Message-Id: <20210509151615.200608-4-idosch@idosch.org>
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
 net/ipv4/route.c                       | 121 +++++++++++++++++++++++++
 net/ipv4/sysctl_net_ipv4.c             |   3 +-
 3 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 15982f830abc..2c3b7677222e 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -99,6 +99,8 @@ fib_multipath_hash_policy - INTEGER
 	- 0 - Layer 3
 	- 1 - Layer 4
 	- 2 - Layer 3 or inner Layer 3 if present
+	- 3 - Custom multipath hash. Fields used for multipath hash calculation
+	  are determined by fib_multipath_hash_fields sysctl
 
 fib_multipath_hash_fields - UNSIGNED INTEGER
 	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 9d61e969446e..a4c477475f4c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1906,6 +1906,121 @@ static void ip_multipath_l3_keys(const struct sk_buff *skb,
 	hash_keys->addrs.v4addrs.dst = key_iph->daddr;
 }
 
+static u32 fib_multipath_custom_hash_outer(const struct net *net,
+					   const struct sk_buff *skb,
+					   bool *p_has_inner)
+{
+	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	struct flow_keys keys, hash_keys;
+
+	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	skb_flow_dissect_flow_keys(skb, &keys, FLOW_DISSECTOR_F_STOP_AT_ENCAP);
+
+	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
+		hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
+		hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
+		hash_keys.basic.ip_proto = keys.basic.ip_proto;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
+		hash_keys.ports.src = keys.ports.src;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
+		hash_keys.ports.dst = keys.ports.dst;
+
+	*p_has_inner = !!(keys.control.flags & FLOW_DIS_ENCAPSULATION);
+	return flow_hash_from_keys(&hash_keys);
+}
+
+static u32 fib_multipath_custom_hash_inner(const struct net *net,
+					   const struct sk_buff *skb,
+					   bool has_inner)
+{
+	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
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
+static u32 fib_multipath_custom_hash_skb(const struct net *net,
+					 const struct sk_buff *skb)
+{
+	u32 mhash, mhash_inner;
+	bool has_inner = true;
+
+	mhash = fib_multipath_custom_hash_outer(net, skb, &has_inner);
+	mhash_inner = fib_multipath_custom_hash_inner(net, skb, has_inner);
+
+	return jhash_2words(mhash, mhash_inner, 0);
+}
+
+static u32 fib_multipath_custom_hash_fl4(const struct net *net,
+					 const struct flowi4 *fl4)
+{
+	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	struct flow_keys hash_keys;
+
+	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
+		hash_keys.addrs.v4addrs.src = fl4->saddr;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
+		hash_keys.addrs.v4addrs.dst = fl4->daddr;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
+		hash_keys.basic.ip_proto = fl4->flowi4_proto;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
+		hash_keys.ports.src = fl4->fl4_sport;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
+		hash_keys.ports.dst = fl4->fl4_dport;
+
+	return flow_hash_from_keys(&hash_keys);
+}
+
 /* if skb is set it will be used and fl4 can be NULL */
 int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		       const struct sk_buff *skb, struct flow_keys *flkeys)
@@ -1991,6 +2106,12 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		}
 		mhash = flow_hash_from_keys(&hash_keys);
 		break;
+	case 3:
+		if (skb)
+			mhash = fib_multipath_custom_hash_skb(net, skb);
+		else
+			mhash = fib_multipath_custom_hash_fl4(net, fl4);
+		break;
 	}
 
 	if (multipath_hash)
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index da627c4d633a..90b3b924b761 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -30,6 +30,7 @@
 #include <net/netevent.h>
 
 static int two = 2;
+static int three __maybe_unused = 3;
 static int four = 4;
 static int thousand = 1000;
 static int tcp_retr1_max = 255;
@@ -1053,7 +1054,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_fib_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= &three,
 	},
 	{
 		.procname	= "fib_multipath_hash_fields",
-- 
2.31.1

