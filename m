Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FD75EEEFA
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiI2H3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiI2H3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:29:11 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2311E1332EF
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:10 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h7so730922wru.10
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=naU6xDp+k/uBSUb3rG1BgZrheDdyIA3UTwQr7kseNxs=;
        b=0OoHbXzU3q10GKdQ19Wj6wlLIf8SMTTeynSFYRFxhj7DjnEmUU33d5+L71GZZdoYfK
         cdtY46/9+Zs1fIntsm9OeGAv+cGleBUWUXSr16yiAEikrSMEOesyL1vqCcDGgFniqHVP
         HHSuZg0L0CFWF+w/Q+OgTrPRPWCvU5Xu5e3ae9U6idOW/Ex4gHyOIUdbdOqUXgJwgXr5
         bs2Uo7QQ6LDZqLiwbBSNRo7eRGvuyv64SLPTyxZ2I0W92iWKTA9qZkr7/CPXq4dBes0i
         R8oIBWCl06vH4IPDKIaIvIWHH5q/9R79zGI8TmDFxFlYCKdsyDI2RbpPUiGyEIYt5eLj
         uycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=naU6xDp+k/uBSUb3rG1BgZrheDdyIA3UTwQr7kseNxs=;
        b=JnCDDxD/5yITbzvmA56HxU9GnDy/Zp0yG5dvL3oCx1zt5DI1QilUuRCExiysPFMa5K
         YnNu3vjoqink31lyfvrVZFDxV2G0uUy5boysrGMyLAaLImXPGz0Y17BwtKQTv2BZ46ht
         gTzjTj+nZJgm6zvT6O5/KbNAIV9E6RWHD5cJfuTjQzkZdESOEHKnXKABKPSJaQKJy+h6
         3V3oactgr1pJiJ7RUSXjQhaIc/kquOG/78cLez7hWOzm8tv9jTLNhTipwXKWpeitV3Gp
         fmxpJO1oc8o9VDCzeGaXZsZysBrs09VIh2Q6wEigoroS7zzvoS+EU3dk3eLP+cjQHPqT
         5PdA==
X-Gm-Message-State: ACrzQf0PSfBrpZY6Dh1MJu61e8Zlx1gbJ4qJO48q0bmcVLKhD15qzXGB
        9hKUV81pOL06PBBLXzSEh/IpuzaWWDIIuDqY
X-Google-Smtp-Source: AMsMyM74r/GDY9Sahy+gUSybhpsZkROYcWWWbH2T4O8v5kFOalGjzJQdKvoLF66+vCJUfo0zhenkIA==
X-Received: by 2002:a5d:5a14:0:b0:22a:25be:7f69 with SMTP id bq20-20020a5d5a14000000b0022a25be7f69mr1083426wrb.662.1664436548650;
        Thu, 29 Sep 2022 00:29:08 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w1-20020a5d5441000000b0022cc0a2cbecsm5593366wrv.15.2022.09.29.00.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:29:08 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v3 3/7] net: devlink: add port_init/fini() helpers to allow pre-register/post-unregister functions
Date:   Thu, 29 Sep 2022 09:28:58 +0200
Message-Id: <20220929072902.2986539-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929072902.2986539-1-jiri@resnulli.us>
References: <20220929072902.2986539-1-jiri@resnulli.us>
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

Lifetime of some of the devlink objects, like regions, is currently
forced to be different for devlink instance and devlink port instance
(per-port regions). The reason is that for devlink ports, the internal
structures initialization happens only after devlink_port_register() is
called.

To resolve this inconsistency, introduce new set of helpers to allow
driver to initialize devlink pointer and region list before
devlink_register() is called. That allows port regions to be created
before devlink port registration and destroyed after devlink
port unregistration.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
- fixed the patch description
---
 include/net/devlink.h |  6 +++++-
 net/core/devlink.c    | 46 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index bcacd8dab297..ba6b8b094943 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -130,7 +130,8 @@ struct devlink_port {
 	struct devlink_port_attrs attrs;
 	u8 attrs_set:1,
 	   switch_port:1,
-	   registered:1;
+	   registered:1,
+	   initialized:1;
 	struct delayed_work type_warn_dw;
 	struct list_head reporter_list;
 	struct mutex reporters_lock; /* Protects reporter_list */
@@ -1563,6 +1564,9 @@ void devlink_set_features(struct devlink *devlink, u64 features);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
+void devlink_port_init(struct devlink *devlink,
+		       struct devlink_port *devlink_port);
+void devlink_port_fini(struct devlink_port *devlink_port);
 int devl_port_register(struct devlink *devlink,
 		       struct devlink_port *devlink_port,
 		       unsigned int port_index);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 17529e6b2bbf..89baa7c0938b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -375,6 +375,8 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 	WARN_ON_ONCE(!(devlink_port)->registered)
 #define ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port)			\
 	WARN_ON_ONCE((devlink_port)->registered)
+#define ASSERT_DEVLINK_PORT_INITIALIZED(devlink_port)				\
+	WARN_ON_ONCE(!(devlink_port)->initialized)
 
 static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 						      unsigned int port_index)
@@ -9852,6 +9854,44 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
 	cancel_delayed_work_sync(&devlink_port->type_warn_dw);
 }
 
+/**
+ * devlink_port_init() - Init devlink port
+ *
+ * @devlink: devlink
+ * @devlink_port: devlink port
+ *
+ * Initialize essencial stuff that is needed for functions
+ * that may be called before devlink port registration.
+ * Call to this function is optional and not needed
+ * in case the driver does not use such functions.
+ */
+void devlink_port_init(struct devlink *devlink,
+		       struct devlink_port *devlink_port)
+{
+	if (devlink_port->initialized)
+		return;
+	devlink_port->devlink = devlink;
+	INIT_LIST_HEAD(&devlink_port->region_list);
+	devlink_port->initialized = true;
+}
+EXPORT_SYMBOL_GPL(devlink_port_init);
+
+/**
+ * devlink_port_fini() - Deinitialize devlink port
+ *
+ * @devlink_port: devlink port
+ *
+ * Deinitialize essencial stuff that is in use for functions
+ * that may be called after devlink port unregistration.
+ * Call to this function is optional and not needed
+ * in case the driver does not use such functions.
+ */
+void devlink_port_fini(struct devlink_port *devlink_port)
+{
+	WARN_ON(!list_empty(&devlink_port->region_list));
+}
+EXPORT_SYMBOL_GPL(devlink_port_fini);
+
 /**
  * devl_port_register() - Register devlink port
  *
@@ -9876,14 +9916,13 @@ int devl_port_register(struct devlink *devlink,
 
 	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
 
+	devlink_port_init(devlink, devlink_port);
 	devlink_port->registered = true;
-	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
 	mutex_init(&devlink_port->reporters_lock);
 	list_add_tail(&devlink_port->list, &devlink->port_list);
-	INIT_LIST_HEAD(&devlink_port->region_list);
 
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
@@ -9933,7 +9972,6 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	list_del(&devlink_port->list);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
-	WARN_ON(!list_empty(&devlink_port->region_list));
 	mutex_destroy(&devlink_port->reporters_lock);
 	devlink_port->registered = false;
 }
@@ -11347,6 +11385,8 @@ devlink_port_region_create(struct devlink_port *port,
 	struct devlink_region *region;
 	int err = 0;
 
+	ASSERT_DEVLINK_PORT_INITIALIZED(port);
+
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-- 
2.37.1

