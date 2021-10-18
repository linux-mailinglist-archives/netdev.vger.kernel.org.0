Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F882431FB7
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhJROc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhJROcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84ABC61351;
        Mon, 18 Oct 2021 14:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567391;
        bh=KZtHg7yk8Pn3Lcemcr/JPhLiHvvvJS8AYe/0uznmcVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlx1+i1tD91pl8JKDjnzvZcw8XdvNYQaFtTBEpbsYDb9/+3OHtOwd4bs9WPD5FSzn
         SD6DlJsnV/GzO14dCVA7z6ussBH/9JOdXyWG1QdZk6GSPDsAAWCdhTDFEjzrMmwtfs
         j911ZTbJ3SJSKZw0HlFjT0dL1ThkRgQafBHaoG1eo2tsLfOz3p8gw9vMnVrOOxAj0V
         KFS6Tdj5AMh3wTv9pxfZpcYyX2ZLFYSIX8AhWw1huJue/PpoVFHEda3dUIRJZeHHgL
         N0DlWnA7Z+LsS714mEpuaZZYTEFcN028ny2ZDws1DsOMUC4k/4pJ+R4la3G0esZlPJ
         biX7SARJ3Knng==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        nico@fluxnic.net
Subject: [PATCH net-next 11/12] ethernet: smc91x: use eth_hw_addr_set()
Date:   Mon, 18 Oct 2021 07:29:31 -0700
Message-Id: <20211018142932.1000613-12-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018142932.1000613-1-kuba@kernel.org>
References: <20211018142932.1000613-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Read the address into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: nico@fluxnic.net
---
 drivers/net/ethernet/smsc/smc911x.c | 4 +++-
 drivers/net/ethernet/smsc/smc91x.c  | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index b008b4e8a2a5..89381f796985 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -1788,6 +1788,7 @@ static int smc911x_probe(struct net_device *dev)
 	struct dma_slave_config	config;
 	dma_cap_mask_t mask;
 #endif
+	u8 addr[ETH_ALEN];
 
 	DBG(SMC_DEBUG_FUNC, dev, "--> %s\n", __func__);
 
@@ -1892,7 +1893,8 @@ static int smc911x_probe(struct net_device *dev)
 	spin_lock_init(&lp->lock);
 
 	/* Get the MAC address */
-	SMC_GET_MAC_ADDR(lp, dev->dev_addr);
+	SMC_GET_MAC_ADDR(lp, addr);
+	eth_hw_addr_set(dev, addr);
 
 	/* now, reset the chip, and put it into a known state */
 	smc911x_reset(dev);
diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 813ea941b91a..a31c159e96ea 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -1851,6 +1851,7 @@ static int smc_probe(struct net_device *dev, void __iomem *ioaddr,
 	int retval;
 	unsigned int val, revision_register;
 	const char *version_string;
+	u8 addr[ETH_ALEN];
 
 	DBG(2, dev, "%s: %s\n", CARDNAME, __func__);
 
@@ -1922,7 +1923,8 @@ static int smc_probe(struct net_device *dev, void __iomem *ioaddr,
 
 	/* Get the MAC address */
 	SMC_SELECT_BANK(lp, 1);
-	SMC_GET_MAC_ADDR(lp, dev->dev_addr);
+	SMC_GET_MAC_ADDR(lp, addr);
+	eth_hw_addr_set(dev, addr);
 
 	/* now, reset the chip, and put it into a known state */
 	smc_reset(dev);
-- 
2.31.1

