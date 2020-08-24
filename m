Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F6424F691
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 11:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbgHXI4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 04:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730579AbgHXI4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 04:56:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31178207DF;
        Mon, 24 Aug 2020 08:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259402;
        bh=Q1TI+LHp6d08jhWY1mKLYG0n33dy9WBxpPYs0q3FpaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5nIe6RuY4VahOUXely8pQJX5iD2aFC0RrDUfdyy59quJqDvlop+K2+/XD6quiZYL
         UUxTaaB/Q+0RJGcMu7rAf9IPjsCFBOZoyZQ7Z57CcL+HexSFPLqoZw+IPM6x1+0aa3
         /71E/TD1QKhQ//i6OKDY+1bLOdMNaH1Yy9Wf6yFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jarod Wilson <jarod@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/71] bonding: show saner speed for broadcast mode
Date:   Mon, 24 Aug 2020 10:31:36 +0200
Message-Id: <20200824082358.135590476@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
References: <20200824082355.848475917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>

[ Upstream commit 4ca0d9ac3fd8f9f90b72a15d8da2aca3ffb58418 ]

Broadcast mode bonds transmit a copy of all traffic simultaneously out of
all interfaces, so the "speed" of the bond isn't really the aggregate of
all interfaces, but rather, the speed of the slowest active interface.

Also, the type of the speed field is u32, not unsigned long, so adjust
that accordingly, as required to make min() function here without
complaining about mismatching types.

Fixes: bb5b052f751b ("bond: add support to read speed and duplex via ethtool")
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 11429df743067..76fd5fc437ebe 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4200,13 +4200,23 @@ static netdev_tx_t bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return ret;
 }
 
+static u32 bond_mode_bcast_speed(struct slave *slave, u32 speed)
+{
+	if (speed == 0 || speed == SPEED_UNKNOWN)
+		speed = slave->speed;
+	else
+		speed = min(speed, slave->speed);
+
+	return speed;
+}
+
 static int bond_ethtool_get_link_ksettings(struct net_device *bond_dev,
 					   struct ethtool_link_ksettings *cmd)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	unsigned long speed = 0;
 	struct list_head *iter;
 	struct slave *slave;
+	u32 speed = 0;
 
 	cmd->base.duplex = DUPLEX_UNKNOWN;
 	cmd->base.port = PORT_OTHER;
@@ -4218,8 +4228,13 @@ static int bond_ethtool_get_link_ksettings(struct net_device *bond_dev,
 	 */
 	bond_for_each_slave(bond, slave, iter) {
 		if (bond_slave_can_tx(slave)) {
-			if (slave->speed != SPEED_UNKNOWN)
-				speed += slave->speed;
+			if (slave->speed != SPEED_UNKNOWN) {
+				if (BOND_MODE(bond) == BOND_MODE_BROADCAST)
+					speed = bond_mode_bcast_speed(slave,
+								      speed);
+				else
+					speed += slave->speed;
+			}
 			if (cmd->base.duplex == DUPLEX_UNKNOWN &&
 			    slave->duplex != DUPLEX_UNKNOWN)
 				cmd->base.duplex = slave->duplex;
-- 
2.25.1



