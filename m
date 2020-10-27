Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463AE29B407
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 16:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782623AbgJ0O5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 10:57:15 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47082 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1782517AbgJ0O5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 10:57:11 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6F56D1A0EF2;
        Tue, 27 Oct 2020 15:57:09 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6288A1A0EE4;
        Tue, 27 Oct 2020 15:57:09 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2548C202AE;
        Tue, 27 Oct 2020 15:57:09 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     madalin.bucur@oss.nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net 2/2] dpaa_eth: fix the RX headroom size alignment
Date:   Tue, 27 Oct 2020 16:56:30 +0200
Message-Id: <434895b93ba0039abc94d5fdfcd91a27f2d867cb.1603804282.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1603804282.git.camelia.groza@nxp.com>
References: <cover.1603804282.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1603804282.git.camelia.groza@nxp.com>
References: <cover.1603804282.git.camelia.groza@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The headroom reserved for received frames needs to be aligned to an
RX specific value. There is currently a discrepancy between the values
used in the Ethernet driver and the values passed to the FMan.
Coincidentally, the resulting aligned values are identical.

Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 1aac0b6..67ae561 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2842,7 +2842,8 @@ static int dpaa_ingress_cgr_init(struct dpaa_priv *priv)
 	return err;
 }
 
-static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
+static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl,
+				    enum port_type port)
 {
 	u16 headroom;
 
@@ -2856,9 +2857,12 @@ static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
 	 *
 	 * Also make sure the headroom is a multiple of data_align bytes
 	 */
-	headroom = (u16)(bl->priv_data_size + DPAA_PARSE_RESULTS_SIZE +
+	headroom = (u16)(bl[port].priv_data_size + DPAA_PARSE_RESULTS_SIZE +
 		DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE);
 
+	if (port == RX)
+		return ALIGN(headroom, DPAA_FD_RX_DATA_ALIGNMENT);
+
 	return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
 }
 
@@ -3027,8 +3031,8 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 			goto free_dpaa_fqs;
 	}
 
-	priv->tx_headroom = dpaa_get_headroom(&priv->buf_layout[TX]);
-	priv->rx_headroom = dpaa_get_headroom(&priv->buf_layout[RX]);
+	priv->tx_headroom = dpaa_get_headroom(&priv->buf_layout[0], TX);
+	priv->rx_headroom = dpaa_get_headroom(&priv->buf_layout[0], RX);
 
 	/* All real interfaces need their ports initialized */
 	err = dpaa_eth_init_ports(mac_dev, dpaa_bp, &port_fqs,
-- 
1.9.1

