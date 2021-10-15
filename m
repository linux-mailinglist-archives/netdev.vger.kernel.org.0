Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658EE42FC46
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 21:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242758AbhJOTlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 15:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242737AbhJOTlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 15:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E01D61163;
        Fri, 15 Oct 2021 19:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634326737;
        bh=lasaPEF7hyul/ghXKuyqjlfgNsjf6HnAuWhhT9N5hh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j799qMO/Y/FqVv8yNCBt/4oIFo9+YeQ2N33XjMg+l/zQAYU6is5CSOUXH0mgtdLkV
         1FdblH8DjNoGu3MKSLTEsPuw20PVLDGVcXsb1uRq63JyUDiAq48fhYOqjU4Z9U7s1U
         /35Kh/i9cda4G62eXD6GTdHlVckETRTPyJjOmorsCiRyDzQyye03YMHoFrz3oM7jxP
         yD/9DqIpGusu7XApb2po0NKhVgIZk35VxuxcqtLyzAre24khFMUDYNv5FGluf6jm2K
         sY8L4kmZvT83rRl8EQJ8Crr2tb3E0DHvaVBgl8+sLbNC0DM3MD0hfefgPxhJMeOwZZ
         0ldW+gIwCbxjg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>,
        vkochan@marvell.com, tchornyi@marvell.com
Subject: [RFC net-next 3/6] ethernet: prestera: use eth_hw_addr_set_port()
Date:   Fri, 15 Oct 2021 12:38:45 -0700
Message-Id: <20211015193848.779420-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015193848.779420-1-kuba@kernel.org>
References: <20211015193848.779420-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

We need to make sure the last byte is zeroed.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: vkochan@marvell.com
CC: tchornyi@marvell.com
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index b667f560b931..7d179927dabe 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -290,6 +290,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 {
 	struct prestera_port *port;
 	struct net_device *dev;
+	u8 addr[ETH_ALEN] = {};
 	int err;
 
 	dev = alloc_etherdev(sizeof(*port));
@@ -341,8 +342,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	/* firmware requires that port's MAC address consist of the first
 	 * 5 bytes of the base MAC address
 	 */
-	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
-	dev->dev_addr[dev->addr_len - 1] = port->fp_id;
+	memcpy(addr, sw->base_mac, dev->addr_len - 1);
+	eth_hw_addr_set_port(dev, addr, port->fp_id);
 
 	err = prestera_hw_port_mac_set(port, dev->dev_addr);
 	if (err) {
-- 
2.31.1

