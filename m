Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2221D436285
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhJUNOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231169AbhJUNOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:14:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12C0A6135A;
        Thu, 21 Oct 2021 13:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634821943;
        bh=311L13dF8ywQGNgF2OOj+VRKp+Sqe4XJ0RRZTcUERBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/D/mypDtTs2oXCgpKiQhXH9aCwJHs4g8diHnoGXKhK3Vy/4+hf8BBaKedbzyFLC+
         vOT4CVYX4Vx6cC9naMEN07v+7RLO8ydwwyFx9HTtlnMEPJP51HFiHH97jdbE022BFG
         SOJAqInML2KcY5HWn2PFQ5dTeboEGEcGFlMAMguERAZnZuhVND/n3+Uzsh3zSTLYXu
         3bN1WyLQDH+7yCS/09PfPyHbyRTjvUQVJTsvbvoYVlNb8nDOINEtwhccjFMK6kZLsu
         16OSm+SI9VCkPDDURy2nKw476FWpL8BGNJTrWpqjalp2NH9l2PHGX0c0hJ8ccCCzdX
         kpiDvqn1k6/yQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 11/12] net: sb1000,rionet: use eth_hw_addr_set()
Date:   Thu, 21 Oct 2021 06:12:13 -0700
Message-Id: <20211021131214.2032925-12-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021131214.2032925-1-kuba@kernel.org>
References: <20211021131214.2032925-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get these two oldies ready for constant netdev->dev_addr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/rionet.c | 14 ++++++++------
 drivers/net/sb1000.c | 12 ++++++++----
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 2056d6ad04b5..1a95f3beb784 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -482,6 +482,7 @@ static int rionet_setup_netdev(struct rio_mport *mport, struct net_device *ndev)
 {
 	int rc = 0;
 	struct rionet_private *rnet;
+	u8 addr[ETH_ALEN];
 	u16 device_id;
 	const size_t rionet_active_bytes = sizeof(void *) *
 				RIO_MAX_ROUTE_ENTRIES(mport->sys_size);
@@ -501,12 +502,13 @@ static int rionet_setup_netdev(struct rio_mport *mport, struct net_device *ndev)
 
 	/* Set the default MAC address */
 	device_id = rio_local_get_device_id(mport);
-	ndev->dev_addr[0] = 0x00;
-	ndev->dev_addr[1] = 0x01;
-	ndev->dev_addr[2] = 0x00;
-	ndev->dev_addr[3] = 0x01;
-	ndev->dev_addr[4] = device_id >> 8;
-	ndev->dev_addr[5] = device_id & 0xff;
+	addr[0] = 0x00;
+	addr[1] = 0x01;
+	addr[2] = 0x00;
+	addr[3] = 0x01;
+	addr[4] = device_id >> 8;
+	addr[5] = device_id & 0xff;
+	eth_hw_addr_set(ndev, addr);
 
 	ndev->netdev_ops = &rionet_netdev_ops;
 	ndev->mtu = RIONET_MAX_MTU;
diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
index f01c9db01b16..57a6d598467b 100644
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -149,6 +149,7 @@ sb1000_probe_one(struct pnp_dev *pdev, const struct pnp_device_id *id)
 	unsigned short ioaddr[2], irq;
 	unsigned int serial_number;
 	int error = -ENODEV;
+	u8 addr[ETH_ALEN];
 
 	if (pnp_device_attach(pdev) < 0)
 		return -ENODEV;
@@ -203,10 +204,13 @@ sb1000_probe_one(struct pnp_dev *pdev, const struct pnp_device_id *id)
 	dev->netdev_ops	= &sb1000_netdev_ops;
 
 	/* hardware address is 0:0:serial_number */
-	dev->dev_addr[2]	= serial_number >> 24 & 0xff;
-	dev->dev_addr[3]	= serial_number >> 16 & 0xff;
-	dev->dev_addr[4]	= serial_number >>  8 & 0xff;
-	dev->dev_addr[5]	= serial_number >>  0 & 0xff;
+	addr[0] = 0;
+	addr[1] = 0;
+	addr[2]	= serial_number >> 24 & 0xff;
+	addr[3]	= serial_number >> 16 & 0xff;
+	addr[4]	= serial_number >>  8 & 0xff;
+	addr[5]	= serial_number >>  0 & 0xff;
+	eth_hw_addr_set(dev, addr);
 
 	pnp_set_drvdata(pdev, dev);
 
-- 
2.31.1

