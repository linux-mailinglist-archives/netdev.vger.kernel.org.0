Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364C3431FB6
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhJROcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232355AbhJROcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ABDD61350;
        Mon, 18 Oct 2021 14:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567391;
        bh=UNgP6mt73WUSWJjOQ3PXI6RUpAtumqrzrmNHdQ+OO84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6uXXuJX4+J1U/Ht9xyIL/0qo/+JRoWv6T95hrnSWSnHEmsh7QAPIqyJG5YHc7M4g
         c7yjm40wxTpZFAEDUPlSpmGMVpHEyLJcUhg9ybigyuy9YPQlYUIl9mWkWV85fyFM0j
         zqYQ6P78AgrPW3cc8eC0FEBDUevFxcg5XlzPcn7EK7ojWi8xlkag9Zdoj/fwHFaqzF
         kZkgmNMRveB07b0tvTWr9aGzYu1ZT2DBs2SwDNmCDXPj47bqs5PkCRfjQuBc6ZMtjB
         EsKo1CHuqYaHIw2K2pZa6bauDyf3dLHPre4xLdr04KmA2OQgxT4dog/MYPxTSmLIFj
         3XqzZ0Xn8ng5w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        venza@brownhat.org
Subject: [PATCH net-next 10/12] ethernet: sis900: use eth_hw_addr_set()
Date:   Mon, 18 Oct 2021 07:29:30 -0700
Message-Id: <20211018142932.1000613-11-kuba@kernel.org>
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
CC: venza@brownhat.org
---
 drivers/net/ethernet/sis/sis900.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 3f5717a1874f..cc2d907c4c4b 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -292,6 +292,7 @@ static int sis630e_get_mac_addr(struct pci_dev *pci_dev,
 				struct net_device *net_dev)
 {
 	struct pci_dev *isa_bridge = NULL;
+	u8 addr[ETH_ALEN];
 	u8 reg;
 	int i;
 
@@ -308,8 +309,9 @@ static int sis630e_get_mac_addr(struct pci_dev *pci_dev,
 
 	for (i = 0; i < 6; i++) {
 		outb(0x09 + i, 0x70);
-		((u8 *)(net_dev->dev_addr))[i] = inb(0x71);
+		addr[i] = inb(0x71);
 	}
+	eth_hw_addr_set(net_dev, addr);
 
 	pci_write_config_byte(isa_bridge, 0x48, reg & ~0x40);
 	pci_dev_put(isa_bridge);
-- 
2.31.1

