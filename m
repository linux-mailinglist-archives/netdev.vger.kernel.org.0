Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B7036B781
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhDZRFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbhDZRFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:05:37 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD743C06138D
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:04:55 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 4so29461848lfp.11
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=kKkucO9X6ibabos7fPcUypA+Pj+E3QMe4AxVgMyLmmM=;
        b=prMeCvrE5BIq1CAbTQB2gFw4BYxHfwr8Sex94hsd4mhnxxc+xmWJqONge1srAd0Nbw
         DXhcY8J+Ms7r+OUk+cTTW7x9DLBhgzCaEUezpWI2aQqoXXxz1RnpMjUOUJTAi6lbpwFB
         9RVlZsws1Ov7fUr4ginu/eGjC/6qsbq610kF1apAzVREqulpf2ef5izYFl7BomPQh2eY
         bLIdtA9ztWdhM5JYVjUiGp2j3n5A3HN/+0RW8hM3pK7FCrwIG6NDKQheiYvvcAalAAoY
         q247BMgG3pp8R3eqzLPAfPDoiSSsN3TZPBwafrTJyS26qptnJKXnZmnWO5vtw+whv8dn
         Yrdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=kKkucO9X6ibabos7fPcUypA+Pj+E3QMe4AxVgMyLmmM=;
        b=eizcY/ssJ1D1DDxhEg5rAikurEoMzTCB4IjwToZ6KvpjSl9CkSEVGbd4uHC6S2HGVL
         tpNrClaqtUrkM7nCC21zxY3Cc5K11oQcMyktIQuy37k7WOnQ+4oUmiZB5wkvIZeZ/YBa
         YB5uC7lZXh+WfYHLZvy5bLTUn+Ha6is/7i3cZp7KkeWhv8CP/U+ZHeLA+1WdnGwDKJLO
         ojR3cxLr5YAAfrXXsaRApnj/VK8IfmdU4uow4qMyRIOn5ATUFjq8NtDWohUm8NHmV7Rf
         XujIAZfRYEC1GB7Ez0HddnK7FslpiDVnR1C0X3Q1deoD0VJSk9KsVRkvOie0W8hRa1vy
         qw2g==
X-Gm-Message-State: AOAM5331BUtiQoDNhZ4emsRhZUZG/AViULqEfzeBc1ecHhcAR9IGM4+G
        MFdFxSIT+Sf83uhqQjcz6AV7iA==
X-Google-Smtp-Source: ABdhPJzI+VtQpR+B3VOAI1EFBQwSMslc6j+PBjb01GOCCeArUfc249Xml6Jm6xzM3uZzpKhK3cY/pQ==
X-Received: by 2002:ac2:4e8c:: with SMTP id o12mr13546072lfr.211.1619456694279;
        Mon, 26 Apr 2021 10:04:54 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c18sm59140ljd.66.2021.04.26.10.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 10:04:53 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        jiri@resnulli.us, idosch@idosch.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [RFC net-next 8/9] net: dsa: mv88e6xxx: Map virtual bridge port in PVT
Date:   Mon, 26 Apr 2021 19:04:10 +0200
Message-Id: <20210426170411.1789186-9-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426170411.1789186-1-tobias@waldekranz.com>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that each bridge has a unique DSA device/port tuple, make sure
that each chip limits forwarding from the bridge to only include
fabric ports and local ports that are members of the same bridge.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 MAINTAINERS                      |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c | 33 ++++++++++++++++++++++++--------
 drivers/net/dsa/mv88e6xxx/dst.c  | 33 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/dst.h  |  2 ++
 include/linux/dsa/mv88e6xxx.h    | 13 +++++++++++++
 5 files changed, 74 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/dsa/mv88e6xxx.h

diff --git a/MAINTAINERS b/MAINTAINERS
index c3c8fa572580..8794b05793b2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10647,6 +10647,7 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/marvell.txt
 F:	Documentation/networking/devlink/mv88e6xxx.rst
 F:	drivers/net/dsa/mv88e6xxx/
+F:	include/linux/dsa/mv88e6xxx.h
 F:	include/linux/platform_data/mv88e6xxx.h
 
 MARVELL ARMADA 3700 PHY DRIVERS
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 06ef654472b7..6975cf16da65 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -12,6 +12,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/delay.h>
+#include <linux/dsa/mv88e6xxx.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_bridge.h>
@@ -1229,15 +1230,25 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 		}
 	}
 
-	/* Prevent frames from unknown switch or port */
-	if (!found)
-		return 0;
+	if (found) {
+		/* Frames from DSA links and CPU ports can egress any
+		 * local port.
+		 */
+		if (dp->type == DSA_PORT_TYPE_CPU ||
+		    dp->type == DSA_PORT_TYPE_DSA)
+			return mv88e6xxx_port_mask(chip);
 
-	/* Frames from DSA links and CPU ports can egress any local port */
-	if (dp->type == DSA_PORT_TYPE_CPU || dp->type == DSA_PORT_TYPE_DSA)
-		return mv88e6xxx_port_mask(chip);
+		br = dp->bridge_dev;
+	} else {
+		br = mv88e6xxx_dst_bridge_from_dsa(dst, dev, port);
+
+		/* Reject frames from ports that are neither physical
+		 * nor virtual bridge ports.
+		 */
+		if (!br)
+			return 0;
+	}
 
-	br = dp->bridge_dev;
 	pvlan = 0;
 
 	/* Frames from user ports can egress any local DSA links and CPU ports,
@@ -2340,6 +2351,7 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_switch_tree *dst = ds->dst;
 	struct dsa_port *dp;
+	u8 dev, port;
 	int err;
 
 	list_for_each_entry(dp, &dst->ports, list) {
@@ -2363,7 +2375,12 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 		}
 	}
 
-	return 0;
+	/* Map the virtual bridge port if one is assigned. */
+	err = mv88e6xxx_dst_bridge_to_dsa(dst, br, &dev, &port);
+	if (!err)
+		err = mv88e6xxx_pvt_map(chip, dev, port);
+
+	return err;
 }
 
 static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/mv88e6xxx/dst.c b/drivers/net/dsa/mv88e6xxx/dst.c
index 399a818063bf..a5f9077e5b3f 100644
--- a/drivers/net/dsa/mv88e6xxx/dst.c
+++ b/drivers/net/dsa/mv88e6xxx/dst.c
@@ -33,6 +33,39 @@ struct mv88e6xxx_dst {
 #define PORT_FROM_BIT(_bit) ((_bit) % (MV88E6XXX_MAX_PVT_PORTS))
 };
 
+struct net_device *mv88e6xxx_dst_bridge_from_dsa(struct dsa_switch_tree *dst,
+						 u8 dev, u8 port)
+{
+	struct mv88e6xxx_dst *mvdst = dst->priv;
+	struct mv88e6xxx_br *mvbr;
+
+	list_for_each_entry(mvbr, &mvdst->bridges, list) {
+		if (mvbr->dev == dev && mvbr->port == port)
+			return mvbr->brdev;
+	}
+
+	return NULL;
+}
+
+int mv88e6xxx_dst_bridge_to_dsa(const struct dsa_switch_tree *dst,
+				const struct net_device *brdev,
+				u8 *dev, u8 *port)
+{
+	struct mv88e6xxx_dst *mvdst = dst->priv;
+	struct mv88e6xxx_br *mvbr;
+
+	list_for_each_entry(mvbr, &mvdst->bridges, list) {
+		if (mvbr->brdev == brdev) {
+			*dev = mvbr->dev;
+			*port = mvbr->port;
+			return 0;
+		}
+	}
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(mv88e6xxx_dst_bridge_to_dsa);
+
 int mv88e6xxx_dst_bridge_join(struct dsa_switch_tree *dst,
 			      struct net_device *brdev)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/dst.h b/drivers/net/dsa/mv88e6xxx/dst.h
index 3845a19192ef..911890ec4792 100644
--- a/drivers/net/dsa/mv88e6xxx/dst.h
+++ b/drivers/net/dsa/mv88e6xxx/dst.h
@@ -3,6 +3,8 @@
 #ifndef _MV88E6XXX_DST_H
 #define _MV88E6XXX_DST_H
 
+struct net_device *mv88e6xxx_dst_bridge_from_dsa(struct dsa_switch_tree *dst,
+						 u8 dev, u8 port);
 int mv88e6xxx_dst_bridge_join(struct dsa_switch_tree *dst,
 			      struct net_device *brdev);
 void mv88e6xxx_dst_bridge_leave(struct dsa_switch_tree *dst,
diff --git a/include/linux/dsa/mv88e6xxx.h b/include/linux/dsa/mv88e6xxx.h
new file mode 100644
index 000000000000..fa486dfe9808
--- /dev/null
+++ b/include/linux/dsa/mv88e6xxx.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _NET_DSA_MV88E6XXX_H
+#define _NET_DSA_MV88E6XXX_H
+
+#include <linux/netdevice.h>
+#include <net/dsa.h>
+
+int mv88e6xxx_dst_bridge_to_dsa(const struct dsa_switch_tree *dst,
+				const struct net_device *brdev,
+				u8 *dev, u8 *port);
+
+#endif /* _NET_DSA_MV88E6XXX_H */
-- 
2.25.1

