Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8769D194BAA
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 23:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgCZWlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 18:41:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36618 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727696AbgCZWlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 18:41:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id g62so10061119wme.1
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 15:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G4ajGnsm6J0V4DS1Hs9z3LTG7liZ4Sv6fY3Unr7rPaU=;
        b=by0qYJ8EyZiKmVBp8yEj/l2uUPlKCffMKNgNHi5L0Rpp8fr/KXGN3tL5YnCEr/e5vc
         Hc5Qw1/zIuExL4oGXwaEujFVmMnl9myi35rN0d9l2D/5PQqtuDiax7MnDlhjmPhCQeUq
         YgHV3Sx0Oqs4vhGpbkUwJTTl9kY1xD1Oyvn+AuRbVNZiafmcTbk/8e0Bb85k4/zMIGTd
         8CJ+3RNRRL5VICrcIXP4GRBYtV7ilnJOt3j8uAhwNulS6nFQA8OOl1DWAcyevToY8uXk
         twGOaZCJkHIoxtW29nf/HOKcSOdNjHJe3fRfm67MN9i2oPjl67pFS0HRZ4VqRgYnKbkY
         WPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G4ajGnsm6J0V4DS1Hs9z3LTG7liZ4Sv6fY3Unr7rPaU=;
        b=TznlzvTITXaVsuoOW9nVJT6LmxodJo0IP6AfjzzqrVJTEt+CuiPrx/4kDvIlQGE393
         pigj1xieDb+VYvKNQrUTwa+2cLIeLlxazQ8wqCLwtTvnVExO8Cih+rQ21lI5BLyl/ElS
         ZclGrZlYGCeMxtuRwNCKAze4+LzujnEvbhoqPicdrOZbaUziBXYxNndLnz+YomvSvy3F
         XOSRoZ6A6dbH2VgCqDf7jHWS5xGdfvtkaRqVN+3CpMBbJ6C3ppoTs3XK+p6D+R8/AjHJ
         IpGHDnxm9xKv4FELHRK3TQfnMcBHcwg5ynqpmIESaJ4Kx4rNLyU27YnhaJNFMvDf1Hou
         Mm7Q==
X-Gm-Message-State: ANhLgQ0b4WfIAunlAgm+yZauQldva2CoWdiDI2wz7Zyj8K2/NtCVqbtj
        29w2G5Ko+/NNIry46Ch9aYY=
X-Google-Smtp-Source: ADFU+vtpgodKyYNA4tuFvTRmGLvOFJgOM39MdyvhYTAbfWmRPd05kNp0AZyNQPk/UXRkCsCTt22Fxw==
X-Received: by 2002:a5d:4f08:: with SMTP id c8mr723853wru.27.1585262468459;
        Thu, 26 Mar 2020 15:41:08 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id t81sm5522783wmb.15.2020.03.26.15.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 15:41:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 5/8] net: dsa: b53: add MTU configuration support
Date:   Fri, 27 Mar 2020 00:40:37 +0200
Message-Id: <20200326224040.32014-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200326224040.32014-1-olteanv@gmail.com>
References: <20200326224040.32014-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Krishna Policharla <murali.policharla@broadcom.com>

It looks like the Broadcomm switches supported by the b53 driver don't
support precise configuration of the MTU, but just a mumbo-jumbo boolean
flag. Set that.

Also configure BCM583XX devices to send and receive jumbo frames when
ports are configured with 10/100 Mbps speed.

Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Using the b53_set_jumbo function that was already there.

Changes in v2:
Patch is new.

 drivers/net/dsa/b53/b53_common.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ceafce446317..f432edf618e1 100644
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
+	allow_10_100 = (dev->chip_id == BCM58XX_DEVICE_ID);
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

