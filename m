Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79C31DF722
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbfJUUvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:51:47 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43107 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730428AbfJUUvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:45 -0400
Received: by mail-qk1-f196.google.com with SMTP id a194so10061159qkg.10;
        Mon, 21 Oct 2019 13:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ooDb6G0PiKdNv/6wP/o2ydYbNujWPTh8k/LkgxW3Dw=;
        b=s1BvvFUBux9ZJkwWTDt6eF11xyxAqidCgpTcKWbbJpPBmv1IiVTNc1W+pHKN6DgJUL
         FylpKYVCUs3gD4ybqtNuX6cyKx8/bMU1KVdzbVN1sSIE1ko5q5ZEh6oZ7CCjwZumohX/
         dpba02pv7Sleu3yfG0TI8ttLmANv+St0T0u8kNn76dMau4FYPqdtDGm25w8kpgJIYFuI
         ReKQ8oGr/CLMqd+VqqXYKgbQetmEt+IwFGY6x2vS0GXsgV/Dj27BsIQo2tHLuy8VAY66
         4xwwZj1rqU6LOxng62CC4qoPWIJ2CHOeWiJX6qFSbF+icFkAOgxmR+lcZMx+uduhN8b5
         0eCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ooDb6G0PiKdNv/6wP/o2ydYbNujWPTh8k/LkgxW3Dw=;
        b=El4bSdNAjTrLupleR9Moo9wNtKIO/w5y/TWvRfJ0Eeji8UQbTJVGIbnvNrQDwJQV0A
         5JltMhH0jNmB91xmEsVqS4g9oaowN/is7ho3G5m8ObgvacqZCuV2Ceu3a2Rl1scJgWQr
         kwr4C1bbFDhcmRsYuls5sREsXq6di2z/Jjc+x2N82Z5891jZRIWWPgn6JMDuFxBsGqov
         jRaQVFXjna1hc47VPSajB3cAThUNfrnfkDj7AdvqMbmguDpWIybWUw7aslrbzblkM7Dn
         xLSeR1XXW0zlG6/9s20/QLzlSZACLkzIh7iJCNXn/VJCMwfZjsvCd9i4MiGSz7HwJWXN
         ITew==
X-Gm-Message-State: APjAAAU1bDpdBsN4ESlT2VmrYIC7qh8tmYRAvs+cTIj+PFvNO0rMbL00
        ixf1sJ0y0EhY1zJeMzYuat7CAs3K
X-Google-Smtp-Source: APXvYqw0OFKDqIzB/gi63Vt/lpmTWDoVFtPh+yHNGgvCSZqVQxli8l8dkP/2EzHwVYN3/xuKrdfljA==
X-Received: by 2002:a37:4a0c:: with SMTP id x12mr15028702qka.19.1571691103785;
        Mon, 21 Oct 2019 13:51:43 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c23sm11153140qte.66.2019.10.21.13.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:43 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 05/16] net: dsa: use ports list to setup switches
Date:   Mon, 21 Oct 2019 16:51:19 -0400
Message-Id: <20191021205130.304149-6-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
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
 include/net/dsa.h |  4 ++
 net/dsa/dsa2.c    | 93 +++++++++++++++++++++--------------------------
 2 files changed, 45 insertions(+), 52 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d2b7ee28f3fd..bd08bdee8341 100644
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
index ba27ff8b4445..01b6047d9b7b 100644
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
@@ -335,14 +338,21 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_link_unregister_of(dp);
 	if (err && devlink_port_registered)
 		devlink_port_unregister(dlp);
+	if (err)
+		return err;
 
-	return err;
+	dp->setup = true;
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
@@ -365,11 +375,16 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		}
 		break;
 	}
+
+	dp->setup = false;
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
@@ -411,6 +426,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 			goto unregister_notifier;
 	}
 
+	ds->setup = true;
+
 	return 0;
 
 unregister_notifier:
@@ -426,6 +443,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 static void dsa_switch_teardown(struct dsa_switch *ds)
 {
+	if (!ds->setup)
+		return;
+
 	if (ds->slave_mii_bus && ds->ops->phy_read)
 		mdiobus_unregister(ds->slave_mii_bus);
 
@@ -440,78 +460,47 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 		ds->devlink = NULL;
 	}
 
+	ds->setup = false;
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
 
-	for (device = 0; device < DSA_MAX_SWITCHES; device++) {
-		ds = dst->ds[device];
-		if (!ds)
-			continue;
+	list_for_each_entry(dp, &dst->ports, list)
+		dsa_port_teardown(dp);
 
-		for (port = 0; port < ds->num_ports; port++) {
-			dp = &ds->ports[port];
-
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

