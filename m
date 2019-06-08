Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B532C39E39
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbfFHLra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbfFHLr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:47:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6AF82171F;
        Sat,  8 Jun 2019 11:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994447;
        bh=MaGGx6LGuENlbrd9elqbccGtSmUluGQg5szD+oz0nro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DjmMQgOAHV/pQkxa6KgFZlFc1k/50/PxYy4oLBWAp1bstTLauWqyZpjTxJ6kcgLzS
         46KBnhyq/v2RmnH8Vjg7+/Qx0DjyKzsBdA0Q2juAYBeRguEJykylduRnJbWap2PAMd
         ZmQz2hS4DcKHt21Hxozvq/vFDeMD3q2SQou820uA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/31] net: aquantia: fix LRO with FCS error
Date:   Sat,  8 Jun 2019 07:46:27 -0400
Message-Id: <20190608114646.9415-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114646.9415-1-sashal@kernel.org>
References: <20190608114646.9415-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

[ Upstream commit eaeb3b7494ba9159323814a8ce8af06a9277d99b ]

Driver stops producing skbs on ring if a packet with FCS error
was coalesced into LRO session. Ring gets hang forever.

Thats a logical error in driver processing descriptors:
When rx_stat indicates MAC Error, next pointer and eop flags
are not filled. This confuses driver so it waits for descriptor 0
to be filled by HW.

Solution is fill next pointer and eop flag even for packets with FCS error.

Fixes: bab6de8fd180b ("net: ethernet: aquantia: Atlantic A0 and B0 specific functions.")
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 61 ++++++++++---------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index f4b3554b0b67..236325f48ec9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -683,38 +683,41 @@ static int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s *self,
 		if (is_err || rxd_wb->type & 0x1000U) {
 			/* status error or DMA error */
 			buff->is_error = 1U;
-		} else {
-			if (self->aq_nic_cfg->is_rss) {
-				/* last 4 byte */
-				u16 rss_type = rxd_wb->type & 0xFU;
-
-				if (rss_type && rss_type < 0x8U) {
-					buff->is_hash_l4 = (rss_type == 0x4 ||
-					rss_type == 0x5);
-					buff->rss_hash = rxd_wb->rss_hash;
-				}
+		}
+		if (self->aq_nic_cfg->is_rss) {
+			/* last 4 byte */
+			u16 rss_type = rxd_wb->type & 0xFU;
+
+			if (rss_type && rss_type < 0x8U) {
+				buff->is_hash_l4 = (rss_type == 0x4 ||
+				rss_type == 0x5);
+				buff->rss_hash = rxd_wb->rss_hash;
 			}
+		}
 
-			if (HW_ATL_B0_RXD_WB_STAT2_EOP & rxd_wb->status) {
-				buff->len = rxd_wb->pkt_len %
-					AQ_CFG_RX_FRAME_MAX;
-				buff->len = buff->len ?
-					buff->len : AQ_CFG_RX_FRAME_MAX;
-				buff->next = 0U;
-				buff->is_eop = 1U;
+		if (HW_ATL_B0_RXD_WB_STAT2_EOP & rxd_wb->status) {
+			buff->len = rxd_wb->pkt_len %
+				AQ_CFG_RX_FRAME_MAX;
+			buff->len = buff->len ?
+				buff->len : AQ_CFG_RX_FRAME_MAX;
+			buff->next = 0U;
+			buff->is_eop = 1U;
+		} else {
+			buff->len =
+				rxd_wb->pkt_len > AQ_CFG_RX_FRAME_MAX ?
+				AQ_CFG_RX_FRAME_MAX : rxd_wb->pkt_len;
+
+			if (HW_ATL_B0_RXD_WB_STAT2_RSCCNT &
+				rxd_wb->status) {
+				/* LRO */
+				buff->next = rxd_wb->next_desc_ptr;
+				++ring->stats.rx.lro_packets;
 			} else {
-				if (HW_ATL_B0_RXD_WB_STAT2_RSCCNT &
-					rxd_wb->status) {
-					/* LRO */
-					buff->next = rxd_wb->next_desc_ptr;
-					++ring->stats.rx.lro_packets;
-				} else {
-					/* jumbo */
-					buff->next =
-						aq_ring_next_dx(ring,
-								ring->hw_head);
-					++ring->stats.rx.jumbo_packets;
-				}
+				/* jumbo */
+				buff->next =
+					aq_ring_next_dx(ring,
+							ring->hw_head);
+				++ring->stats.rx.jumbo_packets;
 			}
 		}
 	}
-- 
2.20.1

