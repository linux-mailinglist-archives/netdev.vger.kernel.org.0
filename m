Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9DB2F4AE9
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391971AbfKHMM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:12:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732830AbfKHLip (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97E7420869;
        Fri,  8 Nov 2019 11:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213124;
        bh=LoGSwEhWqUDWuPoWcpmAiDNc+LQbBg12CiqsW0Xkyo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXXUwHrfDDCcWOt5ug2cW/WVfMaYuo8pZSDuawPz+HP9q6jfiP0rYHQMf60sCKTZi
         LpJxQXuzSQU7Jwu4lG0h2OFuElE3KSQR1ChosSc3/uEZiy/HXv1ZTagJwTLwNYsp9D
         h7wPawMx3jf+ys8ouUKCoYedDuHzVtEHbbMfQJwE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rick Farrington <ricardo.farrington@cavium.com>,
        Felix Manlunas <felix.manlunas@cavium.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 043/205] liquidio: fix race condition in instruction completion processing
Date:   Fri,  8 Nov 2019 06:35:10 -0500
Message-Id: <20191108113752.12502-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rick Farrington <ricardo.farrington@cavium.com>

[ Upstream commit b943f17e06493fd2c7fd00743093ad5dcdb90e7f ]

In lio_enable_irq, the pkt_in_done count register was being cleared to
zero.  However, there could be some completed instructions which were not
yet processed due to budget and limit constraints.
So, only write this register with the number of actual completions
that were processed.

Signed-off-by: Rick Farrington <ricardo.farrington@cavium.com>
Signed-off-by: Felix Manlunas <felix.manlunas@cavium.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/octeon_device.c   | 5 +++--
 drivers/net/ethernet/cavium/liquidio/octeon_iq.h       | 2 ++
 drivers/net/ethernet/cavium/liquidio/request_manager.c | 2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.c b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
index f878a552fef3b..d0ed6c4f9e1a2 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
@@ -1450,8 +1450,9 @@ void lio_enable_irq(struct octeon_droq *droq, struct octeon_instr_queue *iq)
 	}
 	if (iq) {
 		spin_lock_bh(&iq->lock);
-		writel(iq->pkt_in_done, iq->inst_cnt_reg);
-		iq->pkt_in_done = 0;
+		writel(iq->pkts_processed, iq->inst_cnt_reg);
+		iq->pkt_in_done -= iq->pkts_processed;
+		iq->pkts_processed = 0;
 		/* this write needs to be flushed before we release the lock */
 		mmiowb();
 		spin_unlock_bh(&iq->lock);
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_iq.h b/drivers/net/ethernet/cavium/liquidio/octeon_iq.h
index 2327062e8af6b..aecd0d36d6349 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_iq.h
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_iq.h
@@ -94,6 +94,8 @@ struct octeon_instr_queue {
 
 	u32 pkt_in_done;
 
+	u32 pkts_processed;
+
 	/** A spinlock to protect access to the input ring.*/
 	spinlock_t iq_flush_running_lock;
 
diff --git a/drivers/net/ethernet/cavium/liquidio/request_manager.c b/drivers/net/ethernet/cavium/liquidio/request_manager.c
index 3deb3c07681fd..1d9ab7f4a2fef 100644
--- a/drivers/net/ethernet/cavium/liquidio/request_manager.c
+++ b/drivers/net/ethernet/cavium/liquidio/request_manager.c
@@ -123,6 +123,7 @@ int octeon_init_instr_queue(struct octeon_device *oct,
 	iq->do_auto_flush = 1;
 	iq->db_timeout = (u32)conf->db_timeout;
 	atomic_set(&iq->instr_pending, 0);
+	iq->pkts_processed = 0;
 
 	/* Initialize the spinlock for this instruction queue */
 	spin_lock_init(&iq->lock);
@@ -497,6 +498,7 @@ octeon_flush_iq(struct octeon_device *oct, struct octeon_instr_queue *iq,
 				lio_process_iq_request_list(oct, iq, 0);
 
 		if (inst_processed) {
+			iq->pkts_processed += inst_processed;
 			atomic_sub(inst_processed, &iq->instr_pending);
 			iq->stats.instr_processed += inst_processed;
 		}
-- 
2.20.1

