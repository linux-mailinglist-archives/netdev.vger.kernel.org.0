Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2701B4673FE
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 10:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379610AbhLCJ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 04:29:20 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15701 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379642AbhLCJ3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 04:29:13 -0500
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J56n328k0zZdSP;
        Fri,  3 Dec 2021 17:23:03 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:46 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:43 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 11/11] net: hns3: fix hns3 driver header file not self-contained issue
Date:   Fri, 3 Dec 2021 17:20:59 +0800
Message-ID: <20211203092059.24947-12-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203092059.24947-1-huangguangbin2@huawei.com>
References: <20211203092059.24947-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

The hns3 driver header file uses the structure of other files, but does
not include corresponding file, which causes a check warning that the
header file is not self-contained.

Therefore, the required header file is included in the header file, and
the structure declaration is added to the header file to avoid cyclic
dependency of the header file.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h      | 2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h         | 3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h | 4 ++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h  | 3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h   | 6 ++++++
 5 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index bd8801065e02..83aa1450ab9f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -4,6 +4,8 @@
 #ifndef __HNS3_DEBUGFS_H
 #define __HNS3_DEBUGFS_H
 
+#include "hnae3.h"
+
 #define HNS3_DBG_READ_LEN	65536
 #define HNS3_DBG_READ_LEN_128KB	0x20000
 #define HNS3_DBG_READ_LEN_1MB	0x100000
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 2803b2cd7f30..a05a0c7423ce 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -10,6 +10,9 @@
 
 #include "hnae3.h"
 
+struct iphdr;
+struct ipv6hdr;
+
 enum hns3_nic_state {
 	HNS3_NIC_STATE_TESTING,
 	HNS3_NIC_STATE_RESETTING,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
index fd0e20190b90..4200d0b6d931 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
@@ -4,6 +4,10 @@
 #ifndef __HCLGE_MDIO_H
 #define __HCLGE_MDIO_H
 
+#include "hnae3.h"
+
+struct hclge_dev;
+
 int hclge_mac_mdio_config(struct hclge_dev *hdev);
 int hclge_mac_connect_phy(struct hnae3_handle *handle);
 void hclge_mac_disconnect_phy(struct hnae3_handle *handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
index 7a9b77de632a..bbee74cd8404 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
@@ -8,6 +8,9 @@
 #include <linux/net_tstamp.h>
 #include <linux/types.h>
 
+struct hclge_dev;
+struct ifreq;
+
 #define HCLGE_PTP_REG_OFFSET	0x29000
 
 #define HCLGE_PTP_TX_TS_SEQID_REG	0x0
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 1db7f40b4525..619cc30a2dfc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -6,6 +6,12 @@
 
 #include <linux/types.h>
 
+#include "hnae3.h"
+
+struct hclge_dev;
+struct hclge_vport;
+enum hclge_opcode_type;
+
 /* MAC Pause */
 #define HCLGE_TX_MAC_PAUSE_EN_MSK	BIT(0)
 #define HCLGE_RX_MAC_PAUSE_EN_MSK	BIT(1)
-- 
2.33.0

