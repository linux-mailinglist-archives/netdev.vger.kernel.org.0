Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE3747999A
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 09:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbhLRIPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 03:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbhLRIPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 03:15:14 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CF5C061574
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:13 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id f20so5037945qtb.4
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LX2bldX/HjuUGWiRgUp+v+y85BlyetLNLwktIV2fUMI=;
        b=K6mXe0UG8fqMA53EgK9Zx6PpEwK8dP59ivusAZycBMXc8Q/GswuWSZTmQ+3OHrZirt
         z62jYozO4GtJ7NmyEU46HZ4CH4KPzbLKBtXhso0pr6X+Qd0qir2iIW9j7434Wd+XgNga
         LoQrPSMh7SSkvh+iRCDAb3AoZ1vclFGsJkJolX4ZVRPb5FA6hFkss2UiULiDJup/0WWm
         AdxtHdyJALPX6QhHmA1n2C54StKGZ9c2hG6hasbWxnKCz71CCetdub2QA+EPeJwbCQHS
         F8vV1pkz1/aSzUHBdFQhmbui9lhlRaJLaimGPCc0o+V2Bg385uo/G5jsAkR+efHaWuq+
         TLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LX2bldX/HjuUGWiRgUp+v+y85BlyetLNLwktIV2fUMI=;
        b=DHaH0V211JkKmzp/3RDUNEUXg7FtxDCVod5NMWmPfC77j2uYDpFsqNJYHCthq3e7ji
         +P/qoh2t0usemrGJaoYV9PgMks9sW53Cq8aTms/FmnL6Vypva23N1MIpWuk+2GCXpQno
         6a1ppcyX3O6p4XM4N/FcfPk6DL3sNRl3BJ+SyDGc6zC7ajHFiijqhWIlJQxssnqD19Fb
         BcD5WPCMFxxw3BuS0GTxGSy9oDm2OWPfRUA2Mc4zqx4hRmj0xzr2HxW8BSAaUwOVGrvK
         uw6ArNbdB8IDqiFY1urhd9TLf8ndn0UpbUBy9klFhb8Hr705HuMQLZiOpP4Kg4p0f6JI
         VVpQ==
X-Gm-Message-State: AOAM533Jo+egOmHmKldJ3AXPTtv3R0kSZTIB9m1DfT+oFbTyQURCkmBs
        7OXrRl3djjU0agJh4tqgxyx/kcFw19jUMQ==
X-Google-Smtp-Source: ABdhPJw1KTQTUWe0dZXZmFP0OgrEqznCeWS4p9pjHSdJc/pWiSaEuM823s5zcEUcNItqYB4CIzLWmw==
X-Received: by 2002:a05:622a:453:: with SMTP id o19mr5497234qtx.394.1639815312830;
        Sat, 18 Dec 2021 00:15:12 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id f11sm6423357qko.84.2021.12.18.00.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 00:15:12 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2 06/13] net: dsa: realtek: use phy_read in ds->ops
Date:   Sat, 18 Dec 2021 05:14:18 -0300
Message-Id: <20211218081425.18722-7-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211218081425.18722-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ds->ops->phy_read will only be used if the ds->slave_mii_bus
was not initialized. Calling realtek_smi_setup_mdio will create a
ds->slave_mii_bus, making ds->ops->phy_read dormant.

Using ds->ops->phy_read will allow switches connected through non-SMI
interfaces (like mdio) to let ds allocate slave_mii_bus and reuse the
same code.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/realtek-smi.c |  8 ++++----
 drivers/net/dsa/realtek/realtek.h     |  3 ---
 drivers/net/dsa/realtek/rtl8365mb.c   | 10 ++++++----
 drivers/net/dsa/realtek/rtl8366rb.c   | 10 ++++++----
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 351df8792ab3..32690bd28128 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -328,17 +328,17 @@ static const struct regmap_config realtek_smi_mdio_regmap_config = {
 
 static int realtek_smi_mdio_read(struct mii_bus *bus, int addr, int regnum)
 {
-	struct realtek_priv *priv = bus->priv;
+	struct dsa_switch *ds = ((struct realtek_priv *)bus->priv)->ds;
 
-	return priv->ops->phy_read(priv, addr, regnum);
+	return ds->ops->phy_read(ds, addr, regnum);
 }
 
 static int realtek_smi_mdio_write(struct mii_bus *bus, int addr, int regnum,
 				  u16 val)
 {
-	struct realtek_priv *priv = bus->priv;
+	struct dsa_switch *ds = ((struct realtek_priv *)bus->priv)->ds;
 
-	return priv->ops->phy_write(priv, addr, regnum, val);
+	return ds->ops->phy_write(ds, addr, regnum, val);
 }
 
 static int realtek_smi_setup_mdio(struct dsa_switch *ds)
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index 58814de563a2..a03de15c4a94 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -103,9 +103,6 @@ struct realtek_ops {
 	int	(*enable_vlan)(struct realtek_priv *priv, bool enable);
 	int	(*enable_vlan4k)(struct realtek_priv *priv, bool enable);
 	int	(*enable_port)(struct realtek_priv *priv, int port, bool enable);
-	int	(*phy_read)(struct realtek_priv *priv, int phy, int regnum);
-	int	(*phy_write)(struct realtek_priv *priv, int phy, int regnum,
-			     u16 val);
 };
 
 struct realtek_variant {
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index b52bb987027c..11a985900c57 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -674,8 +674,9 @@ static int rtl8365mb_phy_ocp_write(struct realtek_priv *priv, int phy,
 	return 0;
 }
 
-static int rtl8365mb_phy_read(struct realtek_priv *priv, int phy, int regnum)
+static int rtl8365mb_phy_read(struct dsa_switch *ds, int phy, int regnum)
 {
+	struct realtek_priv *priv = ds->priv;
 	u32 ocp_addr;
 	u16 val;
 	int ret;
@@ -702,9 +703,10 @@ static int rtl8365mb_phy_read(struct realtek_priv *priv, int phy, int regnum)
 	return val;
 }
 
-static int rtl8365mb_phy_write(struct realtek_priv *priv, int phy, int regnum,
+static int rtl8365mb_phy_write(struct dsa_switch *ds, int phy, int regnum,
 			       u16 val)
 {
+	struct realtek_priv *priv = (struct realtek_priv *)ds->priv;
 	u32 ocp_addr;
 	int ret;
 
@@ -1958,6 +1960,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
 	.setup = rtl8365mb_setup,
 	.teardown = rtl8365mb_teardown,
+	.phy_read = rtl8365mb_phy_read,
+	.phy_write = rtl8365mb_phy_write,
 	.phylink_validate = rtl8365mb_phylink_validate,
 	.phylink_mac_config = rtl8365mb_phylink_mac_config,
 	.phylink_mac_link_down = rtl8365mb_phylink_mac_link_down,
@@ -1974,8 +1978,6 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops = {
 
 static const struct realtek_ops rtl8365mb_ops = {
 	.detect = rtl8365mb_detect,
-	.phy_read = rtl8365mb_phy_read,
-	.phy_write = rtl8365mb_phy_write,
 };
 
 const struct realtek_variant rtl8365mb_variant = {
diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index ff607608dead..4576f9b797c5 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1641,8 +1641,9 @@ static int rtl8366rb_enable_vlan4k(struct realtek_priv *priv, bool enable)
 				  enable ? RTL8366RB_SGCR_EN_VLAN_4KTB : 0);
 }
 
-static int rtl8366rb_phy_read(struct realtek_priv *priv, int phy, int regnum)
+static int rtl8366rb_phy_read(struct dsa_switch *ds, int phy, int regnum)
 {
+	struct realtek_priv *priv = ds->priv;
 	u32 val;
 	u32 reg;
 	int ret;
@@ -1675,9 +1676,10 @@ static int rtl8366rb_phy_read(struct realtek_priv *priv, int phy, int regnum)
 	return val;
 }
 
-static int rtl8366rb_phy_write(struct realtek_priv *priv, int phy, int regnum,
+static int rtl8366rb_phy_write(struct dsa_switch *ds, int phy, int regnum,
 			       u16 val)
 {
+	struct realtek_priv *priv = ds->priv;
 	u32 reg;
 	int ret;
 
@@ -1769,6 +1771,8 @@ static int rtl8366rb_detect(struct realtek_priv *priv)
 static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_tag_protocol = rtl8366_get_tag_protocol,
 	.setup = rtl8366rb_setup,
+	.phy_read = rtl8366rb_phy_read,
+	.phy_write = rtl8366rb_phy_write,
 	.phylink_mac_link_up = rtl8366rb_mac_link_up,
 	.phylink_mac_link_down = rtl8366rb_mac_link_down,
 	.get_strings = rtl8366_get_strings,
@@ -1801,8 +1805,6 @@ static const struct realtek_ops rtl8366rb_ops = {
 	.is_vlan_valid	= rtl8366rb_is_vlan_valid,
 	.enable_vlan	= rtl8366rb_enable_vlan,
 	.enable_vlan4k	= rtl8366rb_enable_vlan4k,
-	.phy_read	= rtl8366rb_phy_read,
-	.phy_write	= rtl8366rb_phy_write,
 };
 
 const struct realtek_variant rtl8366rb_variant = {
-- 
2.34.0

