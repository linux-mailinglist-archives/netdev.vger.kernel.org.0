Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E81456AB4
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhKSHNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233433AbhKSHNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A8AF61B51;
        Fri, 19 Nov 2021 07:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305844;
        bh=NabWgImhJSDamoHTlWTxPUEnkxxq5KliwUg/Cy5HJP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHMLysPbSDO7wRe31k/cylQD1CAmOfSSQ75UREoBVQTzfZPl51n3NZDNLBqbrKkDz
         eAwke9qe6nST3aLdtsnBQRoMhuwAaP/RYZxG5PcbE6kQzzsg3xg5qmJ7UeFM8ZLJiG
         XC47Pqdji2pXphf0qsszXjsxufejvxAap+9DdGykHgyxhPtElTKpK+B/RpJJaFAD/i
         z1h42AWHtPfYQrM7Htm0DEinZEdSxKE+IAinsG+HmWhCGvLdgFlYgKDU1MTTR2Lb1h
         YkHO5omQnxvwEtexnB9NDV1lLafEF2KtrmMJVNEwgDrg6E9lG7y7P4kXrn0ry0iwun
         S0qTneTzuwkdg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 12/15] lasi_82594: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:30 -0800
Message-Id: <20211119071033.3756560-13-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
References: <20211119071033.3756560-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_addr is set from IO reads, passed to an arch-specific helper.
Note that the helper never reads it so uninitialized temp is fine.

Fixes build on parisc.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/i825xx/lasi_82596.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/lasi_82596.c b/drivers/net/ethernet/i825xx/lasi_82596.c
index 48e001881c75..0af70094aba3 100644
--- a/drivers/net/ethernet/i825xx/lasi_82596.c
+++ b/drivers/net/ethernet/i825xx/lasi_82596.c
@@ -147,6 +147,7 @@ lan_init_chip(struct parisc_device *dev)
 	struct	net_device *netdevice;
 	struct i596_private *lp;
 	int retval = -ENOMEM;
+	u8 addr[ETH_ALEN];
 	int i;
 
 	if (!dev->irq) {
@@ -167,13 +168,14 @@ lan_init_chip(struct parisc_device *dev)
 	netdevice->base_addr = dev->hpa.start;
 	netdevice->irq = dev->irq;
 
-	if (pdc_lan_station_id(netdevice->dev_addr, netdevice->base_addr)) {
+	if (pdc_lan_station_id(addr, netdevice->base_addr)) {
 		for (i = 0; i < 6; i++) {
-			netdevice->dev_addr[i] = gsc_readb(LAN_PROM_ADDR + i);
+			addr[i] = gsc_readb(LAN_PROM_ADDR + i);
 		}
 		printk(KERN_INFO
 		       "%s: MAC of HP700 LAN read from EEPROM\n", __FILE__);
 	}
+	eth_hw_addr_set(netdevice, addr);
 
 	lp = netdev_priv(netdevice);
 	lp->options = dev->id.sversion == 0x72 ? OPT_SWAP_PORT : 0;
-- 
2.31.1

