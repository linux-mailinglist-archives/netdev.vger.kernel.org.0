Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B283270830
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgIRV0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgIRV0H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 17:26:07 -0400
Received: from lore-desk.redhat.com (unknown [151.66.80.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD3AD222BB;
        Fri, 18 Sep 2020 21:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600464367;
        bh=DAZc0mUFwepPzLk8WiHLVZ1RRuQ2IoUVHYFnj9o/U4A=;
        h=From:To:Cc:Subject:Date:From;
        b=Jv1r7NB3u4r51pW2W6L/esxnPWtMo56IgoO9iz8fb4bmIl4qpE3SpvYfDsdekEi6W
         JrtVBWqiWPBysnnt4KwvjzehNpYandkQA8a9fWGuFAf78AzXo0kZoMvvSmlv2sbBs5
         bgwUnGtbv1EqHVRjk04KpYUt4xlrs66uCE6uG8Yg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, thomas.petazzoni@bootlin.com
Subject: [PATCH net] net: mvneta: recycle the page in case of out-of-order
Date:   Fri, 18 Sep 2020 23:25:56 +0200
Message-Id: <7c7de42afecf5935006ec0dc845534c065d05b65.1600464120.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recycle the received page into the page_pool cache if the dma descriptors
arrived in a wrong order

Fixes: ca0e014609f05 ("net: mvneta: move skb build after descriptors processing")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 69a900081165..c4345e3d616f 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2383,8 +2383,12 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
 					     &size, page, &ps);
 		} else {
-			if (unlikely(!xdp_buf.data_hard_start))
+			if (unlikely(!xdp_buf.data_hard_start)) {
+				rx_desc->buf_phys_addr = 0;
+				page_pool_put_full_page(rxq->page_pool, page,
+							true);
 				continue;
+			}
 
 			mvneta_swbm_add_rx_fragment(pp, rx_desc, rxq, &xdp_buf,
 						    &size, page);
-- 
2.26.2

