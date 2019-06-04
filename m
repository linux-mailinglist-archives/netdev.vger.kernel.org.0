Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106C13491C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfFDNkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:40:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50702 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbfFDNkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:40:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id f204so122842wme.0
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LqCpEewingXpXNI3Gonjczp4EX39Pl7TPMX6knIKouY=;
        b=fFu6XkehC9bPNCz/uayLpBq2LKJwgZ1FyoSG0G41+Hjl9mhqM+RIpQI2Hdv3JNjcxH
         460N46BuIeSAyEeQB6ACqSRt3wD0dIyUBeiWY+TTElo7OyI0e+4dXX2bZxbE1WLblQLQ
         n30AaJABYolP8prbs9YKAacj00MEfOg/NZVeNrjrRdi4RPB7Ipysjc5mqXTE0woJme//
         jBRv8SGiajR7pQ7vZhhAFjkduer9j4axWQaSrLYfJSCYsVVQGLaL3vntzUbfrR6uCSJt
         ecI3P3+f1JCwItmxBj6MN1s5eaC5/Mz/xG+fQ1sk2XeIpWN3ivDZfRc4wP3ij6hWwdO5
         HA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LqCpEewingXpXNI3Gonjczp4EX39Pl7TPMX6knIKouY=;
        b=LyUlTDyQar4lOpXpZyJFgxES3bQykrAt0HJw1tLpIgMtz+4BIFeal7I+SsRY7AENKL
         1v9ziea4eFObz4DbSXj2g4jVbdmpGZGps2j4gqntKoio1Hu6vYMKIiH0v4vEsMdv/kyO
         yH1pyRGYgRQtmmUi36Mxe6rtEk1GnkXp7hEp/RHM9CH7qWNI84aTO0+yKiS5iWt97k41
         4acPuYMy0k3ENJXgE4umbQ+h9pRiJ/rCsJ3rkpaRvugAWvEPhvvvSRkrkJeJ9iIIuDyT
         DeT3N98WYshvQgOxWHwkOfDj+Va5obNeMIGOyL4VQSbcHDozSldPNw+kOGoOK0g6BpkW
         8RDg==
X-Gm-Message-State: APjAAAX0LJeWZA+ss9o99c3w9YCaG/HeVf97FVJCa4pU5G/DRO4+iCY0
        SRUUHVpCerexpXqMTTdAR4VnbYGt7MjIsr8z
X-Google-Smtp-Source: APXvYqwD0INUMDH2OpZeDtYlTW4cb1YJ0p7ij6SuTx0as6Kxz4gEk6ZC0WIJCcnv4pUNV5OiCqEG2A==
X-Received: by 2002:a05:600c:2116:: with SMTP id u22mr6106596wml.58.1559655649867;
        Tue, 04 Jun 2019 06:40:49 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id c5sm17229434wma.19.2019.06.04.06.40.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:40:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v3 4/8] devlink: allow driver to update progress of flash update
Date:   Tue,  4 Jun 2019 15:40:40 +0200
Message-Id: <20190604134044.2613-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce a function to be called from drivers during flash. It sends
notification to userspace about flash update progress.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
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

