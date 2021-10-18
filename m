Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F35F431FB3
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhJROcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232253AbhJROcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E508D6128E;
        Mon, 18 Oct 2021 14:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567391;
        bh=UNM/ksWOibJHwFdJn12h15WWbXNzPbUZuqJ0k01l5Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Arm+awgM19dbK8rRPBm5DJZo4w1fC4SXLosXabDKv5sN6t8Kwr4jCePIcSH9USm+7
         Bt88KTys6B0qoelFxGmM8J72UwFFybwHyEVcj+T7OZlLwJtYq5XWk1//9PL4/v8nex
         rUa/uA4BLVWx9gy8VxkkpJFf3DoFD1jhTpZsBccWx/lzLTptLQOIv4DPlKdyW8F21R
         zoj06d7B0jZq8qH+K3a78pDtEkj2KkliMgzzwJ+FrsABL554i5jpQa2n4TlWPYMf+D
         dzrsV25eshk0qLsYINI89lBagPbNlmkYIL7oINGG4SWzy3rPaszFjVjVgZNBKoyn0D
         EB3NnKLi2eujA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        romieu@fr.zoreil.com
Subject: [PATCH net-next 09/12] ethernet: sis190: use eth_hw_addr_set()
Date:   Mon, 18 Oct 2021 07:29:29 -0700
Message-Id: <20211018142932.1000613-10-kuba@kernel.org>
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
CC: romieu@fr.zoreil.com
---
 drivers/net/ethernet/sis/sis190.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sis/sis190.c b/drivers/net/ethernet/sis/sis190.c
index 5e66e3f3aafc..216bb2d34d7c 100644
--- a/drivers/net/ethernet/sis/sis190.c
+++ b/drivers/net/ethernet/sis/sis190.c
@@ -1631,6 +1631,7 @@ static int sis190_get_mac_addr_from_apc(struct pci_dev *pdev,
 	static const u16 ids[] = { 0x0965, 0x0966, 0x0968 };
 	struct sis190_private *tp = netdev_priv(dev);
 	struct pci_dev *isa_bridge;
+	u8 addr[ETH_ALEN];
 	u8 reg, tmp8;
 	unsigned int i;
 
@@ -1659,8 +1660,9 @@ static int sis190_get_mac_addr_from_apc(struct pci_dev *pdev,
 
         for (i = 0; i < ETH_ALEN; i++) {
                 outb(0x9 + i, 0x78);
-                dev->dev_addr[i] = inb(0x79);
+                addr[i] = inb(0x79);
         }
+	eth_hw_addr_set(dev, addr);
 
 	outb(0x12, 0x78);
 	reg = inb(0x79);
-- 
2.31.1

