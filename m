Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94FA3182990
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 08:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388105AbgCLHMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 03:12:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11633 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388081AbgCLHMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 03:12:17 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 09AFF625377D100FA4BD;
        Thu, 12 Mar 2020 15:12:14 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 12 Mar 2020 15:12:06 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 2/4] net: hns3: fix VF VLAN table entries inconsistent issue
Date:   Thu, 12 Mar 2020 15:11:04 +0800
Message-ID: <1583997066-24773-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583997066-24773-1-git-send-email-tanhuazhong@huawei.com>
References: <1583997066-24773-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, if VF is loaded on the host side, the host doesn't
clear the VF's VLAN table entries when VF removing. In this
case, when doing reset and disabling sriov at the same time the
VLAN device over VF will be removed, but the VLAN table entries
in hardware are remained.

This patch fixes it by asking PF to clear the VLAN table entries for
VF when VF is removing. It also clears the VLAN table full bit
after VF VLAN table entries being cleared.

Fixes: c6075b193462 ("net: hns3: Record VF vlan tables")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h           | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c    | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 +++
 4 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 1b03139..d87158a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -46,6 +46,7 @@ enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_PUSH_VLAN_INFO,	/* (PF -> VF) push port base vlan */
 	HCLGE_MBX_GET_MEDIA_TYPE,       /* (VF -> PF) get media type */
 	HCLGE_MBX_PUSH_PROMISC_INFO,	/* (PF -> VF) push vf promisc info */
+	HCLGE_MBX_VF_UNINIT,            /* (VF -> PF) vf is unintializing */
 
 	HCLGE_MBX_GET_VF_FLR_STATUS = 200, /* (M7 -> PF) get vf flr status */
 	HCLGE_MBX_PUSH_LINK_STATUS,	/* (M7 -> PF) get port link status */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index acf0c29f..6deeb96 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8272,6 +8272,7 @@ void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list)
 			kfree(vlan);
 		}
 	}
+	clear_bit(vport->vport_id, hdev->vf_vlan_full);
 }
 
 void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index a3c0822..3d850f6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -799,6 +799,7 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 			hclge_get_link_mode(vport, req);
 			break;
 		case HCLGE_MBX_GET_VF_FLR_STATUS:
+		case HCLGE_MBX_VF_UNINIT:
 			hclge_rm_vport_all_mac_table(vport, true,
 						     HCLGE_MAC_ADDR_UC);
 			hclge_rm_vport_all_mac_table(vport, true,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index d659720..0510d85 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2803,6 +2803,9 @@ static void hclgevf_uninit_hdev(struct hclgevf_dev *hdev)
 {
 	hclgevf_state_uninit(hdev);
 
+	hclgevf_send_mbx_msg(hdev, HCLGE_MBX_VF_UNINIT, 0, NULL, 0,
+			     false, NULL, 0);
+
 	if (test_bit(HCLGEVF_STATE_IRQ_INITED, &hdev->state)) {
 		hclgevf_misc_irq_uninit(hdev);
 		hclgevf_uninit_msi(hdev);
-- 
2.7.4

