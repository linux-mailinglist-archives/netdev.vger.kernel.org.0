Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE07A49F114
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345435AbiA1ChI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345443AbiA1ChG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:37:06 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4A4C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:37:06 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id 10-20020a9d030a000000b0059f164f4a86so4412054otv.13
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9n8UMOQUnOEMo/pHXyhWlRaqWxW8D9UmwMZoEvdtxuU=;
        b=C5nPAhuc8cCl+bNPQUqdf5U8Mxr6KHaIQkAFNx7TTjxUWLizDv7U4mNQDIODaV+DDl
         qeTYdn4BYc/jvM1bcFkcS6EepIUXCc3SyMu/p0klNzp8A3P8nWB2LvbuPedu45Gy7vLU
         omQ6Q2ciOxA7YgdR6xLV2PVWxbgPWR90Eveinh6p+pL8+1S/tGcFED8ohfaCG5ysHgv5
         CdbcDwL3my3aDKb6KmzOja9q6UerZ5Y20LL8JqyehtHtotL6J/rJTbCbMMwCbgKzDzsI
         MeijpeothW5qoNiTr6sv67J6eM5HfS5u1MpIH8DWmIr09gwjhtCt+pGk9gn5252Le35E
         JOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9n8UMOQUnOEMo/pHXyhWlRaqWxW8D9UmwMZoEvdtxuU=;
        b=iA5rtre867iVfzHa5CJQM3vMOBtwfSMY7OXtfsqn8s3pH9BYFJSzyfMB+kbwEkrdRL
         X6LZEz317JAfyinireXTusTbxoSpKNNISU+bePi/Ce+5n3pknSH/asUtBGQ3hGMdnU7V
         kwNRe2OBklxyvxr6XvWAlghoP8mqdyrsd4VQdMPs/6ueai7hGYs9A/0tWmzqeCVq570F
         c/1MbZxXMlm9mdH4MzWF6ffbQj+4yYJOeLpxQSosqXLUcdhbnive1v2U18YmAHDuNfII
         n6lnuHShUMwdSD7JOYh8Zk8cwd9g9oj6uxX9ckptxTaC5A8+a6S/wfNSTGEroD6b9jkg
         XoYQ==
X-Gm-Message-State: AOAM532NI16gri3jhJT5JgTcath2zX7yiqGIFxF+IRrZRLeor+Ss2nEv
        +sz3XjH0RbZPIClOAtm8p2yX8GIy7qfDdw==
X-Google-Smtp-Source: ABdhPJz54M2Oh4Afff93Y4N+rNVpcjjGqXSCuYes+F+nJXbEPUbQyuBjwCDoDJb5NV/mEozEPIdFDw==
X-Received: by 2002:a9d:6303:: with SMTP id q3mr3792566otk.51.1643337425226;
        Thu, 27 Jan 2022 18:37:05 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id p82sm2586920oib.25.2022.01.27.18.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 18:37:04 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v5 05/11] net: dsa: realtek: use phy_read in ds->ops
Date:   Thu, 27 Jan 2022 23:36:05 -0300
Message-Id: <20220128023611.2424-6-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128023611.2424-1-luizluca@gmail.com>
References: <20220128023611.2424-1-luizluca@gmail.com>
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
2.34.1

