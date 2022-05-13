Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F477525C29
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 09:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377698AbiEMHMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 03:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377700AbiEMHL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 03:11:56 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE293A199;
        Fri, 13 May 2022 00:11:51 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L00Ct4pc9z1JBmB;
        Fri, 13 May 2022 15:10:34 +0800 (CST)
Received: from container.huawei.com (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 15:11:48 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <vburru@marvell.com>, <aayarekar@marvell.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] octeon_ep: delete unnecessary NULL check
Date:   Fri, 13 May 2022 15:29:28 +0800
Message-ID: <20220513072928.3713739-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vfree(NULL) is safe. NULL check before vfree() is not needed.
Delete them to simplify the code.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 3 +--
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c   | 3 +--
 drivers/net/ethernet/marvell/octeon_ep/octep_tx.c   | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index e020c81f3455..7e590c572d58 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -980,8 +980,7 @@ static void octep_device_cleanup(struct octep_device *oct)
 	dev_info(&oct->pdev->dev, "Cleaning up Octeon Device ...\n");
 
 	for (i = 0; i < OCTEP_MAX_VF; i++) {
-		if (oct->mbox[i])
-			vfree(oct->mbox[i]);
+		vfree(oct->mbox[i]);
 		oct->mbox[i] = NULL;
 	}
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
index 945947ec7723..d9ae0937d17a 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -230,8 +230,7 @@ static int octep_free_oq(struct octep_oq *oq)
 
 	octep_oq_free_ring_buffers(oq);
 
-	if (oq->buff_info)
-		vfree(oq->buff_info);
+	vfree(oq->buff_info);
 
 	if (oq->desc_ring)
 		dma_free_coherent(oq->dev,
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
index 511552bc3e87..5a520d37bea0 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
@@ -270,8 +270,7 @@ static void octep_free_iq(struct octep_iq *iq)
 
 	desc_ring_size = OCTEP_IQ_DESC_SIZE * CFG_GET_IQ_NUM_DESC(oct->conf);
 
-	if (iq->buff_info)
-		vfree(iq->buff_info);
+	vfree(iq->buff_info);
 
 	if (iq->desc_ring)
 		dma_free_coherent(iq->dev, desc_ring_size,
-- 
2.25.1

