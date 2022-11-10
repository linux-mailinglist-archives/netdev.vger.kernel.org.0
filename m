Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9654762428F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 13:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiKJMrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 07:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKJMrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 07:47:05 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FECF4047D
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:47:04 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id m204so1682554oib.6
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2dPyfU82fPWg5Er3UXLUlR+lvcuqLCYZpafxU7GrLmU=;
        b=qmWjUC+R55Lf816DLS/HqozmTJeMD9hZP0ydBz7Fxd3PLPKG4Bw4PtfVZpAycfKy9p
         hk2vk5365V3ISUu4GNE00+bcpySWTX2D4wZny9kOQBKc95XK5GJIk/Qm8oNB2+L/wZVa
         iZd5kTgEcGAD3t9dH/Y1HOAsY7uakogc2nEdJUTlQNSFN4DtasMp/WJVWd2ehxCRHLfJ
         2O7w/dsWEWObCxkYYrV/pHYk6UrHjY++XH3cC/flkyeDhSwpO0gWXmpnj8AO7WDoPZ6u
         y2FA7O9Ty1WpZZr5PK4UDcFIukTYaYEFNmk/Xi+27iVDskJY9S6fTXv0L7TqUPKYusO/
         JlUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2dPyfU82fPWg5Er3UXLUlR+lvcuqLCYZpafxU7GrLmU=;
        b=e6MJh403jt+775yplwbxUCO2W/sTMe/xDJlUFiEGrUsmkDRpMKiFxUrljkjM4HY6Xy
         3qTS1a1361a3cS53PECSDVWQTX7bFusWsG0u340rggS1b/HCtKQKpSkIPW1szBeEOYrL
         +QBebdYSVKY4PyV1cisDLvrCHOHjry/HB3rv54WmqBO15yLZC4rLhrhyPsiiWWyV7jkP
         7bMRh9ASGUgbyzTWN96caUOODB8l/j9N9A6PIlnYxbxkPMGMvs7FF+7C0Tg3Dp1zVHU+
         ggaNS73uFyZWYUoptO5mKRYtB4EL33FAUi8ObLyHfzUeuA0jrybCrZMRUb0i5sPknZ/+
         yUew==
X-Gm-Message-State: ACrzQf0nCqJaIEmD9Gob87qcgleGFhhLrjrzIMTgYTKb3qgh0cIcmHUP
        wmDzHUY02ITRKP93uxIaDzY=
X-Google-Smtp-Source: AMsMyM7JXOoqVZadtKcTGjtpEAB0jrtYLGbxj3zU7nyapKphHMrKNHxQ2x7QREZCMZjeCfSuxgR7ZA==
X-Received: by 2002:aca:5a44:0:b0:35a:6004:2bc9 with SMTP id o65-20020aca5a44000000b0035a60042bc9mr1227425oib.3.1668084423768;
        Thu, 10 Nov 2022 04:47:03 -0800 (PST)
Received: from localhost.localdomain ([2804:14c:485:4b69:314f:58a0:2270:2e])
        by smtp.gmail.com with ESMTPSA id o65-20020aca4144000000b0035028730c90sm5710289oia.1.2022.11.10.04.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 04:47:03 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     andrew@lunn.ch, olteanv@gmail.com, netdev@vger.kernel.org,
        =?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Allow hwstamping on the master port
Date:   Thu, 10 Nov 2022 09:43:45 -0300
Message-Id: <20221110124345.3901389-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Bätz <steffen@innosonix.de>

Currently, it is not possible to run SIOCGHWTSTAMP or SIOCSHWTSTAMP
ioctls on the dsa master interface if the port_hwtstamp_set/get()
hooks are present, as implemented in net/dsa/master.c:

static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
{
...
	case SIOCGHWTSTAMP:
	case SIOCSHWTSTAMP:
		/* Deny PTP operations on master if there is at least one
		 * switch in the tree that is PTP capable.
		 */
		list_for_each_entry(dp, &dst->ports, list)
			if (dp->ds->ops->port_hwtstamp_get ||
			    dp->ds->ops->port_hwtstamp_set)
				return -EBUSY;
		break;
	}

Even if the hwtstamping functionality is disabled in the mv88e6xxx driver
by not setting CONFIG_NET_DSA_MV88E6XXX_PTP, the functions port_hwtstamp_set()
port_hwtstamp_get() are still present due to their stub declarations.

Fix this problem, by removing the stub declarations and guarding these
functions wih CONFIG_NET_DSA_MV88E6XXX_PTP.

Without this change:

 # hwstamp_ctl -i eth0
SIOCGHWTSTAMP failed: Device or resource busy

With the change applied, it is possible to set and get the timestamping
options:

 # hwstamp_ctl -i eth0
current settings:
tx_type 0
rx_filter 0

 # hwstamp_ctl -i eth0 -r 1 -t 1
current settings:
tx_type 0
rx_filter 0
new settings:
tx_type 1
rx_filter 1

Tested on a custom i.MX8MN board with a 88E6320 switch.

Signed-off-by: Steffen Bätz <steffen@innosonix.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
 drivers/net/dsa/mv88e6xxx/chip.c     |  2 ++
 drivers/net/dsa/mv88e6xxx/hwtstamp.h | 12 ------------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index bf34c942db99..cfa0168cab03 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6925,8 +6925,10 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_mirror_del	= mv88e6xxx_port_mirror_del,
 	.crosschip_bridge_join	= mv88e6xxx_crosschip_bridge_join,
 	.crosschip_bridge_leave	= mv88e6xxx_crosschip_bridge_leave,
+#ifdef CONFIG_NET_DSA_MV88E6XXX_PTP
 	.port_hwtstamp_set	= mv88e6xxx_port_hwtstamp_set,
 	.port_hwtstamp_get	= mv88e6xxx_port_hwtstamp_get,
+#endif
 	.port_txtstamp		= mv88e6xxx_port_txtstamp,
 	.port_rxtstamp		= mv88e6xxx_port_rxtstamp,
 	.get_ts_info		= mv88e6xxx_get_ts_info,
diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.h b/drivers/net/dsa/mv88e6xxx/hwtstamp.h
index cf7fb6d660b1..86c6213c2ae8 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.h
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.h
@@ -132,18 +132,6 @@ int mv88e6165_global_disable(struct mv88e6xxx_chip *chip);
 
 #else /* !CONFIG_NET_DSA_MV88E6XXX_PTP */
 
-static inline int mv88e6xxx_port_hwtstamp_set(struct dsa_switch *ds,
-					      int port, struct ifreq *ifr)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds,
-					      int port, struct ifreq *ifr)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
 					   struct sk_buff *clone,
 					   unsigned int type)
-- 
2.25.1

