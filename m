Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA5D4C9FD
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731545AbfFTIyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:54:37 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19044 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731471AbfFTIyg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 04:54:36 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6EB32B0C464C6BCC9673;
        Thu, 20 Jun 2019 16:54:33 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 16:54:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/11] net: hns3: modify handling of out of memory in hclge_err.c
Date:   Thu, 20 Jun 2019 16:52:40 +0800
Message-ID: <1561020765-14481-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
References: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

Users should be informed if HNS driver failed to allocate memory for
descriptor when handling hw errors. This patch solve above issues.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 3dfb265..dd7b8a8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1859,7 +1859,7 @@ static int hclge_handle_all_hw_msix_error(struct hclge_dev *hdev,
 	if (ret) {
 		dev_err(dev, "fail(%d) to query msix int status bd num\n",
 			ret);
-		return ret;
+		goto out;
 	}
 
 	mpf_bd_num = le32_to_cpu(desc_bd.data[0]);
@@ -1867,8 +1867,10 @@ static int hclge_handle_all_hw_msix_error(struct hclge_dev *hdev,
 	bd_num = max_t(u32, mpf_bd_num, pf_bd_num);
 
 	desc = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
-	if (!desc)
+	if (!desc) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	ret = hclge_handle_mpf_msix_error(hdev, desc, mpf_bd_num,
 					  reset_requests);
-- 
2.7.4

