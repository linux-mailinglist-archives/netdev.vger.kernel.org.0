Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6751B431FB0
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhJROcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232048AbhJROcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BF7A610A6;
        Mon, 18 Oct 2021 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567389;
        bh=MeMfZUBjYKDUHjtl75UoEHh9oZbj7AdUPIAxu4ZPfE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o62NiMuXDyLNkOUdgF8b9rOdSZC/ii0uvXWgVXFnSUD3X3i6RIelmtviVKJLUWm3Y
         E82eMhO0UfoC/lGOVsxOZod16wGfP0igRhCTPV+rpg3pn6yNmFV436nskJQ/kun713
         MujJ2gVLdpnXkxKhbBN2aIdrEjPLSi6w41Vw4OCgZgmleLXt7bh46t8bule71XQMk/
         9OE0B6+jDVQDeOJV2o6TF6hrZC1ye9IQERWHnYtVkmJN+ADKlMMBPWg4YqyhEK1WRG
         Z99rLnFH1JrPlFl+i4vo0+GKHNVb6rbKH8CgRtioR4RYyJpuF5vxRsYEJGjScWztOM
         cPxeP8tcCb7ZQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        hkallweit1@gmail.com, nic_swsd@realtek.com
Subject: [PATCH net-next 05/12] ethernet: r8169: use eth_hw_addr_set()
Date:   Mon, 18 Oct 2021 07:29:25 -0700
Message-Id: <20211018142932.1000613-6-kuba@kernel.org>
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
CC: hkallweit1@gmail.com
CC: nic_swsd@realtek.com
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0199914440ab..ee6c9c842012 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5217,7 +5217,7 @@ static int rtl_get_ether_clk(struct rtl8169_private *tp)
 static void rtl_init_mac_address(struct rtl8169_private *tp)
 {
 	struct net_device *dev = tp->dev;
-	u8 *mac_addr = dev->dev_addr;
+	u8 mac_addr[ETH_ALEN];
 	int rc;
 
 	rc = eth_platform_get_mac_address(tp_to_dev(tp), mac_addr);
@@ -5235,6 +5235,7 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 	eth_hw_addr_random(dev);
 	dev_warn(tp_to_dev(tp), "can't read MAC address, setting random one\n");
 done:
+	eth_hw_addr_set(dev, mac_addr);
 	rtl_rar_set(tp, mac_addr);
 }
 
-- 
2.31.1

