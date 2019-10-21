Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6813DF73D
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 23:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387405AbfJUVEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 17:04:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38721 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbfJUVEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 17:04:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id v9so4288529wrq.5
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 14:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hBEv6QYPF0Jw/Q+VKatlmEgADK+n5RKsMHBvpwrZDdE=;
        b=HydMKHLmsweHpm+KHAhWFvDGIBeFGiHjVr3pXVl0c/PIYKlc9Ljoltj4OlVt7kH5JF
         LQ8pfUQ665VMMUpl3sBRRjtqwZ6p/lQ9QZ1ChXkUiYkI3sYRZoDgAeLJ/mjfEVpyKD6O
         4icXsAEqWzdQ27AvzQwpc6PO65Qiz1wRHYbFl5rmD0UWv+LpZznTGNZmb5YY9pvn2sPw
         XWrzTdGgTC2NEhFD9qIZwALTraU62odh1kqOwqyojl6jI6MKVvezWX1rIfmji6liF+Kq
         S9yX4ERvZrYyRokE8S2og6cymsJZFXlyoz7/LNTYbBh6nYQ+tcNT60dg99Pkia767Mqv
         OHyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hBEv6QYPF0Jw/Q+VKatlmEgADK+n5RKsMHBvpwrZDdE=;
        b=QRTp7EfcLdpm3KZKnwufB4JY/yAG4Qz1JOmKvnZe9upW1dROlVb5kAY4EOU/BFTY8j
         bSwqBlYfyfEWO9f/SZglwZwD/ZzUH/ByWJAFWBzYMRAiWFtUu1JT8P4z6sDbdMfQKLjQ
         GrfVBCKr8/W220HcW+aAE7rofe3lkmgAGyPOfTDfsynMy6T2YTL2xviUMCL7JQ/OCAem
         9Di6bT5S5bpuItJNxFXmSbZKOvoWWTzSVpjKao0Y/ZFDMDGhm2wCK7HpklEHy23DzzOO
         WLgWmFlMz7ztXuiGUi54OFo2Wer39VnlD5yRD0zwSemFys0P36+qBRRQRj9UfHKwacWg
         FYlw==
X-Gm-Message-State: APjAAAVX1lv5xzJjRbox4wlrY1xiMgdUdqa3MJ8jcHJxQio/LHwnmJko
        2BC70stW/WRRW0cHzJvCKz9zQEl5frFD6Q==
X-Google-Smtp-Source: APXvYqzRvSrYG5+T1eGF/7QzHlK0aR6XJvNjZi/GcsOK4C32G+T9MPf67ui3I7kMYk3/7oGG3EXoEA==
X-Received: by 2002:adf:ebcb:: with SMTP id v11mr218317wrn.24.1571691851409;
        Mon, 21 Oct 2019 14:04:11 -0700 (PDT)
Received: from i5wan.lan (214-247-144-85.ftth.glasoperator.nl. [85.144.247.214])
        by smtp.gmail.com with ESMTPSA id g5sm14309949wmg.12.2019.10.21.14.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 14:04:10 -0700 (PDT)
From:   Iwan R Timmer <irtimmer@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, Iwan R Timmer <irtimmer@gmail.com>
Subject: [PATCH net-next v2 2/2] net: dsa: mv88e6xxx: Add support for port mirroring
Date:   Mon, 21 Oct 2019 23:01:43 +0200
Message-Id: <20191021210143.119426-3-irtimmer@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021210143.119426-1-irtimmer@gmail.com>
References: <20191021210143.119426-1-irtimmer@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring port mirroring through the cls_matchall
classifier. We do a full ingress and/or egress capture towards a
capture port. It allows setting a different capture port for ingress
and egress traffic.

It keeps track of the mirrored ports and the destination ports to
prevent changes to the capture port while other ports are being
mirrored.

Signed-off-by: Iwan R Timmer <irtimmer@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 70 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h    |  6 +++
 drivers/net/dsa/mv88e6xxx/global1.c | 11 ++++-
 drivers/net/dsa/mv88e6xxx/port.c    | 29 ++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h    |  2 +
 5 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index e9735346838d..14e71bc98513 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4921,6 +4921,74 @@ static int mv88e6xxx_port_mdb_del(struct dsa_switch *ds, int port,
 	return err;
 }
 
+static int mv88e6xxx_port_mirror_add(struct dsa_switch *ds, int port,
+				     struct dsa_mall_mirror_tc_entry *mirror,
+				     bool ingress)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	bool other_mirrors = false;
+	int i;
+	int err;
+
+	if (!chip->info->ops->set_egress_port)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&chip->reg_lock);
+	if ((ingress ? chip->ingress_dest_port : chip->egress_dest_port) !=
+	    mirror->to_local_port) {
+		for (i = 0; i < mv88e6xxx_num_ports(chip); i++)
+			other_mirrors |= ingress ?
+					 chip->ports[i].mirror_ingress :
+					 chip->ports[i].mirror_egress;
+
+		/* Can't change egress port when other mirror is active */
+		if (other_mirrors) {
+			err = -EBUSY;
+			goto out;
+		}
+
+		err = chip->info->ops->set_egress_port(chip,
+						       ingress,
+						       mirror->to_local_port);
+		if (err)
+			goto out;
+	}
+
+	err = mv88e6xxx_port_set_mirror(chip, port, ingress, true);
+out:
+	mutex_unlock(&chip->reg_lock);
+
+	return err;
+}
+
+static void mv88e6xxx_port_mirror_del(struct dsa_switch *ds, int port,
+				      struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	bool other_mirrors = false;
+	int i;
+
+	mutex_lock(&chip->reg_lock);
+	if (mv88e6xxx_port_set_mirror(chip, port, mirror->ingress, false))
+		dev_err(ds->dev, "p%d: failed to disable mirroring\n", port);
+
+	for (i = 0; i < mv88e6xxx_num_ports(chip); i++)
+		other_mirrors |= mirror->ingress ?
+				 chip->ports[i].mirror_ingress :
+				 chip->ports[i].mirror_egress;
+
+	/* Reset egress port when no other mirror is active */
+	if (!other_mirrors) {
+		if (chip->info->ops->set_egress_port(chip,
+						     mirror->ingress,
+						     dsa_upstream_port(ds,
+								       port)));
+			dev_err(ds->dev, "failed to set egress port\n");
+	}
+
+	mutex_unlock(&chip->reg_lock);
+}
+
 static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 					 bool unicast, bool multicast)
 {
@@ -4975,6 +5043,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_mdb_prepare       = mv88e6xxx_port_mdb_prepare,
 	.port_mdb_add           = mv88e6xxx_port_mdb_add,
 	.port_mdb_del           = mv88e6xxx_port_mdb_del,
+	.port_mirror_add	= mv88e6xxx_port_mirror_add,
+	.port_mirror_del	= mv88e6xxx_port_mirror_del,
 	.crosschip_bridge_join	= mv88e6xxx_crosschip_bridge_join,
 	.crosschip_bridge_leave	= mv88e6xxx_crosschip_bridge_leave,
 	.port_hwtstamp_set	= mv88e6xxx_port_hwtstamp_set,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 42ce3109ebc9..e33a1426dac3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -228,6 +228,8 @@ struct mv88e6xxx_port {
 	u64 vtu_miss_violation;
 	u8 cmode;
 	unsigned int serdes_irq;
+	bool mirror_ingress;
+	bool mirror_egress;
 };
 
 struct mv88e6xxx_chip {
@@ -310,6 +312,10 @@ struct mv88e6xxx_chip {
 	u16 evcap_config;
 	u16 enable_count;
 
+	/* Current ingress and egress monitor ports */
+	int egress_dest_port;
+	int ingress_dest_port;
+
 	/* Per-port timestamping resources. */
 	struct mv88e6xxx_port_hwtstamp port_hwtstamp[DSA_MAX_PORTS];
 
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 35b9610cbe73..ecef80d9d88f 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -280,7 +280,16 @@ int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip, int port,
 	       __bf_shf(MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK) :
 	       __bf_shf(MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK));
 
-	return mv88e6xxx_g1_write(chip, MV88E6185_G1_MONITOR_CTL, reg);
+	err = mv88e6xxx_g1_write(chip, MV88E6185_G1_MONITOR_CTL, reg);
+	if (err)
+		return err;
+
+	if (ingress)
+		chip->ingress_dest_port = port;
+	else
+		chip->egress_dest_port = port;
+
+	return 0;
 }
 
 /* Older generations also call this the ARP destination. It has been
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 15ef81654b67..3e7aae56f27a 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1181,6 +1181,35 @@ int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
 }
 
+int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
+			      bool ingress, bool mirror)
+{
+	u16 reg;
+	u16 bit;
+	int err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &reg);
+	if (err)
+		return err;
+
+	bit = ingress ? MV88E6XXX_PORT_CTL2_INGRESS_MONITOR :
+			MV88E6XXX_PORT_CTL2_EGRESS_MONITOR;
+	reg &= ~bit;
+
+	if (mirror)
+		reg |= bit;
+
+	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
+	if (!err) {
+		if (ingress)
+			chip->ports[port].mirror_ingress = mirror;
+		else
+			chip->ports[port].mirror_egress = mirror;
+	}
+
+	return err;
+}
+
 int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int port,
 				  u16 mode)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 03a480cd71b9..e9d7b66fd49e 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -368,6 +368,8 @@ int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
 int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
 int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 				     int upstream_port);
+int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
+			      bool ingress, bool mirror);
 
 int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port);
 int mv88e6xxx_port_disable_pri_override(struct mv88e6xxx_chip *chip, int port);
-- 
2.23.0

