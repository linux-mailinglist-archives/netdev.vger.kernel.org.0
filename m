Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A3D39571
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbfFGTVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:21:09 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:51141 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730014AbfFGTVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:21:06 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hZKQ8-0004YF-SL; Fri, 07 Jun 2019 21:21:01 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com
Subject: [PATCH v2 net-next 5/7] bnx2x: Use napi_alloc_frag()
Date:   Fri,  7 Jun 2019 21:20:38 +0200
Message-Id: <20190607192040.19367-6-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607192040.19367-1-bigeasy@linutronix.de>
References: <20190607192040.19367-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SKB allocation via bnx2x_frag_alloc() is always performed in NAPI
context. Preemptible context passes GFP_KERNEL and bnx2x_frag_alloc()
uses then __get_free_page() for the allocation.

Use napi_alloc_frag() for memory allocation.

Cc: Ariel Elior <aelior@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 008ad0ca89ba0..c4986b5191916 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -684,7 +684,7 @@ static void *bnx2x_frag_alloc(const struct bnx2x_fastpath *fp, gfp_t gfp_mask)
 		if (unlikely(gfpflags_allow_blocking(gfp_mask)))
 			return (void *)__get_free_page(gfp_mask);
 
-		return netdev_alloc_frag(fp->rx_frag_size);
+		return napi_alloc_frag(fp->rx_frag_size);
 	}
 
 	return kmalloc(fp->rx_buf_size + NET_SKB_PAD, gfp_mask);
-- 
2.20.1

