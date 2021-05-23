Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EBB38D87A
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 05:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhEWDWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 23:22:03 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3636 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbhEWDWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 23:22:02 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FnlrD2YxszQnhy;
        Sun, 23 May 2021 11:17:00 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 23 May 2021 11:20:34 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sun, 23
 May 2021 11:20:33 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] sfc: use DEVICE_ATTR_*() macro
Date:   Sun, 23 May 2021 11:20:30 +0800
Message-ID: <20210523032030.42052-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_*() helper instead of plain DEVICE_ATTR,
which makes the code a bit shorter and easier to read.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/sfc/ef10.c       | 17 ++++++++---------
 drivers/net/ethernet/sfc/efx.c        |  6 +++---
 drivers/net/ethernet/sfc/efx_common.c | 12 +++++++-----
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index c3f35da1b82a..d597c89f00ed 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -370,9 +370,9 @@ static int efx_ef10_get_mac_address_vf(struct efx_nic *efx, u8 *mac_address)
 	return 0;
 }
 
-static ssize_t efx_ef10_show_link_control_flag(struct device *dev,
-					       struct device_attribute *attr,
-					       char *buf)
+static ssize_t link_control_flag_show(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
 {
 	struct efx_nic *efx = dev_get_drvdata(dev);
 
@@ -382,9 +382,9 @@ static ssize_t efx_ef10_show_link_control_flag(struct device *dev,
 		       ? 1 : 0);
 }
 
-static ssize_t efx_ef10_show_primary_flag(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
+static ssize_t primary_flag_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
 {
 	struct efx_nic *efx = dev_get_drvdata(dev);
 
@@ -519,9 +519,8 @@ static void efx_ef10_cleanup_vlans(struct efx_nic *efx)
 	mutex_unlock(&nic_data->vlan_lock);
 }
 
-static DEVICE_ATTR(link_control_flag, 0444, efx_ef10_show_link_control_flag,
-		   NULL);
-static DEVICE_ATTR(primary_flag, 0444, efx_ef10_show_primary_flag, NULL);
+static DEVICE_ATTR_RO(link_control_flag);
+static DEVICE_ATTR_RO(primary_flag);
 
 static int efx_ef10_probe(struct efx_nic *efx)
 {
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 4fd9903ffe98..37fcf2eb0741 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -689,13 +689,13 @@ static struct notifier_block efx_netdev_notifier = {
 	.notifier_call = efx_netdev_event,
 };
 
-static ssize_t
-show_phy_type(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t phy_type_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
 	struct efx_nic *efx = dev_get_drvdata(dev);
 	return sprintf(buf, "%d\n", efx->phy_type);
 }
-static DEVICE_ATTR(phy_type, 0444, show_phy_type, NULL);
+static DEVICE_ATTR_RO(phy_type);
 
 static int efx_register_netdev(struct efx_nic *efx)
 {
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index de797e1ac5a9..896b59253197 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1160,8 +1160,9 @@ void efx_fini_io(struct efx_nic *efx)
 }
 
 #ifdef CONFIG_SFC_MCDI_LOGGING
-static ssize_t show_mcdi_log(struct device *dev, struct device_attribute *attr,
-			     char *buf)
+static ssize_t mcdi_logging_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
 {
 	struct efx_nic *efx = dev_get_drvdata(dev);
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
@@ -1169,8 +1170,9 @@ static ssize_t show_mcdi_log(struct device *dev, struct device_attribute *attr,
 	return scnprintf(buf, PAGE_SIZE, "%d\n", mcdi->logging_enabled);
 }
 
-static ssize_t set_mcdi_log(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
+static ssize_t mcdi_logging_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
 {
 	struct efx_nic *efx = dev_get_drvdata(dev);
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
@@ -1180,7 +1182,7 @@ static ssize_t set_mcdi_log(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(mcdi_logging, 0644, show_mcdi_log, set_mcdi_log);
+static DEVICE_ATTR_RW(mcdi_logging);
 
 void efx_init_mcdi_logging(struct efx_nic *efx)
 {
-- 
2.17.1

