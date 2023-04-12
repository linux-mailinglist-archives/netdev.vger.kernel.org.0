Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4430E6DEA2A
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjDLEI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjDLEIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A0C526A
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 012E262DA9
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A94C433EF;
        Wed, 12 Apr 2023 04:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272488;
        bh=032JmDWv8d5jlUbjFKOcXwfkSvYVfLttYNSAmhacHPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ekj+Xv9HgRWpX5j5QEcXc3uMCeVySgpLuZRH2elmqxByjVa/Ht2MnAaWMBo1Unhxp
         WOv+NFxbBJTI+tnZp3Pu18UjX1i+61bZ9jhHQ0frnOZS5K5lrMAF2znGJJkUiBGJON
         CYx+r5E3oj0OciYI2f2ogI0hr81l3+GQfWh7+1GkQlYTuBeRbnHYrBpJ8WOZT6D7MC
         Ew7CvK/6xRlkhVpYyU2RSihE2uZE6TgJL4qL2o0DIdPEcfTFMbsIbfsqA5cBxbFKga
         jluI/YJfNPlZbjE9oiYdyPo0BRWG4tOP2dC+sJ2WOu4GLQVWTx7ZIJATXq0w81k1yF
         HQVF8xstgqyjA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 09/15] net/mlx5: Bridge, add tracepoints for multicast
Date:   Tue, 11 Apr 2023 21:07:46 -0700
Message-Id: <20230412040752.14220-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Pass target struct net_device to mdb attach/detach handler in order to
expose the port name to the new tracepoints. Implemented following
tracepoints:

- Attach mdb to port.
- Detach mdb from port.

Usage example:

># cd /sys/kernel/debug/tracing
># echo mlx5:mlx5_esw_bridge_port_mdb_attach >> set_event
># cat trace
...
     kworker/0:0-19071   [000] ..... 259004.253848: mlx5_esw_bridge_port_mdb_attach: net_device=enp8s0f0_0 addr=33:33:ff:00:00:01 vid=0 num_ports=1 offloaded=1

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/rep/bridge.c        |  4 +--
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 14 ++++----
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  | 10 +++---
 .../mellanox/mlx5/core/esw/bridge_mcast.c     | 12 ++++---
 .../mellanox/mlx5/core/esw/bridge_priv.h      |  8 ++---
 .../mlx5/core/esw/diag/bridge_tracepoint.h    | 35 +++++++++++++++++++
 6 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index dd0dd3f028a3..fd191925ab4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -238,7 +238,7 @@ mlx5_esw_bridge_port_obj_add(struct net_device *dev,
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
-		err = mlx5_esw_bridge_port_mdb_add(vport_num, esw_owner_vhca_id, mdb->addr,
+		err = mlx5_esw_bridge_port_mdb_add(dev, vport_num, esw_owner_vhca_id, mdb->addr,
 						   mdb->vid, br_offloads, extack);
 		break;
 	default:
@@ -270,7 +270,7 @@ mlx5_esw_bridge_port_obj_del(struct net_device *dev,
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
-		mlx5_esw_bridge_port_mdb_del(vport_num, esw_owner_vhca_id, mdb->addr, mdb->vid,
+		mlx5_esw_bridge_port_mdb_del(dev, vport_num, esw_owner_vhca_id, mdb->addr, mdb->vid,
 					     br_offloads);
 		break;
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index be4787539c6c..1ba03e219111 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1803,8 +1803,9 @@ void mlx5_esw_bridge_update(struct mlx5_esw_bridge_offloads *br_offloads)
 	}
 }
 
-int mlx5_esw_bridge_port_mdb_add(u16 vport_num, u16 esw_owner_vhca_id, const unsigned char *addr,
-				 u16 vid, struct mlx5_esw_bridge_offloads *br_offloads,
+int mlx5_esw_bridge_port_mdb_add(struct net_device *dev, u16 vport_num, u16 esw_owner_vhca_id,
+				 const unsigned char *addr, u16 vid,
+				 struct mlx5_esw_bridge_offloads *br_offloads,
 				 struct netlink_ext_ack *extack)
 {
 	struct mlx5_esw_bridge_vlan *vlan;
@@ -1837,7 +1838,7 @@ int mlx5_esw_bridge_port_mdb_add(u16 vport_num, u16 esw_owner_vhca_id, const uns
 		}
 	}
 
-	err = mlx5_esw_bridge_port_mdb_attach(port, addr, vid);
+	err = mlx5_esw_bridge_port_mdb_attach(dev, port, addr, vid);
 	if (err) {
 		NL_SET_ERR_MSG_FMT_MOD(extack, "Failed to add MDB (MAC=%pM,vid=%u,vport=%u)\n",
 				       addr, vid, vport_num);
@@ -1847,8 +1848,9 @@ int mlx5_esw_bridge_port_mdb_add(u16 vport_num, u16 esw_owner_vhca_id, const uns
 	return 0;
 }
 
-void mlx5_esw_bridge_port_mdb_del(u16 vport_num, u16 esw_owner_vhca_id, const unsigned char *addr,
-				  u16 vid, struct mlx5_esw_bridge_offloads *br_offloads)
+void mlx5_esw_bridge_port_mdb_del(struct net_device *dev, u16 vport_num, u16 esw_owner_vhca_id,
+				  const unsigned char *addr, u16 vid,
+				  struct mlx5_esw_bridge_offloads *br_offloads)
 {
 	struct mlx5_esw_bridge_port *port;
 
@@ -1856,7 +1858,7 @@ void mlx5_esw_bridge_port_mdb_del(u16 vport_num, u16 esw_owner_vhca_id, const un
 	if (!port)
 		return;
 
-	mlx5_esw_bridge_port_mdb_detach(port, addr, vid);
+	mlx5_esw_bridge_port_mdb_detach(dev, port, addr, vid);
 }
 
 static void mlx5_esw_bridge_flush(struct mlx5_esw_bridge_offloads *br_offloads)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index 9cab66467289..a9dd18c73d6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -79,10 +79,12 @@ int mlx5_esw_bridge_port_vlan_add(u16 vport_num, u16 esw_owner_vhca_id, u16 vid,
 void mlx5_esw_bridge_port_vlan_del(u16 vport_num, u16 esw_owner_vhca_id, u16 vid,
 				   struct mlx5_esw_bridge_offloads *br_offloads);
 
-int mlx5_esw_bridge_port_mdb_add(u16 vport_num, u16 esw_owner_vhca_id, const unsigned char *addr,
-				 u16 vid, struct mlx5_esw_bridge_offloads *br_offloads,
+int mlx5_esw_bridge_port_mdb_add(struct net_device *dev, u16 vport_num, u16 esw_owner_vhca_id,
+				 const unsigned char *addr, u16 vid,
+				 struct mlx5_esw_bridge_offloads *br_offloads,
 				 struct netlink_ext_ack *extack);
-void mlx5_esw_bridge_port_mdb_del(u16 vport_num, u16 esw_owner_vhca_id, const unsigned char *addr,
-				  u16 vid, struct mlx5_esw_bridge_offloads *br_offloads);
+void mlx5_esw_bridge_port_mdb_del(struct net_device *dev, u16 vport_num, u16 esw_owner_vhca_id,
+				  const unsigned char *addr, u16 vid,
+				  struct mlx5_esw_bridge_offloads *br_offloads);
 
 #endif /* __MLX5_ESW_BRIDGE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
index d17fe6d374b5..2eae594a5e80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
@@ -5,6 +5,7 @@
 #include "bridge.h"
 #include "eswitch.h"
 #include "bridge_priv.h"
+#include "diag/bridge_tracepoint.h"
 
 static const struct rhashtable_params mdb_ht_params = {
 	.key_offset = offsetof(struct mlx5_esw_bridge_mdb_entry, key),
@@ -180,8 +181,8 @@ static void mlx5_esw_bridge_port_mdb_entry_cleanup(struct mlx5_esw_bridge *bridg
 	kvfree(entry);
 }
 
-int mlx5_esw_bridge_port_mdb_attach(struct mlx5_esw_bridge_port *port, const unsigned char *addr,
-				    u16 vid)
+int mlx5_esw_bridge_port_mdb_attach(struct net_device *dev, struct mlx5_esw_bridge_port *port,
+				    const unsigned char *addr, u16 vid)
 {
 	struct mlx5_esw_bridge *bridge = port->bridge;
 	struct mlx5_esw_bridge_mdb_entry *entry;
@@ -224,6 +225,8 @@ int mlx5_esw_bridge_port_mdb_attach(struct mlx5_esw_bridge_port *port, const uns
 		 */
 		esw_warn(bridge->br_offloads->esw->dev, "MDB attach failed to offload (MAC=%pM,vid=%u,vport=%u,err=%d)\n",
 			 addr, vid, port->vport_num, err);
+
+	trace_mlx5_esw_bridge_port_mdb_attach(dev, entry);
 	return 0;
 }
 
@@ -248,8 +251,8 @@ static void mlx5_esw_bridge_port_mdb_entry_detach(struct mlx5_esw_bridge_port *p
 			 entry->key.addr, entry->key.vid, port->vport_num);
 }
 
-void mlx5_esw_bridge_port_mdb_detach(struct mlx5_esw_bridge_port *port, const unsigned char *addr,
-				     u16 vid)
+void mlx5_esw_bridge_port_mdb_detach(struct net_device *dev, struct mlx5_esw_bridge_port *port,
+				     const unsigned char *addr, u16 vid)
 {
 	struct mlx5_esw_bridge *bridge = port->bridge;
 	struct mlx5_esw_bridge_mdb_entry *entry;
@@ -269,6 +272,7 @@ void mlx5_esw_bridge_port_mdb_detach(struct mlx5_esw_bridge_port *port, const un
 		return;
 	}
 
+	trace_mlx5_esw_bridge_port_mdb_detach(dev, entry);
 	mlx5_esw_bridge_port_mdb_entry_detach(port, entry);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
index 849028f94be2..c9595801bdb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
@@ -233,10 +233,10 @@ void mlx5_esw_bridge_mcast_disable(struct mlx5_esw_bridge *bridge);
 
 int mlx5_esw_bridge_mdb_init(struct mlx5_esw_bridge *bridge);
 void mlx5_esw_bridge_mdb_cleanup(struct mlx5_esw_bridge *bridge);
-int mlx5_esw_bridge_port_mdb_attach(struct mlx5_esw_bridge_port *port, const unsigned char *addr,
-				    u16 vid);
-void mlx5_esw_bridge_port_mdb_detach(struct mlx5_esw_bridge_port *port, const unsigned char *addr,
-				     u16 vid);
+int mlx5_esw_bridge_port_mdb_attach(struct net_device *dev, struct mlx5_esw_bridge_port *port,
+				    const unsigned char *addr, u16 vid);
+void mlx5_esw_bridge_port_mdb_detach(struct net_device *dev, struct mlx5_esw_bridge_port *port,
+				     const unsigned char *addr, u16 vid);
 void mlx5_esw_bridge_port_mdb_vlan_flush(struct mlx5_esw_bridge_port *port,
 					 struct mlx5_esw_bridge_vlan *vlan);
 void mlx5_esw_bridge_mdb_flush(struct mlx5_esw_bridge *bridge);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
index 51ac24e6ec3c..1808da214094 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
@@ -110,6 +110,41 @@ DEFINE_EVENT(mlx5_esw_bridge_port_template,
 	     TP_ARGS(port)
 	);
 
+DECLARE_EVENT_CLASS(mlx5_esw_bridge_mdb_port_change_template,
+		    TP_PROTO(const struct net_device *dev,
+			     const struct mlx5_esw_bridge_mdb_entry *mdb),
+		    TP_ARGS(dev, mdb),
+		    TP_STRUCT__entry(
+			    __array(char, dev_name, IFNAMSIZ)
+			    __array(unsigned char, addr, ETH_ALEN)
+			    __field(u16, vid)
+			    __field(int, num_ports)
+			    __field(bool, offloaded)),
+		    TP_fast_assign(
+			    strscpy(__entry->dev_name, netdev_name(dev), IFNAMSIZ);
+			    memcpy(__entry->addr, mdb->key.addr, ETH_ALEN);
+			    __entry->vid = mdb->key.vid;
+			    __entry->num_ports = mdb->num_ports;
+			    __entry->offloaded = mdb->egress_handle;),
+		    TP_printk("net_device=%s addr=%pM vid=%u num_ports=%d offloaded=%d",
+			      __entry->dev_name,
+			      __entry->addr,
+			      __entry->vid,
+			      __entry->num_ports,
+			      __entry->offloaded));
+
+DEFINE_EVENT(mlx5_esw_bridge_mdb_port_change_template,
+	     mlx5_esw_bridge_port_mdb_attach,
+	     TP_PROTO(const struct net_device *dev,
+		      const struct mlx5_esw_bridge_mdb_entry *mdb),
+	     TP_ARGS(dev, mdb));
+
+DEFINE_EVENT(mlx5_esw_bridge_mdb_port_change_template,
+	     mlx5_esw_bridge_port_mdb_detach,
+	     TP_PROTO(const struct net_device *dev,
+		      const struct mlx5_esw_bridge_mdb_entry *mdb),
+	     TP_ARGS(dev, mdb));
+
 #endif
 
 /* This part must be outside protection */
-- 
2.39.2

