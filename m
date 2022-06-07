Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D648541790
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 23:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377570AbiFGVD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 17:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379168AbiFGVCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 17:02:09 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AF7188EAC
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 11:46:44 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id kq6so23966552ejb.11
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 11:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hf1jc2du12TaQ+e4X7BuWjrmUs1aIjYSqtWkFD5qagY=;
        b=g0RwDCzmZvnD1xCt3VnYuZhl/AWtldB3ALD6hW4OFq3z4SpjCZt5npFzx3rTDpgTot
         qGdMrHlbN2eOawV4Xdr8qaH2EKlMnOCNc5YvTP/X8rADjPgMqAlKUlhtqSi3MFvjAtBJ
         y7drJXyG191FFsXHCD8yGbaUoiW0XsGSDf6yw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hf1jc2du12TaQ+e4X7BuWjrmUs1aIjYSqtWkFD5qagY=;
        b=KNOQqde9bfkIx6wf9TzPghqjk3XNYx4Kwr2xIMIL3xv6Y8JirGSjZ6WdX+ffeGhich
         Lq9UotXJ4qCHaelsRHv1BdK8Uq82UC9cbk8TgG2cCqtOlJfDzS7L5E630yNBoQxHZxll
         To3EnwM/FYCRmODg+2Tj0tAujIp5DQEzXB/2yGHF4JBBleJF+9lUkbtfXCwgsNeiDbUO
         W80L00fgzUsWvU4vqZ/IM4t2bfnnrWYoU2BtAf9REHatcgactSWtCZt5pNI8AE0mmatx
         jrT40HX9QnOMg3oGBrp3lAzR2x2gH7g314gz2NTvJXp1rcQJJMq21xQI96u8kjjPJQWY
         HbuQ==
X-Gm-Message-State: AOAM532+FkSMQ+pe0KuWCXNl5Dqsjo6M4LUMzXQUdhxwSzSxBxtT2iAk
        cqEM8P7eS29Pee+nMrDwbwHavg==
X-Google-Smtp-Source: ABdhPJw/Fqo3BTFZ8n5XfwbBfYdfWv6VxCDOxrThxU1K3gkqpN1R2DW+zWIQSpLq4S+H+Uv028ueHw==
X-Received: by 2002:a17:907:7b86:b0:711:d2c8:ab18 with SMTP id ne6-20020a1709077b8600b00711d2c8ab18mr9788400ejc.580.1654627602945;
        Tue, 07 Jun 2022 11:46:42 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id y18-20020a056402171200b0042dc0181307sm10839131edu.93.2022.06.07.11.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 11:46:42 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     luizluca@gmail.com, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: dsa: realtek: rtl8365mb: fix GMII caps for ports with internal PHY
Date:   Tue,  7 Jun 2022 20:46:24 +0200
Message-Id: <20220607184624.417641-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Since commit a18e6521a7d9 ("net: phylink: handle NA interface mode in
phylink_fwnode_phy_connect()"), phylib defaults to GMII when no phy-mode
or phy-connection-type property is specified in a DSA port node of the
device tree. The same commit caused a regression in rtl8365mb whereby
phylink would fail to connect, because the driver did not advertise
support for GMII for ports with internal PHY.

It should be noted that the aforementioned regression is not because the
blamed commit was incorrect: on the contrary, the blamed commit is
correcting the previous behaviour whereby unspecified phy-mode would
cause the internal interface mode to be PHY_INTERFACE_MODE_NA. The
rtl8365mb driver only worked by accident before because it _did_
advertise support for PHY_INTERFACE_MODE_NA, despite NA being reserved
for internal use by phylink. With one mistake fixed, the other was
exposed.

Commit a5dba0f207e5 ("net: dsa: rtl8365mb: add GMII as user port mode")
then introduced implicit support for GMII mode on ports with internal
PHY to allow a PHY connection for device trees where the phy-mode is not
explicitly set to "internal". At this point everything was working OK
again.

Subsequently, commit 6ff6064605e9 ("net: dsa: realtek: convert to
phylink_generic_validate()") broke this behaviour again by discarding
the usage of rtl8365mb_phy_mode_supported() - where this GMII support
was indicated - while switching to the new .phylink_get_caps API.

With the new API, rtl8365mb_phy_mode_supported() is no longer needed.
Remove it altogether and add back the GMII capability - this time to
rtl8365mb_phylink_get_caps() - so that the above default behaviour works
for ports with internal PHY again.

Fixes: 6ff6064605e9 ("net: dsa: realtek: convert to phylink_generic_validate()")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---

v1 -> v2:

- no code changes
- added more detail in the commit description after Luiz and Russel's
  help finding commit a18e6521a7d9

---
 drivers/net/dsa/realtek/rtl8365mb.c | 38 +++++++----------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 3bb42a9f236d..769f672e9128 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -955,35 +955,21 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 	return 0;
 }
 
-static bool rtl8365mb_phy_mode_supported(struct dsa_switch *ds, int port,
-					 phy_interface_t interface)
-{
-	int ext_int;
-
-	ext_int = rtl8365mb_extint_port_map[port];
-
-	if (ext_int < 0 &&
-	    (interface == PHY_INTERFACE_MODE_NA ||
-	     interface == PHY_INTERFACE_MODE_INTERNAL ||
-	     interface == PHY_INTERFACE_MODE_GMII))
-		/* Internal PHY */
-		return true;
-	else if ((ext_int >= 1) &&
-		 phy_interface_mode_is_rgmii(interface))
-		/* Extension MAC */
-		return true;
-
-	return false;
-}
-
 static void rtl8365mb_phylink_get_caps(struct dsa_switch *ds, int port,
 				       struct phylink_config *config)
 {
-	if (dsa_is_user_port(ds, port))
+	if (dsa_is_user_port(ds, port)) {
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 			  config->supported_interfaces);
-	else if (dsa_is_cpu_port(ds, port))
+
+		/* GMII is the default interface mode for phylib, so
+		 * we have to support it for ports with integrated PHY.
+		 */
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
+	} else if (dsa_is_cpu_port(ds, port)) {
 		phy_interface_set_rgmii(config->supported_interfaces);
+	}
 
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
 				   MAC_10 | MAC_100 | MAC_1000FD;
@@ -996,12 +982,6 @@ static void rtl8365mb_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct realtek_priv *priv = ds->priv;
 	int ret;
 
-	if (!rtl8365mb_phy_mode_supported(ds, port, state->interface)) {
-		dev_err(priv->dev, "phy mode %s is unsupported on port %d\n",
-			phy_modes(state->interface), port);
-		return;
-	}
-
 	if (mode != MLO_AN_PHY && mode != MLO_AN_FIXED) {
 		dev_err(priv->dev,
 			"port %d supports only conventional PHY or fixed-link\n",
-- 
2.36.0

