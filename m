Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BB715F211
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390835AbgBNSGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731103AbgBNPy4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C80F824673;
        Fri, 14 Feb 2020 15:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695695;
        bh=UsiEZwaNCOzGinm9GY9LYQeSFH9pbbl3cGztO6ANsr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6JL2uVcr+8VOcuB2PA9dV57/JbWR500G8Myd7d6QAZNVfjvwU8i1/TPSIC7yjhXg
         Hm2HZ9XFgUGMMgT/m1CUYnleEF6VXY39/2klzzqNGtt3ba4ZeTEqOAOJAFRr4zWQMG
         NGxIsAuTiFZQEFgX0ujIUGn7t5Ls3691dRXFIDYk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 278/542] ice: add extra check for null Rx descriptor
Date:   Fri, 14 Feb 2020 10:44:30 -0500
Message-Id: <20200214154854.6746-278-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

[ Upstream commit 1f45ebe0d8fbe6178670b663005f38ef8535db5d ]

In the case where the hardware gives us a null Rx descriptor, it is
theoretically possible that we could call one of our skb-construction
functions with no data pointer, which would cause a panic.

In real life, this will never happen - we only get null RX
descriptors as the final descriptor in a chain of otherwise-valid
descriptors. When this happens, the skb will be extant and we'll just
call ice_add_rx_frag(), which can deal with empty data buffers.

Unfortunately, Coverity does not have intimate knowledge of our
hardware, so we must add a check here.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 2c212f64d99f2..8b2b9e254d28d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1071,13 +1071,16 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		ice_put_rx_buf(rx_ring, rx_buf);
 		continue;
 construct_skb:
-		if (skb)
+		if (skb) {
 			ice_add_rx_frag(rx_ring, rx_buf, skb, size);
-		else if (ice_ring_uses_build_skb(rx_ring))
-			skb = ice_build_skb(rx_ring, rx_buf, &xdp);
-		else
+		} else if (likely(xdp.data)) {
+			if (ice_ring_uses_build_skb(rx_ring))
+				skb = ice_build_skb(rx_ring, rx_buf, &xdp);
+			else
+				skb = ice_construct_skb(rx_ring, rx_buf, &xdp);
+		} else {
 			skb = ice_construct_skb(rx_ring, rx_buf, &xdp);
-
+		}
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buf_failed++;
-- 
2.20.1

