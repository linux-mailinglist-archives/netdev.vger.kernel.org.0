Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F442FA23E
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 14:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392516AbhARNzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 08:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392507AbhARNxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 08:53:05 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CBDC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 05:52:25 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id p22so17636431edu.11
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 05:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wvEVGNe84JT+aQuHL3u0gYPjwus4MCEwXYRveUk+Nfg=;
        b=MzO4z4pO424doHmMN1omkXqJlguoCDbs3GxZPDh+oBQdGFcuXy9Se0ptot/F+b4pRC
         FGC1IQC5oPzqOJK7QNqdl9MKxAD++6uushcoRbgkHo1bS9p7eS2rEH0W+b+EJz4FUwQT
         zwDrIyZymWXbQ7eT6O4joN/ZUu5Hz+/f80/oWGC+z0BFsXVP3mvPFgkrFXG0C1PCAjNA
         HjxkYxCgoXFCKjhymDxVvsgE2WtHM+ClZVBjeJAhpLg3OhY2QBAWdQdYc646YoGGzD3T
         +3YohaVP60FFKe5ZQtjB0eU6sICj7Rc/YEj59U77DjCDQ9c12XSbNL4TL+5Qx1V1AzI6
         SMOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wvEVGNe84JT+aQuHL3u0gYPjwus4MCEwXYRveUk+Nfg=;
        b=n5DUmGXIg0Vu7JAUFX37GJRUGoF7uTf8q9VGueV9GxC64RSuTZ3AJ+PZf5UCbYMalQ
         t74ppIXWMi7coCRhuVq1t0d2kb08cxOiocYFMzFs+tkfhXEF3R9HZPLSik6WYMGnL8zl
         mbjQbGUEuMXR8G9r5z/ImwSfYf8BsDhkAIuxZ3v7nvAR2/2KSJpOSwsRrCI4433bwSFf
         TTJ/UMItMBTSOEloXlg24hnwY5Jqg4DPwr1CA+dFqFM8ZVX4Pda3L+5mZ10aF3OEAt5o
         OV6wYIOG2lRc0sv/Vu+H+C3RtnU9MBjygXjgP6QpHGBD189TQ27AW7l3GshGIfnyROm5
         YScw==
X-Gm-Message-State: AOAM530GnrlajOtcG+wdDWXKuEvXUvhO5/Qxb0XT3GNIqEgnSgXBkQ+9
        LlDKgoItX+botiADgKiAc8mEdlYeVtU=
X-Google-Smtp-Source: ABdhPJzehgF/PEqX9kg9QTHJ8EPKjLswzBiGNUVf7c1AYT1yq4GiazH//UDieDe0ouNzJa5fRX9QYw==
X-Received: by 2002:aa7:db4e:: with SMTP id n14mr10627540edt.101.1610977944182;
        Mon, 18 Jan 2021 05:52:24 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id i22sm4460142ejx.77.2021.01.18.05.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 05:52:23 -0800 (PST)
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
Subject: [PATCH net] net: mscc: ocelot: allow offloading of bridge on top of LAG
Date:   Mon, 18 Jan 2021 15:52:10 +0200
Message-Id: <20210118135210.2666246-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The blamed commit was too aggressive, and it made ocelot_netdevice_event
react only to network interface events emitted for the ocelot switch
ports.

In fact, only the PRECHANGEUPPER should have had that check.

When we ignore all events that are not for us, we miss the fact that the
upper of the LAG changes, and the bonding interface gets enslaved to a
bridge. This is an operation we could offload under certain conditions.

Fixes: 7afb3e575e5a ("net: mscc: ocelot: don't handle netdev events for other netdevs")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 2bd2840d88bd..42230f92ca9c 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1042,10 +1042,8 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	int ret = 0;
 
-	if (!ocelot_netdevice_dev_check(dev))
-		return 0;
-
 	if (event == NETDEV_PRECHANGEUPPER &&
+	    ocelot_netdevice_dev_check(dev) &&
 	    netif_is_lag_master(info->upper_dev)) {
 		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
 		struct netlink_ext_ack *extack;
-- 
2.25.1

