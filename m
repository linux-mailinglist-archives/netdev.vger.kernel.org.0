Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A57FBDEB
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 03:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfKNCcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 21:32:31 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6659 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726516AbfKNCc3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 21:32:29 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BEB2F7459B744862161E;
        Thu, 14 Nov 2019 10:32:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 14 Nov 2019 10:32:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 2/3] net: hns3: reallocate SSU' buffer size when pfc_en changes
Date:   Thu, 14 Nov 2019 10:32:40 +0800
Message-ID: <1573698761-25682-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573698761-25682-1-git-send-email-tanhuazhong@huawei.com>
References: <1573698761-25682-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

When a TC's PFC is disabled or enabled, the RX private buffer for
this TC need to be changed too, otherwise this may cause packet
dropped problem.

This patch fixes it by calling hclge_buffer_alloc to reallocate
buffer when pfc_en changes.

Fixes: cacde272dd00 ("net: hns3: Add hclge_dcb module for the support of DCB feature")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index c063301..8b42cae 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -318,6 +318,7 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	struct net_device *netdev = h->kinfo.netdev;
 	struct hclge_dev *hdev = vport->back;
 	u8 i, j, pfc_map, *prio_tc;
+	int ret;
 
 	if (!(hdev->dcbx_cap & DCB_CAP_DCBX_VER_IEEE) ||
 	    hdev->flag & HCLGE_FLAG_MQPRIO_ENABLE)
@@ -347,7 +348,21 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 
 	hclge_tm_pfc_info_update(hdev);
 
-	return hclge_pause_setup_hw(hdev, false);
+	ret = hclge_pause_setup_hw(hdev, false);
+	if (ret)
+		return ret;
+
+	ret = hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
+	if (ret)
+		return ret;
+
+	ret = hclge_buffer_alloc(hdev);
+	if (ret) {
+		hclge_notify_client(hdev, HNAE3_UP_CLIENT);
+		return ret;
+	}
+
+	return hclge_notify_client(hdev, HNAE3_UP_CLIENT);
 }
 
 /* DCBX configuration */
-- 
2.7.4

