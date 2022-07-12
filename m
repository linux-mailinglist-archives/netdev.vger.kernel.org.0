Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23D757173E
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbiGLKYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbiGLKYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:24:30 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947C4ADD67
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:24:29 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r18so9500191edb.9
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6EprXVQpt4cqZIGl5hB23e4JQrj35K1q82k1dZNLNEA=;
        b=2LI86ZOdZmvN2EohuvbakjWVqv/6NlT2RMpb/JgYeacidlPyrUx1lX8BQLw3HfOjJc
         1VxsTNPAyLcrbRQVBTGrFg5/xwIMHdjlVhieu3AFN2FmonX9PR8gDFzY68bjjt+OEV4d
         V2lquWtJGg5XhXHCmRS/q+2qag85Y+ocHh6FKFfaXSLfKe2Aqnn/jB9aEsxyrFc/dpc3
         jRBso8fziJrQYJycA2D5scNJUxQMKcd+VzY7FAqLCsRQvjz1tdLgYLi0KI1LA4E6ZQV4
         91XVvEOzSiMQpXSVCtxTmgze1108g/rN2E92mksVfNNUiJCZdl5U7KrIBnxVdyQOKh/f
         ZPpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6EprXVQpt4cqZIGl5hB23e4JQrj35K1q82k1dZNLNEA=;
        b=e3m0ku8kBOBiRrGys1nnoxysrnhvWT72yMPLFrnpF19GLJ2fZFSO9cn/oKYgTFCOwl
         5BYLuwmGBbtAZepA/lG8tmv08Wrh7IiXZ2OSfjO4Rt2oOrpPe/LDWn2VKfukpPb6Qq8t
         bpAy8IssYhF67d0g8nkyvHvn9m76v+iN39NFYhkRYYvQGhD8ziasqceMSuVn2heVN9pm
         QGFuWiQuWO278cQyk53hqn5Sz8cHUrcuRjqm5Ml06FCnvibBeFoH0r++fxmYH5zqsUMb
         j/tbdKARwXRfTCW7bML+78S+8Ug3avo0EPsyGz9BTemZ1z0SJY/c4Rh3zFcxs3dx+CTS
         qBzg==
X-Gm-Message-State: AJIora++15vnSNOru/UNsDCmylWEYT7M1GDfbE5pPDykQ0vPll52O1cF
        8wBHCAdEuatpPua7IYTsXTcv5zWtu5INnsubcF0=
X-Google-Smtp-Source: AGRyM1u4ZksUYT2P6dRJeDt8t267zJvhzC1dNay/c6WIegwhU14c/RAevmKT3Fo+2DyDatsctbR5JA==
X-Received: by 2002:aa7:c683:0:b0:43a:13fe:9c69 with SMTP id n3-20020aa7c683000000b0043a13fe9c69mr30879733edq.353.1657621468161;
        Tue, 12 Jul 2022 03:24:28 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906201200b00722e50e259asm3617026ejo.102.2022.07.12.03.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:24:27 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v4 1/3] net: devlink: fix unlocked vs locked functions descriptions
Date:   Tue, 12 Jul 2022 12:24:22 +0200
Message-Id: <20220712102424.2774011-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712102424.2774011-1-jiri@resnulli.us>
References: <20220712102424.2774011-1-jiri@resnulli.us>
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
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
v3->v4:
- rebased on top of Mosche's patchset (trivial)
v1->v2:
- s/devlink_/devl_/ for unregister comment
- removed tabs
- added ()s
---
 net/core/devlink.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e206cc90bec5..8cef65a6934d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9673,6 +9673,19 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
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
@@ -9711,6 +9724,8 @@ EXPORT_SYMBOL_GPL(devl_port_register);
  *	is convenient to be embedded inside user driver private structure.
  *	Note that the caller should take care of zeroing the devlink_port
  *	structure.
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
@@ -9725,6 +9740,11 @@ int devlink_port_register(struct devlink *devlink,
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
@@ -9742,6 +9762,8 @@ EXPORT_SYMBOL_GPL(devl_port_unregister);
  *	devlink_port_unregister - Unregister devlink port
  *
  *	@devlink_port: devlink port
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_port_unregister(struct devlink_port *devlink_port)
 {
-- 
2.35.3

