Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150074E7FFB
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 09:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiCZIR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 04:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiCZIRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 04:17:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4D81FF23E;
        Sat, 26 Mar 2022 01:15:48 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KQWvQ3CF3zfZgW;
        Sat, 26 Mar 2022 16:14:10 +0800 (CST)
Received: from huawei.com (10.175.112.208) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Sat, 26 Mar
 2022 16:15:45 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH] net: sparx5: switchdev: fix possible NULL pointer dereference
Date:   Sat, 26 Mar 2022 08:12:39 +0000
Message-ID: <20220326081239.9168-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the possible failure of the allocation, devm_kzalloc() may return NULL
pointer.
Therefore, it should be better to check the 'db' in order to prevent
the dereference of NULL pointer.

Fixes: 10615907e9b51 ("net: sparx5: switchdev: adding frame DMA functionality")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index 7436f62fa152..174ad95e746a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -420,6 +420,8 @@ static int sparx5_fdma_tx_alloc(struct sparx5 *sparx5)
 			db_hw->dataptr = phys;
 			db_hw->status = 0;
 			db = devm_kzalloc(sparx5->dev, sizeof(*db), GFP_KERNEL);
+			if (!db)
+				return -ENOMEM;
 			db->cpu_addr = cpu_addr;
 			list_add_tail(&db->list, &tx->db_list);
 		}
-- 
2.17.1

