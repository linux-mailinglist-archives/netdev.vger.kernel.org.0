Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEDFDDC12
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfJTDUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:23 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39952 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfJTDUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:16 -0400
Received: by mail-qt1-f195.google.com with SMTP id o49so7425027qta.7;
        Sat, 19 Oct 2019 20:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZKyvo8245xL/BxF/Gv/+cUrFV68zLsFhX14RcWrEpQs=;
        b=WI6J2tONXI1Ds9JkXUIizN69R/lNE6EUbT1iaT2+gabMeo9ekIZP3hr9kp4KxwkBQL
         ZLSiqHiGViuVxQ+qx2V6TtnhySo2Hdir3WNkt+fQNcbzF0Y/U9M3xcixF/28LDIfgL9n
         EBlXpgDIv01gpbNogCYxY6GcBjHBa5n8sDb0u9SWDajOeyX/iNL8xGAVX/B/7nyWyMWW
         s8TgSlqgf8rJ0Rir9eALJ+l71X29e9GBT8I67dfJJReed5IBBwfiCy85BOmD1/lq47+w
         AKhPTX3olsmbhgi4l/K4T/nDbrb7a0UlD0OKeaL+Tl5Cw1z9VP5l4nRiwdh6M7jv3/uM
         Vh5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZKyvo8245xL/BxF/Gv/+cUrFV68zLsFhX14RcWrEpQs=;
        b=guFugJF+KdiPJjuMqwURvME8L/qCKjNvRPT/jz5g2QDOwS3OrA4oxRBUMetnWwEuKm
         /3HqcTwLu8zkwTIVFGOaZaTAx42IAfRN2vNsuhroWBUmSpYbkZFP6fVchrSMB3nR6oYO
         TH0u+DRr66z/S9k99CKd5RNrppq8etiAYVpaTmq67j4V9EGj7Kx6yY2csOvScvB/cioO
         /czQP7PQPhh4jR8zsVMG9kycxauaRsJUXfKXyqBus/pEVEA4WoVNN2hqeNz+irq3sHu1
         G+hKTwo4Og8XMLeIcS07ALuvUoiShgvsloipE6a2G0prhAj3Tmcj/EhjtVKRQcxsPh35
         /oMw==
X-Gm-Message-State: APjAAAUXQJTVje8viXq9tYYTh8qk386OdWcb+rqf8tsc4//l7Cr+YddM
        t3wvHL544EzkeaNgsD+QySw=
X-Google-Smtp-Source: APXvYqwMmLbxCRfmUe87uuT1fta7IUTr76LLekN3tqTAJFlZr5pPavWE3y+FVf+wTnndcv5aPBEcZg==
X-Received: by 2002:a0c:d610:: with SMTP id c16mr17457004qvj.229.1571541614279;
        Sat, 19 Oct 2019 20:20:14 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id m188sm1192280qkf.35.2019.10.19.20.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:13 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 05/16] net: dsa: use ports list to setup switches
Date:   Sat, 19 Oct 2019 23:19:30 -0400
Message-Id: <20191020031941.3805884-6-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ports list instead of iterating over switches and their
ports when setting up the switches and their ports.

At the same time, provide setup states and messages for ports and
switches as it is done for the trees.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h |   4 ++
 net/dsa/dsa2.c    | 101 ++++++++++++++++++++++------------------------
 2 files changed, 53 insertions(+), 52 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 938de9518c61..b199a8ca6393 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -215,9 +215,13 @@ struct dsa_port {
 	 * Original copy of the master netdev net_device_ops
 	 */
 	const struct net_device_ops *orig_ndo_ops;
+
+	bool setup;
 };
 
 struct dsa_switch {
+	bool setup;
+
 	struct device *dev;
 
 	/*
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b6536641ac99..fd2b7f157f97 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -267,6 +267,9 @@ static int dsa_port_setup(struct dsa_port *dp)
 	bool dsa_port_enabled = false;
 	int err = 0;
 
+	if (dp->setup)
+		return 0;
+
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		dsa_port_disable(dp);
@@ -335,14 +338,23 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_link_unregister_of(dp);
 	if (err && devlink_port_registered)
 		devlink_port_unregister(dlp);
+	if (err)
+		return err;
 
-	return err;
+	dp->setup = true;
+
+	pr_info("DSA: switch %d port %d setup\n", dp->ds->index, dp->index);
+
+	return 0;
 }
 
 static void dsa_port_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
 
+	if (!dp->setup)
+		return;
+
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		break;
@@ -365,11 +377,18 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		}
 		break;
 	}
+
+	dp->setup = false;
+
+	pr_info("DSA: switch %d port %d torn down\n", dp->ds->index, dp->index);
 }
 
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
-	int err = 0;
+	int err;
+
+	if (ds->setup)
+		return 0;
 
 	/* Initialize ds->phys_mii_mask before registering the slave MDIO bus
 	 * driver and before ops->setup() has run, since the switch drivers and
@@ -411,6 +430,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 			goto unregister_notifier;
 	}
 
+	ds->setup = true;
+
+	pr_info("DSA: switch %d setup\n", ds->index);
+
 	return 0;
 
 unregister_notifier:
@@ -426,6 +449,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 static void dsa_switch_teardown(struct dsa_switch *ds)
 {
+	if (!ds->setup)
+		return;
+
 	if (ds->slave_mii_bus && ds->ops->phy_read)
 		mdiobus_unregister(ds->slave_mii_bus);
 
@@ -440,78 +466,49 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 		ds->devlink = NULL;
 	}
 
+	ds->setup = false;
+
+	pr_info("DSA: switch %d torn down\n", ds->index);
 }
 
 static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 {
-	struct dsa_switch *ds;
 	struct dsa_port *dp;
-	int device, port, i;
-	int err = 0;
-
-	for (device = 0; device < DSA_MAX_SWITCHES; device++) {
-		ds = dst->ds[device];
-		if (!ds)
-			continue;
+	int err;
 
-		err = dsa_switch_setup(ds);
+	list_for_each_entry(dp, &dst->ports, list) {
+		err = dsa_switch_setup(dp->ds);
 		if (err)
-			goto switch_teardown;
-
-		for (port = 0; port < ds->num_ports; port++) {
-			dp = &ds->ports[port];
+			goto teardown;
+	}
 
-			err = dsa_port_setup(dp);
-			if (err)
-				goto ports_teardown;
-		}
+	list_for_each_entry(dp, &dst->ports, list) {
+		err = dsa_port_setup(dp);
+		if (err)
+			goto teardown;
 	}
 
 	return 0;
 
-ports_teardown:
-	for (i = 0; i < port; i++)
-		dsa_port_teardown(&ds->ports[i]);
-
-	dsa_switch_teardown(ds);
-
-switch_teardown:
-	for (i = 0; i < device; i++) {
-		ds = dst->ds[i];
-		if (!ds)
-			continue;
-
-		for (port = 0; port < ds->num_ports; port++) {
-			dp = &ds->ports[port];
-
-			dsa_port_teardown(dp);
-		}
+teardown:
+	list_for_each_entry(dp, &dst->ports, list)
+		dsa_port_teardown(dp);
 
-		dsa_switch_teardown(ds);
-	}
+	list_for_each_entry(dp, &dst->ports, list)
+		dsa_switch_teardown(dp->ds);
 
 	return err;
 }
 
 static void dsa_tree_teardown_switches(struct dsa_switch_tree *dst)
 {
-	struct dsa_switch *ds;
 	struct dsa_port *dp;
-	int device, port;
-
-	for (device = 0; device < DSA_MAX_SWITCHES; device++) {
-		ds = dst->ds[device];
-		if (!ds)
-			continue;
 
-		for (port = 0; port < ds->num_ports; port++) {
-			dp = &ds->ports[port];
+	list_for_each_entry(dp, &dst->ports, list)
+		dsa_port_teardown(dp);
 
-			dsa_port_teardown(dp);
-		}
-
-		dsa_switch_teardown(ds);
-	}
+	list_for_each_entry(dp, &dst->ports, list)
+		dsa_switch_teardown(dp->ds);
 }
 
 static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
-- 
2.23.0

