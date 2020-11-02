Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BB62A3316
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 19:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgKBSet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 13:34:49 -0500
Received: from inva020.nxp.com ([92.121.34.13]:56082 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgKBSep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 13:34:45 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id AC3231A023A;
        Mon,  2 Nov 2020 19:34:43 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9D6BE1A0227;
        Mon,  2 Nov 2020 19:34:43 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4ECF520306;
        Mon,  2 Nov 2020 19:34:43 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     willemdebruijn.kernel@gmail.com, madalin.bucur@oss.nxp.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net v3 2/2] dpaa_eth: fix the RX headroom size alignment
Date:   Mon,  2 Nov 2020 20:34:36 +0200
Message-Id: <87ce12180a5a492d0bdfce8b06dea510c82f9cd5.1604339942.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1604339942.git.camelia.groza@nxp.com>
References: <cover.1604339942.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1604339942.git.camelia.groza@nxp.com>
References: <cover.1604339942.git.camelia.groza@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The headroom reserved for received frames needs to be aligned to an
RX specific value. There is currently a discrepancy between the values
used in the Ethernet driver and the values passed to the FMan.
Coincidentally, the resulting aligned values are identical.

Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
Changes in v3:
- remove the unnecessary inline identifier

Changes in v2:
- make the returned value for TX ports explicit
- simplify the buf_layout reference

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 3eaa5f2..d9c2859 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2845,7 +2845,8 @@ static int dpaa_ingress_cgr_init(struct dpaa_priv *priv)
 	return err;
 }

-static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
+static u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl,
+			     enum port_type port)
 {
 	u16 headroom;

@@ -2859,9 +2860,12 @@ static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
 	 *
 	 * Also make sure the headroom is a multiple of data_align bytes
 	 */
-	headroom = (u16)(bl->priv_data_size + DPAA_HWA_SIZE);
+	headroom = (u16)(bl[port].priv_data_size + DPAA_HWA_SIZE);

-	return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
+	if (port == RX)
+		return ALIGN(headroom, DPAA_FD_RX_DATA_ALIGNMENT);
+	else
+		return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
 }

 static int dpaa_eth_probe(struct platform_device *pdev)
@@ -3029,8 +3033,8 @@ static int dpaa_eth_probe(struct platform_device *pdev)
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

