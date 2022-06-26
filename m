Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB5F55B21E
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 15:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbiFZNCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 09:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234520AbiFZNBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 09:01:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0F811A02;
        Sun, 26 Jun 2022 06:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656248514; x=1687784514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QJx/KSDQuzLjOJSNYWiOeeuqt+7awbeyjleOCYK2Tic=;
  b=Lv4go0qSK4ybWZzmRMLYnGq/ETnCYZLVutyf1u2Lhk2pKDDQqjgcdrVL
   OeuBwndYAb12iI1TtmEqlw8vGetf8rFUDgGmEsHpKSj2mQ199B3AjfFBi
   n5eQMJSKcvxWaV3/VctQVVRxRKftaWCNsDCHtzy1+a7fqtEXUm0i3kjK/
   u813UaycfaENtESWsj/fs4bTzTmE2oTHxs6OwJXs/Df/VyliOud4hxYUV
   Rl3AG19NagYs3NG6761jkPJkgV3cX7NxuhSNmE/i/m1XDVMhxGd2v9Z2B
   vzAbkNLpwq2oMxOLebR7nAZxUk2WC95h57ovkTjcNSTiG8xSgMQZYIJP/
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,224,1650956400"; 
   d="scan'208";a="165122628"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2022 06:01:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 26 Jun 2022 06:01:51 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 26 Jun 2022 06:01:49 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 8/8] net: lan966x: Update PGID when lag ports are changing link status
Date:   Sun, 26 Jun 2022 15:04:51 +0200
Message-ID: <20220626130451.1079933-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
References: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a port under a bond device is changing it's link status it is
required to recalculate the PGID entries. Otherwise the HW will still
try to transmit frames on the port that is down.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/lan966x_lag.c | 16 ++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h    |  3 +++
 .../ethernet/microchip/lan966x/lan966x_port.c    |  6 ++++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
index 4ce41a55737c..eec5d6912757 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
@@ -151,6 +151,22 @@ void lan966x_lag_port_leave(struct lan966x_port *port, struct net_device *bond)
 	lan966x_lag_set_aggr_pgids(lan966x);
 }
 
+void lan966x_lag_port_down(struct lan966x_port *port)
+{
+	port->bond_fix = port->bond;
+	lan966x_lag_port_leave(port, port->bond);
+}
+
+void lan966x_lag_port_up(struct lan966x_port *port)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	port->bond = port->bond_fix;
+	lan966x_lag_set_port_ids(lan966x);
+	lan966x_update_fwd_mask(lan966x);
+	lan966x_lag_set_aggr_pgids(lan966x);
+}
+
 int lan966x_lag_port_prechangeupper(struct net_device *dev,
 				    struct netdev_notifier_changeupper_info *info)
 {
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index c1f5ca5d91a4..23264e70fb8a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -293,6 +293,7 @@ struct lan966x_port {
 	struct sk_buff_head tx_skbs;
 
 	struct net_device *bond;
+	struct net_device *bond_fix;
 	bool lag_tx_active;
 };
 
@@ -420,6 +421,8 @@ int lan966x_lag_port_join(struct lan966x_port *port,
 			  struct net_device *bond,
 			  struct netlink_ext_ack *extack);
 void lan966x_lag_port_leave(struct lan966x_port *port, struct net_device *bond);
+void lan966x_lag_port_down(struct lan966x_port *port);
+void lan966x_lag_port_up(struct lan966x_port *port);
 int lan966x_lag_port_prechangeupper(struct net_device *dev,
 				    struct netdev_notifier_changeupper_info *info);
 int lan966x_lag_port_changelowerstate(struct net_device *dev,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index f141644e4372..e99478a443cb 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -274,11 +274,17 @@ static void lan966x_port_link_up(struct lan966x_port *port)
 void lan966x_port_config_down(struct lan966x_port *port)
 {
 	lan966x_port_link_down(port);
+
+	if (port->bond)
+		lan966x_lag_port_down(port);
 }
 
 void lan966x_port_config_up(struct lan966x_port *port)
 {
 	lan966x_port_link_up(port);
+
+	if (port->bond_fix)
+		lan966x_lag_port_up(port);
 }
 
 void lan966x_port_status_get(struct lan966x_port *port,
-- 
2.33.0

