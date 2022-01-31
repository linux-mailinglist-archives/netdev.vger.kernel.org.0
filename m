Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612114A4ADC
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379796AbiAaPrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379790AbiAaPrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:47:07 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98460C06173B
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:47:06 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id q127so20020727ljq.2
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=XS8KE71pw/v2S961RpMqGgaRJTZC7ly+qgOupOr0icQ=;
        b=ikTdhl3iJphvERLi+185zuAqxR7uh7SolCYuWx5X1x6N3m3COjvArPCXhk9GDMFhkz
         EZfdhAtmhL0rZ8Xjz7Mp6zgUj9fNHhWfZh1Tr1azmnrXqKxEonTEZXpRFKBP95iSFS4T
         9ns7RyaaQLoQCugGLCo/dou7if4R8KQrlE7pb1dS8qNA1Xo28cFSRDTAR/g+BeG4EzAn
         UYXWkLyB0/MXFe2mmFlvn5IC4yRWDYf1rhBpkosvq55PLFHi6/JgK8isQ+wW5WVyIbdK
         wR6EsX60KxahcpKHpgWAkn2M+jeLYYchOdo1E+nIkv8rMo4+U8Z6q+Ut6vUBsrkCMpnS
         4p6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=XS8KE71pw/v2S961RpMqGgaRJTZC7ly+qgOupOr0icQ=;
        b=BjJ51aZWpFUjxdY5/DoogqLuyf9lyRYDfp4u/dTcahkj7sinjSCG0xlunJVe25Md7W
         HFLHzrgcpfxNJlBQ29E8Lx2P+LkLk2wJmcl17KlMdRKdxQMBTwhEbEuP4IaQWGVqRE5H
         S2U+6m8GTVUOGTN820SdmfG6JzGJrfaebXGzgzODwpXsp8hL6Qnb7/pM8kUBd/q1fV5y
         0uM1lTdutTW9Dc+mH1tTlZ3MJzbMoREnu1RoqQvPE1pR48oK2Qpbce0FCnd69k8ioqh6
         T0IoPGMJ2QzqkCYrtW9q6cJmvOEsco3zkg1IFZh33RGMh06vAzNcQKD2FX249K/bwAEn
         Zm+Q==
X-Gm-Message-State: AOAM532wKoPsuW7Qh0VK1Ipis2oe1fMQ0ogNv7eRX/YUktmd1Pq9ipCj
        aCZYqq1KvekP35irVxBIqtXyJA==
X-Google-Smtp-Source: ABdhPJw3hQGmvlGOAlxRdSyWR94f2t6Mk11cIMBOLJAToN2jSPJhxDpDJBsVHUW1YyvLGyGF79I2AA==
X-Received: by 2002:a05:651c:1681:: with SMTP id bd1mr13366990ljb.446.1643644024650;
        Mon, 31 Jan 2022 07:47:04 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y36sm3374769lfa.82.2022.01.31.07.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:47:04 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: dsa: mv88e6xxx: Improve isolation of standalone ports
Date:   Mon, 31 Jan 2022 16:46:51 +0100
Message-Id: <20220131154655.1614770-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220131154655.1614770-1-tobias@waldekranz.com>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear MapDA on standalone ports to bypass any ATU lookup that might
point the packet in the wrong direction. This means that all packets
are flooded using the PVT config. So make sure that standalone ports
are only allowed to communicate with the CPU port.

Here is a scenario in which this is needed:

   CPU
    |     .----.
.---0---. | .--0--.
|  sw0  | | | sw1 |
'-1-2-3-' | '-1-2-'
      '---'

- sw0p1 and sw1p1 are bridged
- sw0p2 and sw1p2 are in standalone mode
- Learning must be enabled on sw0p3 in order for hardware forwarding
  to work properly between bridged ports

1. A packet with SA :aa comes in on sw1p2
   1a. Egresses sw1p0
   1b. Ingresses sw0p3, ATU adds an entry for :aa towards port 3
   1c. Egresses sw0p0

2. A packet with DA :aa comes in on sw0p2
   2a. If an ATU lookup is done at this point, the packet will be
       incorrectly forwarded towards sw0p3. With this change in place,
       the ATU is pypassed and the packet is forwarded in accordance
       whith the PVT, which only contains the CPU port.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 32 +++++++++++++++++++++++++-------
 drivers/net/dsa/mv88e6xxx/port.c |  7 +++++--
 drivers/net/dsa/mv88e6xxx/port.h |  2 +-
 include/net/dsa.h                | 12 ++++++++++++
 4 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1023e4549359..dde6a8d0ca36 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1290,8 +1290,15 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 
 	pvlan = 0;
 
-	/* Frames from user ports can egress any local DSA links and CPU ports,
-	 * as well as any local member of their bridge group.
+	/* Frames from standalone user ports can only egress on the
+	 * CPU port.
+	 */
+	if (!dsa_port_bridge_dev_get(dp))
+		return BIT(dsa_switch_upstream_port(ds));
+
+	/* Frames from bridged user ports can egress any local DSA
+	 * links and CPU ports, as well as any local member of their
+	 * bridge group.
 	 */
 	dsa_switch_for_each_port(other_dp, ds)
 		if (other_dp->type == DSA_PORT_TYPE_CPU ||
@@ -2487,6 +2494,10 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 	if (err)
 		goto unlock;
 
+	err = mv88e6xxx_port_set_map_da(chip, port, true);
+	if (err)
+		return err;
+
 	err = mv88e6xxx_port_commit_pvid(chip, port);
 	if (err)
 		goto unlock;
@@ -2521,6 +2532,12 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 	    mv88e6xxx_port_vlan_map(chip, port))
 		dev_err(ds->dev, "failed to remap in-chip Port VLAN\n");
 
+	err = mv88e6xxx_port_set_map_da(chip, port, false);
+	if (err)
+		dev_err(ds->dev,
+			"port %d failed to restore map-DA: %pe\n",
+			port, ERR_PTR(err));
+
 	err = mv88e6xxx_port_commit_pvid(chip, port);
 	if (err)
 		dev_err(ds->dev,
@@ -2918,12 +2935,13 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 		return err;
 
 	/* Port Control 2: don't force a good FCS, set the MTU size to
-	 * 10222 bytes, disable 802.1q tags checking, don't discard tagged or
-	 * untagged frames on this port, do a destination address lookup on all
-	 * received packets as usual, disable ARP mirroring and don't send a
-	 * copy of all transmitted/received frames on this port to the CPU.
+	 * 10222 bytes, disable 802.1q tags checking, don't discard
+	 * tagged or untagged frames on this port, skip destination
+	 * address lookup on user ports, disable ARP mirroring and don't
+	 * send a copy of all transmitted/received frames on this port
+	 * to the CPU.
 	 */
-	err = mv88e6xxx_port_set_map_da(chip, port);
+	err = mv88e6xxx_port_set_map_da(chip, port, !dsa_is_user_port(ds, port));
 	if (err)
 		return err;
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index ab41619a809b..ceb450113f88 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1278,7 +1278,7 @@ int mv88e6xxx_port_drop_untagged(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, new);
 }
 
-int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port)
+int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port, bool map)
 {
 	u16 reg;
 	int err;
@@ -1287,7 +1287,10 @@ int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
-	reg |= MV88E6XXX_PORT_CTL2_MAP_DA;
+	if (map)
+		reg |= MV88E6XXX_PORT_CTL2_MAP_DA;
+	else
+		reg &= ~MV88E6XXX_PORT_CTL2_MAP_DA;
 
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
 }
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 03382b66f800..5c347cc58baf 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -425,7 +425,7 @@ int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
 int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
 int mv88e6xxx_port_drop_untagged(struct mv88e6xxx_chip *chip, int port,
 				 bool drop_untagged);
-int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
+int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port, bool map);
 int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 				     int upstream_port);
 int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 57b3e4e7413b..30f3192616e5 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -581,6 +581,18 @@ static inline bool dsa_is_upstream_port(struct dsa_switch *ds, int port)
 	return port == dsa_upstream_port(ds, port);
 }
 
+/* Return the local port used to reach the CPU port */
+static inline unsigned int dsa_switch_upstream_port(struct dsa_switch *ds)
+{
+	int p;
+
+	for (p = 0; p < ds->num_ports; p++)
+		if (!dsa_is_unused_port(ds, p))
+			return dsa_upstream_port(ds, p);
+
+	return ds->num_ports;
+}
+
 /* Return true if @upstream_ds is an upstream switch of @downstream_ds, meaning
  * that the routing port from @downstream_ds to @upstream_ds is also the port
  * which @downstream_ds uses to reach its dedicated CPU.
-- 
2.25.1

