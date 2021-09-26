Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9B6418A68
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 19:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhIZR75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 13:59:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32860 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhIZR74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 13:59:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SKSik1BoYsc88Z6CUAfQQEKWWPhteKhTzpUiVXxitYc=; b=zZwQjSC8knNoTSVSaq0HK1FHch
        fs3bgPFSKSL4lgDNhe1IDHBDsV+BGqQrI/bZlmwuUdo36c6WlH58Cyw1zeCC2fdtZb/XLfC6Buc89
        JvHakWxkZeEy4qQD58UCexLpjllMitZdz9K+ALcyD3hLa6YEc/gUz/qz0KHb8QfA2JxQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUY9i-008L12-8I; Sun, 26 Sep 2021 19:41:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     cao88yu@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net 2/3] dsa: mv88e6xxx: Fix MTU definition
Date:   Sun, 26 Sep 2021 19:41:25 +0200
Message-Id: <20210926174126.1987355-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210926174126.1987355-1-andrew@lunn.ch>
References: <20210926174126.1987355-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MTU passed to the DSA driver is the payload size, typically 1500.
However, the switch uses the frame size when applying restrictions.
Adjust the MTU with the size of the Ethernet header and the frame
checksum. The VLAN header also needs to be included when the frame
size it per port, but not when it is global.

Fixes: 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU")
Reported by: 曹煜 <cao88yu@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 12 ++++++------
 drivers/net/dsa/mv88e6xxx/global1.c |  2 ++
 drivers/net/dsa/mv88e6xxx/port.c    |  2 ++
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 86d3cab6ceef..ed4a6d18142b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2834,8 +2834,8 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
-	/* Port Control 2: don't force a good FCS, set the maximum frame size to
-	 * 10240 bytes, disable 802.1q tags checking, don't discard tagged or
+	/* Port Control 2: don't force a good FCS, set the MTU size to
+	 * 10222 bytes, disable 802.1q tags checking, don't discard tagged or
 	 * untagged frames on this port, do a destination address lookup on all
 	 * received packets as usual, disable ARP mirroring and don't send a
 	 * copy of all transmitted/received frames on this port to the CPU.
@@ -2854,7 +2854,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 		return err;
 
 	if (chip->info->ops->port_set_jumbo_size) {
-		err = chip->info->ops->port_set_jumbo_size(chip, port, 10240);
+		err = chip->info->ops->port_set_jumbo_size(chip, port, 10218);
 		if (err)
 			return err;
 	}
@@ -2944,10 +2944,10 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 
 	if (chip->info->ops->port_set_jumbo_size)
-		return 10240;
+		return 10240 - VLAN_ETH_HLEN - ETH_FCS_LEN;
 	else if (chip->info->ops->set_max_frame_size)
-		return 1632;
-	return 1522;
+		return 1632 - VLAN_ETH_HLEN - ETH_FCS_LEN;
+	return 1522 - VLAN_ETH_HLEN - ETH_FCS_LEN;
 }
 
 static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 815b0f681d69..5848112036b0 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -232,6 +232,8 @@ int mv88e6185_g1_set_max_frame_size(struct mv88e6xxx_chip *chip, int mtu)
 	u16 val;
 	int err;
 
+	mtu += ETH_HLEN + ETH_FCS_LEN;
+
 	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_CTL1, &val);
 	if (err)
 		return err;
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index f77e2ee64a60..451028c57af8 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1277,6 +1277,8 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
 	u16 reg;
 	int err;
 
+	size += VLAN_ETH_HLEN + ETH_FCS_LEN;
+
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &reg);
 	if (err)
 		return err;
-- 
2.33.0

