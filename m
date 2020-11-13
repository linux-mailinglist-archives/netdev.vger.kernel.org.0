Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4822B237C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgKMSRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbgKMSRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 13:17:05 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11FE8206CA;
        Fri, 13 Nov 2020 18:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605291425;
        bh=1sTdWhb5AmwOOIax17y9cEcScgVg9NMS6HP73b6C5F0=;
        h=From:To:Cc:Subject:Date:From;
        b=WoxPgp8Elf5jB+LV4tFBJCyn4MkJqFn6mUKTfOkhLwRQ9+D9wT2GZPDVSB3VdX+b4
         NldNFUbz4jCdNjY8borlsUEcCdg/JHajXLXo6aK/+4suIVq4/AR/vC/lkZ5Y6QNn0n
         nGb43qZTGrIqwDrvJI/FBkEsNCiUcbaducM0kEbk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, ilias.apalodimas@linaro.org, echaudro@redhat.com
Subject: [PATCH net] net: mvneta: fix possible memory leak in mvneta_swbm_add_rx_fragment
Date:   Fri, 13 Nov 2020 19:16:57 +0100
Message-Id: <df6a2bad70323ee58d3901491ada31c1ca2a40b9.1605291228.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recycle the page running page_pool_put_full_page() in
mvneta_swbm_add_rx_fragment routine when the last descriptor
contains just the FCS or if the received packet contains more than
MAX_SKB_FRAGS fragments

Fixes: ca0e014609f0 ("net: mvneta: move skb build after descriptors processing")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 54b0bf574c05..4a9041ee1b39 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2287,6 +2287,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 	dma_sync_single_for_cpu(dev->dev.parent,
 				rx_desc->buf_phys_addr,
 				len, dma_dir);
+	rx_desc->buf_phys_addr = 0;
 
 	if (data_len > 0 && sinfo->nr_frags < MAX_SKB_FRAGS) {
 		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags];
@@ -2295,8 +2296,8 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
 		sinfo->nr_frags++;
-
-		rx_desc->buf_phys_addr = 0;
+	} else {
+		page_pool_put_full_page(rxq->page_pool, page, true);
 	}
 	*size -= len;
 }
-- 
2.26.2

