Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A163576D66
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 13:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiGPLC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 07:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiGPLCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 07:02:54 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0BE27B2E
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:02:52 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id mf4so13035898ejc.3
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8uVD57S1SdiB8uSmTU3BT3oak0rYxr+EQzizPmHsZCg=;
        b=PMaBBE5ZGuIWm7Iil5iiggQP5Gaz834+rYWU030tL8le+P26qxPqXsAsMGkyaKe1Oy
         Ap07JA1B+98uT60sH0PGQOW6HEILjgDcyiTd6vEQmJu7e2a8/e+Wygw+Y7E7jqEHsaUk
         WVGlSiUOkbFuZS7412NIRX7tV3P7on+7lsn1luwCWG7N5XQb6mwhNEsvSZd3oDmSfimW
         hbSu/QHG6VHGmFBeiu8NE7dVutFJsQKpoDsRCAQDI9B9vUBmmCkbkRLEuw2cdoUHiuec
         idjPHPVOJ0o8M7+FV1/bmRZGpxkTOhSKUW3Yd/OJzs8kHfMysIyMLe5IYSQzXo2GeRC/
         6lbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8uVD57S1SdiB8uSmTU3BT3oak0rYxr+EQzizPmHsZCg=;
        b=AzQczpakAnVpl82DG4HstuhXG7QMkEqd0M88oNah+b8DhmdEJNvz+WdTbjR+jVmqZp
         GHRJ3wcYME6F4TYgbKb/eLGUGYhLj8ELS8VqRjsSVy0p0qOygvw5WcOvrhdm3LLBO7Cn
         rd/ANwkIT1jpJjMWQSATekhPS17eybUxjVe8OoUBmFPX8R6tvohB6cXW0DiPKAixlMRn
         2KHOjMvjPaybMhwQ0F8CGwLPALf2Q0uE0iRplF4igULFTAElfVgB/8ZVrWx+MxZRUeSo
         dFy9Ud3r4DSvV8nzCRTmEh4iFMVWHGvQlmatFk2Y85c9tMgC75wfwqpLDQgVdzc8PcrY
         WlJg==
X-Gm-Message-State: AJIora+B/uvFy7QVgpisWYr5OaDlx0GVRYV5IvVJgI1ZtLJ9BQA7vhfa
        Ny/eVXNnpY1nvngNa0GXbLZsAvmuBmduLgOD
X-Google-Smtp-Source: AGRyM1tfd8JKDFhKCzVaW1NWFjQwkRuiQFFpvNIYLYoWxaSZrscluZ/TN1L+xANVfPXUreO8RpsZPw==
X-Received: by 2002:a17:907:7f09:b0:726:2ba7:21c2 with SMTP id qf9-20020a1709077f0900b007262ba721c2mr17681433ejc.744.1657969370593;
        Sat, 16 Jul 2022 04:02:50 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i23-20020a056402055700b0043a2338ca10sm4435802edx.92.2022.07.16.04.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 04:02:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next 4/9] net: devlink: add unlocked variants of devlink_sb*() functions
Date:   Sat, 16 Jul 2022 13:02:36 +0200
Message-Id: <20220716110241.3390528-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220716110241.3390528-1-jiri@resnulli.us>
References: <20220716110241.3390528-1-jiri@resnulli.us>
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

Add unlocked variants of devlink_sb*() functions to be used
in drivers called-in with devlink->lock held.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  5 ++++
 net/core/devlink.c    | 54 ++++++++++++++++++++++++++++---------------
 2 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index d341753753ce..0057809a13b0 100644
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
index 1688271ef7b2..64dab4024d11 100644
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

