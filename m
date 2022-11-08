Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F59620B08
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiKHIXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiKHIXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:23:51 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE2CF014
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:23:50 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 0829A84DF9;
        Tue,  8 Nov 2022 09:23:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667895828;
        bh=wgb6XYrXtu1js3p2L4ykT61qERQS3CKBqRCMbvrkYXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2sijH2NG+pgndT7No36ls73onlvp5rBuP1kYGwDBUaBwZR1wbeI83JRryZmu/cfJ
         nHAiQ9bqkjJFXd2vPz9jvOAu7+UZZ/2/lyQRSTaHQE4ZlptU2lBLhBsiU54IPUNpjr
         iCWXT14jg8cnr+h8XF525qucODxwDyICqj+EVk2UsVlsGmQjcSV3B+X35N3a+3Bz3u
         adGv7LU+AVxrQl6ZaTFNlfjXtStyPJQM8qQ5Y6x1ubHS6uAMSywbC6D1g/3TdbOKis
         IFo/UYPCs1ETxa4WnruK8pNeahJaY1UExaP7w9q05tY0+liElj/2hJuVxpQz6yA6V2
         GHTNLt3q9SRRQ==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 1/9] net: dsa: allow switch drivers to override default slave PHY addresses
Date:   Tue,  8 Nov 2022 09:23:22 +0100
Message-Id: <20221108082330.2086671-2-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108082330.2086671-1-lukma@denx.de>
References: <20221108082330.2086671-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

Avoid having to define a PHY for every physical port when PHY addresses
are fixed, but port index != PHY address.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Lukasz Majewski <lukma@denx.de>
[Adjustments for newest kernel upstreaming]
---
 include/net/dsa.h | 1 +
 net/dsa/slave.c   | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index ee369670e20e..210b0e215ac9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -858,6 +858,7 @@ struct dsa_switch_ops {
 	int	(*port_setup)(struct dsa_switch *ds, int port);
 	void	(*port_teardown)(struct dsa_switch *ds, int port);
 
+	int	(*get_phy_address)(struct dsa_switch *ds, int port);
 	u32	(*get_phy_flags)(struct dsa_switch *ds, int port);
 
 	/*
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a9fde48cffd4..8bb1e8770846 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2273,7 +2273,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	struct device_node *port_dn = dp->dn;
 	struct dsa_switch *ds = dp->ds;
 	u32 phy_flags = 0;
-	int ret;
+	int ret, addr;
 
 	dp->pl_config.dev = &slave_dev->dev;
 	dp->pl_config.type = PHYLINK_NETDEV;
@@ -2299,7 +2299,12 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		/* We could not connect to a designated PHY or SFP, so try to
 		 * use the switch internal MDIO bus instead
 		 */
-		ret = dsa_slave_phy_connect(slave_dev, dp->index, phy_flags);
+		if (ds->ops->get_phy_address)
+			addr = ds->ops->get_phy_address(ds, dp->index);
+		else
+			addr = dp->index;
+
+		ret = dsa_slave_phy_connect(slave_dev, addr, phy_flags);
 	}
 	if (ret) {
 		netdev_err(slave_dev, "failed to connect to PHY: %pe\n",
-- 
2.37.2

