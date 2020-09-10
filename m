Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6142640EC
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 11:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgIJJIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 05:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729781AbgIJJIW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 05:08:22 -0400
Received: from lore-desk.redhat.com (unknown [151.66.29.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37F102065E;
        Thu, 10 Sep 2020 09:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599728900;
        bh=YWJEOtWKKcbdkFcVi8Ky/5M96HR3wvEaXmOiTSGOfCM=;
        h=From:To:Cc:Subject:Date:From;
        b=E+eR8zHc4kPahyCFrz3MwSFtB0Mfc9XXoDtpS1EGJdr1h02CFlG29v9V8XpM3Rwly
         FX5QqLGLKxf4hvyUzyGmc2Y/upBwAdtfPJ29h7jm+KwmgWhA5K5VGdspx7MTFEUOzZ
         nmZb9VoOO4vuqugVrDitf1oExNYISiri0/BUu7I0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        echaudro@redhat.com
Subject: [PATCH net] net: mvneta: fix possible use-after-free in mvneta_xdp_put_buff
Date:   Thu, 10 Sep 2020 11:08:01 +0200
Message-Id: <f203fdb6060bb3ba8ff3f27a30767941a4a01c17.1599728755.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Release first buffer as last one since it contains references
to subsequent fragments. This code will be optimized introducing
multi-buffer bit in xdp_buff structure.

Fixes: ca0e014609f05 ("net: mvneta: move skb build after descriptors processing")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index dfcb1767acbb..69a900081165 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2029,11 +2029,11 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	int i;
 
-	page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
-			   sync_len, napi);
 	for (i = 0; i < sinfo->nr_frags; i++)
 		page_pool_put_full_page(rxq->page_pool,
 					skb_frag_page(&sinfo->frags[i]), napi);
+	page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
+			   sync_len, napi);
 }
 
 static int
-- 
2.26.2

