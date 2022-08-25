Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E235A0DF5
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240869AbiHYKeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240846AbiHYKeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:34:11 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22499F74B
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:09 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h24so24028063wrb.8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=idvMtG1XnDDbT6TMYpq+ApZNAfs6S2lrCtyZaUzz36c=;
        b=0PMaF2Z7hIJDBKnaxmTgxyRNrJUWqekalLrUKDdJ3wxw/Mx4+RHvMfscRIaXI6nosl
         Hylg2lSJcNP6HoX9Y73uzpQ62LZX8Kfs7gAIPmCk5bFTZk2ZxKMfabyT99JNuGhK9YG1
         VGaKAiTF3OYW9Tt1VkdRS+6w4D39L3jkbgVrq/Oh2oFzdOVAvV+KABkk6Ihy5nbYWgqx
         umsaHl/gbkBTc3K6Tm2GCSKCzfhSacpaksiVSGgueyUJDsFeFUcf/rIql2C+OCtVovBv
         RP5km/vBxua09iXVqkq5dX9cbiiUzHFGASzNSYZdo7JrhRd9f6O2WFQdxpwblfQY5wgS
         AwmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=idvMtG1XnDDbT6TMYpq+ApZNAfs6S2lrCtyZaUzz36c=;
        b=tYdH+ieJoUI4iaBV2MGVDn0KiMMekNmnE9Ui330fHGpVAfYVKOBTjPqxK/gEJyJs/c
         MFg01mudJxR1KucHI6kzxYXJyocFKdANKPUjBdFL8ch9W2LEZxiMKlKQrWtVMpEsl5Vw
         uw2evdm9oWLdFoCz3stQW2eAeuY7qC3j+tTUDiyR6DAOgxhl+qPmVm8menw4gEqkwzOH
         MDDhTq/jZUfU1ZJ72mR3F3vxaCyoQmf7aO328XRNe1OB5izwK7kHpXOUiCFqdSUmttO9
         TDA2Fjh5bGfakWyErCPXn938ulF9cSoghEnBWSdZvMqXxCpaUUGtKAdj3Nik1VE3iL5K
         rFFw==
X-Gm-Message-State: ACgBeo1yuZ0JE7zfcOFFkyHqD0HlZfKBJj9TWFNCdhNy4xMkCLyzYOdN
        ZRaenQAvzWctwSl/PIgtM6DKKwozTCUpXYAz
X-Google-Smtp-Source: AA6agR5QEu0vvdbqqdSvBJin+tfIsZSbBKOcuqNObOb9sFoWb/tAuuNgni0bOZBSkskh8d7qpwjR2A==
X-Received: by 2002:a05:6000:15c1:b0:225:332e:2741 with SMTP id y1-20020a05600015c100b00225332e2741mr1952474wry.652.1661423648413;
        Thu, 25 Aug 2022 03:34:08 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m13-20020a05600c4f4d00b003a3561d4f3fsm5175381wmq.43.2022.08.25.03.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:34:07 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next 3/7] net: devlink: introduce a flag to indicate devlink port being registered
Date:   Thu, 25 Aug 2022 12:33:56 +0200
Message-Id: <20220825103400.1356995-4-jiri@resnulli.us>
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
index 0b45d44a3348..7b41ebbaf379 100644
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
index 2737dad89f51..af13f95384d9 100644
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
@@ -9778,6 +9778,7 @@ int devl_port_register(struct devlink *devlink,
 
 	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
 
+	devlink_port->registered = true;
 	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
@@ -9836,6 +9837,7 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
 	WARN_ON(!list_empty(&devlink_port->region_list));
 	mutex_destroy(&devlink_port->reporters_lock);
+	devlink_port->registered = false;
 }
 EXPORT_SYMBOL_GPL(devl_port_unregister);
 
-- 
2.37.1

