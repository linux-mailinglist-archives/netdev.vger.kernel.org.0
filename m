Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44AB477D27
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241228AbhLPUO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241244AbhLPUO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:27 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D5BC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:27 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id a1so398319qtx.11
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3HnNpxWLagLlyBqA49CE1lSv57jgNSMlTsJjHtoQGAY=;
        b=pjVJGgzWXdMWqjuOzIOPW0L8Bk6N7QcNCeua/aNsH47Z5u13KoSjuq4UxeRoZ4o7lr
         pY4/dQ36Je7O4l0u7Csa3goGKmnGT+CzPUYa5akubCNTAAY0VdoHo3vyR0fzovJprLLp
         0V5LepoB5FqAXLdPp0to9DStAlSo42Set+bXgiUuWJn4fLwrSCo9nBKfBnOuzRgwTv5P
         ktNH//X9gtpZUjoyUqOKxYH/cjUosu2TfAYZejhYYqq9hPyHFMTn6N0fufg+/Dd5FXLW
         /xD198yW84HRdFJKy8MeExm6AWYuLWcnBu537fpXt0TYBtIyPNY3deYx0uCcZg9dYqia
         28BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3HnNpxWLagLlyBqA49CE1lSv57jgNSMlTsJjHtoQGAY=;
        b=xKVPkPOHq6vZYVajo6jTd/MR8VL0kmbe/Haj0ndnmvRrdKlnRlLplgaKaDOgCx4pnz
         ga37Siy4PXPgnHE8UUvPVYSke6vzBqWKR83q4kZW2b9MpXbyy7geofGCYbht6z+oBCmx
         dVCAe60A1d03lx6pTSpT09CmsChcN1pQxhAxSwfaOm20VDHYtx7UIPjtzuniwjDINULQ
         NyPLUvshJ39kuI2C6blIih0FMqPM1t3lw9RYBGAmFbUs2VkuqcmVvxZjNXGBtAnkM7KH
         XjvbvN1lg39Ut0IiwobwnEvRtJmmr5cOItK2jEi5+NfDrUX8yOUo+bEnl0+wo3b5o11d
         CfkA==
X-Gm-Message-State: AOAM530y6HEGtBDL3qfx7/zY/FRRQ6ckSUFkNc6ga95NHPJu9VKIFsxq
        VRvQfl7B8KYGz+tKwyHq1P3rB3H8hbyyJw==
X-Google-Smtp-Source: ABdhPJzmeloZh4uCJ5YYJu/11Fh9j4j34jj3/V42jkOvSzQWNI0PPXNymM+gL69IWHXDOazBWpBWmA==
X-Received: by 2002:a05:622a:108:: with SMTP id u8mr18251770qtw.333.1639685666026;
        Thu, 16 Dec 2021 12:14:26 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a15sm5110266qtb.5.2021.12.16.12.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:14:25 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 05/13] net: dsa: realtek: use phy_read in ds->ops
Date:   Thu, 16 Dec 2021 17:13:34 -0300
Message-Id: <20211216201342.25587-6-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

The ds->ops->phy_read will only be used if the ds->slave_mii_bus
was not initialized. Calling realtek_smi_setup_mdio will create a
ds->slave_mii_bus, making ds->ops->phy_read dormant.

Using ds->ops->phy_read will allow switches connected through non-SMI
interfaces (like mdio) to let ds allocate slave_mii_bus and reuse the
same code.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/realtek-smi.c |  8 ++++----
 drivers/net/dsa/realtek/realtek.h     |  3 ---
 drivers/net/dsa/realtek/rtl8365mb.c   | 10 ++++++----
 drivers/net/dsa/realtek/rtl8366rb.c   | 10 ++++++----
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 11447096c8dc..f10acd7d3636 100644
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
 
 int realtek_smi_setup_mdio(struct dsa_switch *ds)
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index 766e79151a6c..daca0c0b7ea2 100644
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
index d6054f63f204..488b17a68226 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -674,11 +674,12 @@ static int rtl8365mb_phy_ocp_write(struct realtek_priv *priv, int phy,
 	return 0;
 }
 
-static int rtl8365mb_phy_read(struct realtek_priv *priv, int phy, int regnum)
+static int rtl8365mb_phy_read(struct dsa_switch *ds, int phy, int regnum)
 {
 	u32 ocp_addr;
 	u16 val;
 	int ret;
+	struct realtek_priv *priv = ds->priv;
 
 	if (phy > RTL8365MB_PHYADDRMAX)
 		return -EINVAL;
@@ -702,11 +703,12 @@ static int rtl8365mb_phy_read(struct realtek_priv *priv, int phy, int regnum)
 	return val;
 }
 
-static int rtl8365mb_phy_write(struct realtek_priv *priv, int phy, int regnum,
+static int rtl8365mb_phy_write(struct dsa_switch *ds, int phy, int regnum,
 			       u16 val)
 {
 	u32 ocp_addr;
 	int ret;
+	struct realtek_priv *priv = (struct realtek_priv *)ds->priv;
 
 	if (phy > RTL8365MB_PHYADDRMAX)
 		return -EINVAL;
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
index 31f1a949c8e7..27f08a5f53d4 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1639,11 +1639,12 @@ static int rtl8366rb_enable_vlan4k(struct realtek_priv *priv, bool enable)
 				  enable ? RTL8366RB_SGCR_EN_VLAN_4KTB : 0);
 }
 
-static int rtl8366rb_phy_read(struct realtek_priv *priv, int phy, int regnum)
+static int rtl8366rb_phy_read(struct dsa_switch *ds, int phy, int regnum)
 {
 	u32 val;
 	u32 reg;
 	int ret;
+	struct realtek_priv *priv = ds->priv;
 
 	if (phy > RTL8366RB_PHY_NO_MAX)
 		return -EINVAL;
@@ -1673,11 +1674,12 @@ static int rtl8366rb_phy_read(struct realtek_priv *priv, int phy, int regnum)
 	return val;
 }
 
-static int rtl8366rb_phy_write(struct realtek_priv *priv, int phy, int regnum,
+static int rtl8366rb_phy_write(struct dsa_switch *ds, int phy, int regnum,
 			       u16 val)
 {
 	u32 reg;
 	int ret;
+	struct realtek_priv *priv = ds->priv;
 
 	if (phy > RTL8366RB_PHY_NO_MAX)
 		return -EINVAL;
@@ -1767,6 +1769,8 @@ static int rtl8366rb_detect(struct realtek_priv *priv)
 static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_tag_protocol = rtl8366_get_tag_protocol,
 	.setup = rtl8366rb_setup,
+	.phy_read = rtl8366rb_phy_read,
+	.phy_write = rtl8366rb_phy_write,
 	.phylink_mac_link_up = rtl8366rb_mac_link_up,
 	.phylink_mac_link_down = rtl8366rb_mac_link_down,
 	.get_strings = rtl8366_get_strings,
@@ -1799,8 +1803,6 @@ static const struct realtek_ops rtl8366rb_ops = {
 	.is_vlan_valid	= rtl8366rb_is_vlan_valid,
 	.enable_vlan	= rtl8366rb_enable_vlan,
 	.enable_vlan4k	= rtl8366rb_enable_vlan4k,
-	.phy_read	= rtl8366rb_phy_read,
-	.phy_write	= rtl8366rb_phy_write,
 };
 
 const struct realtek_variant rtl8366rb_variant = {
-- 
2.34.0

