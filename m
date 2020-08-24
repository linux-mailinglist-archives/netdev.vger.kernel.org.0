Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8314624F574
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 10:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbgHXItP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 04:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729675AbgHXItO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 04:49:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 504092072D;
        Mon, 24 Aug 2020 08:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258953;
        bh=67NKfojbCGWv2hUDoau8jNJpjbEzin4x+MY9ySUplyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qvj6KVhhu5/s50pXdxJqxWIEM25SmCl6zF8bJWycd/fiejVpvFmt5BkQJa4dPj3UA
         /q6KsMZqWruZ39405s6+OiIbGf2EESTjS+l4gVCedk9ndTG9rwu1nHackU+IOS+cRn
         PPeJkhQTus0nngo7jQbD7beXFPlPPMeDGyAZj5io=
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
Subject: [PATCH 5.4 076/107] bonding: show saner speed for broadcast mode
Date:   Mon, 24 Aug 2020 10:30:42 +0200
Message-Id: <20200824082408.880725524@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
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
index 499845c32b1bc..11c014586d466 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4246,13 +4246,23 @@ static netdev_tx_t bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -4264,8 +4274,13 @@ static int bond_ethtool_get_link_ksettings(struct net_device *bond_dev,
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



