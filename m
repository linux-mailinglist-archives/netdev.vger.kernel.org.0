Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC19716FB90
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 11:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbgBZKD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 05:03:59 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:48132 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgBZKD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 05:03:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582711439; x=1614247439;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ogBxMdoiImHjr5YAD+7clha6xGTKyhG6C7kTtWh5Y2M=;
  b=VbZpcWC3Wz5jBXl9GZDEqX8WaOUKuSodcY+2YNGIrzdotbfANFp6JA3U
   7xI4+2p/zqFpmJTdpPwgyMWUF+U7PLjrboIPnYNKdWXEdGG2pwPIsQJjB
   QEkuKkBKrZZpdUvICkoNzniez6Q3I/wy9vhqBGhwCZEDUz5klYaTRbval
   E=;
IronPort-SDR: BdiholnAs0Cl1Kd/FFoOpiYE5CNBzjTKTiS7ZluPApqxdspSdGHBVnGvQU6kL9QcM61zKH9BYy
 KNs/+kfF5JvA==
X-IronPort-AV: E=Sophos;i="5.70,487,1574121600"; 
   d="scan'208";a="18283995"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 26 Feb 2020 10:03:44 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id 557FBA36DE;
        Wed, 26 Feb 2020 10:03:43 +0000 (UTC)
Received: from EX13d09UWC004.ant.amazon.com (10.43.162.114) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 26 Feb 2020 10:03:42 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC004.ant.amazon.com (10.43.162.114) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Feb 2020 10:03:42 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.71.32) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 26 Feb 2020 10:03:37 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [RESEND PATCH V1 net-next] net: ena: fix broken interface between ENA driver and FW
Date:   Wed, 26 Feb 2020 12:03:35 +0200
Message-ID: <1582711415-4442-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

In this commit we revert the part of
commit 1a63443afd70 ("net/amazon: Ensure that driver version is aligned to the linux kernel"),
which breaks the interface between the ENA driver and FW.

We also replace the use of DRIVER_VERSION with DRIVER_GENERATION
when we bring back the deleted constants that are used in interface with
ENA device FW.

This commit does not change the driver version reported to the user via
ethtool, which remains the kernel version.

Fixes: 1a63443afd70 ("net/amazon: Ensure that driver version is aligned to the linux kernel")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |  6 +++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 11 +++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 4faf81c456d8..555c7273d712 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3090,7 +3090,11 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev,
 	host_info->os_dist = 0;
 	strncpy(host_info->os_dist_str, utsname()->release,
 		sizeof(host_info->os_dist_str) - 1);
-	host_info->driver_version = LINUX_VERSION_CODE;
+	host_info->driver_version =
+		(DRV_MODULE_GEN_MAJOR) |
+		(DRV_MODULE_GEN_MINOR << ENA_ADMIN_HOST_INFO_MINOR_SHIFT) |
+		(DRV_MODULE_GEN_SUBMINOR << ENA_ADMIN_HOST_INFO_SUB_MINOR_SHIFT) |
+		("K"[0] << ENA_ADMIN_HOST_INFO_MODULE_TYPE_SHIFT);
 	host_info->num_cpus = num_online_cpus();
 
 	host_info->driver_supported_features =
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 74c7f10b60dd..97dfd0c67e84 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -45,7 +45,18 @@
 #include "ena_com.h"
 #include "ena_eth_com.h"
 
+#define DRV_MODULE_GEN_MAJOR	2
+#define DRV_MODULE_GEN_MINOR	1
+#define DRV_MODULE_GEN_SUBMINOR 0
+
 #define DRV_MODULE_NAME		"ena"
+#ifndef DRV_MODULE_GENERATION
+#define DRV_MODULE_GENERATION \
+	__stringify(DRV_MODULE_GEN_MAJOR) "."	\
+	__stringify(DRV_MODULE_GEN_MINOR) "."	\
+	__stringify(DRV_MODULE_GEN_SUBMINOR) "K"
+#endif
+
 #define DEVICE_NAME	"Elastic Network Adapter (ENA)"
 
 /* 1 for AENQ + ADMIN */
-- 
2.23.0

