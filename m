Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C14D370DE8
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 18:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhEBQZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 12:25:40 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51983 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhEBQZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 12:25:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1BDDC5C0117;
        Sun,  2 May 2021 12:24:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 02 May 2021 12:24:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=+yGDr1o/AdqfdazCVVHpxRhJv7r9IzDpMacLAbNiGM0=; b=ES/TV+Ii
        MxYuVIlkDEEHQPrXqhYWquawjQndVlDJSuJE4Iz3r03gR5W13HagM2ANX9cPhzAJ
        9ZlrqNVidT1xaPOlO7LLjl2+is3PdzaAphRtXHPQwG1Bk7JM6jUOd5APG/5y/tHA
        YBsYyHrNCB8fSGZO0fpXYNTkOk8F95g9MLjhEsig8hliX+hMbyMKLLLhe7n5UL10
        Z/nBcvvt9MeQSsgBYgI+7XIHdkl6gL59/E0t6zEZ/IXsG72RuPLF0XGLoFT682wn
        z+s/q1yNEfApnc5s2ZZrxIusG/UBuM87K8K7izxSkXzhwru7OJ32dmt7agBuJOLS
        hu7nEPmFM7OVXw==
X-ME-Sender: <xms:T9KOYB6nCWuFQj7ZnHp3sFJXkQLN6G2vSosOMCfSsLe0LCKZVCzIXw>
    <xme:T9KOYO4335qS73KyLJ7Bq0QGHs0_lsleTTWgdRITYeDi8g5kajmikFV_v1hrdEdIO
    75dcx8Pjmv8BmU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefvddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:UNKOYIf8Emj7kVAX6z8R4TskVWOmp2ztYlmigX0dDR60GJ2s8B-5MA>
    <xmx:UNKOYKI7ToJVNCnDQ0QdOjkt_eR2jtooIrC9x-VJO73bb-9GzDCQwg>
    <xmx:UNKOYFK0fnbzH3w1Ac73yxTGFEkhJw6aLZt0S9I0V-giwFT2hJsShg>
    <xmx:UNKOYN8Px-UdjTXnNNl_TPOdIfmqXBadDzE6JmZZ1k1NqSvvei_k0Q>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 12:24:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 03/10] ipv4: Add custom multipath hash policy
Date:   Sun,  2 May 2021 19:22:50 +0300
Message-Id: <20210502162257.3472453-4-idosch@idosch.org>
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
 net/ipv4/route.c                       | 121 +++++++++++++++++++++++++
 net/ipv4/sysctl_net_ipv4.c             |   3 +-
 3 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 8ab61f4edf02..549601494694 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -99,6 +99,8 @@ fib_multipath_hash_policy - INTEGER
 	- 0 - Layer 3
 	- 1 - Layer 4
 	- 2 - Layer 3 or inner Layer 3 if present
+	- 3 - Custom multipath hash. Fields used for multipath hash calculation
+	  are determined by fib_multipath_hash_fields sysctl
 
 fib_multipath_hash_fields - list of comma separated ranges
 	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 9d61e969446e..995799a6e06f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1906,6 +1906,121 @@ static void ip_multipath_l3_keys(const struct sk_buff *skb,
 	hash_keys->addrs.v4addrs.dst = key_iph->daddr;
 }
 
+static u32 fib_multipath_custom_hash_outer(const struct net *net,
+					   const struct sk_buff *skb,
+					   bool *p_has_inner)
+{
+	unsigned long *hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	struct flow_keys keys, hash_keys;
+
+	if (!net->ipv4.fib_multipath_hash_fields_need_outer)
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	skb_flow_dissect_flow_keys(skb, &keys, FLOW_DISSECTOR_F_STOP_AT_ENCAP);
+
+	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_IP, hash_fields))
+		hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_IP, hash_fields))
+		hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(IP_PROTO, hash_fields))
+		hash_keys.basic.ip_proto = keys.basic.ip_proto;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_PORT, hash_fields))
+		hash_keys.ports.src = keys.ports.src;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_PORT, hash_fields))
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
+	unsigned long *hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	struct flow_keys keys, hash_keys;
+
+	/* We assume the packet carries an encapsulation, but if none was
+	 * encountered during dissection of the outer flow, then there is no
+	 * point in calling the flow dissector again.
+	 */
+	if (!has_inner)
+		return 0;
+
+	if (!net->ipv4.fib_multipath_hash_fields_need_inner)
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
+	unsigned long *hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	struct flow_keys hash_keys;
+
+	if (!net->ipv4.fib_multipath_hash_fields_need_outer)
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_IP, hash_fields))
+		hash_keys.addrs.v4addrs.src = fl4->saddr;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_IP, hash_fields))
+		hash_keys.addrs.v4addrs.dst = fl4->daddr;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(IP_PROTO, hash_fields))
+		hash_keys.basic.ip_proto = fl4->flowi4_proto;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_PORT, hash_fields))
+		hash_keys.ports.src = fl4->fl4_sport;
+	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_PORT, hash_fields))
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
index 0db7e68c38cd..988defcd8ae3 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -30,6 +30,7 @@
 #include <net/netevent.h>
 
 static int two = 2;
+static int three __maybe_unused = 3;
 static int four = 4;
 static int thousand = 1000;
 static int tcp_retr1_max = 255;
@@ -1075,7 +1076,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_fib_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= &three,
 	},
 	{
 		.procname	= "fib_multipath_hash_fields",
-- 
2.30.2

