Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5401158E5D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 01:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfF0XNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 19:13:08 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43420 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfF0XNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 19:13:08 -0400
Received: by mail-qt1-f196.google.com with SMTP id w17so4330319qto.10
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 16:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4NF8PA9pzcwOyncuyWwoN+LbzT4TREUP1arkC2JYWjw=;
        b=YPWIvGOjAHHsGFqTSOPB80PCi9cDGxVLfMhEDOkJgYIkVxyCeOLwExyt7L+1LGtVc8
         kbKbP2pYf8beYN5bzEtG6LyLxc+5wd2UmE7vjxjUaoFcL1FHIvpj7cuQhgUfJ+gj3tsk
         DnovMM5db8qfM9dtwgIMmJHB8oaaeCXeO6+DKouLbRxKTNcU4W+hTibRq4iUTB0BI8oF
         jgoEVCkdxeF2KqODyM/KPIrzFRI8n3/9n02WT//uZc9qiiTp0mrfWt7bGzqG7qw0ZGw4
         KtF4J0qQXcy9pHefW5CERc1NESj9f7BYnpKuh2ph4Blg/5zaUFgl3Kq5+kumGTmPN3cG
         icUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4NF8PA9pzcwOyncuyWwoN+LbzT4TREUP1arkC2JYWjw=;
        b=V94u6LExaw/6SApDl9ilC81CPFfZVAbqoCvYb0KevoNUYOeuWEjLaDpUvZCyM2Nn4M
         O035v/vuceY3IkpPJ7kd/noW3K47MdLz/KXuJAmxe7eABphTjOFP2GIbhoX+c+ife633
         uQ1NvVtLENuel5a7+v06XHYov6MoM6tJkdBAPmLbJmWK7e+LU/wz1BtuOAQ6Lrw2rE9O
         Jt/lR8sfTC+38IVx1uxsGIEO/HUH8KFoO9VCnOyKPXufAUbHbwbEvw7evqxGQsvmRXoZ
         Fgcd6/HXtS7vY6j4Op2r6IrsFKrjxxYBfUgNmq+ib1fInGzMYH1rdYo/HFKQXvjImDEa
         X1gw==
X-Gm-Message-State: APjAAAXljQEbBpVx9m+pY+XpQYT5mfO/UehRZqomFJZe6sfpL4aFT9Tr
        C3cwkpL7YXmTUc6xubfmx3/D7g==
X-Google-Smtp-Source: APXvYqxisozpdQ1UL8vqT6spc56E1/8XVk/dykyolZfC23MucMAoT0+UVfce9vLRMio4sgb3kA0weg==
X-Received: by 2002:a0c:bf4a:: with SMTP id b10mr5544377qvj.120.1561677186907;
        Thu, 27 Jun 2019 16:13:06 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o33sm253518qtk.67.2019.06.27.16.13.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 16:13:06 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 1/5] nfp: flower: refactor tunnel key layer calculation
Date:   Thu, 27 Jun 2019 16:12:39 -0700
Message-Id: <20190627231243.8323-2-jakub.kicinski@netronome.com>
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

Refactor the key layer calculation function, in particular the tunnel
key layer calculation by introducing helper functions. This is done
in preparation for supporting GRE tunnel offloads.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
---
 .../ethernet/netronome/nfp/flower/offload.c   | 100 +++++++++++-------
 1 file changed, 60 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 39e6599f2bd7..6b28910442db 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -141,16 +141,16 @@ static bool nfp_flower_check_higher_than_l3(struct tc_cls_flower_offload *f)
 }
 
 static int
-nfp_flower_calc_opt_layer(struct flow_match_enc_opts *enc_opts,
+nfp_flower_calc_opt_layer(struct flow_dissector_key_enc_opts *enc_opts,
 			  u32 *key_layer_two, int *key_size,
 			  struct netlink_ext_ack *extack)
 {
-	if (enc_opts->key->len > NFP_FL_MAX_GENEVE_OPT_KEY) {
+	if (enc_opts->len > NFP_FL_MAX_GENEVE_OPT_KEY) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: geneve options exceed maximum length");
 		return -EOPNOTSUPP;
 	}
 
-	if (enc_opts->key->len > 0) {
+	if (enc_opts->len > 0) {
 		*key_layer_two |= NFP_FLOWER_LAYER2_GENEVE_OP;
 		*key_size += sizeof(struct nfp_flower_geneve_options);
 	}
@@ -158,6 +158,57 @@ nfp_flower_calc_opt_layer(struct flow_match_enc_opts *enc_opts,
 	return 0;
 }
 
+static int
+nfp_flower_calc_udp_tun_layer(struct flow_dissector_key_ports *enc_ports,
+			      struct flow_dissector_key_enc_opts *enc_op,
+			      u32 *key_layer_two, u8 *key_layer, int *key_size,
+			      struct nfp_flower_priv *priv,
+			      enum nfp_flower_tun_type *tun_type,
+			      struct netlink_ext_ack *extack)
+{
+	int err;
+
+	switch (enc_ports->dst) {
+	case htons(IANA_VXLAN_UDP_PORT):
+		*tun_type = NFP_FL_TUNNEL_VXLAN;
+		*key_layer |= NFP_FLOWER_LAYER_VXLAN;
+		*key_size += sizeof(struct nfp_flower_ipv4_udp_tun);
+
+		if (enc_op) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: encap options not supported on vxlan tunnels");
+			return -EOPNOTSUPP;
+		}
+		break;
+	case htons(GENEVE_UDP_PORT):
+		if (!(priv->flower_ext_feats & NFP_FL_FEATS_GENEVE)) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support geneve offload");
+			return -EOPNOTSUPP;
+		}
+		*tun_type = NFP_FL_TUNNEL_GENEVE;
+		*key_layer |= NFP_FLOWER_LAYER_EXT_META;
+		*key_size += sizeof(struct nfp_flower_ext_meta);
+		*key_layer_two |= NFP_FLOWER_LAYER2_GENEVE;
+		*key_size += sizeof(struct nfp_flower_ipv4_udp_tun);
+
+		if (!enc_op)
+			break;
+		if (!(priv->flower_ext_feats & NFP_FL_FEATS_GENEVE_OPT)) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support geneve option offload");
+			return -EOPNOTSUPP;
+		}
+		err = nfp_flower_calc_opt_layer(enc_op, key_layer_two,
+						key_size, extack);
+		if (err)
+			return err;
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: tunnel type unknown");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int
 nfp_flower_calculate_key_layers(struct nfp_app *app,
 				struct net_device *netdev,
@@ -243,44 +294,13 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS))
 			flow_rule_match_enc_opts(rule, &enc_op);
 
-		switch (enc_ports.key->dst) {
-		case htons(IANA_VXLAN_UDP_PORT):
-			*tun_type = NFP_FL_TUNNEL_VXLAN;
-			key_layer |= NFP_FLOWER_LAYER_VXLAN;
-			key_size += sizeof(struct nfp_flower_ipv4_udp_tun);
-
-			if (enc_op.key) {
-				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: encap options not supported on vxlan tunnels");
-				return -EOPNOTSUPP;
-			}
-			break;
-		case htons(GENEVE_UDP_PORT):
-			if (!(priv->flower_ext_feats & NFP_FL_FEATS_GENEVE)) {
-				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support geneve offload");
-				return -EOPNOTSUPP;
-			}
-			*tun_type = NFP_FL_TUNNEL_GENEVE;
-			key_layer |= NFP_FLOWER_LAYER_EXT_META;
-			key_size += sizeof(struct nfp_flower_ext_meta);
-			key_layer_two |= NFP_FLOWER_LAYER2_GENEVE;
-			key_size += sizeof(struct nfp_flower_ipv4_udp_tun);
 
-			if (!enc_op.key)
-				break;
-			if (!(priv->flower_ext_feats &
-			      NFP_FL_FEATS_GENEVE_OPT)) {
-				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support geneve option offload");
-				return -EOPNOTSUPP;
-			}
-			err = nfp_flower_calc_opt_layer(&enc_op, &key_layer_two,
-							&key_size, extack);
-			if (err)
-				return err;
-			break;
-		default:
-			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: tunnel type unknown");
-			return -EOPNOTSUPP;
-		}
+		err = nfp_flower_calc_udp_tun_layer(enc_ports.key, enc_op.key,
+						    &key_layer_two, &key_layer,
+						    &key_size, priv, tun_type,
+						    extack);
+		if (err)
+			return err;
 
 		/* Ensure the ingress netdev matches the expected tun type. */
 		if (!nfp_fl_netdev_is_tunnel_type(netdev, *tun_type)) {
-- 
2.21.0

