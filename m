Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F5B148BD5
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 17:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389844AbgAXQTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 11:19:40 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:25554 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389808AbgAXQTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 11:19:39 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: TUV9C+7aHq/J9FkjrB1IdtwB6zq4L9m9K6jayedywNDREKeHgfP0T30fANsvFKGIL2g1rvMzGe
 yFNfyNgfjUkrJKt9bYaWviY82GGSoc5+TKMpkSivRaTWi+Xn0QAzMcSv64/3CAH8C5konfYIwh
 n0Bel/b6BoOoOIWi1B44lxkUvkGMHBJ2Rc7C5547/4rnkTn6DPDO/3rr2ZUFaqgt/HkyMvo5Hu
 VYZzGnOVvlP+Kz+MF8XyIlOhgmSsUzzKK86I+xH1fowq78u45t7SE83skp0ZAQuERn7QDP9LEJ
 xvM=
X-IronPort-AV: E=Sophos;i="5.70,358,1574146800"; 
   d="scan'208";a="19361"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jan 2020 09:19:37 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 Jan 2020 09:19:37 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 24 Jan 2020 09:19:35 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <jeffrey.t.kirsher@intel.com>,
        <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v3 03/10] net: bridge: mrp: Add MRP interface used by netlink
Date:   Fri, 24 Jan 2020 17:18:21 +0100
Message-ID: <20200124161828.12206-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200124161828.12206-1-horatiu.vultur@microchip.com>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the MRP interface that will be used by the generic netlink to offload the
calls to the HW.

For this it is required for the kernel to hold in a list all the MRP instances
that are created and all the ports that are part of the MRP rings. Therefore add
the structure 'br_mrp'. This contains the following:
- a list with all MRP instances
- pointer to the net bridge on which the MRP instance is attach to
- pointers to the net bridge ports, which represents the ring ports
- a ring nr which represents the ID of the ring.

The interface has the following functions:

br_mrp_add - it creates a br_mrp instances and adds it to the list of mrp
  instances.
br_mrp_del - it removes a br_mrp instances from the list based on the ring nr of
  the instance.
These functions are used just by the SW to know which rings and which ports are
to which ring. These function will not call eventually the switchdev API. If
there is a HW required to know about these calls then the switchdev API can be
extended.

br_mrp_add_port - adds a port to a MRP instance. This will eventually call the
  switchdev API to notify the HW that the port is part of a ring so it needs to
  process or forward MRP frames on the other port.
br_mrp_del_port - deletes a port from a MRP instance. This will eventually call
  switchdev API to notify the HW that the port is not part of a ring anymore. So
  it would not need to do special processing to MRP frames
Whenever a port is added to the MRP instance, the also the SW needs to know this
information in case the HW can't support MRP. This information is required when
the SW bridge receives MRP frames. Because in case a frame arrived on an MRP
port the SW bridge should not forward the frame.

br_mrp_port_state - changes the port state. The port can be in forwarding state,
  which means that the frames can pass through or in blocked state which means
  that the frames can't pass through except MRP frames. This will eventually
  call the switchdev API to notify the HW. This information is used also by the
  SW bridge to know how to forward frames in case the HW doesn't have this
  capability.

br_mrp_port_role - a port role can be primary or secondary. This information is
  required to be pushed to HW in case the HW can generate MRP_Test frames.
  Because the MRP_Test frames contains a file with this information. Otherwise
  the HW will not be able to generate the frames correctly.

br_mrp_ring_state - a ring can be in state open or closed. State open means that
  the mrp port stopped receiving MRP_Test frames, while closed means that the
  mrp port received MRP_Test frames. Similar with br_mrp_port_role, this
  information is pushed in HW because the MRP_Test frames contain this
  information.

For all the previous commands the userspace doesn't need to check the return
value because it is not affected if the HW supports these or not.

br_mrp_ring_role - a ring can have the following roles MRM or MRC. For the role
  MRM it is expected that the HW can terminate the MRP frames, notify the SW
  that it stopped receiving MRP_Test frames and trapp all the other MRP frames.
  While for MRC mode it is expected that the HW can forward the MRP frames only
  between the MRP ports and copy MRP_Topology frames to CPU. In case the HW
  doesn't support a role it needs to return an error code different than
  -EOPNOTSUPP.

Because the userspace doesn't know if the kernel has HW offload capabilities
it is using the return value of the netlink calls to know if there was a problem
setting the role to the HW, or it should run the role in userspace. For example
if the node doesn't have a switchdev driver than the return code is -EOPNOTSUPP
that means that the state machine can run only in SW. If the node has switchdev
support then, if the node doesn't support the role it needs to return an error
code different than -EOPNOTSUPP. In this case the entire userspace application
will stop. If the node support the role then it returns 0.

br_mrp_start_test - this starts/stops the generation of MRP_Test frames. To stop
  the generation of frames the interval needs to have a value of 0. In this case
  the userspace needs to know if the HW supports this or not. Not to have
  duplicate frames(generated by HW and SW). Because if the HW supports this then
  the SW will not generate anymore frames and will expect that the HW will
  notify when it stopped receiving MRP frames using the function
  br_mrp_port_open.

br_mrp_flush - will flush the FDB.

br_mrp_port_open - this function is used by drivers to notify the userspace via
  a netlink callback that one of the ports stopped receiving MRP_Test frames.
  This function is called only when the node has the role MRM. It is not
  supposed to be called from userspace.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_private_mrp.h | 42 +++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100644 net/bridge/br_private_mrp.h

diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
new file mode 100644
index 000000000000..bea4ece4411c
--- /dev/null
+++ b/net/bridge/br_private_mrp.h
@@ -0,0 +1,42 @@
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
+	struct list_head		list;
+
+	struct net_bridge		*br;
+	struct net_bridge_port		*p_port;
+	struct net_bridge_port		*s_port;
+
+	u32				ring_nr;
+};
+
+/* br_mrp.c */
+int br_mrp_add(struct net_bridge *br, u32 ring_nr);
+int br_mrp_add_port(struct net_bridge *br, u32 ring_nr,
+		    struct net_bridge_port *p);
+int br_mrp_del(struct net_bridge *br, u32 ring_nr);
+int br_mrp_del_port(struct net_bridge_port *p);
+int br_mrp_set_port_state(struct net_bridge_port *p,
+			  enum br_mrp_port_state_type state);
+int br_mrp_set_port_role(struct net_bridge_port *p, u32 ring_nr,
+			 enum br_mrp_port_role_type role);
+int br_mrp_set_ring_state(struct net_bridge *br, u32 ring_nr,
+			  enum br_mrp_ring_state_type state);
+int br_mrp_set_ring_role(struct net_bridge *br, u32 ring_nr,
+			 enum br_mrp_ring_role_type role);
+int br_mrp_start_test(struct net_bridge *br, u32 ring_nr, u32 interval,
+		      u8 max_miss);
+int br_mrp_flush(struct net_bridge *br, u32 ring_nr);
+
+/* br_mrp_netlink.c */
+void br_mrp_port_open(struct net_device *dev, u8 loc);
+
+#endif /* _BR_PRIVATE_MRP_H */
+
-- 
2.17.1

