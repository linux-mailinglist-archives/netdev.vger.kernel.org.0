Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE3752FD72
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfE3OT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:19:58 -0400
Received: from inva021.nxp.com ([92.121.34.21]:47206 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfE3OT5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 10:19:57 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0899420054E;
        Thu, 30 May 2019 16:19:56 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id F0260200182;
        Thu, 30 May 2019 16:19:55 +0200 (CEST)
Received: from fsr-ub1864-101.ea.freescale.net (fsr-ub1864-101.ea.freescale.net [10.171.82.13])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 678932026B;
        Thu, 30 May 2019 16:19:55 +0200 (CEST)
From:   laurentiu.tudor@nxp.com
To:     netdev@vger.kernel.org, madalin.bucur@nxp.com, roy.pledge@nxp.com,
        camelia.groza@nxp.com, leoyang.li@nxp.com
Cc:     Joakim.Tjernlund@infinera.com, davem@davemloft.net,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: [PATCH v3 4/6] dpaa_eth: base dma mappings on the fman rx port
Date:   Thu, 30 May 2019 17:19:49 +0300
Message-Id: <20190530141951.6704-5-laurentiu.tudor@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
References: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

The dma transactions initiator is the rx fman port so that's the device
that the dma mappings should be done. Previously the mappings were done
through the MAC device which makes no sense because it's neither dma-able
nor connected in any way to smmu.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Acked-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 975f307f0caa..f54b0cd0d175 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2805,8 +2805,15 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	mac_dev = dpaa_mac_dev_get(pdev);
+	if (IS_ERR(mac_dev)) {
+		dev_err(&pdev->dev, "dpaa_mac_dev_get() failed\n");
+		err = PTR_ERR(mac_dev);
+		goto probe_err;
+	}
+
 	/* device used for DMA mapping */
-	dev = pdev->dev.parent;
+	dev = fman_port_get_device(mac_dev->port[RX]);
 	err = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(40));
 	if (err) {
 		dev_err(dev, "dma_coerce_mask_and_coherent() failed\n");
@@ -2831,13 +2838,6 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 
 	priv->msg_enable = netif_msg_init(debug, DPAA_MSG_DEFAULT);
 
-	mac_dev = dpaa_mac_dev_get(pdev);
-	if (IS_ERR(mac_dev)) {
-		dev_err(dev, "dpaa_mac_dev_get() failed\n");
-		err = PTR_ERR(mac_dev);
-		goto free_netdev;
-	}
-
 	/* If fsl_fm_max_frm is set to a higher value than the all-common 1500,
 	 * we choose conservatively and let the user explicitly set a higher
 	 * MTU via ifconfig. Otherwise, the user may end up with different MTUs
@@ -2973,9 +2973,9 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	qman_release_cgrid(priv->cgr_data.cgr.cgrid);
 free_dpaa_bps:
 	dpaa_bps_free(priv);
-free_netdev:
 	dev_set_drvdata(dev, NULL);
 	free_netdev(net_dev);
+probe_err:
 
 	return err;
 }
-- 
2.17.1

