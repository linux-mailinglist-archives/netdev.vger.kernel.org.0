Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A0A2B1A81
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgKMMDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:03:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726854AbgKMLtd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 06:49:33 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF2202224F;
        Fri, 13 Nov 2020 11:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605268132;
        bh=X/652KcX1ghKM3MixANJqmPxus5xOB2yI+S3x9cOI5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkU6zbuIpGTyIkwTi7dtxtDKxfL/4q6FOobtFHCc9SzMBtRYUSAe2ydN0bzyCuntv
         k/X0wTWWph/aq9D3Gw2UD0jYqUl3LfROOHuflKpfKE2CY00NOn/VUzQh4fqFdALvpz
         qaYkALjAOGi4zP10aU1SibIkvM/FS0agA8jul8sk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, john.fastabend@gmail.com
Subject: [PATCH v6 net-nex 3/5] net: mvneta: add xdp tx return bulking support
Date:   Fri, 13 Nov 2020 12:48:30 +0100
Message-Id: <9af8014006d022fc0fec78cdaa71beb56999750d.1605267335.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1605267335.git.lorenzo@kernel.org>
References: <cover.1605267335.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mvneta driver to xdp_return_frame_bulk APIs.

XDP_REDIRECT (upstream codepath): 275Kpps
XDP_REDIRECT (upstream codepath + bulking APIs): 284Kpps

Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 54b0bf574c05..183530ed4d1d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1834,8 +1834,13 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 				 struct netdev_queue *nq, bool napi)
 {
 	unsigned int bytes_compl = 0, pkts_compl = 0;
+	struct xdp_frame_bulk bq;
 	int i;
 
+	xdp_frame_bulk_init(&bq);
+
+	rcu_read_lock(); /* need for xdp_return_frame_bulk */
+
 	for (i = 0; i < num; i++) {
 		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_get_index];
 		struct mvneta_tx_desc *tx_desc = txq->descs +
@@ -1857,9 +1862,12 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 			if (napi && buf->type == MVNETA_TYPE_XDP_TX)
 				xdp_return_frame_rx_napi(buf->xdpf);
 			else
-				xdp_return_frame(buf->xdpf);
+				xdp_return_frame_bulk(buf->xdpf, &bq);
 		}
 	}
+	xdp_flush_frame_bulk(&bq);
+
+	rcu_read_unlock();
 
 	netdev_tx_completed_queue(nq, pkts_compl, bytes_compl);
 }
-- 
2.26.2

