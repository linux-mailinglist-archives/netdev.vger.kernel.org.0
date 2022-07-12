Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDE85717FB
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbiGLLFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbiGLLFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:05:22 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1F6B024B
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:20 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w12so8889806edd.13
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JktIlM3mMfpY7Y/p7yM9EXwtOqpp11fREQvmJ879gZQ=;
        b=Weyr2hOhL1P9E500eBJeaanxXk3mUk2+uUA3MAX7E20H02xl/MZLfNYyjRyoekVpIq
         LBGyWdy7CUQqRg/zc8MlBJPkk/10I3oaEtxb9i852Vcazb/pMkIZ0Hra0HE8mijrv7mo
         pUfh7isUM9YgEZogpY7f5Cg7nhdZaOLh1OpY6g5Am8k3j9poiuOx/l66XgfrG0HVIQz3
         A2p8APap+eWsgE/uCbw5QV8joJRPtOjx+1D7GfeGYWw4WzQkeGWVZveoUbNQjH1xvgyF
         TmCWk6kzRAGBrHz1K2Rx1xwXG16DHp3W8OhXtBIHKfGOYSDnh4w6wmUGo4xVACl3UpJr
         yp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JktIlM3mMfpY7Y/p7yM9EXwtOqpp11fREQvmJ879gZQ=;
        b=iE6PlcCd4K/bLDBYntdtaGgj8aOXyTmWSwZybyOeBq0JX6mYXZszc1UoIC/MvwQQdQ
         oBFbVROHfomiAZI89WK22XAYwBPihkkP1P8kJjY9394iQNXLBbD23L6QuB8LYNlyH/nW
         b6+zwp5LWwxV0CLInhLx4h04ZHncckpB3IB7Ket5isuTyG6CJDvGRqxijUUU7ayMIcaC
         S7WVI5yxpQOy8lTxxQSozvQEwzVhDwuaZrCuqvXc6FN1mBBQoRgLfud8AJ+BQjSID5cV
         OGCghaQ2WCci5ZQdKH0fgmg4JyOtKzXjFh026V5RaFFPZJZ9L//ndR+6tRbBkuP2h5sI
         q1pA==
X-Gm-Message-State: AJIora+H+b+zWm34k48FYKctKd5Myz4cbm14PXNsGGpMAV+c/OIi99GH
        3E5/e+dVl6yVjPs+3PM1BwASW+yzQAWV+5+aKSs=
X-Google-Smtp-Source: AGRyM1v3T8Ur6ub/F3DBkznXKTCiDqSKVqjJVgxD1PTvYbo8Rn3ikEuCZcovoQgtW//h7uCWUrz/Ew==
X-Received: by 2002:a05:6402:28c8:b0:43a:aba5:efe5 with SMTP id ef8-20020a05640228c800b0043aaba5efe5mr30701752edb.2.1657623918732;
        Tue, 12 Jul 2022 04:05:18 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b4-20020aa7d484000000b0043a46f5fb82sm5827879edr.73.2022.07.12.04.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:05:18 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFC 04/10] net: devlink: add unlocked variants of devlink_sb*() functions
Date:   Tue, 12 Jul 2022 13:05:05 +0200
Message-Id: <20220712110511.2834647-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712110511.2834647-1-jiri@resnulli.us>
References: <20220712110511.2834647-1-jiri@resnulli.us>
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

Add unlocked variants of devlink_sb*() functions to be used
in drivers called-in with devlink->lock held.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  5 ++++
 net/core/devlink.c    | 54 ++++++++++++++++++++++++++++---------------
 2 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 86b2b9f466f9..9d340f642ed9 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1579,10 +1579,15 @@ void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
 void devlink_linecard_provision_fail(struct devlink_linecard *linecard);
 void devlink_linecard_activate(struct devlink_linecard *linecard);
 void devlink_linecard_deactivate(struct devlink_linecard *linecard);
+int devl_sb_register(struct devlink *devlink, unsigned int sb_index,
+		     u32 size, u16 ingress_pools_count,
+		     u16 egress_pools_count, u16 ingress_tc_count,
+		     u16 egress_tc_count);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
 			u16 egress_tc_count);
+void devl_sb_unregister(struct devlink *devlink, unsigned int sb_index);
 void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index);
 int devlink_dpipe_table_register(struct devlink *devlink,
 				 const char *table_name,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5b89fea9bc9b..b45e9216e913 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10375,25 +10375,21 @@ void devlink_linecard_deactivate(struct devlink_linecard *linecard)
 }
 EXPORT_SYMBOL_GPL(devlink_linecard_deactivate);
 
-int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
-			u32 size, u16 ingress_pools_count,
-			u16 egress_pools_count, u16 ingress_tc_count,
-			u16 egress_tc_count)
+int devl_sb_register(struct devlink *devlink, unsigned int sb_index,
+		     u32 size, u16 ingress_pools_count,
+		     u16 egress_pools_count, u16 ingress_tc_count,
+		     u16 egress_tc_count)
 {
 	struct devlink_sb *devlink_sb;
-	int err = 0;
 
-	devl_lock(devlink);
-	if (devlink_sb_index_exists(devlink, sb_index)) {
-		err = -EEXIST;
-		goto unlock;
-	}
+	lockdep_assert_held(&devlink->lock);
+
+	if (devlink_sb_index_exists(devlink, sb_index))
+		return -EEXIST;
 
 	devlink_sb = kzalloc(sizeof(*devlink_sb), GFP_KERNEL);
-	if (!devlink_sb) {
-		err = -ENOMEM;
-		goto unlock;
-	}
+	if (!devlink_sb)
+		return -ENOMEM;
 	devlink_sb->index = sb_index;
 	devlink_sb->size = size;
 	devlink_sb->ingress_pools_count = ingress_pools_count;
@@ -10401,23 +10397,45 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 	devlink_sb->ingress_tc_count = ingress_tc_count;
 	devlink_sb->egress_tc_count = egress_tc_count;
 	list_add_tail(&devlink_sb->list, &devlink->sb_list);
-unlock:
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devl_sb_register);
+
+int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
+			u32 size, u16 ingress_pools_count,
+			u16 egress_pools_count, u16 ingress_tc_count,
+			u16 egress_tc_count)
+{
+	int err;
+
+	devl_lock(devlink);
+	err = devl_sb_register(devlink, sb_index, size, ingress_pools_count,
+			       egress_pools_count, ingress_tc_count,
+			       egress_tc_count);
 	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_sb_register);
 
-void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
+void devl_sb_unregister(struct devlink *devlink, unsigned int sb_index)
 {
 	struct devlink_sb *devlink_sb;
 
-	devl_lock(devlink);
+	lockdep_assert_held(&devlink->lock);
+
 	devlink_sb = devlink_sb_get_by_index(devlink, sb_index);
 	WARN_ON(!devlink_sb);
 	list_del(&devlink_sb->list);
-	devl_unlock(devlink);
 	kfree(devlink_sb);
 }
+EXPORT_SYMBOL_GPL(devl_sb_unregister);
+
+void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
+{
+	devl_lock(devlink);
+	devl_sb_unregister(devlink, sb_index);
+	devl_unlock(devlink);
+}
 EXPORT_SYMBOL_GPL(devlink_sb_unregister);
 
 /**
-- 
2.35.3

