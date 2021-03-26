Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0072C349EC7
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhCZBg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 21:36:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14604 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhCZBgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 21:36:23 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F64JW6swGz19JF4;
        Fri, 26 Mar 2021 09:34:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 09:36:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 9/9] net: hns3: split out hclge_tm_vport_tc_info_update()
Date:   Fri, 26 Mar 2021 09:36:28 +0800
Message-ID: <1616722588-58967-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616722588-58967-1-git-send-email-tanhuazhong@huawei.com>
References: <1616722588-58967-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

hclge_tm_vport_tc_info_update() is bloated, so split it into
separate functions for readability and maintainability.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 151afd1..aa81b8c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -631,13 +631,12 @@ static u16 hclge_vport_get_tqp_num(struct hclge_vport *vport)
 	return sum;
 }
 
-static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
+static void hclge_tm_update_kinfo_rss_size(struct hclge_vport *vport)
 {
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
 	struct hclge_dev *hdev = vport->back;
 	u16 vport_max_rss_size;
 	u16 max_rss_size;
-	u8 i;
 
 	/* TC configuration is shared by PF/VF in one port, only allow
 	 * one tc for VF for simplicity. VF's vport_id is non zero.
@@ -677,7 +676,15 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 		/* Set to the maximum specification value (max_rss_size). */
 		kinfo->rss_size = max_rss_size;
 	}
+}
+
+static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
+{
+	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
+	struct hclge_dev *hdev = vport->back;
+	u8 i;
 
+	hclge_tm_update_kinfo_rss_size(vport);
 	kinfo->num_tqps = hclge_vport_get_tqp_num(vport);
 	vport->dwrr = 100;  /* 100 percent as init */
 	vport->alloc_rss_size = kinfo->rss_size;
-- 
2.7.4

