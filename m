Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA8EF4914
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390536AbfKHLnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388718AbfKHLnl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C759222C2;
        Fri,  8 Nov 2019 11:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213420;
        bh=qvaJckDGdLrK/qEiSj60eF89SiNSLo3wCVU4ci/H+BM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=so8UyrBBYmSQdY1yiCWORXqMHAN5lyRTOwMboW5eft/8m1bipWAUhQvhFA2FSMKg3
         SMvQkHFLMBvLZeFwj5YtlKtczRLTUMyIuwSHttPXFWEk4n31/A9++eCJkg+PdGJUph
         qpkDeMUKm/TeKHY0GIXCDX6DPDPb0ibkmGfiRrVg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rick Farrington <ricardo.farrington@cavium.com>,
        Felix Manlunas <felix.manlunas@cavium.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 022/103] liquidio: fix race condition in instruction completion processing
Date:   Fri,  8 Nov 2019 06:41:47 -0500
Message-Id: <20191108114310.14363-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
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
index 29d53b1763a72..2a9c925376cc1 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
@@ -1444,8 +1444,9 @@ void lio_enable_irq(struct octeon_droq *droq, struct octeon_instr_queue *iq)
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
index 5c3c8da976f73..1860603452ee7 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_iq.h
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_iq.h
@@ -84,6 +84,8 @@ struct octeon_instr_queue {
 
 	u32 pkt_in_done;
 
+	u32 pkts_processed;
+
 	/** A spinlock to protect access to the input ring.*/
 	spinlock_t iq_flush_running_lock;
 
diff --git a/drivers/net/ethernet/cavium/liquidio/request_manager.c b/drivers/net/ethernet/cavium/liquidio/request_manager.c
index 55e8731264634..0ea623768783e 100644
--- a/drivers/net/ethernet/cavium/liquidio/request_manager.c
+++ b/drivers/net/ethernet/cavium/liquidio/request_manager.c
@@ -122,6 +122,7 @@ int octeon_init_instr_queue(struct octeon_device *oct,
 	iq->do_auto_flush = 1;
 	iq->db_timeout = (u32)conf->db_timeout;
 	atomic_set(&iq->instr_pending, 0);
+	iq->pkts_processed = 0;
 
 	/* Initialize the spinlock for this instruction queue */
 	spin_lock_init(&iq->lock);
@@ -474,6 +475,7 @@ octeon_flush_iq(struct octeon_device *oct, struct octeon_instr_queue *iq,
 				lio_process_iq_request_list(oct, iq, 0);
 
 		if (inst_processed) {
+			iq->pkts_processed += inst_processed;
 			atomic_sub(inst_processed, &iq->instr_pending);
 			iq->stats.instr_processed += inst_processed;
 		}
-- 
2.20.1

