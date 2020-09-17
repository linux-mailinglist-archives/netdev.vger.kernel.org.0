Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FDF26D16D
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgIQDIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIQDIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 23:08:01 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8581BC061356
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:02:14 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u9so350736plk.4
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GeBC5SZMySgUGL1jC0oi+rfcsEQ+xVNDU0XKznJ0qkE=;
        b=YiBK8n1I/wuCAWLRBCit/H6omZv+YnIT9D9O1n0D+HxrANZzRmuekWyBYyyUQ5lmVE
         t7RylX6BaazSSIqntMaac8OsqP/UytuLnI1hp9EDmq3NEnLtrMSuzz23cUXKlG4KY8wk
         cDh5S0hgpL9q7HO3hQ15wV5UdUsN9/dATNgyZg53ffiZrkwMvOhKzOGqpdtujxddnQZL
         QaTjbm3li/aoDSk+qI2qirJPWm5wI19ZhUYoHISY2cmOGk1DFjy4uQ2fC5po44fqlsII
         ENAmBgq6LyVDbFTwITgYeW1brfwmnLnpVVDvpgNkGMoAo/3p1PJiABqtocLMd2u5LHx/
         JQ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GeBC5SZMySgUGL1jC0oi+rfcsEQ+xVNDU0XKznJ0qkE=;
        b=eNugT3pZruzAxKTv7ZOtNetZPWJN43QwyNYPjHRqeWoZjAPG5+JafF/kdTSsfC6SK8
         WJpiMidqr6SbIjpGgcIGbDK1iyQwDai/e6rrRGHNt1+Dok13mBwCyagGwL3vQVs1Lulp
         9ZZ68VHUMI58LXuvXkrPkI4Cr//Lh915Zeerglj0Z/WGA+Bhw6Mm8mBlDr7aZX9QLfK+
         DoZZA8DiMDZEYXBsttC4gqPLUFXfM3sYF9sSG6HRgqvIpE3+Mevl0RlZ+ZfIZFlHPPaM
         IBpR3cdT6k3+RjbMBOmBnY0ps/U/9SMwVjHgGCsEIKlDDpuCViXIdYRamfcrsoHlMjOy
         w5CA==
X-Gm-Message-State: AOAM531BSn7b3t7cm6DYpYtzDvJ5veOgFheBCwbSXWjAPMJ2pMHbP7lK
        TjsGke6JI11+Yl5jmsCjVWNU7S19hXTBAQ==
X-Google-Smtp-Source: ABdhPJzUILzsHNzgD3kGHIk+m/0yoppn46ogLqS4DxmvumP+WhEnm8jzrcbKJbRZCMHomCDwmNO0gw==
X-Received: by 2002:a17:90a:e98d:: with SMTP id v13mr6399048pjy.79.1600311733772;
        Wed, 16 Sep 2020 20:02:13 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id b2sm12072498pfp.3.2020.09.16.20.02.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 20:02:12 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 1/5] devlink: add timeout information to status_notify
Date:   Wed, 16 Sep 2020 20:02:00 -0700
Message-Id: <20200917030204.50098-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200917030204.50098-1-snelson@pensando.io>
References: <20200917030204.50098-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a timeout element to the DEVLINK_CMD_FLASH_UPDATE_STATUS
netlink message for use by a userland utility to show that
a particular firmware flash activity may take a long but
bounded time to finish.  Also add a handy helper for drivers
to make use of the new timeout value.

UI usage hints:
 - if non-zero, add timeout display to the end of the status line
 	[component] status_msg  ( Xm Ys : Am Bs )
     using the timeout value for Am Bs and updating the Xm Ys
     every second
 - if the timeout expires while awaiting the next update,
   display something like
 	[component] status_msg  ( timeout reached : Am Bs )
 - if new status notify messages are received, remove
   the timeout and start over

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 include/net/devlink.h        |  4 ++++
 include/uapi/linux/devlink.h |  3 +++
 net/core/devlink.c           | 29 +++++++++++++++++++++++------
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index eaec0a8cc5ef..f206accf80ad 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1400,6 +1400,10 @@ void devlink_flash_update_status_notify(struct devlink *devlink,
 					const char *component,
 					unsigned long done,
 					unsigned long total);
+void devlink_flash_update_timeout_notify(struct devlink *devlink,
+					 const char *status_msg,
+					 const char *component,
+					 unsigned long timeout);
 
 int devlink_traps_register(struct devlink *devlink,
 			   const struct devlink_trap *traps,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 40d35145c879..4a6e213cfa04 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -460,6 +460,9 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_PORT_EXTERNAL,		/* u8 */
 	DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,	/* u32 */
+
+	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,	/* u64 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 19037f114307..01f855e53e06 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3024,7 +3024,9 @@ static int devlink_nl_flash_update_fill(struct sk_buff *msg,
 					enum devlink_command cmd,
 					const char *status_msg,
 					const char *component,
-					unsigned long done, unsigned long total)
+					unsigned long done,
+					unsigned long total,
+					unsigned long timeout)
 {
 	void *hdr;
 
@@ -3052,6 +3054,9 @@ static int devlink_nl_flash_update_fill(struct sk_buff *msg,
 	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,
 			      total, DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,
+			      timeout, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
 
 out:
 	genlmsg_end(msg, hdr);
@@ -3067,7 +3072,8 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 					  const char *status_msg,
 					  const char *component,
 					  unsigned long done,
-					  unsigned long total)
+					  unsigned long total,
+					  unsigned long timeout)
 {
 	struct sk_buff *msg;
 	int err;
@@ -3081,7 +3087,7 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 		return;
 
 	err = devlink_nl_flash_update_fill(msg, devlink, cmd, status_msg,
-					   component, done, total);
+					   component, done, total, timeout);
 	if (err)
 		goto out_free_msg;
 
@@ -3097,7 +3103,7 @@ void devlink_flash_update_begin_notify(struct devlink *devlink)
 {
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE,
-				      NULL, NULL, 0, 0);
+				      NULL, NULL, 0, 0, 0);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_begin_notify);
 
@@ -3105,7 +3111,7 @@ void devlink_flash_update_end_notify(struct devlink *devlink)
 {
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE_END,
-				      NULL, NULL, 0, 0);
+				      NULL, NULL, 0, 0, 0);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_end_notify);
 
@@ -3117,10 +3123,21 @@ void devlink_flash_update_status_notify(struct devlink *devlink,
 {
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
-				      status_msg, component, done, total);
+				      status_msg, component, done, total, 0);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
 
+void devlink_flash_update_timeout_notify(struct devlink *devlink,
+					 const char *status_msg,
+					 const char *component,
+					 unsigned long timeout)
+{
+	__devlink_flash_update_notify(devlink,
+				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
+				      status_msg, component, 0, 0, timeout);
+}
+EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
+
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
-- 
2.17.1

