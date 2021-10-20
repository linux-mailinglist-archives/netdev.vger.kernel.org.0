Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F9C434F78
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhJTP6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhJTP6m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 11:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24F11613A1;
        Wed, 20 Oct 2021 15:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634745388;
        bh=311L13dF8ywQGNgF2OOj+VRKp+Sqe4XJ0RRZTcUERBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8xNs/5wwKsQcHeWECz1dOn3GFZLIT0Dz76gOBQcOpU5e/GdRgLZMtDNc52OuPmsw
         EDjWAPFTIBNNzezEOl1esIuVkSs8+QOi6g8PZEBZkLDaNk66lA4WYmk0JacXIcOo8U
         z31agDBasZ+x+Nl0nXh9K907qK45UrsQJX08QfOqZsN718qXnhdnKLgxTQGbGf1XTt
         0LIsXpewTLxnn5HLXOFi9L7SlALZQuihNCMpVvwqtg0Xfw4N6iXhCHPX5/fciwjYcS
         ylAvQK9eiaGIlBnqUmHaQLu8X7u9uoT/XcHenBiUCcUWLoz3NpUfh4GEhcU/5PbmBQ
         uzCJ+jlE0bG5Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/12] net: sb1000,rionet: use eth_hw_addr_set()
Date:   Wed, 20 Oct 2021 08:56:16 -0700
Message-Id: <20211020155617.1721694-12-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020155617.1721694-1-kuba@kernel.org>
References: <20211020155617.1721694-1-kuba@kernel.org>
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

