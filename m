Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591B556B3D1
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbiGHHuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237146AbiGHHuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:50:44 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B9D7D1F0
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 00:50:42 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id o25so36370978ejm.3
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 00:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TxTG9PU+gMdE/rBJKWk2kGnRCX7IJeRQReWoqeS/qdE=;
        b=6PDx3JPQZQu/edlxfAVbuf0SoVbf253i+G1swEhHlk9UrrAc/ngaBHXVGcuTyMgl+M
         JeeWzw6T7QfB7f4iheeRPfZMbltg+bDeOM8dIcVLYFn7smp5+gcCrXIAb+dJutYFrngY
         W8/aiBoh39nrXv2kJjEFbOhGOZPzrO8Sj8wlE9YwbGGNRmrNe5qHBJ10pSc0sAtKF9ac
         CSoW1roAyj7P52w6JRBj9TafQ2/1+8z341/GmxpTKgPkOCcULFnzs5oNINBxQf6FgBHl
         JZcwBgfkSXsBzuSY3/GW019E2Lpo3uVZ1hyoOwCGkWXhAAnrqEucO0yqAgiz+NIS2tdX
         Oxog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TxTG9PU+gMdE/rBJKWk2kGnRCX7IJeRQReWoqeS/qdE=;
        b=oU6eUaa47IoUJd6JzZb8rwvqz3GZ+qf7Jfx8n9FcHdcI3QahfFZxxBopLqDFiBmejL
         XdvPPc6sMjxDNci7kBiz/h1F0kA6rKXf7GUYs63oMwwaZexURhvjnPxlBENcUM5FYPEM
         PrBZsndOZaLDcIYWG7brCGZUbZkJixVENEWT0qICsV3o/CPeoWO0UwRml6KKWRGxxjj0
         g0KTEbtVJj2maogGr4wSqoyQS/HBN4tk68TZ60u1jTkj/ugV9XR8q/BEItKUW4H988OB
         GbdBbGsDagZfiQpCB3C7Xx7EyxgsajWXbecjw3kimlsmz59hSddOrDpaUGRRIM/xhQF7
         YUlQ==
X-Gm-Message-State: AJIora8yLAqqKze05ERiJgNZUwI2FYOTOWpKbbP9uUCXlLUrFG2GFi17
        xP5bVbmRFoR27UNiHdU6cOuXbXwZGDUgHjyL3Iw=
X-Google-Smtp-Source: AGRyM1snUTtV8vsVgqVInl2FVOY5lzYKakAXUOi0o6wrCUi6tKFHyueFaCzQJa1zQm1Eb/g+CgXerw==
X-Received: by 2002:a17:907:a077:b0:72b:dc1:c88a with SMTP id ia23-20020a170907a07700b0072b0dc1c88amr2211536ejc.130.1657266641024;
        Fri, 08 Jul 2022 00:50:41 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id es25-20020a056402381900b0043a6b86f024sm10158793edb.67.2022.07.08.00.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 00:50:40 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v3 1/3] net: devlink: fix unlocked vs locked functions descriptions
Date:   Fri,  8 Jul 2022 09:50:36 +0200
Message-Id: <20220708075038.2191948-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220708074808.2191479-1-jiri@resnulli.us>
References: <20220708074808.2191479-1-jiri@resnulli.us>
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

To be unified with the rest of the code, the unlocked version (devl_*)
of function should have the same description in documentation as the
locked one. Add the missing documentation. Also, add "Context"
annotation for the locked versions where it is missing.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- s/devlink_/devl_/ for unregister comment
- removed tabs
- added ()s
---
 net/core/devlink.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 25b481dd1709..46cd67b0ed6c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9877,6 +9877,19 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
 	cancel_delayed_work_sync(&devlink_port->type_warn_dw);
 }
 
+/**
+ * devl_port_register() - Register devlink port
+ *
+ * @devlink: devlink
+ * @devlink_port: devlink port
+ * @port_index: driver-specific numerical identifier of the port
+ *
+ * Register devlink port with provided port index. User can use
+ * any indexing, even hw-related one. devlink_port structure
+ * is convenient to be embedded inside user driver private structure.
+ * Note that the caller should take care of zeroing the devlink_port
+ * structure.
+ */
 int devl_port_register(struct devlink *devlink,
 		       struct devlink_port *devlink_port,
 		       unsigned int port_index)
@@ -9915,6 +9928,8 @@ EXPORT_SYMBOL_GPL(devl_port_register);
  *	is convenient to be embedded inside user driver private structure.
  *	Note that the caller should take care of zeroing the devlink_port
  *	structure.
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
@@ -9929,6 +9944,11 @@ int devlink_port_register(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_port_register);
 
+/**
+ * devl_port_unregister() - Unregister devlink port
+ *
+ * @devlink_port: devlink port
+ */
 void devl_port_unregister(struct devlink_port *devlink_port)
 {
 	lockdep_assert_held(&devlink_port->devlink->lock);
@@ -9946,6 +9966,8 @@ EXPORT_SYMBOL_GPL(devl_port_unregister);
  *	devlink_port_unregister - Unregister devlink port
  *
  *	@devlink_port: devlink port
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_port_unregister(struct devlink_port *devlink_port)
 {
@@ -10206,6 +10228,15 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 }
 EXPORT_SYMBOL_GPL(devl_rate_leaf_create);
 
+/**
+ * devlink_rate_leaf_create - create devlink rate leaf
+ * @devlink_port: devlink port object to create rate object on
+ * @priv: driver private data
+ *
+ * Create devlink rate object of type leaf on provided @devlink_port.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ */
 int
 devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 {
@@ -10220,6 +10251,11 @@ devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 }
 EXPORT_SYMBOL_GPL(devlink_rate_leaf_create);
 
+/**
+ * devl_rate_leaf_destroy - destroy devlink rate leaf
+ *
+ * @devlink_port: devlink port linked to the rate object
+ */
 void devl_rate_leaf_destroy(struct devlink_port *devlink_port)
 {
 	struct devlink_rate *devlink_rate = devlink_port->devlink_rate;
-- 
2.35.3

