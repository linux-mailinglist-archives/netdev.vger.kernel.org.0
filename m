Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5365C6386A2
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiKYJtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiKYJsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:48:06 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2EF3FB96;
        Fri, 25 Nov 2022 01:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669369585; x=1700905585;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yOv7Fb89iAFPzocbXuazrmMYErxRE5EPQPrRQ5bHq8A=;
  b=mmui6yFBzefr3yspdl4XnFD6HlXUk3pQUvt8rtSD+XJ+W/bAImDTFdsn
   StT6TZMmH7pAPMDF4QZJ+OWN1aAJ3g3+iGvVBmebWSXJNSNXyT0Z8BXMU
   No1ooDPGB95dQFBW8F7oYmDX++Pvem/esTh0O/+yCH2z5WHgLeUTSfslb
   p1cln7z2fqsbIGzH1SCJil+qXcmo/aBYhAEa+GZNq2MtIM6PESeEYGSGt
   1ovYYl9IURxy8cv3PqgTpzNQ52R8uC0+dkn6NSwHLjPwU1zbZMALSUUKY
   xbCmJqeIVsWeHhMqcJwBYcykx5O50a/H8LE85MctVPdRy5vpHQ4BtXXZr
   A==;
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="125075015"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 02:46:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 02:46:24 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 25 Nov 2022 02:46:22 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 7/9] net: lan966x: add tc matchall goto action
Date:   Fri, 25 Nov 2022 10:50:08 +0100
Message-ID: <20221125095010.124458-8-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221125095010.124458-1-horatiu.vultur@microchip.com>
References: <20221125095010.124458-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend matchall with action goto. This is needed to enable the lookup in
the VCAP. It is needed to connect chain 0 to a chain that is recognized
by the HW.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |  2 +-
 .../ethernet/microchip/lan966x/lan966x_goto.c | 54 +++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |  9 ++++
 .../microchip/lan966x/lan966x_tc_matchall.c   |  6 +++
 4 files changed, 70 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_goto.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 23781149f7a9b..56afd694f3c78 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -13,7 +13,7 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_tbf.o lan966x_cbs.o lan966x_ets.o \
 			lan966x_tc_matchall.o lan966x_police.o lan966x_mirror.o \
 			lan966x_xdp.o lan966x_vcap_impl.o lan966x_vcap_ag_api.o \
-			lan966x_tc_flower.o
+			lan966x_tc_flower.o lan966x_goto.o
 
 # Provide include files
 ccflags-y += -I$(srctree)/drivers/net/ethernet/microchip/vcap
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_goto.c b/drivers/net/ethernet/microchip/lan966x/lan966x_goto.c
new file mode 100644
index 0000000000000..bf0cfe24a8fc0
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_goto.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+#include "vcap_api_client.h"
+
+int lan966x_goto_port_add(struct lan966x_port *port,
+			  struct flow_action_entry *act,
+			  unsigned long goto_id,
+			  struct netlink_ext_ack *extack)
+{
+	struct lan966x *lan966x = port->lan966x;
+	int err;
+
+	err = vcap_enable_lookups(lan966x->vcap_ctrl, port->dev,
+				  act->chain_index, goto_id,
+				  true);
+	if (err == -EFAULT) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported goto chain");
+		return -EOPNOTSUPP;
+	}
+
+	if (err == -EADDRINUSE) {
+		NL_SET_ERR_MSG_MOD(extack, "VCAP already enabled");
+		return -EOPNOTSUPP;
+	}
+
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Could not enable VCAP lookups");
+		return err;
+	}
+
+	port->tc.goto_id = goto_id;
+
+	return 0;
+}
+
+int lan966x_goto_port_del(struct lan966x_port *port,
+			  unsigned long goto_id,
+			  struct netlink_ext_ack *extack)
+{
+	struct lan966x *lan966x = port->lan966x;
+	int err;
+
+	err = vcap_enable_lookups(lan966x->vcap_ctrl, port->dev, 0,
+				  goto_id, false);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Could not disable VCAP lookups");
+		return err;
+	}
+
+	port->tc.goto_id = 0;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 0820b96b75ab1..b9993ff2aa22f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -310,6 +310,7 @@ struct lan966x_port_tc {
 	unsigned long police_id;
 	unsigned long ingress_mirror_id;
 	unsigned long egress_mirror_id;
+	unsigned long goto_id;
 	struct flow_stats police_stat;
 	struct flow_stats mirror_stat;
 };
@@ -569,6 +570,14 @@ void lan966x_vcap_deinit(struct lan966x *lan966x);
 int lan966x_tc_flower(struct lan966x_port *port,
 		      struct flow_cls_offload *f);
 
+int lan966x_goto_port_add(struct lan966x_port *port,
+			  struct flow_action_entry *act,
+			  unsigned long goto_id,
+			  struct netlink_ext_ack *extack);
+int lan966x_goto_port_del(struct lan966x_port *port,
+			  unsigned long goto_id,
+			  struct netlink_ext_ack *extack);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c
index 7368433b9277a..a539abaad9b67 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c
@@ -23,6 +23,9 @@ static int lan966x_tc_matchall_add(struct lan966x_port *port,
 	case FLOW_ACTION_MIRRED:
 		return lan966x_mirror_port_add(port, act, f->cookie,
 					       ingress, f->common.extack);
+	case FLOW_ACTION_GOTO:
+		return lan966x_goto_port_add(port, act, f->cookie,
+					     f->common.extack);
 	default:
 		NL_SET_ERR_MSG_MOD(f->common.extack,
 				   "Unsupported action");
@@ -43,6 +46,9 @@ static int lan966x_tc_matchall_del(struct lan966x_port *port,
 		   f->cookie == port->tc.egress_mirror_id) {
 		return lan966x_mirror_port_del(port, ingress,
 					       f->common.extack);
+	} else if (f->cookie == port->tc.goto_id) {
+		return lan966x_goto_port_del(port, f->cookie,
+					     f->common.extack);
 	} else {
 		NL_SET_ERR_MSG_MOD(f->common.extack,
 				   "Unsupported action");
-- 
2.38.0

