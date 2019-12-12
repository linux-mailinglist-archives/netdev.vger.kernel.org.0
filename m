Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA3211D514
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfLLSRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:17:11 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39274 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730145AbfLLSRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:17:09 -0500
Received: by mail-wm1-f68.google.com with SMTP id d5so3628088wmb.4
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 10:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=olt74HY0imu/TXOltHSY2V3DTOAzK49YNGc0FiOGupM=;
        b=X7l4tT0iJrUurDUovDPwkGsHQBbdqAG9DfXyfaI3b8WwfVYZsvWDD9t5RxoJjgrYA+
         77tZiIMCc9shkMki4UmnSZuhyG/Uc+Td3976Feog1Zpu9HF+oZ7Nj5B7ry6SW7lhVZb3
         Rozr4eq5JPF6Xi5wvxo+q//i3jxpE8N7jlGEuP1rAmg88gAg/zBpifNbtTpzguWugUnn
         YeHTIAciDPHYwZO1bVit7AL5cWH2BidInxczmiv+ZyhaoAgsMwLE2yxXeiKLg5BCfIsX
         BZ8+DXzwtH9WbnrXjUFW1B3p0u6fkV0PZ9ZnQjFsUgB2JsOENgTmeG6s0vuxdQjvTfF8
         W1FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=olt74HY0imu/TXOltHSY2V3DTOAzK49YNGc0FiOGupM=;
        b=BLAiNT6QusgrrHarF90Q05jl2Xs5xwFw+9+WauqgVL3uLlgDnSNaeIysa69HxOVE0c
         Bvlis0UJU43H3uY9kg5Q9dp76TqiJZPNk1Cw815HPUls+pAhPZ9ad2kSKL6uecKgE+BP
         NdZp6poKlMfFxLhW2a7jTzc/rc8b1r8Ks+1/6Ji0vQI1QziiRnWfkRFeCcN/Vkv4lo0f
         CxRehCOdfUxUMpNlSHK6RsX9ORw59EtmVgmdGUKd2J6B4zx2kKDRz12oqw4LF+uHO3Vc
         /GPo382/3TY2Bb5ZliefTrrEL8gL+7+uXX+4ubNDQrh8qFjwC7ANDufL6Zw87PZFn9tT
         TF8g==
X-Gm-Message-State: APjAAAVgFYomlBbAWZzA71Xht60q/AWbl+KJXKDuRYwYGoj6li2J3VmA
        VPmEhEwooG+LV7HDugXYU18ttkGM0o0ywONC2/nBx6NZrirgw3flFJMfOZ0+xsLZDj/bCkr12OZ
        4XFVc5HfqnzPwiUoy9rKm67BqRnlLJzUF1OHBWjKjXpLPJ3jcQT6APaDY1Huwzg7HDP7KlZ0jDQ
        ==
X-Google-Smtp-Source: APXvYqz9QNIAQS18vorSpAfzn1HkhLfYP6F+yxmsflqEtxY0ZZfVRgk0H9zNxCsFxvcs93t0GzFlPw==
X-Received: by 2002:a1c:49c3:: with SMTP id w186mr8405371wma.53.1576174628029;
        Thu, 12 Dec 2019 10:17:08 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id j21sm7928736wmj.39.2019.12.12.10.17.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 10:17:07 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 1/9] nfp: flower: pass flow rule pointer directly to match functions
Date:   Thu, 12 Dec 2019 18:16:48 +0000
Message-Id: <1576174616-9738-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
References: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
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

