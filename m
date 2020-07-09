Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6221B219CC1
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 12:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgGIKBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 06:01:46 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:3869 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgGIKBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 06:01:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594288896; x=1625824896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uci+63N0XBlAvV0QBr++Adpov2aPMsyTOj+m1Y0wXT8=;
  b=Ul6QLbcs8X85dh0gIBh+vY4KpVNSb2AieFToo/4EwvZG2lxIGzTnzOJf
   i89bHGvRPN9gaanoXZ39QpwA520qN+aSdyQJpZ7RIGWxMn2V5eqoJLZGW
   w9M57Qj4wic3CF+3m6+UIWhx48XP9B+cuz1BiJAQQIDlkWSoOoYQeujP6
   RIRxY9u6PadyDbkzrX38n4O8ZuiUzuOyTvlPMnE3EJuAQeMuyoCjvcabH
   LWY8k1rxvGl3NEZrtvE5w2rs0fcyxJq+8dC8d4qI4RJh1Up3kNmxRHoRU
   FofPJ8PcvzsIpOHzN4x0Gnb6YglfS1EkZ7r3hUY1qzNaF5kdY2d6i/voA
   Q==;
IronPort-SDR: dnqaWMqAToYVQQX9wHZ+mLdhSrjtWXnMOmBio5T0ofFrByPfpgwqhQD8M10z7K2teepBCmsBrl
 ZGxxJhOlJum5XHfoOaCdJlQ73fbyxYTIW38buXDr2ZuHfs1pyC/aDzNur373r7LhsAmPECcluY
 vz9bw75l3/hPfEi/UaaXgxQwH3TYq73n6xkZu66zwUr2FjQ1n79r1SbRhRvtZeILen1genE8mx
 llr8h4pynTbKBK2RTu2bbTWtWwRZPg8+Ks65t58h2x9OJ9Em0O3e6U1fSIQf0CImSgr+4mDVVD
 e0Y=
X-IronPort-AV: E=Sophos;i="5.75,331,1589266800"; 
   d="scan'208";a="83138399"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jul 2020 03:01:34 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 9 Jul 2020 03:01:08 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 9 Jul 2020 03:01:30 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 01/12] switchdev: mrp: Extend switchdev API for MRP Interconnect
Date:   Thu, 9 Jul 2020 12:00:29 +0200
Message-ID: <20200709100040.554623-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200709100040.554623-1-horatiu.vultur@microchip.com>
References: <20200709100040.554623-1-horatiu.vultur@microchip.com>
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

