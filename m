Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD26B11947D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbfLJVNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:13:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729279AbfLJVNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EC582077B;
        Tue, 10 Dec 2019 21:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012400;
        bh=3yIRxbD7xE9D403SQkid8uZMATyDWz3ZczN4YUKfBDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlvmxzIqKt0XXI90wmOCIqrMNt+gI5Zb/tVSVvOjNzGCgp97Kbvkd6lcL8lKJPoHp
         vjkUpTr1SXnPQBE311g6Nefcs+5jRXCkUrIqp2IlQ5iN5pVmFxB2RTOJRqpiAiQf5x
         Os2Rjx3Hx94jO4xz1LatNknmdp2BcZ2m42fdLSP8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 319/350] bnxt_en: Improve RX buffer error handling.
Date:   Tue, 10 Dec 2019 16:07:04 -0500
Message-Id: <20191210210735.9077-280-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 19b3751ffa713d04290effb26fe01009010f2206 ]

When hardware reports RX buffer errors, the latest 57500 chips do not
require reset.  The packet is discarded by the hardware and the
ring will continue to operate.

Also, add an rx_buf_errors counter for this type of error.  It can help
the user to identify if the aggregation ring is too small.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 8 ++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 ++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 04ec909e06dfd..527e1bf931160 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1767,8 +1767,12 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 		rc = -EIO;
 		if (rx_err & RX_CMPL_ERRORS_BUFFER_ERROR_MASK) {
-			netdev_warn(bp->dev, "RX buffer error %x\n", rx_err);
-			bnxt_sched_reset(bp, rxr);
+			bnapi->cp_ring.rx_buf_errors++;
+			if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
+				netdev_warn(bp->dev, "RX buffer error %x\n",
+					    rx_err);
+				bnxt_sched_reset(bp, rxr);
+			}
 		}
 		goto next_rx_no_len;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index d333589811a53..5163bb848618f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -927,6 +927,7 @@ struct bnxt_cp_ring_info {
 	dma_addr_t		hw_stats_map;
 	u32			hw_stats_ctx_id;
 	u64			rx_l4_csum_errors;
+	u64			rx_buf_errors;
 	u64			missed_irqs;
 
 	struct bnxt_ring_struct	cp_ring_struct;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 51c1404767178..89f95428556eb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -173,6 +173,7 @@ static const char * const bnxt_ring_tpa2_stats_str[] = {
 
 static const char * const bnxt_ring_sw_stats_str[] = {
 	"rx_l4_csum_errors",
+	"rx_buf_errors",
 	"missed_irqs",
 };
 
@@ -552,6 +553,7 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 		for (k = 0; k < stat_fields; j++, k++)
 			buf[j] = le64_to_cpu(hw_stats[k]);
 		buf[j++] = cpr->rx_l4_csum_errors;
+		buf[j++] = cpr->rx_buf_errors;
 		buf[j++] = cpr->missed_irqs;
 
 		bnxt_sw_func_stats[RX_TOTAL_DISCARDS].counter +=
-- 
2.20.1

