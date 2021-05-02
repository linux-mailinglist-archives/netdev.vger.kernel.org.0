Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75086370DE6
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 18:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhEBQZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 12:25:35 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34943 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhEBQZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 12:25:35 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 903215C011D;
        Sun,  2 May 2021 12:24:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 02 May 2021 12:24:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=A3sH6QRmOFJww5oDye1PHFbjTLC1JchZ/MTPAnasEVE=; b=bRjsFvbA
        8bS1vuijg6JhD/IYnvwDuYhX1pg2ogTZLaK3Z2lVYV4vEduFsQl658DiiLDTnoYi
        MLgQijBbVExbl9reZqmlHwck0/ZHVTLyAYZr66vNGczBPcO0lKp6ZhsPm45f5E4r
        E3l5yqlDDV/pGqqCjNvX0NXWgQhGOYFYiLA8Ouin5IjWK5HSAO81BSxbp6ZIEj2p
        He+UfsgKgTYJHqNSpYNpW2ZUaNQpvXFazojFuCBd54REmEmbS+Bg0hs3aPfRVxEq
        6GE0E4SX6A43bZXrRety7HMs2fHdoo+4f9lVqZldsF9sH/4380j4tn08zzNzF57V
        OU0N9RPBH818tg==
X-ME-Sender: <xms:S9KOYGg79G0iU7U7k1E_7pfn4xbhZOJsn27EBtxrrgAL-MfePtCELw>
    <xme:S9KOYHDXMnqKrh1zfCBrWDvKl1J_TZMrscwaW7OBib29O0A5yj12id7gVZ6IDEE5y
    Qfbtix6FZkQE9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefvddgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:S9KOYOGy1GclAzfw35IreBknWykPJL3laFp7yOrurC66MMw8cniUtg>
    <xmx:S9KOYPS7lZi83WdQXJgnHWRwue_PYwYDJbK31T9GwF5sxxglk118Lw>
    <xmx:S9KOYDwD0pcEunc6DTIJas3w9TFwUGHBUlMMif9AupW2cDivx9rJ4w>
    <xmx:S9KOYKlKB2rXIhsP10FcNS33Z9JGCL2Wjp64SjJln45eaH69wx93QQ>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 12:24:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 01/10] ipv4: Calculate multipath hash inside switch statement
Date:   Sun,  2 May 2021 19:22:48 +0300
Message-Id: <20210502162257.3472453-2-idosch@idosch.org>
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
2.30.2

