Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F01B1238F2
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfLQV5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:57:38 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34494 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfLQV5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:57:37 -0500
Received: by mail-wm1-f68.google.com with SMTP id f4so3194298wmj.1
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 13:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=olt74HY0imu/TXOltHSY2V3DTOAzK49YNGc0FiOGupM=;
        b=aHbEMW+aDH/h7gQI25zT7gqmnJ7aYK+B3coHI93fFGzicfVEiFEP3nx2ZLuP93Pn4P
         sFPnTui5Kc/HSiVUEYwyBTiIX6utd6b91k77680Tqu9eLG7nsjmAcOlOjtAQ0ekETU4e
         zqBux4XcG59H9gdARkpL3L3RH7ZfDmxNgH3xVhu7n5UqOOkcMIKYD0dv2zsXcZn1mzDb
         6Qk2DxM9U58xKiThpPPdXEOZdXzA8jDo5+z8mqyC6A+VQW3sU8JGsG6on5Qawftorhbz
         VRZksAkJirHAihf/VdZltMoeRBiPqfnOmU1RdkX1rXT4GQud5SwYYCaJM0rJKdtwzEpP
         rrhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=olt74HY0imu/TXOltHSY2V3DTOAzK49YNGc0FiOGupM=;
        b=LNeODiwig/+u3NRHhu35HHfg/JCnjcdXJ6O6uAeL0YowzqYWi5WS/oO4I+5M/OtPWD
         rX8qzlRa7UJ55bCKZqRHV609I5sIR6LthP2KFLwiP0d/h9JV6CG9SSWqwGw/l7saIy3N
         F4SoKjh1DJTWinxsKlQEIfx9Vbc+JePBboOQMMOIRlzBkBU7TOKag82xN7aoaeCjbZsA
         OI6E0rta7Bp3QBCrLqR+Br3whBrpVIIKCWSVI4htIcm2ZwnSInkYfwAE3DLkL/UGmqe0
         K6DcAqQlXrnG/5Gr12y3f1uxdddrkQnFGyeDcFeJ0RcX7IMCCC34xzydBIGaiH5/+8PX
         WT6g==
X-Gm-Message-State: APjAAAX93OKJWoPY23t3k+50gFL2hAJSZLMozJHXxT3cpCM25BJntPhY
        DRCX97qT3SRHI/WxelP3F3wCrZim0kJSZy/DifkA8werMCn6A3GD7TxLPFfuTJVKmafuMrhZJSE
        uJY5Q3E6Rg5gymWNLTcTLCilRsU8duezaW21ClYChg5zs4uK0MtbHY3pGq7j6ODnolGHucsoDlw
        ==
X-Google-Smtp-Source: APXvYqy1A3kJsbKoDZYjfCSu/TLxfW6sxVZ6qcp1u4gdkH7sTP5RIMEet8LfIDFm3gec1BQbRL9+4Q==
X-Received: by 2002:a7b:cf0d:: with SMTP id l13mr7619244wmg.13.1576619854440;
        Tue, 17 Dec 2019 13:57:34 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id u22sm157109wru.30.2019.12.17.13.57.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:57:34 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v2 1/9] nfp: flower: pass flow rule pointer directly to match functions
Date:   Tue, 17 Dec 2019 21:57:16 +0000
Message-Id: <1576619844-25413-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
References: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In kernel 5.1, the flow offload API was introduced along with a helper
function to extract the flow_rule from the TC offload struct. Each of the
match helper functions are passed the offload struct and extract the flow
rule to a local variable.

Simplify the code while also removing the extra compat and local variable
calls by extracting the rule once in the main match handler, and passing
a reference to the rule direct to each helper.

This patch does not change driver functionality.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/match.c | 76 ++++++++---------------
 1 file changed, 27 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 9cc3ba1..1079f37 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -10,9 +10,8 @@
 static void
 nfp_flower_compile_meta_tci(struct nfp_flower_meta_tci *ext,
 			    struct nfp_flower_meta_tci *msk,
-			    struct flow_cls_offload *flow, u8 key_type)
+			    struct flow_rule *rule, u8 key_type)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	u16 tmp_tci;
 
 	memset(ext, 0, sizeof(struct nfp_flower_meta_tci));
@@ -77,11 +76,8 @@ nfp_flower_compile_port(struct nfp_flower_in_port *frame, u32 cmsg_port,
 
 static void
 nfp_flower_compile_mac(struct nfp_flower_mac_mpls *ext,
-		       struct nfp_flower_mac_mpls *msk,
-		       struct flow_cls_offload *flow)
+		       struct nfp_flower_mac_mpls *msk, struct flow_rule *rule)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
-
 	memset(ext, 0, sizeof(struct nfp_flower_mac_mpls));
 	memset(msk, 0, sizeof(struct nfp_flower_mac_mpls));
 
@@ -130,10 +126,8 @@ nfp_flower_compile_mac(struct nfp_flower_mac_mpls *ext,
 static void
 nfp_flower_compile_tport(struct nfp_flower_tp_ports *ext,
 			 struct nfp_flower_tp_ports *msk,
-			 struct flow_cls_offload *flow)
+			 struct flow_rule *rule)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
-
 	memset(ext, 0, sizeof(struct nfp_flower_tp_ports));
 	memset(msk, 0, sizeof(struct nfp_flower_tp_ports));
 
@@ -150,11 +144,8 @@ nfp_flower_compile_tport(struct nfp_flower_tp_ports *ext,
 
 static void
 nfp_flower_compile_ip_ext(struct nfp_flower_ip_ext *ext,
-			  struct nfp_flower_ip_ext *msk,
-			  struct flow_cls_offload *flow)
+			  struct nfp_flower_ip_ext *msk, struct flow_rule *rule)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
-
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
 		struct flow_match_basic match;
 
@@ -224,10 +215,8 @@ nfp_flower_compile_ip_ext(struct nfp_flower_ip_ext *ext,
 
 static void
 nfp_flower_compile_ipv4(struct nfp_flower_ipv4 *ext,
-			struct nfp_flower_ipv4 *msk,
-			struct flow_cls_offload *flow)
+			struct nfp_flower_ipv4 *msk, struct flow_rule *rule)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	struct flow_match_ipv4_addrs match;
 
 	memset(ext, 0, sizeof(struct nfp_flower_ipv4));
@@ -241,16 +230,13 @@ nfp_flower_compile_ipv4(struct nfp_flower_ipv4 *ext,
 		msk->ipv4_dst = match.mask->dst;
 	}
 
-	nfp_flower_compile_ip_ext(&ext->ip_ext, &msk->ip_ext, flow);
+	nfp_flower_compile_ip_ext(&ext->ip_ext, &msk->ip_ext, rule);
 }
 
 static void
 nfp_flower_compile_ipv6(struct nfp_flower_ipv6 *ext,
-			struct nfp_flower_ipv6 *msk,
-			struct flow_cls_offload *flow)
+			struct nfp_flower_ipv6 *msk, struct flow_rule *rule)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
-
 	memset(ext, 0, sizeof(struct nfp_flower_ipv6));
 	memset(msk, 0, sizeof(struct nfp_flower_ipv6));
 
@@ -264,16 +250,15 @@ nfp_flower_compile_ipv6(struct nfp_flower_ipv6 *ext,
 		msk->ipv6_dst = match.mask->dst;
 	}
 
-	nfp_flower_compile_ip_ext(&ext->ip_ext, &msk->ip_ext, flow);
+	nfp_flower_compile_ip_ext(&ext->ip_ext, &msk->ip_ext, rule);
 }
 
 static int
-nfp_flower_compile_geneve_opt(void *ext, void *msk,
-			      struct flow_cls_offload *flow)
+nfp_flower_compile_geneve_opt(void *ext, void *msk, struct flow_rule *rule)
 {
 	struct flow_match_enc_opts match;
 
-	flow_rule_match_enc_opts(flow->rule, &match);
+	flow_rule_match_enc_opts(rule, &match);
 	memcpy(ext, match.key->data, match.key->len);
 	memcpy(msk, match.mask->data, match.mask->len);
 
@@ -283,10 +268,8 @@ nfp_flower_compile_geneve_opt(void *ext, void *msk,
 static void
 nfp_flower_compile_tun_ipv4_addrs(struct nfp_flower_tun_ipv4 *ext,
 				  struct nfp_flower_tun_ipv4 *msk,
-				  struct flow_cls_offload *flow)
+				  struct flow_rule *rule)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
-
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
 		struct flow_match_ipv4_addrs match;
 
@@ -301,10 +284,8 @@ nfp_flower_compile_tun_ipv4_addrs(struct nfp_flower_tun_ipv4 *ext,
 static void
 nfp_flower_compile_tun_ip_ext(struct nfp_flower_tun_ip_ext *ext,
 			      struct nfp_flower_tun_ip_ext *msk,
-			      struct flow_cls_offload *flow)
+			      struct flow_rule *rule)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
-
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {
 		struct flow_match_ip match;
 
@@ -319,10 +300,8 @@ nfp_flower_compile_tun_ip_ext(struct nfp_flower_tun_ip_ext *ext,
 static void
 nfp_flower_compile_ipv4_gre_tun(struct nfp_flower_ipv4_gre_tun *ext,
 				struct nfp_flower_ipv4_gre_tun *msk,
-				struct flow_cls_offload *flow)
+				struct flow_rule *rule)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
-
 	memset(ext, 0, sizeof(struct nfp_flower_ipv4_gre_tun));
 	memset(msk, 0, sizeof(struct nfp_flower_ipv4_gre_tun));
 
@@ -341,17 +320,15 @@ nfp_flower_compile_ipv4_gre_tun(struct nfp_flower_ipv4_gre_tun *ext,
 		msk->tun_flags = cpu_to_be16(NFP_FL_GRE_FLAG_KEY);
 	}
 
-	nfp_flower_compile_tun_ipv4_addrs(&ext->ipv4, &msk->ipv4, flow);
-	nfp_flower_compile_tun_ip_ext(&ext->ip_ext, &msk->ip_ext, flow);
+	nfp_flower_compile_tun_ipv4_addrs(&ext->ipv4, &msk->ipv4, rule);
+	nfp_flower_compile_tun_ip_ext(&ext->ip_ext, &msk->ip_ext, rule);
 }
 
 static void
 nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *ext,
 				struct nfp_flower_ipv4_udp_tun *msk,
-				struct flow_cls_offload *flow)
+				struct flow_rule *rule)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
-
 	memset(ext, 0, sizeof(struct nfp_flower_ipv4_udp_tun));
 	memset(msk, 0, sizeof(struct nfp_flower_ipv4_udp_tun));
 
@@ -366,8 +343,8 @@ nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *ext,
 		msk->tun_id = cpu_to_be32(temp_vni);
 	}
 
-	nfp_flower_compile_tun_ipv4_addrs(&ext->ipv4, &msk->ipv4, flow);
-	nfp_flower_compile_tun_ip_ext(&ext->ip_ext, &msk->ip_ext, flow);
+	nfp_flower_compile_tun_ipv4_addrs(&ext->ipv4, &msk->ipv4, rule);
+	nfp_flower_compile_tun_ip_ext(&ext->ip_ext, &msk->ip_ext, rule);
 }
 
 int nfp_flower_compile_flow_match(struct nfp_app *app,
@@ -378,6 +355,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 				  enum nfp_flower_tun_type tun_type,
 				  struct netlink_ext_ack *extack)
 {
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	u32 port_id;
 	int err;
 	u8 *ext;
@@ -393,7 +371,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 
 	nfp_flower_compile_meta_tci((struct nfp_flower_meta_tci *)ext,
 				    (struct nfp_flower_meta_tci *)msk,
-				    flow, key_ls->key_layer);
+				    rule, key_ls->key_layer);
 	ext += sizeof(struct nfp_flower_meta_tci);
 	msk += sizeof(struct nfp_flower_meta_tci);
 
@@ -425,7 +403,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	if (NFP_FLOWER_LAYER_MAC & key_ls->key_layer) {
 		nfp_flower_compile_mac((struct nfp_flower_mac_mpls *)ext,
 				       (struct nfp_flower_mac_mpls *)msk,
-				       flow);
+				       rule);
 		ext += sizeof(struct nfp_flower_mac_mpls);
 		msk += sizeof(struct nfp_flower_mac_mpls);
 	}
@@ -433,7 +411,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	if (NFP_FLOWER_LAYER_TP & key_ls->key_layer) {
 		nfp_flower_compile_tport((struct nfp_flower_tp_ports *)ext,
 					 (struct nfp_flower_tp_ports *)msk,
-					 flow);
+					 rule);
 		ext += sizeof(struct nfp_flower_tp_ports);
 		msk += sizeof(struct nfp_flower_tp_ports);
 	}
@@ -441,7 +419,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	if (NFP_FLOWER_LAYER_IPV4 & key_ls->key_layer) {
 		nfp_flower_compile_ipv4((struct nfp_flower_ipv4 *)ext,
 					(struct nfp_flower_ipv4 *)msk,
-					flow);
+					rule);
 		ext += sizeof(struct nfp_flower_ipv4);
 		msk += sizeof(struct nfp_flower_ipv4);
 	}
@@ -449,7 +427,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	if (NFP_FLOWER_LAYER_IPV6 & key_ls->key_layer) {
 		nfp_flower_compile_ipv6((struct nfp_flower_ipv6 *)ext,
 					(struct nfp_flower_ipv6 *)msk,
-					flow);
+					rule);
 		ext += sizeof(struct nfp_flower_ipv6);
 		msk += sizeof(struct nfp_flower_ipv6);
 	}
@@ -457,7 +435,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_GRE) {
 		__be32 tun_dst;
 
-		nfp_flower_compile_ipv4_gre_tun((void *)ext, (void *)msk, flow);
+		nfp_flower_compile_ipv4_gre_tun((void *)ext, (void *)msk, rule);
 		tun_dst = ((struct nfp_flower_ipv4_gre_tun *)ext)->ipv4.dst;
 		ext += sizeof(struct nfp_flower_ipv4_gre_tun);
 		msk += sizeof(struct nfp_flower_ipv4_gre_tun);
@@ -473,7 +451,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	    key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
 		__be32 tun_dst;
 
-		nfp_flower_compile_ipv4_udp_tun((void *)ext, (void *)msk, flow);
+		nfp_flower_compile_ipv4_udp_tun((void *)ext, (void *)msk, rule);
 		tun_dst = ((struct nfp_flower_ipv4_udp_tun *)ext)->ipv4.dst;
 		ext += sizeof(struct nfp_flower_ipv4_udp_tun);
 		msk += sizeof(struct nfp_flower_ipv4_udp_tun);
@@ -485,7 +463,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		nfp_tunnel_add_ipv4_off(app, tun_dst);
 
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE_OP) {
-			err = nfp_flower_compile_geneve_opt(ext, msk, flow);
+			err = nfp_flower_compile_geneve_opt(ext, msk, rule);
 			if (err)
 				return err;
 		}
-- 
2.7.4

