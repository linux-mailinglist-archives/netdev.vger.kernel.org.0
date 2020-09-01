Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45256259CF1
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 19:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732684AbgIARVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 13:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbgIAPMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 11:12:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4368D2078B;
        Tue,  1 Sep 2020 15:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973140;
        bh=5GNgPTtfXVvMA6ocoAn2mDIL7i+Q7oAG+au7SI1IFGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQL495QJSvNoKT0ikRti2AfZT6PwI+WZJNMljvmJWWUib1X5MCncAVvxi1+v1yiQv
         BtcOrUygYNu46Z3Np6kNCCPlYB+SYzusgngF032Rk0Ai8+Fq4owQNpIZfB0DzJUHzd
         yLmKF71KXJ1X03XcjcxzWe8J3UpVSk3e1MLJYO9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 4.4 04/62] bonding: show saner speed for broadcast mode
Date:   Tue,  1 Sep 2020 17:09:47 +0200
Message-Id: <20200901150920.936373256@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4057,13 +4057,23 @@ static netdev_tx_t bond_start_xmit(struc
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
 static int bond_ethtool_get_settings(struct net_device *bond_dev,
 				     struct ethtool_cmd *ecmd)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	unsigned long speed = 0;
 	struct list_head *iter;
 	struct slave *slave;
+	u32 speed = 0;
 
 	ecmd->duplex = DUPLEX_UNKNOWN;
 	ecmd->port = PORT_OTHER;
@@ -4075,8 +4085,13 @@ static int bond_ethtool_get_settings(str
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
 			if (ecmd->duplex == DUPLEX_UNKNOWN &&
 			    slave->duplex != DUPLEX_UNKNOWN)
 				ecmd->duplex = slave->duplex;


