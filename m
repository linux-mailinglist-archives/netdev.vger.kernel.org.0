Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26903222F17
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgGPXfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgGPXfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 19:35:17 -0400
Received: from localhost.localdomain.com (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CE8A2088E;
        Thu, 16 Jul 2020 22:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594937835;
        bh=STQ6Do2lWIqjCP+0TDQ1QJOzFZ973F8f0Q30dhcTy2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gob9AencWu8dvvXQOOF6V79EkekdURjRRua/hgr2IEoQhw9zYviCm1ptzMRMXM6fv
         P6c+Ti5oAVva7uY8xckDYjQUFUAmhw09+A0PX/6onSfEZg1rlI8Nqn0vv6yoFgr2xr
         REFYjLWfZ0MsXYPOku5gz3n4jd4XZNquQ+/sSrK0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, bpf@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, echaudro@redhat.com, sameehj@amazon.com
Subject: [PATCH v2 net-next 5/6] net: mvneta: get rid of skb in mvneta_rx_queue
Date:   Fri, 17 Jul 2020 00:16:33 +0200
Message-Id: <c747fec1d2445fa29ff61f3751b56a2cc2e5a2a0.1594936660.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1594936660.git.lorenzo@kernel.org>
References: <cover.1594936660.git.lorenzo@kernel.org>
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
index 7746693a3de1..8b7f6fcd4cca 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -699,8 +699,6 @@ struct mvneta_rx_queue {
 	int first_to_refill;
 	u32 refill_num;
 
-	/* pointer to uncomplete skb buffer */
-	struct sk_buff *skb;
 	int left_size;
 };
 
@@ -3362,9 +3360,6 @@ static void mvneta_rxq_deinit(struct mvneta_port *pp,
 {
 	mvneta_rxq_drop_pkts(pp, rxq);
 
-	if (rxq->skb)
-		dev_kfree_skb_any(rxq->skb);
-
 	if (rxq->descs)
 		dma_free_coherent(pp->dev->dev.parent,
 				  rxq->size * MVNETA_DESC_ALIGNED_SIZE,
@@ -3377,7 +3372,6 @@ static void mvneta_rxq_deinit(struct mvneta_port *pp,
 	rxq->descs_phys        = 0;
 	rxq->first_to_refill   = 0;
 	rxq->refill_num        = 0;
-	rxq->skb               = NULL;
 	rxq->left_size         = 0;
 }
 
-- 
2.26.2

