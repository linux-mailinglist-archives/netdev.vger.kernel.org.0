Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684CC2BB129
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbgKTRGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728223AbgKTRGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 12:06:18 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B03B52225B;
        Fri, 20 Nov 2020 17:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605891976;
        bh=nSj88FBcp1WSuiTw1D70+ian/NVTZr4S4PTnuLkYEYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nF6ybdm1Gp9634FrmXd6f0izqEIhvW75hD2d6FRc8UP8EHg+ds5NDFFe86xLQ2UY5
         EKOI48EN8srvGv/3cFePbH7ieV0ml+AhIcsBmkPW8ImQNy5qGipysgVGOzlFUGEEd0
         oYz+Qzfap38qjKbeNWKWxxyCGCj5sBE99XiIl5UM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, john.fastabend@gmail.com
Subject: [PATCH net-next 1/3] net: mvneta: avoid unnecessary xdp_buff initialization
Date:   Fri, 20 Nov 2020 18:05:42 +0100
Message-Id: <611eb5973eb88b0a7a342f44c818b3bcb6e94c8c.1605889259.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1605889258.git.lorenzo@kernel.org>
References: <cover.1605889258.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explicitly initialize mandatory fields defining xdp_buff struct
in mvneta_rx_swbm routine

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 5d559117f78c..60a285f3a55f 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2347,13 +2347,14 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 {
 	int rx_proc = 0, rx_todo, refill, size = 0;
 	struct net_device *dev = pp->dev;
-	struct xdp_buff xdp_buf = {
-		.frame_sz = PAGE_SIZE,
-		.rxq = &rxq->xdp_rxq,
-	};
 	struct mvneta_stats ps = {};
 	struct bpf_prog *xdp_prog;
 	u32 desc_status, frame_sz;
+	struct xdp_buff xdp_buf;
+
+	xdp_buf.data_hard_start = NULL;
+	xdp_buf.frame_sz = PAGE_SIZE;
+	xdp_buf.rxq = &rxq->xdp_rxq;
 
 	/* Get number of received packets */
 	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
-- 
2.26.2

