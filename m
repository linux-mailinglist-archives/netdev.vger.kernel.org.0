Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F10B5717FD
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbiGLLFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbiGLLFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:05:24 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F303B025B
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:23 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id mf4so12472063ejc.3
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jRj2x+hppUH4qtgedgp/T52fIYsQutjLXzc5QM6zN1Q=;
        b=ogrS9qzhZZgbVQGfltPJiHKhxSdx6qGI1tm2zE/KDknQpjEBH9gUXg03pyC8kmxF6m
         hCvfTK0K1R9B3/jrPQvW9Ag7F9WRaHTvka6WGR6v/6GVdjOrPG6iP2hNJIO33Kh7DW8a
         Eai5Ij6jd69xr4lbkZV+XBEU19/BAuCp7Tqjs6KvkyvhXXH8ZyzWeXKcutr4x1ginf5z
         uFdGAa1bvFjD0UB7ioXRPV/79ubjdGOnAnzulOtzeFjKI4hXOS24xy8yOZUH3mjdzLbZ
         n/EDwv0MbotluLJi5fBYzHF83TiVncjafT1Jk75h0iUQ73ce4mRb6nfX1Y93gjpojABL
         JExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jRj2x+hppUH4qtgedgp/T52fIYsQutjLXzc5QM6zN1Q=;
        b=CP3a6tXsE7xHn4MYUDskvxaRfJJpN82p2W5XZB7UgUU3rqOBEDX5ta6OE50sWBQm1F
         LSVLugPXWZzJMgagJHxLw7MllI7HIPst3zR+acJgBK1Ia288m7rugFEjtws19nPWnW+h
         DwLjpOXNSM2gzNc5jV4S4wogHxQX2OTQo1L19+yye+QC8QvZwZgYBFF/rvxRysRVCm2Q
         PmScdnANHu+P+cdrbGk/cQXxLo4glitbMoyFlxzP7NJ344C8UzahamLhZEw+Yf5uh6XI
         36NhcCLKGryXWjP32en1WKXgPaOkFfewAqpB+xpDOj5g+JsmFam1wGFYKtwtBAw8k6Yt
         bf3Q==
X-Gm-Message-State: AJIora/sbhKJM73yJknx45rBvfdR/RGfYJyJYZ02qonv4zDj9ISwOuQT
        NL7sLQO0gUhKgBjWy0UZD7Fz7YTlAHKBhq3QHY4=
X-Google-Smtp-Source: AGRyM1sYcvTi6VLmBAEzzLNA8RctdNo8YDgXAMvI9a7Kf8XYM2PRUBy/EiTng4CYmSA98zPEkAr4Iw==
X-Received: by 2002:a17:906:c10:b0:6f4:6c70:b00f with SMTP id s16-20020a1709060c1000b006f46c70b00fmr23469663ejf.660.1657623921731;
        Tue, 12 Jul 2022 04:05:21 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id e24-20020a50ec98000000b0043a6a7048absm5763205edr.95.2022.07.12.04.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:05:21 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFC 06/10] net: devlink: add unlocked variants of devlink_trap_policers*() functions
Date:   Tue, 12 Jul 2022 13:05:07 +0200
Message-Id: <20220712110511.2834647-7-jiri@resnulli.us>
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

Add unlocked variants of devlink_trap_policers*() functions to be used
in drivers called-in with devlink->lock held.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  8 ++++++
 net/core/devlink.c    | 61 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 58 insertions(+), 11 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 66722e4dcb87..18ad88527847 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1808,10 +1808,18 @@ void devlink_trap_groups_unregister(struct devlink *devlink,
 				    const struct devlink_trap_group *groups,
 				    size_t groups_count);
 int
+devl_trap_policers_register(struct devlink *devlink,
+			    const struct devlink_trap_policer *policers,
+			    size_t policers_count);
+int
 devlink_trap_policers_register(struct devlink *devlink,
 			       const struct devlink_trap_policer *policers,
 			       size_t policers_count);
 void
+devl_trap_policers_unregister(struct devlink *devlink,
+			      const struct devlink_trap_policer *policers,
+			      size_t policers_count);
+void
 devlink_trap_policers_unregister(struct devlink *devlink,
 				 const struct devlink_trap_policer *policers,
 				 size_t policers_count);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 20b2a5e2c2f2..efd0772e8c42 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -12185,7 +12185,7 @@ devlink_trap_policer_unregister(struct devlink *devlink,
 }
 
 /**
- * devlink_trap_policers_register - Register packet trap policers with devlink.
+ * devl_trap_policers_register - Register packet trap policers with devlink.
  * @devlink: devlink.
  * @policers: Packet trap policers.
  * @policers_count: Count of provided packet trap policers.
@@ -12193,13 +12193,13 @@ devlink_trap_policer_unregister(struct devlink *devlink,
  * Return: Non-zero value on failure.
  */
 int
-devlink_trap_policers_register(struct devlink *devlink,
-			       const struct devlink_trap_policer *policers,
-			       size_t policers_count)
+devl_trap_policers_register(struct devlink *devlink,
+			    const struct devlink_trap_policer *policers,
+			    size_t policers_count)
 {
 	int i, err;
 
-	devl_lock(devlink);
+	devl_assert_locked(devlink);
 	for (i = 0; i < policers_count; i++) {
 		const struct devlink_trap_policer *policer = &policers[i];
 
@@ -12214,35 +12214,74 @@ devlink_trap_policers_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_policer_register;
 	}
-	devl_unlock(devlink);
-
 	return 0;
 
 err_trap_policer_register:
 err_trap_policer_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devl_trap_policers_register);
+
+/**
+ * devlink_trap_policers_register - Register packet trap policers with devlink.
+ * @devlink: devlink.
+ * @policers: Packet trap policers.
+ * @policers_count: Count of provided packet trap policers.
+ *
+ * Return: Non-zero value on failure.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ */
+int
+devlink_trap_policers_register(struct devlink *devlink,
+			       const struct devlink_trap_policer *policers,
+			       size_t policers_count)
+{
+	int err;
+
+	devl_lock(devlink);
+	err = devl_trap_policers_register(devlink, policers, policers_count);
 	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
 
+/**
+ * devl_trap_policers_unregister - Unregister packet trap policers from devlink.
+ * @devlink: devlink.
+ * @policers: Packet trap policers.
+ * @policers_count: Count of provided packet trap policers.
+ */
+void
+devl_trap_policers_unregister(struct devlink *devlink,
+			      const struct devlink_trap_policer *policers,
+			      size_t policers_count)
+{
+	int i;
+
+	devl_assert_locked(devlink);
+	for (i = policers_count - 1; i >= 0; i--)
+		devlink_trap_policer_unregister(devlink, &policers[i]);
+}
+EXPORT_SYMBOL_GPL(devl_trap_policers_unregister);
+
 /**
  * devlink_trap_policers_unregister - Unregister packet trap policers from devlink.
  * @devlink: devlink.
  * @policers: Packet trap policers.
  * @policers_count: Count of provided packet trap policers.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
  */
 void
 devlink_trap_policers_unregister(struct devlink *devlink,
 				 const struct devlink_trap_policer *policers,
 				 size_t policers_count)
 {
-	int i;
-
 	devl_lock(devlink);
-	for (i = policers_count - 1; i >= 0; i--)
-		devlink_trap_policer_unregister(devlink, &policers[i]);
+	devl_trap_policers_unregister(devlink, policers, policers_count);
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
-- 
2.35.3

