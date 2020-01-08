Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C7A133AAF
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 06:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgAHFGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 00:06:18 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35567 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgAHFGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 00:06:17 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so1115226wmb.0
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 21:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=24gi9Aj6gf61S0BZfkvmi6uYkZr8l+RSeXI4VPqeTH8=;
        b=a4OQh6k3XKsLXqFONZydKKrRI/YIGHMbQ4YB/zRTFYdNlRG50ZE8nVOSXn7BM2VaSh
         dSquchMD26XqDeL2z7Y2qRNwRXtd9mvO4InHrUvLVZfZmJFA3KNB2YK7BrMYgzY9DN9v
         aPmj49JLo2GCH5uhLoERY/+vnGyUjuO+r1zqO0JIz41KXEJpmwN5XOrpkFelp9K3cD6M
         sxgZdBwOepdV5j7RewVpWaf5QrDB/qe1DjAwGW51HadrJQDroAkNUDagL99dZfJZJPmo
         +rqDnzo9S49kzUIkCemeCEjsl5z/cnoyjqU+FzMLW0i3WleucxIzvhlMvy1o9PKW1OP8
         wpWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=24gi9Aj6gf61S0BZfkvmi6uYkZr8l+RSeXI4VPqeTH8=;
        b=hZks/jNjKvMEEXU5h5RRiXSPJxqfimfEfQQcdgSes1fJW4Jfb57txnCcgwQZB433dM
         SO6exXV069BGXBAc1+7Hnaybe5CSeXicDjNuRtD425YWDwJzp9eIeRHJ6JOl1mJEswKx
         sRDSVPtyg43nctdGTnMimcAFzSpquGptIWsmJk8Va4LI8YI2FvkiP2G11pubOFVeYNOW
         TXpSXRUFnohfldXY60XoCv1EqrOkZHksdM/85LEm6XwkKohsVMdlFr9e9FqtBue8Cs9V
         dPrgWzUEJUYDYupOncSZhutv7YtRNdk0Gs2wvlOkBW3UNbLD/jiIX83GFF+8K5Q2d75+
         1KPw==
X-Gm-Message-State: APjAAAX8vFAI2hZo1KptQN/c/nSeoAe8aG9Qcw4xrHohtGM1t647WyX3
        d4qjpEYLJly3HNe8oA5diOGwY15l
X-Google-Smtp-Source: APXvYqyneXPK12ZUq7oGU8GRujsNwKzlgaOVAFgLF5ZYje0i+VthlYvKHs9brDxtT99M3fdNUOHIdw==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr1496245wmi.31.1578459973479;
        Tue, 07 Jan 2020 21:06:13 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p5sm2730048wrt.79.2020.01.07.21.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 21:06:12 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 1/2] net: dsa: Get information about stacked DSA protocol
Date:   Tue,  7 Jan 2020 21:06:05 -0800
Message-Id: <20200108050606.22090-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200108050606.22090-1-f.fainelli@gmail.com>
References: <20200108050606.22090-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible to stack multiple DSA switches in a way that they are not
part of the tree (disjoint) but the DSA master of a switch is a DSA
slave of another. When that happens switch drivers may have to know this
is the case so as to determine whether their tagging protocol has a
remove chance of working.

This is useful for specific switch drivers such as b53 where devices
have been known to be stacked in the wild without the Broadcom tag
protocol supporting that feature. This allows b53 to continue supporting
those devices by forcing the disabling of Broadcom tags on the outermost
switches if necessary.

The get_tag_protocol() function is therefore updated to gain an
additional enum dsa_tag_protocol argument which denotes the current
tagging protocol used by the DSA master we are attached to, else
DSA_TAG_PROTO_NONE for the top of the dsa_switch_tree.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c       | 22 +++++++++++-------
 drivers/net/dsa/b53/b53_priv.h         |  4 +++-
 drivers/net/dsa/dsa_loop.c             |  3 ++-
 drivers/net/dsa/lan9303-core.c         |  3 ++-
 drivers/net/dsa/lantiq_gswip.c         |  3 ++-
 drivers/net/dsa/microchip/ksz8795.c    |  3 ++-
 drivers/net/dsa/microchip/ksz9477.c    |  3 ++-
 drivers/net/dsa/mt7530.c               |  3 ++-
 drivers/net/dsa/mv88e6060.c            |  3 ++-
 drivers/net/dsa/mv88e6xxx/chip.c       |  3 ++-
 drivers/net/dsa/ocelot/felix.c         |  3 ++-
 drivers/net/dsa/qca/ar9331.c           |  3 ++-
 drivers/net/dsa/qca8k.c                |  3 ++-
 drivers/net/dsa/rtl8366rb.c            |  3 ++-
 drivers/net/dsa/sja1105/sja1105_main.c |  3 ++-
 drivers/net/dsa/vitesse-vsc73xx-core.c |  3 ++-
 include/net/dsa.h                      |  3 ++-
 net/dsa/dsa2.c                         | 31 ++++++++++++++++++++++++--
 net/dsa/dsa_priv.h                     |  1 +
 net/dsa/slave.c                        |  4 +---
 20 files changed, 78 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index edacacfc9365..2b530a31ef0f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -573,9 +573,8 @@ EXPORT_SYMBOL(b53_disable_port);
 
 void b53_brcm_hdr_setup(struct dsa_switch *ds, int port)
 {
-	bool tag_en = !(ds->ops->get_tag_protocol(ds, port) ==
-			 DSA_TAG_PROTO_NONE);
 	struct b53_device *dev = ds->priv;
+	bool tag_en = !(dev->tag_protocol == DSA_TAG_PROTO_NONE);
 	u8 hdr_ctl, val;
 	u16 reg;
 
@@ -1876,7 +1875,8 @@ static bool b53_can_enable_brcm_tags(struct dsa_switch *ds, int port)
 	return ret;
 }
 
-enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port)
+enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port,
+					   enum dsa_tag_protocol mprot)
 {
 	struct b53_device *dev = ds->priv;
 
@@ -1886,16 +1886,22 @@ enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port)
 	 * misses on multicast addresses (TBD).
 	 */
 	if (is5325(dev) || is5365(dev) || is539x(dev) || is531x5(dev) ||
-	    !b53_can_enable_brcm_tags(ds, port))
-		return DSA_TAG_PROTO_NONE;
+	    !b53_can_enable_brcm_tags(ds, port)) {
+		dev->tag_protocol = DSA_TAG_PROTO_NONE;
+		goto out;
+	}
 
 	/* Broadcom BCM58xx chips have a flow accelerator on Port 8
 	 * which requires us to use the prepended Broadcom tag type
 	 */
-	if (dev->chip_id == BCM58XX_DEVICE_ID && port == B53_CPU_PORT)
-		return DSA_TAG_PROTO_BRCM_PREPEND;
+	if (dev->chip_id == BCM58XX_DEVICE_ID && port == B53_CPU_PORT) {
+		dev->tag_protocol = DSA_TAG_PROTO_BRCM_PREPEND;
+		goto out;
+	}
 
-	return DSA_TAG_PROTO_BRCM;
+	dev->tag_protocol = DSA_TAG_PROTO_BRCM;
+out:
+	return dev->tag_protocol;
 }
 EXPORT_SYMBOL(b53_get_tag_protocol);
 
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 1877acf05081..3c30f3a7eb29 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -118,6 +118,7 @@ struct b53_device {
 	u8 jumbo_size_reg;
 	int reset_gpio;
 	u8 num_arl_entries;
+	enum dsa_tag_protocol tag_protocol;
 
 	/* used ports mask */
 	u16 enabled_ports;
@@ -359,7 +360,8 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 		const struct switchdev_obj_port_mdb *mdb);
 int b53_mirror_add(struct dsa_switch *ds, int port,
 		   struct dsa_mall_mirror_tc_entry *mirror, bool ingress);
-enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port);
+enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port,
+					   enum dsa_tag_protocol mprot);
 void b53_mirror_del(struct dsa_switch *ds, int port,
 		    struct dsa_mall_mirror_tc_entry *mirror);
 int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index c8d7ef27fd72..fdcb70b9f0e4 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -61,7 +61,8 @@ struct dsa_loop_priv {
 static struct phy_device *phydevs[PHY_MAX_ADDR];
 
 static enum dsa_tag_protocol dsa_loop_get_protocol(struct dsa_switch *ds,
-						   int port)
+						   int port,
+						   enum dsa_tag_protocol mp)
 {
 	dev_dbg(ds->dev, "%s: port: %d\n", __func__, port);
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index e3c333a8f45d..cc17a44dd3a8 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -883,7 +883,8 @@ static int lan9303_check_device(struct lan9303 *chip)
 /* ---------------------------- DSA -----------------------------------*/
 
 static enum dsa_tag_protocol lan9303_get_tag_protocol(struct dsa_switch *ds,
-						      int port)
+						      int port,
+						      enum dsa_tag_protocol mp)
 {
 	return DSA_TAG_PROTO_LAN9303;
 }
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 955324968b74..0369c22fe3e1 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -841,7 +841,8 @@ static int gswip_setup(struct dsa_switch *ds)
 }
 
 static enum dsa_tag_protocol gswip_get_tag_protocol(struct dsa_switch *ds,
-						    int port)
+						    int port,
+						    enum dsa_tag_protocol mp)
 {
 	return DSA_TAG_PROTO_GSWIP;
 }
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 24a5e99f7fd5..47d65b77caf7 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -645,7 +645,8 @@ static void ksz8795_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 }
 
 static enum dsa_tag_protocol ksz8795_get_tag_protocol(struct dsa_switch *ds,
-						      int port)
+						      int port,
+						      enum dsa_tag_protocol mp)
 {
 	return DSA_TAG_PROTO_KSZ8795;
 }
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 50ffc63d6231..9a51b8a4de5d 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -295,7 +295,8 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 }
 
 static enum dsa_tag_protocol ksz9477_get_tag_protocol(struct dsa_switch *ds,
-						      int port)
+						      int port,
+						      enum dsa_tag_protocol mp)
 {
 	enum dsa_tag_protocol proto = DSA_TAG_PROTO_KSZ9477;
 	struct ksz_device *dev = ds->priv;
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index ed1ec10ec62b..022466ca1c19 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1223,7 +1223,8 @@ mt7530_port_vlan_del(struct dsa_switch *ds, int port,
 }
 
 static enum dsa_tag_protocol
-mtk_get_tag_protocol(struct dsa_switch *ds, int port)
+mtk_get_tag_protocol(struct dsa_switch *ds, int port,
+		     enum dsa_tag_protocol mp)
 {
 	struct mt7530_priv *priv = ds->priv;
 
diff --git a/drivers/net/dsa/mv88e6060.c b/drivers/net/dsa/mv88e6060.c
index a5a37f47b320..24b8219fd607 100644
--- a/drivers/net/dsa/mv88e6060.c
+++ b/drivers/net/dsa/mv88e6060.c
@@ -43,7 +43,8 @@ static const char *mv88e6060_get_name(struct mii_bus *bus, int sw_addr)
 }
 
 static enum dsa_tag_protocol mv88e6060_get_tag_protocol(struct dsa_switch *ds,
-							int port)
+							int port,
+							enum dsa_tag_protocol m)
 {
 	return DSA_TAG_PROTO_TRAILER;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 99816ca9e5e4..04ef4d00f134 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5217,7 +5217,8 @@ static struct mv88e6xxx_chip *mv88e6xxx_alloc_chip(struct device *dev)
 }
 
 static enum dsa_tag_protocol mv88e6xxx_get_tag_protocol(struct dsa_switch *ds,
-							int port)
+							int port,
+							enum dsa_tag_protocol m)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f072dd75cea2..feccb6201660 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -16,7 +16,8 @@
 #include "felix.h"
 
 static enum dsa_tag_protocol felix_get_tag_protocol(struct dsa_switch *ds,
-						    int port)
+						    int port,
+						    enum dsa_tag_protocol mp)
 {
 	return DSA_TAG_PROTO_OCELOT;
 }
diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index da3bece75e21..de25f99e995a 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -347,7 +347,8 @@ static void ar9331_sw_port_disable(struct dsa_switch *ds, int port)
 }
 
 static enum dsa_tag_protocol ar9331_sw_get_tag_protocol(struct dsa_switch *ds,
-							int port)
+							int port,
+							enum dsa_tag_protocol m)
 {
 	return DSA_TAG_PROTO_AR9331;
 }
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index e548289df31e..9f4205b4439b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1017,7 +1017,8 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static enum dsa_tag_protocol
-qca8k_get_tag_protocol(struct dsa_switch *ds, int port)
+qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
+		       enum dsa_tag_protocol mp)
 {
 	return DSA_TAG_PROTO_QCA;
 }
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index f5cc8b0a7c74..fd1977590cb4 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -964,7 +964,8 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 }
 
 static enum dsa_tag_protocol rtl8366_get_tag_protocol(struct dsa_switch *ds,
-						      int port)
+						      int port,
+						      enum dsa_tag_protocol mp)
 {
 	/* For now, the RTL switches are handled without any custom tags.
 	 *
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 61795833c8f5..784e6b8166a0 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1534,7 +1534,8 @@ static int sja1105_setup_8021q_tagging(struct dsa_switch *ds, bool enabled)
 }
 
 static enum dsa_tag_protocol
-sja1105_get_tag_protocol(struct dsa_switch *ds, int port)
+sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
+			 enum dsa_tag_protocol mp)
 {
 	return DSA_TAG_PROTO_SJA1105;
 }
diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 69fc0110ce04..6e21a2a5cf01 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -542,7 +542,8 @@ static int vsc73xx_phy_write(struct dsa_switch *ds, int phy, int regnum,
 }
 
 static enum dsa_tag_protocol vsc73xx_get_tag_protocol(struct dsa_switch *ds,
-						      int port)
+						      int port,
+						      enum dsa_tag_protocol mp)
 {
 	/* The switch internally uses a 8 byte header with length,
 	 * source port, tag, LPA and priority. This is supposedly
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0c39fed8cd99..63495e3443ac 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -380,7 +380,8 @@ typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
 	enum dsa_tag_protocol (*get_tag_protocol)(struct dsa_switch *ds,
-						  int port);
+						  int port,
+						  enum dsa_tag_protocol mprot);
 
 	int	(*setup)(struct dsa_switch *ds);
 	void	(*teardown)(struct dsa_switch *ds);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index c66abbed4daf..c6d81f2baf4e 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -614,6 +614,32 @@ static int dsa_port_parse_dsa(struct dsa_port *dp)
 	return 0;
 }
 
+static enum dsa_tag_protocol dsa_get_tag_protocol(struct dsa_port *dp,
+						  struct net_device *master)
+{
+	enum dsa_tag_protocol tag_protocol = DSA_TAG_PROTO_NONE;
+	struct dsa_switch *mds, *ds = dp->ds;
+	unsigned int mdp_upstream;
+	struct dsa_port *mdp;
+
+	/* It is possible to stack DSA switches onto one another when that
+	 * happens the switch driver may want to know if its tagging protocol
+	 * is going to work in such a configuration.
+	 */
+	if (dsa_slave_dev_check(master)) {
+		mdp = dsa_slave_to_port(master);
+		mds = mdp->ds;
+		mdp_upstream = dsa_upstream_port(mds, mdp->index);
+		tag_protocol = mds->ops->get_tag_protocol(mds, mdp_upstream,
+							  DSA_TAG_PROTO_NONE);
+	}
+
+	/* If the master device is not itself a DSA slave in a disjoint DSA
+	 * tree, then return immediately.
+	 */
+	return ds->ops->get_tag_protocol(ds, dp->index, tag_protocol);
+}
+
 static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 {
 	struct dsa_switch *ds = dp->ds;
@@ -621,20 +647,21 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 	const struct dsa_device_ops *tag_ops;
 	enum dsa_tag_protocol tag_protocol;
 
-	tag_protocol = ds->ops->get_tag_protocol(ds, dp->index);
+	tag_protocol = dsa_get_tag_protocol(dp, master);
 	tag_ops = dsa_tag_driver_get(tag_protocol);
 	if (IS_ERR(tag_ops)) {
 		if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
 			return -EPROBE_DEFER;
 		dev_warn(ds->dev, "No tagger for this switch\n");
+		dp->master = NULL;
 		return PTR_ERR(tag_ops);
 	}
 
+	dp->master = master;
 	dp->type = DSA_PORT_TYPE_CPU;
 	dp->filter = tag_ops->filter;
 	dp->rcv = tag_ops->rcv;
 	dp->tag_ops = tag_ops;
-	dp->master = master;
 	dp->dst = dst;
 
 	return 0;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 8a162605b861..a7662e7a691d 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -157,6 +157,7 @@ extern const struct dsa_device_ops notag_netdev_ops;
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
 int dsa_slave_create(struct dsa_port *dp);
 void dsa_slave_destroy(struct net_device *slave_dev);
+bool dsa_slave_dev_check(const struct net_device *dev);
 int dsa_slave_suspend(struct net_device *slave_dev);
 int dsa_slave_resume(struct net_device *slave_dev);
 int dsa_slave_register_notifier(void);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c1828bdc79dc..088c886e609e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -22,8 +22,6 @@
 
 #include "dsa_priv.h"
 
-static bool dsa_slave_dev_check(const struct net_device *dev);
-
 /* slave mii_bus handling ***************************************************/
 static int dsa_slave_phy_read(struct mii_bus *bus, int addr, int reg)
 {
@@ -1473,7 +1471,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	free_netdev(slave_dev);
 }
 
-static bool dsa_slave_dev_check(const struct net_device *dev)
+bool dsa_slave_dev_check(const struct net_device *dev)
 {
 	return dev->netdev_ops == &dsa_slave_netdev_ops;
 }
-- 
2.17.1

