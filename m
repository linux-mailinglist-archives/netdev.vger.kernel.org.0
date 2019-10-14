Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0CCD6093
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 12:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbfJNKut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 06:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731449AbfJNKus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 06:50:48 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAADD20873;
        Mon, 14 Oct 2019 10:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571050247;
        bh=pV2PH2KLT5EdywTUxlWQt4uRWS0e+82dOXBzKjESo8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nB3cH4LDC1BsPkwxKTkPexiscsnv1rudDc/yYLKA4D/O3unrqu6PU5FT3MQ7zvZyB
         pSNFVIFYIefg2wra+c2tMDuPyoZr4OhhMbjLMzeS4ULWpieKxDeawplBopPYF5TT+u
         d14OXb+qm+j+0nAcqyqwUy3PFXPF2QBy7kqIyxDE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: [PATCH v3 net-next 6/8] net: mvneta: move header prefetch in mvneta_swbm_rx_frame
Date:   Mon, 14 Oct 2019 12:49:53 +0200
Message-Id: <67ecff86072e0aad7ce73452af9e9a830818f0d5.1571049326.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571049326.git.lorenzo@kernel.org>
References: <cover.1571049326.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move data buffer prefetch in mvneta_swbm_rx_frame after
dma_sync_single_range_for_cpu

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index b47a44cf9610..a79d81c9be7a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2024,6 +2024,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 				rx_desc->buf_phys_addr,
 				len, dma_dir);
 
+	/* Prefetch header */
+	prefetch(data);
+
 	xdp->data_hard_start = data;
 	xdp->data = data + MVNETA_SKB_HEADROOM + MVNETA_MH_SIZE;
 	xdp->data_end = xdp->data + data_len;
@@ -2119,15 +2122,11 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	/* Fairness NAPI loop */
 	while (done < budget && done < rx_pending) {
 		struct mvneta_rx_desc *rx_desc = mvneta_rxq_next_desc_get(rxq);
-		unsigned char *data;
 		struct page *page;
 		int index;
 
 		index = rx_desc - rxq->descs;
 		page = (struct page *)rxq->buf_virt_addr[index];
-		data = page_address(page);
-		/* Prefetch header */
-		prefetch(data);
 
 		rxq->refill_num++;
 		done++;
-- 
2.21.0

