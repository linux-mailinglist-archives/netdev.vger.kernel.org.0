Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29FF7C07E
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 13:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbfGaLwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 07:52:13 -0400
Received: from correo.us.es ([193.147.175.20]:59314 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728195AbfGaLwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 07:52:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 216F28076C
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:52:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11172203F3
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:52:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0665FDA732; Wed, 31 Jul 2019 13:52:07 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BBB7CDA732;
        Wed, 31 Jul 2019 13:52:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 31 Jul 2019 13:52:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3DEC24265A31;
        Wed, 31 Jul 2019 13:52:04 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/8] netfilter: nf_tables: Make nft_meta expression more robust
Date:   Wed, 31 Jul 2019 13:51:51 +0200
Message-Id: <20190731115157.27020-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190731115157.27020-1-pablo@netfilter.org>
References: <20190731115157.27020-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

nft_meta_get_eval()'s tendency to bail out setting NFT_BREAK verdict in
situations where required data is missing leads to unexpected behaviour
with inverted checks like so:

| meta iifname != eth0 accept

This rule will never match if there is no input interface (or it is not
known) which is not intuitive and, what's worse, breaks consistency of
iptables-nft with iptables-legacy.

Fix this by falling back to placing a value in dreg which never matches
(avoiding accidental matches), i.e. zero for interface index and an
empty string for interface name.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_meta_bridge.c |  6 +-----
 net/netfilter/nft_meta.c               | 16 ++++------------
 2 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index bed66f536b34..a98dec2cf0cf 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -30,13 +30,9 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 	switch (priv->key) {
 	case NFT_META_BRI_IIFNAME:
 		br_dev = nft_meta_get_bridge(in);
-		if (!br_dev)
-			goto err;
 		break;
 	case NFT_META_BRI_OIFNAME:
 		br_dev = nft_meta_get_bridge(out);
-		if (!br_dev)
-			goto err;
 		break;
 	case NFT_META_BRI_IIFPVID: {
 		u16 p_pvid;
@@ -64,7 +60,7 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
-	strncpy((char *)dest, br_dev->name, IFNAMSIZ);
+	strncpy((char *)dest, br_dev ? br_dev->name : "", IFNAMSIZ);
 	return;
 out:
 	return nft_meta_get_eval(expr, regs, pkt);
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index f1b1d948c07b..f69afb9ff3cb 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -60,24 +60,16 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		*dest = skb->mark;
 		break;
 	case NFT_META_IIF:
-		if (in == NULL)
-			goto err;
-		*dest = in->ifindex;
+		*dest = in ? in->ifindex : 0;
 		break;
 	case NFT_META_OIF:
-		if (out == NULL)
-			goto err;
-		*dest = out->ifindex;
+		*dest = out ? out->ifindex : 0;
 		break;
 	case NFT_META_IIFNAME:
-		if (in == NULL)
-			goto err;
-		strncpy((char *)dest, in->name, IFNAMSIZ);
+		strncpy((char *)dest, in ? in->name : "", IFNAMSIZ);
 		break;
 	case NFT_META_OIFNAME:
-		if (out == NULL)
-			goto err;
-		strncpy((char *)dest, out->name, IFNAMSIZ);
+		strncpy((char *)dest, out ? out->name : "", IFNAMSIZ);
 		break;
 	case NFT_META_IIFTYPE:
 		if (in == NULL)
-- 
2.11.0

