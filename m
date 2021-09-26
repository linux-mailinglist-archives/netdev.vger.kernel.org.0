Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E94418A69
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 19:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhIZR77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 13:59:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32862 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229721AbhIZR75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 13:59:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tBHSUVBoSLz7lFfhRyW9SecwdxQvbVMsdlK8eMIOTZw=; b=uqTmKeqZT7/AAheUECUdnmTjrq
        DyaAHIGH9AJ4K/16M9hYwvPOZ+CH0cX42LqqKvxy0L8TAoFVJb9LsOBO4N4wQTk0h8JzwIF7vOX8m
        w1lzD2CcROLx0BSOlwSCSNFUPvIf/xSTwCdAUXDz+o5baJp0YHarXNoHY3V85TDjdXys=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUY9i-008L15-9X; Sun, 26 Sep 2021 19:41:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     cao88yu@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net 3/3] dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU ports
Date:   Sun, 26 Sep 2021 19:41:26 +0200
Message-Id: <20210926174126.1987355-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210926174126.1987355-1-andrew@lunn.ch>
References: <20210926174126.1987355-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same members of the Marvell Ethernet switches impose MTU restrictions
on ports used for connecting to the CPU or another switch for DSA. If
the MTU is set too low, tagged frames will be discarded. Ensure the
worst case tagger overhead is included in setting the MTU for DSA and
CPU ports.

Fixes: 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU")
Reported by: 曹煜 <cao88yu@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 9 ++++++---
 drivers/net/dsa/mv88e6xxx/chip.h | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ed4a6d18142b..03744d1c43fc 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2944,10 +2944,10 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 
 	if (chip->info->ops->port_set_jumbo_size)
-		return 10240 - VLAN_ETH_HLEN - ETH_FCS_LEN;
+		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 	else if (chip->info->ops->set_max_frame_size)
-		return 1632 - VLAN_ETH_HLEN - ETH_FCS_LEN;
-	return 1522 - VLAN_ETH_HLEN - ETH_FCS_LEN;
+		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 }
 
 static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
@@ -2955,6 +2955,9 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret = 0;
 
+	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
+		new_mtu += EDSA_HLEN;
+
 	mv88e6xxx_reg_lock(chip);
 	if (chip->info->ops->port_set_jumbo_size)
 		ret = chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 675b1f3e43b7..59f316cc8583 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -18,6 +18,7 @@
 #include <linux/timecounter.h>
 #include <net/dsa.h>
 
+#define EDSA_HLEN		8
 #define MV88E6XXX_N_FID		4096
 
 /* PVT limits for 4-bit port and 5-bit switch */
-- 
2.33.0

