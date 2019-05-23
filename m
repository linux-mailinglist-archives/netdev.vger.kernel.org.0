Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100AF2799A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbfEWJp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:45:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53424 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730028AbfEWJp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:45:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id 198so5091703wme.3
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 02:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=epU2k/cBEMzaegX+zA+I0N6IA/FvNv2FtO4ZKvLQ00Y=;
        b=ZBe9K0XSwAQj9W6PSQokqv7jmYPGcXUPROyXsc8UuMplfHpayDk8+tN+98FEdUUHCv
         ZUSYYXGpbJHqEDa+xMlGG2tTzt/cE1aHVfoFQ3WBxOD0poGF9z1OF//YZ3LniLWrM+t2
         FjQ0xeNjPyqXQjsWrfY8iTqLWK+85swBYAiZn5JLkt3kW3Igkbhpv7HYwC/eImKlhGH4
         zyEDYtNQ6QJNujbKtykOc1QjHmXyZN6WwQoQ7gjjDOTl60T5pi4u0OmpGWgTJzz5zvAu
         kHUAcSe4CVbWs5tnFal7tlQmQVHBoRZdzOjmDj6WH5SqKZ9mA6kViSMcybiePmWDjpCG
         9sdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=epU2k/cBEMzaegX+zA+I0N6IA/FvNv2FtO4ZKvLQ00Y=;
        b=ZE5hji1k0Q/ATrxSYDvheh9elWs3z4WvGXZ83ZOncvpjFvMMs/vtosx6iSeoeFjNAv
         HWLPc00WKgI8ioOjmc7wAoCjEtDY2H4YU0nAPLyY02hTJ7b90CPlmURwu4Gn/KRhfNlW
         ONJOqT0J6E+Uo6IUNmER9B8gTvoZIw+BilR38lVCQ0KdGi37jZAUETc6uf1P2876v5JE
         qh3AMEa8QAbK47wZn21nh+lV5+PfUgX8HdecQRs7FKYoHX/ETOumd6SEcwrXpyPrd6h/
         dRt88kjceD1mG+ZgKeobNaMU8kYe4anymYllFCLWF0UKfubWmSgHIVcUqd4tQnRmhznk
         80HQ==
X-Gm-Message-State: APjAAAXXj6+WJ4zBT0qFdTUqIaQYfRcn43yGfuvQcQmfyk4LqAAKH7zZ
        WP9meRpPyLZl+0kGEOyOD5ZUQlu2NFo=
X-Google-Smtp-Source: APXvYqxA/kmtmReXTao70Q4iB5EQ2R1qEiPpHvKxfsAFnv824f4KtJlH9kl1EtS5yWssvleY1fQEIw==
X-Received: by 2002:a7b:c189:: with SMTP id y9mr11531257wmi.116.1558604724496;
        Thu, 23 May 2019 02:45:24 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id i27sm7784980wmb.16.2019.05.23.02.45.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 02:45:15 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org
Subject: [patch net-next 4/7] devlink: allow driver to update progress of flash update
Date:   Thu, 23 May 2019 11:45:07 +0200
Message-Id: <20190523094510.2317-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190523094510.2317-1-jiri@resnulli.us>
References: <20190523094510.2317-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce a function to be called from drivers during flash. It sends
notification to userspace about flash update progress.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h        |   8 +++
 include/uapi/linux/devlink.h |   5 ++
 net/core/devlink.c           | 102 +++++++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 151eb930d329..8f65356132be 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -741,6 +741,14 @@ void
 devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
 				     enum devlink_health_reporter_state state);
 
+void devlink_flash_update_begin_notify(struct devlink *devlink);
+void devlink_flash_update_end_notify(struct devlink *devlink);
+void devlink_flash_update_status_notify(struct devlink *devlink,
+					const char *status_msg,
+					const char *component,
+					unsigned long done,
+					unsigned long total);
+
 #if IS_ENABLED(CONFIG_NET_DEVLINK)
 
 void devlink_compat_running_version(struct net_device *dev,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 5bb4ea67d84f..5287b42c181f 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -104,6 +104,8 @@ enum devlink_command {
 	DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR,
 
 	DEVLINK_CMD_FLASH_UPDATE,
+	DEVLINK_CMD_FLASH_UPDATE_END,		/* notification only */
+	DEVLINK_CMD_FLASH_UPDATE_STATUS,	/* notification only */
 
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
@@ -331,6 +333,9 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME,	/* string */
 	DEVLINK_ATTR_FLASH_UPDATE_COMPONENT,	/* string */
+	DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG,	/* string */
+	DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,	/* u64 */
+	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,	/* u64 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9716a7f382cb..963178d32dda 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2673,6 +2673,108 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	return devlink->ops->reload(devlink, info->extack);
 }
 
+static int devlink_nl_flash_update_fill(struct sk_buff *msg,
+					struct devlink *devlink,
+					enum devlink_command cmd,
+					const char *status_msg,
+					const char *component,
+					unsigned long done, unsigned long total)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(msg, 0, 0, &devlink_nl_family, 0, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+
+	if (cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS)
+		goto out;
+
+	if (status_msg &&
+	    nla_put_string(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG,
+			   status_msg))
+		goto nla_put_failure;
+	if (component &&
+	    nla_put_string(msg, DEVLINK_ATTR_FLASH_UPDATE_COMPONENT,
+			   component))
+		goto nla_put_failure;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,
+			      done, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,
+			      total, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+out:
+	genlmsg_end(msg, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static void __devlink_flash_update_notify(struct devlink *devlink,
+					  enum devlink_command cmd,
+					  const char *status_msg,
+					  const char *component,
+					  unsigned long done,
+					  unsigned long total)
+{
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
+		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
+		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_flash_update_fill(msg, devlink, cmd, status_msg,
+					   component, done, total);
+	if (err)
+		goto out_free_msg;
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+	return;
+
+out_free_msg:
+	nlmsg_free(msg);
+}
+
+void devlink_flash_update_begin_notify(struct devlink *devlink)
+{
+	__devlink_flash_update_notify(devlink,
+				      DEVLINK_CMD_FLASH_UPDATE,
+				      NULL, NULL, 0, 0);
+}
+EXPORT_SYMBOL_GPL(devlink_flash_update_begin_notify);
+
+void devlink_flash_update_end_notify(struct devlink *devlink)
+{
+	__devlink_flash_update_notify(devlink,
+				      DEVLINK_CMD_FLASH_UPDATE_END,
+				      NULL, NULL, 0, 0);
+}
+EXPORT_SYMBOL_GPL(devlink_flash_update_end_notify);
+
+void devlink_flash_update_status_notify(struct devlink *devlink,
+					const char *status_msg,
+					const char *component,
+					unsigned long done,
+					unsigned long total)
+{
+	__devlink_flash_update_notify(devlink,
+				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
+				      status_msg, component, done, total);
+}
+EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
+
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
-- 
2.17.2

