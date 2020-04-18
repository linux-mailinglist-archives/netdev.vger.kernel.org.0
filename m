Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776CB1AEA51
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 08:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgDRGs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 02:48:27 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54178 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725983AbgDRGsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 02:48:23 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 10F22EB9EB761EFE19EE;
        Sat, 18 Apr 2020 14:48:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Sat, 18 Apr 2020 14:48:12 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 10/10] net: hns3: add trace event support for PF/VF mailbox
Date:   Sat, 18 Apr 2020 14:47:09 +0800
Message-ID: <1587192429-11463-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587192429-11463-1-git-send-email-tanhuazhong@huawei.com>
References: <1587192429-11463-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

This patch adds trace event support for PF/VF mailbox.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  7 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_trace.h   | 87 ++++++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  7 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h | 87 ++++++++++++++++++++++
 6 files changed, 190 insertions(+)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
index 0fb61d4..6c28c8f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
@@ -4,6 +4,7 @@
 #
 
 ccflags-y := -I $(srctree)/drivers/net/ethernet/hisilicon/hns3
+ccflags-y += -I $(srctree)/$(src)
 
 obj-$(CONFIG_HNS3_HCLGE) += hclge.o
 hclge-objs = hclge_main.o hclge_cmd.o hclge_mdio.o hclge_tm.o hclge_mbx.o hclge_err.o  hclge_debugfs.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 7f24fcb..103c2ec 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -5,6 +5,9 @@
 #include "hclge_mbx.h"
 #include "hnae3.h"
 
+#define CREATE_TRACE_POINTS
+#include "hclge_trace.h"
+
 static u16 hclge_errno_to_resp(int errno)
 {
 	return abs(errno);
@@ -90,6 +93,8 @@ static int hclge_send_mbx_msg(struct hclge_vport *vport, u8 *msg, u16 msg_len,
 
 	memcpy(&resp_pf_to_vf->msg.vf_mbx_msg_code, msg, msg_len);
 
+	trace_hclge_pf_mbx_send(hdev, resp_pf_to_vf);
+
 	status = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
 		dev_err(&hdev->pdev->dev,
@@ -674,6 +679,8 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 
 		vport = &hdev->vport[req->mbx_src_vfid];
 
+		trace_hclge_pf_mbx_get(hdev, req);
+
 		switch (req->msg.code) {
 		case HCLGE_MBX_MAP_RING_TO_VECTOR:
 			ret = hclge_map_unmap_ring_to_vf_vector(vport, true,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
new file mode 100644
index 0000000..5b0b71b
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2018-2020 Hisilicon Limited. */
+
+/* This must be outside ifdef _HCLGE_TRACE_H */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM hns3
+
+#if !defined(_HCLGE_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _HCLGE_TRACE_H_
+
+#include <linux/tracepoint.h>
+
+#define PF_GET_MBX_LEN	(sizeof(struct hclge_mbx_vf_to_pf_cmd) / sizeof(u32))
+#define PF_SEND_MBX_LEN	(sizeof(struct hclge_mbx_pf_to_vf_cmd) / sizeof(u32))
+
+TRACE_EVENT(hclge_pf_mbx_get,
+	TP_PROTO(
+		struct hclge_dev *hdev,
+		struct hclge_mbx_vf_to_pf_cmd *req),
+	TP_ARGS(hdev, req),
+
+	TP_STRUCT__entry(
+		__field(u8, vfid)
+		__field(u8, code)
+		__field(u8, subcode)
+		__string(pciname, pci_name(hdev->pdev))
+		__string(devname, &hdev->vport[0].nic.kinfo.netdev->name)
+		__array(u32, mbx_data, PF_GET_MBX_LEN)
+	),
+
+	TP_fast_assign(
+		__entry->vfid = req->mbx_src_vfid;
+		__entry->code = req->msg.code;
+		__entry->subcode = req->msg.subcode;
+		__assign_str(pciname, pci_name(hdev->pdev));
+		__assign_str(devname, &hdev->vport[0].nic.kinfo.netdev->name);
+		memcpy(__entry->mbx_data, req,
+		       sizeof(struct hclge_mbx_vf_to_pf_cmd));
+	),
+
+	TP_printk(
+		"%s %s vfid:%u code:%u subcode:%u data:%s",
+		__get_str(pciname), __get_str(devname), __entry->vfid,
+		__entry->code, __entry->subcode,
+		__print_array(__entry->mbx_data, PF_GET_MBX_LEN, sizeof(u32))
+	)
+);
+
+TRACE_EVENT(hclge_pf_mbx_send,
+	TP_PROTO(
+		struct hclge_dev *hdev,
+		struct hclge_mbx_pf_to_vf_cmd *req),
+	TP_ARGS(hdev, req),
+
+	TP_STRUCT__entry(
+		__field(u8, vfid)
+		__field(u16, code)
+		__string(pciname, pci_name(hdev->pdev))
+		__string(devname, &hdev->vport[0].nic.kinfo.netdev->name)
+		__array(u32, mbx_data, PF_SEND_MBX_LEN)
+	),
+
+	TP_fast_assign(
+		__entry->vfid = req->dest_vfid;
+		__entry->code = req->msg.code;
+		__assign_str(pciname, pci_name(hdev->pdev));
+		__assign_str(devname, &hdev->vport[0].nic.kinfo.netdev->name);
+		memcpy(__entry->mbx_data, req,
+		       sizeof(struct hclge_mbx_pf_to_vf_cmd));
+	),
+
+	TP_printk(
+		"%s %s vfid:%u code:%u data:%s",
+		__get_str(pciname), __get_str(devname), __entry->vfid,
+		__entry->code,
+		__print_array(__entry->mbx_data, PF_SEND_MBX_LEN, sizeof(u32))
+	)
+);
+
+#endif /* _HCLGE_TRACE_H_ */
+
+/* This must be outside ifdef _HCLGE_TRACE_H */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE hclge_trace
+#include <trace/define_trace.h>
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
index 53804d9..2c26ea6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
@@ -4,6 +4,7 @@
 #
 
 ccflags-y := -I $(srctree)/drivers/net/ethernet/hisilicon/hns3
+ccflags-y += -I $(srctree)/$(src)
 
 obj-$(CONFIG_HNS3_HCLGEVF) += hclgevf.o
 hclgevf-objs = hclgevf_main.o hclgevf_cmd.o hclgevf_mbx.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 9b81549..5b2dcd9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -5,6 +5,9 @@
 #include "hclgevf_main.h"
 #include "hnae3.h"
 
+#define CREATE_TRACE_POINTS
+#include "hclgevf_trace.h"
+
 static int hclgevf_resp_to_errno(u16 resp_code)
 {
 	return resp_code ? -resp_code : 0;
@@ -106,6 +109,8 @@ int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev,
 
 	memcpy(&req->msg, send_msg, sizeof(struct hclge_vf_to_pf_msg));
 
+	trace_hclge_vf_mbx_send(hdev, req);
+
 	/* synchronous send */
 	if (need_resp) {
 		mutex_lock(&hdev->mbx_resp.mbx_mutex);
@@ -179,6 +184,8 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 			continue;
 		}
 
+		trace_hclge_vf_mbx_get(hdev, req);
+
 		/* synchronous messages are time critical and need preferential
 		 * treatment. Therefore, we need to acknowledge all the sync
 		 * responses as quickly as possible so that waiting tasks do not
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h
new file mode 100644
index 0000000..e4bfb61
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2018-2019 Hisilicon Limited. */
+
+/* This must be outside ifdef _HCLGEVF_TRACE_H */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM hns3
+
+#if !defined(_HCLGEVF_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _HCLGEVF_TRACE_H_
+
+#include <linux/tracepoint.h>
+
+#define VF_GET_MBX_LEN	(sizeof(struct hclge_mbx_pf_to_vf_cmd) / sizeof(u32))
+#define VF_SEND_MBX_LEN	(sizeof(struct hclge_mbx_vf_to_pf_cmd) / sizeof(u32))
+
+TRACE_EVENT(hclge_vf_mbx_get,
+	TP_PROTO(
+		struct hclgevf_dev *hdev,
+		struct hclge_mbx_pf_to_vf_cmd *req),
+	TP_ARGS(hdev, req),
+
+	TP_STRUCT__entry(
+		__field(u8, vfid)
+		__field(u16, code)
+		__string(pciname, pci_name(hdev->pdev))
+		__string(devname, &hdev->nic.kinfo.netdev->name)
+		__array(u32, mbx_data, VF_GET_MBX_LEN)
+	),
+
+	TP_fast_assign(
+		__entry->vfid = req->dest_vfid;
+		__entry->code = req->msg.code;
+		__assign_str(pciname, pci_name(hdev->pdev));
+		__assign_str(devname, &hdev->nic.kinfo.netdev->name);
+		memcpy(__entry->mbx_data, req,
+		       sizeof(struct hclge_mbx_pf_to_vf_cmd));
+	),
+
+	TP_printk(
+		"%s %s vfid:%u code:%u data:%s",
+		__get_str(pciname), __get_str(devname), __entry->vfid,
+		__entry->code,
+		__print_array(__entry->mbx_data, VF_GET_MBX_LEN, sizeof(u32))
+	)
+);
+
+TRACE_EVENT(hclge_vf_mbx_send,
+	TP_PROTO(
+		struct hclgevf_dev *hdev,
+		struct hclge_mbx_vf_to_pf_cmd *req),
+	TP_ARGS(hdev, req),
+
+	TP_STRUCT__entry(
+		__field(u8, vfid)
+		__field(u8, code)
+		__field(u8, subcode)
+		__string(pciname, pci_name(hdev->pdev))
+		__string(devname, &hdev->nic.kinfo.netdev->name)
+		__array(u32, mbx_data, VF_SEND_MBX_LEN)
+	),
+
+	TP_fast_assign(
+		__entry->vfid = req->mbx_src_vfid;
+		__entry->code = req->msg.code;
+		__entry->subcode = req->msg.subcode;
+		__assign_str(pciname, pci_name(hdev->pdev));
+		__assign_str(devname, &hdev->nic.kinfo.netdev->name);
+		memcpy(__entry->mbx_data, req,
+		       sizeof(struct hclge_mbx_vf_to_pf_cmd));
+	),
+
+	TP_printk(
+		"%s %s vfid:%u code:%u subcode:%u data:%s",
+		__get_str(pciname), __get_str(devname), __entry->vfid,
+		__entry->code, __entry->subcode,
+		__print_array(__entry->mbx_data, VF_SEND_MBX_LEN, sizeof(u32))
+	)
+);
+
+#endif /* _HCLGEVF_TRACE_H_ */
+
+/* This must be outside ifdef _HCLGEVF_TRACE_H */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE hclgevf_trace
+#include <trace/define_trace.h>
-- 
2.7.4

