Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7834B102ED2
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfKSWGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:06:13 -0500
Received: from correo.us.es ([193.147.175.20]:35168 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbfKSWGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 17:06:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 22D0C8C3C61
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 23:06:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14E48DA3A9
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 23:06:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0A6A6DA72F; Tue, 19 Nov 2019 23:06:04 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29445FB362;
        Tue, 19 Nov 2019 23:06:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 19 Nov 2019 23:06:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E5B3142EE38E;
        Tue, 19 Nov 2019 23:06:01 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] netfilter: nft_payload: add C-VLAN offload support
Date:   Tue, 19 Nov 2019 23:05:55 +0100
Message-Id: <20191119220555.17391-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191119220555.17391-1-pablo@netfilter.org>
References: <20191119220555.17391-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Match on h_vlan_encapsulated_proto and set up protocol dependency. Check
for protocol dependency before accessing the tci field. Allow to match
on the encapsulated ethertype too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index f17939fbf6c3..1993af3a2979 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -203,6 +203,22 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
 				  vlan_tpid, sizeof(__be16), reg);
+		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
+		break;
+	case offsetof(struct vlan_ethhdr, h_vlan_TCI) + sizeof(struct vlan_hdr):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
+				  vlan_tci, sizeof(__be16), reg);
+		break;
+	case offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto) +
+							sizeof(struct vlan_hdr):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
+				  vlan_tpid, sizeof(__be16), reg);
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.11.0

