Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33CD49C037
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbiAZAiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:38:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33904 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbiAZAiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:38:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1BA4B81B9A
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 00:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585A8C340EB;
        Wed, 26 Jan 2022 00:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643157485;
        bh=X4yd7Dxmu5PFhFcieA8ox30wK4paNfYa0lKukRAMuz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oF00jcGG9O2JgCAACElzEdRtFg5cf9j5vTLHU8Ah/RaHgr6oPzA7JzxxZk/lR1hpj
         8NQAhKIYgsC5o3t5soLWm+9YJkcK/ii4U6mHdkPHmAqQlf/wT+G7DXJun0GsPN4ozq
         ZTDl4ePzH5CCx9Isv7uFvmXrsyXVMB5/MhAzu+9dAXnbs2aFi/z7LkQ2nez3zuoa6W
         Lwyc/mou2FFqoMsk1wemPRVLlHbVgd0YN9lbqsLEfhEnZpDhKmvbEMPTjPmnjBH0xc
         9z0TK53dUrFC+1CRU/nL+Dq8oki66vwzZJENv593auxBLa/HRsDkQCqscZ475GQ89x
         CpqeuXUVwFRUw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dave@thedillows.org, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 1/6] ethernet: 3com/typhoon: don't write directly to netdev->dev_addr
Date:   Tue, 25 Jan 2022 16:37:56 -0800
Message-Id: <20220126003801.1736586-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126003801.1736586-1-kuba@kernel.org>
References: <20220126003801.1736586-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver casts off the const and writes directly to netdev->dev_addr.
This will result in a MAC address tree corruption and a warning.

Compile tested ppc6xx_defconfig.

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/3com/typhoon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 481f1df3106c..8aec5d9fbfef 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2278,6 +2278,7 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct net_device *dev;
 	struct typhoon *tp;
 	int card_id = (int) ent->driver_data;
+	u8 addr[ETH_ALEN] __aligned(4);
 	void __iomem *ioaddr;
 	void *shared;
 	dma_addr_t shared_dma;
@@ -2409,8 +2410,9 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto error_out_reset;
 	}
 
-	*(__be16 *)&dev->dev_addr[0] = htons(le16_to_cpu(xp_resp[0].parm1));
-	*(__be32 *)&dev->dev_addr[2] = htonl(le32_to_cpu(xp_resp[0].parm2));
+	*(__be16 *)&addr[0] = htons(le16_to_cpu(xp_resp[0].parm1));
+	*(__be32 *)&addr[2] = htonl(le32_to_cpu(xp_resp[0].parm2));
+	eth_hw_addr_set(dev, addr);
 
 	if (!is_valid_ether_addr(dev->dev_addr)) {
 		err_msg = "Could not obtain valid ethernet address, aborting";
-- 
2.34.1

