Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EAE377731
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 17:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhEIPSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 11:18:43 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42047 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229712AbhEIPSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 11:18:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DA6995C00E7;
        Sun,  9 May 2021 11:17:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 09 May 2021 11:17:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=vJMUtGJcDyB+PdPl0g3TEX6/JZtkvnAzK7wFolAV4UA=; b=I6ZGN2MK
        FP8vG+pSwf/XC9tjgEsGnrhoQRGKXCwNFyLHs4e8hKEt2ceKleaOXqfUlXir322r
        L3WwzxdNPmxOzdxqCoX11b9JWIKzXxiXiFVae9RgAY1HQPr9o2Ql20YHxzNx8h2g
        znoBXee7V6c0kDgNClmhnwCspqsqTN68GWGFUtd/11zNaG1WTl5COWQYiz3zOVnE
        o3UuiADCbQGAMPOm3xCwgmWEaHypZQh4DdDa6WxOsVa84OsiimU5ChzerfzHsGdm
        Czw/cHU+mN+9zTTyXtM/jb0PpNDJeVsIGZw/26APKFHZ78M4Lx1bsU8kQ9AuVAsF
        +0O93tcBnbrhkw==
X-ME-Sender: <xms:Ef2XYCrGrIDTuwBb68Q9D1Sm6r2vs0t1AX0NIu7PXgS7-FBRwBMaKQ>
    <xme:Ef2XYAo4SGangVrBduUato5VgByV8ojxXmscX9lsfjIz8BeNnyoWJ_al4lqmollQg
    7CZTr6bTmydf4k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Ef2XYHMwsbueGl-fjoE7YONDNq-e1UwwLf59iAhGmxqBFwsF7GgvCA>
    <xmx:Ef2XYB5f4MQv9u5sCCeZqn2jRLjc1ixhX27jRHzEPG1Q_Q9U73OUkA>
    <xmx:Ef2XYB446Vj4SFXVWKuoQw6E8vIGK87tI2kjclZM-NlvIfsVnVy5wg>
    <xmx:Ef2XYOsJ4DspI32yini9PjJCLk_iC-nXilyWC_I3spdk4IBv6-7T5A>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 11:17:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 01/10] ipv4: Calculate multipath hash inside switch statement
Date:   Sun,  9 May 2021 18:16:06 +0300
Message-Id: <20210509151615.200608-2-idosch@idosch.org>
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
 net/ipv4/route.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f6787c55f6ab..9d61e969446e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1912,7 +1912,7 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 {
 	u32 multipath_hash = fl4 ? fl4->flowi4_multipath_hash : 0;
 	struct flow_keys hash_keys;
-	u32 mhash;
+	u32 mhash = 0;
 
 	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
 	case 0:
@@ -1924,6 +1924,7 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 			hash_keys.addrs.v4addrs.src = fl4->saddr;
 			hash_keys.addrs.v4addrs.dst = fl4->daddr;
 		}
+		mhash = flow_hash_from_keys(&hash_keys);
 		break;
 	case 1:
 		/* skb is currently provided only when forwarding */
@@ -1957,6 +1958,7 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 			hash_keys.ports.dst = fl4->fl4_dport;
 			hash_keys.basic.ip_proto = fl4->flowi4_proto;
 		}
+		mhash = flow_hash_from_keys(&hash_keys);
 		break;
 	case 2:
 		memset(&hash_keys, 0, sizeof(hash_keys));
@@ -1987,9 +1989,9 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 			hash_keys.addrs.v4addrs.src = fl4->saddr;
 			hash_keys.addrs.v4addrs.dst = fl4->daddr;
 		}
+		mhash = flow_hash_from_keys(&hash_keys);
 		break;
 	}
-	mhash = flow_hash_from_keys(&hash_keys);
 
 	if (multipath_hash)
 		mhash = jhash_2words(mhash, multipath_hash, 0);
-- 
2.31.1

