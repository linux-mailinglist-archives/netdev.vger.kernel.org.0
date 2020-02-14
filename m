Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0758715E81F
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394394AbgBNQ6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:58:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404491AbgBNQRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 541DA246F7;
        Fri, 14 Feb 2020 16:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697052;
        bh=eCjAj+mF4lI1N7X7UgOYWyGT6SuItiaO4gbXdsEREQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oScUyO1uz5DxYTU2+TSSUeoHVt3sVrMwsNTWJMmbs/jDNz8TOZRMny2EyDd5yF7U9
         sr7el0rHNPZufoaPWhzgXg1MNTDb4RgArzQWY7ENpS5UyRvtZtRIedCyBRy0b1qFMn
         Wv4qAenE2oAL9cNEigwOMebafeab6nuDtLDYDA04=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 012/186] gianfar: Fix TX timestamping with a stacked DSA driver
Date:   Fri, 14 Feb 2020 11:14:21 -0500
Message-Id: <20200214161715.18113-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit c26a2c2ddc0115eb088873f5c309cf46b982f522 ]

The driver wrongly assumes that it is the only entity that can set the
SKBTX_IN_PROGRESS bit of the current skb. Therefore, in the
gfar_clean_tx_ring function, where the TX timestamp is collected if
necessary, the aforementioned bit is used to discriminate whether or not
the TX timestamp should be delivered to the socket's error queue.

But a stacked driver such as a DSA switch can also set the
SKBTX_IN_PROGRESS bit, which is actually exactly what it should do in
order to denote that the hardware timestamping process is undergoing.

Therefore, gianfar would misinterpret the "in progress" bit as being its
own, and deliver a second skb clone in the socket's error queue,
completely throwing off a PTP process which is not expecting to receive
it, _even though_ TX timestamping is not enabled for gianfar.

There have been discussions [0] as to whether non-MAC drivers need or
not to set SKBTX_IN_PROGRESS at all (whose purpose is to avoid sending 2
timestamps, a sw and a hw one, to applications which only expect one).
But as of this patch, there are at least 2 PTP drivers that would break
in conjunction with gianfar: the sja1105 DSA switch and the felix
switch, by way of its ocelot core driver.

So regardless of that conclusion, fix the gianfar driver to not do stuff
based on flags set by others and not intended for it.

[0]: https://www.spinics.net/lists/netdev/msg619699.html

Fixes: f0ee7acfcdd4 ("gianfar: Add hardware TX timestamping support")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/gianfar.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 27d0e3b9833cd..e4a2c74a9b47e 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2685,13 +2685,17 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 	skb_dirtytx = tx_queue->skb_dirtytx;
 
 	while ((skb = tx_queue->tx_skbuff[skb_dirtytx])) {
+		bool do_tstamp;
+
+		do_tstamp = (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+			    priv->hwts_tx_en;
 
 		frags = skb_shinfo(skb)->nr_frags;
 
 		/* When time stamping, one additional TxBD must be freed.
 		 * Also, we need to dma_unmap_single() the TxPAL.
 		 */
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS))
+		if (unlikely(do_tstamp))
 			nr_txbds = frags + 2;
 		else
 			nr_txbds = frags + 1;
@@ -2705,7 +2709,7 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 		    (lstatus & BD_LENGTH_MASK))
 			break;
 
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
+		if (unlikely(do_tstamp)) {
 			next = next_txbd(bdp, base, tx_ring_size);
 			buflen = be16_to_cpu(next->length) +
 				 GMAC_FCB_LEN + GMAC_TXPAL_LEN;
@@ -2715,7 +2719,7 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 		dma_unmap_single(priv->dev, be32_to_cpu(bdp->bufPtr),
 				 buflen, DMA_TO_DEVICE);
 
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
+		if (unlikely(do_tstamp)) {
 			struct skb_shared_hwtstamps shhwtstamps;
 			u64 *ns = (u64 *)(((uintptr_t)skb->data + 0x10) &
 					  ~0x7UL);
-- 
2.20.1

