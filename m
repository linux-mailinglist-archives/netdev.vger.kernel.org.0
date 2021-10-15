Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E531642FE02
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238975AbhJOWTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238854AbhJOWTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A50611EE;
        Fri, 15 Oct 2021 22:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336223;
        bh=zQIFxNvsbWLg83k6dNof1PbOqUOcEUw/Z3YN4gDqUl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8nRpyILvrUiF1U1HxJx0rnZWczFN6wIFtlOD84GZm1x9eIWgQmWgwuYrnzyLdXNO
         hz5isjQHZa/FJa4YPXE/TDzx53u28Aq0iN5loKNXi/1r8RQV0q03a5UFEPWKqSFlE3
         uPA1o5DIfaW/4OQrwNphEU1i1eD/WB0HyFlfhf+G6aP6kPxM51qGEjNypce1Cj4i5R
         oCADURMV9LKSKIr3TbDVZcCvMW5koZyFcv/jbtPHsesxOCXEh4ovMMCpVe1I3GNiUf
         XutmnbiJQZPUt05RCnVg9EgmUZJrdPIzBXMh6kKKMTr2oRomHr5sCYkTxkpePODe49
         mR+f7vX1QJyfQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        claudiu.manoil@nxp.com
Subject: [PATCH net-next 10/12] ethernet: enetc: use eth_hw_addr_set()
Date:   Fri, 15 Oct 2021 15:16:50 -0700
Message-Id: <20211015221652.827253-11-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015221652.827253-1-kuba@kernel.org>
References: <20211015221652.827253-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Pass a netdev into the helper instead of just the address,
read the address into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: claudiu.manoil@nxp.com
---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 6 +++++-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 2 +-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 0f5f081a5baf..1514e6a4a3ff 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -635,10 +635,14 @@ struct enetc_cmd_rfse {
 #define ENETC_RFSE_EN	BIT(15)
 #define ENETC_RFSE_MODE_BD	2
 
-static inline void enetc_get_primary_mac_addr(struct enetc_hw *hw, u8 *addr)
+static inline void enetc_load_primary_mac_addr(struct enetc_hw *hw,
+					       struct net_device *ndev)
 {
+	u8 addr[ETH_ALEN] __aligned(4);
+
 	*(u32 *)addr = __raw_readl(hw->reg + ENETC_SIPMAR0);
 	*(u16 *)(addr + 4) = __raw_readw(hw->reg + ENETC_SIPMAR1);
+	eth_hw_addr_set(ndev, addr);
 }
 
 #define ENETC_SI_INT_IDX	0
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 8281dd664f4e..ead2b93bf614 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -783,7 +783,7 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	}
 
 	/* pick up primary MAC address from SI */
-	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
+	enetc_load_primary_mac_addr(&si->hw, ndev);
 }
 
 static int enetc_mdio_probe(struct enetc_pf *pf, struct device_node *np)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index df312c9f8243..17924305afa2 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -135,7 +135,7 @@ static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 		ndev->hw_features |= NETIF_F_RXHASH;
 
 	/* pick up primary MAC address from SI */
-	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
+	enetc_load_primary_mac_addr(&si->hw, ndev);
 }
 
 static int enetc_vf_probe(struct pci_dev *pdev,
-- 
2.31.1

