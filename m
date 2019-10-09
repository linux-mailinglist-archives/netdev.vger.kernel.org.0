Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17152D1C9A
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732466AbfJIXTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731072AbfJIXTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 19:19:09 -0400
Received: from localhost.localdomain (unknown [151.66.37.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3FB4206C0;
        Wed,  9 Oct 2019 23:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570663148;
        bh=mHOEu+Fp9TA19zNJiWWuav+GG+VahHAEeiTVcSao14I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKvquttjzCovMp+9NnK0VaB2swQpITV5S46zS1gNyonFNQ7SaD6G0x3iiSM9qGF5u
         P241LbLEZDMh3pjv146C5MDWISj6ZxFiFW/e3zNPWGXXsWfSQDNe0souxyqqa6ngiy
         XrKZ3gG/zd/OqAqtk8HAVWbLzKymgEus7WYL/Ol4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: [PATCH v2 net-next 4/8] net: mvneta: sync dma buffers before refilling hw queues
Date:   Thu, 10 Oct 2019 01:18:34 +0200
Message-Id: <744e01ea2c93200765ba8a77f0e6b0ca6baca513.1570662004.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1570662004.git.lorenzo@kernel.org>
References: <cover.1570662004.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mvneta driver can run on not cache coherent devices so it is
necessary to sync dma buffers before sending them to the device
in order to avoid memory corruption. This patch introduce a performance
penalty and it is necessary to introduce a more sophisticated logic
in order to avoid dma sync as much as we can

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 79a6bac0192b..ba4aa9bbc798 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1821,6 +1821,7 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
 			    struct mvneta_rx_queue *rxq,
 			    gfp_t gfp_mask)
 {
+	enum dma_data_direction dma_dir;
 	dma_addr_t phys_addr;
 	struct page *page;
 
@@ -1830,6 +1831,9 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
 		return -ENOMEM;
 
 	phys_addr = page_pool_get_dma_addr(page) + pp->rx_offset_correction;
+	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
+	dma_sync_single_for_device(pp->dev->dev.parent, phys_addr,
+				   MVNETA_MAX_RX_BUF_SIZE, dma_dir);
 	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
 
 	return 0;
-- 
2.21.0

