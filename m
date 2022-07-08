Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13F156AF59
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 02:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbiGHAOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiGHAOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:14:09 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141776EE92;
        Thu,  7 Jul 2022 17:14:09 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id b9so6139601pfp.10;
        Thu, 07 Jul 2022 17:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EPIqDUDwUL8GcLZII6giZ1lM/7jnEq1hR9ruxU38etY=;
        b=Zgd9Mzhrgu975THaR3rV8Hknxs7yBMfORZclz7hgD7q9Fa8mFVKt9QMutgq4zHtZSP
         90WLNv3UVc6ui9XvAVsvQqdSB/WnoNmu5ynw0o3Akud7Kms6n/DfWTRpQyJ2Z2MIqZZT
         B+k8rz0+a2KUGEa9CHCV7ft9BaWyR0a1FUYMKfBpB359mcPzLhVMijXzYL61XF6Aeocv
         /LjZN8FaYWolw5h0ljAFH9/as+usV540aGZs8mHKZjlXd2F6hxzPuN0KuYSPpAz5tleK
         6QHebSG+gczugSEXWgzTVYAWmXUTiaDMzue6IMlHdLojdZT/EIDWAYUjk4xvp8ip1do5
         +GKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EPIqDUDwUL8GcLZII6giZ1lM/7jnEq1hR9ruxU38etY=;
        b=ORGQO/RVAOq575YOJfYc8hRSjr8UIFEjO6J+eO/Oz2N4/li374OAemKwO3OqEcEmoh
         OZm7ftqzGycikUHFVTVO2KK3gVnKAVwtSVjmdTbVrR3GTnVM0I9adDXo+5xLDJ3or9VJ
         tlLsp/xj1fSlM2z02RlNlI0oQBfg7/+sACpicLh/HYqH7q8MbOsunzPoOA1FMDpf8qy7
         P8eWUklMZdoVIj6CFOrogYuXZ3K+ATKEMfQDSZ5+LojemNPZPz33tuB7KXYRHKeDk2S1
         1304QVe3Aj9H1HssgpeNmqv/uTlbAAe71iz7uLYF56adKEQ0JHE7fgoi/RMiOJWslJKH
         mUNg==
X-Gm-Message-State: AJIora9XVK/ZoJdi33kFWRMNgmyLC9FsaMwadNFR6DeZmaB4g/Zqc6Sx
        n/6QWDc8g510X+c82/s5JV1F3y8bVnw=
X-Google-Smtp-Source: AGRyM1srMNsNREHvzkYJIXlogrslrHy5Vja65MpLfTgalTmHZgsp3NLmlhMlXo2e/ApQfmbjFEsxcA==
X-Received: by 2002:a62:1891:0:b0:528:5d43:c3ab with SMTP id 139-20020a621891000000b005285d43c3abmr886621pfy.79.1657239248208;
        Thu, 07 Jul 2022 17:14:08 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t14-20020a62ea0e000000b00525521a288dsm27340169pfh.28.2022.07.07.17.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 17:14:07 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch
Subject: [PATCH stable 4.9 v3] net: dsa: bcm_sf2: force pause link settings
Date:   Thu,  7 Jul 2022 17:14:04 -0700
Message-Id: <20220708001405.1743251-1-f.fainelli@gmail.com>
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
Changes in v3:

- gate the flow control enabling to links that are auto-negotiated and
  in full duplex

Changes in v2:

- use both local and remote advertisement to determine when to apply
  flow control settings

 drivers/net/dsa/bcm_sf2.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 40b3adf7ad99..f3d61f2bb0f7 100644
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
@@ -667,10 +669,27 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
 		break;
 	}
 
+	if (phydev->duplex == DUPLEX_FULL &&
+	    phydev->autoneg == AUTONEG_ENABLE) {
+		if (phydev->pause)
+			rmt_adv = LPA_PAUSE_CAP;
+		if (phydev->asym_pause)
+			rmt_adv |= LPA_PAUSE_ASYM;
+		if (phydev->advertising & ADVERTISED_Pause)
+			lcl_adv = ADVERTISE_PAUSE_CAP;
+		if (phydev->advertising & ADVERTISED_Asym_Pause)
+			lcl_adv |= ADVERTISE_PAUSE_ASYM;
+		flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
+	}
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

