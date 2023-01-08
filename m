Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276A8661486
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 11:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbjAHKgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 05:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbjAHKgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 05:36:05 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7177EE0C2
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 02:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673174163; x=1704710163;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4z/K6HIGmMlECX3NMbZs5X48Um0ZTGBuE68PJlxE9/k=;
  b=lAajQOipOrCDBSfenfquRMXQpA0PAQsDmeqV/tYf6Id4vt4Be3bv4xOF
   fA/acsc4KGwyGF1OhyuQ7yVkQcRnXo6A6TzEqoxhi6mcQ2OUkBMEgp720
   xXHrvoXdo+VUez77q+My1awQD1fr2oNoXMicc+6AXnFnNdhTetm3e3V+P
   o=;
X-IronPort-AV: E=Sophos;i="5.96,310,1665446400"; 
   d="scan'208";a="1090394641"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 10:35:58 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com (Postfix) with ESMTPS id AFDEF42BFC;
        Sun,  8 Jan 2023 10:35:56 +0000 (UTC)
Received: from EX19D002UWC003.ant.amazon.com (10.13.138.183) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sun, 8 Jan 2023 10:35:46 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWC003.ant.amazon.com (10.13.138.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Sun, 8 Jan 2023 10:35:46 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Sun, 8 Jan 2023 10:35:44 +0000
From:   David Arinzon <darinzon@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     David Arinzon <darinzon@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH V1 net-next 2/5] net: ena: Add devlink reload functionality
Date:   Sun, 8 Jan 2023 10:35:30 +0000
Message-ID: <20230108103533.10104-3-darinzon@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230108103533.10104-1-darinzon@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This system allows to reload most of the driver's resources.
This functionality is added to our driver to apply configurations which
require a reset (such as changing LLQ entry size).

For the implementation of reload functionality, the driver performs
the same sequence that device reset performs with a few exceptions:
  - The reset occurs immediately rather than setting a reset flag which
    would cause the timer routine to trigger the reset.
    This is done to provide a smoother user experience,
    which makes sure the reset operation is done by the time
    the 'devlink reload' command returns.

  - Destruction of driver resources (using ena_destroy_device()) and
    their re-initialization (using ena_restore_device()) is done without
    holding the rtnl_lock() throughout the 'devlink reload' execution,
    but rather with holding it for *each* of the operations separately.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_devlink.c | 73 ++++++++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  3 +
 3 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_devlink.c b/drivers/net/ethernet/amazon/ena/ena_devlink.c
index 6897d60d8376..2568ade34c2a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_devlink.c
+++ b/drivers/net/ethernet/amazon/ena/ena_devlink.c
@@ -7,7 +7,76 @@
 
 #include "ena_devlink.h"
 
-static const struct devlink_ops ena_devlink_ops = {};
+static int ena_devlink_reload_down(struct devlink *devlink,
+				   bool netns_change,
+				   enum devlink_reload_action action,
+				   enum devlink_reload_limit limit,
+				   struct netlink_ext_ack *extack)
+{
+	struct ena_adapter *adapter = ENA_DEVLINK_PRIV(devlink);
+
+	if (netns_change) {
+		NL_SET_ERR_MSG_MOD(extack, "Namespace change is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT) {
+		NL_SET_ERR_MSG_MOD(extack, "Action is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (limit != DEVLINK_RELOAD_LIMIT_UNSPEC) {
+		NL_SET_ERR_MSG_MOD(extack, "Driver reload doesn't support limitations");
+		return -EOPNOTSUPP;
+	}
+
+	rtnl_lock();
+	ena_destroy_device(adapter, false);
+	rtnl_unlock();
+
+	return 0;
+}
+
+static int ena_devlink_reload_up(struct devlink *devlink,
+				 enum devlink_reload_action action,
+				 enum devlink_reload_limit limit,
+				 u32 *actions_performed,
+				 struct netlink_ext_ack *extack)
+{
+	struct ena_adapter *adapter = ENA_DEVLINK_PRIV(devlink);
+	int err = 0;
+
+	if (action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT) {
+		NL_SET_ERR_MSG_MOD(extack, "Action is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (limit != DEVLINK_RELOAD_LIMIT_UNSPEC) {
+		NL_SET_ERR_MSG_MOD(extack, "Driver reload doesn't support limitations");
+		return -EOPNOTSUPP;
+	}
+
+	rtnl_lock();
+	/* Check that no other routine initialized the device (e.g.
+	 * ena_fw_reset_device()). Also we're under devlink_mutex here,
+	 * so devlink isn't freed under our feet.
+	 */
+	if (!test_bit(ENA_FLAG_DEVICE_RUNNING, &adapter->flags))
+		err = ena_restore_device(adapter);
+
+	rtnl_unlock();
+
+	if (!err)
+		*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
+
+	return err;
+}
+
+static const struct devlink_ops ena_devlink_ops = {
+	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
+	.reload_down	= ena_devlink_reload_down,
+	.reload_up	= ena_devlink_reload_up,
+};
 
 struct devlink *ena_devlink_alloc(struct ena_adapter *adapter)
 {
@@ -20,6 +89,8 @@ struct devlink *ena_devlink_alloc(struct ena_adapter *adapter)
 		return NULL;
 	}
 
+	devlink_set_features(devlink, DEVLINK_F_RELOAD);
+
 	ENA_DEVLINK_PRIV(devlink) = adapter;
 	adapter->devlink = devlink;
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index ce79a0c42e6a..a42db781472c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -44,8 +44,6 @@ MODULE_DEVICE_TABLE(pci, ena_pci_tbl);
 
 static int ena_rss_init_default(struct ena_adapter *adapter);
 static void check_for_admin_com_state(struct ena_adapter *adapter);
-static void ena_destroy_device(struct ena_adapter *adapter, bool graceful);
-static int ena_restore_device(struct ena_adapter *adapter);
 
 static void ena_init_io_rings(struct ena_adapter *adapter,
 			      int first_index, int count);
@@ -3587,7 +3585,7 @@ static int ena_enable_msix_and_set_admin_interrupts(struct ena_adapter *adapter)
 	return rc;
 }
 
-static void ena_destroy_device(struct ena_adapter *adapter, bool graceful)
+void ena_destroy_device(struct ena_adapter *adapter, bool graceful)
 {
 	struct net_device *netdev = adapter->netdev;
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
@@ -3633,7 +3631,7 @@ static void ena_destroy_device(struct ena_adapter *adapter, bool graceful)
 	clear_bit(ENA_FLAG_DEVICE_RUNNING, &adapter->flags);
 }
 
-static int ena_restore_device(struct ena_adapter *adapter)
+int ena_restore_device(struct ena_adapter *adapter)
 {
 	struct ena_com_dev_get_features_ctx get_feat_ctx;
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index c6132aa229df..244c80af6974 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -452,4 +452,7 @@ static inline enum ena_xdp_errors_t ena_xdp_allowed(struct ena_adapter *adapter)
 	return rc;
 }
 
+void ena_destroy_device(struct ena_adapter *adapter, bool graceful);
+int ena_restore_device(struct ena_adapter *adapter);
+
 #endif /* !(ENA_H) */
-- 
2.38.1

