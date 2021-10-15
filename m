Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F7842FDFB
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238836AbhJOWTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238749AbhJOWTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53104611EE;
        Fri, 15 Oct 2021 22:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336221;
        bh=ZzDV/aN28Lyng98AqTtBDSAGZxj+6eYJj38zRqcpPFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ns6KgdqgQZ0j1Oqk2CFWfXoSa1iiX+PW5YuHiDwF4lRpIZ/u9CI3ml28kvrqS58eL
         PDqWNGRxOAsGmQXp4nPy7RvjfWAk5scM6sYtXsxHmdxc/YnUU5RoVOBN3POB4A7PG6
         6iep2IFiMLTtEOHse++bbhZaIzzK/FsIpA8HsqT7rgHTV6IIy03XSp441pKKnvDXBC
         qTPypoHVfx3F0S7AXi0sp4uDCNApfCFkgAYix9U446wZAMlYe4CSEcwpak2e3csYZD
         hhWGzUDwTsTMTTVY070Gq3bRpiAkKrr4ia+ClCk/Ccz1pKkxwm124yaUB7X7FUCD2N
         BpUWaw5mTEZIg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        pcnet32@frontier.com
Subject: [PATCH net-next 04/12] ethernet: amd: use eth_hw_addr_set()
Date:   Fri, 15 Oct 2021 15:16:44 -0700
Message-Id: <20211015221652.827253-5-kuba@kernel.org>
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

Read the address into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: pcnet32@frontier.com
---
 drivers/net/ethernet/amd/amd8111e.c |  4 +++-
 drivers/net/ethernet/amd/pcnet32.c  | 13 +++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 0b493467b042..9421afb950f7 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1743,6 +1743,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	unsigned long reg_addr, reg_len;
 	struct amd8111e_priv *lp;
 	struct net_device *dev;
+	u8 addr[ETH_ALEN];
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -1809,7 +1810,8 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 
 	/* Initializing MAC address */
 	for (i = 0; i < ETH_ALEN; i++)
-		dev->dev_addr[i] = readb(lp->mmio + PADR + i);
+		addr[i] = readb(lp->mmio + PADR + i);
+	eth_hw_addr_set(dev, addr);
 
 	/* Setting user defined parametrs */
 	lp->ext_phy_option = speed_duplex[card_idx];
diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index 820baa2604ac..f5c50ff377ff 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1595,6 +1595,7 @@ pcnet32_probe1(unsigned long ioaddr, int shared, struct pci_dev *pdev)
 	struct net_device *dev;
 	const struct pcnet32_access *a = NULL;
 	u8 promaddr[ETH_ALEN];
+	u8 addr[ETH_ALEN];
 	int ret = -ENODEV;
 
 	/* reset the chip */
@@ -1760,9 +1761,10 @@ pcnet32_probe1(unsigned long ioaddr, int shared, struct pci_dev *pdev)
 		unsigned int val;
 		val = a->read_csr(ioaddr, i + 12) & 0x0ffff;
 		/* There may be endianness issues here. */
-		dev->dev_addr[2 * i] = val & 0x0ff;
-		dev->dev_addr[2 * i + 1] = (val >> 8) & 0x0ff;
+		addr[2 * i] = val & 0x0ff;
+		addr[2 * i + 1] = (val >> 8) & 0x0ff;
 	}
+	eth_hw_addr_set(dev, addr);
 
 	/* read PROM address and compare with CSR address */
 	for (i = 0; i < ETH_ALEN; i++)
@@ -1780,8 +1782,11 @@ pcnet32_probe1(unsigned long ioaddr, int shared, struct pci_dev *pdev)
 	}
 
 	/* if the ethernet address is not valid, force to 00:00:00:00:00:00 */
-	if (!is_valid_ether_addr(dev->dev_addr))
-		eth_zero_addr(dev->dev_addr);
+	if (!is_valid_ether_addr(dev->dev_addr)) {
+		static const u8 zero_addr[ETH_ALEN] = {};
+
+		eth_hw_addr_set(dev, zero_addr);
+	}
 
 	if (pcnet32_debug & NETIF_MSG_PROBE) {
 		pr_cont(" %pM", dev->dev_addr);
-- 
2.31.1

