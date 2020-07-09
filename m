Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F6D21A430
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 17:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgGIP5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 11:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgGIP5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 11:57:48 -0400
Received: from localhost.localdomain.com (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C1C207DD;
        Thu,  9 Jul 2020 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594310267;
        bh=0E6lajcEknoqulDOhEMKppla4drvU7gytPYmfUFp0UA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V++Zxuo5umKbZJYWXgBRLTFXXg4kXcRLZZnq20g1BXRstuSTnYRoIVAsig/KtwV4I
         njRgpEOQokXpc3oz03db8GcRkU/sBbzpcJ1uns0Nryx+9vVKBZPY9Ei8/yYPpnxosK
         21ZsHjjRdGdUAmnp5w7SnzaUerITyoYy3+xjy+jE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, bpf@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, echaudro@redhat.com, sameehj@amazon.com
Subject: [PATCH 5/6] net: mvneta: get rid of skb in mvneta_rx_queue
Date:   Thu,  9 Jul 2020 17:57:22 +0200
Message-Id: <99f6e0a7fe5d2e196e4ed80ff398ff1dd022a5ea.1594309075.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1594309075.git.lorenzo@kernel.org>
References: <cover.1594309075.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove skb pointer in mvneta_rx_queue data structure since it is no
longer used

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f75a45ad586c..1a0f34a9c01e 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -699,8 +699,6 @@ struct mvneta_rx_queue {
 	int first_to_refill;
 	u32 refill_num;
 
-	/* pointer to uncomplete skb buffer */
-	struct sk_buff *skb;
 	int left_size;
 };
 
@@ -3361,9 +3359,6 @@ static void mvneta_rxq_deinit(struct mvneta_port *pp,
 {
 	mvneta_rxq_drop_pkts(pp, rxq);
 
-	if (rxq->skb)
-		dev_kfree_skb_any(rxq->skb);
-
 	if (rxq->descs)
 		dma_free_coherent(pp->dev->dev.parent,
 				  rxq->size * MVNETA_DESC_ALIGNED_SIZE,
@@ -3376,7 +3371,6 @@ static void mvneta_rxq_deinit(struct mvneta_port *pp,
 	rxq->descs_phys        = 0;
 	rxq->first_to_refill   = 0;
 	rxq->refill_num        = 0;
-	rxq->skb               = NULL;
 	rxq->left_size         = 0;
 }
 
-- 
2.26.2

