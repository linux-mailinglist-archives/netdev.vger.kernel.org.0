Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1150EFF34A
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbfKPQYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbfKPPmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:24 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86E1F2082E;
        Sat, 16 Nov 2019 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918943;
        bh=nn55VR0mjRnVCirDI9UVbFxLsK48NZQCrZGr+lyqim4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCX7kilWCVqh3LsO5ztPw6ztY2jA5IZUL8XpLVBHKu4p6xkDQyQvM4yl7L7U6qel6
         jNlVQxPe0rQmwFQg6NqpN9UJVjdoFEJVKah03qY7Ms+EqLf26SMb2W/Nt1S9SbwSOI
         HSfBgWekFhkRFIqQkMKYtpodAdxDtyT43QKz5nEs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 066/237] net: dsa: mv88e6xxx: Fix 88E6141/6341 2500mbps SERDES speed
Date:   Sat, 16 Nov 2019 10:38:21 -0500
Message-Id: <20191116154113.7417-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>

[ Upstream commit 26422340da467538cd65eaa9c65538039ee99c8c ]

This is a fix for the port_set_speed method for the Topaz family.
Currently the same method is used as for the Peridot family, but
this is wrong for the SERDES port.

On Topaz, the SERDES port is port 5, not 9 and 10 as in Peridot.
Moreover setting alt_bit on Topaz only makes sense for port 0 (for
(differentiating 100mbps vs 200mbps). The SERDES port does not
support more than 2500mbps, so alt_bit does not make any difference.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  4 ++--
 drivers/net/dsa/mv88e6xxx/port.c | 25 +++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/port.h |  1 +
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d075f0f7a3de8..411ae9961bf4f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3028,7 +3028,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
-	.port_set_speed = mv88e6390_port_set_speed,
+	.port_set_speed = mv88e6341_port_set_speed,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
@@ -3649,7 +3649,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
-	.port_set_speed = mv88e6390_port_set_speed,
+	.port_set_speed = mv88e6341_port_set_speed,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index fdeddbfa829da..2f16a310c110e 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -228,8 +228,11 @@ static int mv88e6xxx_port_set_speed(struct mv88e6xxx_chip *chip, int port,
 		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_1000;
 		break;
 	case 2500:
-		ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000 |
-			MV88E6390_PORT_MAC_CTL_ALTSPEED;
+		if (alt_bit)
+			ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000 |
+				MV88E6390_PORT_MAC_CTL_ALTSPEED;
+		else
+			ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000;
 		break;
 	case 10000:
 		/* all bits set, fall through... */
@@ -291,6 +294,24 @@ int mv88e6185_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
 	return mv88e6xxx_port_set_speed(chip, port, speed, false, false);
 }
 
+/* Support 10, 100, 200, 1000, 2500 Mbps (e.g. 88E6341) */
+int mv88e6341_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
+{
+	if (speed == SPEED_MAX)
+		speed = port < 5 ? 1000 : 2500;
+
+	if (speed > 2500)
+		return -EOPNOTSUPP;
+
+	if (speed == 200 && port != 0)
+		return -EOPNOTSUPP;
+
+	if (speed == 2500 && port < 5)
+		return -EOPNOTSUPP;
+
+	return mv88e6xxx_port_set_speed(chip, port, speed, !port, true);
+}
+
 /* Support 10, 100, 200, 1000 Mbps (e.g. 88E6352 family) */
 int mv88e6352_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 95b59f5eb3931..cbb64a7683e28 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -280,6 +280,7 @@ int mv88e6xxx_port_set_duplex(struct mv88e6xxx_chip *chip, int port, int dup);
 
 int mv88e6065_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
 int mv88e6185_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
+int mv88e6341_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
 int mv88e6352_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
 int mv88e6390_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
 int mv88e6390x_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
-- 
2.20.1

