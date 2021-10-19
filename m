Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21D8433848
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhJSOXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:23:07 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26167 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhJSOXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 10:23:06 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HYbV172zwz8tl6;
        Tue, 19 Oct 2021 22:19:37 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:50 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 1/8] net: hns3: Add configuration of TM QCN error event
Date:   Tue, 19 Oct 2021 22:16:28 +0800
Message-ID: <20211019141635.43695-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211019141635.43695-1-huangguangbin2@huawei.com>
References: <20211019141635.43695-1-huangguangbin2@huawei.com>
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

From: Jiaran Zhang <zhangjiaran@huawei.com>

Add configuration of interrupt type and fifo interrupt enable of TM QCN
error event if enabled, otherwise this event will not be reported when
there is error.

Fixes: d914971df022 ("net: hns3: remove redundant query in hclge_config_tm_hw_err_int()")
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 5 ++++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index bb9b026ae88e..93aa7f2bdc13 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1560,8 +1560,11 @@ static int hclge_config_tm_hw_err_int(struct hclge_dev *hdev, bool en)
 
 	/* configure TM QCN hw errors */
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_TM_QCN_MEM_INT_CFG, false);
-	if (en)
+	desc.data[0] = cpu_to_le32(HCLGE_TM_QCN_ERR_INT_TYPE);
+	if (en) {
+		desc.data[0] |= cpu_to_le32(HCLGE_TM_QCN_FIFO_INT_EN);
 		desc.data[1] = cpu_to_le32(HCLGE_TM_QCN_MEM_ERR_INT_EN);
+	}
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 07987fb8332e..d811eeefe2c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -50,6 +50,8 @@
 #define HCLGE_PPP_MPF_ECC_ERR_INT3_EN	0x003F
 #define HCLGE_PPP_MPF_ECC_ERR_INT3_EN_MASK	0x003F
 #define HCLGE_TM_SCH_ECC_ERR_INT_EN	0x3
+#define HCLGE_TM_QCN_ERR_INT_TYPE	0x29
+#define HCLGE_TM_QCN_FIFO_INT_EN	0xFFFF00
 #define HCLGE_TM_QCN_MEM_ERR_INT_EN	0xFFFFFF
 #define HCLGE_NCSI_ERR_INT_EN	0x3
 #define HCLGE_NCSI_ERR_INT_TYPE	0x9
-- 
2.33.0

