Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCE7102ED3
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfKSWGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:06:14 -0500
Received: from correo.us.es ([193.147.175.20]:35156 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727007AbfKSWGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 17:06:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DD97F8C3C6E
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 23:06:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF900B7FF9
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 23:06:02 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C4C39B8001; Tue, 19 Nov 2019 23:06:02 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD21ADA4D0;
        Tue, 19 Nov 2019 23:06:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 19 Nov 2019 23:06:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9E4B842EE38E;
        Tue, 19 Nov 2019 23:06:00 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] netfilter: nf_tables_offload: allow ethernet interface type only
Date:   Tue, 19 Nov 2019 23:05:53 +0100
Message-Id: <20191119220555.17391-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191119220555.17391-1-pablo@netfilter.org>
References: <20191119220555.17391-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardware offload support at this stage assumes an ethernet device in
place. The flow dissector provides the intermediate representation to
express this selector, so extend it to allow to store the interface
type. Flower does not uses this, so skb_flow_dissect_meta() is not
extended to match on this new field.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/flow_dissector.h | 2 ++
 net/netfilter/nft_cmp.c      | 6 ++++++
 net/netfilter/nft_meta.c     | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index b1063db63e66..1a0727d1acfa 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -203,9 +203,11 @@ struct flow_dissector_key_ip {
 /**
  * struct flow_dissector_key_meta:
  * @ingress_ifindex: ingress ifindex
+ * @ingress_iftype: ingress interface type
  */
 struct flow_dissector_key_meta {
 	int ingress_ifindex;
+	u16 ingress_iftype;
 };
 
 /**
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 0744b2bb46da..b8092069f868 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
+#include <linux/if_arp.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables_offload.h>
@@ -125,6 +126,11 @@ static int __nft_cmp_offload(struct nft_offload_ctx *ctx,
 	flow->match.dissector.used_keys |= BIT(reg->key);
 	flow->match.dissector.offset[reg->key] = reg->base_offset;
 
+	if (reg->key == FLOW_DISSECTOR_KEY_META &&
+	    reg->offset == offsetof(struct nft_flow_key, meta.ingress_iftype) &&
+	    nft_reg_load16(priv->data.data) != ARPHRD_ETHER)
+		return -EOPNOTSUPP;
+
 	nft_offload_update_dependency(ctx, &priv->data, priv->len);
 
 	return 0;
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 8fbea031bd4a..9740b554fdb3 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -551,6 +551,10 @@ static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_META, meta,
 				  ingress_ifindex, sizeof(__u32), reg);
 		break;
+	case NFT_META_IIFTYPE:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_META, meta,
+				  ingress_iftype, sizeof(__u16), reg);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.11.0

