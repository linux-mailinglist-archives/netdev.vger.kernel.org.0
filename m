Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B20725F99C
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfGDOGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:06:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8706 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727398AbfGDOGc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 10:06:32 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 27DCFB793B9BA315CA11;
        Thu,  4 Jul 2019 22:06:27 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Thu, 4 Jul 2019 22:06:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/9] net: hns3: set default value for param "type" in hclgevf_bind_ring_to_vector
Date:   Thu, 4 Jul 2019 22:04:24 +0800
Message-ID: <1562249068-40176-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
References: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

The value of param type is always not changed in
hclgevf_bind_ring_to_vector, move the assignment to
front of "for {}" can reduce the redundant assignment.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index ff7e8cb..a13a0e1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -994,6 +994,8 @@ static int hclgevf_bind_ring_to_vector(struct hnae3_handle *handle, bool en,
 	u8 type;
 
 	req = (struct hclge_mbx_vf_to_pf_cmd *)desc.data;
+	type = en ? HCLGE_MBX_MAP_RING_TO_VECTOR :
+		HCLGE_MBX_UNMAP_RING_TO_VECTOR;
 
 	for (node = ring_chain; node; node = node->next) {
 		int idx_offset = HCLGE_MBX_RING_MAP_BASIC_MSG_NUM +
@@ -1003,9 +1005,6 @@ static int hclgevf_bind_ring_to_vector(struct hnae3_handle *handle, bool en,
 			hclgevf_cmd_setup_basic_desc(&desc,
 						     HCLGEVF_OPC_MBX_VF_TO_PF,
 						     false);
-			type = en ?
-				HCLGE_MBX_MAP_RING_TO_VECTOR :
-				HCLGE_MBX_UNMAP_RING_TO_VECTOR;
 			req->msg[0] = type;
 			req->msg[1] = vector_id;
 		}
-- 
2.7.4

