Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605D92C28A
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfE1JFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:05:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17610 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbfE1JEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:04:38 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 553566C73F7D2B25D6E7;
        Tue, 28 May 2019 17:04:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 28 May 2019 17:04:28 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>
Subject: [PATCH net-next 12/12] net: hns3: fix a memory leak issue for hclge_map_unmap_ring_to_vf_vector
Date:   Tue, 28 May 2019 17:03:02 +0800
Message-ID: <1559034182-24737-13-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
References: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When hclge_bind_ring_with_vector() fails,
hclge_map_unmap_ring_to_vf_vector() returns the error
directly, so nobody will free the memory allocated by
hclge_get_ring_chain_from_mbx().

So hclge_free_vector_ring_chain() should be called no matter
hclge_bind_ring_with_vector() fails or not.

Fixes: 84e095d64ed9 ("net: hns3: Change PF to add ring-vect binding & resetQ to mailbox")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 0e04e63..d20f017 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -192,12 +192,10 @@ static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
 		return ret;
 
 	ret = hclge_bind_ring_with_vector(vport, vector_id, en, &ring_chain);
-	if (ret)
-		return ret;
 
 	hclge_free_vector_ring_chain(&ring_chain);
 
-	return 0;
+	return ret;
 }
 
 static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
-- 
2.7.4

