Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC8C408C3B
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbhIMNQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:16:10 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9423 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236206AbhIMNNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:13:50 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H7Rc33kMLz8yV0;
        Mon, 13 Sep 2021 21:08:03 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 21:12:28 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 21:12:28 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 1/6] net: hns3: add option to turn off page pool feature
Date:   Mon, 13 Sep 2021 21:08:20 +0800
Message-ID: <20210913130825.27025-2-huangguangbin2@huawei.com>
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

From: Yunsheng Lin <linyunsheng@huawei.com>

When page pool is added to the hns3 driver, it is always
enabled unconditionally, which means spilt page handling
in the hns3 driver is dead code.

As there is a requirement to test the performance between
spilt page handling in driver and page pool, so add a module
param to support disabling the page pool.

When the page pool is proved to perform better in most case,
the spilt page handling in driver can be removed.

Fixes: 93188e9642c3 ("net: hns3: support skb's frag page recycling based on page pool")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 22af3d6ce178..293243bbe407 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -61,6 +61,9 @@ static unsigned int tx_sgl = 1;
 module_param(tx_sgl, uint, 0600);
 MODULE_PARM_DESC(tx_sgl, "Minimum number of frags when using dma_map_sg() to optimize the IOMMU mapping");
 
+static bool page_pool_enabled = true;
+module_param(page_pool_enabled, bool, 0400);
+
 #define HNS3_SGL_SIZE(nfrag)	(sizeof(struct scatterlist) * (nfrag) +	\
 				 sizeof(struct sg_table))
 #define HNS3_MAX_SGL_SIZE	ALIGN(HNS3_SGL_SIZE(HNS3_MAX_TSO_BD_NUM), \
@@ -4753,7 +4756,8 @@ static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
 		goto out_with_desc_cb;
 
 	if (!HNAE3_IS_TX_RING(ring)) {
-		hns3_alloc_page_pool(ring);
+		if (page_pool_enabled)
+			hns3_alloc_page_pool(ring);
 
 		ret = hns3_alloc_ring_buffers(ring);
 		if (ret)
-- 
2.33.0

