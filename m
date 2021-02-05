Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11277311990
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhBFDMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhBFCpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:45:44 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4B9C061221
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:15 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id q2so10713184edi.4
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w6Xc58ToC8+ijxTxPbxGmb5r50nmvZ4Yn9iItw/4NHA=;
        b=ffCP1X2ParYu/ejogj+4GSu4qx1CAKARusYm7PwK1YJI2y7BFlTkH0imucZVdeNYI6
         /cA8kp3EH78Qs5I8Huuv4NBg9WXuU41AkLM8XXVqH6sf6Dh8Ya1tS36worrHQZQZazhA
         F/eIwKoDsEE7hHFBIx6P9sNRUcDblW7Obf8JkGg7FeLxj7xQKsjWSZZgteqh2TNlpad7
         hQe1vf9MVhegMne6YZhhJklL3IehoNZyF9uVWxAJfkGeiBt+YPg8avVeID4//L/q8q0F
         zgnxAnYjBa+TmSBIfxKzK6/SivXr/GMIf4CHWa6JlEW9y06+3IYh8LvK2i4WRSYa7YpK
         b+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w6Xc58ToC8+ijxTxPbxGmb5r50nmvZ4Yn9iItw/4NHA=;
        b=W9ZKTm1Yu9asKHPEASv1+x6sNXedFMBAg9G9JWe9HnWc7lCT27x0ft4bYVjGI5Tvrh
         ro5gspOlySdze5oWaCVb74R85Vx1vHfQ4pSbaza2eD0qyMSkCEi5XynHdcJUoxqGr6Fx
         cZ+BsOSGjFgsE5Ugi2C5XWmgwz/4wqEWcvNRCffJCBpCMoTX3aP6em6O7O4gNKnetJei
         GrPrV/ntOEr+js1fIQerItOZw/qkdI8Gb12hJSUszP4BYqMy98Z2tVhj3gTw/0S2OvWB
         Eyisgz9Vu0IZhIHmdzF9LruH5MGBCJFyuZCTQihXWspxujS1dDBSwSZjTFO1mgyuplXW
         f3wQ==
X-Gm-Message-State: AOAM531on99GQjFPldXYy+QP2S77GXiZl86xPd8fvQtCy9iKO935Prp/
        /iWeiq0SQ+5uGa49IA8Tbsg=
X-Google-Smtp-Source: ABdhPJwbg8Rb0pDYrEZuxrZduVdiYzEtnXgDq4m53vKtl7scvkfxUkyuBPLE2uzadL0uxeuLas0K+Q==
X-Received: by 2002:aa7:c9cf:: with SMTP id i15mr5577178edt.296.1612562594250;
        Fri, 05 Feb 2021 14:03:14 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:13 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH RESEND v3 net-next 03/12] net: mscc: ocelot: don't refuse bonding interfaces we can't offload
Date:   Sat,  6 Feb 2021 00:02:12 +0200
Message-Id: <20210205220221.255646-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
References: <20210205220221.255646-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since switchdev/DSA exposes network interfaces that fulfill many of the
same user space expectations that dedicated NICs do, it makes sense to
not deny bonding interfaces with a bonding policy that we cannot offload,
but instead allow the bonding driver to select the egress interface in
software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v3:
None.

Changes in v2:
Addressed Alex's feedback:
> This changes the return value in case of error, I'm not sure how
> important this is.
by keeping the return code of notifier_from_errno(-EINVAL)

 drivers/net/ethernet/mscc/ocelot.c     |  6 ++++-
 drivers/net/ethernet/mscc/ocelot.h     |  3 ++-
 drivers/net/ethernet/mscc/ocelot_net.c | 36 +++++++-------------------
 3 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5f21799ad85b..33274d4fc5af 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1316,12 +1316,16 @@ static void ocelot_setup_lag(struct ocelot *ocelot, int lag)
 }
 
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
-			 struct net_device *bond)
+			 struct net_device *bond,
+			 struct netdev_lag_upper_info *info)
 {
 	struct net_device *ndev;
 	u32 bond_mask = 0;
 	int lag, lp;
 
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+		return -EOPNOTSUPP;
+
 	rcu_read_lock();
 	for_each_netdev_in_bond_rcu(bond, ndev) {
 		struct ocelot_port_private *priv = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 76b8d8ce3b48..12dc74453076 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -110,7 +110,8 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 int ocelot_mact_forget(struct ocelot *ocelot,
 		       const unsigned char mac[ETH_ALEN], unsigned int vid);
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
-			 struct net_device *bond);
+			 struct net_device *bond,
+			 struct netdev_lag_upper_info *info);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index ec68cf644522..0a4de949f4d9 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1129,12 +1129,19 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 		}
 	}
 	if (netif_is_lag_master(info->upper_dev)) {
-		if (info->linking)
+		if (info->linking) {
 			err = ocelot_port_lag_join(ocelot, port,
-						   info->upper_dev);
-		else
+						   info->upper_dev,
+						   info->upper_info);
+			if (err == -EOPNOTSUPP) {
+				NL_SET_ERR_MSG_MOD(info->info.extack,
+						   "Offloading not supported");
+				err = 0;
+			}
+		} else {
 			ocelot_port_lag_leave(ocelot, port,
 					      info->upper_dev);
+		}
 	}
 
 	return notifier_from_errno(err);
@@ -1163,29 +1170,6 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
 	switch (event) {
-	case NETDEV_PRECHANGEUPPER: {
-		struct netdev_notifier_changeupper_info *info = ptr;
-		struct netdev_lag_upper_info *lag_upper_info;
-		struct netlink_ext_ack *extack;
-
-		if (!ocelot_netdevice_dev_check(dev))
-			break;
-
-		if (!netif_is_lag_master(info->upper_dev))
-			break;
-
-		lag_upper_info = info->upper_info;
-
-		if (lag_upper_info &&
-		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
-			extack = netdev_notifier_info_to_extack(&info->info);
-			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
-
-			return notifier_from_errno(-EINVAL);
-		}
-
-		break;
-	}
 	case NETDEV_CHANGEUPPER: {
 		struct netdev_notifier_changeupper_info *info = ptr;
 
-- 
2.25.1

