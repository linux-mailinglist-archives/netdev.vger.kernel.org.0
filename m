Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2C012BB57
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfL0VhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:37:10 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40163 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfL0Vg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:36:58 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so9301237wmi.5
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K5D3W/fCixiqiMl4ZhilHiF+8en5/MvOq3+tMTVW4iQ=;
        b=G3qYYmpXvUgvfgr56cjceFVGlbBB8aYGhZkf7sgIwpZBDDMfOrCIjZowsKBwjh2qOY
         ORpVBsrKWw55oZIgJ7Xh15oDAd0Bk0G22TTMfWbMylZbejj/o/x4ZsSa8Hb19XZTTSvq
         yBdwAbU3b5/G2SJcwicujyTIVOnOv9ceavlsKJ5BFg4kp+ESjTGYfbwyppngffYjWGg4
         a9cwXxa1EFYeOFigSpGBv0tLqwcyszglj6BrEzwwlIzHXIMgEUawpQa6anECoyQXzss1
         rkGfbu+LxYKqNU+iestQtWSXSUUWyjFd2mq4QAAQbOYkdFZyG/Te0CFFUOKw0P7Kc/w2
         G69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K5D3W/fCixiqiMl4ZhilHiF+8en5/MvOq3+tMTVW4iQ=;
        b=Z9RPKIa0BD8ZTHUpjE7H9a2yolGtBnmwqkS80sSUIL/xYDwEqogLeofgghq40Q++Ly
         +RAL/tKVGIpx9Khl72LpgHwYrFmpA6k8bi8K/ctbMfiL4Rk17aT8OOTDULMykbCYuEoK
         xf0VhFYuGpRmh6j7lLTc8vLeRF/P3WmaBKQFmUS8rk4XlXlj0Xc6B7HrEsizoKZmJKiV
         KkmVztKsR8hrKYET3aj8jTG6RlbGA+0XJQ/Dh4syGoV1Mgn/TSVZzpRzwuBGNRpigTFp
         Fhy3Nw9JTiAAGhAxssIdz+jXq1E7JhraU7YGNEWyqEtTjzihQ/Pw7KoQlz99mHR+iOx9
         92lg==
X-Gm-Message-State: APjAAAWZCLZOcLkee7/pNdQqM2/tAyDZGwBWuvbZknfmHr4qRlqw2Kvp
        2BgFUe3E7JXezJtR2wKtsoA=
X-Google-Smtp-Source: APXvYqzP+5ydcHbRI9MpIym4+SXSqb3o5g75fu2hbOehqpWzT+mVL1I6Kq1/9BuvzIJ5sI4zKwrqwA==
X-Received: by 2002:a1c:1b41:: with SMTP id b62mr20289275wmb.53.1577482615742;
        Fri, 27 Dec 2019 13:36:55 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v3sm36330504wru.32.2019.12.27.13.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 13:36:55 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 05/11] net: phy: Add a property for controlling in-band auto-negotiation
Date:   Fri, 27 Dec 2019 23:36:20 +0200
Message-Id: <20191227213626.4404-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227213626.4404-1-olteanv@gmail.com>
References: <20191227213626.4404-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch aims to solve a simple problem: for SerDes interfaces, the
MAC has a PCS layer which serializes the data before passing it to the
link partner (typically a PHY with its own PCS, but not necessarily, it
can also be a remote PHY).

Some of these SerDes protocols have a configuration word that is
transmitted in-band, to establish the link parameters. Some SerDes
implementations strictly require this handshake (in-band AN) to complete
before passing data, while on others it may be bypassed.

From a user perspective, the top-most entity of this in-band AN
relationship is the MAC PCS, driven by an Ethernet driver.
When the MAC PCS operates as PHY-less, there is little that can be done
from our side to prevent a settings mismatch, since the link partner may
be remote and outside our control.
When the MAC PCS is connected to a PHY driven by the PHY library, that
is when we want to ensure the in-band AN settings are in sync and can be
fulfilled by both parties.

This setting is ternary and requested by the MAC PCS driver. For
compatibility with existing code, we introduce a IN_BAND_AN_DEFAULT
state equal to 0, which means that the MAC driver, caller of the PHY
library, has no opinion about in-band AN settings. It is assumed that
somebody else has taken care of this setting and nothing should be done.

When the PHYLIB caller requests an explicit setting (IN_BAND_AN_ENABLED
or IN_BAND_AN_DISABLED), the PHY driver must veto this operation in its
.config_init callback if it can't do as requested. As mentioned, this is
to avoid mismatches, which will be taken to result in failure to pass
data between MAC and PHY.

As for the caller of PHYLIB, it shouldn't hardcode any particular value
for phydev->in_band_autoneg, but rather take this information from a
board description file such as device tree. This gives the caller a
chance to veto the setting as well, if it doesn't support it, and it
leaves the choice at the level of individual MAC-PHY instances instead
of drivers. A more-or-less standard device tree binding that can be used
to gather this information is:
	managed = "in-band-status";
which PHYLINK already uses.

Make PHYLINK the first user of this scheme, by parsing the DT binding
mentioned above and passing it to the PHY library.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Patch is new.

 drivers/net/phy/phylink.c |  2 ++
 include/linux/phy.h       | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 73a01ea5fc55..af574d5a8426 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -878,6 +878,8 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 	if (!phy_dev)
 		return -ENODEV;
 
+	phy_dev->in_band_autoneg = (pl->cfg_link_an_mode == MLO_AN_INBAND);
+
 	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
 				pl->link_interface);
 	if (ret)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 30e599c454db..090e4ba303e2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -318,6 +318,22 @@ enum phy_state {
 	PHY_NOLINK,
 };
 
+/* Settings for system-side PHY auto-negotiation:
+ * - IN_BAND_AN_DEFAULT: the PHY is left in the default configuration, be it
+ *   out-of-reset, preconfigured by boot firmware, etc. In-band AN can be
+ *   disabled, enabled or even unsupported when this setting is on.
+ * - IN_BAND_AN_ENABLED: the PHY must enable system-side auto-negotiation with
+ *   the attached MAC, or veto this setting if it can't.
+ * - IN_BAND_AN_DISABLED: the PHY must disable or bypass system-side
+ *   auto-negotiation with the attached MAC (and force the link settings if
+ *   applicable), or veto this setting if it can't.
+ */
+enum phy_in_band_autoneg {
+	IN_BAND_AN_DEFAULT = 0,
+	IN_BAND_AN_ENABLED,
+	IN_BAND_AN_DISABLED,
+};
+
 /**
  * struct phy_c45_device_ids - 802.3-c45 Device Identifiers
  * @devices_in_package: Bit vector of devices present.
@@ -388,6 +404,8 @@ struct phy_device {
 	/* Interrupts are enabled */
 	unsigned interrupts:1;
 
+	enum phy_in_band_autoneg in_band_autoneg;
+
 	enum phy_state state;
 
 	u32 dev_flags;
-- 
2.17.1

