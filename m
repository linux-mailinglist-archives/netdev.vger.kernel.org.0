Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53DF5A0DF8
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241046AbiHYKe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240997AbiHYKeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:34:20 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DF8A894E
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:16 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so2271949wmb.4
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=77g2Vx/dCFDAwFCz9/acum/oN/5yDeobm9I7mn1PpYI=;
        b=xGF3y90IYLDPTrrAmoPxZxcsA3GvnKZ9dQyoGGZPj6Cd99TIaDa9W3hKdzauci4eXI
         fNXJm/6IZ9eu80D8s1fBh1t29qwojBFQAO8Ys/Zjm/J6bvp1JUNdff6n5kXwsdcPW6ws
         6vsfnNkncQ1NMFA6WWuTazt8m/a/4MmvJoU6oS0/vZA5xKYig8cQ52au9Oz/M9g8B0Ph
         yp+4pOLEvqn39sYC0SEyMdfCN7fSEQApWrVV9PXKZm4BNZry4ybhypot/kf3htGgWnUJ
         Pz7SCF74PiRbAsG3uFMpmdBshUdtaOiSwZTFd72f5+ad29wYKFx1/5MaEwISI4evQHXk
         1HAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=77g2Vx/dCFDAwFCz9/acum/oN/5yDeobm9I7mn1PpYI=;
        b=GJRYJaw4bUCOTPVjwJgnZx6eS3P8YiIZLEMEdLbHhhA4XUumUIHmW88+1djGI4cpNd
         SBYRtNqUm/wAARTg7qOWFZ2u5ESvF7cBAzuijjl37Si7g//SsjJDLK3PK5lZbw5rJjiB
         YOj0HzxBFIcSiZjhFOy3YU911dwRyEfDqNpjSh9Sa2EPolUz0skMRCF151JOfqLVp7Ma
         t4CWPrw2VTKkSGhaGtFDWiw+WZeavVPdD7syh+qDLhUmYVJdYW0nOjSBOkQ84ZaKTmDo
         4gP5pURh+tGHELCYGgwmKszbU/TmtCsndU5wCGWkGtec8LNZTmQgCeE4KEcyFZtrQmnG
         l31w==
X-Gm-Message-State: ACgBeo1eZ5UYOAgSP+T2bl5UC/7J3aaWcGqwulBEidUbk1CMkidgKn0E
        oXzEU/8UOmfVVLj2C8vs2Jee5SS+amzLJBws
X-Google-Smtp-Source: AA6agR6BqWDE3yIPbgB3nfa0i5RA1xgNaZ6/c1YLQROuqVdGpgmmAwNSVgvtgEf3ak0EoWMrDL2YMQ==
X-Received: by 2002:a1c:4c18:0:b0:3a6:9e0:7c2a with SMTP id z24-20020a1c4c18000000b003a609e07c2amr8050298wmf.42.1661423655055;
        Thu, 25 Aug 2022 03:34:15 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p7-20020a5d48c7000000b00223a50b1be8sm19234017wrs.50.2022.08.25.03.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:34:14 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next 6/7] net: dsa: don't do devlink port setup early
Date:   Thu, 25 Aug 2022 12:33:59 +0200
Message-Id: <20220825103400.1356995-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220825103400.1356995-1-jiri@resnulli.us>
References: <20220825103400.1356995-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Commit 3122433eb533 ("net: dsa: Register devlink ports before calling DSA driver setup()")
moved devlink port setup to be done early before driver setup()
was called. That is no longer needed, so move the devlink port
initialization back to dsa_port_setup(), as the first thing done there.

Note there is no longer needed to reinit port as unused if
dsa_port_setup() fails, as it unregisters the devlink port instance on
the error path.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/dsa/dsa2.c | 183 ++++++++++++++++++++++---------------------------
 1 file changed, 81 insertions(+), 102 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 644aecbe79a0..b53bc1a1aa83 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -447,6 +447,74 @@ static void dsa_tree_teardown_cpu_ports(struct dsa_switch_tree *dst)
 			dp->cpu_dp = NULL;
 }
 
+static int dsa_port_devlink_setup(struct dsa_port *dp)
+{
+	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_switch_tree *dst = dp->ds->dst;
+	struct devlink_port_attrs attrs = {};
+	struct devlink *dl = dp->ds->devlink;
+	struct dsa_switch *ds = dp->ds;
+	const unsigned char *id;
+	unsigned char len;
+	int err;
+
+	memset(dlp, 0, sizeof(*dlp));
+	devlink_port_init(dl, dlp);
+
+	if (ds->ops->port_setup) {
+		err = ds->ops->port_setup(ds, dp->index);
+		if (err)
+			return err;
+	}
+
+	id = (const unsigned char *)&dst->index;
+	len = sizeof(dst->index);
+
+	attrs.phys.port_number = dp->index;
+	memcpy(attrs.switch_id.id, id, len);
+	attrs.switch_id.id_len = len;
+
+	switch (dp->type) {
+	case DSA_PORT_TYPE_UNUSED:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
+		break;
+	case DSA_PORT_TYPE_CPU:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_CPU;
+		break;
+	case DSA_PORT_TYPE_DSA:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_DSA;
+		break;
+	case DSA_PORT_TYPE_USER:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		break;
+	}
+
+	devlink_port_attrs_set(dlp, &attrs);
+	err = devlink_port_register(dl, dlp, dp->index);
+	if (err) {
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
+		return err;
+	}
+	dp->devlink_port_setup = true;
+
+	return 0;
+}
+
+static void dsa_port_devlink_teardown(struct dsa_port *dp)
+{
+	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_switch *ds = dp->ds;
+
+	if (dp->devlink_port_setup) {
+		devlink_port_unregister(dlp);
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
+		devlink_port_fini(dlp);
+	}
+	dp->devlink_port_setup = false;
+}
+
 static int dsa_port_setup(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
@@ -458,6 +526,10 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (dp->setup)
 		return 0;
 
+	err = dsa_port_devlink_setup(dp);
+	if (err)
+		return err;
+
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		dsa_port_disable(dp);
@@ -512,64 +584,12 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
 		dsa_shared_port_link_unregister_of(dp);
-	if (err)
-		return err;
-
-	dp->setup = true;
-
-	return 0;
-}
-
-static int dsa_port_devlink_setup(struct dsa_port *dp)
-{
-	struct devlink_port *dlp = &dp->devlink_port;
-	struct dsa_switch_tree *dst = dp->ds->dst;
-	struct devlink_port_attrs attrs = {};
-	struct devlink *dl = dp->ds->devlink;
-	struct dsa_switch *ds = dp->ds;
-	const unsigned char *id;
-	unsigned char len;
-	int err;
-
-	memset(dlp, 0, sizeof(*dlp));
-	devlink_port_init(dl, dlp);
-
-	if (ds->ops->port_setup) {
-		err = ds->ops->port_setup(ds, dp->index);
-		if (err)
-			return err;
-	}
-
-	id = (const unsigned char *)&dst->index;
-	len = sizeof(dst->index);
-
-	attrs.phys.port_number = dp->index;
-	memcpy(attrs.switch_id.id, id, len);
-	attrs.switch_id.id_len = len;
-
-	switch (dp->type) {
-	case DSA_PORT_TYPE_UNUSED:
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
-		break;
-	case DSA_PORT_TYPE_CPU:
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_CPU;
-		break;
-	case DSA_PORT_TYPE_DSA:
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_DSA;
-		break;
-	case DSA_PORT_TYPE_USER:
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-		break;
-	}
-
-	devlink_port_attrs_set(dlp, &attrs);
-	err = devlink_port_register(dl, dlp, dp->index);
 	if (err) {
-		if (ds->ops->port_teardown)
-			ds->ops->port_teardown(ds, dp->index);
+		dsa_port_devlink_teardown(dp);
 		return err;
 	}
-	dp->devlink_port_setup = true;
+
+	dp->setup = true;
 
 	return 0;
 }
@@ -604,31 +624,9 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		break;
 	}
 
-	dp->setup = false;
-}
-
-static void dsa_port_devlink_teardown(struct dsa_port *dp)
-{
-	struct devlink_port *dlp = &dp->devlink_port;
-	struct dsa_switch *ds = dp->ds;
-
-	if (dp->devlink_port_setup) {
-		devlink_port_unregister(dlp);
-		if (ds->ops->port_teardown)
-			ds->ops->port_teardown(ds, dp->index);
-		devlink_port_fini(dlp);
-	}
-	dp->devlink_port_setup = false;
-}
-
-/* Destroy the current devlink port, and create a new one which has the UNUSED
- * flavour.
- */
-static int dsa_port_reinit_as_unused(struct dsa_port *dp)
-{
 	dsa_port_devlink_teardown(dp);
-	dp->type = DSA_PORT_TYPE_UNUSED;
-	return dsa_port_devlink_setup(dp);
+
+	dp->setup = false;
 }
 
 static int dsa_devlink_info_get(struct devlink *dl,
@@ -852,7 +850,6 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
 	struct device_node *dn;
-	struct dsa_port *dp;
 	int err;
 
 	if (ds->setup)
@@ -875,18 +872,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	dl_priv = devlink_priv(ds->devlink);
 	dl_priv->ds = ds;
 
-	/* Setup devlink port instances now, so that the switch
-	 * setup() can register regions etc, against the ports
-	 */
-	dsa_switch_for_each_port(dp, ds) {
-		err = dsa_port_devlink_setup(dp);
-		if (err)
-			goto unregister_devlink_ports;
-	}
-
 	err = dsa_switch_register_notifier(ds);
 	if (err)
-		goto unregister_devlink_ports;
+		goto devlink_free;
 
 	ds->configure_vlan_while_not_filtering = true;
 
@@ -927,9 +915,7 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 		ds->ops->teardown(ds);
 unregister_notifier:
 	dsa_switch_unregister_notifier(ds);
-unregister_devlink_ports:
-	dsa_switch_for_each_port(dp, ds)
-		dsa_port_devlink_teardown(dp);
+devlink_free:
 	devlink_free(ds->devlink);
 	ds->devlink = NULL;
 	return err;
@@ -937,8 +923,6 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 static void dsa_switch_teardown(struct dsa_switch *ds)
 {
-	struct dsa_port *dp;
-
 	if (!ds->setup)
 		return;
 
@@ -957,8 +941,6 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	dsa_switch_unregister_notifier(ds);
 
 	if (ds->devlink) {
-		dsa_switch_for_each_port(dp, ds)
-			dsa_port_devlink_teardown(dp);
 		devlink_free(ds->devlink);
 		ds->devlink = NULL;
 	}
@@ -1010,11 +992,8 @@ static int dsa_tree_setup_ports(struct dsa_switch_tree *dst)
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_user(dp) || dsa_port_is_unused(dp)) {
 			err = dsa_port_setup(dp);
-			if (err) {
-				err = dsa_port_reinit_as_unused(dp);
-				if (err)
-					goto teardown;
-			}
+			if (err)
+				goto teardown;
 		}
 	}
 
-- 
2.37.1

