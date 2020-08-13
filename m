Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D265C243B3E
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 16:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgHMOJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 10:09:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22865 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726102AbgHMOJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 10:09:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597327763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ov9WwCk7+UWfHEP4xpuxzRaz3npe9xUOJK6D2NPqZEY=;
        b=P604e7yAxHTGhNDNe4GqzkDGG9IN2+t7Xh0HLoPHfyHfDLF8MiQWxWTFb5PunS15lX4Qgb
        GP9bkaOQmP3FuJT2G5y80pyS641lfP85Y5j9wM9k4953PoeWGcDznErEgeGibRCs189JT9
        TBlzpBsfmVhxyimaAB4lTi2agcXJc/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-g_7Kdl7pME2wNP-Vh_37aw-1; Thu, 13 Aug 2020 10:09:19 -0400
X-MC-Unique: g_7Kdl7pME2wNP-Vh_37aw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D0CF100CEC0;
        Thu, 13 Aug 2020 14:09:18 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5A1560D34;
        Thu, 13 Aug 2020 14:09:14 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH net v2] bonding: show saner speed for broadcast mode
Date:   Thu, 13 Aug 2020 10:09:00 -0400
Message-Id: <20200813140900.7246-1-jarod@redhat.com>
In-Reply-To: <20200813035509.739-1-jarod@redhat.com>
References: <20200813035509.739-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
v2: fix description to clarify speed == that of slowest active interface

 drivers/net/bonding/bond_main.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5ad43aaf76e5..c853ca67058c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4552,13 +4552,23 @@ static netdev_tx_t bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -4570,8 +4580,13 @@ static int bond_ethtool_get_link_ksettings(struct net_device *bond_dev,
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
2.20.1

