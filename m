Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3461A4821F9
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 05:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242678AbhLaEeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 23:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242685AbhLaEeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 23:34:46 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FF8C061401
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:34:46 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id f138so24314465qke.10
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N7/xcV+q2pIHBurUaT+7rAoEx7uFiSsrmfW9Jumb19U=;
        b=SoXn9WLQFrGtT0bb3EZRlYF3Rg8UGkMHrtx+GWHeOPkX0YWCwu8Ib01MlwNa6OEga0
         NltdKOOLPG9UBWVay4aJqOve6oZ+dambJYJjYPO2wioLsPXkwpLP0EmovsaCjDiD9a+9
         BRsm/PpsO6fLXDjxMDlsG1kURSQhjyjAJi9lzMWktxBuKJ9J/gMLtQKU8f6lZBmYFe6V
         ca8SIlx28NVvEC/unAoUcOwaCiVJhV2vQRIGPhd5r25m9QC9gnhK/OhnAWF6578acV0F
         prK7XmPbm74jRzkLeICZ4Wt8DGG8+sPJBEXfgke2MZoIhq228ZR0hDHnmf30wE/CwR02
         Ep0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7/xcV+q2pIHBurUaT+7rAoEx7uFiSsrmfW9Jumb19U=;
        b=B+LOpjJhctVaUPDpR/+DwDUjsaXUveT3Z6gxmVGeeuaBrBPNeRgHfDCUkUgsJA28CR
         ByUVVheUBGhQn+jjpcQLd/RbpcnfpazqOf4ukJHU83E9JSPzKUiZgASEGzxugw6s2NGA
         2/ff7qpS4FfAyE7DywIlMng6HJQJ4NFz8y7mId7I0I3H+c74Ejc/o4nFyItXWnAZ5EO1
         qwOvajQai+XnHiQTlteua9hoO2l9O/ktPdNQxLjzpXaG7BGaOjJKvyV3O8J/3e3rtzc1
         wLOPjnd+VolJ2dawIwngX6u6QGWgKTW91IUZpu720iS+M81qf5xJ0bxQyFAvpBkiwF9J
         HPKg==
X-Gm-Message-State: AOAM532OFf2bJacFwTODR3QsnA34PX6wMLC5B970/V6/JgEjeXZXkUPI
        OcHeA9D9CfRxX6df7n9IhyKQVc2l/xeaT9Yr
X-Google-Smtp-Source: ABdhPJyG+7BoNWQp0iccqGfkodnVljD2BiCH+Ligv57JgiItmZSkHLBZi+wYSQ2dzlKssR5+wHPebA==
X-Received: by 2002:a05:620a:450f:: with SMTP id t15mr23480383qkp.224.1640925285111;
        Thu, 30 Dec 2021 20:34:45 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id i5sm8020030qti.27.2021.12.30.20.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 20:34:44 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3 05/11] net: dsa: realtek: use phy_read in ds->ops
Date:   Fri, 31 Dec 2021 01:33:00 -0300
Message-Id: <20211231043306.12322-6-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211231043306.12322-1-luizluca@gmail.com>
References: <20211231043306.12322-1-luizluca@gmail.com>
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

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/realtek/realtek-smi.c |  6 ++++--
 drivers/net/dsa/realtek/realtek.h     |  3 ---
 drivers/net/dsa/realtek/rtl8365mb.c   | 10 ++++++----
 drivers/net/dsa/realtek/rtl8366rb.c   | 10 ++++++----
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 5514fe81d64f..1f024e2520a6 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -329,16 +329,18 @@ static const struct regmap_config realtek_smi_mdio_regmap_config = {
 static int realtek_smi_mdio_read(struct mii_bus *bus, int addr, int regnum)
 {
 	struct realtek_priv *priv = bus->priv;
+	struct dsa_switch *ds = priv->ds;
 
-	return priv->ops->phy_read(priv, addr, regnum);
+	return ds->ops->phy_read(ds, addr, regnum);
 }
 
 static int realtek_smi_mdio_write(struct mii_bus *bus, int addr, int regnum,
 				  u16 val)
 {
 	struct realtek_priv *priv = bus->priv;
+	struct dsa_switch *ds = priv->ds;
 
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

