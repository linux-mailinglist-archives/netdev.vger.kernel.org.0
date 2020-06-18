Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EDA1FEDC4
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 10:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgFRIhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 04:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbgFRIh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 04:37:29 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08644C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:37:29 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id g7so2370740qvx.11
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=f0wpaSdm/kbjyMK/zd6VzknUE9Tyb8h/E5yy8Dyg5Mg=;
        b=vDHy3ZoaBh1Si0+AEDx6zwz9bVEzjJntX2qmEpVRTjOKGiddC2PPV7FBjd+r9gz8Ix
         9xiqbFu82edq3ozXPpBNH9bp31AgXa0faBhxBTbMOhX3DkglXq5HDx0nG3JwWzM94W3l
         QwqJJPYEBFkJlqksAk2/vK2GipG6Ju4MN66OkECyIX+HElaron9fFez4CgD/DoweHXT1
         lMPaMYY5UYVA9U66bL9CF7+i80uvPdyF4IaARJNcbqzxkXB9SSnaptshHMDtNDl5RTnV
         FJ6Ns/5z7lOlm2oJsxNVjGcZlOUgKlhrpBJasmxFUQZVH/qxicf02em0Yq09M1IgcHzo
         4Nkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f0wpaSdm/kbjyMK/zd6VzknUE9Tyb8h/E5yy8Dyg5Mg=;
        b=fEeKG6eiMhayLNkJZiRUDWXfkjsiTwOjYCEHHBv0CxuJqilb+1hkEaGs05wHRVxQEE
         fmgLNpjMt4Fiq51jhlKjVrAkMNHY5HW5xfBFgFJyJYj7AwIoebulOJEntpse5z7t3qiD
         428jslZh9cWeLixiquOeyAyH73hCr1RaXuRosfLROSToLog+LPUYeyTM0AGukvx+aZpk
         LYAQcadMX8CWW03abfXN8vJ9QGSryQJLRSo2AmmzrcT+c5ZKj9m7RCKNA2cVHjZRCkeC
         9sj+P1G5w4tq5E9JQ5hiTf31aMi0g376ZRzCi7Lz8gke9E52FOjNsyXbgJcc2fT3tVJk
         4yuw==
X-Gm-Message-State: AOAM530PxOgLiObxxz3q6Yt1q72+uN20jg6x0SE83r+S3mVQ8cg7A85Z
        WiPAVxkSjp1v8Zuv11kFU7I=
X-Google-Smtp-Source: ABdhPJzwro4KaJhr2SQxklkw+zOjprc66kp/1HrVeK77+OXsRGNgwKJaINZ2h2PlzrM1tsiDS5U4IQ==
X-Received: by 2002:a05:6214:12f4:: with SMTP id w20mr2606863qvv.119.1592469448261;
        Thu, 18 Jun 2020 01:37:28 -0700 (PDT)
Received: from localhost.localdomain ([111.205.198.3])
        by smtp.gmail.com with ESMTPSA id l69sm2131551qke.112.2020.06.18.01.37.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jun 2020 01:37:27 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     paulb@mellanox.com, saeedm@mellanox.com, gerlitz.or@gmail.com,
        roid@mellanox.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 1/3] net/mlx5e: Implicitly decap the tunnel packet when necessary
Date:   Thu, 18 Jun 2020 16:36:44 +0800
Message-Id: <20200618083646.59507-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The commit 0a7fcb78cc21 ("net/mlx5e: Support inner header rewrite with
goto action"), will decapsulate the tunnel packets if there is a goto
action in chain 0. But in some case, we don't want do that, for example:

$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0      \
        flower enc_dst_ip 2.2.2.100 enc_dst_port 4789                   \
        action goto chain 2
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2      \
        flower dst_mac 00:11:22:33:44:55 enc_src_ip 2.2.2.200           \
        enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100           \
        action tunnel_key unset action mirred egress redirect dev enp130s0f0_0
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2      \
        flower dst_mac 00:11:22:33:44:66 enc_src_ip 2.2.2.200           \
        enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 200           \
        action tunnel_key unset action mirred egress redirect dev enp130s0f0_1

If there are pedit and goto actions, do the decapsulate and id mapping action.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 .../ethernet/mellanox/mlx5/core/en/mapping.c  |  24 ++++
 .../ethernet/mellanox/mlx5/core/en/mapping.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 109 ++++++++++++------
 3 files changed, 99 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
index ea321e528749..90306dde6b60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
@@ -74,6 +74,30 @@ int mapping_add(struct mapping_ctx *ctx, void *data, u32 *id)
 	return err;
 }
 
+int mapping_find_by_data(struct mapping_ctx *ctx, void *data, u32 *id)
+{
+	struct mapping_item *mi;
+	u32 hash_key;
+
+	mutex_lock(&ctx->lock);
+
+	hash_key = jhash(data, ctx->data_size, 0);
+	hash_for_each_possible(ctx->ht, mi, node, hash_key) {
+		if (!memcmp(data, mi->data, ctx->data_size))
+			goto found;
+	}
+
+	mutex_unlock(&ctx->lock);
+	return -ENOENT;
+
+found:
+	if (id)
+		*id = mi->id;
+
+	mutex_unlock(&ctx->lock);
+	return 0;
+}
+
 static void mapping_remove_and_free(struct mapping_ctx *ctx,
 				    struct mapping_item *mi)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
index 285525cc5470..af501c9796b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
@@ -9,6 +9,7 @@ struct mapping_ctx;
 int mapping_add(struct mapping_ctx *ctx, void *data, u32 *id);
 int mapping_remove(struct mapping_ctx *ctx, u32 id);
 int mapping_find(struct mapping_ctx *ctx, u32 id, void *data);
+int mapping_find_by_data(struct mapping_ctx *ctx, void *data, u32 *id);
 
 /* mapping uses an xarray to map data to ids in add(), and for find().
  * For locking, it uses a internal xarray spin lock for add()/remove(),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 7fc84f58e28a..05f8df8b53af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1836,7 +1836,8 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 	}
 }
 
-static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
+static int flow_has_tc_action(struct flow_cls_offload *f,
+			      enum flow_action_id action)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_action *flow_action = &rule->action;
@@ -1844,12 +1845,8 @@ static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
 	int i;
 
 	flow_action_for_each(i, act, flow_action) {
-		switch (act->id) {
-		case FLOW_ACTION_GOTO:
+		if (act->id == action)
 			return true;
-		default:
-			continue;
-		}
 	}
 
 	return false;
@@ -1901,10 +1898,37 @@ enc_opts_is_dont_care_or_full_match(struct mlx5e_priv *priv,
 	       sizeof(*__dst));\
 })
 
+static void mlx5e_make_tunnel_match_key(struct flow_cls_offload *f,
+					struct net_device *filter_dev,
+					struct tunnel_match_key *tunnel_key)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+
+	memset(tunnel_key, 0, sizeof(*tunnel_key));
+	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL,
+		       &tunnel_key->enc_control);
+	if (tunnel_key->enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS)
+		COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
+			       &tunnel_key->enc_ipv4);
+	else
+		COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS,
+			       &tunnel_key->enc_ipv6);
+
+	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IP, &tunnel_key->enc_ip);
+	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_PORTS,
+		       &tunnel_key->enc_tp);
+	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_KEYID,
+		       &tunnel_key->enc_key_id);
+
+	tunnel_key->filter_ifindex = filter_dev->ifindex;
+}
+
 static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 				    struct mlx5e_tc_flow *flow,
 				    struct flow_cls_offload *f,
-				    struct net_device *filter_dev)
+				    struct net_device *filter_dev,
+				    bool sets_mapping,
+				    bool needs_mapping)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
@@ -1925,22 +1949,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
 	uplink_priv = &uplink_rpriv->uplink_priv;
 
-	memset(&tunnel_key, 0, sizeof(tunnel_key));
-	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL,
-		       &tunnel_key.enc_control);
-	if (tunnel_key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS)
-		COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
-			       &tunnel_key.enc_ipv4);
-	else
-		COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS,
-			       &tunnel_key.enc_ipv6);
-	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IP, &tunnel_key.enc_ip);
-	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_PORTS,
-		       &tunnel_key.enc_tp);
-	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_KEYID,
-		       &tunnel_key.enc_key_id);
-	tunnel_key.filter_ifindex = filter_dev->ifindex;
-
+	mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
 	err = mapping_add(uplink_priv->tunnel_mapping, &tunnel_key, &tun_id);
 	if (err)
 		return err;
@@ -1970,10 +1979,10 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	mask = enc_opts_id ? TUNNEL_ID_MASK :
 			     (TUNNEL_ID_MASK & ~ENC_OPTS_BITS_MASK);
 
-	if (attr->chain) {
+	if (needs_mapping) {
 		mlx5e_tc_match_to_reg_match(&attr->parse_attr->spec,
 					    TUNNEL_TO_REG, value, mask);
-	} else {
+	} else if (sets_mapping) {
 		mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
 		err = mlx5e_tc_match_to_reg_set(priv->mdev,
 						mod_hdr_acts,
@@ -1996,6 +2005,25 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	return err;
 }
 
+static int mlx5e_lookup_flow_tunnel_id(struct mlx5e_priv *priv,
+				       struct mlx5e_tc_flow *flow,
+				       struct flow_cls_offload *f,
+				       struct net_device *filter_dev,
+				       u32 *tun_id)
+{
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct tunnel_match_key tunnel_key;
+	struct mlx5_eswitch *esw;
+
+	esw = priv->mdev->priv.eswitch;
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+
+	mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
+	return mapping_find_by_data(uplink_priv->tunnel_mapping, &tunnel_key, tun_id);
+}
+
 static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow)
 {
 	u32 enc_opts_id = flow->tunnel_id & ENC_OPTS_BITS_MASK;
@@ -2057,13 +2085,19 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct netlink_ext_ack *extack = f->common.extack;
 	bool needs_mapping, sets_mapping;
+	bool pedit_action;
 	int err;
 
 	if (!mlx5e_is_eswitch_flow(flow))
 		return -EOPNOTSUPP;
 
-	needs_mapping = !!flow->esw_attr->chain;
-	sets_mapping = !flow->esw_attr->chain && flow_has_tc_fwd_action(f);
+	pedit_action = flow_has_tc_action(f, FLOW_ACTION_MANGLE) ||
+		       flow_has_tc_action(f, FLOW_ACTION_ADD);
+	sets_mapping = pedit_action &&
+		       flow_has_tc_action(f, FLOW_ACTION_GOTO);
+	needs_mapping = !!flow->esw_attr->chain &&
+			!mlx5e_lookup_flow_tunnel_id(priv, flow, f,
+						     filter_dev, NULL);
 	*match_inner = !needs_mapping;
 
 	if ((needs_mapping || sets_mapping) &&
@@ -2075,7 +2109,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (!flow->esw_attr->chain) {
+	if (*match_inner) {
 		err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f,
 					 match_level);
 		if (err) {
@@ -2085,18 +2119,20 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 				    "Failed to parse tunnel attributes");
 			return err;
 		}
-
-		/* With mpls over udp we decapsulate using packet reformat
-		 * object
-		 */
-		if (!netif_is_bareudp(filter_dev))
-			flow->esw_attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
 	}
 
+	/* With mpls over udp we decapsulate using packet reformat
+	 * object
+	 */
+	if (!netif_is_bareudp(filter_dev) &&
+	    sets_mapping && !needs_mapping)
+		flow->esw_attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
+
 	if (!needs_mapping && !sets_mapping)
 		return 0;
 
-	return mlx5e_get_flow_tunnel_id(priv, flow, f, filter_dev);
+	return mlx5e_get_flow_tunnel_id(priv, flow, f, filter_dev,
+					sets_mapping, needs_mapping);
 }
 
 static void *get_match_inner_headers_criteria(struct mlx5_flow_spec *spec)
@@ -4309,6 +4345,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	}
 
+	if (decap)
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
+
 	if (!(attr->action &
 	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
 		NL_SET_ERR_MSG_MOD(extack,
-- 
2.26.1

