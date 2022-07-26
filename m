Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E853A581340
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 14:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbiGZMlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 08:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238516AbiGZMlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 08:41:12 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF74DFC4
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 05:41:08 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id fy29so25813326ejc.12
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 05:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XJv+b+9T+82Xz8sZYU8vRW+BzA0fxoNw4nBNvukCJ2Y=;
        b=0eVTBAL/qR1H7kgpu32sZNtvzsD5/UZAA/OOuh8tRfVj3YW2FOig3Ju3QQuT2OBOBn
         +vJKhiyv9wsDb48oyb7zOYiCHUtvebzKOb4AbgL16ibhCKL78NA9IMOPUCk8BdPc6YtP
         3ywwWZpq78543lI1/s4obEtlvFffL1tqa0Ws5b3kUbOl+/k7wJfV6S9oPSJfFNFc3NjZ
         u0QInNZHOL57JuRAVUF7kN7Ns0ihtZRy8TRLzdl7yJHRX1/oag39DU78eCWBSfEEEHXZ
         +JmaY4k4F+4nebvEXBqxE54hZFS/ZJ+oXizdu1cGSnRYLkSZ3tDJ9pNcHCIGJVrTLhaq
         45eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XJv+b+9T+82Xz8sZYU8vRW+BzA0fxoNw4nBNvukCJ2Y=;
        b=uCnFcoCyUGT9xEi0yr51O8xIrUdC060h1/IantO6Jfp7s/64Ye38MAWXc9sU9FpgaO
         ERdxmVxtmPOshDAeSe/DQjs7ukcEu0vGJt3taW/ap5+oQK2qKAvwEi1dI+mFo3yWYssb
         1y+5pbWWGsOrwDET3B+2B0rohsFwtE9nBRRHDxoZ8BTwOoG81RSJN9c11B+wNhTXwyyZ
         Qjwknjcu2U1D/cIrNKAWH8JHn5/pkNlKujgGs8VtaDWgsbaukVEoY/rPYENfNEbH9gi9
         oCYvuBmX2Q+ZuJKnMPZa0HJxWDrycN1PepxGWO83vuwutl0yFFPq9v0C3PAq9RGehYPv
         0A6g==
X-Gm-Message-State: AJIora8v+VXLVlLpxHGfwVCt5NQoTHWXatyPivtEmfjmNTca3nRh0lfQ
        ZQu0V5hiSOp+bSaTo46lci8fqGUqifSu3jpdAq0=
X-Google-Smtp-Source: AGRyM1v8U31tmxwfwhJoAgeBUKyT98B9ajLdbYcIN+Ic6SAcMEyzBh/Vth4137CkniRBcNh7ZsBTyA==
X-Received: by 2002:a17:907:3fa0:b0:72f:aefd:621e with SMTP id hr32-20020a1709073fa000b0072faefd621emr14234651ejc.475.1658839267321;
        Tue, 26 Jul 2022 05:41:07 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b20-20020a170906195400b0072aa38d768esm6469403eje.64.2022.07.26.05.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 05:41:06 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: [patch net-next RFC] net: dsa: move port_setup/teardown to be called outside devlink port registered area
Date:   Tue, 26 Jul 2022 14:41:05 +0200
Message-Id: <20220726124105.495652-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Move port_setup() op to be called before devlink_port_register() and
port_teardown() after devlink_port_unregister().

RFC note: I don't see why this would not work, but I have no way to
test this does not break things. But I think it makes sense to move this
alongside the rest of the devlink port code, the reinit() function
also gets much nicer, as clearly the fact that
port_setup()->devlink_port_region_create() was called in dsa_port_setup
did not fit the flow.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/dsa/dsa2.c | 64 +++++++++++++++++---------------------------------
 1 file changed, 21 insertions(+), 43 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cac48a741f27..a8b6c6434df2 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -451,19 +451,12 @@ static int dsa_port_setup(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
 	bool dsa_port_link_registered = false;
-	struct dsa_switch *ds = dp->ds;
 	bool dsa_port_enabled = false;
 	int err = 0;
 
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
@@ -506,11 +499,6 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
 		dsa_port_link_unregister_of(dp);
-	if (err) {
-		if (ds->ops->port_teardown)
-			ds->ops->port_teardown(ds, dp->index);
-		return err;
-	}
 
 	dp->setup = true;
 
@@ -523,10 +511,17 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 	struct dsa_switch_tree *dst = dp->ds->dst;
 	struct devlink_port_attrs attrs = {};
 	struct devlink *dl = dp->ds->devlink;
+	struct dsa_switch *ds = dp->ds;
 	const unsigned char *id;
 	unsigned char len;
 	int err;
 
+	if (ds->ops->port_setup) {
+		err = ds->ops->port_setup(ds, dp->index);
+		if (err)
+			return err;
+	}
+
 	id = (const unsigned char *)&dst->index;
 	len = sizeof(dst->index);
 
@@ -552,24 +547,23 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 
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
@@ -597,40 +591,24 @@ static void dsa_port_teardown(struct dsa_port *dp)
 static void dsa_port_devlink_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_switch *ds = dp->ds;
 
-	if (dp->devlink_port_setup)
+	if (dp->devlink_port_setup) {
 		devlink_port_unregister(dlp);
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
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
2.35.3

