Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C4C33C850
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhCOVPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbhCOVPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:15:10 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04230C06175F
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:15:10 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id z25so17990957lja.3
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=NBVpGbR92gdeBgZlfx4q1NYmX4rD8uVZtTpiu2+w42Y=;
        b=nuGTEtX5V3gsp7jFgJHXSUisqe9dkxzKwCM3qOkIr7Iy/Lo16PRsiRoEq4bIicAcqt
         o/XhqX+DCgGnFUo94dKiERW+Iybxq1AIGqF7Ae0TXXzgGfSVyWm1L1KoumLhFAZiLL7f
         XucQWyl+VWWkEO/Y/1VBDSJMeJIi9tqv3YuSOw7gQBg3NaJMGX5XlE7Otd5PsXLCIY6N
         hVg7bs7DqwhOuHWYHKsOCLynoahnDK/KVlhjMxkEguXB4f4Pz6SoPnzU+8lPW8G48f3W
         n+QIWSRcNqor+7Xl16qYoZNnzWq+w4mo/VSOOWggTl8OHRQRiarouI/MlbrJoez070gV
         EhrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=NBVpGbR92gdeBgZlfx4q1NYmX4rD8uVZtTpiu2+w42Y=;
        b=f4txTk/wbn9FF1m66ElBV3rzYvEjx1MyqVWgIVrFpSvobqoSBQpe6kfCBb943ddcUL
         JfhaTAHeo5qagUjeesuDevXXAiwl4pVaiQ/3lCcthU9w8V+zKNplwdi9CaT+RCG51TaV
         5d7dt4jKfA2NgXKdbzxwArAWLxCGpWpxSeeUok6Xry9AHL0tt7CXy7lC2Q3toCWuCGMA
         cg0R3E8PyInhdNr97VrI7mV2aZuux1CeykJH8/K5loRMadxtAugXnDY85w6Ioxx8XtJh
         ogxQHEZ9/diXOF3fvC/mBw/BA8Ow0RZxYFhXQZwmvm95tUaggPfwHiUZbml5eGYZ11kx
         cETQ==
X-Gm-Message-State: AOAM532Z0ngVvEBfxkqgnKBGIqSLU22bvNI1CHEMY1dHFMPoQ+2XAArd
        XuM3sDaNHcWYDusuyZE0v8zQDw==
X-Google-Smtp-Source: ABdhPJwV9DZeL0hm4N9aKm1FQPuELBTh2dF5zIVYdl1NJ8LfPpWB8UNCV01mA6aOOaxoLv0kFh025w==
X-Received: by 2002:a2e:974f:: with SMTP id f15mr581138ljj.352.1615842908529;
        Mon, 15 Mar 2021 14:15:08 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v11sm2975003ljp.63.2021.03.15.14.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:15:08 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 4/5] net: dsa: mv88e6xxx: Offload bridge learning flag
Date:   Mon, 15 Mar 2021 22:13:59 +0100
Message-Id: <20210315211400.2805330-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315211400.2805330-1-tobias@waldekranz.com>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow a user to control automatic learning per port.

Many chips have an explicit "LearningDisable"-bit that can be used for
this, but we opt for setting/clearing the PAV instead, as it works on
all devices at least as far back as 6083.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 29 +++++++++++++++++++++--------
 drivers/net/dsa/mv88e6xxx/port.c | 21 +++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  2 ++
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 01e4ac32d1e5..48e65f22641e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2689,15 +2689,20 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 			return err;
 	}
 
-	/* Port Association Vector: when learning source addresses
-	 * of packets, add the address to the address database using
-	 * a port bitmap that has only the bit for this port set and
-	 * the other bits clear.
+	/* Port Association Vector: disable automatic address learning
+	 * on all user ports since they start out in standalone
+	 * mode. When joining a bridge, learning will be configured to
+	 * match the bridge port settings. Enable learning on all
+	 * DSA/CPU ports. NOTE: FROM_CPU frames always bypass the
+	 * learning process.
+	 *
+	 * Disable HoldAt1, IntOnAgeOut, LockedPort, IgnoreWrongData,
+	 * and RefreshLocked. I.e. setup standard automatic learning.
 	 */
-	reg = 1 << port;
-	/* Disable learning for CPU port */
-	if (dsa_is_cpu_port(ds, port))
+	if (dsa_is_user_port(ds, port))
 		reg = 0;
+	else
+		reg = 1 << port;
 
 	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,
 				   reg);
@@ -5426,7 +5431,7 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	const struct mv88e6xxx_ops *ops;
 
-	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
 		return -EINVAL;
 
 	ops = chip->info->ops;
@@ -5449,6 +5454,14 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 
 	mv88e6xxx_reg_lock(chip);
 
+	if (flags.mask & BR_LEARNING) {
+		u16 pav = (flags.val & BR_LEARNING) ? (1 << port) : 0;
+
+		err = mv88e6xxx_port_set_assoc_vector(chip, port, pav);
+		if (err)
+			goto out;
+	}
+
 	if (flags.mask & BR_FLOOD) {
 		bool unicast = !!(flags.val & BR_FLOOD);
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 4561f289ab76..d716cd61b6c6 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1171,6 +1171,27 @@ int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
 				    0x0001);
 }
 
+/* Offset 0x0B: Port Association Vector */
+
+int mv88e6xxx_port_set_assoc_vector(struct mv88e6xxx_chip *chip, int port,
+				    u16 pav)
+{
+	u16 reg, mask;
+	int err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,
+				  &reg);
+	if (err)
+		return err;
+
+	mask = GENMASK(mv88e6xxx_num_ports(chip), 0);
+	reg &= ~mask;
+	reg |= pav & mask;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,
+				    reg);
+}
+
 /* Offset 0x0C: Port ATU Control */
 
 int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port)
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index e6d0eaa6aa1d..635b6571a0e9 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -361,6 +361,8 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
 				  size_t size);
 int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
 int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
+int mv88e6xxx_port_set_assoc_vector(struct mv88e6xxx_chip *chip, int port,
+				    u16 pav);
 int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
 			       u8 out);
 int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
-- 
2.25.1

