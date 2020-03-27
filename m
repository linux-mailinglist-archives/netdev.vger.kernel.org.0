Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58B1195F5E
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgC0T4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:56:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38192 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbgC0T4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:56:01 -0400
Received: by mail-wm1-f67.google.com with SMTP id f6so7195900wmj.3
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 12:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s7tbstuFGEpRCcyGVHhiptgOv8UP+5o42rEmNwNHkhk=;
        b=Zx3GNUMlgc5kj4E0vpASljMa0b/WJiFdNxg+4M9J52sWissve7c3FhgNFt8pOzl2L1
         u2zHzRPZraR7PrTFo4tv7mAmOvpp/glVfZUjjti89+XJdY4a33EIQpAJ2rd9YB87o0CE
         dlccJ4W7j2UWtwMsKdf1Gd4odVLeW72VuLUuvEPREpnXOZJLJYh49jCbHhKDCL9vpKYh
         zU28Yxl6qcu9SsbohPhn45sBSVVH7jfspMMurPIGXHd2AySCqvlQRg84fHzVHObcmOye
         nuAzLnefL4xw5wkCiAobNUH+Ho0gzJ3llt8n6vRYIElsOF0Pu9ARoyJElARxjL/ey64p
         CI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s7tbstuFGEpRCcyGVHhiptgOv8UP+5o42rEmNwNHkhk=;
        b=Hc3aL8wG5URfvuhafEiH/O/51otAFOIP2kNhvXUW9UokJkWWU7iO2vpihS0+3DjWdl
         ZozYbAUdOZST9a3bcCgDzjFvgmRMlMkoh3G5/vRDXEtoDoom96UmL5Sj3j02S8itKTSC
         Ovi5nLsYefPfs8338F/L+Zyr5wgfSpGUGd1SB8qmCfzbtoAnCG/egQQrPhNpGlZe46WV
         duS2g+CQvcpX85UfG2pjvMaQAitJlDeuklceY+CkSrSe/FjtR67/2GTKwJt0CKFVgu8C
         aBXNsETONuH/wyigkgTKeubFiPKfsM2VmStLJ4NTFPmmyd4O5/K4KpzzNxDesqRxyi0i
         +DKw==
X-Gm-Message-State: ANhLgQ1NeZ0NfkYddaxQZLHC1ygphx9IBqYW1sV/Oir4D3exqRSe798h
        1SF6RwWEyt/m0yv1BrSq8Mo=
X-Google-Smtp-Source: ADFU+vviUT0gYTNBU+BAUd1dM6O7+uoosVx+nCgjaMygyuYU06DHTNy14nJNLqVeUlDvC/a1kFyyxQ==
X-Received: by 2002:a1c:b4d4:: with SMTP id d203mr373452wmf.85.1585338960515;
        Fri, 27 Mar 2020 12:56:00 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z19sm10089479wrg.28.2020.03.27.12.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 12:56:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 5/8] net: dsa: b53: add MTU configuration support
Date:   Fri, 27 Mar 2020 21:55:44 +0200
Message-Id: <20200327195547.11583-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327195547.11583-1-olteanv@gmail.com>
References: <20200327195547.11583-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Krishna Policharla <murali.policharla@broadcom.com>

It looks like the Broadcom switches supported by the b53 driver don't
support precise configuration of the MTU, but just a mumbo-jumbo boolean
flag. Set that.

Also configure BCM583XX devices to send and receive jumbo frames when
ports are configured with 10/100 Mbps speed.

Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
Changed the device id for the allow_10_100 check.

Changes in v3:
Using the b53_set_jumbo function that was already there.

Changes in v2:
Patch is new.

 drivers/net/dsa/b53/b53_common.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ceafce446317..39ae4ed87d1d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -699,9 +699,6 @@ int b53_configure_vlan(struct dsa_switch *ds)
 		b53_write16(dev, B53_VLAN_PAGE,
 			    B53_VLAN_PORT_DEF_TAG(i), def_vid);
 
-	if (!is5325(dev) && !is5365(dev))
-		b53_set_jumbo(dev, dev->enable_jumbo, false);
-
 	return 0;
 }
 EXPORT_SYMBOL(b53_configure_vlan);
@@ -807,8 +804,6 @@ static int b53_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val)
 static int b53_reset_switch(struct b53_device *priv)
 {
 	/* reset vlans */
-	priv->enable_jumbo = false;
-
 	memset(priv->vlans, 0, sizeof(*priv->vlans) * priv->num_vlans);
 	memset(priv->ports, 0, sizeof(*priv->ports) * priv->num_ports);
 
@@ -2065,6 +2060,26 @@ int b53_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 }
 EXPORT_SYMBOL(b53_set_mac_eee);
 
+static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
+{
+	struct b53_device *dev = ds->priv;
+	bool enable_jumbo;
+	bool allow_10_100;
+
+	if (is5325(dev) || is5365(dev))
+		return -EOPNOTSUPP;
+
+	enable_jumbo = (mtu >= JMS_MIN_SIZE);
+	allow_10_100 = (dev->chip_id == BCM583XX_DEVICE_ID);
+
+	return b53_set_jumbo(dev, enable_jumbo, allow_10_100);
+}
+
+static int b53_get_max_mtu(struct dsa_switch *ds, int port)
+{
+	return JMS_MAX_SIZE;
+}
+
 static const struct dsa_switch_ops b53_switch_ops = {
 	.get_tag_protocol	= b53_get_tag_protocol,
 	.setup			= b53_setup,
@@ -2102,6 +2117,8 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_mdb_prepare	= b53_mdb_prepare,
 	.port_mdb_add		= b53_mdb_add,
 	.port_mdb_del		= b53_mdb_del,
+	.port_max_mtu		= b53_get_max_mtu,
+	.port_change_mtu	= b53_change_mtu,
 };
 
 struct b53_chip_data {
-- 
2.17.1

