Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE78F1C65CF
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 04:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgEFCRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 22:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgEFCRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 22:17:11 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2481EC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 19:17:10 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id hi11so116693pjb.3
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 19:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fiRiLmMqWyQJ9S/K6+Ga8x7BBVpYyeV+nEcFnodr/E4=;
        b=JEppMT31/jVX3MuOqe6C3nO3MXdUXBCNjjPuprq7q67gkG0kSk1qm4xZ0XdA9DhFxl
         7nsQb74m5+eqP7+KkS/5lzuQx4+VC6iV94B6t9kEmO+L41+i62t+Y4CwpNcQ1QV5ir14
         FxLoZOKUSoTu6n6RUUygSDugkOgWu54w0pgLlwWAPe+z86AsooMr3VmyFr4RqOC8aZK2
         jrbayLJgIvF+dMvFky1CYHROlA5EldNw5SN+ckzRS6ywNuqZGDBLrBbE7ds1RDYCBl91
         VNLf8gTa49L4lMHNgVtGqESbf9xIyHgYdOwYJ9CVJvsuN3JhiP8LsdFDlZarJGbW2Swp
         JnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fiRiLmMqWyQJ9S/K6+Ga8x7BBVpYyeV+nEcFnodr/E4=;
        b=Bafkc/ZWOlcizwjyq4ybX/IsndNKM+5pXVDZPaKCzCDh3LukzMa/qXT8wfW3XFqKG1
         a8Cv2BgtS4tFUZGXFr55xL1mCiPPcQEGSFxNmoh+y8hWD3Rc4w4llUamDhd2Fxv3ViQk
         FWncLavTbHVN6/WeWDIBKwc0+DQXRR4alO5TQppzTNT+8JRnOdf9sUFPFW0ETyGO/0Ng
         M8sFhqMwoOqgqD5PjWUgXUSGq56evA/8CNbhGfn29ltx505qDJHZSgtNBRJiEt33s2DV
         NJGPQm30xdM2Mm8g4eT9QHFU+dQ9xMF6Nmgv6JvxFyfjqTQ2+8YWNZ/95BRFqZcNtlkm
         fhzQ==
X-Gm-Message-State: AGi0PuZNFBgv++4YzK6gIqlnQVCcBb395cZ6IH7prEF22gFOZ/vB3rHg
        XSd1OCKkNmcOiPjjTSXtoxQMpSJ2
X-Google-Smtp-Source: APiQypLNCKGYT/RFsg38L1B61vg684GrQL7MJ1lvoiaHCkeF5CLEwcPSDMVvsvF1vp74nBKnevIUyQ==
X-Received: by 2002:a17:90b:692:: with SMTP id m18mr6590321pjz.39.1588731429315;
        Tue, 05 May 2020 19:17:09 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id ft14sm1751646pjb.46.2020.05.05.19.17.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 19:17:08 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     paulb@mellanox.com, saeedm@mellanox.com, roid@mellanox.com,
        gerlitz.or@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH v2 1/3] net/mlx5e: Implicitly decap the tunnel packet when necessary
Date:   Wed,  6 May 2020 10:16:31 +0800
Message-Id: <1588731393-6973-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The commit 0a7fcb78cc21 ("net/mlx5e: Support inner header rewrite with
goto action"), will decapsulate the tunnel packets if there is a goto
action in chain 0. But in some case, we don't want do that, for example:

$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789			\
	action goto chain 2
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
	flower dst_mac 00:11:22:33:44:55 enc_src_ip 2.2.2.200		\
	enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100		\
	action tunnel_key unset action mirred egress redirect dev enp130s0f0_0
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
	flower dst_mac 00:11:22:33:44:66 enc_src_ip 2.2.2.200		\
	enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 200		\
	action tunnel_key unset action mirred egress redirect dev enp130s0f0_1

In this patch, if there is a pedit action in chain, do the decapsulation action.
if there are pedit and goto actions, do the decapsulation and id mapping action.

9 test units:
[1]:
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789			\
	action goto chain 2
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
	action tunnel_key unset \
	action mirred egress redirect dev enp130s0f0_0
[2]:
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100	\
	action goto chain 2
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
	action pedit ex munge eth src set 00:11:22:33:44:f0		\
	action mirred egress redirect dev enp130s0f0_0
[3]:
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100	\
	action goto chain 2
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
	action tunnel_key unset \
	action pedit ex munge eth src set 00:11:22:33:44:f0		\
[4]:
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0      \
        flower enc_dst_ip 2.2.2.100 enc_dst_port 4789                   \
        enc_key_id 100 dst_mac 00:11:22:33:44:55                        \
        action pedit ex munge eth src set 00:11:22:33:44:ff pipe        \
        action mirred egress redirect dev enp130s0f0_0
[5]:
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0      \
        flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
        enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
        action pedit ex munge eth src set 00:11:22:33:44:ff             \
        action goto chain 2
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2      \
        flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
        enc_dst_port 4789 enc_key_id 100 src_mac 00:11:22:33:44:ff      \
        action tunnel_key unset \
        action mirred egress redirect dev enp130s0f0_0
[6]:
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0      \
        flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
        enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
        action pedit ex munge eth src set 00:11:22:33:44:ff             \
        action goto chain 2
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2      \
        flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
        enc_dst_port 4789 enc_key_id 100 src_mac 00:11:22:33:44:ff      \
        action tunnel_key unset \
        action pedit ex munge eth src set 00:11:22:33:44:f0             \
        action mirred egress redirect dev enp130s0f0_0
[7]:
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0      \
        flower  enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100               \
        enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
        action pedit ex munge eth src set 00:11:22:33:44:ff             \
        action goto chain 2
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2      \
        flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
        enc_dst_port 4789 enc_key_id 100 src_mac 00:11:22:33:44:ff      \
        action pedit ex munge eth src set 00:11:22:33:44:f0             \
        action goto chain 3
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 3      \
        flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
        enc_dst_port 4789 enc_key_id 100 src_mac 00:11:22:33:44:f0      \
        action tunnel_key unset \
        action pedit ex munge eth src set 00:11:22:33:44:f1             \
        action mirred egress redirect dev enp130s0f0_0
[8]:
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0      \
        flower enc_dst_ip 2.2.2.100 enc_dst_port 4789                   \
        action goto chain 2
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2      \
        flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
        enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
        action pedit ex munge eth src set 00:11:22:33:44:f0             \
        action goto chain 3
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 3      \
        flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
        enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
        action pedit ex munge eth src set 00:11:22:33:44:f1             \
        action goto chain 4
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 4      \
        flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100                \
        enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
        action pedit ex munge eth src set 00:11:22:33:44:f2             \
        action mirred egress redirect dev enp130s0f0_0
[9]:
tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0        \
        flower enc_dst_ip 2.2.2.100 enc_dst_port 4789			\
	dst_mac 00:11:22:33:44:55					\
        action tunnel_key unset                                         \
        action mirred egress redirect dev enp130s0f0_0

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v2:
* update commit message
* add a test case[9]
---
 .../net/ethernet/mellanox/mlx5/core/en/mapping.c   | 24 ++++++
 .../net/ethernet/mellanox/mlx5/core/en/mapping.h   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 99 +++++++++++++++-------
 3 files changed, 94 insertions(+), 30 deletions(-)

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
@@ -9,6 +9,7 @@
 int mapping_add(struct mapping_ctx *ctx, void *data, u32 *id);
 int mapping_remove(struct mapping_ctx *ctx, u32 id);
 int mapping_find(struct mapping_ctx *ctx, u32 id, void *data);
+int mapping_find_by_data(struct mapping_ctx *ctx, void *data, u32 *id);
 
 /* mapping uses an xarray to map data to ids in add(), and for find().
  * For locking, it uses a internal xarray spin lock for add()/remove(),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 77397aa66810..7ab1b162d317 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1791,7 +1791,8 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 	}
 }
 
-static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
+static int flow_has_tc_action(struct flow_cls_offload *f,
+			      enum flow_action_id action)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_action *flow_action = &rule->action;
@@ -1799,12 +1800,8 @@ static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
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
@@ -1856,10 +1853,37 @@ static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
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
@@ -1880,22 +1904,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
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
@@ -1925,10 +1934,10 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
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
@@ -1951,6 +1960,25 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
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
@@ -1986,14 +2014,24 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct netlink_ext_ack *extack = f->common.extack;
 	bool needs_mapping, sets_mapping;
+	bool pedit_action;
+	bool tunnel_decap;
 	int err;
 
 	if (!mlx5e_is_eswitch_flow(flow))
 		return -EOPNOTSUPP;
 
-	needs_mapping = !!flow->esw_attr->chain;
-	sets_mapping = !flow->esw_attr->chain && flow_has_tc_fwd_action(f);
-	*match_inner = !needs_mapping;
+	pedit_action = flow_has_tc_action(f, FLOW_ACTION_MANGLE) ||
+		       flow_has_tc_action(f, FLOW_ACTION_ADD);
+	tunnel_decap = flow_has_tc_action(f, FLOW_ACTION_TUNNEL_DECAP);
+
+	*match_inner = pedit_action || tunnel_decap;
+	sets_mapping = pedit_action &&
+		       flow_has_tc_action(f, FLOW_ACTION_GOTO);
+
+	needs_mapping = !!flow->esw_attr->chain &&
+			!mlx5e_lookup_flow_tunnel_id(priv, flow, f,
+						     filter_dev, NULL);
 
 	if ((needs_mapping || sets_mapping) &&
 	    !mlx5_eswitch_reg_c1_loopback_enabled(esw)) {
@@ -2004,7 +2042,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (!flow->esw_attr->chain) {
+	if (*match_inner && !needs_mapping) {
 		err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f,
 					 match_level);
 		if (err) {
@@ -2021,7 +2059,8 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 	if (!needs_mapping && !sets_mapping)
 		return 0;
 
-	return mlx5e_get_flow_tunnel_id(priv, flow, f, filter_dev);
+	return mlx5e_get_flow_tunnel_id(priv, flow, f, filter_dev,
+					sets_mapping, needs_mapping);
 }
 
 static void *get_match_inner_headers_criteria(struct mlx5_flow_spec *spec)
-- 
1.8.3.1

