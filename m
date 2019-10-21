Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8145EDF715
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730526AbfJUUv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:51:58 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41049 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730498AbfJUUvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:55 -0400
Received: by mail-qt1-f193.google.com with SMTP id c17so20324279qtn.8;
        Mon, 21 Oct 2019 13:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gRTkU1hlDhCB4rz+rajjExJGYzm4sxaCoEEvEfqhbgw=;
        b=sASsBmWzjO6u9ASPRxcZ2BgA0JtTGGA4ZhFH4krisCPp8zdDccuamCONKisNdRau3L
         xzjZwie63fDkQbtGvi9JehLFTai7At0QA1h3UCBiXeOoJCTrzeN5ExDN0yDwxtjy6Fi6
         tIEwFiWrwMZ9MMebR7ged0Z4y2VclsLwUrlbcKEfa+zlCnnWZBQe1H/jfya5evv1tcSr
         x5/EKoP3LXbx2UpmhHE2Yz/et7+dAxrvOfe8Kcbu3lccAC6y/DXFDpCxp39YGoY/nzT7
         Sq9Umhw0xN1CRKU0NDbPd6Rs4JAPvzJ+AU26M3Des3pN9pB8L+tksCny/Izz4Zyp1uqi
         qkDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gRTkU1hlDhCB4rz+rajjExJGYzm4sxaCoEEvEfqhbgw=;
        b=J6GOlr2DfxMTMhkBawWMkRf31xyP+zMc3LrRnyHibYyP9pvooz9bebNJoh1T3T405b
         /3GWZaL9amhny10vx9wmw33DSWT71RMlrXtVjjAejNKNIeSR1yW0X8fw+Mm1IoyVRqRq
         3WL4POsCzOBeMOgbpPIi6Zmx+l7wAfqArS0jUAC8Y0yz6ZBxgh0P218/K4WhgiopWHEh
         fxwN3WkQICk4ClLlq+KkgG/JxrSFfKZX/CscLpS/B8hR1W70rEZKy+lG+AeKR7DJB+5D
         LuirKPR4xNMdLcq6juDDJyfpn4WoGBH1Q+pJWCH4dIul/e1m+q3WZzgH1RI+RpzZ+Dp/
         E+8A==
X-Gm-Message-State: APjAAAVKjufRBqglxTgeG6ZbsN1CiOqqhZlmmJQzrva8zWF0WdX4F/NS
        vhq6Jn8aQ52d77l8WDdPSH7jGF15
X-Google-Smtp-Source: APXvYqw+E0OJZLBaB2a7S+8JO7Z7cCl3HiYQerFM8TNP5ztBeyYvN8UglNrSMoQNxGMrThUkRRrUZg==
X-Received: by 2002:ac8:f30:: with SMTP id e45mr12511866qtk.222.1571691114590;
        Mon, 21 Oct 2019 13:51:54 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id t13sm4935639qtn.18.2019.10.21.13.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:54 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 12/16] net: dsa: mv88e6xxx: use ports list to map port VLAN
Date:   Mon, 21 Oct 2019 16:51:26 -0400
Message-Id: <20191021205130.304149-13-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of digging into the other dsa_switch structures of the fabric
and relying too much on the dsa_to_port helper, use the new list of
switch fabric ports to define the mask of the local ports allowed to
receive frames from another port of the fabric.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 510ccdc2d03c..af8943142053 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1057,35 +1057,43 @@ static int mv88e6xxx_set_mac_eee(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+/* Mask of the local ports allowed to receive frames from a given fabric port */
 static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 {
-	struct dsa_switch *ds = NULL;
+	struct dsa_switch *ds = chip->ds;
+	struct dsa_switch_tree *dst = ds->dst;
 	struct net_device *br;
+	struct dsa_port *dp;
+	bool found = false;
 	u16 pvlan;
-	int i;
 
-	if (dev < DSA_MAX_SWITCHES)
-		ds = chip->ds->dst->ds[dev];
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds->index == dev && dp->index == port) {
+			found = true;
+			break;
+		}
+	}
 
 	/* Prevent frames from unknown switch or port */
-	if (!ds || port >= ds->num_ports)
+	if (!found)
 		return 0;
 
 	/* Frames from DSA links and CPU ports can egress any local port */
-	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+	if (dp->type == DSA_PORT_TYPE_CPU || dp->type == DSA_PORT_TYPE_DSA)
 		return mv88e6xxx_port_mask(chip);
 
-	br = dsa_to_port(ds, port)->bridge_dev;
+	br = dp->bridge_dev;
 	pvlan = 0;
 
 	/* Frames from user ports can egress any local DSA links and CPU ports,
 	 * as well as any local member of their bridge group.
 	 */
-	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i)
-		if (dsa_is_cpu_port(chip->ds, i) ||
-		    dsa_is_dsa_port(chip->ds, i) ||
-		    (br && dsa_to_port(chip->ds, i)->bridge_dev == br))
-			pvlan |= BIT(i);
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->ds == ds &&
+		    (dp->type == DSA_PORT_TYPE_CPU ||
+		     dp->type == DSA_PORT_TYPE_DSA ||
+		     (br && dp->bridge_dev == br)))
+			pvlan |= BIT(dp->index);
 
 	return pvlan;
 }
-- 
2.23.0

