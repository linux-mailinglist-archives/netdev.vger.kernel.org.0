Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C3C49E507
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiA0OsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:48:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50528 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238149AbiA0OsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:48:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A866161D1D
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB02C340E4;
        Thu, 27 Jan 2022 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643294902;
        bh=9v1JR45R9SGQZksUjYPWMJEwBL4thRlgMtlhcLeXyYU=;
        h=From:To:Cc:Subject:Date:From;
        b=e9ckg71CYquDghS0Y4nHwfH4yf0TTvYF5evs+CZGF/2Vwbd3DxECe0DtaPillxEgz
         Hfe3HfsnqZWEZHypzy4UBvd1QuZeoMfH7LRidOFikfPAD5mkRT6ohGD3o8KPmivPBH
         7hkFVjgZcwQs4d2SNLuJ8QGH+anm16hUnJoztM7D+Qznjoum1vcxevgO5Zb6DBDMvi
         NVGT5OROTMzayBAbnt57/7sZE57dBdb4l0Yc/E+QcE6KJoVy96GR3tRQ7zA2PS/Y5D
         FKyQxNTD3EI87ngJOlnIz18R960dTaKr92YsCtjDgqCWZkZ4BHiYaSGF2gAradPb1K
         9dAWLAbkH/u1g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, kuba@kernel.org, dan.carpenter@oracle.com
Subject: [PATCH net-next] net: mvneta: remove unnecessary if condition in mvneta_xdp_submit_frame
Date:   Thu, 27 Jan 2022 15:47:49 +0100
Message-Id: <d7b846d1caf1f59612eead3d8760e7a6913695ba.1643294657.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of unnecessary if check on tx_desc pointer in
mvneta_xdp_submit_frame routine since num_frames is always greater than
0 and tx_desc pointer is always initialized.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 315a43e4c63d..f1335a1ed695 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2083,7 +2083,7 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
 	struct device *dev = pp->dev->dev.parent;
-	struct mvneta_tx_desc *tx_desc = NULL;
+	struct mvneta_tx_desc *tx_desc;
 	int i, num_frames = 1;
 	struct page *page;
 
@@ -2140,10 +2140,8 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 
 		mvneta_txq_inc_put(txq);
 	}
-
 	/*last descriptor */
-	if (likely(tx_desc))
-		tx_desc->command |= MVNETA_TXD_L_DESC | MVNETA_TXD_Z_PAD;
+	tx_desc->command |= MVNETA_TXD_L_DESC | MVNETA_TXD_Z_PAD;
 
 	txq->pending += num_frames;
 	txq->count += num_frames;
-- 
2.34.1

