Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924365A0DF7
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241025AbiHYKeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240917AbiHYKeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:34:20 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2E1A3D0A
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:14 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id s23so10043898wmj.4
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=dVQVHFix4pVjdA5WT6dRzaINYMtb7RgRlTsdHBGHExk=;
        b=xlVluPE1DqGzH5NPstKXthUaK25zBUq9SQriBXip2i7OM6zMQEWPz3hXj530hLpL3P
         5HrkeUWj03I7T82Q1Ml2jqZEvRb0ZhjKZgQBiCjLA1noJY/eaVIW9ibWoys0Bx3Dzpgn
         Aa5YlHVdRFP2E2opabiVB/ROABGQ26upbl7rcvXOuZDMfjVyAxA/npK+QRSgIY0iHsGf
         h95DrIx0nnulwy7hBZBKu0sK5cT2xTy/FoWKe8aaTui7+6T0kKpvfqV2MNDIskaEszwB
         IPLK9kAgduGCafZo1WTSGnk/tCYWl3PoA3OBZOSwtgXZdLhhdp2GmhrjiNlvGzH1v1qd
         e9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=dVQVHFix4pVjdA5WT6dRzaINYMtb7RgRlTsdHBGHExk=;
        b=JIUog0hbSYRMw+2lFeAXD9wiwaymt4Z/ufmrjeNqfRjqz8zBfxOoBcgMXw7DC9l/tK
         R5xTX6uGSNnzQVWpKsokUxrO31VooNqUoHf1qD4AyPC6SLMI/t+PFPbptke9Mn1mVnZT
         ZU0uq1d94xjm1sx3z84zek+7NkQMsf7XHziU2dXhA9wMvlYCKZks8Swtg80wVRSasaov
         JAZ0Z+XjnQfuax4qwh3JLZfnQ9mzK7yoVCzJt6XXwZjnvI33V/+JmacpZC0ybEHp+jSt
         3Rb86PVKSVqz6qhbC4wfQ9ANSS7/+Zq+gSpAz5KnTmbnpsf7pS3TIgKdpDT2QdFm7TFu
         pOqQ==
X-Gm-Message-State: ACgBeo1C7RqBDPGHqViBh6xyU5IEfYrY+GwsbZdfgbjfaXKxfDA+nVY8
        DRFdRLm58lRvFnkCKXsE9qEWcod79yjMCc4l
X-Google-Smtp-Source: AA6agR4WhNmqL4Psoyj8cb8eQwMxK+0i3iFK7Fl5ZsML2ey7Nf6Y8Qr3at3ky6GLYwGVzUk7pVgP7A==
X-Received: by 2002:a05:600c:198e:b0:3a5:d4a2:8896 with SMTP id t14-20020a05600c198e00b003a5d4a28896mr7509531wmq.140.1661423652823;
        Thu, 25 Aug 2022 03:34:12 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x11-20020a05600c2d0b00b003a5f3f5883dsm4380005wmf.17.2022.08.25.03.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:34:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next 5/7] net: dsa: move port_setup/teardown to be called outside devlink port registered area
Date:   Thu, 25 Aug 2022 12:33:58 +0200
Message-Id: <20220825103400.1356995-6-jiri@resnulli.us>
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

Move port_setup() op to be called before devlink_port_register() and
port_teardown() after devlink_port_unregister().

Note it makes sense to move this alongside the rest of the devlink port
code, the reinit() function also gets much nicer, as clearly the fact that
port_setup()->devlink_port_region_create() was called in dsa_port_setup
did not fit the flow.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/dsa/dsa2.c | 68 +++++++++++++++++++-------------------------------
 1 file changed, 26 insertions(+), 42 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ed56c7a554b8..644aecbe79a0 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -458,12 +458,6 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (dp->setup)
 		return 0;
 
-	if (ds->ops->port_setup) {
-		err = ds->ops->port_setup(ds, dp->index);
-		if (err)
-			return err;
-	}
-
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		dsa_port_disable(dp);
@@ -518,11 +512,8 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
 		dsa_shared_port_link_unregister_of(dp);
-	if (err) {
-		if (ds->ops->port_teardown)
-			ds->ops->port_teardown(ds, dp->index);
+	if (err)
 		return err;
-	}
 
 	dp->setup = true;
 
@@ -535,17 +526,26 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 	struct dsa_switch_tree *dst = dp->ds->dst;
 	struct devlink_port_attrs attrs = {};
 	struct devlink *dl = dp->ds->devlink;
+	struct dsa_switch *ds = dp->ds;
 	const unsigned char *id;
 	unsigned char len;
 	int err;
 
+	memset(dlp, 0, sizeof(*dlp));
+	devlink_port_init(dl, dlp);
+
+	if (ds->ops->port_setup) {
+		err = ds->ops->port_setup(ds, dp->index);
+		if (err)
+			return err;
+	}
+
 	id = (const unsigned char *)&dst->index;
 	len = sizeof(dst->index);
 
 	attrs.phys.port_number = dp->index;
 	memcpy(attrs.switch_id.id, id, len);
 	attrs.switch_id.id_len = len;
-	memset(dlp, 0, sizeof(*dlp));
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
@@ -564,24 +564,23 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 
 	devlink_port_attrs_set(dlp, &attrs);
 	err = devlink_port_register(dl, dlp, dp->index);
+	if (err) {
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
+		return err;
+	}
+	dp->devlink_port_setup = true;
 
-	if (!err)
-		dp->devlink_port_setup = true;
-
-	return err;
+	return 0;
 }
 
 static void dsa_port_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
-	struct dsa_switch *ds = dp->ds;
 
 	if (!dp->setup)
 		return;
 
-	if (ds->ops->port_teardown)
-		ds->ops->port_teardown(ds, dp->index);
-
 	devlink_port_type_clear(dlp);
 
 	switch (dp->type) {
@@ -611,40 +610,25 @@ static void dsa_port_teardown(struct dsa_port *dp)
 static void dsa_port_devlink_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_switch *ds = dp->ds;
 
-	if (dp->devlink_port_setup)
+	if (dp->devlink_port_setup) {
 		devlink_port_unregister(dlp);
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
+		devlink_port_fini(dlp);
+	}
 	dp->devlink_port_setup = false;
 }
 
 /* Destroy the current devlink port, and create a new one which has the UNUSED
- * flavour. At this point, any call to ds->ops->port_setup has been already
- * balanced out by a call to ds->ops->port_teardown, so we know that any
- * devlink port regions the driver had are now unregistered. We then call its
- * ds->ops->port_setup again, in order for the driver to re-create them on the
- * new devlink port.
+ * flavour.
  */
 static int dsa_port_reinit_as_unused(struct dsa_port *dp)
 {
-	struct dsa_switch *ds = dp->ds;
-	int err;
-
 	dsa_port_devlink_teardown(dp);
 	dp->type = DSA_PORT_TYPE_UNUSED;
-	err = dsa_port_devlink_setup(dp);
-	if (err)
-		return err;
-
-	if (ds->ops->port_setup) {
-		/* On error, leave the devlink port registered,
-		 * dsa_switch_teardown will clean it up later.
-		 */
-		err = ds->ops->port_setup(ds, dp->index);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return dsa_port_devlink_setup(dp);
 }
 
 static int dsa_devlink_info_get(struct devlink *dl,
-- 
2.37.1

