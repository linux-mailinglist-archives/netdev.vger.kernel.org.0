Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A226422F4
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 07:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiLEGRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 01:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiLEGRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 01:17:41 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83CC25F
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 22:17:38 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NQYGq0lTlz15N5G;
        Mon,  5 Dec 2022 14:16:51 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 5 Dec
 2022 14:17:36 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <ioana.ciornei@nxp.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH] dpaa2-switch: Fix memory leak in dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove()
Date:   Mon, 5 Dec 2022 06:15:15 +0000
Message-ID: <20221205061515.115012-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cmd_buff needs to be freed when error happened in
dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove().

Fixes: 1110318d83e8 ("dpaa2-switch: add tc flower hardware offload on ingress traffic")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index cacd454ac696..c39b866e2582 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -132,6 +132,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 						 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
 		dev_err(dev, "DMA mapping failed\n");
+		kfree(cmd_buff);
 		return -EFAULT;
 	}
 
@@ -142,6 +143,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 			 DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
+		kfree(cmd_buff);
 		return err;
 	}
 
@@ -172,6 +174,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
 						 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
 		dev_err(dev, "DMA mapping failed\n");
+		kfree(cmd_buff);
 		return -EFAULT;
 	}
 
@@ -182,6 +185,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
 			 DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_remove_entry() failed %d\n", err);
+		kfree(cmd_buff);
 		return err;
 	}
 
-- 
2.17.1

