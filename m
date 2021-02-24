Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306DD323B6B
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbhBXLqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbhBXLpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:45:08 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D120BC06178C
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:06 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id h25so2090815eds.4
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yoeAVXVVgmxIroT+hw2AkHBtvfntX19xz1hn/RwiUHo=;
        b=QqBVRTlRH4UmpnUe3vf/XKZfg283KiLXd9GaHYMDaFTz3pbjLSb2/RJBvk5D12xvY3
         GM3WsUh/F+2HS7c81WJYiIkqMpdyqlPBQro5KfjqAfohM1l5ZfZCA2DQv2HBjcHzReYV
         ZPgA7zNzFbSjZQCpi4Yla4WqN2ry5BuTg2WK7boUK0JnHm/oDBHzcOAD89F6atg+flip
         aju7FaYb1DpEuvTcUBc3VlREH005D6UkzM7Hr1gcamkQFi9SykR51/943rLpFc/G7+e7
         KxcCknOQDb5R01WOR7uNmvB6VAMLkMt+ROaeMSlGCe+4YF2Q5wjJ5TuXBVh3BZS3qNh7
         5ybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yoeAVXVVgmxIroT+hw2AkHBtvfntX19xz1hn/RwiUHo=;
        b=loHkCBcsOCfZfgSURABvo2BthhPIiQOxBkHX13vRZNxH3PxrVvIKD8kQk36DuNDcRa
         B75BiWA27a62g0GLc/OlJL58nBioaQRvOei4J9b7c2wSx6NFNrsNEyUXwMndL8754xed
         q5CcH9eZeKBuK9rKcnvE3CtaH+EjZ/rJ0kKRthEZG6Ov4yWGmIJHcZSRS0WxVWVH7Kao
         L4ft0s5Y1qe8IL1Ry5MMqOFpAbxSsvD8VkAPEFlTKgMXfzoUSD/44Agz0hI9k4bHfySC
         0iKsUGcBhO7z9/ICgSyY7qkT6/LKmtuA8r/9CHmqzrhJsdzv981uZm+jcfLim1iO3IkN
         4u2A==
X-Gm-Message-State: AOAM531Z0cc0IO77IhskpVQwdWwVaWlCBbMiO8V7BgblMnbnZyqIyedR
        yW3J39aruRCP6zvTdqatjOfDwXLQPdE=
X-Google-Smtp-Source: ABdhPJwHE/yG7le0+dXFw79KdfZeaq/qV/N2rEKvBzipX7VSzGlbidosUeHpY7fjzbZQPNbUUj6jug==
X-Received: by 2002:aa7:d2c4:: with SMTP id k4mr15362246edr.237.1614167045449;
        Wed, 24 Feb 2021 03:44:05 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:05 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 04/17] net: dsa: install the port MAC addresses as host fdb entries
Date:   Wed, 24 Feb 2021 13:43:37 +0200
Message-Id: <20210224114350.2791260-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In preparation of support for IFF_UNICAST_FLT for DSA standalone ports,
the unicast address of the DSA interfaces should always be known to the
switch and installed as an FDB entry towards the CPU port associated
with that user port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b6ea7e21b3b6..6544a4ec69f4 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -223,11 +223,9 @@ static int dsa_slave_open(struct net_device *dev)
 		goto out;
 	}
 
-	if (!ether_addr_equal(dev->dev_addr, master->dev_addr)) {
-		err = dev_uc_add(master, dev->dev_addr);
-		if (err < 0)
-			goto out;
-	}
+	err = dsa_host_fdb_add(dp, dev->dev_addr, 0);
+	if (err && err != -EOPNOTSUPP)
+		goto out;
 
 	if (dev->flags & IFF_ALLMULTI) {
 		err = dev_set_allmulti(master, 1);
@@ -253,8 +251,7 @@ static int dsa_slave_open(struct net_device *dev)
 	if (dev->flags & IFF_ALLMULTI)
 		dev_set_allmulti(master, -1);
 del_unicast:
-	if (!ether_addr_equal(dev->dev_addr, master->dev_addr))
-		dev_uc_del(master, dev->dev_addr);
+	dsa_host_fdb_del(dp, dev->dev_addr, 0);
 out:
 	return err;
 }
@@ -273,8 +270,7 @@ static int dsa_slave_close(struct net_device *dev)
 	if (dev->flags & IFF_PROMISC)
 		dev_set_promiscuity(master, -1);
 
-	if (!ether_addr_equal(dev->dev_addr, master->dev_addr))
-		dev_uc_del(master, dev->dev_addr);
+	dsa_host_fdb_del(dp, dev->dev_addr, 0);
 
 	return 0;
 }
@@ -302,26 +298,18 @@ static void dsa_slave_set_rx_mode(struct net_device *dev)
 
 static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
 {
-	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct sockaddr *addr = a;
 	int err;
 
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	if (!(dev->flags & IFF_UP))
-		goto out;
-
-	if (!ether_addr_equal(addr->sa_data, master->dev_addr)) {
-		err = dev_uc_add(master, addr->sa_data);
-		if (err < 0)
-			return err;
-	}
-
-	if (!ether_addr_equal(dev->dev_addr, master->dev_addr))
-		dev_uc_del(master, dev->dev_addr);
+	err = dsa_host_fdb_add(dp, addr->sa_data, 0);
+	if (err && err != -EOPNOTSUPP)
+		return err;
 
-out:
+	dsa_host_fdb_del(dp, dev->dev_addr, 0);
 	ether_addr_copy(dev->dev_addr, addr->sa_data);
 
 	return 0;
-- 
2.25.1

