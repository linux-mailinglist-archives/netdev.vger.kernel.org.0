Return-Path: <netdev+bounces-1418-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC9666FDB75
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEC7F1C20CFB
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744B87460;
	Wed, 10 May 2023 10:15:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E13569C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:15:59 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025781BCA
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3neK9KLueYQQg1ADiQjAOBvrtgWH+eq2gSP7XNzc7oY=; b=yWCZiWn7/kyVMkkJzzUnZFWgyp
	CT8/1jy0b8EDvWgqNU7pJsEIsPeNn+ceuNP4zi2uN4c+8PG2sWj2EEY8ODt5KyhujBcBvLBaBTyfL
	2ZYmOvBXHjdLasaEhf7bsxRoFRk88TEO3FR7MUQcSV6cY+myIZ0X/jxz6MqUZWuQFKB1QYDex8pVx
	qmNyoa8SWa4pu4f9CIk/Hj/t1Wf+yDVWldSc/2FjN4x27sPWHRCFYPd0p4XiNu9Jf+SyRDD1Tr3uG
	qiKYK3xQr48HCzTjWnjQASRV8upXsgcIh42MHrLsIHoAodjegcawVtpE9VYlLl0G3DFGtlHlEkQBE
	H1hK5X2w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42506 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pwgrR-0004jw-Tr; Wed, 10 May 2023 11:15:53 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pwgrR-001XDy-8S; Wed, 10 May 2023 11:15:53 +0100
In-Reply-To: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk>
References: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	 Eric Dumazet <edumazet@google.com>,
	 Jakub Kicinski <kuba@kernel.org>,
	 netdev@vger.kernel.org,
	 Paolo Abeni <pabeni@redhat.com>,
	 Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH net-next 3/5] net: mvneta: use buf->type to determine whether
 to dma-unmap
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pwgrR-001XDy-8S@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 10 May 2023 11:15:53 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Now that we use a different buffer type for TSO headers, we can use
buf->type to determine whether the original buffer was DMA-mapped or
not. The rules are:

	MVNETA_TYPE_XDP_TX - from a DMA pool, no unmap is required
	MVNETA_TYPE_XDP_NDO - dma_map_single()'d
	MVNETA_TYPE_SKB - normal skbuff, dma_map_single()'d
	MVNETA_TYPE_TSO - from the TSO buffer area

This means we only need to call dma_unmap_single() on the XDP_NDO and
SKB types of buffer, and we no longer need the private IS_TSO_HEADER()
which relies on the TSO region being contiguously allocated.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c05649f33d18..c23d75af65ee 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -364,10 +364,6 @@
 			 MVNETA_SKB_HEADROOM))
 #define MVNETA_MAX_RX_BUF_SIZE	(PAGE_SIZE - MVNETA_SKB_PAD)
 
-#define IS_TSO_HEADER(txq, addr) \
-	((addr >= txq->tso_hdrs_phys) && \
-	 (addr < txq->tso_hdrs_phys + txq->size * TSO_HEADER_SIZE))
-
 #define MVNETA_RX_GET_BM_POOL_ID(rxd) \
 	(((rxd)->status & MVNETA_RXD_BM_POOL_MASK) >> MVNETA_RXD_BM_POOL_SHIFT)
 
@@ -1879,8 +1875,8 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 
 		mvneta_txq_inc_get(txq);
 
-		if (!IS_TSO_HEADER(txq, tx_desc->buf_phys_addr) &&
-		    buf->type != MVNETA_TYPE_XDP_TX)
+		if (buf->type == MVNETA_TYPE_XDP_NDO ||
+		    buf->type == MVNETA_TYPE_SKB)
 			dma_unmap_single(pp->dev->dev.parent,
 					 tx_desc->buf_phys_addr,
 					 tx_desc->data_size, DMA_TO_DEVICE);
@@ -2728,8 +2724,9 @@ static void mvneta_release_descs(struct mvneta_port *pp,
 
 	for (i = num; i >= 0; i--) {
 		struct mvneta_tx_desc *tx_desc = txq->descs + desc_idx;
+		struct mvneta_tx_buf *buf = &txq->buf[desc_idx];
 
-		if (!IS_TSO_HEADER(txq, tx_desc->buf_phys_addr))
+		if (buf->type == MVNETA_TYPE_SKB)
 			dma_unmap_single(pp->dev->dev.parent,
 					 tx_desc->buf_phys_addr,
 					 tx_desc->data_size,
-- 
2.30.2


