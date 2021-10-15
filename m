Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D54242FDFA
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238810AbhJOWTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238776AbhJOWTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00949611CE;
        Fri, 15 Oct 2021 22:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336221;
        bh=zmM4+1oFxmGPs0su0F20menDbf5pqmX7D/3WHkCKDO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdj9XgWcDCa5Ryl8C0kblf+9gKIgjuRGBF0Pe5LNWWMZaQac3ZLXFQbXfongNBAmj
         dneL39xzrrnYgYg5UX4GOs2QR8NY2vnzJBnAYIiR3CC20PivsszTxF5Vetme0jTMKR
         K0cYdk+znoUPfFeDXjaihVo3MLZdrWkhA+dfAYuOjhXcUq9hgJpgR451w5AU+aApZn
         D7T8erQvaB+pUM0LGlOOVdwfXj66P7nMkhR4rR8fbAaX7VS10MBe2PrpAvLRf9B4gA
         VLSj6WUvNcAaCXXEfioXHATMSJKh4FscrV5upnxH+CnbFZDEb1YiwJco+WmTc8cfzg
         r512zA+P0KpOw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jes@trained-monkey.org, linux-acenic@sunsite.dk
Subject: [PATCH net-next 03/12] ethernet: alteon: use eth_hw_addr_set()
Date:   Fri, 15 Oct 2021 15:16:43 -0700
Message-Id: <20211015221652.827253-4-kuba@kernel.org>
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

Break the address apart into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jes@trained-monkey.org
CC: linux-acenic@sunsite.dk
---
 drivers/net/ethernet/alteon/acenic.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index eeb86bd851f9..732da15a3827 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -869,6 +869,7 @@ static int ace_init(struct net_device *dev)
 	int board_idx, ecode = 0;
 	short i;
 	unsigned char cache_size;
+	u8 addr[ETH_ALEN];
 
 	ap = netdev_priv(dev);
 	regs = ap->regs;
@@ -988,12 +989,13 @@ static int ace_init(struct net_device *dev)
 	writel(mac1, &regs->MacAddrHi);
 	writel(mac2, &regs->MacAddrLo);
 
-	dev->dev_addr[0] = (mac1 >> 8) & 0xff;
-	dev->dev_addr[1] = mac1 & 0xff;
-	dev->dev_addr[2] = (mac2 >> 24) & 0xff;
-	dev->dev_addr[3] = (mac2 >> 16) & 0xff;
-	dev->dev_addr[4] = (mac2 >> 8) & 0xff;
-	dev->dev_addr[5] = mac2 & 0xff;
+	addr[0] = (mac1 >> 8) & 0xff;
+	addr[1] = mac1 & 0xff;
+	addr[2] = (mac2 >> 24) & 0xff;
+	addr[3] = (mac2 >> 16) & 0xff;
+	addr[4] = (mac2 >> 8) & 0xff;
+	addr[5] = mac2 & 0xff;
+	eth_hw_addr_set(dev, addr);
 
 	printk("MAC: %pM\n", dev->dev_addr);
 
-- 
2.31.1

