Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8C8393748
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 22:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbhE0UrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 16:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbhE0UrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 16:47:18 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1142BC061761
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:43 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g7so2368626edm.4
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f3LXLy0RxWR9HBLo60bQO4krGpz/yZL++bJpVi6moh0=;
        b=KiLH/RjHXRiudeeWLmGLxFfwwNxpuUr5Xg+9fX+b6oAuvBFQJUob5llvDqNsO8F2Up
         WDo/E9PUS3HR6u7lWfj/jzJGy2K0k2JjAoAoN5PqADtksUgo8vPS23fqMYDqp5JVzT0P
         IdWPee2Hu1bQGj2kOmsh2XQKqjw1RrzgggMoSnIrnRKLmJdYyOb0KeMqjslFArrtwfoB
         /fYvIedoR7M1qw7Ig8NAA34bK0HxLktMZUvQlBYUxF95eqZNJ+WgOVhU/Nt8ZAmEsQxY
         BywgYgnS3ESkETO2UeWLb1qjE0D6LIBNDNPskNXIDL70APf7WXs8XArqztUX4izP/20G
         ctaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f3LXLy0RxWR9HBLo60bQO4krGpz/yZL++bJpVi6moh0=;
        b=mwU6SaC6/8GK5IqeUx8nUl0zLHd97wukKS7VrjD5uCojhnOpsk/aDj5OVckoGxbmn8
         STP4MQVYjs33sGVgeidoHCppGNArD/eESIBhBQ+38apeeeRK15sV0X04VnrvZcsfiKGg
         Oye+TvTZw4MAiw4q7QZNo95HWiVPgsV9Ue0idp/WHZjKZjradm/WTlaGYRfM1BtRT2wQ
         gcAmX1gQKoWinrEi6aT4mPE7OXZQkwJn7cG354eYEdsSmD7mb0wz0DkFUjTjYf2avhik
         iyaEQuI8/aZimt/JyPx1RM4hbj3dFa3yxFslDiSfWgHlI4F1lpdRkmYyds8e1KGphCZD
         DCtA==
X-Gm-Message-State: AOAM532RXH4/qCdHJm7jfN0cSyTQF8lB47Z/VCm1eeCGKQdxbcyzpLIs
        W7AsPdQgvot3oWZAZ7277/4=
X-Google-Smtp-Source: ABdhPJyIXKzYSMGSj4uJEl5i4yOI3WEVbysDrGcHEearUs0F0rTLxkFbpHTqTRnICFLMpmTQEkRtdw==
X-Received: by 2002:a05:6402:5174:: with SMTP id d20mr6443295ede.248.1622148341586;
        Thu, 27 May 2021 13:45:41 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g11sm1654145edt.85.2021.05.27.13.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 13:45:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 3/8] net: pcs: xpcs: export xpcs_validate
Date:   Thu, 27 May 2021 23:45:23 +0300
Message-Id: <20210527204528.3490126-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527204528.3490126-1-olteanv@gmail.com>
References: <20210527204528.3490126-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Calling a function pointer with a single implementation through
struct mdio_xpcs_ops is clunky, and the stmmac_do_callback system forces
this to return int, even though it always returns zero.

Simply remove the "validate" function pointer from struct mdio_xpcs_ops
and replace it with an exported xpcs_validate symbol which is called
directly by stmmac.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/hwif.h        |  2 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +-
 drivers/net/pcs/pcs-xpcs.c                        | 10 ++++------
 include/linux/pcs/pcs-xpcs.h                      |  5 ++---
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 75a8b90c202a..a86b358feae9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -613,8 +613,6 @@ struct stmmac_mmc_ops {
 	stmmac_do_void_callback(__priv, mmc, read, __args)
 
 /* XPCS callbacks */
-#define stmmac_xpcs_validate(__priv, __args...) \
-	stmmac_do_callback(__priv, xpcs, validate, __args)
 #define stmmac_xpcs_config(__priv, __args...) \
 	stmmac_do_callback(__priv, xpcs, config, __args)
 #define stmmac_xpcs_get_state(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bf9fe25fed69..d3d85d36e177 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -996,7 +996,7 @@ static void stmmac_validate(struct phylink_config *config,
 	linkmode_andnot(state->advertising, state->advertising, mask);
 
 	/* If PCS is supported, check which modes it supports. */
-	stmmac_xpcs_validate(priv, &priv->hw->xpcs_args, supported, state);
+	xpcs_validate(&priv->hw->xpcs_args, supported, state);
 }
 
 static void stmmac_mac_pcs_get_state(struct phylink_config *config,
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 71efd5ef69e5..4c0093473470 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -658,9 +658,8 @@ static void xpcs_resolve_pma(struct mdio_xpcs_args *xpcs,
 	}
 }
 
-static int xpcs_validate(struct mdio_xpcs_args *xpcs,
-			 unsigned long *supported,
-			 struct phylink_link_state *state)
+void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
+		   struct phylink_link_state *state)
 {
 	bool valid_interface;
 
@@ -683,13 +682,13 @@ static int xpcs_validate(struct mdio_xpcs_args *xpcs,
 
 	if (!valid_interface) {
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		return 0;
+		return;
 	}
 
 	linkmode_and(supported, supported, xpcs->supported);
 	linkmode_and(state->advertising, state->advertising, xpcs->supported);
-	return 0;
 }
+EXPORT_SYMBOL_GPL(xpcs_validate);
 
 static int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
 			   int enable)
@@ -958,7 +957,6 @@ static int xpcs_probe(struct mdio_xpcs_args *xpcs)
 }
 
 static struct mdio_xpcs_ops xpcs_ops = {
-	.validate = xpcs_validate,
 	.config = xpcs_config,
 	.get_state = xpcs_get_state,
 	.link_up = xpcs_link_up,
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index e48636a1a078..56755b7895a0 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -25,9 +25,6 @@ struct mdio_xpcs_args {
 };
 
 struct mdio_xpcs_ops {
-	int (*validate)(struct mdio_xpcs_args *xpcs,
-			unsigned long *supported,
-			struct phylink_link_state *state);
 	int (*config)(struct mdio_xpcs_args *xpcs,
 		      const struct phylink_link_state *state);
 	int (*get_state)(struct mdio_xpcs_args *xpcs,
@@ -40,5 +37,7 @@ struct mdio_xpcs_ops {
 };
 
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
+void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
+		   struct phylink_link_state *state);
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

