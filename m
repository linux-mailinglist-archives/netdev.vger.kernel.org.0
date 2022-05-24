Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828FA532190
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 05:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbiEXD2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 23:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiEXD2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 23:28:43 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E259C50E3A;
        Mon, 23 May 2022 20:28:39 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 24 May
 2022 11:28:38 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Tue, 24 May
 2022 11:28:37 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     <joe@perches.com>
CC:     <aayarekar@marvell.com>, <baihaowen@meizu.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <vburru@marvell.com>
Subject: [PATCH V2] octeon_ep: Remove unnecessary cast
Date:   Tue, 24 May 2022 11:28:35 +0800
Message-ID: <1653362915-22831-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <53b4a92efb83d893230f47ae9988282f3875b355.camel@perches.com>
References: <53b4a92efb83d893230f47ae9988282f3875b355.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

./drivers/net/ethernet/marvell/octeon_ep/octep_rx.c:161:18-40: WARNING:
casting value returned by memory allocation function to (struct
octep_rx_buffer *) is useless.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
V1->V2: change vzalloc to vcalloc as suggestion.

 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
index d9ae0937d17a..3c43f8078528 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -158,8 +158,7 @@ static int octep_setup_oq(struct octep_device *oct, int q_no)
 		goto desc_dma_alloc_err;
 	}
 
-	oq->buff_info = (struct octep_rx_buffer *)
-			vzalloc(oq->max_count * OCTEP_OQ_RECVBUF_SIZE);
+	oq->buff_info = vcalloc(oq->max_count, OCTEP_OQ_RECVBUF_SIZE);
 	if (unlikely(!oq->buff_info)) {
 		dev_err(&oct->pdev->dev,
 			"Failed to allocate buffer info for OQ-%d\n", q_no);
-- 
2.7.4

