Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D54169F5C
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgBXHgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:17 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38175 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbgBXHgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:14 -0500
Received: by mail-wm1-f65.google.com with SMTP id a9so8195919wmj.3
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C9GvRaR50sjqBJaESB/Hh1cnB1xFvMEc/AC25ErEplg=;
        b=GZorwqdD9VjEXfQwiJPSNc+ELzW92gX1vNyq/gOM9BCSf6FgPy2qibtHoJhZFQqtj2
         qefS7Mmnv9tku7/yu88jVR2ntYa+NCGOecCFSLH7uW6k/I5Zon4ej+VaMg+wmdAXrZ1H
         hPQ78NSAXwJsM/R7J6ovbSHVyzunbXV+KRz4PxQ5xgBSk1l9yW6cnZ2n4YWcUV79nf7P
         0VygRL46fTTX1cq9GBTrXOk79fKzgMlrp9CTYP4vEHx/URiE7N4EEVPn006tRKYUwLUi
         uGfIai2elw02XOYMyfDKdb7IijbeLZafKEWYNsnTgBw2GR4nAI8IxN1eeKVpr0wwKdT5
         pbMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C9GvRaR50sjqBJaESB/Hh1cnB1xFvMEc/AC25ErEplg=;
        b=clKHcY3riruEmpq84JXfrbgzUhVP5M2hVhjQxU2/oVM7OsDM2MFeSEwju4FXBu9Cwm
         LfvyZYMOsWnphqeVtyWFitFNxWbrmNob3SOvRgxy5YLJ7X8qRFQfSheVhIwa3SLa4e38
         oa0TLuFg7NhZ5U1eaSCNMJ7nXo5k936eX7sA8VUj1/VJSh+oLZAUboHjneU7sXm7auO9
         fxErO00qKcgKvks3Cm75N66NN4pgSTIM9mATK9ZldFquvOlXuLWffT+qssWvh/OYK4Vb
         EAa5i3j5NVXd3OP02c3tUOR1Qvt7crgZqVPTSmdHP9eOp27h4/o2CpmwtC9Qmt+gorzh
         O21g==
X-Gm-Message-State: APjAAAXLTKNplnDPZqhlKZYHtKVeG2ED0L1iDEscHZrsxCdQ4NqMyt70
        dm8hbmH1TfRvDish0dZSZcA8M1HvHnI=
X-Google-Smtp-Source: APXvYqwsr/Mvs6u+DCPbKTVZw9lnKxTBUWQ98eFprLv8jRLaf5LlMBsPlm4HnxBzwb3tHnAB2P7QyA==
X-Received: by 2002:a1c:41c4:: with SMTP id o187mr20234155wma.24.1582529771931;
        Sun, 23 Feb 2020 23:36:11 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id c4sm16557371wml.7.2020.02.23.23.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:11 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 10/16] mlxsw: core: Allow to enable/disable rx_listener for trap
Date:   Mon, 24 Feb 2020 08:35:52 +0100
Message-Id: <20200224073558.26500-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

For source traps, the "thin policer" is going to be used in order
to reduce the amount of trapped packets to minimum. However, there
will be still small number of packets coming in that need to be dropped
in the driver. Allow to enable/disable rx_listener related to specific
trap in order to prevent unwanted packets to go up the stack.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 48 ++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlxsw/core.h |  2 +-
 2 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 167df7e4d678..2a451f7e1fea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -142,6 +142,7 @@ struct mlxsw_rx_listener_item {
 	struct list_head list;
 	struct mlxsw_rx_listener rxl;
 	void *priv;
+	bool enabled;
 };
 
 struct mlxsw_event_listener_item {
@@ -1470,7 +1471,7 @@ __find_rx_listener_item(struct mlxsw_core *mlxsw_core,
 
 int mlxsw_core_rx_listener_register(struct mlxsw_core *mlxsw_core,
 				    const struct mlxsw_rx_listener *rxl,
-				    void *priv)
+				    void *priv, bool enabled)
 {
 	struct mlxsw_rx_listener_item *rxl_item;
 
@@ -1482,6 +1483,7 @@ int mlxsw_core_rx_listener_register(struct mlxsw_core *mlxsw_core,
 		return -ENOMEM;
 	rxl_item->rxl = *rxl;
 	rxl_item->priv = priv;
+	rxl_item->enabled = enabled;
 
 	list_add_rcu(&rxl_item->list, &mlxsw_core->rx_listener_list);
 	return 0;
@@ -1502,6 +1504,19 @@ void mlxsw_core_rx_listener_unregister(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_rx_listener_unregister);
 
+static void
+mlxsw_core_rx_listener_state_set(struct mlxsw_core *mlxsw_core,
+				 const struct mlxsw_rx_listener *rxl,
+				 bool enabled)
+{
+	struct mlxsw_rx_listener_item *rxl_item;
+
+	rxl_item = __find_rx_listener_item(mlxsw_core, rxl);
+	if (WARN_ON(!rxl_item))
+		return;
+	rxl_item->enabled = enabled;
+}
+
 static void mlxsw_core_event_listener_func(struct sk_buff *skb, u8 local_port,
 					   void *priv)
 {
@@ -1563,7 +1578,7 @@ int mlxsw_core_event_listener_register(struct mlxsw_core *mlxsw_core,
 	el_item->el = *el;
 	el_item->priv = priv;
 
-	err = mlxsw_core_rx_listener_register(mlxsw_core, &rxl, el_item);
+	err = mlxsw_core_rx_listener_register(mlxsw_core, &rxl, el_item, true);
 	if (err)
 		goto err_rx_listener_register;
 
@@ -1601,16 +1616,18 @@ EXPORT_SYMBOL(mlxsw_core_event_listener_unregister);
 
 static int mlxsw_core_listener_register(struct mlxsw_core *mlxsw_core,
 					const struct mlxsw_listener *listener,
-					void *priv)
+					void *priv, bool enabled)
 {
-	if (listener->is_event)
+	if (listener->is_event) {
+		WARN_ON(!enabled);
 		return mlxsw_core_event_listener_register(mlxsw_core,
 						&listener->event_listener,
 						priv);
-	else
+	} else {
 		return mlxsw_core_rx_listener_register(mlxsw_core,
 						&listener->rx_listener,
-						priv);
+						priv, enabled);
+	}
 }
 
 static void mlxsw_core_listener_unregister(struct mlxsw_core *mlxsw_core,
@@ -1632,7 +1649,8 @@ int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
 	char hpkt_pl[MLXSW_REG_HPKT_LEN];
 	int err;
 
-	err = mlxsw_core_listener_register(mlxsw_core, listener, priv);
+	err = mlxsw_core_listener_register(mlxsw_core, listener, priv,
+					   listener->enabled_on_register);
 	if (err)
 		return err;
 
@@ -1675,11 +1693,22 @@ int mlxsw_core_trap_state_set(struct mlxsw_core *mlxsw_core,
 {
 	enum mlxsw_reg_hpkt_action action;
 	char hpkt_pl[MLXSW_REG_HPKT_LEN];
+	int err;
+
+	/* Not supported for event listener */
+	if (WARN_ON(listener->is_event))
+		return -EINVAL;
 
 	action = enabled ? listener->en_action : listener->dis_action;
 	mlxsw_reg_hpkt_pack(hpkt_pl, action, listener->trap_id,
 			    listener->trap_group, listener->is_ctrl);
-	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(hpkt), hpkt_pl);
+	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(hpkt), hpkt_pl);
+	if (err)
+		return err;
+
+	mlxsw_core_rx_listener_state_set(mlxsw_core, &listener->rx_listener,
+					 enabled);
+	return 0;
 }
 EXPORT_SYMBOL(mlxsw_core_trap_state_set);
 
@@ -1939,7 +1968,8 @@ void mlxsw_core_skb_receive(struct mlxsw_core *mlxsw_core, struct sk_buff *skb,
 		if ((rxl->local_port == MLXSW_PORT_DONT_CARE ||
 		     rxl->local_port == local_port) &&
 		    rxl->trap_id == rx_info->trap_id) {
-			found = true;
+			if (rxl_item->enabled)
+				found = true;
 			break;
 		}
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index b6e57cbc084e..b1c2ad214191 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -129,7 +129,7 @@ struct mlxsw_listener {
 
 int mlxsw_core_rx_listener_register(struct mlxsw_core *mlxsw_core,
 				    const struct mlxsw_rx_listener *rxl,
-				    void *priv);
+				    void *priv, bool enabled);
 void mlxsw_core_rx_listener_unregister(struct mlxsw_core *mlxsw_core,
 				       const struct mlxsw_rx_listener *rxl);
 
-- 
2.21.1

