Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65545EBCA4
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiI0ICn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiI0ICX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:02:23 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6237AB2CF5
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:57:28 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id t14so13669371wrx.8
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=9+xMapSF679p96gL9vU+Omt/7DAfC+pmm5Ktf8c3i1k=;
        b=t5xE2KTr9b8bivdmxpOzRhIc3AhLx87IKskpEP5SvfrJo3CgA00pLFwq+I/uRqE65u
         /FZgPZnA+MzIrdt/2Tkxq9cBlcYhKPyDciecUBkOdTrK4GfiNG+zsPUe97u0yxhzbqpw
         Sg5P7rrj9ZXddE2f0QK/ryjNiV6sb6Hq8/AQraLjmBTUjcmTbRlVvJwMzMBe9hGj805w
         Glj+lAZWVaWHa/pF2ek5Tmdr0utBX6F06h9wvEQ/JgTRNoUC0k7Z3S3qrK/koZqwVD1L
         EsE7/qzGcq9h1c8uANDh2XDgL1d2MMyvrRnTQ7cWxl+0uAMXTNiG+4nooC5Fd4dQZw94
         navg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=9+xMapSF679p96gL9vU+Omt/7DAfC+pmm5Ktf8c3i1k=;
        b=CS0eaLfV6aGSXEdd0cndMHzcyzSMe0QRJ0dTZcPW9ZmCT4xYIjX3IpR0bd7J8RTX5I
         jSoR4Z4Fx3phAxWhsYDdV1to9Ft8jyPRcoxJsT3QJGCzQn612aTxoov3iNn4rqno3fig
         ra4ZB+xsEJ35St+u/u8aVA0McPU3ldt7+U+iQQgDELUh898b64jvm0UanjZlMdI+gGL3
         QTaOgHxjRveI4748zBCXKzWmtR0NwOhkcP0CVmFDyPXbqTn5QIBaSrWV/k8EYEONrO8u
         +ti+NCcHLGO4KiMVlxmGkHqg4GLxv5Ws9tBWRbKnfQzTDqBqKi/KbvtIs/LcqDmPIggE
         KmJQ==
X-Gm-Message-State: ACrzQf2+L85ggF+lDBMau0XZSG5TyPxpgT54nKjPq1HaVGn9gb8LZXTe
        7qsvlYZLBPT5LJDhH4trXi5gS5Gn1MEPkqqH
X-Google-Smtp-Source: AMsMyM5dKRGGtxclgrH6VoUTy06rxcV/bYSduPBt/XOlbgGLKEfBxkjXEWaBwnkhK9MlXfXO4n8YFw==
X-Received: by 2002:a05:6000:1565:b0:22b:3057:ba63 with SMTP id 5-20020a056000156500b0022b3057ba63mr16060207wrz.259.1664265410435;
        Tue, 27 Sep 2022 00:56:50 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u15-20020a05600c210f00b003a845621c5bsm927638wml.34.2022.09.27.00.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:56:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v2 2/7] net: devlink: introduce a flag to indicate devlink port being registered
Date:   Tue, 27 Sep 2022 09:56:40 +0200
Message-Id: <20220927075645.2874644-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220927075645.2874644-1-jiri@resnulli.us>
References: <20220927075645.2874644-1-jiri@resnulli.us>
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

Instead of relying on devlink pointer not being initialized, introduce
an extra flag to indicate if devlink port is registered. This is needed
as later on devlink pointer is going to be initialized even in case
devlink port is not registered yet.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h | 3 ++-
 net/core/devlink.c    | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 264aa98e6da6..bcacd8dab297 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -129,7 +129,8 @@ struct devlink_port {
 	void *type_dev;
 	struct devlink_port_attrs attrs;
 	u8 attrs_set:1,
-	   switch_port:1;
+	   switch_port:1,
+	   registered:1;
 	struct delayed_work type_warn_dw;
 	struct list_head reporter_list;
 	struct mutex reporters_lock; /* Protects reporter_list */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f5bfbdb0301e..17529e6b2bbf 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -372,9 +372,9 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 }
 
 #define ASSERT_DEVLINK_PORT_REGISTERED(devlink_port)				\
-	WARN_ON_ONCE(!(devlink_port)->devlink)
+	WARN_ON_ONCE(!(devlink_port)->registered)
 #define ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port)			\
-	WARN_ON_ONCE((devlink_port)->devlink)
+	WARN_ON_ONCE((devlink_port)->registered)
 
 static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 						      unsigned int port_index)
@@ -9876,6 +9876,7 @@ int devl_port_register(struct devlink *devlink,
 
 	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
 
+	devlink_port->registered = true;
 	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
@@ -9934,6 +9935,7 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
 	WARN_ON(!list_empty(&devlink_port->region_list));
 	mutex_destroy(&devlink_port->reporters_lock);
+	devlink_port->registered = false;
 }
 EXPORT_SYMBOL_GPL(devl_port_unregister);
 
-- 
2.37.1

