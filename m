Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42AD758E5F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 01:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfF0XNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 19:13:13 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38827 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfF0XNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 19:13:12 -0400
Received: by mail-qk1-f193.google.com with SMTP id a27so3274788qkk.5
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 16:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=28PoqWdyW/oc2H/j8gtUknp4f5KJDSkJB8Xr/UeYSq8=;
        b=eMYGJXIxb8o3fAt2UV6dc81nuvC/tilE2eGhAzY/zm/euJRMZX94xahGjqMtMQWIu9
         w8OktOpgu0NlsSLPKgw+xylZICdX+p+nX1q9r5dZZN2c7yIcN5e2bRqJTaKv1Tcrhmfp
         t1+dbuUAja0gQjomTISFECigNRV2rgLuDRVetOM9CcSospSKjnLqMr/501RGEIC7vXbn
         3Q/WYV3A30L3/kNwdWlT6iMGCbZtQMIKlAj4in4jVUjsYp49fiMvCxxpurDl7h4KIR6v
         tNj8u5jNvs6zi4gcjtzbcja7Vo/gnkL6/sU1A6J/VlcGQjGSMFpXFhT6q54KbU8W7NGb
         xhfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=28PoqWdyW/oc2H/j8gtUknp4f5KJDSkJB8Xr/UeYSq8=;
        b=sRL5m+s46hg8ZAkNc+962aeJu8CTbjCfj0PqpJAv10xQa954c42jfmmCx+zjm4DuAK
         RrpTp/1a0Xq0D7F/P1KGTWXRTnFDNCseOKUjVAMADy0cQopF6X1WkJRwlbbT4ezw4ISJ
         SDjqdgGuAWunNqr/ZDwAZOSYDn0Rs39EY3m98hkam64gz37KzA9KNhocZN/w2Tpvz9QM
         wVStwh6QhbQlR/FZ4mH+I9H9KiCDwS0GO6zwCXY2sX3o6lvY6tgnQzLvblDQwP9PkGZl
         KmUyq8/WWdKMQPKe9VqCYxBz/sNof3s3AN9txdcmI9l7+KHv7vIZ/+1Dat+MjIotLIFV
         jJ0Q==
X-Gm-Message-State: APjAAAW/ZX2YjifdhxtjqwkEZUOvpZtPfVIeT0E7eeaFGE8mdqOGdUto
        fdt4dc5AoSBKl5mFpuL65GYPjQ==
X-Google-Smtp-Source: APXvYqwFqmIwMOibVxlmTQR/Pm3G9jcZcc4B1TaeDLEt/7b5Nxm8GY8rYaRcQiDew2NKmLPDvRE5LQ==
X-Received: by 2002:a05:620a:247:: with SMTP id q7mr6174174qkn.265.1561677190836;
        Thu, 27 Jun 2019 16:13:10 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o33sm253518qtk.67.2019.06.27.16.13.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 16:13:10 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 4/5] nfp: flower: add GRE decap classification support
Date:   Thu, 27 Jun 2019 16:12:42 -0700
Message-Id: <20190627231243.8323-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190627231243.8323-1-jakub.kicinski@netronome.com>
References: <20190627231243.8323-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Extend the existing tunnel matching support to include GRE decap
classification. Specifically matching existing tunnel fields for
NVGRE (GRE with protocol field set to TEB).

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
---
 .../net/ethernet/netronome/nfp/flower/cmsg.h  | 39 ++++++++++++
 .../net/ethernet/netronome/nfp/flower/match.c | 44 ++++++++++++++
 .../ethernet/netronome/nfp/flower/offload.c   | 59 +++++++++++++------
 3 files changed, 124 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index d0d57d1ef750..0f1706ae5bfc 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -8,6 +8,7 @@
 #include <linux/skbuff.h>
 #include <linux/types.h>
 #include <net/geneve.h>
+#include <net/gre.h>
 #include <net/vxlan.h>
 
 #include "../nfp_app.h"
@@ -22,6 +23,7 @@
 #define NFP_FLOWER_LAYER_CT		BIT(6)
 #define NFP_FLOWER_LAYER_VXLAN		BIT(7)
 
+#define NFP_FLOWER_LAYER2_GRE		BIT(0)
 #define NFP_FLOWER_LAYER2_GENEVE	BIT(5)
 #define NFP_FLOWER_LAYER2_GENEVE_OP	BIT(6)
 
@@ -37,6 +39,9 @@
 #define NFP_FL_IP_FRAG_FIRST		BIT(7)
 #define NFP_FL_IP_FRAGMENTED		BIT(6)
 
+/* GRE Tunnel flags */
+#define NFP_FL_GRE_FLAG_KEY		BIT(2)
+
 /* Compressed HW representation of TCP Flags */
 #define NFP_FL_TCP_FLAG_URG		BIT(4)
 #define NFP_FL_TCP_FLAG_PSH		BIT(3)
@@ -107,6 +112,7 @@
 
 enum nfp_flower_tun_type {
 	NFP_FL_TUNNEL_NONE =	0,
+	NFP_FL_TUNNEL_GRE =	1,
 	NFP_FL_TUNNEL_VXLAN =	2,
 	NFP_FL_TUNNEL_GENEVE =	4,
 };
@@ -388,6 +394,35 @@ struct nfp_flower_ipv4_udp_tun {
 	__be32 tun_id;
 };
 
+/* Flow Frame GRE TUNNEL --> Tunnel details (6W/24B)
+ * -----------------------------------------------------------------
+ *    3                   2                   1
+ *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                         ipv4_addr_src                         |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                         ipv4_addr_dst                         |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |           tun_flags           |       tos     |       ttl     |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |            Reserved           |           Ethertype           |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                              Key                              |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                           Reserved                            |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ */
+
+struct nfp_flower_ipv4_gre_tun {
+	struct nfp_flower_tun_ipv4 ipv4;
+	__be16 tun_flags;
+	struct nfp_flower_tun_ip_ext ip_ext;
+	__be16 reserved1;
+	__be16 ethertype;
+	__be32 tun_key;
+	__be32 reserved2;
+};
+
 struct nfp_flower_geneve_options {
 	u8 data[NFP_FL_MAX_GENEVE_OPT_KEY];
 };
@@ -538,6 +573,8 @@ nfp_fl_netdev_is_tunnel_type(struct net_device *netdev,
 {
 	if (netif_is_vxlan(netdev))
 		return tun_type == NFP_FL_TUNNEL_VXLAN;
+	if (netif_is_gretap(netdev))
+		return tun_type == NFP_FL_TUNNEL_GRE;
 	if (netif_is_geneve(netdev))
 		return tun_type == NFP_FL_TUNNEL_GENEVE;
 
@@ -554,6 +591,8 @@ static inline bool nfp_fl_is_netdev_to_offload(struct net_device *netdev)
 		return true;
 	if (netif_is_geneve(netdev))
 		return true;
+	if (netif_is_gretap(netdev))
+		return true;
 
 	return false;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 9181611087c2..c1690de19172 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -316,6 +316,35 @@ nfp_flower_compile_tun_ip_ext(struct nfp_flower_tun_ip_ext *ext,
 	}
 }
 
+static void
+nfp_flower_compile_ipv4_gre_tun(struct nfp_flower_ipv4_gre_tun *ext,
+				struct nfp_flower_ipv4_gre_tun *msk,
+				struct tc_cls_flower_offload *flow)
+{
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+
+	memset(ext, 0, sizeof(struct nfp_flower_ipv4_gre_tun));
+	memset(msk, 0, sizeof(struct nfp_flower_ipv4_gre_tun));
+
+	/* NVGRE is the only supported GRE tunnel type */
+	ext->ethertype = cpu_to_be16(ETH_P_TEB);
+	msk->ethertype = cpu_to_be16(~0);
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid match;
+
+		flow_rule_match_enc_keyid(rule, &match);
+		ext->tun_key = match.key->keyid;
+		msk->tun_key = match.mask->keyid;
+
+		ext->tun_flags = cpu_to_be16(NFP_FL_GRE_FLAG_KEY);
+		msk->tun_flags = cpu_to_be16(NFP_FL_GRE_FLAG_KEY);
+	}
+
+	nfp_flower_compile_tun_ipv4_addrs(&ext->ipv4, &msk->ipv4, flow);
+	nfp_flower_compile_tun_ip_ext(&ext->ip_ext, &msk->ip_ext, flow);
+}
+
 static void
 nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *ext,
 				struct nfp_flower_ipv4_udp_tun *msk,
@@ -425,6 +454,21 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		msk += sizeof(struct nfp_flower_ipv6);
 	}
 
+	if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_GRE) {
+		__be32 tun_dst;
+
+		nfp_flower_compile_ipv4_gre_tun((void *)ext, (void *)msk, flow);
+		tun_dst = ((struct nfp_flower_ipv4_gre_tun *)ext)->ipv4.dst;
+		ext += sizeof(struct nfp_flower_ipv4_gre_tun);
+		msk += sizeof(struct nfp_flower_ipv4_gre_tun);
+
+		/* Store the tunnel destination in the rule data.
+		 * This must be present and be an exact match.
+		 */
+		nfp_flow->nfp_tun_ipv4_addr = tun_dst;
+		nfp_tunnel_add_ipv4_off(app, tun_dst);
+	}
+
 	if (key_ls->key_layer & NFP_FLOWER_LAYER_VXLAN ||
 	    key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
 		__be32 tun_dst;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 6b28910442db..6dbe947269c3 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -52,8 +52,7 @@
 
 #define NFP_FLOWER_WHITELIST_TUN_DISSECTOR_R \
 	(BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL) | \
-	 BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) | \
-	 BIT(FLOW_DISSECTOR_KEY_ENC_PORTS))
+	 BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS))
 
 #define NFP_FLOWER_MERGE_FIELDS \
 	(NFP_FLOWER_LAYER_PORT | \
@@ -285,27 +284,51 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			return -EOPNOTSUPP;
 		}
 
-		flow_rule_match_enc_ports(rule, &enc_ports);
-		if (enc_ports.mask->dst != cpu_to_be16(~0)) {
-			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: only an exact match L4 destination port is supported");
-			return -EOPNOTSUPP;
-		}
-
 		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS))
 			flow_rule_match_enc_opts(rule, &enc_op);
 
 
-		err = nfp_flower_calc_udp_tun_layer(enc_ports.key, enc_op.key,
-						    &key_layer_two, &key_layer,
-						    &key_size, priv, tun_type,
-						    extack);
-		if (err)
-			return err;
+		if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS)) {
+			/* check if GRE, which has no enc_ports */
+			if (netif_is_gretap(netdev)) {
+				*tun_type = NFP_FL_TUNNEL_GRE;
+				key_layer |= NFP_FLOWER_LAYER_EXT_META;
+				key_size += sizeof(struct nfp_flower_ext_meta);
+				key_layer_two |= NFP_FLOWER_LAYER2_GRE;
+				key_size +=
+					sizeof(struct nfp_flower_ipv4_gre_tun);
+
+				if (enc_op.key) {
+					NL_SET_ERR_MSG_MOD(extack, "unsupported offload: encap options not supported on GRE tunnels");
+					return -EOPNOTSUPP;
+				}
+			} else {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: an exact match on L4 destination port is required for non-GRE tunnels");
+				return -EOPNOTSUPP;
+			}
+		} else {
+			flow_rule_match_enc_ports(rule, &enc_ports);
+			if (enc_ports.mask->dst != cpu_to_be16(~0)) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: only an exact match L4 destination port is supported");
+				return -EOPNOTSUPP;
+			}
 
-		/* Ensure the ingress netdev matches the expected tun type. */
-		if (!nfp_fl_netdev_is_tunnel_type(netdev, *tun_type)) {
-			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: ingress netdev does not match the expected tunnel type");
-			return -EOPNOTSUPP;
+			err = nfp_flower_calc_udp_tun_layer(enc_ports.key,
+							    enc_op.key,
+							    &key_layer_two,
+							    &key_layer,
+							    &key_size, priv,
+							    tun_type, extack);
+			if (err)
+				return err;
+
+			/* Ensure the ingress netdev matches the expected
+			 * tun type.
+			 */
+			if (!nfp_fl_netdev_is_tunnel_type(netdev, *tun_type)) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: ingress netdev does not match the expected tunnel type");
+				return -EOPNOTSUPP;
+			}
 		}
 	}
 
-- 
2.21.0

