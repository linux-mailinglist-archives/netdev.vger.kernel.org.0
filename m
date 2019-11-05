Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B811CF08B3
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbfKEVu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:50:26 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50355 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbfKEVuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:50:23 -0500
Received: by mail-wm1-f67.google.com with SMTP id 11so1080698wmk.0
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rh0Knqn2IqhHSBCsWhn91KGD4+KiwHgX0MC6njSE16M=;
        b=VmGc29UrXvUiCLYo/IHoBvCVUzFMIbWL5I01fbEDUijpo7oebxDabaEMYb5AqGWRU5
         lk1L+kHZLZWki/0oEndEbiiv4ZAIGnx95uBbNlNmNstF6EkWt/YjFPyyaBjnDfoYfJFI
         mEUbbWBX94gp8HNPPLLd07aeu5wrxwgop3bvBiECqdY7Uw+FJf0HcScTV2TlLF1pu+LF
         7fFzaAtqDSfEAAt/H0UqCEdpNYJ1yVde7CLZJo0+zTbpyMy9sHeAeEnhZKSK0s2mYUsL
         ai4OFZ0ImCwQ2fX70awi1c2wMNc6k6oIM47lvs86PY6dDYJ4gbGZoCMHrXyo39arHfoL
         LGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rh0Knqn2IqhHSBCsWhn91KGD4+KiwHgX0MC6njSE16M=;
        b=RXeG7QIx82vwmgZ6lVz9e9OJPGPcLEEjq+3sudRvDDC0tXS8sXXqIQfydPiUQU4yEQ
         8Oo2CCs4ekOeACb6Ms7KBZ7dKYRxtEXA37qVIrE5FNFcWfYgRb76JqCZGqa7GSYsGRum
         e95+fZqTKuIxSWB1ihmYkGQpOLpgHjqD1z0t9E967PeFY06QKADFwJl174MzrBzRHT9K
         RXiRXG+xS4N2vqwDhTQ7rs00BOVYkj+zEe4XJwY1i2dML1orR7Kh5oHbLHyWdsOOukhY
         SFy/foiTOCqpgpg6o/T5m7AxWHDdlt1YePjkyz6cezzA3ZTqCw3CqFBx9W/AwUaAWHXe
         PuEA==
X-Gm-Message-State: APjAAAXdqxO7OZXszJMMO40QMoi1BHEDJRB0US0GrjjA44IqtvRM3DYO
        mVSjM44lqmop6gHaQ21Ix44=
X-Google-Smtp-Source: APXvYqxGDVmzxqDatyc+7O3Ru0ZnQpW993ieLO/Qfv7qExZ6yl8e5Nc01mEkudhP/6zwEuSo1Rm09A==
X-Received: by 2002:a7b:cb0a:: with SMTP id u10mr1020666wmj.48.1572990621510;
        Tue, 05 Nov 2019 13:50:21 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id r19sm25389732wrr.47.2019.11.05.13.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 13:50:20 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 1/2] net: mscc: ocelot: don't handle netdev events for other netdevs
Date:   Tue,  5 Nov 2019 23:50:13 +0200
Message-Id: <20191105215014.12492-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191105215014.12492-1-olteanv@gmail.com>
References: <20191105215014.12492-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

The check that the event is actually for this device should be moved
from the "port" handler to the net device handler.

Otherwise the port handler will deny bonding configuration for other
net devices in the same system (like enetc in the LS1028A) that don't
have the lag_upper_info->tx_type restriction that ocelot has.

Fixes: dc96ee3730fc ("net: mscc: ocelot: add bonding support")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 344539c0d3aa..dbf09fcf61f1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1680,9 +1680,6 @@ static int ocelot_netdevice_port_event(struct net_device *dev,
 	struct ocelot_port *ocelot_port = netdev_priv(dev);
 	int err = 0;
 
-	if (!ocelot_netdevice_dev_check(dev))
-		return 0;
-
 	switch (event) {
 	case NETDEV_CHANGEUPPER:
 		if (netif_is_bridge_master(info->upper_dev)) {
@@ -1719,6 +1716,9 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	int ret = 0;
 
+	if (!ocelot_netdevice_dev_check(dev))
+		return 0;
+
 	if (event == NETDEV_PRECHANGEUPPER &&
 	    netif_is_lag_master(info->upper_dev)) {
 		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
-- 
2.17.1

