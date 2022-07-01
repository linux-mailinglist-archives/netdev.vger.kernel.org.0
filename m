Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F485630D5
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiGAJ7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbiGAJ7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:59:34 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E38271BE3
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 02:59:33 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id c13so2261116eds.10
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 02:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=koHGpx4bc3UP5/1gpss61ee4ZJIo/c5rZmOOUmrA+II=;
        b=qRrWfQj/NJSHLCXsN0unfCCkxP7TLtgG8N7YFJPMnUgeS//+alBmwLowV4ODI30tgJ
         BjQAg0uPPMhTWtZhw8Z4sfXmRnOnRMhVewnvqw8AnWoIZj2BPDsFdQzgWehWMA1+f5Ql
         0TMMcuCk8hp9ipoZfypqiGH8E3NX6QrP/Slb4B6FoClOFcPMvA0IRpIUIDScbX5z4z+/
         Z2mFgTiLfjm42HN0p9un/Ms9KAXTcYP1ak8q5QWlAGJa9ceXValfjo16BCzkrTt26gF2
         eGKddHVF+13X7Vm1VNGus9mOll39uK+TJIvy5pE1qmg6qgBZl5EztGkaNW+HPJBNHhep
         BUsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=koHGpx4bc3UP5/1gpss61ee4ZJIo/c5rZmOOUmrA+II=;
        b=ReeUMFG5+JAfk6/F0cMlbYnRtJ9xjolr1OFjvupXH8Rh7XF1YGALjzfsvxNEgTGoW7
         rFIP4eP88a+tDqxpl7sghtZ1Uwz0mgCi0Er2VK/8ZOUPrdLMT9x/MEArZ9XBi+iWQ3+U
         2jdalk8mXnEf7XvLqSqX4IMNCCrByp/FOJ1XT15kEymx/xf+cb6MfM7ol/hQTNPO7idM
         A6UXFVjvXmDwDa//RpVlhHw+fGIBOPFqc9EmxOZcLmlmCp77A9WJoT4J6WfBHE4TEmY4
         /JAy7dTfbDB8yxVOzfcsUc59pFDb+H1R+fMyc4aXbo2yCGFL8uodKsn2sZqC0oNTmidO
         Cy/A==
X-Gm-Message-State: AJIora+wepUUZS76Pw+rpknRsONVMlSKASsnSouDtv3tD/2BQ6eJZZtF
        SKaIBeimU/+K4SHZ9Lw0USt8W5WB4RND2fYR
X-Google-Smtp-Source: AGRyM1sIq69y85etpmQv/jl84KpP8hhU6ElZ8TpaTgM8bIja5vYGVIF5jzRTs29P8ahNRZc0DmWjug==
X-Received: by 2002:a50:c8cd:0:b0:435:688d:6c59 with SMTP id k13-20020a50c8cd000000b00435688d6c59mr17275143edh.271.1656669571528;
        Fri, 01 Jul 2022 02:59:31 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j24-20020aa7de98000000b00435726bd375sm14459199edv.57.2022.07.01.02.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 02:59:31 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next 3/3] net: devlink: fix unlocked vs locked functions descriptions
Date:   Fri,  1 Jul 2022 11:59:26 +0200
Message-Id: <20220701095926.1191660-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220701095926.1191660-1-jiri@resnulli.us>
References: <20220701095926.1191660-1-jiri@resnulli.us>
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
 net/core/devlink.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index a7477addbd59..cdb33125cd1e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9877,6 +9877,19 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
 	cancel_delayed_work_sync(&devlink_port->type_warn_dw);
 }
 
+/**
+ *	devl_port_register - Register devlink port
+ *
+ *	@devlink: devlink
+ *	@devlink_port: devlink port
+ *	@port_index: driver-specific numerical identifier of the port
+ *
+ *	Register devlink port with provided port index. User can use
+ *	any indexing, even hw-related one. devlink_port structure
+ *	is convenient to be embedded inside user driver private structure.
+ *	Note that the caller should take care of zeroing the devlink_port
+ *	structure.
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
+ *	devlink_port_unregister - Unregister devlink port
+ *
+ *	@devlink_port: devlink port
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

