Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF3D306579
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhA0Uzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:55:54 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:17352 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbhA0UzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:55:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611780922; x=1643316922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T0HrEE1cC4riKci4S2bD/LUtEMpp9hvfssr4U4/6vgA=;
  b=OFzHtSXe++4hHv1yBUVjwsXw4NsOWu+G4fCalOwNYJuWfjR3UqdUjwYw
   BLEKRwqoLzsZfUPuCo2JruJgMoQdCZSCo8p5nw+sGVTBsUH1g+QK2QyRf
   hxgguwYhHKMG7gceqgVGYGC98k4UoLUBsUosn6DksmVdnpFA812qo7zit
   pOIFEkmT/F3tDFh1dwRydLgi/5M9miexCkZfaxRkBSLe/iVM9PRIJxU40
   zUrQqhoNZePY+o7BreMkKpENxd6ES42yvQfdhujnw1J+Vhbl/4GACm6XV
   WE5JJEuK/PRGXzypfDeHDf1nkFiiOG0KMBnC/oLj+6pgH5cHa7aPMxWcg
   A==;
IronPort-SDR: IdUGRO1KgZQ9uTj/dQImMURowiiYlTjpbfCJ7SuIYxzKm/OtfwHKdFkGZvndQr5iehz36gJwN8
 dAYpNC3I79EozqRQyS+eB2yV7h+DIq5pIln4JLjTyZUU1VoZyqITMeU4d7YFa3vofFjknC6ZqT
 TJ/vT7ko+GWf3ar4sEBk1dE6KQC9t8590yFqcgY6dsqelKtDta4/DlfQTMfRPfwej+CCSM9om3
 nJ36jWz/qqyrI1jcpnOZO2p6zyTGfqDpbPctGK4vFLVZF6aLimou6wMEGFUXQmzlXkZU+pqj5I
 2WM=
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="107543319"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 13:54:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 13:54:06 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 13:54:04 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 3/4] bridge: mrp: Extend br_mrp_switchdev to detect better the errors
Date:   Wed, 27 Jan 2021 21:52:40 +0100
Message-ID: <20210127205241.2864728-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
References: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the br_mrp_switchdev functions to be able to have a
better understanding what cause the issue and if the SW needs to be used
as a backup.

There are the following cases:
- when the code is compiled without CONFIG_NET_SWITCHDEV. In this case
  return success so the SW can continue with the protocol. Depending
  on the function, it returns 0 or BR_MRP_SW.
- when code is compiled with CONFIG_NET_SWITCHDEV and the driver doesn't
  implement any MRP callbacks. In this case the HW can't run MRP so it
  just returns -EOPNOTSUPP. So the SW will stop further to configure the
  node.
- when code is compiled with CONFIG_NET_SWITCHDEV and the driver fully
  supports any MRP functionality. In this case the SW doesn't need to do
  anything. The functions will return 0 or BR_MRP_HW.
- when code is compiled with CONFIG_NET_SWITCHDEV and the HW can't run
  completely the protocol but it can help the SW to run it. For
  example, the HW can't support completely MRM role(can't detect when it
  stops receiving MRP Test frames) but it can redirect these frames to
  CPU. In this case it is possible to have a SW fallback. The SW will
  try initially to call the driver with sw_backup set to false, meaning
  that the HW should implement completely the role. If the driver returns
  -EOPNOTSUPP, the SW will try again with sw_backup set to false,
  meaning that the SW will detect when it stops receiving the frames but
  it needs HW support to redirect the frames to CPU. In case the driver
  returns 0 then the SW will continue to configure the node accordingly.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp_switchdev.c | 171 +++++++++++++++++++++-------------
 net/bridge/br_private_mrp.h   |  24 +++--
 2 files changed, 118 insertions(+), 77 deletions(-)

diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
index ed547e03ace1..ffd844e9be6b 100644
--- a/net/bridge/br_mrp_switchdev.c
+++ b/net/bridge/br_mrp_switchdev.c
@@ -4,6 +4,30 @@
 
 #include "br_private_mrp.h"
 
+static enum br_mrp_hw_support
+br_mrp_switchdev_port_obj(struct net_bridge *br,
+			  const struct switchdev_obj *obj, bool add)
+{
+	int err;
+
+	if (add)
+		err = switchdev_port_obj_add(br->dev, obj, NULL);
+	else
+		err = switchdev_port_obj_del(br->dev, obj);
+
+	/* In case of success just return and notify the SW that doesn't need
+	 * to do anything
+	 */
+	if (!err)
+		return BR_MRP_HW;
+
+	if (err != -EOPNOTSUPP)
+		return BR_MRP_NONE;
+
+	/* Continue with SW backup */
+	return BR_MRP_SW;
+}
+
 int br_mrp_switchdev_add(struct net_bridge *br, struct br_mrp *mrp)
 {
 	struct switchdev_obj_mrp mrp_obj = {
@@ -14,14 +38,11 @@ int br_mrp_switchdev_add(struct net_bridge *br, struct br_mrp *mrp)
 		.ring_id = mrp->ring_id,
 		.prio = mrp->prio,
 	};
-	int err;
 
-	err = switchdev_port_obj_add(br->dev, &mrp_obj.obj, NULL);
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
-	return 0;
+	return switchdev_port_obj_add(br->dev, &mrp_obj.obj, NULL);
 }
 
 int br_mrp_switchdev_del(struct net_bridge *br, struct br_mrp *mrp)
@@ -33,40 +54,54 @@ int br_mrp_switchdev_del(struct net_bridge *br, struct br_mrp *mrp)
 		.s_port = NULL,
 		.ring_id = mrp->ring_id,
 	};
-	int err;
-
-	err = switchdev_port_obj_del(br->dev, &mrp_obj.obj);
 
-	if (err && err != -EOPNOTSUPP)
-		return err;
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	return 0;
+	return switchdev_port_obj_del(br->dev, &mrp_obj.obj);
 }
 
-int br_mrp_switchdev_set_ring_role(struct net_bridge *br,
-				   struct br_mrp *mrp,
-				   enum br_mrp_ring_role_type role)
+enum br_mrp_hw_support
+br_mrp_switchdev_set_ring_role(struct net_bridge *br, struct br_mrp *mrp,
+			       enum br_mrp_ring_role_type role)
 {
 	struct switchdev_obj_ring_role_mrp mrp_role = {
 		.obj.orig_dev = br->dev,
 		.obj.id = SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
 		.ring_role = role,
 		.ring_id = mrp->ring_id,
+		.sw_backup = false,
 	};
+	enum br_mrp_hw_support support;
 	int err;
 
-	if (role == BR_MRP_RING_ROLE_DISABLED)
-		err = switchdev_port_obj_del(br->dev, &mrp_role.obj);
-	else
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return BR_MRP_SW;
+
+	support = br_mrp_switchdev_port_obj(br, &mrp_role.obj,
+					    role != BR_MRP_RING_ROLE_DISABLED);
+	if (support != BR_MRP_SW)
+		return support;
+
+	/* If the driver can't configure to run completely the protocol in HW,
+	 * then try again to configure the HW so the SW can run the protocol.
+	 */
+	mrp_role.sw_backup = true;
+	if (role != BR_MRP_RING_ROLE_DISABLED)
 		err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
+	else
+		err = switchdev_port_obj_del(br->dev, &mrp_role.obj);
 
-	return err;
+	if (!err)
+		return BR_MRP_SW;
+
+	return BR_MRP_NONE;
 }
 
-int br_mrp_switchdev_send_ring_test(struct net_bridge *br,
-				    struct br_mrp *mrp, u32 interval,
-				    u8 max_miss, u32 period,
-				    bool monitor)
+enum br_mrp_hw_support
+br_mrp_switchdev_send_ring_test(struct net_bridge *br, struct br_mrp *mrp,
+				u32 interval, u8 max_miss, u32 period,
+				bool monitor)
 {
 	struct switchdev_obj_ring_test_mrp test = {
 		.obj.orig_dev = br->dev,
@@ -77,14 +112,11 @@ int br_mrp_switchdev_send_ring_test(struct net_bridge *br,
 		.period = period,
 		.monitor = monitor,
 	};
-	int err;
 
-	if (interval == 0)
-		err = switchdev_port_obj_del(br->dev, &test.obj);
-	else
-		err = switchdev_port_obj_add(br->dev, &test.obj, NULL);
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return BR_MRP_SW;
 
-	return err;
+	return br_mrp_switchdev_port_obj(br, &test.obj, interval != 0);
 }
 
 int br_mrp_switchdev_set_ring_state(struct net_bridge *br,
@@ -97,19 +129,17 @@ int br_mrp_switchdev_set_ring_state(struct net_bridge *br,
 		.ring_state = state,
 		.ring_id = mrp->ring_id,
 	};
-	int err;
-
-	err = switchdev_port_obj_add(br->dev, &mrp_state.obj, NULL);
 
-	if (err && err != -EOPNOTSUPP)
-		return err;
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	return 0;
+	return switchdev_port_obj_add(br->dev, &mrp_state.obj, NULL);
 }
 
-int br_mrp_switchdev_set_in_role(struct net_bridge *br, struct br_mrp *mrp,
-				 u16 in_id, u32 ring_id,
-				 enum br_mrp_in_role_type role)
+enum br_mrp_hw_support
+br_mrp_switchdev_set_in_role(struct net_bridge *br, struct br_mrp *mrp,
+			     u16 in_id, u32 ring_id,
+			     enum br_mrp_in_role_type role)
 {
 	struct switchdev_obj_in_role_mrp mrp_role = {
 		.obj.orig_dev = br->dev,
@@ -118,15 +148,32 @@ int br_mrp_switchdev_set_in_role(struct net_bridge *br, struct br_mrp *mrp,
 		.in_id = mrp->in_id,
 		.ring_id = mrp->ring_id,
 		.i_port = rtnl_dereference(mrp->i_port)->dev,
+		.sw_backup = false,
 	};
+	enum br_mrp_hw_support support;
 	int err;
 
-	if (role == BR_MRP_IN_ROLE_DISABLED)
-		err = switchdev_port_obj_del(br->dev, &mrp_role.obj);
-	else
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return BR_MRP_SW;
+
+	support = br_mrp_switchdev_port_obj(br, &mrp_role.obj,
+					    role != BR_MRP_IN_ROLE_DISABLED);
+	if (support != BR_MRP_NONE)
+		return support;
+
+	/* If the driver can't configure to run completely the protocol in HW,
+	 * then try again to configure the HW so the SW can run the protocol.
+	 */
+	mrp_role.sw_backup = true;
+	if (role != BR_MRP_IN_ROLE_DISABLED)
 		err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
+	else
+		err = switchdev_port_obj_del(br->dev, &mrp_role.obj);
+
+	if (!err)
+		return BR_MRP_SW;
 
-	return err;
+	return BR_MRP_NONE;
 }
 
 int br_mrp_switchdev_set_in_state(struct net_bridge *br, struct br_mrp *mrp,
@@ -138,18 +185,16 @@ int br_mrp_switchdev_set_in_state(struct net_bridge *br, struct br_mrp *mrp,
 		.in_state = state,
 		.in_id = mrp->in_id,
 	};
-	int err;
-
-	err = switchdev_port_obj_add(br->dev, &mrp_state.obj, NULL);
 
-	if (err && err != -EOPNOTSUPP)
-		return err;
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	return 0;
+	return switchdev_port_obj_add(br->dev, &mrp_state.obj, NULL);
 }
 
-int br_mrp_switchdev_send_in_test(struct net_bridge *br, struct br_mrp *mrp,
-				  u32 interval, u8 max_miss, u32 period)
+enum br_mrp_hw_support
+br_mrp_switchdev_send_in_test(struct net_bridge *br, struct br_mrp *mrp,
+			      u32 interval, u8 max_miss, u32 period)
 {
 	struct switchdev_obj_in_test_mrp test = {
 		.obj.orig_dev = br->dev,
@@ -159,14 +204,11 @@ int br_mrp_switchdev_send_in_test(struct net_bridge *br, struct br_mrp *mrp,
 		.in_id = mrp->in_id,
 		.period = period,
 	};
-	int err;
 
-	if (interval == 0)
-		err = switchdev_port_obj_del(br->dev, &test.obj);
-	else
-		err = switchdev_port_obj_add(br->dev, &test.obj, NULL);
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return BR_MRP_SW;
 
-	return err;
+	return br_mrp_switchdev_port_obj(br, &test.obj, interval != 0);
 }
 
 int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
@@ -177,14 +219,11 @@ int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
 		.id = SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
 		.u.mrp_port_state = state,
 	};
-	int err;
 
-	err = switchdev_port_attr_set(p->dev, &attr);
-	if (err && err != -EOPNOTSUPP)
-		br_warn(p->br, "error setting offload MRP state on port %u(%s)\n",
-			(unsigned int)p->port_no, p->dev->name);
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	return err;
+	return switchdev_port_attr_set(p->dev, &attr);
 }
 
 int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
@@ -195,11 +234,9 @@ int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
 		.id = SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
 		.u.mrp_port_role = role,
 	};
-	int err;
 
-	err = switchdev_port_attr_set(p->dev, &attr);
-	if (err && err != -EOPNOTSUPP)
-		return err;
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	return 0;
+	return switchdev_port_attr_set(p->dev, &attr);
 }
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 31e666ae6955..e941dad398cf 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -79,24 +79,28 @@ int br_mrp_start_in_test(struct net_bridge *br,
 /* br_mrp_switchdev.c */
 int br_mrp_switchdev_add(struct net_bridge *br, struct br_mrp *mrp);
 int br_mrp_switchdev_del(struct net_bridge *br, struct br_mrp *mrp);
-int br_mrp_switchdev_set_ring_role(struct net_bridge *br, struct br_mrp *mrp,
-				   enum br_mrp_ring_role_type role);
+enum br_mrp_hw_support
+br_mrp_switchdev_set_ring_role(struct net_bridge *br, struct br_mrp *mrp,
+			       enum br_mrp_ring_role_type role);
 int br_mrp_switchdev_set_ring_state(struct net_bridge *br, struct br_mrp *mrp,
 				    enum br_mrp_ring_state_type state);
-int br_mrp_switchdev_send_ring_test(struct net_bridge *br, struct br_mrp *mrp,
-				    u32 interval, u8 max_miss, u32 period,
-				    bool monitor);
+enum br_mrp_hw_support
+br_mrp_switchdev_send_ring_test(struct net_bridge *br, struct br_mrp *mrp,
+				u32 interval, u8 max_miss, u32 period,
+				bool monitor);
 int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
 				    enum br_mrp_port_state_type state);
 int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
 				   enum br_mrp_port_role_type role);
-int br_mrp_switchdev_set_in_role(struct net_bridge *br, struct br_mrp *mrp,
-				 u16 in_id, u32 ring_id,
-				 enum br_mrp_in_role_type role);
+enum br_mrp_hw_support
+br_mrp_switchdev_set_in_role(struct net_bridge *br, struct br_mrp *mrp,
+			     u16 in_id, u32 ring_id,
+			     enum br_mrp_in_role_type role);
 int br_mrp_switchdev_set_in_state(struct net_bridge *br, struct br_mrp *mrp,
 				  enum br_mrp_in_state_type state);
-int br_mrp_switchdev_send_in_test(struct net_bridge *br, struct br_mrp *mrp,
-				  u32 interval, u8 max_miss, u32 period);
+enum br_mrp_hw_support
+br_mrp_switchdev_send_in_test(struct net_bridge *br, struct br_mrp *mrp,
+			      u32 interval, u8 max_miss, u32 period);
 
 /* br_mrp_netlink.c  */
 int br_mrp_ring_port_open(struct net_device *dev, u8 loc);
-- 
2.27.0

