Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34B95A0DF4
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240841AbiHYKeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239174AbiHYKeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:34:09 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D078F9F74B
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:07 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id bs25so24050247wrb.2
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=tvAgG0qyftoep/Nfoaw+TcQW5VODOZjYX3BdjDUZn84=;
        b=spZ6qzZpsngzXAJ+4RYXMF5bJnsXl7yCuRsvSdyw7pd+Ss0lrE8kaZWuaJ9fd9lmil
         sl/Vt2eXBj8KMQDtYTaGGeEZ2CRHgqKUmGNx8M9ktgsrSQBR93gleWERFtrcVgYphD0m
         Ks4oC4XZTbHX94oMIBakJFtAVSZRY4AKnuNLdTezAtnx32w9BdZiMAqplDUM9bv4s2LQ
         xNs3DNWx5JLtSTxQN8nOT5ST4AHVaodED3lP3UHeZ8+H+L3tsbkRjBw6DK5BQ675KP2t
         n9PMTSeu40RAES22RrhzELRkHxG89eEHJA+3hIM+6ppCA8NMgQr2AovZpQUh+360IWNz
         3t+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=tvAgG0qyftoep/Nfoaw+TcQW5VODOZjYX3BdjDUZn84=;
        b=SCeZ6flMMlqPf14Mx3KXiYyhD2W10eg/NUx97xtcqkVghg3Gdx2UUsHhWOIaHksvr1
         cGvcDsMyfk3cV63fcY1YY+aOmdgGEVGaJiFB6c1ZsF6cKxcBZXI49lDQ2BCyLVyRgH7f
         at12PtcXI70yvz8Wknt6vTpccEnndmWNevwgjzZ868Y0I59FsD3Sd3QQAxJ4xk8te+fh
         ZABpup5mWUXVfPyTwk+XtEEmDBJ80mgOjrn1J9fT1DGSpoo2o7HR4SG0PsPxgqOb0KEf
         WUfstNFaQP4JBOG47b4BrH/T22SMIWYjavSI+6yNL7yROLKwfDi9vbdZWs3rsIM2m/JJ
         Hkkg==
X-Gm-Message-State: ACgBeo0QevPBJtp783BMRa7fUlWzaaEoI4dmpPvyjfLcxJPv5puctTO8
        ldMov892s+jqiHKRZzTfV4nMZ7QtXq0758Ko
X-Google-Smtp-Source: AA6agR46zboCickPVy+EoYv+23uFzCq+mXuPiHKQeFBYpJKKL7C0cK3s7lfppvKbf3xEfL/AHuZ7ww==
X-Received: by 2002:a5d:67c6:0:b0:225:2a3e:6384 with SMTP id n6-20020a5d67c6000000b002252a3e6384mr1811397wrw.23.1661423646409;
        Thu, 25 Aug 2022 03:34:06 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id cc19-20020a5d5c13000000b0022571d43d32sm4338900wrb.21.2022.08.25.03.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:34:05 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next 2/7] net: devlink: introduce port registered assert helper and use it
Date:   Thu, 25 Aug 2022 12:33:55 +0200
Message-Id: <20220825103400.1356995-3-jiri@resnulli.us>
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

Instead of checking devlink_port->devlink pointer for not being NULL
which indicates that devlink port is registered, put this check to new
pair of helpers similar to what we have for devlink and use them in
other functions.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6854f574e3ae..2737dad89f51 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -371,6 +371,11 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 	return ERR_PTR(-ENODEV);
 }
 
+#define ASSERT_DEVLINK_PORT_REGISTERED(devlink_port)				\
+	WARN_ON_ONCE(!(devlink_port)->devlink)
+#define ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port)			\
+	WARN_ON_ONCE((devlink_port)->devlink)
+
 static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 						      unsigned int port_index)
 {
@@ -9771,7 +9776,8 @@ int devl_port_register(struct devlink *devlink,
 	if (devlink_port_index_exists(devlink, port_index))
 		return -EEXIST;
 
-	WARN_ON(devlink_port->devlink);
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
@@ -9854,8 +9860,8 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 				    enum devlink_port_type type,
 				    void *type_dev)
 {
-	if (WARN_ON(!devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
+
 	devlink_port_type_warn_cancel(devlink_port);
 	spin_lock_bh(&devlink_port->type_lock);
 	devlink_port->type = type;
@@ -9974,8 +9980,8 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 {
 	int ret;
 
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	devlink_port->attrs = *attrs;
 	ret = __devlink_port_attrs_set(devlink_port, attrs->flavour);
 	if (ret)
@@ -9998,8 +10004,8 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_PF);
 	if (ret)
@@ -10025,8 +10031,8 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_VF);
 	if (ret)
@@ -10053,8 +10059,8 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_SF);
 	if (ret)
@@ -10169,8 +10175,8 @@ EXPORT_SYMBOL_GPL(devl_rate_nodes_destroy);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
 			       struct devlink_linecard *linecard)
 {
-	if (WARN_ON(devlink_port->devlink))
-		return;
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
+
 	devlink_port->linecard = linecard;
 }
 EXPORT_SYMBOL_GPL(devlink_port_linecard_set);
-- 
2.37.1

