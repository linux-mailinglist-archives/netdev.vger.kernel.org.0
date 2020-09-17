Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3971C26D174
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgIQDIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgIQDII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 23:08:08 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 23:08:02 EDT
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E88C0612F2
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:02:16 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y6so336966plt.9
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2w1n/UNGFvfdJeXM8PGLXzwznjiLAcdbCmfR6hGUsw8=;
        b=hZF/z7Tl0eMRaWzsy4eIiwjv/kZhVvAZpIwAHKKEYUtmTJMgnPhgUC1CX2lmWnyG9A
         NROG6SziuqWRfYZuToN2Z31wpe4OPPz0PD1iDhoj4kR4WZlTeB12tdFo4n8eKQjvoeKq
         SDBSX2Wv4fAiH7aueMZXQ/ORpmKZxNPek/PQUR2Sgrgb7wUXmoUFWzTqGKPCmjYbwAi3
         J2OjzVneXLJ68zpICuCmgSEyWaPMGFgbqX+zwui0sEg4U45TdGhy/8M+F7Z9iPyPAIkG
         q45rF0QzMCO0dPUsZplpXJUVKzlPdeRgpMD32zGeLDuRwtuUvGNUB6zQ4PMxXBXGUOsS
         VFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2w1n/UNGFvfdJeXM8PGLXzwznjiLAcdbCmfR6hGUsw8=;
        b=ujJWelgoMM6geyS/FWPFfHEkGNZ2O8yRmONooz16vIXNX6IW9dRfjAi8O9TbooJxjO
         GndjbN2kmCmj0four1cz4rAtOF6XbF1O1/VgCL9LcrqeInMrjVWZU3F10xwSQJZ2VkCc
         3i95WYGNHRK/flLGAk/+E8E2u+E5y/dX2gWIU0/CQs7SOwu7FPatXRV+4cGou05DK1+K
         x7QkAtAWNAJbvfsRvfBVX2v/KF5byxBEVVfd0jZ9f2BwJiO+aklwwJDqGYpvCVuCAaqg
         d+3dSibxWBijWNXRsv6C+0PYFR4OPI3UVj8zmBi8DPFvfsZUEJ0cJVhk/mKzcKwKGO3o
         HPqA==
X-Gm-Message-State: AOAM531lqUX+JZHcqHZpyutal62u0o4o/WustH0UHGOkwm4wvoyYtOL1
        eqhUyxlYvl5cCHx8I1MPbHSGpY6Vnm0u3w==
X-Google-Smtp-Source: ABdhPJzEVKJuTOL8H3mvy8bcGG/ZgVwCneZdvVt2ShMBoREXHRezxYYV452zH29S+Fn/KvJWcpxj4g==
X-Received: by 2002:a17:90b:707:: with SMTP id s7mr6629847pjz.25.1600311734801;
        Wed, 16 Sep 2020 20:02:14 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id b2sm12072498pfp.3.2020.09.16.20.02.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 20:02:14 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 2/5] devlink: collect flash notify params into a struct
Date:   Wed, 16 Sep 2020 20:02:01 -0700
Message-Id: <20200917030204.50098-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200917030204.50098-1-snelson@pensando.io>
References: <20200917030204.50098-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev flash status notify function parameter lists are getting
rather long, so add a struct to be filled and passed rather than
continuously changing the function signatures.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 include/net/devlink.h | 21 ++++++++++++
 net/core/devlink.c    | 80 +++++++++++++++++++++++--------------------
 2 files changed, 63 insertions(+), 38 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index f206accf80ad..9ab2014885cb 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -391,6 +391,27 @@ struct devlink_param_gset_ctx {
 	enum devlink_param_cmode cmode;
 };
 
+/**
+ * struct devlink_flash_notify - devlink dev flash notify data
+ * @cmd: devlink notify command code
+ * @status_msg: current status string
+ * @component: firmware component being updated
+ * @done: amount of work completed of total amount
+ * @total: amount of work expected to be done
+ * @timeout: expected max timeout in seconds
+ *
+ * These are values to be given to userland to be displayed in order
+ * to show current activity in a firmware update process.
+ */
+struct devlink_flash_notify {
+	enum devlink_command cmd;
+	const char *status_msg;
+	const char *component;
+	unsigned long done;
+	unsigned long total;
+	unsigned long timeout;
+};
+
 /**
  * struct devlink_param - devlink configuration parameter data
  * @name: name of the parameter
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 01f855e53e06..816f27a18b16 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3021,41 +3021,36 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 
 static int devlink_nl_flash_update_fill(struct sk_buff *msg,
 					struct devlink *devlink,
-					enum devlink_command cmd,
-					const char *status_msg,
-					const char *component,
-					unsigned long done,
-					unsigned long total,
-					unsigned long timeout)
+					struct devlink_flash_notify *params)
 {
 	void *hdr;
 
-	hdr = genlmsg_put(msg, 0, 0, &devlink_nl_family, 0, cmd);
+	hdr = genlmsg_put(msg, 0, 0, &devlink_nl_family, 0, params->cmd);
 	if (!hdr)
 		return -EMSGSIZE;
 
 	if (devlink_nl_put_handle(msg, devlink))
 		goto nla_put_failure;
 
-	if (cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS)
+	if (params->cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS)
 		goto out;
 
-	if (status_msg &&
+	if (params->status_msg &&
 	    nla_put_string(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG,
-			   status_msg))
+			   params->status_msg))
 		goto nla_put_failure;
-	if (component &&
+	if (params->component &&
 	    nla_put_string(msg, DEVLINK_ATTR_FLASH_UPDATE_COMPONENT,
-			   component))
+			   params->component))
 		goto nla_put_failure;
 	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,
-			      done, DEVLINK_ATTR_PAD))
+			      params->done, DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,
-			      total, DEVLINK_ATTR_PAD))
+			      params->total, DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,
-			      timeout, DEVLINK_ATTR_PAD))
+			      params->timeout, DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 
 out:
@@ -3068,26 +3063,20 @@ static int devlink_nl_flash_update_fill(struct sk_buff *msg,
 }
 
 static void __devlink_flash_update_notify(struct devlink *devlink,
-					  enum devlink_command cmd,
-					  const char *status_msg,
-					  const char *component,
-					  unsigned long done,
-					  unsigned long total,
-					  unsigned long timeout)
+					  struct devlink_flash_notify *params)
 {
 	struct sk_buff *msg;
 	int err;
 
-	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
-		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
-		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
+	WARN_ON(params->cmd != DEVLINK_CMD_FLASH_UPDATE &&
+		params->cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
+		params->cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return;
 
-	err = devlink_nl_flash_update_fill(msg, devlink, cmd, status_msg,
-					   component, done, total, timeout);
+	err = devlink_nl_flash_update_fill(msg, devlink, params);
 	if (err)
 		goto out_free_msg;
 
@@ -3101,17 +3090,21 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 
 void devlink_flash_update_begin_notify(struct devlink *devlink)
 {
-	__devlink_flash_update_notify(devlink,
-				      DEVLINK_CMD_FLASH_UPDATE,
-				      NULL, NULL, 0, 0, 0);
+	struct devlink_flash_notify params = {
+		.cmd = DEVLINK_CMD_FLASH_UPDATE,
+	};
+
+	__devlink_flash_update_notify(devlink, &params);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_begin_notify);
 
 void devlink_flash_update_end_notify(struct devlink *devlink)
 {
-	__devlink_flash_update_notify(devlink,
-				      DEVLINK_CMD_FLASH_UPDATE_END,
-				      NULL, NULL, 0, 0, 0);
+	struct devlink_flash_notify params = {
+		.cmd = DEVLINK_CMD_FLASH_UPDATE_END,
+	};
+
+	__devlink_flash_update_notify(devlink, &params);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_end_notify);
 
@@ -3121,9 +3114,15 @@ void devlink_flash_update_status_notify(struct devlink *devlink,
 					unsigned long done,
 					unsigned long total)
 {
-	__devlink_flash_update_notify(devlink,
-				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
-				      status_msg, component, done, total, 0);
+	struct devlink_flash_notify params = {
+		.cmd = DEVLINK_CMD_FLASH_UPDATE_STATUS,
+		.status_msg = status_msg,
+		.component = component,
+		.done = done,
+		.total = total,
+	};
+
+	__devlink_flash_update_notify(devlink, &params);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
 
@@ -3132,9 +3131,14 @@ void devlink_flash_update_timeout_notify(struct devlink *devlink,
 					 const char *component,
 					 unsigned long timeout)
 {
-	__devlink_flash_update_notify(devlink,
-				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
-				      status_msg, component, 0, 0, timeout);
+	struct devlink_flash_notify params = {
+		.cmd = DEVLINK_CMD_FLASH_UPDATE_STATUS,
+		.status_msg = status_msg,
+		.component = component,
+		.timeout = timeout,
+	};
+
+	__devlink_flash_update_notify(devlink, &params);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
 
-- 
2.17.1

