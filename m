Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68854292CC6
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 19:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgJSR2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 13:28:46 -0400
Received: from mailout04.rmx.de ([94.199.90.94]:56039 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgJSR2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 13:28:46 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4CFNyb2jzYz3qf83;
        Mon, 19 Oct 2020 19:28:39 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CFNxB3hrGz2xDw;
        Mon, 19 Oct 2020 19:27:26 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.91) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 19 Oct
 2020 19:25:58 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH net-next 2/9] net: dsa: microchip: split ksz_common.h
Date:   Mon, 19 Oct 2020 19:24:28 +0200
Message-ID: <20201019172435.4416-3-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201019172435.4416-1-ceggers@arri.de>
References: <20201019172435.4416-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.91]
X-RMX-ID: 20201019-192726-4CFNxB3hrGz2xDw-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parts of ksz_common.h (struct ksz_device) will be required in
net/dsa/tag_ksz.c soon. So move the relevant parts into a new header
file.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 MAINTAINERS                            |  1 +
 drivers/net/dsa/microchip/ksz_common.h | 81 +---------------------
 include/linux/dsa/ksz_common.h         | 96 ++++++++++++++++++++++++++
 3 files changed, 98 insertions(+), 80 deletions(-)
 create mode 100644 include/linux/dsa/ksz_common.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8f56ced74cb1..65bb9847e8e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11469,6 +11469,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
 F:	drivers/net/dsa/microchip/*
+F:	include/linux/dsa/microchip/ksz_common.h
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index cf866e48ff66..5735374b5bc3 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -7,92 +7,13 @@
 #ifndef __KSZ_COMMON_H
 #define __KSZ_COMMON_H
 
+#include <linux/dsa/ksz_common.h>
 #include <linux/etherdevice.h>
-#include <linux/kernel.h>
-#include <linux/mutex.h>
-#include <linux/phy.h>
-#include <linux/regmap.h>
-#include <net/dsa.h>
 
 struct vlan_table {
 	u32 table[3];
 };
 
-struct ksz_port_mib {
-	struct mutex cnt_mutex;		/* structure access */
-	u8 cnt_ptr;
-	u64 *counters;
-};
-
-struct ksz_port {
-	u16 member;
-	u16 vid_member;
-	int stp_state;
-	struct phy_device phydev;
-
-	u32 on:1;			/* port is not disabled by hardware */
-	u32 phy:1;			/* port has a PHY */
-	u32 fiber:1;			/* port is fiber */
-	u32 sgmii:1;			/* port is SGMII */
-	u32 force:1;
-	u32 read:1;			/* read MIB counters in background */
-	u32 freeze:1;			/* MIB counter freeze is enabled */
-
-	struct ksz_port_mib mib;
-	phy_interface_t interface;
-};
-
-struct ksz_device {
-	struct dsa_switch *ds;
-	struct ksz_platform_data *pdata;
-	const char *name;
-
-	struct mutex dev_mutex;		/* device access */
-	struct mutex regmap_mutex;	/* regmap access */
-	struct mutex alu_mutex;		/* ALU access */
-	struct mutex vlan_mutex;	/* vlan access */
-	const struct ksz_dev_ops *dev_ops;
-
-	struct device *dev;
-	struct regmap *regmap[3];
-
-	void *priv;
-
-	struct gpio_desc *reset_gpio;	/* Optional reset GPIO */
-
-	/* chip specific data */
-	u32 chip_id;
-	int num_vlans;
-	int num_alus;
-	int num_statics;
-	int cpu_port;			/* port connected to CPU */
-	int cpu_ports;			/* port bitmap can be cpu port */
-	int phy_port_cnt;
-	int port_cnt;
-	int reg_mib_cnt;
-	int mib_cnt;
-	int mib_port_cnt;
-	int last_port;			/* ports after that not used */
-	phy_interface_t compat_interface;
-	u32 regs_size;
-	bool phy_errata_9477;
-	bool synclko_125;
-
-	struct vlan_table *vlan_cache;
-
-	struct ksz_port *ports;
-	struct delayed_work mib_read;
-	unsigned long mib_read_interval;
-	u16 br_member;
-	u16 member;
-	u16 mirror_rx;
-	u16 mirror_tx;
-	u32 features;			/* chip specific features */
-	u32 overrides;			/* chip functions set by user */
-	u16 host_mask;
-	u16 port_mask;
-};
-
 struct alu_struct {
 	/* entry 1 */
 	u8	is_static:1;
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
new file mode 100644
index 000000000000..3b22380d85c5
--- /dev/null
+++ b/include/linux/dsa/ksz_common.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Included by drivers/net/dsa/microchip/ksz_common.h and net/dsa/tag_ksz.c */
+
+#ifndef _NET_DSA_KSZ_COMMON_H_
+#define _NET_DSA_KSZ_COMMON_H_
+
+#include <linux/gpio/consumer.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/phy.h>
+#include <linux/regmap.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+#include <net/dsa.h>
+
+struct ksz_platform_data;
+struct ksz_dev_ops;
+struct vlan_table;
+
+struct ksz_port_mib {
+	struct mutex cnt_mutex;		/* structure access */
+	u8 cnt_ptr;
+	u64 *counters;
+};
+
+struct ksz_port {
+	u16 member;
+	u16 vid_member;
+	int stp_state;
+	struct phy_device phydev;
+
+	u32 on:1;			/* port is not disabled by hardware */
+	u32 phy:1;			/* port has a PHY */
+	u32 fiber:1;			/* port is fiber */
+	u32 sgmii:1;			/* port is SGMII */
+	u32 force:1;
+	u32 read:1;			/* read MIB counters in background */
+	u32 freeze:1;			/* MIB counter freeze is enabled */
+
+	struct ksz_port_mib mib;
+	phy_interface_t interface;
+};
+
+struct ksz_device {
+	struct dsa_switch *ds;
+	struct ksz_platform_data *pdata;
+	const char *name;
+
+	struct mutex dev_mutex;		/* device access */
+	struct mutex regmap_mutex;	/* regmap access */
+	struct mutex alu_mutex;		/* ALU access */
+	struct mutex vlan_mutex;	/* vlan access */
+	const struct ksz_dev_ops *dev_ops;
+
+	struct device *dev;
+	struct regmap *regmap[3];
+
+	void *priv;
+
+	struct gpio_desc *reset_gpio;	/* Optional reset GPIO */
+
+	/* chip specific data */
+	u32 chip_id;
+	int num_vlans;
+	int num_alus;
+	int num_statics;
+	int cpu_port;			/* port connected to CPU */
+	int cpu_ports;			/* port bitmap can be cpu port */
+	int phy_port_cnt;
+	int port_cnt;
+	int reg_mib_cnt;
+	int mib_cnt;
+	int mib_port_cnt;
+	int last_port;			/* ports after that not used */
+	phy_interface_t compat_interface;
+	u32 regs_size;
+	bool phy_errata_9477;
+	bool synclko_125;
+
+	struct vlan_table *vlan_cache;
+
+	struct ksz_port *ports;
+	struct delayed_work mib_read;
+	unsigned long mib_read_interval;
+	u16 br_member;
+	u16 member;
+	u16 mirror_rx;
+	u16 mirror_tx;
+	u32 features;			/* chip specific features */
+	u32 overrides;			/* chip functions set by user */
+	u16 host_mask;
+	u16 port_mask;
+};
+
+#endif /* _NET_DSA_KSZ_COMMON_H_ */
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

