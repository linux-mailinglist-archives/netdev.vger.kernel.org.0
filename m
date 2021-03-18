Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145CF340E2A
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhCRT0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbhCRTZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:25:47 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DC1C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:46 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e9so6738618wrw.10
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=LU4zHWVy6LHnH+mwS8aNnMWGy91irUuDZsXDy3cN124=;
        b=ohcxjnVa9vzDJDz6qWycoKQDPuSQ5EUkKA0tGjJmS3d9siotBIyCantCoTgNGRC6eU
         8nz1aL+SSNwZGEBvbU030K9173YwBAu5TxwR02cMMdGpQXrOMrC1IlHr4JcpDxeZUt22
         DVizI34+2/EQyGpUq7TRP5PnCvUV7drDom5rLGAprSDUPdaiIglL78LzZ61HEL04AFVH
         pGNbbGS66TwHBeJL7pLon8hYVmk4oVZ5VI033PLz+r2exRwPx8TSiCBDivbwB3Z4PwOE
         1sVIUL8RRDaEhaveIEhjX11jQKqGQ2dSb7bI0vmnJ8s2qoUGXm7s6aN/bFxcgSJWVwra
         A8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=LU4zHWVy6LHnH+mwS8aNnMWGy91irUuDZsXDy3cN124=;
        b=r9pg/Gx5nZroOYyvpNnK7B4OHkNXsVsmyjNnp9sbmscuMCltMXk0Qr7ySm5nTCfWq1
         5Apln9V/JbOKw2f0HdYf4HakhWldFDXYQArHCNEvfpSgLJ31OaquiJdifyqW2hdWn/y5
         JrN4fx6y6RlJaYj7qB3KJaTb5tKCgw3we/TXW59Nd6qinNSNKKgjuU1IuFZy5myZv1Hx
         0fitd3D/VKx7jIeAje7YB0D5bO9kOHpU2h5bz+Ffb2/6/C4VAeW5S6rwkGRuE8KuoBPu
         Zx1CpmOG1um/9T03GFMJSeGZTlotcYCh2Xq/CqTZOfZmmXpNIfedXtifYCdRYr3mQBqb
         R/HA==
X-Gm-Message-State: AOAM531JWsqI1XdWx9DC5g1QtcJgXOzQFTj1EUQjHGXf04WIBWcuJQ4f
        N+FVq01j6Lc4N5Ah3qU+ZiX/CA==
X-Google-Smtp-Source: ABdhPJzgsnH/mD7Np/iPh36Q2KhP/IHDVGSRhKnSICIz6Zmt8uFKl/T7R1zwFNWan0rdFfqM5ZJ0pg==
X-Received: by 2002:a5d:6ca6:: with SMTP id a6mr779299wra.179.1616095545650;
        Thu, 18 Mar 2021 12:25:45 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j30sm4576443wrj.62.2021.03.18.12.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 12:25:45 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 1/8] net: dsa: Add helper to resolve bridge port from DSA port
Date:   Thu, 18 Mar 2021 20:25:33 +0100
Message-Id: <20210318192540.895062-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318192540.895062-1-tobias@waldekranz.com>
References: <20210318192540.895062-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for a driver to be able to query a bridge for information
about itself, e.g. reading out port flags, it has to use a netdev that
is known to the bridge. In the simple case, that is just the netdev
representing the port, e.g. swp0 or swp1 in this example:

   br0
   / \
swp0 swp1

But in the case of an offloaded lag, this will be the bond or team
interface, e.g. bond0 in this example:

     br0
     /
  bond0
   / \
swp0 swp1

Add a helper that hides some of this complexity from the
drivers. Then, redefine dsa_port_offloads_bridge_port using the helper
to avoid double accounting of the set of possible offloaded uppers.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/net/dsa.h  | 14 ++++++++++++++
 net/dsa/dsa_priv.h | 14 +-------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index dac303edd33d..57b2c49f72f4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -493,6 +493,20 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 		return dp->vlan_filtering;
 }
 
+static inline
+struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
+{
+	if (!dp->bridge_dev)
+		return NULL;
+
+	if (dp->lag_dev)
+		return dp->lag_dev;
+	else if (dp->hsr_dev)
+		return dp->hsr_dev;
+
+	return dp->slave;
+}
+
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 9d4b0e9b1aa1..4c43c5406834 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -233,19 +233,7 @@ extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
 						 struct net_device *dev)
 {
-	/* Switchdev offloading can be configured on: */
-
-	if (dev == dp->slave)
-		/* DSA ports directly connected to a bridge, and event
-		 * was emitted for the ports themselves.
-		 */
-		return true;
-
-	if (dp->lag_dev == dev)
-		/* DSA ports connected to a bridge via a LAG */
-		return true;
-
-	return false;
+	return dsa_port_to_bridge_port(dp) == dev;
 }
 
 static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
-- 
2.25.1

