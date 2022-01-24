Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC5F498687
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241070AbiAXRW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244442AbiAXRW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:22:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA04C06173D
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:22:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A523B8119D
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 17:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BD8C340E5;
        Mon, 24 Jan 2022 17:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643044975;
        bh=GT0DGOMZuJZejNQ35Fm5RaUNRde2aGPxDaGr+jzjQOI=;
        h=From:To:Cc:Subject:Date:From;
        b=VkrfAzPed7u2IBI+y4jN9UDlW7SrlZVuxyiL2T3krNd7X5gZmhJJx0oB5h5He1O+p
         rPbUDoCVFMlw+zvRh0onwA5UDpkWq757Ycdm/uOy4FjjAiCDPpUMOORFlO8Qh8M7IB
         CeDZk+pqijziyTyxYHJ7wN0Oq/dm8nvoia6jE11aZY7XN5CKOsRxcAs3UqnG3WOXN0
         mwK7vAHle2AnYrrP/zVIA5eKZp6pmkNKiARkhf2O+2eUo9dJGxn91XuAv91wW0Ao4a
         RH9oDjxrG7Jg0kDgZj4ztXOx0rH1bRCpjjWJnRtp6YfAmJNqmCW3iqom+8JHsyuJYp
         67rFBt1zbP/gg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH net] net: fec_mpc52xx: don't discard const from netdev->dev_addr
Date:   Mon, 24 Jan 2022 09:22:49 -0800
Message-Id: <20220124172249.2827138-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent changes made netdev->dev_addr const, and it's passed
directly to mpc52xx_fec_set_paddr().

Similar problem exists on the probe patch, the driver needs
to call eth_hw_addr_set().

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/freescale/fec_mpc52xx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index bbbde9f701c2..be0bd4b44926 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -99,13 +99,13 @@ static void mpc52xx_fec_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	netif_wake_queue(dev);
 }
 
-static void mpc52xx_fec_set_paddr(struct net_device *dev, u8 *mac)
+static void mpc52xx_fec_set_paddr(struct net_device *dev, const u8 *mac)
 {
 	struct mpc52xx_fec_priv *priv = netdev_priv(dev);
 	struct mpc52xx_fec __iomem *fec = priv->fec;
 
-	out_be32(&fec->paddr1, *(u32 *)(&mac[0]));
-	out_be32(&fec->paddr2, (*(u16 *)(&mac[4]) << 16) | FEC_PADDR2_TYPE);
+	out_be32(&fec->paddr1, *(const u32 *)(&mac[0]));
+	out_be32(&fec->paddr2, (*(const u16 *)(&mac[4]) << 16) | FEC_PADDR2_TYPE);
 }
 
 static int mpc52xx_fec_set_mac_address(struct net_device *dev, void *addr)
@@ -893,13 +893,15 @@ static int mpc52xx_fec_probe(struct platform_device *op)
 	rv = of_get_ethdev_address(np, ndev);
 	if (rv) {
 		struct mpc52xx_fec __iomem *fec = priv->fec;
+		u8 addr[ETH_ALEN] __aligned(4);
 
 		/*
 		 * If the MAC addresse is not provided via DT then read
 		 * it back from the controller regs
 		 */
-		*(u32 *)(&ndev->dev_addr[0]) = in_be32(&fec->paddr1);
-		*(u16 *)(&ndev->dev_addr[4]) = in_be32(&fec->paddr2) >> 16;
+		*(u32 *)(&addr[0]) = in_be32(&fec->paddr1);
+		*(u16 *)(&addr[4]) = in_be32(&fec->paddr2) >> 16;
+		eth_hw_addr_set(ndev, addr);
 	}
 
 	/*
-- 
2.34.1

