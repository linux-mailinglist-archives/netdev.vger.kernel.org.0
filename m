Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D9131A389
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 18:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhBLRZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 12:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbhBLRZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 12:25:27 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0092C061756
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 09:24:46 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id w1so351996ejf.11
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 09:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P4V6Y9BMlBScqu2WRe4FMpH2XCbfD+bQLjaALaGEcX0=;
        b=gGl763Bta1PpfzwbHCXlrHScA6EM5FwrVFxbMasBLOC+ciUPRQ1MeH4/E6/IyOWCaI
         CZAt61dwKudsUlqyKCgSxr8yLmLb7bmGPPXsRsCJ4Pb0MfiNuihzb1rirOQjfuhezTvo
         P9LbNcj2ME+5RUWa8m+fOa6J30UNeJq0gMPG/4AXgnjL/ubstOMWWCR+izc/r73x4mg3
         fpZEErBZwhqz/34vt0Q5E8dCvL/1GVKnLqbwIfx8QR8YrtWrH6Sg99f4HfTo2x6Rn/+m
         Fc05Nfnj+XaP2VskrdV18kaovXvo8M28BtK7kjxUL/f4+M8/g0qaTdTCF7NhtQxXiKrg
         uoxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P4V6Y9BMlBScqu2WRe4FMpH2XCbfD+bQLjaALaGEcX0=;
        b=nIlopKWTcjb0wgNSKG1RjFYPG9G8MW2iirk6o+OZUwU/V4xhS4xcgJskgop/kWLmu/
         ZD+o51LfWxpbAjrqMXTd829Pb4Dr+2XdlTTjFm66nEY69PtVpOdIyk+wckZlhVNOcCr1
         U1v7DfHyAwhrZVXkgfioYqf9nRPj3/X0ybPVHlFs9BVIHglZXC7639lXet9pYlfp9MrS
         TC+LO4KMjfAOLwk20xgAqAB72CHdmnLevy02AlKgWP51/f3e//dlwU5CXJB3Qd4LcTbi
         JFJ39Ixf9g3HPnx0kzrKnyVxczoLgdp1pVoaMW13AQ2CecyQNibdEvHWErU9KxreuI6v
         0cag==
X-Gm-Message-State: AOAM532lzqPxgrKIx9svUc/ixybVxoxA/SEDP3Ju8jD0i3Z+wwgyZnt+
        0KQljugwnM8OmgdQBIwWgS0=
X-Google-Smtp-Source: ABdhPJy/ksvidVyQEWOvUxOWc5JGkim09qK8wMPbuPcwOi+kwrikLNeV3MLt5n/yZf92T7mEScNNTA==
X-Received: by 2002:a17:906:1447:: with SMTP id q7mr4203966ejc.27.1613150685653;
        Fri, 12 Feb 2021 09:24:45 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x25sm6061616edv.65.2021.02.12.09.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 09:24:45 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/2] net: phylink: explicitly configure in-band autoneg for PHYs that support it
Date:   Fri, 12 Feb 2021 19:23:40 +0200
Message-Id: <20210212172341.3489046-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212172341.3489046-1-olteanv@gmail.com>
References: <20210212172341.3489046-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently Linux has no control over whether a MAC-to-PHY interface uses
in-band signaling or not, even though phylink has the
	managed = "in-band-status";
property which denotes that the MAC expects in-band signaling to be used.

The problem is really that if the in-band signaling is configurable in
both the PHY and the MAC, there is a risk that they are out of sync
unless phylink manages them both. Most if not all in-band autoneg state
machines follow IEEE 802.3 clause 37, which means that they will not
change the operating mode of the SERDES lane from control to data mode
unless in-band AN completed successfully. Therefore traffic will not
work.

It is particularly unpleasant that currently, we assume that PHYs which
have configurable in-band AN come pre-configured from a prior boot stage
such as U-Boot, because once the bootloader changes, all bets are off.

Let's introduce a new PHY driver method for configuring in-band autoneg,
and make phylink be its first user. The main PHY library does not call
phy_config_inband_autoneg, because it does not know what to configure it
to. Presumably, non-phylink drivers can also call phy_config_inband_autoneg
individually.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phy.c     | 12 ++++++++++++
 drivers/net/phy/phylink.c |  8 ++++++++
 include/linux/phy.h       |  8 ++++++++
 3 files changed, 28 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index fdb914b5b857..d6c63c54943e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -748,6 +748,18 @@ static int phy_check_link_status(struct phy_device *phydev)
 	return 0;
 }
 
+int phy_config_inband_aneg(struct phy_device *phydev, bool enabled)
+{
+	if (!phydev->drv)
+		return -EIO;
+
+	if (!phydev->drv->config_inband_aneg)
+		return -EOPNOTSUPP;
+
+	return phydev->drv->config_inband_aneg(phydev, enabled);
+}
+EXPORT_SYMBOL(phy_config_inband_aneg);
+
 /**
  * phy_start_aneg - start auto-negotiation for this PHY device
  * @phydev: the phy_device struct
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 84f6e197f965..ef3e947d5019 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -978,6 +978,14 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 		return ret;
 	}
 
+	ret = phy_config_inband_aneg(phy,
+				     (pl->cur_link_an_mode == MLO_AN_INBAND));
+	if (ret && ret != -EOPNOTSUPP) {
+		phylink_warn(pl, "failed to configure PHY in-band autoneg: %d\n",
+			     ret);
+		return ret;
+	}
+
 	phy->phylink = pl;
 	phy->phy_link_change = phylink_phy_change;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c130788306c8..2260b512ffbf 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -746,6 +746,13 @@ struct phy_driver {
 	 */
 	int (*config_aneg)(struct phy_device *phydev);
 
+	/**
+	 * @config_inband_aneg: Enable or disable in-band auto-negotiation for
+	 * the system-side interface if the PHY operates in a mode that
+	 * requires it: (Q)SGMII, USXGMII, 1000Base-X, etc.
+	 */
+	int (*config_inband_aneg)(struct phy_device *phydev, bool enabled);
+
 	/** @aneg_done: Determines the auto negotiation result */
 	int (*aneg_done)(struct phy_device *phydev);
 
@@ -1394,6 +1401,7 @@ void phy_detach(struct phy_device *phydev);
 void phy_start(struct phy_device *phydev);
 void phy_stop(struct phy_device *phydev);
 int phy_start_aneg(struct phy_device *phydev);
+int phy_config_inband_aneg(struct phy_device *phydev, bool enabled);
 int phy_aneg_done(struct phy_device *phydev);
 int phy_speed_down(struct phy_device *phydev, bool sync);
 int phy_speed_up(struct phy_device *phydev);
-- 
2.25.1

