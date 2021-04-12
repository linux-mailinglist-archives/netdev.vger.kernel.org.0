Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C423535CE06
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245536AbhDLQl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343994AbhDLQga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:36:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88BF3613ED;
        Mon, 12 Apr 2021 16:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244851;
        bh=/MG3KWNNLYHNW9Rh6BkTYR1TFQXUkcBfuNY6i+S1LtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/SwGlg/MAW+B0kS8x6vNAj1HvleUufq/OVYBM+Bav0Lsngg7e/iFt5wqJF5V+d0W
         ZdpYAUyehm1uV2G+BL6+ZcFKd7gQ3Ls/mcu+5UFSYXSLgGk+2dxMSZ1ppGdXUknMPO
         cLEmCIq03OhWAHHlxOXIWx3MtYiKri47EGm4bKq/Jl1Fw0qRvlMDoG8EDsAbs+pbpq
         6/zhpFHjhnEBpJUs0XhTje10rTa8d4/xL+aPyZSQht+hcQn0l2C9MM063OXu3eYxdg
         TcyUSyMZXCubGmVCnKAdLVuWbl8XaP/B1vJlD0kfKilLmL6sREtlqW0irPu+hMcRh7
         BhZfmnvodjeTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 20/23] pcnet32: Use pci_resource_len to validate PCI resource
Date:   Mon, 12 Apr 2021 12:27:01 -0400
Message-Id: <20210412162704.315783-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162704.315783-1-sashal@kernel.org>
References: <20210412162704.315783-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 66c3f05ddc538ee796321210c906b6ae6fc0792a ]

pci_resource_start() is not a good indicator to determine if a PCI
resource exists or not, since the resource may start at address 0.
This is seen when trying to instantiate the driver in qemu for riscv32
or riscv64.

pci 0000:00:01.0: reg 0x10: [io  0x0000-0x001f]
pci 0000:00:01.0: reg 0x14: [mem 0x00000000-0x0000001f]
...
pcnet32: card has no PCI IO resources, aborting

Use pci_resouce_len() instead.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pcnet32.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index c22bf52d3320..c3887ac3d04d 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1493,8 +1493,7 @@ pcnet32_probe_pci(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	pci_set_master(pdev);
 
-	ioaddr = pci_resource_start(pdev, 0);
-	if (!ioaddr) {
+	if (!pci_resource_len(pdev, 0)) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
 			pr_err("card has no PCI IO resources, aborting\n");
 		return -ENODEV;
@@ -1506,6 +1505,8 @@ pcnet32_probe_pci(struct pci_dev *pdev, const struct pci_device_id *ent)
 			pr_err("architecture does not support 32bit PCI busmaster DMA\n");
 		return err;
 	}
+
+	ioaddr = pci_resource_start(pdev, 0);
 	if (!request_region(ioaddr, PCNET32_TOTAL_SIZE, "pcnet32_probe_pci")) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
 			pr_err("io address range already allocated\n");
-- 
2.30.2

