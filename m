Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCAF115CF9A
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 02:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgBNBye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 20:54:34 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10171 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728335AbgBNByJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 20:54:09 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A6633F51318AC8064A0B;
        Fri, 14 Feb 2020 09:54:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Fri, 14 Feb 2020 09:54:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 2/3] net: hns3: fix VF bandwidth does not take effect in some case
Date:   Fri, 14 Feb 2020 09:53:42 +0800
Message-ID: <1581645223-23038-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1581645223-23038-1-git-send-email-tanhuazhong@huawei.com>
References: <1581645223-23038-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

When enabling 4 TC after setting the bandwidth of VF, the bandwidth
of VF will resume to default value, because of the qset resources
changed in this case.

This patch fixes it by using a fixed VF's qset resources according to
HNAE3_MAX_TC macro.

Fixes: ee9e44248f52 ("net: hns3: add support for configuring bandwidth of VF on the host")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 180224e..28db132 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -566,7 +566,7 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 	 */
 	kinfo->num_tc = vport->vport_id ? 1 :
 			min_t(u16, vport->alloc_tqps, hdev->tm_info.num_tc);
-	vport->qs_offset = (vport->vport_id ? hdev->tm_info.num_tc : 0) +
+	vport->qs_offset = (vport->vport_id ? HNAE3_MAX_TC : 0) +
 				(vport->vport_id ? (vport->vport_id - 1) : 0);
 
 	max_rss_size = min_t(u16, hdev->rss_size_max,
-- 
2.7.4

