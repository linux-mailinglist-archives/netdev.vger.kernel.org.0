Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5F488BAE
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 19:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbiAISle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 13:41:34 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:51875 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236526AbiAISld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 13:41:33 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6d8Fnvxm5soWh6d8Fnw4Qn; Sun, 09 Jan 2022 19:41:32 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 19:41:32 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH] igb: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 19:41:30 +0100
Message-Id: <abb2371cc7fabfa26d96abc1ff1b80ac038448b1.1641753678.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask never fails if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to be
1.

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch was not part of the 1st serie I've sent. So there is no
Reviewed-by tag.
---
 drivers/net/ethernet/intel/igb/igb_main.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 38ba92022cd4..bfa321e4003f 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3164,8 +3164,8 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	s32 ret_val;
 	static int global_quad_port_a; /* global quad port a indication */
 	const struct e1000_info *ei = igb_info_tbl[ent->driver_data];
-	int err, pci_using_dac;
 	u8 part_str[E1000_PBANUM_LENGTH];
+	int err;
 
 	/* Catch broken hardware that put the wrong VF device ID in
 	 * the PCIe SR-IOV capability.
@@ -3180,17 +3180,11 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		return err;
 
-	pci_using_dac = 0;
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
-	if (!err) {
-		pci_using_dac = 1;
-	} else {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev,
-				"No usable DMA configuration, aborting\n");
-			goto err_dma;
-		}
+	if (err) {
+		dev_err(&pdev->dev,
+			"No usable DMA configuration, aborting\n");
+		goto err_dma;
 	}
 
 	err = pci_request_mem_regions(pdev, igb_driver_name);
@@ -3306,8 +3300,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (hw->mac.type >= e1000_i350)
 		netdev->hw_features |= NETIF_F_NTUPLE;
 
-	if (pci_using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
+	netdev->features |= NETIF_F_HIGHDMA;
 
 	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
 	netdev->mpls_features |= NETIF_F_HW_CSUM;
-- 
2.32.0

