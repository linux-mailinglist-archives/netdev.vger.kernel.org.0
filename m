Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CDA7D435
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbfHAD5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:57:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3724 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728150AbfHAD5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:57:54 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7E636E30EF4810CE094D;
        Thu,  1 Aug 2019 11:57:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 11:57:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 02/12] net: hns3: add handler for NCSI error mailbox
Date:   Thu, 1 Aug 2019 11:55:35 +0800
Message-ID: <1564631745-36733-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
References: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When NCSI has HW error, the IMP will report this error to the driver
by sending a mailbox. After received this message, the driver should
assert a global reset to fix this kind of HW error.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 12 ++++++++++++
 4 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 1564be5..f8a87f8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -48,6 +48,7 @@ enum HCLGE_MBX_OPCODE {
 
 	HCLGE_MBX_GET_VF_FLR_STATUS = 200, /* (M7 -> PF) get vf reset status */
 	HCLGE_MBX_PUSH_LINK_STATUS,	/* (M7 -> PF) get port link status */
+	HCLGE_MBX_NCSI_ERROR,		/* (M7 -> PF) receive a NCSI error */
 };
 
 /* below are per-VF mac-vlan subcodes */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 538d101..c20b972 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -394,6 +394,7 @@ static int hclge_firmware_compat_config(struct hclge_dev *hdev)
 	req = (struct hclge_firmware_compat_cmd *)desc.data;
 
 	hnae3_set_bit(compat, HCLGE_LINK_EVENT_REPORT_EN_B, 1);
+	hnae3_set_bit(compat, HCLGE_NCSI_ERROR_REPORT_EN_B, 1);
 	req->compat = cpu_to_le32(compat);
 
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 743c9f4..070b9dd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1011,6 +1011,7 @@ struct hclge_query_ppu_pf_other_int_dfx_cmd {
 };
 
 #define HCLGE_LINK_EVENT_REPORT_EN_B	0
+#define HCLGE_NCSI_ERROR_REPORT_EN_B	1
 struct hclge_firmware_compat_cmd {
 	__le32 compat;
 	u8 rsv[20];
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 87de32d..5a7221e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -582,6 +582,15 @@ static bool hclge_cmd_crq_empty(struct hclge_hw *hw)
 	return tail == hw->cmq.crq.next_to_use;
 }
 
+static void hclge_handle_ncsi_error(struct hclge_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
+
+	ae_dev->ops->set_default_reset_request(ae_dev, HNAE3_GLOBAL_RESET);
+	dev_warn(&hdev->pdev->dev, "requesting reset due to NCSI error\n");
+	ae_dev->ops->reset_event(hdev->pdev, NULL);
+}
+
 void hclge_mbx_handler(struct hclge_dev *hdev)
 {
 	struct hclge_cmq_ring *crq = &hdev->hw.cmq.crq;
@@ -740,6 +749,9 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		case HCLGE_MBX_PUSH_LINK_STATUS:
 			hclge_handle_link_change_event(hdev, req);
 			break;
+		case HCLGE_MBX_NCSI_ERROR:
+			hclge_handle_ncsi_error(hdev);
+			break;
 		default:
 			dev_err(&hdev->pdev->dev,
 				"un-supported mailbox message, code = %d\n",
-- 
2.7.4

