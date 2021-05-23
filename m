Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B95838D939
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 08:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhEWGED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 02:04:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5669 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbhEWGEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 02:04:02 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FnqS11fWrz1BQJY;
        Sun, 23 May 2021 13:59:45 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 23 May 2021 14:02:34 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sun, 23
 May 2021 14:02:33 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <dougmill@linux.ibm.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 net-next] ehea: Use DEVICE_ATTR_*() macro
Date:   Sun, 23 May 2021 14:02:23 +0800
Message-ID: <20210523060223.41936-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_*() helper instead of plain DEVICE_ATTR,
which makes the code a bit shorter and easier to read.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: probe_port_show should be probe_port_store 

 drivers/net/ethernet/ibm/ehea/ehea_main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index ea55314b209d..fb639f7644bc 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2867,14 +2867,14 @@ static int ehea_get_jumboframe_status(struct ehea_port *port, int *jumbo)
 	return ret;
 }
 
-static ssize_t ehea_show_port_id(struct device *dev,
-				 struct device_attribute *attr, char *buf)
+static ssize_t log_port_id_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct ehea_port *port = container_of(dev, struct ehea_port, ofdev.dev);
 	return sprintf(buf, "%d", port->logical_port_id);
 }
 
-static DEVICE_ATTR(log_port_id, 0444, ehea_show_port_id, NULL);
+static DEVICE_ATTR_RO(log_port_id);
 
 static void logical_port_release(struct device *dev)
 {
@@ -3113,7 +3113,7 @@ static struct device_node *ehea_get_eth_dn(struct ehea_adapter *adapter,
 	return NULL;
 }
 
-static ssize_t ehea_probe_port(struct device *dev,
+static ssize_t probe_port_store(struct device *dev,
 			       struct device_attribute *attr,
 			       const char *buf, size_t count)
 {
@@ -3168,9 +3168,9 @@ static ssize_t ehea_probe_port(struct device *dev,
 	return (ssize_t) count;
 }
 
-static ssize_t ehea_remove_port(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
+static ssize_t remove_port_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
 {
 	struct ehea_adapter *adapter = dev_get_drvdata(dev);
 	struct ehea_port *port;
@@ -3203,8 +3203,8 @@ static ssize_t ehea_remove_port(struct device *dev,
 	return (ssize_t) count;
 }
 
-static DEVICE_ATTR(probe_port, 0200, NULL, ehea_probe_port);
-static DEVICE_ATTR(remove_port, 0200, NULL, ehea_remove_port);
+static DEVICE_ATTR_WO(probe_port);
+static DEVICE_ATTR_WO(remove_port);
 
 static int ehea_create_device_sysfs(struct platform_device *dev)
 {
-- 
2.17.1

