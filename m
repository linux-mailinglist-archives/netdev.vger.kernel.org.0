Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6F8455DF6
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhKROa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:30:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233068AbhKROa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:30:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81A2461406;
        Thu, 18 Nov 2021 14:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637245647;
        bh=Z5sEMqaKEjdeRs8J9yX4V/4uXgJ2vqgipplbSL1ps4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDEMALms2vFLaCE1Hmeja0wtFdkczGIul8mlayOT8ko/9t8R1WjbvPNTFQ3W+xvlY
         N8vlBR4rFYwT6tgU0orvFeqUeKBQJIn8nuWaC52CAmY4TcCwoARLlcPa/XWNcmrkEE
         ylLNt995+QKZ6/F+4tMS2C3MBdCrFBHymF1yWGbBdpUuWnJ9mTzhqFT6eASKO305qr
         rJ7ZUXx0g87C/bL70ytNiRRP4Oh9QBUU+sXyn20+L0EErola9LbYTg2+4tYf/qxL4A
         Im0c+uLVeFTDku3PdQCFX0Bz3VrM1Y6TAiDDhpjh2hwEbggEEZoaYLSZTNnc4T5hWp
         SNN/T6rD88khw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Lukasz Stelmach <l.stelmach@samsung.com>
Subject: [PATCH net-next 1/4] net: ax88796c: don't write to netdev->dev_addr directly
Date:   Thu, 18 Nov 2021 06:27:17 -0800
Message-Id: <20211118142720.3176980-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118142720.3176980-1-kuba@kernel.org>
References: <20211118142720.3176980-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The future is here, convert the new driver as we are about
to make netdev->dev_addr const.

Acked-by: Lukasz Stelmach <l.stelmach@samsung.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/asix/ax88796c_main.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index e230d8d0ff73..e7a9f9863258 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -144,12 +144,13 @@ static void ax88796c_set_mac_addr(struct net_device *ndev)
 static void ax88796c_load_mac_addr(struct net_device *ndev)
 {
 	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	u8 addr[ETH_ALEN];
 	u16 temp;
 
 	lockdep_assert_held(&ax_local->spi_lock);
 
 	/* Try the device tree first */
-	if (!eth_platform_get_mac_address(&ax_local->spi->dev, ndev->dev_addr) &&
+	if (!platform_get_ethdev_address(&ax_local->spi->dev, ndev) &&
 	    is_valid_ether_addr(ndev->dev_addr)) {
 		if (netif_msg_probe(ax_local))
 			dev_info(&ax_local->spi->dev,
@@ -159,18 +160,19 @@ static void ax88796c_load_mac_addr(struct net_device *ndev)
 
 	/* Read the MAC address from AX88796C */
 	temp = AX_READ(&ax_local->ax_spi, P3_MACASR0);
-	ndev->dev_addr[5] = (u8)temp;
-	ndev->dev_addr[4] = (u8)(temp >> 8);
+	addr[5] = (u8)temp;
+	addr[4] = (u8)(temp >> 8);
 
 	temp = AX_READ(&ax_local->ax_spi, P3_MACASR1);
-	ndev->dev_addr[3] = (u8)temp;
-	ndev->dev_addr[2] = (u8)(temp >> 8);
+	addr[3] = (u8)temp;
+	addr[2] = (u8)(temp >> 8);
 
 	temp = AX_READ(&ax_local->ax_spi, P3_MACASR2);
-	ndev->dev_addr[1] = (u8)temp;
-	ndev->dev_addr[0] = (u8)(temp >> 8);
+	addr[1] = (u8)temp;
+	addr[0] = (u8)(temp >> 8);
 
-	if (is_valid_ether_addr(ndev->dev_addr)) {
+	if (is_valid_ether_addr(addr)) {
+		eth_hw_addr_set(ndev, addr);
 		if (netif_msg_probe(ax_local))
 			dev_info(&ax_local->spi->dev,
 				 "MAC address read from ASIX chip\n");
-- 
2.31.1

