Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6401B0F97
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbgDTPMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:12:01 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:38961 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730150AbgDTPL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587395516; x=1618931516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=GpF87DMmjMQqOQvV6RirKDpXW1f6XePfO9TzwePvn0U=;
  b=J/HpIaZD+0KU4UQWk0SybbkHE+CJqA4vsxuwV3y/D2sKkFyYcH4IoYhs
   FWPtRHKpgE6HgDDWSUE+idfWWnKuWZ1KwCmBG3fkZduwTztDSGqqsHsYy
   aTIPdMDwbbwnIlwpEQDHxt7oXzNXlkirZFQe/A+D4LIndCK98wwO13ZSB
   3KUOtLLJJuITVOihfueufeUvVhk30r0uYb/htHEiUvDyQ93Hq9mPRo1hp
   IisHN0vq0hyWVjs2G313wAihvmRBuurBgm4tfay78/19CFfRYqAPf7cJO
   IQM3kYAy4Cz0C4Z4YESOiKpN6f3do4TPc/Mhvg0u0aaepovG27XnyPDnB
   g==;
IronPort-SDR: LFU7JHjZEhpBl96W8mQ3xYf0itzE6ifdrEfrguN7CVpoJRsuW6SMYcYcI1jgDze6D8LqWk0jIe
 HYKFiDqGZ62fZUL1BURcIcSzu8ulnqIRli6jaqDiKzguDPVzJzL7oPHTgiatVvFEtyr1HvtU9R
 c3ty6R5pAryZbhxX7oXSvZxsAYswTNtWpPxIyS0TVIleCJ+YoTUNNIEqRletWjAhIb+UO5Tsrn
 fqhtSH06/Z5kVOIMPoDRQkHPIVkUjD7BQOwr1ngA10ne3NzTV1Gp98WyaXOk3FVzMAlzTmRfkT
 66Q=
X-IronPort-AV: E=Sophos;i="5.72,406,1580799600"; 
   d="scan'208";a="72755077"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2020 08:11:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Apr 2020 08:11:55 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 20 Apr 2020 08:11:24 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 05/13] bridge: mrp: Add MRP interface.
Date:   Mon, 20 Apr 2020 17:09:39 +0200
Message-ID: <20200420150947.30974-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420150947.30974-1-horatiu.vultur@microchip.com>
References: <20200420150947.30974-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the MRP interface.
This interface is used by the netlink to update the MRP instances and by the MRP
to make the calls to switchdev to offload it to HW.

It defines an MRP instance 'struct br_mrp' which is a list of MRP instances.
Which will be part of the 'struct net_bridge'. Each instance has 2 ring ports,
a bridge and an ID.

In case the HW can't generate MRP Test frames then the SW will generate those.

br_mrp_add - adds a new MRP instance.

br_mrp_del - deletes an existing MRP instance. Each instance has an ID(ring_id).

br_mrp_set_port_state - changes the port state. The port can be in forwarding
  state, which means that the frames can pass through or in blocked state which
  means that the frames can't pass through except MRP frames. This will
  eventually call the switchdev API to notify the HW. This information is used
  also by the SW bridge to know how to forward frames in case the HW doesn't
  have this capability.

br_mrp_set_port_role - a port role can be primary or secondary. This
  information is required to be pushed to HW in case the HW can generate
  MRP_Test frames.  Because the MRP_Test frames contains a file with this
  information. Otherwise the HW will not be able to generate the frames
  correctly.

br_mrp_set_ring_state - a ring can be in state open or closed. State open means
  that the mrp port stopped receiving MRP_Test frames, while closed means that
  the mrp port received MRP_Test frames. Similar with br_mrp_port_role, this
  information is pushed in HW because the MRP_Test frames contain this
  information.

br_mrp_set_ring_role - a ring can have the following roles MRM or MRC. For the
  role MRM it is expected that the HW can terminate the MRP frames, notify the
  SW that it stopped receiving MRP_Test frames and trapp all the other MRP
  frames.  While for MRC mode it is expected that the HW can forward the MRP
  frames only between the MRP ports and copy MRP_Topology frames to CPU. In
  case the HW doesn't support a role it needs to return an error code different
  than -EOPNOTSUPP.

br_mrp_start_test - this starts/stops the generation of MRP_Test frames. To stop
  the generation of frames the interval needs to have a value of 0. In this case
  the userspace needs to know if the HW supports this or not. Not to have
  duplicate frames(generated by HW and SW). Because if the HW supports this then
  the SW will not generate anymore frames and will expect that the HW will
  notify when it stopped receiving MRP frames using the function
  br_mrp_port_open.

br_mrp_port_open - this function is used by drivers to notify the userspace via
  a netlink callback that one of the ports stopped receiving MRP_Test frames.
  This function is called only when the node has the role MRM. It is not
  supposed to be called from userspace.

br_mrp_port_switchdev_add - this corresponds to the function br_mrp_add,
  and will notify the HW that a MRP instance is added. The function gets
  as parameter the MRP instance.

br_mrp_port_switchdev_del - this corresponds to the function br_mrp_del,
  and will notify the HW that a MRP instance is removed. The function
  gets as parameter the ID of the MRP instance that is removed.

br_mrp_port_switchdev_set_state - this corresponds to the function
  br_mrp_set_port_state. It would notify the HW if it should block or not
  non-MRP frames.

br_mrp_port_switchdev_set_port - this corresponds to the function
  br_mrp_set_port_role. It would set the port role, primary or secondary.

br_mrp_switchdev_set_role - this corresponds to the function
  br_mrp_set_ring_role and would set one of the role MRM or MRC.

br_mrp_switchdev_set_ring_state - this corresponds to the function
  br_mrp_set_ring_state and would set the ring to be open or closed.

br_mrp_switchdev_send_ring_test - this corresponds to the function
  br_mrp_start_test. This will notify the HW to start or stop generating
  MRP_Test frames. Value 0 for the interval parameter means to stop generating
  the frames.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_private_mrp.h | 60 +++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100644 net/bridge/br_private_mrp.h

diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
new file mode 100644
index 000000000000..5af8d13cce2b
--- /dev/null
+++ b/net/bridge/br_private_mrp.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _BR_PRIVATE_MRP_H_
+#define _BR_PRIVATE_MRP_H_
+
+#include "br_private.h"
+#include <uapi/linux/mrp_bridge.h>
+
+struct br_mrp {
+	/* list of mrp instances */
+	struct list_head		__rcu list;
+
+	struct net_bridge_port __rcu	*p_port;
+	struct net_bridge_port __rcu	*s_port;
+
+	u32				ring_id;
+
+	enum br_mrp_ring_role_type	ring_role;
+	u8				ring_role_offloaded;
+	enum br_mrp_ring_state_type	ring_state;
+	u32				ring_transitions;
+
+	struct delayed_work		test_work;
+	u32				test_interval;
+	unsigned long			test_end;
+	u32				test_count_miss;
+	u32				test_max_miss;
+
+	u32				seq_id;
+
+	struct rcu_head			rcu;
+};
+
+/* br_mrp.c */
+int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance);
+int br_mrp_del(struct net_bridge *br, struct br_mrp_instance *instance);
+int br_mrp_set_port_state(struct net_bridge_port *p,
+			  enum br_mrp_port_state_type state);
+int br_mrp_set_port_role(struct net_bridge_port *p,
+			 struct br_mrp_port_role *role);
+int br_mrp_set_ring_state(struct net_bridge *br,
+			  struct br_mrp_ring_state *state);
+int br_mrp_set_ring_role(struct net_bridge *br, struct br_mrp_ring_role *role);
+int br_mrp_start_test(struct net_bridge *br, struct br_mrp_start_test *test);
+
+/* br_mrp_switchdev.c */
+int br_mrp_switchdev_add(struct net_bridge *br, struct br_mrp *mrp);
+int br_mrp_switchdev_del(struct net_bridge *br, struct br_mrp *mrp);
+int br_mrp_switchdev_set_ring_role(struct net_bridge *br, struct br_mrp *mrp,
+				   enum br_mrp_ring_role_type role);
+int br_mrp_switchdev_set_ring_state(struct net_bridge *br, struct br_mrp *mrp,
+				    enum br_mrp_ring_state_type state);
+int br_mrp_switchdev_send_ring_test(struct net_bridge *br, struct br_mrp *mrp,
+				    u32 interval, u8 max_miss, u32 period);
+int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
+				    enum br_mrp_port_state_type state);
+int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
+				   enum br_mrp_port_role_type role);
+
+#endif /* _BR_PRIVATE_MRP_H */
-- 
2.17.1

