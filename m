Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19458569293
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 21:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbiGFTZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 15:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiGFTZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 15:25:06 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C96286F4;
        Wed,  6 Jul 2022 12:25:06 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id z13so19684565qts.12;
        Wed, 06 Jul 2022 12:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GNCmLRb+XfJJD5OehxZXlSjvcI9p98h6qk3nLF3Qq9U=;
        b=YPJVd3eZCxeUsT54EWgRJkvv4PRsCWQtKIGBEkoDJxmdyIEqNUf8/N5i26E8v4uyPO
         98A060poQOTnXEJdTuMQTn4IqtiUXB4OzVmTBhq18gYJstPWz56Exllv2iIJ1hDqSE0o
         elhLp/iLsumJMSAlRjkS2AK7vOX4MlMIXWxs+iwHvYXIbEy6pq7TkrVVEDPTtGuWB4eE
         5z0AY1RYCJy+o+I+ABdQ+2qXyF5OqW7PpCOGmfB82jfWjGORy90jIpqO3ty8bd+FxVHr
         23xeiamKzsQUZZ3pAofFfLB0llsvmPgpWCbH8X1sdrDWuJOL2btY7AYygXDbJtGY3KXt
         rk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GNCmLRb+XfJJD5OehxZXlSjvcI9p98h6qk3nLF3Qq9U=;
        b=lIgTFwEXmtDqTJL0lytkqsCweeBZmZZIJlQQpTC6v20MU04sFPPKl3h/ULhMwFC88A
         IYtboKHmlb9GZzcuTFV3Ardzj8IajxYhl/IsgIjBQ1E1sK//jZZkBx0SXaUjXr4J+0dH
         RsCOaheY/squS9uIK+s6S4dJU5+I3JIm41MBui8kCfZLN8ldo/BMWLGbTd6CQNecuY30
         qa0aSvKUS9LHW3DXiExToUuMM+VUFfEfl4GdxLHjCtJI24OUFzsUfqTVrrhZ0Spug1Xr
         lrx44PtkJv80jL8BPV9HwZr7JyhYieHm+6Y3VzkseJNgYULZ30F9D7vaU6ESaXBtyIVG
         yrdg==
X-Gm-Message-State: AJIora8M73HoNNWenXc7LJ2g6rx82ECPVX3wjb4rQ4xlHrYa34p96yC8
        YFs+1B9mY18tqeB1j9qr6ihBld0mxEI=
X-Google-Smtp-Source: AGRyM1t1N8PJE1uAw3wgRa6gP7K1yPsQDgLEnub98zkh00flDiiQWRhkePrTFyqJS8w0LK51NwlqLg==
X-Received: by 2002:a0c:8108:0:b0:470:2d8c:2a2a with SMTP id 8-20020a0c8108000000b004702d8c2a2amr37993670qvc.4.1657135504814;
        Wed, 06 Jul 2022 12:25:04 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u9-20020a05622a17c900b0031d3d0b2a04sm10545523qtk.9.2022.07.06.12.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 12:25:04 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch
Subject: [PATCH stable 4.9 v2] net: dsa: bcm_sf2: force pause link settings
Date:   Wed,  6 Jul 2022 12:24:54 -0700
Message-Id: <20220706192455.56001-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream

The pause settings reported by the PHY should also be applied to the
GMII port status override otherwise the switch will not generate pause
frames towards the link partner despite the advertisement saying
otherwise.

Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Changes in v2:

- use both local and remote advertisement to determine when to apply
  flow control settings

 drivers/net/dsa/bcm_sf2.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 40b3adf7ad99..562b5eb23d90 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -600,7 +600,9 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_eee *p = &priv->port_sts[port].eee;
 	u32 id_mode_dis = 0, port_mode;
+	u16 lcl_adv = 0, rmt_adv = 0;
 	const char *str = NULL;
+	u8 flowctrl = 0;
 	u32 reg;
 
 	switch (phydev->interface) {
@@ -667,10 +669,24 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
 		break;
 	}
 
+	if (phydev->pause)
+		rmt_adv = LPA_PAUSE_CAP;
+	if (phydev->asym_pause)
+		rmt_adv |= LPA_PAUSE_ASYM;
+	if (phydev->advertising & ADVERTISED_Pause)
+		lcl_adv = ADVERTISE_PAUSE_CAP;
+	if (phydev->advertising & ADVERTISED_Asym_Pause)
+		lcl_adv |= ADVERTISE_PAUSE_ASYM;
+	flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
+
 	if (phydev->link)
 		reg |= LINK_STS;
 	if (phydev->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
+	if (flowctrl & FLOW_CTRL_TX)
+		reg |= TXFLOW_CNTL;
+	if (flowctrl & FLOW_CTRL_RX)
+		reg |= RXFLOW_CNTL;
 
 	core_writel(priv, reg, CORE_STS_OVERRIDE_GMIIP_PORT(port));
 
-- 
2.25.1

