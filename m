Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925F827DB3F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgI2V7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728074AbgI2V7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 17:59:04 -0400
Received: from localhost.localdomain (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCCEA206D9;
        Tue, 29 Sep 2020 21:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601416744;
        bh=8jxTmGdZgN3IRo+KIJPvmxgmu/WShVwcjGvSsaJcHo0=;
        h=From:To:Cc:Subject:Date:From;
        b=fLBOf27EDqW9T7OnjpF3ircygK6kiiefsrXAYbqgXIDvYp66+z5YWmTsC3KiCkmyb
         wVdnfu9ehjq3TxxNtc/ciUi+OGOTcyj7bbN9ssEyliRs364TyTN0/saaMdRv9PexFB
         Cnf3Jxc+VepWQxxAYjfQqoSU3fHBkOterLk4WJUg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, ilias.apalodimas@linaro.org
Subject: [PATCH net-next] net: mvneta: avoid possible cache misses in mvneta_rx_swbm
Date:   Tue, 29 Sep 2020 23:58:57 +0200
Message-Id: <6284e8e13117c87470d412e930cfff23b9ce6f16.1601416347.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rx_desc pointers if possible since rx descriptors are stored in
uncached memory and dereferencing rx_desc pointers generate extra loads.
This patch improves XDP_DROP performance of ~ 110Kpps (700Kpps vs 590Kpps)
on Marvell Espressobin

Analyzed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index bb485745b72a..d095718355d3 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2236,19 +2236,22 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	enum dma_data_direction dma_dir;
 	struct skb_shared_info *sinfo;
 
-	if (rx_desc->data_size > MVNETA_MAX_RX_BUF_SIZE) {
+	if (*size > MVNETA_MAX_RX_BUF_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
 		data_len += len;
 	} else {
-		len = rx_desc->data_size;
+		len = *size;
 		data_len += len - ETH_FCS_LEN;
 	}
+	*size = *size - len;
 
 	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
 	dma_sync_single_for_cpu(dev->dev.parent,
 				rx_desc->buf_phys_addr,
 				len, dma_dir);
 
+	rx_desc->buf_phys_addr = 0;
+
 	/* Prefetch header */
 	prefetch(data);
 
@@ -2259,9 +2262,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 
 	sinfo = xdp_get_shared_info_from_buff(xdp);
 	sinfo->nr_frags = 0;
-
-	*size = rx_desc->data_size - len;
-	rx_desc->buf_phys_addr = 0;
 }
 
 static void
@@ -2375,7 +2375,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 
 			size = rx_desc->data_size;
 			frame_sz = size - ETH_FCS_LEN;
-			desc_status = rx_desc->status;
+			desc_status = rx_status;
 
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
 					     &size, page);
-- 
2.26.2

