Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D365B377736
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 17:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhEIPS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 11:18:58 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51179 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229753AbhEIPSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 11:18:53 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 5482D5C00E7;
        Sun,  9 May 2021 11:17:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 09 May 2021 11:17:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=TO5bqtpQ1yrDlW9PElnLc8+tb3/i2nsyVx4KW06TjB0=; b=cRKHLzJ+
        HAP/3IcuMjPf8U9l62vW83xDL09EHQM+BE2O2Tt0F9NH88ur1TQINyKZC+TqlHqh
        CcO3i9MfQRuWUemBvcVOf5O9VODCgz/kDz+WpdeV5T9iioDkEEx95UHlb+6JmAGn
        dq9CO/DN3ecmF6uYdyQiEA0wCJlqcAhGG+MUFEJGPdzgUMGYGoVjIBpc0lckq4Hx
        EIylmxPIEuwS2QSVUQHxjitZC+Z3PGgLJfhBiAD01MilHlz1b9DOvJ6J53lieDxk
        tKOHL+tnm6K1gXNBXl/+q2tCvif02UsIDUlqQ64zdidwOUIFUgUZc77IDicmqZSN
        t739Ze+mMbe7og==
X-ME-Sender: <xms:Hv2XYNn6fYbYRlZcLlvFSF3M2rh0U7U153H_gqAaqA4-Yqbt7cQZZg>
    <xme:Hv2XYI3gBCnXEwBYvXJnG27JbaJoZFh5mU7kp_-Lo3T3XkdJAWA22g2oUy2eKQxtt
    bG5DNslDD_9Vus>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Hv2XYDqiLhiiv3c5iDfEcQ2HVKaD-h5lcAtZx0GVkgSmVf224QRpqA>
    <xmx:Hv2XYNma9k_kD71_Wq1tlN5HjSQtA79H544PCVg5G1QbqW5F_7C8xg>
    <xmx:Hv2XYL2obsWSBnvuhGJgz9fcZie_eNbOOnBBUGb8taLsjU_FJD219A>
    <xmx:Hv2XYFrIs9dosr2Sd4FVzLwkHVwCaqDUxVDxN5fmy2ARpBdLYrnRIQ>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 11:17:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 05/10] ipv6: Calculate multipath hash inside switch statement
Date:   Sun,  9 May 2021 18:16:10 +0300
Message-Id: <20210509151615.200608-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509151615.200608-1-idosch@idosch.org>
References: <20210509151615.200608-1-idosch@idosch.org>
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
2.31.1

