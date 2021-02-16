Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D8031D253
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhBPVqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:46:34 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:8067 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhBPVqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:46:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613511961; x=1645047961;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bk5PzErx6g4A4iPPoaxjVOkdstJtGjan8JWJz8p7Pv4=;
  b=cL3EJi1aiuh25S/sWZIysbXII9stYFNZrKuhgs+EaofFAgS5sUfpF9R7
   HLKevOIHAg3CjUWXPdS5hlG+C5NieZwkbcF+okQVbhmCcjoGf+APqRclL
   +IWu5xn4h1ESxE+8R5V0Nm+Whh1KiINNXVUewZ+YF3pA318ri5vnmkuLx
   XoEJwq0IgHg7DxeurMqTbWJdFLBaPZMgLks2MuDnSZ7SLSlELMsotnr09
   H/OWTpx0q7Pruyz+gK4L9JA+n+mie4sp2CV/u9T1Jjn7+kF6nTV5UoIw9
   rgI0yyjM7o1BMGlrEG0XWIBiRzrIpRuqAVJ5k9VyYZmkGJoLaGr4kCoTF
   w==;
IronPort-SDR: 46kyS09quXlIlYd112rbNmF2Km0e2ioXPYavjzhe5eYRd7y9XnVT2n47geT6MiW5hiTGSMvMqa
 LHcKeaYLQEp+cfarx6b+tQQEUa530Neyu/0ummOIokWq8S7iJrBdkgMZpTNhyLUe4+iu0iyZM6
 8CJcXBCxH/tlTAHxMzQzx9zrw5Db8DEWyLiU0hDTj7YDsI7HdKShtramN9HO9iodUvrvOuxDBF
 3WouFtzSN5AugKuTx+YITTwdrFk+ju/mduxrGi0dyKrPPVoKMGiEcmYRJjWRTyof+oBawDjEDu
 i9E=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="109421081"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 14:43:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 14:43:14 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 16 Feb 2021 14:43:10 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jiri@resnulli.us>, <ivecera@redhat.com>, <nikolay@nvidia.com>,
        <roopa@nvidia.com>, <vladimir.oltean@nxp.com>,
        <claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <rasmus.villemoes@prevas.dk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 4/8] bridge: mrp: Extend br_mrp_switchdev to detect better the errors
Date:   Tue, 16 Feb 2021 22:42:01 +0100
Message-ID: <20210216214205.32385-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216214205.32385-1-horatiu.vultur@microchip.com>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
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
index 3c9a4abcf4ee..cb54b324fa8c 100644
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
 
 int br_mrp_port_switchdev_set_state(struct net_bridge_port *p, u32 state)
@@ -176,14 +218,11 @@ int br_mrp_port_switchdev_set_state(struct net_bridge_port *p, u32 state)
 		.id = SWITCHDEV_ATTR_ID_PORT_STP_STATE,
 		.u.stp_state = state,
 	};
-	int err;
 
-	err = switchdev_port_attr_set(p->dev, &attr, NULL);
-	if (err && err != -EOPNOTSUPP)
-		br_warn(p->br, "error setting offload MRP state on port %u(%s)\n",
-			(unsigned int)p->port_no, p->dev->name);
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	return err;
+	return switchdev_port_attr_set(p->dev, &attr, NULL);
 }
 
 int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
@@ -194,11 +233,9 @@ int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
 		.id = SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
 		.u.mrp_port_role = role,
 	};
-	int err;
 
-	err = switchdev_port_attr_set(p->dev, &attr, NULL);
-	if (err && err != -EOPNOTSUPP)
-		return err;
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	return 0;
+	return switchdev_port_attr_set(p->dev, &attr, NULL);
 }
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 966444304c38..9559aa2750fb 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -79,23 +79,27 @@ int br_mrp_start_in_test(struct net_bridge *br,
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
 int br_mrp_port_switchdev_set_state(struct net_bridge_port *p, u32 state);
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

