Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4C01696A5
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgBWHcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:32:09 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:32966 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgBWHcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:32:01 -0500
Received: by mail-wm1-f67.google.com with SMTP id m10so8338121wmc.0
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Uw1/fD7YPwtNQcffV1jDM31kknDn5olQFO06u9ASrw=;
        b=PUcOfOqE6aPj/dpFY7t/61/D/0cMmx2naWuXOSa2rSyPnfw3aLqYD7QYfa2Q/DFbH6
         YJ1IrHUpPkwoWyu9e/j6WjAqusrUj5YhQ/vNvpikbEN8P3PYVgogtDSMGiDqPw1srV9e
         3ucrCaCP/ipEMEQMsD6J/lJX20HxiqFNGoTaA6XPAVD0KGhOb9xv6+QGn5d3jvj4CuDB
         8OQOKf7y0RbCCLF/vwV6W8sjDsYxRtFZakUVxtZG5o6kmK/EfmQMkmESJoUWiPbmC3kn
         3QFOvN054vKpYdM4BE4Xfk5+JqPSnxx8ir8j2HDcIj+KzlqPENDiMGxKDIvuUpJv2OBi
         g/yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Uw1/fD7YPwtNQcffV1jDM31kknDn5olQFO06u9ASrw=;
        b=hJ9JV5ltTp1Kp0ChQeNtJhud3MxkD6zND1ptlpZx8DA5MvqUyKK9WXUMdtUmwVUhcQ
         n6GrYHQ/GPx6d7iPF9B/SulKMe26FDgH+XnHfQfze7hW2MNwOM1ckgT7MtnVpHX32yFT
         uY6z23GlfBzO4f49XM5NTDrOqF2gwTQNp/k2ihgR93FMtbJj/gAxatKMYGWcVROua0K7
         +wZsE8mfHLWfx4j7hLNU9JxgPdVJlJvHLzI1kZkRvPkAkzuwWIjp/NvL2NGho57AEnHM
         V5zciCDTCm71W1kjhh5Ks59mfAHG3l67xjDxbA0ZZu+z39K+fW/zGxcSPo2DQge8xGLu
         HFlA==
X-Gm-Message-State: APjAAAVkWW+wefQpMRrOUVT3o3gvFTUGsQ3J7C6EjnTbseUZWbbJ/3w5
        Up5BwMdrEoBdVarcrCKFT1P2KDO6h98=
X-Google-Smtp-Source: APXvYqxoeVZ8j8HbJoi30s3Il2NS/FcCNkgsXCE3LNnLZbOwv9zd//Cs3pdNwMijYpCB4SwuC4MZ3A==
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr14186539wma.84.1582443118278;
        Sat, 22 Feb 2020 23:31:58 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id j14sm12295376wrn.32.2020.02.22.23.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:57 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 11/12] mlxsw: core: Remove priv from listener equality comparison
Date:   Sun, 23 Feb 2020 08:31:43 +0100
Message-Id: <20200223073144.28529-12-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200223073144.28529-1-jiri@resnulli.us>
References: <20200223073144.28529-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

During packet receive, only the first matching RX listener
in rx_listener_list is going to get the packet. So there is no
meaning in registering two equal listeners with different privs.
Remove priv from equality comparison and disable possibility
of doing it.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 34 +++++++++-------------
 drivers/net/ethernet/mellanox/mlxsw/core.h |  6 ++--
 2 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 1ad959de909d..4b92ba574073 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1457,14 +1457,12 @@ static bool __is_rx_listener_equal(const struct mlxsw_rx_listener *rxl_a,
 
 static struct mlxsw_rx_listener_item *
 __find_rx_listener_item(struct mlxsw_core *mlxsw_core,
-			const struct mlxsw_rx_listener *rxl,
-			void *priv)
+			const struct mlxsw_rx_listener *rxl)
 {
 	struct mlxsw_rx_listener_item *rxl_item;
 
 	list_for_each_entry(rxl_item, &mlxsw_core->rx_listener_list, list) {
-		if (__is_rx_listener_equal(&rxl_item->rxl, rxl) &&
-		    rxl_item->priv == priv)
+		if (__is_rx_listener_equal(&rxl_item->rxl, rxl))
 			return rxl_item;
 	}
 	return NULL;
@@ -1476,7 +1474,7 @@ int mlxsw_core_rx_listener_register(struct mlxsw_core *mlxsw_core,
 {
 	struct mlxsw_rx_listener_item *rxl_item;
 
-	rxl_item = __find_rx_listener_item(mlxsw_core, rxl, priv);
+	rxl_item = __find_rx_listener_item(mlxsw_core, rxl);
 	if (rxl_item)
 		return -EEXIST;
 	rxl_item = kmalloc(sizeof(*rxl_item), GFP_KERNEL);
@@ -1491,12 +1489,11 @@ int mlxsw_core_rx_listener_register(struct mlxsw_core *mlxsw_core,
 EXPORT_SYMBOL(mlxsw_core_rx_listener_register);
 
 void mlxsw_core_rx_listener_unregister(struct mlxsw_core *mlxsw_core,
-				       const struct mlxsw_rx_listener *rxl,
-				       void *priv)
+				       const struct mlxsw_rx_listener *rxl)
 {
 	struct mlxsw_rx_listener_item *rxl_item;
 
-	rxl_item = __find_rx_listener_item(mlxsw_core, rxl, priv);
+	rxl_item = __find_rx_listener_item(mlxsw_core, rxl);
 	if (!rxl_item)
 		return;
 	list_del_rcu(&rxl_item->list);
@@ -1534,14 +1531,12 @@ static bool __is_event_listener_equal(const struct mlxsw_event_listener *el_a,
 
 static struct mlxsw_event_listener_item *
 __find_event_listener_item(struct mlxsw_core *mlxsw_core,
-			   const struct mlxsw_event_listener *el,
-			   void *priv)
+			   const struct mlxsw_event_listener *el)
 {
 	struct mlxsw_event_listener_item *el_item;
 
 	list_for_each_entry(el_item, &mlxsw_core->event_listener_list, list) {
-		if (__is_event_listener_equal(&el_item->el, el) &&
-		    el_item->priv == priv)
+		if (__is_event_listener_equal(&el_item->el, el))
 			return el_item;
 	}
 	return NULL;
@@ -1559,7 +1554,7 @@ int mlxsw_core_event_listener_register(struct mlxsw_core *mlxsw_core,
 		.trap_id = el->trap_id,
 	};
 
-	el_item = __find_event_listener_item(mlxsw_core, el, priv);
+	el_item = __find_event_listener_item(mlxsw_core, el);
 	if (el_item)
 		return -EEXIST;
 	el_item = kmalloc(sizeof(*el_item), GFP_KERNEL);
@@ -1586,8 +1581,7 @@ int mlxsw_core_event_listener_register(struct mlxsw_core *mlxsw_core,
 EXPORT_SYMBOL(mlxsw_core_event_listener_register);
 
 void mlxsw_core_event_listener_unregister(struct mlxsw_core *mlxsw_core,
-					  const struct mlxsw_event_listener *el,
-					  void *priv)
+					  const struct mlxsw_event_listener *el)
 {
 	struct mlxsw_event_listener_item *el_item;
 	const struct mlxsw_rx_listener rxl = {
@@ -1596,10 +1590,10 @@ void mlxsw_core_event_listener_unregister(struct mlxsw_core *mlxsw_core,
 		.trap_id = el->trap_id,
 	};
 
-	el_item = __find_event_listener_item(mlxsw_core, el, priv);
+	el_item = __find_event_listener_item(mlxsw_core, el);
 	if (!el_item)
 		return;
-	mlxsw_core_rx_listener_unregister(mlxsw_core, &rxl, el_item);
+	mlxsw_core_rx_listener_unregister(mlxsw_core, &rxl);
 	list_del(&el_item->list);
 	kfree(el_item);
 }
@@ -1625,12 +1619,10 @@ static void mlxsw_core_listener_unregister(struct mlxsw_core *mlxsw_core,
 {
 	if (listener->is_event)
 		mlxsw_core_event_listener_unregister(mlxsw_core,
-						     &listener->event_listener,
-						     priv);
+						     &listener->event_listener);
 	else
 		mlxsw_core_rx_listener_unregister(mlxsw_core,
-						  &listener->rx_listener,
-						  priv);
+						  &listener->rx_listener);
 }
 
 int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index c5890e35fd2f..5773e25ecf98 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -116,15 +116,13 @@ int mlxsw_core_rx_listener_register(struct mlxsw_core *mlxsw_core,
 				    const struct mlxsw_rx_listener *rxl,
 				    void *priv);
 void mlxsw_core_rx_listener_unregister(struct mlxsw_core *mlxsw_core,
-				       const struct mlxsw_rx_listener *rxl,
-				       void *priv);
+				       const struct mlxsw_rx_listener *rxl);
 
 int mlxsw_core_event_listener_register(struct mlxsw_core *mlxsw_core,
 				       const struct mlxsw_event_listener *el,
 				       void *priv);
 void mlxsw_core_event_listener_unregister(struct mlxsw_core *mlxsw_core,
-					  const struct mlxsw_event_listener *el,
-					  void *priv);
+					  const struct mlxsw_event_listener *el);
 
 int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
 			     const struct mlxsw_listener *listener,
-- 
2.21.1

