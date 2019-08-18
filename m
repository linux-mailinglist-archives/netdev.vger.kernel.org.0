Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB0391860
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 19:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfHRRgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 13:36:15 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45860 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfHRRgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 13:36:15 -0400
Received: by mail-qk1-f195.google.com with SMTP id m2so8749469qki.12
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 10:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kfkh0Sh6tMgOWn1v4XR70lQVh3g68k3POkBN6oHsbi8=;
        b=H+EZ+oS51mgmca4x12VXfbB8SdTWsythA4P/byZunheeyZrQVhykJxMvnk4Fy83nQ/
         AP4gnzCYqCyciEaVmWdL5VKc1GDFLng077d2tt8PuNOftNtwSvw27Q4uQpPgfJnFdHXF
         071CxfExPHvC2zVG9W8VlgDEfTrZqhd8ZyQwUi8UN+MnGRIyLdfYuYEewgEqVqA+nHcL
         bmc+lbg12d7qDXD9yFuipKBDwYHwJCaLh57TRggjHosT4U6r9BbWG8A70CBySoDagb6O
         +/j/hAOdjr+Z3/iRqeUadC99l5cSlkNJkbrN9x8sqWjuxdRGssNmk7iP21rpH19fA2C1
         5qTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kfkh0Sh6tMgOWn1v4XR70lQVh3g68k3POkBN6oHsbi8=;
        b=Rssf53PWruKQkh4/53u81vYIJUow8KJiEGsuhtwDIuWAcZlikXus7IlmmYBBcjhWeX
         05No+2jvtVVdoAwrUE0l+klBpkMRCc+tFa7phSEDodJRggYmHG7aEjl9Y7gwsysRyo9i
         fZnMCLI/XnPX4Bb6+mVpsAlMuYPS6v/gLkC7Zuruhz9Oq0fugax0EIlKAYWVuV/siUgu
         Hsw8e530X6fQHA3s4Jz8GAjxMqZBHa7iPGSZSstBfNEDBoJ8pov4o6gBE5RRNY5hnXbq
         iKBzJXDxaU2C8G0nArtR5AzHW3OYGh7vUPDXyOtwYZjVgHP8IJvvaVhF4d340fDh/htD
         Msxg==
X-Gm-Message-State: APjAAAUiis7KMXJF6XB+6T5cCgle4gjo0R0lgkg52Br18RnNcXxb5hcN
        T2l3ynuTYp0UgFOXjXPVUUKk3qWs
X-Google-Smtp-Source: APXvYqzDDzOmDeYBLknNC0tkcLjQe5Z8nO/qrqQiVB3Rnp2wusRIAmvl5/LEmp21a+E25jT8Gz2saQ==
X-Received: by 2002:a37:6392:: with SMTP id x140mr17734941qkb.114.1566149773968;
        Sun, 18 Aug 2019 10:36:13 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o34sm7446684qtc.61.2019.08.18.10.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 10:36:13 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 2/6] net: dsa: do not enable or disable non user ports
Date:   Sun, 18 Aug 2019 13:35:44 -0400
Message-Id: <20190818173548.19631-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190818173548.19631-1-vivien.didelot@gmail.com>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .port_enable and .port_disable operations are currently only
called for user ports, hence assuming they have a slave device. In
preparation for using these operations for other port types as well,
simply guard all implementations against non user ports and return
directly in such case.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c       | 10 +++++++++-
 drivers/net/dsa/bcm_sf2.c              |  6 ++++++
 drivers/net/dsa/lan9303-core.c         |  6 ++++++
 drivers/net/dsa/lantiq_gswip.c         |  6 ++++++
 drivers/net/dsa/microchip/ksz_common.c |  6 ++++++
 drivers/net/dsa/mt7530.c               |  6 ++++++
 drivers/net/dsa/mv88e6xxx/chip.c       |  6 ++++++
 7 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 907af62846ba..1639ea7b7dab 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -510,10 +510,15 @@ EXPORT_SYMBOL(b53_imp_vlan_setup);
 int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 {
 	struct b53_device *dev = ds->priv;
-	unsigned int cpu_port = ds->ports[port].cpu_dp->index;
+	unsigned int cpu_port;
 	int ret = 0;
 	u16 pvlan;
 
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
+	cpu_port = ds->ports[port].cpu_dp->index;
+
 	if (dev->ops->irq_enable)
 		ret = dev->ops->irq_enable(dev, port);
 	if (ret)
@@ -547,6 +552,9 @@ void b53_disable_port(struct dsa_switch *ds, int port)
 	struct b53_device *dev = ds->priv;
 	u8 reg;
 
+	if (!dsa_is_user_port(ds, port))
+		return;
+
 	/* Disable Tx/Rx for the port */
 	b53_read8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), &reg);
 	reg |= PORT_CTRL_RX_DISABLE | PORT_CTRL_TX_DISABLE;
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 49f99436018a..3d06262817bd 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -157,6 +157,9 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
 	unsigned int i;
 	u32 reg;
 
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
 	/* Clear the memory power down */
 	reg = core_readl(priv, CORE_MEM_PSM_VDD_CTRL);
 	reg &= ~P_TXQ_PSM_VDD(port);
@@ -222,6 +225,9 @@ static void bcm_sf2_port_disable(struct dsa_switch *ds, int port)
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	u32 reg;
 
+	if (!dsa_is_user_port(ds, port))
+		return;
+
 	/* Disable learning while in WoL mode */
 	if (priv->wol_ports_mask & (1 << port)) {
 		reg = core_readl(priv, CORE_DIS_LEARN);
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 7a2063e7737a..bbec86b9418e 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1079,6 +1079,9 @@ static int lan9303_port_enable(struct dsa_switch *ds, int port,
 {
 	struct lan9303 *chip = ds->priv;
 
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
 	return lan9303_enable_processing_port(chip, port);
 }
 
@@ -1086,6 +1089,9 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
 {
 	struct lan9303 *chip = ds->priv;
 
+	if (!dsa_is_user_port(ds, port))
+		return;
+
 	lan9303_disable_processing_port(chip, port);
 	lan9303_phy_write(ds, chip->phy_addr_base + port, MII_BMCR, BMCR_PDOWN);
 }
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 2175ec13bb2c..a69c9b9878b7 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -642,6 +642,9 @@ static int gswip_port_enable(struct dsa_switch *ds, int port,
 	struct gswip_priv *priv = ds->priv;
 	int err;
 
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
 	if (!dsa_is_cpu_port(ds, port)) {
 		err = gswip_add_single_port_br(priv, port, true);
 		if (err)
@@ -678,6 +681,9 @@ static void gswip_port_disable(struct dsa_switch *ds, int port)
 {
 	struct gswip_priv *priv = ds->priv;
 
+	if (!dsa_is_user_port(ds, port))
+		return;
+
 	if (!dsa_is_cpu_port(ds, port)) {
 		gswip_mdio_mask(priv, GSWIP_MDIO_PHY_LINK_DOWN,
 				GSWIP_MDIO_PHY_LINK_MASK,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index b45c7b972cec..b0b870f0c252 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -361,6 +361,9 @@ int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 {
 	struct ksz_device *dev = ds->priv;
 
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
 	/* setup slave port */
 	dev->dev_ops->port_setup(dev, port, false);
 	if (dev->dev_ops->phy_setup)
@@ -378,6 +381,9 @@ void ksz_disable_port(struct dsa_switch *ds, int port)
 {
 	struct ksz_device *dev = ds->priv;
 
+	if (!dsa_is_user_port(ds, port))
+		return;
+
 	dev->on_ports &= ~(1 << port);
 	dev->live_ports &= ~(1 << port);
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 3181e95586d6..c48e29486b10 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -726,6 +726,9 @@ mt7530_port_enable(struct dsa_switch *ds, int port,
 {
 	struct mt7530_priv *priv = ds->priv;
 
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
 	mutex_lock(&priv->reg_mutex);
 
 	/* Setup the MAC for the user port */
@@ -751,6 +754,9 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
 {
 	struct mt7530_priv *priv = ds->priv;
 
+	if (!dsa_is_user_port(ds, port))
+		return;
+
 	mutex_lock(&priv->reg_mutex);
 
 	/* Clear up all port matrix which could be restored in the next
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9b3ad22a5b98..5e557545df6d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2267,6 +2267,9 @@ static int mv88e6xxx_port_enable(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
 	mv88e6xxx_reg_lock(chip);
 
 	err = mv88e6xxx_serdes_power(chip, port, true);
@@ -2283,6 +2286,9 @@ static void mv88e6xxx_port_disable(struct dsa_switch *ds, int port)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
+	if (!dsa_is_user_port(ds, port))
+		return;
+
 	mv88e6xxx_reg_lock(chip);
 
 	if (mv88e6xxx_port_set_state(chip, port, BR_STATE_DISABLED))
-- 
2.22.0

