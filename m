Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB5D11D51B
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbfLLSRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:17:21 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35789 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730346AbfLLSRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:17:14 -0500
Received: by mail-wr1-f66.google.com with SMTP id g17so3811792wro.2
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 10:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=11u7/cc3s7vXvLoxR+XBCjrHe9WBejj9VSJXotb7DNU=;
        b=WiVuOELSnTkx/N2friMvNuhvjj+k1Q6i+YeCejCk+ngcEoc+7J1+LhJapZ9sOuf8Bs
         ujk6wTNCJufLdTTKe7vfzqyD56CX63q8/ynkg1CGwDmBNTRdvWyf8izh3eFZ54U6vi/2
         t20DPnpTrRngQ/emvTmt+1J0YVmxFJ0nK0ZFMRdm3/Sy7EfDimczOhZf/xCjvcjYSMxz
         58f/S9i9J+4a/xmGMO/0XuuXo0emZTrK8WmlOsTCbdbVcp/pjh/poYLI8+4Fdsw8dsVH
         ZTLktAVWYE6g+pwfiVtORnupHXnxSfm3YEhIkdKD4FumXM9pzem232pGf3ol7588rvAG
         HXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=11u7/cc3s7vXvLoxR+XBCjrHe9WBejj9VSJXotb7DNU=;
        b=chLOrQd4BiTbGuQA4VveSb/TRi1Uhe+pgeUcVU0c40G1QTdnMWU73+YVMmwD4ycpHP
         rIyJUUEQshQmDy7lpC3Om/Pukfjx1Xkp6vTna/EuZ+QVk9AiBgoKuLUwy2RSor/UJXyt
         YqUgYgpPVDTc1nut4CkKWvIaZlcPY+duE6TupDhFXBf6WOYjdNxXCZgvLpTdzdBnGE9B
         bhFE5ipf1VEcwLSDvSZYj62M/rIxX+AxVfe7xp5m+IoTqiV6paqpi1V96yRWWxCic6ZJ
         QuhBBHHBwsz3bWKCccsvTrf2koTMaOReYm8QwTcgWYfCI3FASF1TFxGnEsFQ6OEharHH
         Xbeg==
X-Gm-Message-State: APjAAAUEIzu6AHuczqIIgve14Cr2dpMHKD0gvR04uRpBHK0BaxDXGeN5
        iHynbFdLXH0fR+0m4TzFHbqK588Oiig4T3RJu662nepphVF2oOvAuZmjJqeWTo3egdi1A4VTKE8
        veVqlycpS2xY+vZLNsRZgaDkQRrrwolSbD4UhCqNX3ZB6YuHNtYFXOAYx/OPHmadrAmsEKX4nIQ
        ==
X-Google-Smtp-Source: APXvYqxE2Mq87yiKiqOS9pAyuIxjtHw3/5qNsAid5esiwH7gge/I277gv2uUDyBr9fOIYOfHzxAxDA==
X-Received: by 2002:adf:cf12:: with SMTP id o18mr7886114wrj.361.1576174630185;
        Thu, 12 Dec 2019 10:17:10 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id j21sm7928736wmj.39.2019.12.12.10.17.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 10:17:09 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 3/9] nfp: flower: compile match for IPv6 tunnels
Date:   Thu, 12 Dec 2019 18:16:50 +0000
Message-Id: <1576174616-9738-4-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
References: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6 tunnel matches are now supported by firmware. Modify the NFP driver
to compile these match rules. IPv6 matches are handled similar to IPv4
tunnels with the difference the address length. The type of tunnel is
indicated by the same bitmap that is used in IPv4 with an extra bit
signifying that the IPv6 variation should be used.

Only compile IPv6 tunnel matches when the fw features symbol indicated
that they are compatible with the currently loaded fw.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |  83 +++++++++++++++
 drivers/net/ethernet/netronome/nfp/flower/main.h   |   1 +
 drivers/net/ethernet/netronome/nfp/flower/match.c  | 111 ++++++++++++++++-----
 .../net/ethernet/netronome/nfp/flower/offload.c    | 102 ++++++++++++++-----
 4 files changed, 246 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 7eb2ec8..8d12805 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -26,6 +26,7 @@
 #define NFP_FLOWER_LAYER2_GRE		BIT(0)
 #define NFP_FLOWER_LAYER2_GENEVE	BIT(5)
 #define NFP_FLOWER_LAYER2_GENEVE_OP	BIT(6)
+#define NFP_FLOWER_LAYER2_TUN_IPV6	BIT(7)
 
 #define NFP_FLOWER_MASK_VLAN_PRIO	GENMASK(15, 13)
 #define NFP_FLOWER_MASK_VLAN_PRESENT	BIT(12)
@@ -63,6 +64,7 @@
 #define NFP_FL_MAX_GENEVE_OPT_ACT	32
 #define NFP_FL_MAX_GENEVE_OPT_CNT	64
 #define NFP_FL_MAX_GENEVE_OPT_KEY	32
+#define NFP_FL_MAX_GENEVE_OPT_KEY_V6	8
 
 /* Action opcodes */
 #define NFP_FL_ACTION_OPCODE_OUTPUT		0
@@ -387,6 +389,11 @@ struct nfp_flower_tun_ipv4 {
 	__be32 dst;
 };
 
+struct nfp_flower_tun_ipv6 {
+	struct in6_addr src;
+	struct in6_addr dst;
+};
+
 struct nfp_flower_tun_ip_ext {
 	u8 tos;
 	u8 ttl;
@@ -416,6 +423,42 @@ struct nfp_flower_ipv4_udp_tun {
 	__be32 tun_id;
 };
 
+/* Flow Frame IPv6 UDP TUNNEL --> Tunnel details (11W/44B)
+ * -----------------------------------------------------------------
+ *    3                   2                   1
+ *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_src,   31 - 0                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_src,  63 - 32                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_src,  95 - 64                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_src, 127 - 96                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_dst,   31 - 0                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_dst,  63 - 32                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_dst,  95 - 64                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_dst, 127 - 96                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |           Reserved            |      tos      |      ttl      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                            Reserved                           |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                     VNI                       |   Reserved    |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ */
+struct nfp_flower_ipv6_udp_tun {
+	struct nfp_flower_tun_ipv6 ipv6;
+	__be16 reserved1;
+	struct nfp_flower_tun_ip_ext ip_ext;
+	__be32 reserved2;
+	__be32 tun_id;
+};
+
 /* Flow Frame GRE TUNNEL --> Tunnel details (6W/24B)
  * -----------------------------------------------------------------
  *    3                   2                   1
@@ -445,6 +488,46 @@ struct nfp_flower_ipv4_gre_tun {
 	__be32 reserved2;
 };
 
+/* Flow Frame GRE TUNNEL V6 --> Tunnel details (12W/48B)
+ * -----------------------------------------------------------------
+ *    3                   2                   1
+ *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_src,   31 - 0                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_src,  63 - 32                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_src,  95 - 64                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_src, 127 - 96                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_dst,   31 - 0                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_dst,  63 - 32                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_dst,  95 - 64                      |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                  ipv6_addr_dst, 127 - 96                      |
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
+struct nfp_flower_ipv6_gre_tun {
+	struct nfp_flower_tun_ipv6 ipv6;
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
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 31d9459..386d629 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -43,6 +43,7 @@ struct nfp_app;
 #define NFP_FL_FEATS_VF_RLIM		BIT(4)
 #define NFP_FL_FEATS_FLOW_MOD		BIT(5)
 #define NFP_FL_FEATS_PRE_TUN_RULES	BIT(6)
+#define NFP_FL_FEATS_IPV6_TUN		BIT(7)
 #define NFP_FL_FEATS_FLOW_MERGE		BIT(30)
 #define NFP_FL_FEATS_LAG		BIT(31)
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 1cf8eae..2410ead 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -282,6 +282,22 @@ nfp_flower_compile_tun_ipv4_addrs(struct nfp_flower_tun_ipv4 *ext,
 }
 
 static void
+nfp_flower_compile_tun_ipv6_addrs(struct nfp_flower_tun_ipv6 *ext,
+				  struct nfp_flower_tun_ipv6 *msk,
+				  struct flow_rule *rule)
+{
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS)) {
+		struct flow_match_ipv6_addrs match;
+
+		flow_rule_match_enc_ipv6_addrs(rule, &match);
+		ext->src = match.key->src;
+		ext->dst = match.key->dst;
+		msk->src = match.mask->src;
+		msk->dst = match.mask->dst;
+	}
+}
+
+static void
 nfp_flower_compile_tun_ip_ext(struct nfp_flower_tun_ip_ext *ext,
 			      struct nfp_flower_tun_ip_ext *msk,
 			      struct flow_rule *rule)
@@ -360,6 +376,37 @@ nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *ext,
 	nfp_flower_compile_tun_udp_key(&ext->tun_id, &msk->tun_id, rule);
 }
 
+static void
+nfp_flower_compile_ipv6_udp_tun(struct nfp_flower_ipv6_udp_tun *ext,
+				struct nfp_flower_ipv6_udp_tun *msk,
+				struct flow_rule *rule)
+{
+	memset(ext, 0, sizeof(struct nfp_flower_ipv6_udp_tun));
+	memset(msk, 0, sizeof(struct nfp_flower_ipv6_udp_tun));
+
+	nfp_flower_compile_tun_ipv6_addrs(&ext->ipv6, &msk->ipv6, rule);
+	nfp_flower_compile_tun_ip_ext(&ext->ip_ext, &msk->ip_ext, rule);
+	nfp_flower_compile_tun_udp_key(&ext->tun_id, &msk->tun_id, rule);
+}
+
+static void
+nfp_flower_compile_ipv6_gre_tun(struct nfp_flower_ipv6_gre_tun *ext,
+				struct nfp_flower_ipv6_gre_tun *msk,
+				struct flow_rule *rule)
+{
+	memset(ext, 0, sizeof(struct nfp_flower_ipv6_gre_tun));
+	memset(msk, 0, sizeof(struct nfp_flower_ipv6_gre_tun));
+
+	/* NVGRE is the only supported GRE tunnel type */
+	ext->ethertype = cpu_to_be16(ETH_P_TEB);
+	msk->ethertype = cpu_to_be16(~0);
+
+	nfp_flower_compile_tun_ipv6_addrs(&ext->ipv6, &msk->ipv6, rule);
+	nfp_flower_compile_tun_ip_ext(&ext->ip_ext, &msk->ip_ext, rule);
+	nfp_flower_compile_tun_gre_key(&ext->tun_key, &msk->tun_key,
+				       &ext->tun_flags, &msk->tun_flags, rule);
+}
+
 int nfp_flower_compile_flow_match(struct nfp_app *app,
 				  struct flow_cls_offload *flow,
 				  struct nfp_fl_key_ls *key_ls,
@@ -446,34 +493,50 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	}
 
 	if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_GRE) {
-		__be32 tun_dst;
-
-		nfp_flower_compile_ipv4_gre_tun((void *)ext, (void *)msk, rule);
-		tun_dst = ((struct nfp_flower_ipv4_gre_tun *)ext)->ipv4.dst;
-		ext += sizeof(struct nfp_flower_ipv4_gre_tun);
-		msk += sizeof(struct nfp_flower_ipv4_gre_tun);
-
-		/* Store the tunnel destination in the rule data.
-		 * This must be present and be an exact match.
-		 */
-		nfp_flow->nfp_tun_ipv4_addr = tun_dst;
-		nfp_tunnel_add_ipv4_off(app, tun_dst);
+		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
+			nfp_flower_compile_ipv6_gre_tun((void *)ext,
+							(void *)msk, rule);
+			ext += sizeof(struct nfp_flower_ipv6_gre_tun);
+			msk += sizeof(struct nfp_flower_ipv6_gre_tun);
+		} else {
+			__be32 dst;
+
+			nfp_flower_compile_ipv4_gre_tun((void *)ext,
+							(void *)msk, rule);
+			dst = ((struct nfp_flower_ipv4_gre_tun *)ext)->ipv4.dst;
+			ext += sizeof(struct nfp_flower_ipv4_gre_tun);
+			msk += sizeof(struct nfp_flower_ipv4_gre_tun);
+
+			/* Store the tunnel destination in the rule data.
+			 * This must be present and be an exact match.
+			 */
+			nfp_flow->nfp_tun_ipv4_addr = dst;
+			nfp_tunnel_add_ipv4_off(app, dst);
+		}
 	}
 
 	if (key_ls->key_layer & NFP_FLOWER_LAYER_VXLAN ||
 	    key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
-		__be32 tun_dst;
-
-		nfp_flower_compile_ipv4_udp_tun((void *)ext, (void *)msk, rule);
-		tun_dst = ((struct nfp_flower_ipv4_udp_tun *)ext)->ipv4.dst;
-		ext += sizeof(struct nfp_flower_ipv4_udp_tun);
-		msk += sizeof(struct nfp_flower_ipv4_udp_tun);
-
-		/* Store the tunnel destination in the rule data.
-		 * This must be present and be an exact match.
-		 */
-		nfp_flow->nfp_tun_ipv4_addr = tun_dst;
-		nfp_tunnel_add_ipv4_off(app, tun_dst);
+		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
+			nfp_flower_compile_ipv6_udp_tun((void *)ext,
+							(void *)msk, rule);
+			ext += sizeof(struct nfp_flower_ipv6_udp_tun);
+			msk += sizeof(struct nfp_flower_ipv6_udp_tun);
+		} else {
+			__be32 dst;
+
+			nfp_flower_compile_ipv4_udp_tun((void *)ext,
+							(void *)msk, rule);
+			dst = ((struct nfp_flower_ipv4_udp_tun *)ext)->ipv4.dst;
+			ext += sizeof(struct nfp_flower_ipv4_udp_tun);
+			msk += sizeof(struct nfp_flower_ipv4_udp_tun);
+
+			/* Store the tunnel destination in the rule data.
+			 * This must be present and be an exact match.
+			 */
+			nfp_flow->nfp_tun_ipv4_addr = dst;
+			nfp_tunnel_add_ipv4_off(app, dst);
+		}
 
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE_OP) {
 			err = nfp_flower_compile_geneve_opt(ext, msk, rule);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 987ae22..0997350 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -54,6 +54,10 @@
 	(BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL) | \
 	 BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS))
 
+#define NFP_FLOWER_WHITELIST_TUN_DISSECTOR_V6_R \
+	(BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL) | \
+	 BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS))
+
 #define NFP_FLOWER_MERGE_FIELDS \
 	(NFP_FLOWER_LAYER_PORT | \
 	 NFP_FLOWER_LAYER_MAC | \
@@ -146,10 +150,11 @@ static bool nfp_flower_check_higher_than_l3(struct flow_cls_offload *f)
 
 static int
 nfp_flower_calc_opt_layer(struct flow_dissector_key_enc_opts *enc_opts,
-			  u32 *key_layer_two, int *key_size,
+			  u32 *key_layer_two, int *key_size, bool ipv6,
 			  struct netlink_ext_ack *extack)
 {
-	if (enc_opts->len > NFP_FL_MAX_GENEVE_OPT_KEY) {
+	if (enc_opts->len > NFP_FL_MAX_GENEVE_OPT_KEY ||
+	    (ipv6 && enc_opts->len > NFP_FL_MAX_GENEVE_OPT_KEY_V6)) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: geneve options exceed maximum length");
 		return -EOPNOTSUPP;
 	}
@@ -167,7 +172,7 @@ nfp_flower_calc_udp_tun_layer(struct flow_dissector_key_ports *enc_ports,
 			      struct flow_dissector_key_enc_opts *enc_op,
 			      u32 *key_layer_two, u8 *key_layer, int *key_size,
 			      struct nfp_flower_priv *priv,
-			      enum nfp_flower_tun_type *tun_type,
+			      enum nfp_flower_tun_type *tun_type, bool ipv6,
 			      struct netlink_ext_ack *extack)
 {
 	int err;
@@ -176,7 +181,15 @@ nfp_flower_calc_udp_tun_layer(struct flow_dissector_key_ports *enc_ports,
 	case htons(IANA_VXLAN_UDP_PORT):
 		*tun_type = NFP_FL_TUNNEL_VXLAN;
 		*key_layer |= NFP_FLOWER_LAYER_VXLAN;
-		*key_size += sizeof(struct nfp_flower_ipv4_udp_tun);
+
+		if (ipv6) {
+			*key_layer |= NFP_FLOWER_LAYER_EXT_META;
+			*key_size += sizeof(struct nfp_flower_ext_meta);
+			*key_layer_two |= NFP_FLOWER_LAYER2_TUN_IPV6;
+			*key_size += sizeof(struct nfp_flower_ipv6_udp_tun);
+		} else {
+			*key_size += sizeof(struct nfp_flower_ipv4_udp_tun);
+		}
 
 		if (enc_op) {
 			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: encap options not supported on vxlan tunnels");
@@ -192,7 +205,13 @@ nfp_flower_calc_udp_tun_layer(struct flow_dissector_key_ports *enc_ports,
 		*key_layer |= NFP_FLOWER_LAYER_EXT_META;
 		*key_size += sizeof(struct nfp_flower_ext_meta);
 		*key_layer_two |= NFP_FLOWER_LAYER2_GENEVE;
-		*key_size += sizeof(struct nfp_flower_ipv4_udp_tun);
+
+		if (ipv6) {
+			*key_layer_two |= NFP_FLOWER_LAYER2_TUN_IPV6;
+			*key_size += sizeof(struct nfp_flower_ipv6_udp_tun);
+		} else {
+			*key_size += sizeof(struct nfp_flower_ipv4_udp_tun);
+		}
 
 		if (!enc_op)
 			break;
@@ -200,8 +219,8 @@ nfp_flower_calc_udp_tun_layer(struct flow_dissector_key_ports *enc_ports,
 			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support geneve option offload");
 			return -EOPNOTSUPP;
 		}
-		err = nfp_flower_calc_opt_layer(enc_op, key_layer_two,
-						key_size, extack);
+		err = nfp_flower_calc_opt_layer(enc_op, key_layer_two, key_size,
+						ipv6, extack);
 		if (err)
 			return err;
 		break;
@@ -237,6 +256,8 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 
 	/* If any tun dissector is used then the required set must be used. */
 	if (dissector->used_keys & NFP_FLOWER_WHITELIST_TUN_DISSECTOR &&
+	    (dissector->used_keys & NFP_FLOWER_WHITELIST_TUN_DISSECTOR_V6_R)
+	    != NFP_FLOWER_WHITELIST_TUN_DISSECTOR_V6_R &&
 	    (dissector->used_keys & NFP_FLOWER_WHITELIST_TUN_DISSECTOR_R)
 	    != NFP_FLOWER_WHITELIST_TUN_DISSECTOR_R) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: tunnel match not supported");
@@ -268,8 +289,10 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
 		struct flow_match_enc_opts enc_op = { NULL, NULL };
 		struct flow_match_ipv4_addrs ipv4_addrs;
+		struct flow_match_ipv6_addrs ipv6_addrs;
 		struct flow_match_control enc_ctl;
 		struct flow_match_ports enc_ports;
+		bool ipv6_tun = false;
 
 		flow_rule_match_enc_control(rule, &enc_ctl);
 
@@ -277,38 +300,62 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: wildcarded protocols on tunnels are not supported");
 			return -EOPNOTSUPP;
 		}
-		if (enc_ctl.key->addr_type != FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
-			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: only IPv4 tunnels are supported");
+
+		ipv6_tun = enc_ctl.key->addr_type ==
+				FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+		if (ipv6_tun &&
+		    !(priv->flower_ext_feats & NFP_FL_FEATS_IPV6_TUN)) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: firmware does not support IPv6 tunnels");
 			return -EOPNOTSUPP;
 		}
 
-		/* These fields are already verified as used. */
-		flow_rule_match_enc_ipv4_addrs(rule, &ipv4_addrs);
-		if (ipv4_addrs.mask->dst != cpu_to_be32(~0)) {
-			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: only an exact match IPv4 destination address is supported");
+		if (!ipv6_tun &&
+		    enc_ctl.key->addr_type != FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: tunnel address type not IPv4 or IPv6");
 			return -EOPNOTSUPP;
 		}
 
+		if (ipv6_tun) {
+			flow_rule_match_enc_ipv6_addrs(rule, &ipv6_addrs);
+			if (memchr_inv(&ipv6_addrs.mask->dst, 0xff,
+				       sizeof(ipv6_addrs.mask->dst))) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: only an exact match IPv6 destination address is supported");
+				return -EOPNOTSUPP;
+			}
+		} else {
+			flow_rule_match_enc_ipv4_addrs(rule, &ipv4_addrs);
+			if (ipv4_addrs.mask->dst != cpu_to_be32(~0)) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: only an exact match IPv4 destination address is supported");
+				return -EOPNOTSUPP;
+			}
+		}
+
 		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS))
 			flow_rule_match_enc_opts(rule, &enc_op);
 
-
 		if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS)) {
 			/* check if GRE, which has no enc_ports */
-			if (netif_is_gretap(netdev)) {
-				*tun_type = NFP_FL_TUNNEL_GRE;
-				key_layer |= NFP_FLOWER_LAYER_EXT_META;
-				key_size += sizeof(struct nfp_flower_ext_meta);
-				key_layer_two |= NFP_FLOWER_LAYER2_GRE;
-				key_size +=
-					sizeof(struct nfp_flower_ipv4_gre_tun);
+			if (!netif_is_gretap(netdev)) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: an exact match on L4 destination port is required for non-GRE tunnels");
+				return -EOPNOTSUPP;
+			}
 
-				if (enc_op.key) {
-					NL_SET_ERR_MSG_MOD(extack, "unsupported offload: encap options not supported on GRE tunnels");
-					return -EOPNOTSUPP;
-				}
+			*tun_type = NFP_FL_TUNNEL_GRE;
+			key_layer |= NFP_FLOWER_LAYER_EXT_META;
+			key_size += sizeof(struct nfp_flower_ext_meta);
+			key_layer_two |= NFP_FLOWER_LAYER2_GRE;
+
+			if (ipv6_tun) {
+				key_layer_two |= NFP_FLOWER_LAYER2_TUN_IPV6;
+				key_size +=
+					sizeof(struct nfp_flower_ipv6_udp_tun);
 			} else {
-				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: an exact match on L4 destination port is required for non-GRE tunnels");
+				key_size +=
+					sizeof(struct nfp_flower_ipv4_udp_tun);
+			}
+
+			if (enc_op.key) {
+				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: encap options not supported on GRE tunnels");
 				return -EOPNOTSUPP;
 			}
 		} else {
@@ -323,7 +370,8 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 							    &key_layer_two,
 							    &key_layer,
 							    &key_size, priv,
-							    tun_type, extack);
+							    tun_type, ipv6_tun,
+							    extack);
 			if (err)
 				return err;
 
-- 
2.7.4

