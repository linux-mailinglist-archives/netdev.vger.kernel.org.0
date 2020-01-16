Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2537F13E546
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390832AbgAPRNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390825AbgAPRNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 268BD2469E;
        Thu, 16 Jan 2020 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194826;
        bh=uygpqcRBzydA8O8gxzqnmROM4ngHd0GFslMkdbAREWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nta3C+zP1PaEkSFcIyg6w3PfcCKRMzvPhb0kRHf5ArFBFoYLGN+31Jr1RsxOZR/D4
         RfD/mmKeCUy/9erNwNeL3iJ0hfFPRBbRYuUqsygY5W2X01pnn1cMUUtQd/qPwJbQsR
         D27PV0kCx/3gvVF8IKWRLjRrYR/BfpOU+hN77w+g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 630/671] dpaa_eth: perform DMA unmapping before read
Date:   Thu, 16 Jan 2020 12:04:28 -0500
Message-Id: <20200116170509.12787-367-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

[ Upstream commit c70fd3182caef014e6c628b412f81aa57a3ef9e4 ]

DMA unmapping is required before accessing the HW provided timestamping
information.

Fixes: 4664856e9ca2 ("dpaa_eth: add support for hardware timestamping")
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 32 ++++++++++---------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 462bb8c4f80c..3cd62a71ddea 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1620,18 +1620,6 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	skbh = (struct sk_buff **)phys_to_virt(addr);
 	skb = *skbh;
 
-	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
-
-		if (!fman_port_get_tstamp(priv->mac_dev->port[TX], (void *)skbh,
-					  &ns)) {
-			shhwtstamps.hwtstamp = ns_to_ktime(ns);
-			skb_tstamp_tx(skb, &shhwtstamps);
-		} else {
-			dev_warn(dev, "fman_port_get_tstamp failed!\n");
-		}
-	}
-
 	if (unlikely(qm_fd_get_format(fd) == qm_fd_sg)) {
 		nr_frags = skb_shinfo(skb)->nr_frags;
 		dma_unmap_single(dev, addr,
@@ -1654,14 +1642,28 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 			dma_unmap_page(dev, qm_sg_addr(&sgt[i]),
 				       qm_sg_entry_get_len(&sgt[i]), dma_dir);
 		}
-
-		/* Free the page frag that we allocated on Tx */
-		skb_free_frag(phys_to_virt(addr));
 	} else {
 		dma_unmap_single(dev, addr,
 				 skb_tail_pointer(skb) - (u8 *)skbh, dma_dir);
 	}
 
+	/* DMA unmapping is required before accessing the HW provided info */
+	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+
+		if (!fman_port_get_tstamp(priv->mac_dev->port[TX], (void *)skbh,
+					  &ns)) {
+			shhwtstamps.hwtstamp = ns_to_ktime(ns);
+			skb_tstamp_tx(skb, &shhwtstamps);
+		} else {
+			dev_warn(dev, "fman_port_get_tstamp failed!\n");
+		}
+	}
+
+	if (qm_fd_get_format(fd) == qm_fd_sg)
+		/* Free the page frag that we allocated on Tx */
+		skb_free_frag(phys_to_virt(addr));
+
 	return skb;
 }
 
-- 
2.20.1

