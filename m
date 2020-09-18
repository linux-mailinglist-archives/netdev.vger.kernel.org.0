Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421F426EA5B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgIRBNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgIRBNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:13:37 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6F1C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:13:36 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k13so2095548plk.3
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F3dW+5Hdcx1xSziM78lv6esioF80C3S/lvaxsGQ9Cz0=;
        b=CMmL2dUNkMeX3v0gNyQN65z1rnBrXbU3RerzRBhY6T9GoVNDS/Czbl1EyI7vB9Y3jC
         jPQgLWfdZE7lcnmXNi7G0Opjz4GlqCh6Pddm1xt+yahE5Unp4lFzZHmvs9FYUzpNuzsX
         i1Nx1v1YY27eXFrJlORHzNKX3+4qcunU7nWoDFjiLt0C/ivLOGQDRbH/ZkuyeJKXAkJ+
         lA6eqT6DnFX1STjjKR9kuNb7sZeuxU1ihvh9HuKfTBZDCmoqypjmAgHEY5q4Amczqc5a
         r9yDmehkVS+Do5PdDjs0srNaokcVJ6FzgPp0+3kefUjvhcg5Nw10K85Vrg6ZJ51NOOli
         8N2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=F3dW+5Hdcx1xSziM78lv6esioF80C3S/lvaxsGQ9Cz0=;
        b=ihBjm/9s6pVJAUvUhL4JXzO9YHdx/GJ/z/Qo7lrRt2obG4oakhrzAzaBT3RHvVV4bl
         onvRf9KSEEQiX9mp35uRr6kTYsFWqXb4EDQS6KsUqZvOzNXMJaXjWInj8v/kNnj/6BTk
         gcWvYcHVV2Kq9Mbh9tYEXwpGpAqfXPuv7EqcDFRjLvCTGczuoJ/ovs0hjysux4booPD+
         CGzAUHkUJLynulNGrNhjXUy2zeeCrPMAN6VuXnA1qHUZXBoslXeqfl0SHihEM4XBhJHu
         vKA/PEbum0P4C9C+/u3ZUaIIczG5UY9kfR4ATZVkt6crQYo9INIfDI+FOmBk/f4i8+aS
         CAMA==
X-Gm-Message-State: AOAM530oxY/QU3Zo5GIPA79ShH2RCgH3XT2AZnZRW0FWo44wj3CwW1rL
        dFAkYNquN7ErWLlNIpadwtPieGOO6YDvCw==
X-Google-Smtp-Source: ABdhPJzHKEnysGHzVq6kFhGWSBYj0i+KsShjDSM3EBqO9vQjtSjW3kM+mVLo0S2g4L6rMXxw+FEnww==
X-Received: by 2002:a17:90a:d70b:: with SMTP id y11mr10487313pju.15.1600391615875;
        Thu, 17 Sep 2020 18:13:35 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id e19sm955701pfl.135.2020.09.17.18.13.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 18:13:35 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v5 net-next 2/5] devlink: collect flash notify params into a struct
Date:   Thu, 17 Sep 2020 18:13:24 -0700
Message-Id: <20200918011327.31577-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200918011327.31577-1-snelson@pensando.io>
References: <20200918011327.31577-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev flash status notify function parameter lists are getting
rather long, so add a struct to be filled and passed rather than
continuously changing the function signatures.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/net/devlink.h | 19 +++++++++++++++
 net/core/devlink.c    | 54 +++++++++++++++++++++++++------------------
 2 files changed, 50 insertions(+), 23 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index be132c17fbcc..73065f07bf17 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -391,6 +391,25 @@ struct devlink_param_gset_ctx {
 	enum devlink_param_cmode cmode;
 };
 
+/**
+ * struct devlink_flash_notify - devlink dev flash notify data
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
index a32e15851119..d5844761a177 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3022,11 +3022,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 static int devlink_nl_flash_update_fill(struct sk_buff *msg,
 					struct devlink *devlink,
 					enum devlink_command cmd,
-					const char *status_msg,
-					const char *component,
-					unsigned long done,
-					unsigned long total,
-					unsigned long timeout)
+					struct devlink_flash_notify *params)
 {
 	void *hdr;
 
@@ -3040,22 +3036,22 @@ static int devlink_nl_flash_update_fill(struct sk_buff *msg,
 	if (cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS)
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
@@ -3069,11 +3065,7 @@ static int devlink_nl_flash_update_fill(struct sk_buff *msg,
 
 static void __devlink_flash_update_notify(struct devlink *devlink,
 					  enum devlink_command cmd,
-					  const char *status_msg,
-					  const char *component,
-					  unsigned long done,
-					  unsigned long total,
-					  unsigned long timeout)
+					  struct devlink_flash_notify *params)
 {
 	struct sk_buff *msg;
 	int err;
@@ -3086,8 +3078,7 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 	if (!msg)
 		return;
 
-	err = devlink_nl_flash_update_fill(msg, devlink, cmd, status_msg,
-					   component, done, total, timeout);
+	err = devlink_nl_flash_update_fill(msg, devlink, cmd, params);
 	if (err)
 		goto out_free_msg;
 
@@ -3101,17 +3092,21 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 
 void devlink_flash_update_begin_notify(struct devlink *devlink)
 {
+	struct devlink_flash_notify params = { 0 };
+
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE,
-				      NULL, NULL, 0, 0, 0);
+				      &params);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_begin_notify);
 
 void devlink_flash_update_end_notify(struct devlink *devlink)
 {
+	struct devlink_flash_notify params = { 0 };
+
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE_END,
-				      NULL, NULL, 0, 0, 0);
+				      &params);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_end_notify);
 
@@ -3121,9 +3116,16 @@ void devlink_flash_update_status_notify(struct devlink *devlink,
 					unsigned long done,
 					unsigned long total)
 {
+	struct devlink_flash_notify params = {
+		.status_msg = status_msg,
+		.component = component,
+		.done = done,
+		.total = total,
+	};
+
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
-				      status_msg, component, done, total, 0);
+				      &params);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
 
@@ -3132,9 +3134,15 @@ void devlink_flash_update_timeout_notify(struct devlink *devlink,
 					 const char *component,
 					 unsigned long timeout)
 {
+	struct devlink_flash_notify params = {
+		.status_msg = status_msg,
+		.component = component,
+		.timeout = timeout,
+	};
+
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
-				      status_msg, component, 0, 0, timeout);
+				      &params);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
 
-- 
2.17.1

