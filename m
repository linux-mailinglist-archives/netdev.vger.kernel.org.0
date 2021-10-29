Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB34243F50F
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 04:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhJ2Ctl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 22:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231544AbhJ2Ctk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 22:49:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC2F961166;
        Fri, 29 Oct 2021 02:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635475633;
        bh=rqTqR5Etp5HMBUJs+PVAunAmZDTscMKOoULYOP1iE+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thJgQ7kdXob0yUlOXZswutH5rpKkVVh/ZkvcLiXKOWZic7OnHmx+gBHQWJ7UQkZON
         r5ILI6LDZfxf/cGH35MOeSIlvwPW4B39rRoaocp++HmpnR1dpmz9WqBA/YIrQFUDcb
         yKtcSX/dc65Z8IV6mrfnLuUI51AcLCMPlEr4H2qeYT7/0ykzjsqcTFHC/KG65Ef7Kl
         mjJC4XpvyG3qlUJVxJHXwhjAieBWtb8moptmYiHe/Holmzo/DpkOo36lqIERmp14qq
         jKcdsLGXzZPF7f98qcuCSgU1ew1QxOLRNX/d3tk1pHvo89+YFLCA5e6zGOT4JM8moP
         TsBr1X6H90ZKw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        robinmholt@gmail.com, steve.wahl@hpe.com, mike.travis@hpe.com,
        arnd@arndb.de, gregkh@linuxfoundation.org
Subject: [PATCH net-next 1/3] net: sgi-xp: use eth_hw_addr_set()
Date:   Thu, 28 Oct 2021 19:47:05 -0700
Message-Id: <20211029024707.316066-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029024707.316066-1-kuba@kernel.org>
References: <20211029024707.316066-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it go through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: robinmholt@gmail.com
CC: steve.wahl@hpe.com
CC: mike.travis@hpe.com
CC: arnd@arndb.de
CC: gregkh@linuxfoundation.org
---
 drivers/misc/sgi-xp/xpnet.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
index 2508f83bdc3f..dab7b92db790 100644
--- a/drivers/misc/sgi-xp/xpnet.c
+++ b/drivers/misc/sgi-xp/xpnet.c
@@ -514,6 +514,7 @@ static const struct net_device_ops xpnet_netdev_ops = {
 static int __init
 xpnet_init(void)
 {
+	u8 addr[ETH_ALEN];
 	int result;
 
 	if (!is_uv_system())
@@ -545,15 +546,17 @@ xpnet_init(void)
 	xpnet_device->min_mtu = XPNET_MIN_MTU;
 	xpnet_device->max_mtu = XPNET_MAX_MTU;
 
+	memset(addr, 0, sizeof(addr));
 	/*
 	 * Multicast assumes the LSB of the first octet is set for multicast
 	 * MAC addresses.  We chose the first octet of the MAC to be unlikely
 	 * to collide with any vendor's officially issued MAC.
 	 */
-	xpnet_device->dev_addr[0] = 0x02;     /* locally administered, no OUI */
+	addr[0] = 0x02;     /* locally administered, no OUI */
 
-	xpnet_device->dev_addr[XPNET_PARTID_OCTET + 1] = xp_partition_id;
-	xpnet_device->dev_addr[XPNET_PARTID_OCTET + 0] = (xp_partition_id >> 8);
+	addr[XPNET_PARTID_OCTET + 1] = xp_partition_id;
+	addr[XPNET_PARTID_OCTET + 0] = (xp_partition_id >> 8);
+	eth_hw_addr_set(xpnet_device, addr);
 
 	/*
 	 * ether_setup() sets this to a multicast device.  We are
-- 
2.31.1

