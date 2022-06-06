Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D26053EB0F
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238183AbiFFNBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbiFFNBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:01:52 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8112E298A
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 06:01:50 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v25so18732058eda.6
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 06:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PHja6eQ6Mv2Fce3sGPE0UzxsdJMvKhiNmaMfYmc4ndA=;
        b=URrbnH33zLvDajx/0NU5kLo58AbZNjB8rEMPICV3OEKt/mAq2Nk9jrpxpVuUI74Pa8
         Qg5PSBqML+Zi1e9grmdCRG9zwcGZkgLL5hqRWUMvMVsc1jaBdXscOjleVrsHY3+1L1CN
         DJieqIyP2shK2Fxwll9P/g0kXuAY9GT6ZYLzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PHja6eQ6Mv2Fce3sGPE0UzxsdJMvKhiNmaMfYmc4ndA=;
        b=miEcyohpJveuyR9kByfWZ/wrBmOA1yItNY5wEZD6h7DfplV6gQbzqzTmYt87xZ2tfq
         PJPPirBH+Zf/zKXdb/TCGQlx9aiOFlxc8loFD/SNgZd6HPrUwkcyXow5OpGpDJliO1NS
         uNDiNS63S3L8DkX98Gb41GMnlMAFzre6StcmnIVRNr/HDv5M26DGfQ+BhJ0cTeTmUKPh
         eQdUkAzuD6xl+51lmaMk3S3CAikkFwZUEGWKwy2TDBpyw1gUiSww8pV1GEGPyc3Pepep
         SP2qcEmhEL1bX2b0Zdj+D9DZ5Z/rbZPuYOY94fZRgrpTBpVu6KLEz8jhJjESWn8qFUMM
         rWvw==
X-Gm-Message-State: AOAM530nu71uvLfp8olqY8L91QBb0LBKi2jLrYhqol5hfgu0IP2mw/sH
        4ukyWB2X57Si9mIBMfCWA0tj0g==
X-Google-Smtp-Source: ABdhPJyzKgOqfEIRXyIehEv8SNDfgWNU6dcDZo68dVn7XI3YY9qcBYcpsDLYrBihuvISNzn/a4SAOw==
X-Received: by 2002:a05:6402:32a6:b0:42d:ed8b:3d8 with SMTP id f38-20020a05640232a600b0042ded8b03d8mr26381739eda.225.1654520508129;
        Mon, 06 Jun 2022 06:01:48 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id t26-20020a17090605da00b006fe7d269db8sm6275447ejt.104.2022.06.06.06.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 06:01:47 -0700 (PDT)
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
Subject: [PATCH net] net: dsa: realtek: rtl8365mb: fix GMII caps for ports with internal PHY
Date:   Mon,  6 Jun 2022 15:01:30 +0200
Message-Id: <20220606130130.2894410-1-alvin@pqrs.dk>
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

phylib defaults to GMII when no phy-mode or phy-connection-type property
is specified in a DSA port node.

Commit a5dba0f207e5 ("net: dsa: rtl8365mb: add GMII as user port mode")
introduced implicit support for GMII mode on ports with internal PHY to
allow a PHY connection for device trees where the phy-mode is not
explicitly set to "internal".

Commit 6ff6064605e9 ("net: dsa: realtek: convert to phylink_generic_validate()")
then broke this behaviour by discarding the usage of
rtl8365mb_phy_mode_supported() - where this GMII support was indicated -
while switching to the new .phylink_get_caps API.

With the new API, rtl8365mb_phy_mode_supported() is no longer needed.
Remove it altogether and add back the GMII capability - this time to
rtl8365mb_phylink_get_caps() - so that the above default behaviour works
for ports with internal PHY again.

Fixes: 6ff6064605e9 ("net: dsa: realtek: convert to phylink_generic_validate()")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---

Luiz, Russel:

Commit a5dba0f207e5 ought to have had a Fixes: tag I think, because it
claims to have been fixing a regression in the net-next tree - is that
right? I seem to have missed both referenced commits when they were
posted and never hit this issue personally. I only found things now
during some other refactoring and the test for GMII looked weird to me
so I went and investigated.

Could you please help me identify that Fixes: tag? Just for my own
understanding of what caused this added requirement for GMII on ports
with internal PHY.

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

