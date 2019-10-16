Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF595D9C2A
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 23:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437349AbfJPVDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 17:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfJPVDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 17:03:47 -0400
Received: from localhost.localdomain (unknown [151.66.3.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16C3C20872;
        Wed, 16 Oct 2019 21:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571259827;
        bh=vdUAAXtqNJVu95HOa+bjDcfrL3e2S32QDUQ5yMeeZCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ler6LlJZSqb678ONG6oPCJRo/JR+N4YJ3gTC2ACQyrnHFC9kqCVPiu96krowybQXK
         aqbGey3GCKGogDyMYwlyJBlo6EGMfvFG3EDWvTrtctwDJ4sKRvEzA6sx18skkfUxrE
         6vZOfb3O+kUW7taEDnESzstbvjO6Q45FBk3i8Z6I=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com, jakub.kicinski@netronome.com
Subject: [PATCH v4 net-next 5/7] net: mvneta: move header prefetch in mvneta_swbm_rx_frame
Date:   Wed, 16 Oct 2019 23:03:10 +0200
Message-Id: <4e5c4c61623baedb77774ba506fa53dfc856ccac.1571258793.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571258792.git.lorenzo@kernel.org>
References: <cover.1571258792.git.lorenzo@kernel.org>
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
index 3b2c65a7c474..213b8f3eda44 100644
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

