Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1946408C2E
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240164AbhIMNOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:14:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9862 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238400AbhIMNN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:13:57 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H7Rc62nSXz8yW0;
        Mon, 13 Sep 2021 21:08:06 +0800 (CST)
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
Subject: [PATCH net 5/6] net: hns3: fix the exception when query imp info
Date:   Mon, 13 Sep 2021 21:08:24 +0800
Message-ID: <20210913130825.27025-6-huangguangbin2@huawei.com>
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

From: Jiaran Zhang <zhangjiaran@huawei.com>

When the command for querying imp info is issued to the firmware,
if the firmware does not support the command, the returned value
of bd num is 0.
Add protection mechanism before alloc memory to prevent apply for
0-length memory.

Fixes: 0b198b0d80ea ("net: hns3: refactor dump m7 info of debugfs")
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 68ed1715ac52..87d96f82c318 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1724,6 +1724,10 @@ hclge_dbg_get_imp_stats_info(struct hclge_dev *hdev, char *buf, int len)
 	}
 
 	bd_num = le32_to_cpu(req->bd_num);
+	if (!bd_num) {
+		dev_err(&hdev->pdev->dev, "imp statistics bd number is 0!\n");
+		return -EINVAL;
+	}
 
 	desc_src = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
 	if (!desc_src)
-- 
2.33.0

