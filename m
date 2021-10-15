Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD28942FDF8
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238781AbhJOWTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238749AbhJOWTH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EA6D61181;
        Fri, 15 Oct 2021 22:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336220;
        bh=K6pls3GWczQzZMES9wiWedY5vKt2ql1T+kOFjzAv+eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKfM+F3sgNpXNHJ8J1hdnz1Z1ai4JV5F7DGxdKZSMvZhn95/fVEDdyv/aqXCyfrqM
         KFYnJZfx9G6RG0uPbjkbWetvZPHiLNI9PbKGemrEygDlOutYtrmUgSNYLm1Xksi5u4
         dVPAB7eQeyJX5RCghTxYNuu4I9Wf2er2v0hhRswrqgDZAuSyg+4xm+YSGQJPecnx8i
         6s8+IPlWf7Ys+TexGw4vGvCYjR8BN20xU1RGQV6V+H+0O41e+HZAscYihZK91jpxho
         eduXqPs946GoXUDwWNSsZyNCavjxOg1Ifee4+DsQuons03fRNi0Q3TdPxNoAlh1/WM
         nAZplW6d/ruIQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        ionut@badula.org
Subject: [PATCH net-next 01/12] ethernet: adaptec: use eth_hw_addr_set()
Date:   Fri, 15 Oct 2021 15:16:41 -0700
Message-Id: <20211015221652.827253-2-kuba@kernel.org>
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
CC: ionut@badula.org
---
 drivers/net/ethernet/adaptec/starfire.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index 16b6b83f670b..c6982f7caf9b 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -641,6 +641,7 @@ static int starfire_init_one(struct pci_dev *pdev,
 	struct netdev_private *np;
 	int i, irq, chip_idx = ent->driver_data;
 	struct net_device *dev;
+	u8 addr[ETH_ALEN];
 	long ioaddr;
 	void __iomem *base;
 	int drv_flags, io_size;
@@ -696,7 +697,8 @@ static int starfire_init_one(struct pci_dev *pdev,
 
 	/* Serial EEPROM reads are hidden by the hardware. */
 	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = readb(base + EEPROMCtrl + 20 - i);
+		addr[i] = readb(base + EEPROMCtrl + 20 - i);
+	eth_hw_addr_set(dev, addr);
 
 #if ! defined(final_version) /* Dump the EEPROM contents during development. */
 	if (debug > 4)
-- 
2.31.1

