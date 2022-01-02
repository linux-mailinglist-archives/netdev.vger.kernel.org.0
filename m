Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A10482CC2
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 22:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiABVHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 16:07:10 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:56630 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiABVHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 16:07:10 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 484InfezyIEdl484In6OF9; Sun, 02 Jan 2022 22:07:08 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 02 Jan 2022 22:07:08 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jdmason@kudzu.us, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com, liuhangbin@gmail.com,
        colin.king@intel.com, zhengyongjun3@huawei.com,
        paskripkin@gmail.com, arnd@arndb.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: vxge: Use dma_set_mask_and_coherent() and simplify code
Date:   Sun,  2 Jan 2022 22:07:05 +0100
Message-Id: <6e78ed8aef3240a2cbacb3e424c6470336253e47.1641157546.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dma_set_mask_and_coherent() instead of unrolling it with some
dma_set_mask()+dma_set_coherent_mask().

Moreover, as stated in [1], dma_set_mask() with a 64-bit mask will never
fail if dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

That said, 'high_dma' can only be 1 after a successful
dma_set_mask_and_coherent().

Simplify code and remove some dead code accordingly, including a now
useless parameter to vxge_device_register().

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
In vxge_device_register(), "ndev->features |= NETIF_F_HIGHDMA;" can
certainly be moved a few lines above and merged with
"dev->features |= ndev->hw_features | ..."

However, as I can not test this change, I've left it as is to avoid
potential side effects.
---
 .../net/ethernet/neterion/vxge/vxge-main.c    | 27 +++----------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 2c2e9e56ed4e..aa7c093f1f91 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3349,7 +3349,7 @@ static const struct net_device_ops vxge_netdev_ops = {
 };
 
 static int vxge_device_register(struct __vxge_hw_device *hldev,
-				struct vxge_config *config, int high_dma,
+				struct vxge_config *config,
 				int no_of_vpath, struct vxgedev **vdev_out)
 {
 	struct net_device *ndev;
@@ -3421,11 +3421,7 @@ static int vxge_device_register(struct __vxge_hw_device *hldev,
 	vxge_debug_init(vxge_hw_device_trace_level_get(hldev),
 		"%s : checksumming enabled", __func__);
 
-	if (high_dma) {
-		ndev->features |= NETIF_F_HIGHDMA;
-		vxge_debug_init(vxge_hw_device_trace_level_get(hldev),
-			"%s : using High DMA", __func__);
-	}
+	ndev->features |= NETIF_F_HIGHDMA;
 
 	/* MTU range: 68 - 9600 */
 	ndev->min_mtu = VXGE_HW_MIN_MTU;
@@ -4282,7 +4278,6 @@ vxge_probe(struct pci_dev *pdev, const struct pci_device_id *pre)
 	struct __vxge_hw_device *hldev;
 	enum vxge_hw_status status;
 	int ret;
-	int high_dma = 0;
 	u64 vpath_mask = 0;
 	struct vxgedev *vdev;
 	struct vxge_config *ll_config = NULL;
@@ -4372,22 +4367,9 @@ vxge_probe(struct pci_dev *pdev, const struct pci_device_id *pre)
 		goto _exit0;
 	}
 
-	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
+	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
 		vxge_debug_ll_config(VXGE_TRACE,
 			"%s : using 64bit DMA", __func__);
-
-		high_dma = 1;
-
-		if (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
-			vxge_debug_init(VXGE_ERR,
-				"%s : unable to obtain 64bit DMA for "
-				"consistent allocations", __func__);
-			ret = -ENOMEM;
-			goto _exit1;
-		}
-	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
-		vxge_debug_ll_config(VXGE_TRACE,
-			"%s : using 32bit DMA", __func__);
 	} else {
 		ret = -ENOMEM;
 		goto _exit1;
@@ -4555,8 +4537,7 @@ vxge_probe(struct pci_dev *pdev, const struct pci_device_id *pre)
 	ll_config->tx_pause_enable = VXGE_PAUSE_CTRL_ENABLE;
 	ll_config->rx_pause_enable = VXGE_PAUSE_CTRL_ENABLE;
 
-	ret = vxge_device_register(hldev, ll_config, high_dma, no_of_vpath,
-				   &vdev);
+	ret = vxge_device_register(hldev, ll_config, no_of_vpath, &vdev);
 	if (ret) {
 		ret = -EINVAL;
 		goto _exit4;
-- 
2.32.0

