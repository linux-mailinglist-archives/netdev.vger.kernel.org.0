Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909B81953C4
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgC0JWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:22:25 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12817 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgC0JWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:22:24 -0400
IronPort-SDR: Mq/A5tIisC4TtH8E4ZGyp345BsbtZ9ddSS98Cc2d4R2svlY4jHCStmu4ASV074zQIhq5bF8gc+
 QSTPn9cM24q1+9C5GmWyRitwAsUhPs54CwjGJ0Zy/xZtH/E1zgkWQbLdAMPQoxL+pvWHV2ARSD
 B4dt5cjNnT/x1NY2ZxYjAX3smcOW8YrIFlexaLjG6c5+t3TtN57ftCTjI/3nFsIIjnwHMWmvHv
 uapu3Qt5R1fCNPW35/PFSy79QEma9csndeV0XJriGmEF/nePcMoGKc0H14EZ+HbaGdXK5s9tb+
 HWg=
X-IronPort-AV: E=Sophos;i="5.72,311,1580799600"; 
   d="scan'208";a="73728108"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Mar 2020 02:22:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 27 Mar 2020 02:22:23 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 27 Mar 2020 02:22:21 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <nikolay@cumulusnetworks.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v4 2/9] bridge: mrp: Expose function br_mrp_port_open
Date:   Fri, 27 Mar 2020 10:21:19 +0100
Message-ID: <20200327092126.15407-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327092126.15407-1-horatiu.vultur@microchip.com>
References: <20200327092126.15407-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the HW is capable to detect when the MRP ring is open or closed. It is
expected that the network driver will notify the SW that the ring is open or
closed.

The function br_mrp_port_open is used to notify the kernel that one of the ports
stopped receiving MRP_Test frames. The argument 'loc' has a value of '1' when
the port stopped receiving MRP_Test and '0' when it started to receive MRP_Test.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/linux/mrp_bridge.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 include/linux/mrp_bridge.h

diff --git a/include/linux/mrp_bridge.h b/include/linux/mrp_bridge.h
new file mode 100644
index 000000000000..45448853e705
--- /dev/null
+++ b/include/linux/mrp_bridge.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _LINUX_MRP_BRIDGE_H
+#define _LINUX_MRO_BRIDGE_H
+
+#include <linux/netdevice.h>
+
+/* The drivers are responsible to call this function when it detects that the
+ * MRP port stopped receiving MRP_Test frames or it started to receive MRP_Test.
+ * The argument dev represents the port and loc(Lost of Continuity) has a value
+ * of 1 when it stopped receiving MRP_Test frames and a value of 0 when it
+ * started to receive frames.
+ *
+ * This eventually notify the userspace which is required to react on these
+ * changes.
+ */
+
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+void br_mrp_port_open(struct net_device *dev, u8 loc);
+#else
+inline void br_mrp_port_open(struct net_device *dev, u8 loc)  {}
+#endif
+
+#endif
-- 
2.17.1

