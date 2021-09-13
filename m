Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA4D408C3A
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbhIMNQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:16:09 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9860 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238549AbhIMNNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:13:50 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H7Rc46h8Zz8yVn;
        Mon, 13 Sep 2021 21:08:04 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 21:12:29 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 21:12:29 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 4/6] net: hns3: disable mac in flr process
Date:   Mon, 13 Sep 2021 21:08:23 +0800
Message-ID: <20210913130825.27025-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130825.27025-1-huangguangbin2@huawei.com>
References: <20210913130825.27025-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The firmware will not disable mac in flr process. Therefore, the driver
needs to proactively disable mac during flr, which is the same as the
function reset.

Fixes: 35d93a30040c ("net: hns3: adjust the process of PF reset")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index aed97c934bfb..f1e46ba799f9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8127,11 +8127,12 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
 	hclge_clear_arfs_rules(hdev);
 	spin_unlock_bh(&hdev->fd_rule_lock);
 
-	/* If it is not PF reset, the firmware will disable the MAC,
+	/* If it is not PF reset or FLR, the firmware will disable the MAC,
 	 * so it only need to stop phy here.
 	 */
 	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) &&
-	    hdev->reset_type != HNAE3_FUNC_RESET) {
+	    hdev->reset_type != HNAE3_FUNC_RESET &&
+	    hdev->reset_type != HNAE3_FLR_RESET) {
 		hclge_mac_stop_phy(hdev);
 		hclge_update_link_status(hdev);
 		return;
-- 
2.33.0

