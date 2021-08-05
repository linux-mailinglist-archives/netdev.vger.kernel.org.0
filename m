Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9B13E1A4C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 19:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239673AbhHERXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 13:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238198AbhHERXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 13:23:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F60C061765;
        Thu,  5 Aug 2021 10:23:25 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id cl16-20020a17090af690b02901782c35c4ccso7447101pjb.5;
        Thu, 05 Aug 2021 10:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CCA4VfC8oJsngcHNQHqxfvcnSQIQ9FY8OuEOGE4n/ac=;
        b=cZavTf7ANl8OFNfJo563qA51fsfdLu+lGVjrKfWZApxc9LCwUJIVKLARVzKNDKTrfD
         yaDhlep9ypUPzIMOIB6QvD4Z2FbwiGGYsBNSZFpYaKvJBZGaa0e2eiBfanGv9uFiBnsh
         gFQX/iBVdVtVi1SLQQACfqq5Pc45KU6RG62xVK6yiBtRg9m0/q78o7XUVOXB3H/zhnJ4
         BUwcKYTPEd303BZgpXjDzdK6CkHVkzLPiMgATGRFqPsrHU5cuvdEJ4xYfIeRQ1OKnIf1
         aRdLHWkr4yupNpC5KNaSJotTkSIHkCZusf0P81XtY4LGMpY/Dc0g3yCfEpIh+BDrcsX4
         TPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CCA4VfC8oJsngcHNQHqxfvcnSQIQ9FY8OuEOGE4n/ac=;
        b=asdgkSWMZRmOVMsCsMwEfkr0tGZ5eJ1kgUeVvUkcJv3rbLiNDntX3hzTAqEDgeRD7k
         l6dGEzFrNpRV3wWD0PIsDb+kkoWWhdqI/wAJ/u52SwZUvpUFLbfcC9rL6PBR1HSgdtP+
         Ror+WC5v52uUTdN5YNvZz9J6/ClpHOM8Iz4+8in7dCWKxYmakmJ+Y94E2iE6o8cOPTvg
         8gCh0xjkz5XDr21fulOt8uX3sopI1+AyYTU5mlkb/+Lt9W8NhKPh2fWyERH2KIU54zz3
         4vNmZV3GD+iBpweJkh8VShp56jcQN5V7pd/EBx0QIIuEAr/1FChytpoNxwjoBfB4D4kC
         u8Fg==
X-Gm-Message-State: AOAM533bhuDW8y1w6NXesa3mW1M1TkEX+1j1D8Gqzwsh7grHM24ZDq5o
        ka/gDEwJ7PDmPnxmMMPOP4I=
X-Google-Smtp-Source: ABdhPJxwNlBA5AefYt8BJuAxtTtzEWiCghRdd7UiBDfhSVo+ZgTTYiDj+LCAR2b5qmqgwsbo0yoUZw==
X-Received: by 2002:a63:a0f:: with SMTP id 15mr452388pgk.80.1628184204831;
        Thu, 05 Aug 2021 10:23:24 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id j187sm7381115pfb.132.2021.08.05.10.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 10:23:24 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: dsa: mt7530: drop untagged frames on VLAN-aware ports without PVID
Date:   Fri,  6 Aug 2021 01:23:14 +0800
Message-Id: <20210805172315.362165-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver currently still accepts untagged frames on VLAN-aware ports
without PVID. Use PVC.ACC_FRM to drop untagged frames in that case.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 32 ++++++++++++++++++++++++++++++--
 drivers/net/dsa/mt7530.h |  7 +++++++
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 385e169080d9..df167f0529bb 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1257,9 +1257,11 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
 			   MT7530_PORT_FALLBACK_MODE);
 
-	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
+	mt7530_rmw(priv, MT7530_PVC_P(port),
+		   VLAN_ATTR_MASK | PVC_EG_TAG_MASK | ACC_FRM_MASK,
 		   VLAN_ATTR(MT7530_VLAN_TRANSPARENT) |
-		   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
+		   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT) |
+		   MT7530_VLAN_ACC_ALL);
 
 	/* Set PVID to 0 */
 	mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
@@ -1297,6 +1299,11 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 			   MT7530_PORT_SECURITY_MODE);
 		mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
 			   G0_PORT_VID(priv->ports[port].pvid));
+
+		/* Only accept tagged frames if PVID is not set */
+		if (!priv->ports[port].pvid)
+			mt7530_rmw(priv, MT7530_PVC_P(port), ACC_FRM_MASK,
+				   MT7530_VLAN_ACC_TAGGED);
 	}
 
 	/* Set the port as a user port which is to be able to recognize VID
@@ -1624,11 +1631,26 @@ mt7530_port_vlan_add(struct dsa_switch *ds, int port,
 	if (pvid) {
 		priv->ports[port].pvid = vlan->vid;
 
+		/* Accept all frames if PVID is set */
+		mt7530_rmw(priv, MT7530_PVC_P(port), ACC_FRM_MASK,
+			   MT7530_VLAN_ACC_ALL);
+
 		/* Only configure PVID if VLAN filtering is enabled */
 		if (dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
 			mt7530_rmw(priv, MT7530_PPBV1_P(port),
 				   G0_PORT_VID_MASK,
 				   G0_PORT_VID(vlan->vid));
+	} else if (priv->ports[port].pvid == vlan->vid) {
+		/* This VLAN is overwritten without PVID, so unset it */
+		priv->ports[port].pvid = G0_PORT_VID_DEF;
+
+		/* Only accept tagged frames if the port is VLAN-aware */
+		if (dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
+			mt7530_rmw(priv, MT7530_PVC_P(port), ACC_FRM_MASK,
+				   MT7530_VLAN_ACC_TAGGED);
+
+		mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
+			   G0_PORT_VID_DEF);
 	}
 
 	mutex_unlock(&priv->reg_mutex);
@@ -1654,6 +1676,12 @@ mt7530_port_vlan_del(struct dsa_switch *ds, int port,
 	 */
 	if (priv->ports[port].pvid == vlan->vid) {
 		priv->ports[port].pvid = G0_PORT_VID_DEF;
+
+		/* Only accept tagged frames if the port is VLAN-aware */
+		if (dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
+			mt7530_rmw(priv, MT7530_PVC_P(port), ACC_FRM_MASK,
+				   MT7530_VLAN_ACC_TAGGED);
+
 		mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
 			   G0_PORT_VID_DEF);
 	}
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 4a91d80f51bb..fe4cd2ac26d0 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -238,6 +238,7 @@ enum mt7530_port_mode {
 #define  PVC_EG_TAG_MASK		PVC_EG_TAG(7)
 #define  VLAN_ATTR(x)			(((x) & 0x3) << 6)
 #define  VLAN_ATTR_MASK			VLAN_ATTR(3)
+#define  ACC_FRM_MASK			GENMASK(1, 0)
 
 enum mt7530_vlan_port_eg_tag {
 	MT7530_VLAN_EG_DISABLED = 0,
@@ -249,6 +250,12 @@ enum mt7530_vlan_port_attr {
 	MT7530_VLAN_TRANSPARENT = 3,
 };
 
+enum mt7530_vlan_port_acc_frm {
+	MT7530_VLAN_ACC_ALL = 0,
+	MT7530_VLAN_ACC_TAGGED = 1,
+	MT7530_VLAN_ACC_UNTAGGED = 2,
+};
+
 #define  STAG_VPID			(((x) & 0xffff) << 16)
 
 /* Register for port port-and-protocol based vlan 1 control */
-- 
2.25.1

