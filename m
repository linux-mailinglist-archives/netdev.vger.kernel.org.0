Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AEE4328CC
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhJRVMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232231AbhJRVMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:12:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB2D36113D;
        Mon, 18 Oct 2021 21:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634591419;
        bh=41Zf3+PZPz7ibf7n13zf/1Tf+LQmHEhoQjrPCHqs4U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyyRjLzWRBbO4mjDjdX4d0lHLR8E2AdR+XKj2BkN2dSgjwhFExqOwmi/xCei173Ps
         nUsPWICvrq3Na5t6pL79MsGn/jAh7+lHYaClSSerrmn4qC4gPHB3H41UPa/LEN0qdV
         ooyZgVK9u0hO5vf7P2bvro6SLPo2xcXbuxRU0Cny1+i9lDvh4CNOjbVHWCx1sEw7hR
         pD3y8lebu7w1b0NMhQs8VnuJjGVpZErFW7W118k3PI70om2E2UiuV/9iTb8e4A8Mt5
         Ob4n3cgo+pZKJM41go35j/W8vXdx4DZnH7N548jO2t9a5tGGJ9Jztjv3iJWgLkoTE5
         CDXqy2P1ppTpQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/6] ethernet: prestera: use eth_hw_addr_gen()
Date:   Mon, 18 Oct 2021 14:10:04 -0700
Message-Id: <20211018211007.1185777-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018211007.1185777-1-kuba@kernel.org>
References: <20211018211007.1185777-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Vadym and Taras report that the current behavior of the driver
is not exactly expected and it's better to add the port id in
like other drivers do.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index b667f560b931..d0d5a229d19d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -338,11 +338,14 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 		goto err_port_init;
 	}
 
+	eth_hw_addr_gen(dev, sw->base_mac, port->fp_id);
 	/* firmware requires that port's MAC address consist of the first
 	 * 5 bytes of the base MAC address
 	 */
-	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
-	dev->dev_addr[dev->addr_len - 1] = port->fp_id;
+	if (memcmp(dev->dev_addr, sw->base_mac, ETH_ALEN - 1)) {
+		dev_warn(prestera_dev(sw), "Port MAC address wraps for port(%u)\n", id);
+		dev_addr_mod(dev, 0, sw->base_mac, ETH_ALEN - 1);
+	}
 
 	err = prestera_hw_port_mac_set(port, dev->dev_addr);
 	if (err) {
-- 
2.31.1

