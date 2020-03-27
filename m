Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1656A1953D6
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgC0JWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:22:41 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12855 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0JWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:22:35 -0400
IronPort-SDR: N7N1SRydu0lwOLqUrQVTjNhAXJOTn1K7CJLfHiOUUHUC7jKAYu/76L5qrlFwAGKLfV5/c6+Fdw
 94HBgsEJuAtJ0Zj2yO9GC5eSnnvVYmGydSiB6lijWr5mOoFCsgzMpK/6b9D6DVgJH7CiKhBffx
 rDsqSrfiWO6os15epSqyuzEWYbz3hojcL0MbFDusLB3SJHXgcz05sFQpNwuYmKTmVhWfKMxvsb
 2kkRnAYiXrZ3zAOi7IcOZCuPf48BUfoSkD39FNbo2+ypqwgEnZYIZauD/+0OWYB8olwsZ5iEGQ
 0kI=
X-IronPort-AV: E=Sophos;i="5.72,311,1580799600"; 
   d="scan'208";a="73728117"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Mar 2020 02:22:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 27 Mar 2020 02:22:34 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 27 Mar 2020 02:22:32 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <nikolay@cumulusnetworks.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v4 6/9] bridge: switchdev: mrp Implement MRP API for switchdev
Date:   Fri, 27 Mar 2020 10:21:23 +0100
Message-ID: <20200327092126.15407-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327092126.15407-1-horatiu.vultur@microchip.com>
References: <20200327092126.15407-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the MRP api for switchdev.
These functions will just eventually call the switchdev functions:
switchdev_port_obj_add/del and switchdev_port_attr_set.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp_switchdev.c | 150 ++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)
 create mode 100644 net/bridge/br_mrp_switchdev.c

diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
new file mode 100644
index 000000000000..7b27721fd4cf
--- /dev/null
+++ b/net/bridge/br_mrp_switchdev.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <net/switchdev.h>
+
+#include "br_private_mrp.h"
+
+int br_mrp_switchdev_add(struct br_mrp *mrp)
+{
+	struct net_bridge *br = mrp->br;
+	struct switchdev_obj_mrp mrp_obj = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_MRP,
+		.p_port = rcu_dereference(mrp->p_port)->dev,
+		.s_port = rcu_dereference(mrp->s_port)->dev,
+		.ring_id = mrp->ring_id,
+	};
+	int err = 0;
+
+	err = switchdev_port_obj_add(br->dev, &mrp_obj.obj, NULL);
+
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_del(struct br_mrp *mrp)
+{
+	struct net_bridge *br = mrp->br;
+	struct switchdev_obj_mrp mrp_obj = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_MRP,
+		.p_port = rcu_dereference(mrp->p_port)->dev,
+		.s_port = rcu_dereference(mrp->s_port)->dev,
+		.ring_id = mrp->ring_id,
+	};
+	int err = 0;
+
+	err = switchdev_port_obj_del(br->dev, &mrp_obj.obj);
+
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_set_ring_role(struct br_mrp *mrp,
+				   enum br_mrp_ring_role_type role)
+{
+	struct switchdev_obj_ring_role_mrp mrp_role = {
+		.obj.orig_dev = mrp->br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
+		.ring_role = role,
+		.ring_id = mrp->ring_id,
+	};
+	int err = 0;
+
+	if (role == BR_MRP_RING_ROLE_DISABLED)
+		err = switchdev_port_obj_del(mrp->br->dev, &mrp_role.obj);
+	else
+		err = switchdev_port_obj_add(mrp->br->dev, &mrp_role.obj, NULL);
+
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_send_ring_test(struct br_mrp *mrp, u32 interval,
+				    u8 max_miss, u32 period)
+{
+	struct switchdev_obj_ring_test_mrp test = {
+		.obj.orig_dev = mrp->br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_RING_TEST_MRP,
+		.interval = interval,
+		.max_miss = max_miss,
+		.ring_id = mrp->ring_id,
+		.period = period,
+	};
+	int err = 0;
+
+	if (interval == 0)
+		err = switchdev_port_obj_del(mrp->br->dev, &test.obj);
+	else
+		err = switchdev_port_obj_add(mrp->br->dev, &test.obj, NULL);
+
+	return err;
+}
+
+int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
+				    enum br_mrp_port_state_type state)
+{
+	struct switchdev_attr attr = {
+		.orig_dev = p->dev,
+		.id = SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
+		.u.mrp_port_state = state,
+	};
+	int err = 0;
+
+	err = switchdev_port_attr_set(p->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		br_warn(p->br, "error setting offload MRP state on port %u(%s)\n",
+			(unsigned int)p->port_no, p->dev->name);
+
+	return err;
+}
+
+int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
+				   enum br_mrp_port_role_type role)
+{
+	struct switchdev_attr attr = {
+		.orig_dev = p->dev,
+		.id = SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
+		.u.mrp_port_role = role,
+	};
+	int err;
+
+	err = switchdev_port_attr_set(p->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_set_ring_state(struct br_mrp *mrp,
+				    enum br_mrp_ring_state_type state)
+{
+	struct switchdev_attr attr = {
+		.id = SWITCHDEV_ATTR_ID_MRP_RING_STATE,
+		.u.mrp_ring_state = state,
+	};
+	int err = 0;
+
+	rcu_read_lock();
+
+	attr.orig_dev = rcu_dereference(mrp->p_port)->dev,
+	err = switchdev_port_attr_set(attr.orig_dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		goto unlock;
+
+	attr.orig_dev = rcu_dereference(mrp->s_port)->dev;
+	err = switchdev_port_attr_set(attr.orig_dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		goto unlock;
+
+unlock:
+	rcu_read_unlock();
+
+	return err;
+}
-- 
2.17.1

