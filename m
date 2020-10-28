Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FE929D8F9
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389114AbgJ1WlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:41:15 -0400
Received: from inva020.nxp.com ([92.121.34.13]:49874 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388989AbgJ1Wjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:39:31 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 86F301A0207;
        Wed, 28 Oct 2020 17:41:12 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7A31E1A0160;
        Wed, 28 Oct 2020 17:41:12 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 29F0D2030E;
        Wed, 28 Oct 2020 17:41:12 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     willemdebruijn.kernel@gmail.com, madalin.bucur@oss.nxp.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net v2 2/2] dpaa_eth: fix the RX headroom size alignment
Date:   Wed, 28 Oct 2020 18:41:00 +0200
Message-Id: <5b077d5853123db0c8794af1ed061850b94eae37.1603899392.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1603899392.git.camelia.groza@nxp.com>
References: <cover.1603899392.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1603899392.git.camelia.groza@nxp.com>
References: <cover.1603899392.git.camelia.groza@nxp.com>
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
Changes in v2:
- make the returned value for TX ports explicit
- simplify the buf_layout reference

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 1aac0b6..278a684 100644
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

@@ -2856,10 +2857,13 @@ static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
 	 *
 	 * Also make sure the headroom is a multiple of data_align bytes
 	 */
-	headroom = (u16)(bl->priv_data_size + DPAA_PARSE_RESULTS_SIZE +
+	headroom = (u16)(bl[port].priv_data_size + DPAA_PARSE_RESULTS_SIZE +
 		DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE);

-	return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
+	if (port == RX)
+		return ALIGN(headroom, DPAA_FD_RX_DATA_ALIGNMENT);
+	else
+		return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
 }

 static int dpaa_eth_probe(struct platform_device *pdev)
@@ -3027,8 +3031,8 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 			goto free_dpaa_fqs;
 	}

-	priv->tx_headroom = dpaa_get_headroom(&priv->buf_layout[TX]);
-	priv->rx_headroom = dpaa_get_headroom(&priv->buf_layout[RX]);
+	priv->tx_headroom = dpaa_get_headroom(priv->buf_layout, TX);
+	priv->rx_headroom = dpaa_get_headroom(priv->buf_layout, RX);

 	/* All real interfaces need their ports initialized */
 	err = dpaa_eth_init_ports(mac_dev, dpaa_bp, &port_fqs,
--
1.9.1

