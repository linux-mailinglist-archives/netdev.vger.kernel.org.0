Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715E53016BE
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 17:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbhAWQVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 11:21:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:56961 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbhAWQVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 11:21:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611418874; x=1642954874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qTtsLy9WYlJggMUpOJdxbLdFGX/eib7pjLItnhe6z7Q=;
  b=Vda6cGypQLHBsYLs2VT+7uLAXdqQ/+l25EGegl5NcMz14YsnzerCJ+ZY
   7yI2bGbozFYwXiKWI+bIWehN7DzsFP40jFhBAskgtai517MaRxEUpc8pv
   +WoI8Y1IuOotSAiky71lp4TsmADSKW6wgSHDf7J507hcR/HYM8dyT87ls
   fVNFVeVGTzTAxyjGmG6xMxGThqU75aKhF3Im69+qryOLkgXqyOcLWmRYb
   u9Ae1A8baAiVMW2duet61mv8F/nkrhm63Tp7Wf4wOqptkSIYH4Xz8weRw
   p/1LtXykn7gFE6f1hI/DAtAPuekKWT8EZPT3kJW8N511l8p8lTd55CAnM
   w==;
IronPort-SDR: aye/YBb1IajPmPuc/7mxm7V5kLJrma67pMwlCnf+3E1TlHuKNBgO/ytqtkQPqj+LFXz3prGY0K
 QpkgtdKfd2R6eAzoWUqgTxKswLCd/UTZnZ9ZaKPyuGZYiGZCczQQwHQpAPGicZUEbuD+wfNHZ7
 KM0o/vfdpUjpkzfZ4qKaoNfkGoNIbP45J8FJvF5/LlylkptcVcpgo8DYODRUvVeE81eFgyTMyp
 DFv7mqaY+5q2Dw0hx479qAwHFEVXPjRQafObq5gIiV77vAoH+ddUSYf5i7bp11GCpvLudAEup2
 qaM=
X-IronPort-AV: E=Sophos;i="5.79,369,1602572400"; 
   d="scan'208";a="107044714"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jan 2021 09:19:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 23 Jan 2021 09:19:56 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sat, 23 Jan 2021 09:19:54 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/4] bridge: mrp: Extend br_mrp_switchdev to detect better the errors
Date:   Sat, 23 Jan 2021 17:18:11 +0100
Message-ID: <20210123161812.1043345-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123161812.1043345-1-horatiu.vultur@microchip.com>
References: <20210123161812.1043345-1-horatiu.vultur@microchip.com>
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
  return success so the SW can continue with the protocol. Depending on
  the function it returns 0 or BR_MRP_SW.
- when code is compiled with CONFIG_NET_SWITCHDEV and the driver doesn't
  implement any MRP callbacks, then the HW can't run MRP so it just
  returns -EOPNOTSUPP. So the SW will stop further to configure the
  node.
- when code is compiled with CONFIG_NET_SWITCHDEV and the driver fully
  supports any MRP functionality then the SW doesn't need to do
  anything.  The functions will return 0 or BR_MRP_HW.
- when code is compiled with CONFIG_NET_SWITCHDEV and the HW can't run
  completely the protocol but it can help the SW to run it.  For
  example, the HW can't support completely MRM role(can't detect when it
  stops receiving MRP Test frames) but it can redirect these frames to
  CPU. In this case it is possible to have a SW fallback. The SW will
  try initially to call the driver with sw_backup set to false, meaning
  that the HW can implement completely the role. If the driver returns
  -EOPNOTSUPP, the SW will try again with sw_backup set to false,
  meaning that the SW will detect when it stops receiving the frames. In
  case the driver returns 0 then the SW will continue to configure the
  node accordingly.

In this way is more clear when the SW needs to stop configuring the
node, or when the SW is used as a backup or the HW can implement the
functionality.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp_switchdev.c | 189 +++++++++++++++++++++++++---------
 net/bridge/br_private_mrp.h   |  24 +++--
 2 files changed, 152 insertions(+), 61 deletions(-)

diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
index ed547e03ace1..e93a84532a4e 100644
--- a/net/bridge/br_mrp_switchdev.c
+++ b/net/bridge/br_mrp_switchdev.c
@@ -14,14 +14,12 @@ int br_mrp_switchdev_add(struct net_bridge *br, struct br_mrp *mrp)
 		.ring_id = mrp->ring_id,
 		.prio = mrp->prio,
 	};
-	int err;
-
-	err = switchdev_port_obj_add(br->dev, &mrp_obj.obj, NULL);
 
-	if (err && err != -EOPNOTSUPP)
-		return err;
+	/* If switchdev is not enabled then just run in SW */
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	return 0;
+	return switchdev_port_obj_add(br->dev, &mrp_obj.obj, NULL);
 }
 
 int br_mrp_switchdev_del(struct net_bridge *br, struct br_mrp *mrp)
@@ -33,40 +31,69 @@ int br_mrp_switchdev_del(struct net_bridge *br, struct br_mrp *mrp)
 		.s_port = NULL,
 		.ring_id = mrp->ring_id,
 	};
-	int err;
 
-	err = switchdev_port_obj_del(br->dev, &mrp_obj.obj);
+	/* If switchdev is not enabled then just run in SW */
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
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
 	int err;
 
+	/* If switchdev is not enabled then just run in SW */
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return BR_MRP_SW;
+
+	/* First try to see if HW can implement comptletly the role in HW */
 	if (role == BR_MRP_RING_ROLE_DISABLED)
 		err = switchdev_port_obj_del(br->dev, &mrp_role.obj);
 	else
 		err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
 
-	return err;
+	/* In case of success then just return and notify the SW that doesn't
+	 * need to do anything
+	 */
+	if (!err)
+		return BR_MRP_HW;
+
+	/* There was some issue then is not possible at all to have this role so
+	 * just return failire
+	 */
+	if (err != -EOPNOTSUPP)
+		return BR_MRP_NONE;
+
+	/* In case the HW can't run complety in HW the protocol, we try again
+	 * and this time to allow the SW to help, but the HW needs to redirect
+	 * the frames to CPU.
+	 */
+	mrp_role.sw_backup = true;
+	err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
+
+	/* In case of success then notify the SW that it needs to help with the
+	 * protocol
+	 */
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
@@ -79,12 +106,29 @@ int br_mrp_switchdev_send_ring_test(struct net_bridge *br,
 	};
 	int err;
 
+	/* If switchdev is not enabled then just run in SW */
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return BR_MRP_SW;
+
 	if (interval == 0)
 		err = switchdev_port_obj_del(br->dev, &test.obj);
 	else
 		err = switchdev_port_obj_add(br->dev, &test.obj, NULL);
 
-	return err;
+	/* If everything succeed then the HW can send this frames, so the SW
+	 * doesn't need to generate them
+	 */
+	if (!err)
+		return BR_MRP_HW;
+
+	/* There was an error when the HW was configured so the SW return
+	 * failure
+	 */
+	if (err != -EOPNOTSUPP)
+		return BR_MRP_NONE;
+
+	/* So the HW can't generate these frames so allow the SW to do that */
+	return BR_MRP_SW;
 }
 
 int br_mrp_switchdev_set_ring_state(struct net_bridge *br,
@@ -97,19 +141,18 @@ int br_mrp_switchdev_set_ring_state(struct net_bridge *br,
 		.ring_state = state,
 		.ring_id = mrp->ring_id,
 	};
-	int err;
 
-	err = switchdev_port_obj_add(br->dev, &mrp_state.obj, NULL);
+	/* If switchdev is not enabled then just run in SW */
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
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
@@ -118,15 +161,46 @@ int br_mrp_switchdev_set_in_role(struct net_bridge *br, struct br_mrp *mrp,
 		.in_id = mrp->in_id,
 		.ring_id = mrp->ring_id,
 		.i_port = rtnl_dereference(mrp->i_port)->dev,
+		.sw_backup = false,
 	};
 	int err;
 
+	/* If switchdev is not enabled then just run in SW */
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return BR_MRP_SW;
+
+	/* First try to see if HW can implement comptletly the role in HW */
 	if (role == BR_MRP_IN_ROLE_DISABLED)
 		err = switchdev_port_obj_del(br->dev, &mrp_role.obj);
 	else
 		err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
 
-	return err;
+	/* In case of success then just return and notify the SW that doesn't
+	 * need to do anything
+	 */
+	if (!err)
+		return BR_MRP_HW;
+
+	/* There was some issue then is not possible at all to have this role so
+	 * just return failire
+	 */
+	if (err != -EOPNOTSUPP)
+		return BR_MRP_NONE;
+
+	/* In case the HW can't run complety in HW the protocol, we try again
+	 * and this time to allow the SW to help, but the HW needs to redirect
+	 * the frames to CPU.
+	 */
+	mrp_role.sw_backup = true;
+	err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
+
+	/* In case of success then notify the SW that it needs to help with the
+	 * protocol
+	 */
+	if (!err)
+		return BR_MRP_SW;
+
+	return BR_MRP_NONE;
 }
 
 int br_mrp_switchdev_set_in_state(struct net_bridge *br, struct br_mrp *mrp,
@@ -138,18 +212,17 @@ int br_mrp_switchdev_set_in_state(struct net_bridge *br, struct br_mrp *mrp,
 		.in_state = state,
 		.in_id = mrp->in_id,
 	};
-	int err;
 
-	err = switchdev_port_obj_add(br->dev, &mrp_state.obj, NULL);
+	/* If switchdev is not enabled then just run in SW */
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
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
@@ -161,12 +234,29 @@ int br_mrp_switchdev_send_in_test(struct net_bridge *br, struct br_mrp *mrp,
 	};
 	int err;
 
+	/* If switchdev is not enabled then just run in SW */
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return BR_MRP_SW;
+
 	if (interval == 0)
 		err = switchdev_port_obj_del(br->dev, &test.obj);
 	else
 		err = switchdev_port_obj_add(br->dev, &test.obj, NULL);
 
-	return err;
+	/* If everything succeed then the HW can send this frames, so the SW
+	 * doesn't need to generate them
+	 */
+	if (!err)
+		return BR_MRP_HW;
+
+	/* There was an error when the HW was configured so the SW return
+	 * failure
+	 */
+	if (err != -EOPNOTSUPP)
+		return BR_MRP_NONE;
+
+	/* So the HW can't generate these frames so allow the SW to do that */
+	return BR_MRP_SW;
 }
 
 int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
@@ -177,14 +267,12 @@ int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
 		.id = SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
 		.u.mrp_port_state = state,
 	};
-	int err;
 
-	err = switchdev_port_attr_set(p->dev, &attr);
-	if (err && err != -EOPNOTSUPP)
-		br_warn(p->br, "error setting offload MRP state on port %u(%s)\n",
-			(unsigned int)p->port_no, p->dev->name);
+	/* If switchdev is not enabled then just run in SW */
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
+		return 0;
 
-	return err;
+	return switchdev_port_attr_set(p->dev, &attr);
 }
 
 int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
@@ -195,11 +283,10 @@ int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
 		.id = SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
 		.u.mrp_port_role = role,
 	};
-	int err;
 
-	err = switchdev_port_attr_set(p->dev, &attr);
-	if (err && err != -EOPNOTSUPP)
-		return err;
+	/* If switchdev is not enabled then just run in SW */
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

