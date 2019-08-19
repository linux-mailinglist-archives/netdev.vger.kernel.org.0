Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DABCA94EA2
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfHSUBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:01:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35841 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbfHSUBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:01:10 -0400
Received: by mail-qt1-f195.google.com with SMTP id z4so3332534qtc.3
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t1UQ9o8He35/DPyYwqfbn2F9VbwpmceAG9OJP8XOjrs=;
        b=EGkoenfzIAvIcFYBCCcWoF1aY6UiIG1TJcDWsyQsLYAGQAKAsJm3j8RoR7v3MYvJkM
         F9coJ9jlw145fa1nz5+AtD04Hvf5yf0IYXcuwhIkHsa8KP3Pa5ZESDNHlTp6jRGdnwy7
         XEdYaiCJx4Wsd44I7BEkH0m30Eh/GEhyI2N90dVXNOTv075WYd4mMjbvKUFz9nMx6l06
         1v6mfgue3kSQ4XBZPGLbgeuGpR71y8vSqlRARPvdcDp4gs6iUFoo0d56+bCIcSArt1Oe
         1E7G491OxI6UJeOUT8MGSYWkwzLjFgHW0NtimngsscIdQCshphKlLzRvm1TgUo9K65aR
         jVGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t1UQ9o8He35/DPyYwqfbn2F9VbwpmceAG9OJP8XOjrs=;
        b=D0SjSZnElfLuJzcNYML6c1mUvswy7QlI8kLE37ENeq8tujvr184BGGn/MQbXSl7EoY
         0AzQwluJO9oam122/fwj4TsxOhtr/p+fLRkmWSHjS2J9HWIh+OA9tJx8Ntup3WvU6B5u
         Wys3Y3piGbIKxuw6zT67zUxbdPuCUX3yBU/zj6NaicMUU4oSa5zXfuFginjlJ3zmIH4U
         /Xm/yZMSbzJ/8fU5U/dv8t7/ljzXmp0A8KaY47LQmmRN14g7Nb6iG9LTbog4hPNeFmMd
         YQRL5efs4pRa7vks9ZgxNyzc5UYdu8/y1qqtL14vymQVw1FnkyQEauReTDY+Wk0B+/6+
         +xlA==
X-Gm-Message-State: APjAAAWm0OqpOkl5ySZiG4YPnWmbRQFjJllHBqAL//zM+txXS9q2T9+n
        sMvZWKh5zWHZZZR/em0b6awXZ641i+s=
X-Google-Smtp-Source: APXvYqyrThjt/nyZFIwrZqsziQNjfsNDpTP8oMiw6sdVHQa8jvR8Vi5c3okFKGYS9qpCphK5bkELXw==
X-Received: by 2002:ac8:474d:: with SMTP id k13mr22442379qtp.266.1566244869590;
        Mon, 19 Aug 2019 13:01:09 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 18sm7452341qkh.77.2019.08.19.13.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 13:01:09 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 2/6] net: dsa: do not enable or disable non user ports
Date:   Mon, 19 Aug 2019 16:00:49 -0400
Message-Id: <20190819200053.21637-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190819200053.21637-1-vivien.didelot@gmail.com>
References: <20190819200053.21637-1-vivien.didelot@gmail.com>
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

Note that bcm_sf2_sw_suspend() currently calls bcm_sf2_port_disable()
(and thus b53_disable_port()) against the user and CPU ports, so do
not guards those functions. They will be called for unused ports in
the future, but that was expected by those drivers anyway.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c       | 7 ++++++-
 drivers/net/dsa/bcm_sf2.c              | 3 +++
 drivers/net/dsa/lan9303-core.c         | 6 ++++++
 drivers/net/dsa/lantiq_gswip.c         | 6 ++++++
 drivers/net/dsa/microchip/ksz_common.c | 6 ++++++
 drivers/net/dsa/mt7530.c               | 6 ++++++
 drivers/net/dsa/mv88e6xxx/chip.c       | 6 ++++++
 7 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 907af62846ba..7d328a5f0161 100644
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
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 49f99436018a..4f839348011d 100644
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

