Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA14A436279
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhJUNOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhJUNOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:14:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7375261205;
        Thu, 21 Oct 2021 13:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634821939;
        bh=R+swL9rmtFSenC2ia6irgU9Xg+bV/QFrmjtvxo3XbsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iiGFiR9AtPXvLEtLJrSkKq8YyvpJD2rPBTrAhGgShZoIRr/As7wxT7ATkAAu+giE9
         v0jGu2Q4fgaA1iISi8H/ppCDO+J14EUO1en5FtLzAFJvEcrMe+76jOdf8AVtI4oU67
         yAxjguENrz4pzm31PVKiTHi4yqr5OPlD9xYuDANDMJ4u0brKXyOR6fEjcci8zCdIZP
         EkKZgwdElMqwyMtW3VhSiGhyjDoih6CWeOb7ACOQd+Yy1E8JeLk02hSy59dY//po6H
         G1csD6u/z2PDHbA4s1rGFshGa348gaaYWMhWe2Fv2ba6SgbxsnOTNnWRHKfjb9hvbV
         ZT9fkXocwc2Fw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        wei.liu@kernel.org, paul@xen.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH net-next v2 01/12] net: xen: use eth_hw_addr_set()
Date:   Thu, 21 Oct 2021 06:12:03 -0700
Message-Id: <20211021131214.2032925-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021131214.2032925-1-kuba@kernel.org>
References: <20211021131214.2032925-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: wei.liu@kernel.org
CC: paul@xen.org
CC: boris.ostrovsky@oracle.com
CC: jgross@suse.com
CC: sstabellini@kernel.org
CC: xen-devel@lists.xenproject.org
---
 drivers/net/xen-netback/interface.c | 6 ++++--
 drivers/net/xen-netfront.c          | 4 +++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index c58996c1e230..fe8e21ad8ed9 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -494,6 +494,9 @@ static const struct net_device_ops xenvif_netdev_ops = {
 struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 			    unsigned int handle)
 {
+	static const u8 dummy_addr[ETH_ALEN] = {
+		0xfe, 0xff, 0xff, 0xff, 0xff, 0xff,
+	};
 	int err;
 	struct net_device *dev;
 	struct xenvif *vif;
@@ -551,8 +554,7 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	 * stolen by an Ethernet bridge for STP purposes.
 	 * (FE:FF:FF:FF:FF:FF)
 	 */
-	eth_broadcast_addr(dev->dev_addr);
-	dev->dev_addr[0] &= ~0x01;
+	eth_hw_addr_set(dev, dummy_addr);
 
 	netif_carrier_off(dev);
 
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index e31b98403f31..57437e4b8a94 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -2157,6 +2157,7 @@ static int talk_to_netback(struct xenbus_device *dev,
 	unsigned int max_queues = 0;
 	struct netfront_queue *queue = NULL;
 	unsigned int num_queues = 1;
+	u8 addr[ETH_ALEN];
 
 	info->netdev->irq = 0;
 
@@ -2170,11 +2171,12 @@ static int talk_to_netback(struct xenbus_device *dev,
 					"feature-split-event-channels", 0);
 
 	/* Read mac addr. */
-	err = xen_net_read_mac(dev, info->netdev->dev_addr);
+	err = xen_net_read_mac(dev, addr);
 	if (err) {
 		xenbus_dev_fatal(dev, err, "parsing %s/mac", dev->nodename);
 		goto out_unlocked;
 	}
+	eth_hw_addr_set(info->netdev, addr);
 
 	info->netback_has_xdp_headroom = xenbus_read_unsigned(info->xbdev->otherend,
 							      "feature-xdp-headroom", 0);
-- 
2.31.1

