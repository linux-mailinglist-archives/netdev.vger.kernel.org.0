Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A83C130BD2
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 02:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgAFBem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 20:34:42 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37249 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgAFBeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 20:34:37 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so35399257wru.4
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 17:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o8+UlP7ftnmePjpuimPmMViDxpzbkWwmD1Tg0JpYf68=;
        b=I8Ks+WWZlUz6ITftCeACL5GCJU8eizdoybQoFEaTpZeQSZwxwq+Rgub+EFnEZSDIOA
         gc4FvPByi4WO5H1Z3mBXyhD4ZAZsTowPm0Z8hcjYtp78f3DpCAPKZxB2lVJ8S9AHTy8m
         LD5xiLbuogKF8VHqlApxOKsoBf2vShJZ1sT666C25H3g7MHAu+MSr2KocbuTeYE0QpON
         atkD6QW0TACvpaMmJjznCKZB/MhrjDhoOBdW/IRAlJ2PxVQ0Kky2OXvnx0l6kkQG5R6l
         tby7Q5p8K3BVnJzDZAKD1YBY7fN5qYb3AIWMgzzHn1pVA0sCbR21Fd8krFSgC3iaXgin
         Yjuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o8+UlP7ftnmePjpuimPmMViDxpzbkWwmD1Tg0JpYf68=;
        b=BPtyxI78vsIey+7l/sPFHBnYDJQJ9+iyWI2Fcxkef20r3g4jBJ+KWFVO2a7z8cI4gi
         HdsZh1oEqnduGQOnljfIoxE9xyXhCxJPtAdz3syVnQU9oV8O4qhe9fDhR2wo6AlJVw+j
         DaMr+LGkudxMWQGSDdJon1GkeCgMVXkBFDCBo16gbhT4og3auO+u3Acs8DGxfEYdVXNY
         0TFQCtKzGr1Uo2aGKpgd/DRTbGq/VUeEB6U1pWATkw5WLKVxaDb7xqDAGqMzMF/Deoce
         8io55mGYTx89W8tDhxUcfFD5gqd/qjcG+0NqNLvwUIoAMZ6Ktw/sMVLvkJISLfxbSraj
         eErw==
X-Gm-Message-State: APjAAAWcPveEzy2sCokv54m8/1apIGU0xLUsTcl7Y/8wI8a7V7CXn2ne
        RlSVUmpCkRqnR5Fp/Bhui4bsxvnv
X-Google-Smtp-Source: APXvYqyKVx8PJUnsWKty/FHsncrQ1h7XvBjjijRrxkesS4+PfuSBHBrSP7FcUBkRXgY6hzwmdd1CBg==
X-Received: by 2002:a5d:428c:: with SMTP id k12mr99909890wrq.57.1578274475347;
        Sun, 05 Jan 2020 17:34:35 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id l6sm1412756wmf.21.2020.01.05.17.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 17:34:34 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 3/9] net: phylink: add support for polling MAC PCS
Date:   Mon,  6 Jan 2020 03:34:11 +0200
Message-Id: <20200106013417.12154-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200106013417.12154-1-olteanv@gmail.com>
References: <20200106013417.12154-1-olteanv@gmail.com>
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
Changes in v5:
- None.

Changes in v4:
- None.

Changes in v3:
- Patch is new.

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
index 88686e0f9ae1..af914a8842bd 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1022,7 +1022,8 @@ void phylink_start(struct phylink *pl)
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

