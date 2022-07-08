Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934BF56AF5B
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 02:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbiGHAOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiGHAOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:14:11 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DB46EE92;
        Thu,  7 Jul 2022 17:14:10 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id s21so12139388pjq.4;
        Thu, 07 Jul 2022 17:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tvre+hlNJp6WXp1SXGtKsESYflfZh+7jUtQqn/SqKBY=;
        b=BI3INW1EKYcbfgVOKcn46ln+bVkOf2fGwq0IgAxGxDVT9wv60EITNotu2wYcG58BNN
         dEDBvc5AQ3ovmfeFDFzaH67Yxlfwwya+N+QFDNGZ+NdkzsHZzorjE63qcO9a9abJhHKF
         NH3hRicHYd6mnda2+TvNyTgX8OoPcJWiOWS9oV7PhfOmiw862wisZ0vnUSjkd7CcRD0b
         xcdAvhYu4TmfEgyZK6HlzDvN9faOO+PAtAHTr2xptkbJOn/IHFQlJ0rpfrHKxavKSSYi
         Rpgnlu+Fycz43Dc1jUFmP0y2JGFNDhPAfyR4fFAYyfOWEbaRssc2if/TijDoWRt2Tah0
         3cWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tvre+hlNJp6WXp1SXGtKsESYflfZh+7jUtQqn/SqKBY=;
        b=D2cQvALcs51f/SY/kRbPqifUGGC11QnHXoSYhGS8Y9KMhP9oYcYa7GXgq9TDe26YdH
         u2tN5U2Gg8prA0BKkOiuTXR/xh8ESqklartq8NgwCU9bFER8Aqa6IQHXSGhArV4Yd4Hr
         je2x1R58xOVE7DQeQDzsYJSFJmrkoaSloQCaMBh69Re2kcmPeeZw0FsZg78dRqndAK3x
         HV1BRcfk58GTn2knP1LCZ8SEC7uvsczCK/13gcU/ja8J2XtqHoh+j8ntcv/C4VujcjOZ
         HjeNbO8c+R4PhdiKk0u4dObyaKsGuLv8UiEDuH3AxVp0l2KgtqN25xRjZxWOO9e8uTq5
         pGRw==
X-Gm-Message-State: AJIora9UaiZtWIO8DB/q+asH2op4L5wqLBx5c8m29mjsj0rJcz77KO/w
        NXbO1BQruNtRIyGmqru/dlf9THxnEmo=
X-Google-Smtp-Source: AGRyM1sF1XjkjGH3k5a79pT/Dsb6XwQ4k5Y8s6fgd4IGP6qYB19fs8HElnn/31X+fnyQNG5shLizMw==
X-Received: by 2002:a17:902:f708:b0:153:839f:bf2c with SMTP id h8-20020a170902f70800b00153839fbf2cmr751686plo.113.1657239249586;
        Thu, 07 Jul 2022 17:14:09 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t14-20020a62ea0e000000b00525521a288dsm27340169pfh.28.2022.07.07.17.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 17:14:09 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch
Subject: [PATCH stable 4.14 v3] net: dsa: bcm_sf2: force pause link settings
Date:   Thu,  7 Jul 2022 17:14:05 -0700
Message-Id: <20220708001405.1743251-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708001405.1743251-1-f.fainelli@gmail.com>
References: <20220708001405.1743251-1-f.fainelli@gmail.com>
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
index 11a72c4cbb92..2279e5e2deee 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -625,7 +625,9 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_eee *p = &priv->port_sts[port].eee;
 	u32 id_mode_dis = 0, port_mode;
+	u16 lcl_adv = 0, rmt_adv = 0;
 	const char *str = NULL;
+	u8 flowctrl = 0;
 	u32 reg, offset;
 
 	if (priv->type == BCM7445_DEVICE_ID)
@@ -697,10 +699,27 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
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
 
 	core_writel(priv, reg, offset);
 
-- 
2.25.1

