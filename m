Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB4EC12BB50
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfL0Vg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:36:57 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35485 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfL0Vgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:36:55 -0500
Received: by mail-wr1-f66.google.com with SMTP id g17so27264644wro.2
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BQgcorw9ZHn+5QoaS5q7D5CecKqMr/nL6G8U/tu3Bnk=;
        b=ifrY46Ggzd9V2/7paI9lVjq+g58fC7cxFENnPoXHnCTrGhMqv8aatCV8cp6pHa9GDM
         DsvMimeEd9cIXhM3OHURs+xIokEnKDg/ojJ8SP2HZC5bo8uQOtx6KMPp2MiPrkMLs+li
         GKmR2rioDlqx81YrxKfvKypa1QzbSkvnnG4hCr5cd/M24HHopjeK9uorLnq0PGrK2nyP
         iYBa1SQIf7HDUcv85eqcRMHIyDVwP1HPrwTFLgmDKVu3WOfdW+7R6brLSBIxW0aMSRLd
         6lkHcYY+UkrLw3rktW4NAiG0yp0FLC8gv0IdEPe0fa8npdebYhqLsj4h2ZZ7gVY4h/R/
         oV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BQgcorw9ZHn+5QoaS5q7D5CecKqMr/nL6G8U/tu3Bnk=;
        b=KMTs1mEYOjplPrud4TK7U1YhPfwNJs536jsakinxQJCt4uRDTWKkT0UqL9kOzxckVo
         gaRhBaBTOkpjslczxkfc0OX5DBriwk/UWef9yBzhK2qNVmeg7jroRrfHs4Aqu6gzGwAd
         DTtw6RMAY4YjVGTGfef/Ztnexg44O9WY9thNkQ4lqReUNjVUwZ+ek8nv9Vnhfi7jZPfZ
         huqp+ExOigTZoz+i6SBp/lW5ubhqReNdJRQLLAGP+yGexVhkekOse7Y1qRphyRaLH/9I
         IFB8R3N1PSz0CWVKRrEU110MCxCrzmJ93SLPWNBTHvlUGHcWbnLs8Pz2UaYk3Y9O5zRA
         I/cQ==
X-Gm-Message-State: APjAAAV4+gvOE8MiowwlcbS0hzksfLK5GRSOd1ZIKGyZJlCGdaS5Zco3
        tUuaEWilHR5NzcIPSP1KHOU=
X-Google-Smtp-Source: APXvYqzO7I9yybsqaxBs93Myi4jJ2eQvS1qLZyqITQwealMKwII4bwzsfYAdaVgn8zRRuLocYcDgJg==
X-Received: by 2002:a5d:6284:: with SMTP id k4mr51677180wru.398.1577482613206;
        Fri, 27 Dec 2019 13:36:53 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v3sm36330504wru.32.2019.12.27.13.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 13:36:52 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 03/11] net: phylink: add support for polling MAC PCS
Date:   Fri, 27 Dec 2019 23:36:18 +0200
Message-Id: <20191227213626.4404-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227213626.4404-1-olteanv@gmail.com>
References: <20191227213626.4404-1-olteanv@gmail.com>
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

