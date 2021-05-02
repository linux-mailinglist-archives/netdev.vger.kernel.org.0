Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2ED3370DEA
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 18:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhEBQZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 12:25:46 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51159 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhEBQZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 12:25:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AA8AF5C0135;
        Sun,  2 May 2021 12:24:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 02 May 2021 12:24:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=5EzNwX5cPveEgm3tihSJJobXk46uSK4/sZLomhcpN1s=; b=BUwHq+LN
        VTMZNrz2si4i+uv1iFC8n1GgYVaduZ6+m0JnxunhMI1QsdO6d9oskDQp40gWv7sE
        2MPSok1OBxBakfsP9jO2mgtvT1TkLO7vGxSFH/EwubZ7Er0uFq28KExN6FJpnO/V
        7GCMiGmekBo8m4kt2ARYiRK43rt5wLrp1eIQMTLVqQz+sfen8THu6mtloLonlPv1
        bDAMquHw/xe9ItHCDXOFFv6+rk+nmTjeWSPlNw/e1hT1H7atJpmGie6Dm25Bqab8
        MiIu4FwBfocuPAW4W9FV7CmDthRGOrbL3GtAeaijeXWaVbGBkVp6cwkvebRFUqyL
        SHg6RcVTdpC9WQ==
X-ME-Sender: <xms:VdKOYFwyN8eb9TvN1A8wdV_nXzN2U4q7P8x-lcMKQI3tfBESQtvaqQ>
    <xme:VdKOYFQ1heYojiGJkKTd4-U5oMtpxGEoEdeOXLTRcWy4swNweAqbF4SAL3biJO53K
    Dws0_h0WCuDeho>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefvddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:VdKOYPWEcc2HEei7MjL8tPr7YFwj6G20pkLSTgVuqS0akryajWJMiQ>
    <xmx:VdKOYHgmicM8FG5RT0Jyipt5vjsVVvaTLw7ZcRR3dOUylHga7bbVoA>
    <xmx:VdKOYHD12Dx6OUwWdpTrlR4jgztlVjonD75wgLU2x1SOrHFhROCOqA>
    <xmx:VdKOYJ3mhQDae8yBS4nDJlgHQ5qBbzZlAEghp0pzjzuvjPrfFEweig>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 12:24:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 05/10] ipv6: Calculate multipath hash inside switch statement
Date:   Sun,  2 May 2021 19:22:52 +0300
Message-Id: <20210502162257.3472453-6-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502162257.3472453-1-idosch@idosch.org>
References: <20210502162257.3472453-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

A subsequent patch will add another multipath hash policy where the
multipath hash is calculated directly by the policy specific code and
not outside of the switch statement.

Prepare for this change by moving the multipath hash calculation inside
the switch statement.

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv6/route.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a22822bdbf39..9935e18146e5 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2331,7 +2331,7 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 		       const struct sk_buff *skb, struct flow_keys *flkeys)
 {
 	struct flow_keys hash_keys;
-	u32 mhash;
+	u32 mhash = 0;
 
 	switch (ip6_multipath_hash_policy(net)) {
 	case 0:
@@ -2345,6 +2345,7 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 			hash_keys.tags.flow_label = (__force u32)flowi6_get_flowlabel(fl6);
 			hash_keys.basic.ip_proto = fl6->flowi6_proto;
 		}
+		mhash = flow_hash_from_keys(&hash_keys);
 		break;
 	case 1:
 		if (skb) {
@@ -2376,6 +2377,7 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 			hash_keys.ports.dst = fl6->fl6_dport;
 			hash_keys.basic.ip_proto = fl6->flowi6_proto;
 		}
+		mhash = flow_hash_from_keys(&hash_keys);
 		break;
 	case 2:
 		memset(&hash_keys, 0, sizeof(hash_keys));
@@ -2412,9 +2414,9 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 			hash_keys.tags.flow_label = (__force u32)flowi6_get_flowlabel(fl6);
 			hash_keys.basic.ip_proto = fl6->flowi6_proto;
 		}
+		mhash = flow_hash_from_keys(&hash_keys);
 		break;
 	}
-	mhash = flow_hash_from_keys(&hash_keys);
 
 	return mhash >> 1;
 }
-- 
2.30.2

