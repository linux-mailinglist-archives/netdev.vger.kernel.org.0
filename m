Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E72C12FD5E
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgACUBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:01:51 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42703 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbgACUBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:01:50 -0500
Received: by mail-wr1-f68.google.com with SMTP id q6so43388087wro.9
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 12:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EYv2xTqIo2hEVHOG41HfTo46xhtWfJgsQgJ1Y9/YNjQ=;
        b=fJ7yPPm+xIlXeAVcQCHdsakpJon9YqYJseY5+R4VwBrKejZTUzTbarDja5VCdrRLTq
         cGr/2H58S5eQf0hzcuBilc27hXvDk0i48Gc+XFgaI3tC0hOiZYr6NGRcUyD8KddaTVHh
         mIwdAaauNuWYruBEZRpDROWqTBdb4e5uFzwLnCWUthQYFznwMQaqzhqNUFXMLi61N1tX
         ejxr82TAQW+l2/xe15YcFLiUkHQs/KRKd/X9i7Xbq/NavHxeCoRe6U0TftWISGMcWBWC
         5pG0lPSwXxx/U6zOPHBcoiNe7yWg6sQYtZMG1vn4C0eMXxUjJTmEHPVxfmgrkIK59tO4
         P56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EYv2xTqIo2hEVHOG41HfTo46xhtWfJgsQgJ1Y9/YNjQ=;
        b=rC25RDyI7k6RaUXzdZ+fRU7mNRMR7uDs0iuWUlOoBY7A6C8XBPHvibIdWE/PdUOm1G
         wg/MRgiiSPPsB0/1Kmy6u/JSq4ODYbP5HzrXoPRcILtnKQFMsHxeP0Lu0txFYpCqvq1Q
         MNu7pD/1QH+FeJMyZ+Ga2ReeDBKbJVsmpP8Uv/RSGAMGTDE/11m9b3PASQoRNMHUpryp
         48a3J/bidMCa6Mkozj2KX+l2pEDczdjuhXN6OXzlz3cJ/5chsCmXI1f2AV30mxpBlVFr
         sckvHABFKAOcHXinVA8quC052YqbDedcynPRmFbXhHYsQEUyi2x4XcvH8jqnNOXu28bW
         bx2g==
X-Gm-Message-State: APjAAAVhgt7FAI/2WITeBvBV15nEBj71tpBRu0pPsmSL9WvT2Dn24jO2
        fyYaOwty1VlTo3J894rPFX4=
X-Google-Smtp-Source: APXvYqxFlQroFR7a54UTwxmeHU9SOE6xKV2O4D1TYIxpYxVJxgNvFu4AC56WQ/dGYN/dZOascQe5ig==
X-Received: by 2002:a5d:4d8d:: with SMTP id b13mr94342266wru.6.1578081708937;
        Fri, 03 Jan 2020 12:01:48 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id e12sm60998154wrn.56.2020.01.03.12.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 12:01:48 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 3/9] net: phylink: add support for polling MAC PCS
Date:   Fri,  3 Jan 2020 22:01:21 +0200
Message-Id: <20200103200127.6331-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200103200127.6331-1-olteanv@gmail.com>
References: <20200103200127.6331-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some MAC PCS blocks are unable to provide interrupts when their status
changes. As we already have support in phylink for polling status, use
this to provide a hook for MACs to enable polling mode.

The patch idea was picked up from Russell King's suggestion on the macb
phylink patch thread here [0] but the implementation was changed.
Instead of introducing a new phylink_start_poll() function, which would
make the implementation cumbersome for common PHYLINK implementations
for multiple types of devices, like DSA, just add a boolean property to
the phylink_config structure, which is just as backwards-compatible.

https://lkml.org/lkml/2019/12/16/603

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
- None.

 Documentation/networking/sfp-phylink.rst | 3 ++-
 drivers/net/phy/phylink.c                | 3 ++-
 include/linux/phylink.h                  | 2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/sfp-phylink.rst b/Documentation/networking/sfp-phylink.rst
index a5e00a159d21..d753a309f9d1 100644
--- a/Documentation/networking/sfp-phylink.rst
+++ b/Documentation/networking/sfp-phylink.rst
@@ -251,7 +251,8 @@ this documentation.
 	phylink_mac_change(priv->phylink, link_is_up);
 
     where ``link_is_up`` is true if the link is currently up or false
-    otherwise.
+    otherwise. If a MAC is unable to provide these interrupts, then
+    it should set ``priv->phylink_config.pcs_poll = true;`` in step 9.
 
 11. Verify that the driver does not call::
 
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index c19cbcf183e6..73a01ea5fc55 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1021,7 +1021,8 @@ void phylink_start(struct phylink *pl)
 		if (irq <= 0)
 			mod_timer(&pl->link_poll, jiffies + HZ);
 	}
-	if (pl->cfg_link_an_mode == MLO_AN_FIXED && pl->get_fixed_state)
+	if ((pl->cfg_link_an_mode == MLO_AN_FIXED && pl->get_fixed_state) ||
+	    pl->config->pcs_poll)
 		mod_timer(&pl->link_poll, jiffies + HZ);
 	if (pl->phydev)
 		phy_start(pl->phydev);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index fed5488e3c75..523209e70947 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -63,10 +63,12 @@ enum phylink_op_type {
  * struct phylink_config - PHYLINK configuration structure
  * @dev: a pointer to a struct device associated with the MAC
  * @type: operation type of PHYLINK instance
+ * @pcs_poll: MAC PCS cannot provide link change interrupt
  */
 struct phylink_config {
 	struct device *dev;
 	enum phylink_op_type type;
+	bool pcs_poll;
 };
 
 /**
-- 
2.17.1

