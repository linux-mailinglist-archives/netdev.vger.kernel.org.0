Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873A398851
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 02:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbfHVAJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 20:09:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44405 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfHVAJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 20:09:49 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so2318547pgl.11;
        Wed, 21 Aug 2019 17:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=al+PMjVogxQV1Od/xeGI03NiBlkDv7AtMHf6o33QNRI=;
        b=rDL+eZfQwrDPV5lDYLSFiQb6IXIJ6s1QyGkZcYyP3c8nGy7idqZ9DQZb1iDVR2OThh
         5JBDVP1CNzrYaKs9e10g2f+LtvYkoAK3Nk3C0ITQux/8uDkjT8HNviygZhYa5hspBQMR
         MVut/EWrdqfhnuMUlZkFbZNZHlHpEz+HaqZ+2gSr6eX7+qwx5bebn9gvRu7xLhnpdU0W
         0Hnb6V2UcTvy8oD37g0eRizYJ7H5QVLs6DBJnWFc7Xs3WiK+jk3azw27m1hZ2MhoBXvt
         qjWLgkB7ZYfaBHSM0mqivp2gvTM4SOs0Ds1lz4hLvhvrfz/q3lDqGOIy8nCR+k4kXSPY
         FIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=al+PMjVogxQV1Od/xeGI03NiBlkDv7AtMHf6o33QNRI=;
        b=CSNrlo34xN/9QyBlZNjJ7j8LEdyfjNE0HlvFbtXwg30kNEV7yObLOEFBSXa2hK2mNM
         6maSTWtjO5G+bbWB6nqbEQClKrill70fahwQQPb+SANwlQVM+/pUDi3GzLrnx5mMle6F
         tYrD9Zq/zpbkyOSsNFEanG7ZYoOmymvq5LpahvrcZyKppf/R/rmH1kic6p1gmMKY4sRG
         kR84TgVGwxP79MOx5FGv8q340rZya6WBjGWareSrIdRZa6iymedGhqAIJ3y3TmpWlZlY
         ojbwrk+hFso0tlNIRDkBJYqKRj1q7o931864pAePruxH6gSP0OWiop87ZHOp4+ByTJa+
         8Xdg==
X-Gm-Message-State: APjAAAUKTrqj0RVSb861oOEZezkJNVVOXYBX6gm+g0QE4cai36kuioZf
        J/FLYhg3Othkr67XruUrn5+NWs+q
X-Google-Smtp-Source: APXvYqxJcGCn5gjEQyFQJXcb39q8EzQcGgnvrA5A7LD5MgaV7rwA//L2Plyi0J5CT/yLm/MnqLxTdw==
X-Received: by 2002:a65:690b:: with SMTP id s11mr27314088pgq.10.1566432588546;
        Wed, 21 Aug 2019 17:09:48 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i124sm27053789pfe.61.2019.08.21.17.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 17:09:47 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: bcm_sf2: Do not configure PHYLINK on CPU port
Date:   Wed, 21 Aug 2019 17:07:46 -0700
Message-Id: <20190822000747.3036-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SF2 binding does not specify that the CPU port should have
properties mandatory for successfully instantiating a PHYLINK object. As
such, there will be missing properties (including fixed-link) and when
attempting to validate and later configure link modes, we will have an
incorrect set of parameters (interface, speed, duplex).

Simply prevent the CPU port from being configured through PHYLINK since
bcm_sf2_imp_setup() takes care of that already.

Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 3811fdbda13e..28c963a21dac 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -478,6 +478,7 @@ static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
 				unsigned long *supported,
 				struct phylink_link_state *state)
 {
+	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	if (!phy_interface_mode_is_rgmii(state->interface) &&
@@ -487,8 +488,10 @@ static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
 	    state->interface != PHY_INTERFACE_MODE_INTERNAL &&
 	    state->interface != PHY_INTERFACE_MODE_MOCA) {
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		dev_err(ds->dev,
-			"Unsupported interface: %d\n", state->interface);
+		if (port != core_readl(priv, CORE_IMP0_PRT_ID))
+			dev_err(ds->dev,
+				"Unsupported interface: %d for port %d\n",
+				state->interface, port);
 		return;
 	}
 
@@ -526,6 +529,9 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 	u32 id_mode_dis = 0, port_mode;
 	u32 reg, offset;
 
+	if (port == core_readl(priv, CORE_IMP0_PRT_ID))
+		return;
+
 	if (priv->type == BCM7445_DEVICE_ID)
 		offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
 	else
-- 
2.17.1

