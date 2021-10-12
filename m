Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9C6429A06
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 02:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbhJLACh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 20:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhJLACe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 20:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2BD660F92;
        Tue, 12 Oct 2021 00:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633996834;
        bh=/ToBRatOkVzW6mSWXBQKqcobjBEygtIHEBYTY4hSzf4=;
        h=From:To:Cc:Subject:Date:From;
        b=uAhrGaS1zCNJFGtNT2I7OPvjuNRnq3DwEwT0R8wlOX6ifVlMg07hefu1Q8r6GCXlm
         XQBIK2KO/CZluO1TE9b/6KcEoWR7jrd/tGueIZivgVQ/JO19ajA+FRNe8mxFjT+MYQ
         L+WeYAu83tLyoGSpWe5bNfVpMSwa+e5D45kfXtkCYrC/By7wryk/+6KGmsjjCIAhbY
         irrHFixRMyWU0NWeCWMG7jwtLtck4JF5vIxjX1uMIpISz6OOF+rSWA06RLwrVGrJzW
         FdtLrlSUZSxyJp6j4bGu2yNQZFXX37k6/JGzzh4UMnOHSxw6spSjBTdE8i4YJsMsZE
         Ve9Q3P/RMKqtA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] ethernet: tulip: avoid duplicate variable name on sparc
Date:   Mon, 11 Oct 2021 17:00:16 -0700
Message-Id: <20211012000016.4055478-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I recently added a variable called addr to tulip_init_one()
but for sparc there's already a variable called that half
way thru the function. Rename it to fix build.

Fixes: ca8793175564 ("ethernet: tulip: remove direct netdev->dev_addr writes")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/dec/tulip/tulip_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index ec0ce8f1beea..79df5a72877b 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1605,7 +1605,7 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (sum == 0  || sum == 6*0xff) {
 #if defined(CONFIG_SPARC)
 		struct device_node *dp = pci_device_to_OF_node(pdev);
-		const unsigned char *addr;
+		const unsigned char *addr2;
 		int len;
 #endif
 		eeprom_missing = 1;
@@ -1614,9 +1614,9 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		addr[i] = last_phys_addr[i] + 1;
 		eth_hw_addr_set(dev, addr);
 #if defined(CONFIG_SPARC)
-		addr = of_get_property(dp, "local-mac-address", &len);
-		if (addr && len == ETH_ALEN)
-			eth_hw_addr_set(dev, addr);
+		addr2 = of_get_property(dp, "local-mac-address", &len);
+		if (addr2 && len == ETH_ALEN)
+			eth_hw_addr_set(dev, addr2);
 #endif
 #if defined(__i386__) || defined(__x86_64__)	/* Patch up x86 BIOS bug. */
 		if (last_irq)
-- 
2.31.1

