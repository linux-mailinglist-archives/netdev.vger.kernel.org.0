Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A3621EA41
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGNHjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:39:07 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:43769 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgGNHjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 03:39:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594712345; x=1626248345;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uci+63N0XBlAvV0QBr++Adpov2aPMsyTOj+m1Y0wXT8=;
  b=aApFQHRajXwTfwbxBPB0/6TYDaqQNZcSfT9FklFgWefM7YC2+9lQmDIq
   Dmz9nVLSM/s/LstslZzomdvyMdoacovXZDKkBuyTLUsj4VVj3910+rU8u
   KdlIRhiXTf4GhtXlOprPQWoyVRnst0eTB/tnmFyVUwRoSgqJOhVKuHVqV
   x4HS3TNcLvsn6hEV5McqF2Kwv34e7a1W2sTTatJ5dR30yy7NQkTuKq4Oj
   cR00F+Xm89S9Fl/G6SLMnXPt+vO4j5pva37PVQCBlb4X+BnMo0W+gVb7D
   z12whGCvQLelh+9GRI4UZgBQcK7cwdmxhN62Z+l6iiflugPVMLJkgidJk
   Q==;
IronPort-SDR: aJAh2IEIHMHom+yEkfQYLnJZwAOY1JglLCzuwr5jWGDFCpzk9OiHDqgLgWqdPHW2HE7aBQhVQm
 juj+ZmLEfzVGbuwYg+Rdh8sXSpoEpuIzquhGfGQKyH50Ps+t/xCrfpqwW/Sj2zCsXbd5oq8eod
 6qHKcT0Lour7PgftjnstW7kSH0GPYgPGX+vNpS7LcvPFI0I6qOo5RDS1kFQXzhAR5fDz3xFG9L
 yeWng3CUgikvlsS5Mwl11xsqb9x1Zn5VTddOjea8QMEYCVKPWR8AXGFkgYnMcuU7RjcVEGGlYh
 hkk=
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="19099945"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2020 00:39:03 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 14 Jul 2020 00:39:03 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 14 Jul 2020 00:39:01 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 01/12] switchdev: mrp: Extend switchdev API for MRP Interconnect
Date:   Tue, 14 Jul 2020 09:34:47 +0200
Message-ID: <20200714073458.1939574-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend switchdev API to add support for MRP interconnect. The HW is
notified in the following cases:

SWITCHDEV_OBJ_ID_IN_ROLE_MRP: This is used when the interconnect role
  of the node changes. The supported roles are MIM and MIC.

SWITCHDEV_OBJ_ID_IN_STATE_MRP: This is used when the interconnect ring
  changes it states to open or closed.

SWITCHDEV_OBJ_ID_IN_TEST_MRP: This is used to start/stop sending
  MRP_InTest frames on all MRP ports. This is called only on nodes that
  have the interconnect role MIM.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/net/switchdev.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index b8c059b4e06d9..ff22469143013 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -76,6 +76,10 @@ enum switchdev_obj_id {
 	SWITCHDEV_OBJ_ID_RING_TEST_MRP,
 	SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
 	SWITCHDEV_OBJ_ID_RING_STATE_MRP,
+	SWITCHDEV_OBJ_ID_IN_TEST_MRP,
+	SWITCHDEV_OBJ_ID_IN_ROLE_MRP,
+	SWITCHDEV_OBJ_ID_IN_STATE_MRP,
+
 #endif
 };
 
@@ -155,6 +159,40 @@ struct switchdev_obj_ring_state_mrp {
 #define SWITCHDEV_OBJ_RING_STATE_MRP(OBJ) \
 	container_of((OBJ), struct switchdev_obj_ring_state_mrp, obj)
 
+/* SWITCHDEV_OBJ_ID_IN_TEST_MRP */
+struct switchdev_obj_in_test_mrp {
+	struct switchdev_obj obj;
+	/* The value is in us and a value of 0 represents to stop */
+	u32 interval;
+	u32 in_id;
+	u32 period;
+	u8 max_miss;
+};
+
+#define SWITCHDEV_OBJ_IN_TEST_MRP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_in_test_mrp, obj)
+
+/* SWICHDEV_OBJ_ID_IN_ROLE_MRP */
+struct switchdev_obj_in_role_mrp {
+	struct switchdev_obj obj;
+	struct net_device *i_port;
+	u32 ring_id;
+	u16 in_id;
+	u8 in_role;
+};
+
+#define SWITCHDEV_OBJ_IN_ROLE_MRP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_in_role_mrp, obj)
+
+struct switchdev_obj_in_state_mrp {
+	struct switchdev_obj obj;
+	u32 in_id;
+	u8 in_state;
+};
+
+#define SWITCHDEV_OBJ_IN_STATE_MRP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_in_state_mrp, obj)
+
 #endif
 
 typedef int switchdev_obj_dump_cb_t(struct switchdev_obj *obj);
-- 
2.27.0

