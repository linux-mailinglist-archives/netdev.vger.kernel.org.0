Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E6D13A732
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 11:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgANKVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 05:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbgANKVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 05:21:30 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69AA1207FF;
        Tue, 14 Jan 2020 10:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578997289;
        bh=W+VouGhC9dnBadzQYC8FI5x/zQS2ag+mp3wf4G01YgU=;
        h=From:To:Cc:Subject:Date:From;
        b=TSv21puvsqdWVycZ5gLlLEWa79aPXyec7Bt1G187qEDm6qrEhCMj+EqftXpQJMg/0
         YZmEjFNxCsS5eNizTq+S816pq9RZXqnh7pvUdpO19SQjKy25nvPIjBN1n3e5edguuT
         f7XDv2NwQUqzW+dmNoh6PnSUE8CGObuynX3IxDs4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        brouer@redhat.com, ilias.apalodimas@linaro.org, kuba@kernel.org
Subject: [PATCH net] net: mvneta: fix dma sync size in mvneta_run_xdp
Date:   Tue, 14 Jan 2020 11:21:16 +0100
Message-Id: <c73de2bf79cc3d2f6d4f8c8864ff6a64198db2c8.1578996931.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Page pool API will start syncing (if requested) starting from
page->dma_addr + pool->p.offset. Fix dma sync length in
mvneta_run_xdp since we do not need to account xdp headroom

Fixes: 07e13edbb6a6 ("net: mvneta: get rid of huge dma sync in mvneta_rx_refill")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 71a872d46bc4..67ad8b8b127d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2081,7 +2081,11 @@ static int
 mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	       struct bpf_prog *prog, struct xdp_buff *xdp)
 {
-	u32 ret, act = bpf_prog_run_xdp(prog, xdp);
+	unsigned int len;
+	u32 ret, act;
+
+	len = xdp->data_end - xdp->data_hard_start - pp->rx_offset_correction;
+	act = bpf_prog_run_xdp(prog, xdp);
 
 	switch (act) {
 	case XDP_PASS:
@@ -2094,9 +2098,8 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		if (err) {
 			ret = MVNETA_XDP_DROPPED;
 			__page_pool_put_page(rxq->page_pool,
-					virt_to_head_page(xdp->data),
-					xdp->data_end - xdp->data_hard_start,
-					true);
+					     virt_to_head_page(xdp->data),
+					     len, true);
 		} else {
 			ret = MVNETA_XDP_REDIR;
 		}
@@ -2106,9 +2109,8 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		ret = mvneta_xdp_xmit_back(pp, xdp);
 		if (ret != MVNETA_XDP_TX)
 			__page_pool_put_page(rxq->page_pool,
-					virt_to_head_page(xdp->data),
-					xdp->data_end - xdp->data_hard_start,
-					true);
+					     virt_to_head_page(xdp->data),
+					     len, true);
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
@@ -2119,8 +2121,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	case XDP_DROP:
 		__page_pool_put_page(rxq->page_pool,
 				     virt_to_head_page(xdp->data),
-				     xdp->data_end - xdp->data_hard_start,
-				     true);
+				     len, true);
 		ret = MVNETA_XDP_DROPPED;
 		break;
 	}
-- 
2.21.1

