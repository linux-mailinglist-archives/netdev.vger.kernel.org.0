Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40836312AC
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 07:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiKTGSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 01:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKTGSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 01:18:00 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325ED4C244
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 22:18:00 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NFKwZ3wWdzqSPs;
        Sun, 20 Nov 2022 14:14:06 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 20 Nov 2022 14:17:58 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jeffrey.t.kirsher@intel.com>,
        <alexander.h.duyck@intel.com>, <cuigaosheng1@huawei.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: [PATCH net] intel/igbvf: free irq on the error path in igbvf_request_msix()
Date:   Sun, 20 Nov 2022 14:17:57 +0800
Message-ID: <20221120061757.264242-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In igbvf_request_msix(), irqs have not been freed on the err path,
we need to free it. Fix it.

Fixes: d4e0fe01a38a ("igbvf: add new driver to support 82576 virtual functions")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 3a32809510fc..e212ca16df00 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -1074,7 +1074,7 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
 			  igbvf_intr_msix_rx, 0, adapter->rx_ring->name,
 			  netdev);
 	if (err)
-		goto out;
+		goto free_irq1;
 
 	adapter->rx_ring->itr_register = E1000_EITR(vector);
 	adapter->rx_ring->itr_val = adapter->current_itr;
@@ -1083,10 +1083,14 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
 	err = request_irq(adapter->msix_entries[vector].vector,
 			  igbvf_msix_other, 0, netdev->name, netdev);
 	if (err)
-		goto out;
+		goto free_irq2;
 
 	igbvf_configure_msix(adapter);
 	return 0;
+free_irq2:
+	free_irq(adapter->msix_entries[--vector].vector, netdev);
+free_irq1:
+	free_irq(adapter->msix_entries[--vector].vector, netdev);
 out:
 	return err;
 }
-- 
2.25.1

