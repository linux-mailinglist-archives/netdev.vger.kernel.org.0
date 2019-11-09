Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA6D1F5F42
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfKINDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:24 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46405 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfKINDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:23 -0500
Received: by mail-wr1-f67.google.com with SMTP id b3so9892494wrs.13
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PAoBzU0V4n+iv7qrhPKFWYd3JI86FXfBp+HwfHAdN/k=;
        b=g3HrFWsoBZM3YZ4hbmh4XIgWcPfEJzqN1eTqnJgIi4nXwlKdEF89xFO0PykzspWqko
         wKRrYqVN2gTB7aFU8yWxM8N/6E8J5LBK44BhXlIxfQIUR+yRPYmcHnk8aucOH+Vs7FlW
         9RQ0Z3HKWyn45qSqnRp0jj9gyVWjz8FpAbzuBgdgmYqk/N/Py+w5NA/yR6D6xJfZNVsB
         BnVmLuYnz9buX4pADPyUVekftGEUbJi8faqPXvYsizbAOi8zIr0BYdXZ58EqEQi74+TK
         tvD/y+L73SqkKs3M6X3bSiG5+8aR6VHYlTtbrrhv7XJBB7Dk8dOWNvr22Dz/dyhiY3qJ
         2qHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PAoBzU0V4n+iv7qrhPKFWYd3JI86FXfBp+HwfHAdN/k=;
        b=ZfKnMmC4QlwtaWqpkxmcY05J3WQQ+h4BhuxQV5OuNp/q64oaL89avPsHBRyZtJRA3m
         xhOrQX+4Oj4buuuESsJZH1Yy5SnOIMoUibOZhgo1X9FkWYFGnz4rnKENgTH5TWTwu/RP
         YJHxSyYzi3SR749NbYTSTsNiCCXgLVugb7g9cDLGx7HepcY60UNEeDHMJ9Wa+mW4WG3F
         SV3wg5pnjTmU3+JbuLhR5239DXSrvOTMM2gznDxPdjVWcAiSCUEEg0CZfdGqqc0gP/9D
         6pBLv8PB9ffWM02fjKZoNSNK/xOy9nKNxCwwn9rTtZtxZHb88Bb4U0GlWkEwk3fWu/pB
         7jMw==
X-Gm-Message-State: APjAAAXNHcvOLRHnnKIEYNVQ28fbwt1HQHDuak02DhrboWghCbxCLxH4
        xVFr4oeN+591V0ZZBNodH/U=
X-Google-Smtp-Source: APXvYqxqqPXYl8rywCvSY4f8SmCvNzg2LfwoCx2+t2t73IeBuO/gRmpuwKPSEIMZnv3aXoPkwDAm+A==
X-Received: by 2002:a5d:5091:: with SMTP id a17mr13928442wrt.249.1573304601653;
        Sat, 09 Nov 2019 05:03:21 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:21 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 02/15] net: mscc: ocelot: break apart vlan operations into ocelot_vlan_{add,del}
Date:   Sat,  9 Nov 2019 15:02:48 +0200
Message-Id: <20191109130301.13716-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We need an implementation of these functions that is agnostic to the
higher layer (switchdev or dsa).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 60 +++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 029c5ea59e35..5b9cde6d3e38 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -270,18 +270,11 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port, u16 pvid)
 	ocelot_port->pvid = pvid;
 }
 
-static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
-			       bool untagged)
+static int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
+			   bool untagged)
 {
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = ocelot_port->chip_port;
 	int ret;
 
-	/* Add the port MAC address to with the right VLAN information */
-	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr, vid,
-			  ENTRYTYPE_LOCKED);
-
 	/* Make the port a member of the VLAN */
 	ocelot->vlan_mask[vid] |= BIT(port);
 	ret = ocelot_vlant_set_mask(ocelot, vid, ocelot->vlan_mask[vid]);
@@ -302,22 +295,29 @@ static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
 	return 0;
 }
 
-static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
+static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
+			       bool untagged)
 {
 	struct ocelot_port *ocelot_port = netdev_priv(dev);
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = ocelot_port->chip_port;
 	int ret;
 
-	/* 8021q removes VID 0 on module unload for all interfaces
-	 * with VLAN filtering feature. We need to keep it to receive
-	 * untagged traffic.
-	 */
-	if (vid == 0)
-		return 0;
+	ret = ocelot_vlan_add(ocelot, port, vid, pvid, untagged);
+	if (ret)
+		return ret;
 
-	/* Del the port MAC address to with the right VLAN information */
-	ocelot_mact_forget(ocelot, dev->dev_addr, vid);
+	/* Add the port MAC address to with the right VLAN information */
+	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr, vid,
+			  ENTRYTYPE_LOCKED);
+
+	return 0;
+}
+
+static int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int ret;
 
 	/* Stop the port from being a member of the vlan */
 	ocelot->vlan_mask[vid] &= ~BIT(port);
@@ -336,6 +336,30 @@ static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
 	return 0;
 }
 
+static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
+{
+	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = ocelot_port->chip_port;
+	int ret;
+
+	/* 8021q removes VID 0 on module unload for all interfaces
+	 * with VLAN filtering feature. We need to keep it to receive
+	 * untagged traffic.
+	 */
+	if (vid == 0)
+		return 0;
+
+	ret = ocelot_vlan_del(ocelot, port, vid);
+	if (ret)
+		return ret;
+
+	/* Del the port MAC address to with the right VLAN information */
+	ocelot_mact_forget(ocelot, dev->dev_addr, vid);
+
+	return 0;
+}
+
 static void ocelot_vlan_init(struct ocelot *ocelot)
 {
 	u16 port, vid;
-- 
2.17.1

