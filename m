Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563CD482359
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhLaK1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:27:43 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:31133 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhLaK1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:27:40 -0500
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JQLqn2Qqzz8w6W;
        Fri, 31 Dec 2021 18:25:09 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:39 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 02/13] net: hns3: create new cmdq hardware description structure hclge_comm_hw
Date:   Fri, 31 Dec 2021 18:22:32 +0800
Message-ID: <20211231102243.3006-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211231102243.3006-1-huangguangbin2@huawei.com>
References: <20211231102243.3006-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently PF and VF cmdq APIs use struct hclge(vf)_hw to describe cmdq
hardware information needed by hclge(vf)_cmd_send. There are a little
differences between its child struct hclge_cmq_ring and hclgevf_cmq_ring.
It is redundent to use two sets of structures to support same functions.

So this patch creates new set of common cmdq hardware description
structures(hclge_comm_hw) to unify PF and VF cmdq functions. The struct
hclge_desc is still kept to avoid too many meaningless replacement.

These new structures will be used to unify hclge(vf)_hw structures in PF
and VF cmdq APIs in next patches.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/Makefile  |  1 +
 .../hns3/hns3_common/hclge_comm_cmd.h         | 55 +++++++++++++++++++
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  9 +--
 3 files changed, 57 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h

diff --git a/drivers/net/ethernet/hisilicon/hns3/Makefile b/drivers/net/ethernet/hisilicon/hns3/Makefile
index 32e24e0945f5..33e546cef288 100644
--- a/drivers/net/ethernet/hisilicon/hns3/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/Makefile
@@ -6,6 +6,7 @@
 ccflags-y += -I$(srctree)/$(src)
 ccflags-y += -I$(srctree)/drivers/net/ethernet/hisilicon/hns3/hns3pf
 ccflags-y += -I$(srctree)/drivers/net/ethernet/hisilicon/hns3/hns3vf
+ccflags-y += -I$(srctree)/drivers/net/ethernet/hisilicon/hns3/hns3_common
 
 obj-$(CONFIG_HNS3) += hnae3.o
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
new file mode 100644
index 000000000000..f1e39003ceeb
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+// Copyright (c) 2021-2021 Hisilicon Limited.
+
+#ifndef __HCLGE_COMM_CMD_H
+#define __HCLGE_COMM_CMD_H
+#include <linux/types.h>
+
+#include "hnae3.h"
+
+#define HCLGE_DESC_DATA_LEN		6
+struct hclge_desc {
+	__le16 opcode;
+	__le16 flag;
+	__le16 retval;
+	__le16 rsv;
+	__le32 data[HCLGE_DESC_DATA_LEN];
+};
+
+struct hclge_comm_cmq_ring {
+	dma_addr_t desc_dma_addr;
+	struct hclge_desc *desc;
+	struct pci_dev *pdev;
+	u32 head;
+	u32 tail;
+
+	u16 buf_size;
+	u16 desc_num;
+	int next_to_use;
+	int next_to_clean;
+	u8 ring_type; /* cmq ring type */
+	spinlock_t lock; /* Command queue lock */
+};
+
+enum hclge_comm_cmd_status {
+	HCLGE_COMM_STATUS_SUCCESS	= 0,
+	HCLGE_COMM_ERR_CSQ_FULL		= -1,
+	HCLGE_COMM_ERR_CSQ_TIMEOUT	= -2,
+	HCLGE_COMM_ERR_CSQ_ERROR	= -3,
+};
+
+struct hclge_comm_cmq {
+	struct hclge_comm_cmq_ring csq;
+	struct hclge_comm_cmq_ring crq;
+	u16 tx_timeout;
+	enum hclge_comm_cmd_status last_status;
+};
+
+struct hclge_comm_hw {
+	void __iomem *io_base;
+	void __iomem *mem_base;
+	struct hclge_comm_cmq cmq;
+	unsigned long comm_state;
+};
+
+#endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index d24e59028798..cb1fdab0ee7c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -7,24 +7,17 @@
 #include <linux/io.h>
 #include <linux/etherdevice.h>
 #include "hnae3.h"
+#include "hclge_comm_cmd.h"
 
 #define HCLGE_CMDQ_TX_TIMEOUT		30000
 #define HCLGE_CMDQ_CLEAR_WAIT_TIME	200
 #define HCLGE_DESC_DATA_LEN		6
 
 struct hclge_dev;
-struct hclge_desc {
-	__le16 opcode;
 
 #define HCLGE_CMDQ_RX_INVLD_B		0
 #define HCLGE_CMDQ_RX_OUTVLD_B		1
 
-	__le16 flag;
-	__le16 retval;
-	__le16 rsv;
-	__le32 data[HCLGE_DESC_DATA_LEN];
-};
-
 struct hclge_cmq_ring {
 	dma_addr_t desc_dma_addr;
 	struct hclge_desc *desc;
-- 
2.33.0

