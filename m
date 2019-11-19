Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0E6102ED1
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfKSWGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:06:09 -0500
Received: from correo.us.es ([193.147.175.20]:35162 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbfKSWGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 17:06:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9245E8C3C6B
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 23:06:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84B47DA8E8
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 23:06:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 78684B8005; Tue, 19 Nov 2019 23:06:03 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DEE8DA4CA;
        Tue, 19 Nov 2019 23:06:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 19 Nov 2019 23:06:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5D17242EE38E;
        Tue, 19 Nov 2019 23:06:01 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] netfilter: nft_payload: add VLAN offload support
Date:   Tue, 19 Nov 2019 23:05:54 +0100
Message-Id: <20191119220555.17391-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191119220555.17391-1-pablo@netfilter.org>
References: <20191119220555.17391-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Match on ethertype and set up protocol dependency. Check for protocol
dependency before accessing the tci field. Allow to match on the
encapsulated ethertype too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/flow_dissector.h |  9 ++++++---
 net/netfilter/nft_payload.c  | 22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 1a0727d1acfa..f06b0239c32b 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -48,9 +48,12 @@ struct flow_dissector_key_tags {
 };
 
 struct flow_dissector_key_vlan {
-	u16	vlan_id:12,
-		vlan_dei:1,
-		vlan_priority:3;
+	union {
+		u16	vlan_id:12,
+			vlan_dei:1,
+			vlan_priority:3;
+		__be16	vlan_tci;
+	};
 	__be16	vlan_tpid;
 };
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 0877d46b8605..f17939fbf6c3 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -182,6 +182,28 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
 				  dst, ETH_ALEN, reg);
 		break;
+	case offsetof(struct ethhdr, h_proto):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic,
+				  n_proto, sizeof(__be16), reg);
+		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
+		break;
+	case offsetof(struct vlan_ethhdr, h_vlan_TCI):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
+				  vlan_tci, sizeof(__be16), reg);
+		break;
+	case offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
+				  vlan_tpid, sizeof(__be16), reg);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.11.0

