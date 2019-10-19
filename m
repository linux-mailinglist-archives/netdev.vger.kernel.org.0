Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D663FDD755
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 10:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbfJSIOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 04:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfJSIOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 04:14:00 -0400
Received: from localhost.localdomain (unknown [151.66.3.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADB49222C2;
        Sat, 19 Oct 2019 08:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571472840;
        bh=0TaHYjFLzo+VLcXm+jMoqFeEBjjFzS+Bn5onpi8CzxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmdUYnoOtGYyccyJ3SnWFLUH/6Xm2Jj+r1TOc+p1u/zeJLNBJUNtjqnBtVY1SvS6C
         hm0Jr0Q764IPVWs4qlWLfiFwVf+VNKjJXRltj49XnOzd4W3sviqhPeRhh9JcPXfKER
         p+ZcSO85I9OxLZed/CJV8GfExY3JR8AmAKvhvzbY=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com, jakub.kicinski@netronome.com
Subject: [PATCH v5 net-next 5/7] net: mvneta: move header prefetch in mvneta_swbm_rx_frame
Date:   Sat, 19 Oct 2019 10:13:25 +0200
Message-Id: <31256b3f92b49cb1f652cc858261d8ba4de4801f.1571472169.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571472169.git.lorenzo@kernel.org>
References: <cover.1571472169.git.lorenzo@kernel.org>
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
index 7ca3cd16d781..64f59baa2a3c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2025,6 +2025,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 				rx_desc->buf_phys_addr,
 				len, dma_dir);
 
+	/* Prefetch header */
+	prefetch(data);
+
 	xdp->data_hard_start = data;
 	xdp->data = data + MVNETA_SKB_HEADROOM + MVNETA_MH_SIZE;
 	xdp->data_end = xdp->data + data_len;
@@ -2122,14 +2125,10 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	while (rx_proc < budget && rx_proc < rx_todo) {
 		struct mvneta_rx_desc *rx_desc = mvneta_rxq_next_desc_get(rxq);
 		u32 rx_status, index;
-		unsigned char *data;
 		struct page *page;
 
 		index = rx_desc - rxq->descs;
 		page = (struct page *)rxq->buf_virt_addr[index];
-		data = page_address(page);
-		/* Prefetch header */
-		prefetch(data);
 
 		rx_status = rx_desc->status;
 		rx_proc++;
-- 
2.21.0

