Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B34F176AD3
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgCCCqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:46:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:41294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbgCCCqo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:46:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4851F2465E;
        Tue,  3 Mar 2020 02:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203603;
        bh=+ulgleQGKupvS73skI++NZZypImUuGJBnWowRPLRgBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWqiICR6S3rVp7iVL1kclXcFCNRMj3lzzKX8MrzgwxYmTVSax2ckuRLDCKUNjx4n6
         v5ZSFyebfJW8TiET7GpCFYJftuuxgvUIb9ULodAUSz2Kwzh6FuUbQ3IDaOatl39Wc6
         RRasaTSbcuUTqyveILURvRWj0EqHhYwz3kCuGjOs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Bezrukov <dbezrukov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 22/66] net: atlantic: checksum compat issue
Date:   Mon,  2 Mar 2020 21:45:31 -0500
Message-Id: <20200303024615.8889-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dbezrukov@marvell.com>

[ Upstream commit 15beab0a9d797be1b7c67458da007a62269be29a ]

Yet another checksum offload compatibility issue was found.

The known issue is that AQC HW marks tcp packets with 0xFFFF checksum
as invalid (1). This is workarounded in driver, passing all the suspicious
packets up to the stack for further csum validation.

Another HW problem (2) is that it hides invalid csum of LRO aggregated
packets inside of the individual descriptors. That was workarounded
by forced scan of all LRO descriptors for checksum errors.

However the scan logic was joint for both LRO and multi-descriptor
packets (jumbos). And this causes the issue.

We have to drop LRO packets with the detected bad checksum
because of (2), but we have to pass jumbo packets to stack because of (1).

When using windows tcp partner with jumbo frames but with LSO disabled
driver discards such frames as bad checksummed. But only LRO frames
should be dropped, not jumbos.

On such a configurations tcp stream have a chance of drops and stucks.

(1) 76f254d4afe2 ("net: aquantia: tcp checksum 0xffff being handled incorrectly")
(2) d08b9a0a3ebd ("net: aquantia: do not pass lro session with invalid tcp checksum")

Fixes: d08b9a0a3ebd ("net: aquantia: do not pass lro session with invalid tcp checksum")
Signed-off-by: Dmitry Bezrukov <dbezrukov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c          | 3 ++-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h          | 3 ++-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 5 +++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 951d86f8b66e8..6941999ae845d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -351,7 +351,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 				err = 0;
 				goto err_exit;
 			}
-			if (buff->is_error || buff->is_cso_err) {
+			if (buff->is_error ||
+			    (buff->is_lro && buff->is_cso_err)) {
 				buff_ = buff;
 				do {
 					next_ = buff_->next,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index 991e4d31b0948..2c96f20f62891 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -78,7 +78,8 @@ struct __packed aq_ring_buff_s {
 			u32 is_cleaned:1;
 			u32 is_error:1;
 			u32 is_vlan:1;
-			u32 rsvd3:4;
+			u32 is_lro:1;
+			u32 rsvd3:3;
 			u16 eop_index;
 			u16 rsvd4;
 		};
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index ec041f78d0634..5784da26f8683 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -823,6 +823,8 @@ static int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s *self,
 			}
 		}
 
+		buff->is_lro = !!(HW_ATL_B0_RXD_WB_STAT2_RSCCNT &
+				  rxd_wb->status);
 		if (HW_ATL_B0_RXD_WB_STAT2_EOP & rxd_wb->status) {
 			buff->len = rxd_wb->pkt_len %
 				AQ_CFG_RX_FRAME_MAX;
@@ -835,8 +837,7 @@ static int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s *self,
 				rxd_wb->pkt_len > AQ_CFG_RX_FRAME_MAX ?
 				AQ_CFG_RX_FRAME_MAX : rxd_wb->pkt_len;
 
-			if (HW_ATL_B0_RXD_WB_STAT2_RSCCNT &
-				rxd_wb->status) {
+			if (buff->is_lro) {
 				/* LRO */
 				buff->next = rxd_wb->next_desc_ptr;
 				++ring->stats.rx.lro_packets;
-- 
2.20.1

