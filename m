Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9EF2F4B10
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbhAMMNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbhAMMNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:13:09 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1FBC061795
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:29 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id c5so1871499wrp.6
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q5KdQEKor/xNGEAiee3yVmkHYi5dKtkCDib7jFEW8Bw=;
        b=KWeB45D/RpQ9wwN/+e0VrDWH/jVH0ofcnDlw0HKXuXdYNAWC6EeJB1fx/CutZH60z8
         gLqKIY1pMoCQ4GGPMdpUy/eQw63DQfw+GgL2V8UtaOEZkquUE+akUil+9q1UDK/4KY3h
         uTrovYNDVXIf1D7ThrrryCWvX22UmUTPuW8EiD3LfZ2PDjr5O1p4ZS4m/lOZ8GD4nj72
         XGnaeuTzYtLi2G9dUVhNICe0Im68rSyGg+rPJwpG3KEOywh7DyPbTOOlMnRrCg4LBvkC
         8oufVJm1e5a8XGNVmqMb+TWJCqKuurvc/BGIGeDaghkZhrZD0bkRpyNS9eC+f4ffwWYV
         rQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q5KdQEKor/xNGEAiee3yVmkHYi5dKtkCDib7jFEW8Bw=;
        b=gT5tW+s3z07ur/kC1PF94RfHvNa59Amn0Q0Dq3PvegnYHkpF4ZvJZ5YRNhrM3S/fYf
         4YUcEqmQQh0TJ5v16tKernLlm0UM2i9z5UymROQwWllrOhASJCS9FTbW2UM8O97qx1fF
         wT1ugl2cCrbInowEZejXLvwiAOC3zOYujj5MkX2hlq4nKWAhz8derrVmcrl1NhkkUVGU
         ZC5ZXA+rvR2oCuwdpoZ3yF9hudbJmxRCjgpz+3iUbTvcK3BbTzdJg0c8jnl9a2FGGiEY
         LVaEeNCH40ANWdAJbvHmkC9Ofpj0aVE9bXmHeiA2G/k8BXskodidVzVQ+LniW/axyrM0
         PxKw==
X-Gm-Message-State: AOAM531cRiO8mTpZhvctxSwZNTIwqLH0ueZicSEzjrksM574AS7U77hM
        345mMlvh9QNAlIUynqtdzqXphCJA2OBTmEPP
X-Google-Smtp-Source: ABdhPJwv4982CaJB4sNJTeOPxXPZqtpeLm/c6XReG66v8100IMmVnyyFnEKNrE7Q9ZKQ/adHh3Rl2g==
X-Received: by 2002:a05:6000:222:: with SMTP id l2mr2275189wrz.392.1610539947204;
        Wed, 13 Jan 2021 04:12:27 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id l20sm3237356wrh.82.2021.01.13.04.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 04:12:26 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, mlxsw@nvidia.com
Subject: [patch net-next RFC 03/10] devlink: implement line card active state
Date:   Wed, 13 Jan 2021 13:12:15 +0100
Message-Id: <20210113121222.733517-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113121222.733517-1-jiri@resnulli.us>
References: <20210113121222.733517-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Allow driver to mark a lin ecards as active. Expose this state to the
userspace over devlink netlink interface with proper notifications.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h        |  4 ++++
 include/uapi/linux/devlink.h |  1 +
 net/core/devlink.c           | 46 ++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 854abd53e9ea..ec00cd94c626 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -149,6 +149,7 @@ struct devlink_linecard {
 	void *priv;
 	enum devlink_linecard_state state;
 	const char *provisioned_type;
+	bool active;
 };
 
 /**
@@ -1444,6 +1445,9 @@ void devlink_linecard_destroy(struct devlink_linecard *linecard);
 void devlink_linecard_provision_set(struct devlink_linecard *linecard,
 				    u32 type_index);
 void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
+void devlink_linecard_activate(struct devlink_linecard *linecard);
+void devlink_linecard_deactivate(struct devlink_linecard *linecard);
+bool devlink_linecard_is_active(struct devlink_linecard *linecard);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 4111ddcc000b..d961d31fe288 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -338,6 +338,7 @@ enum devlink_linecard_state {
 	DEVLINK_LINECARD_STATE_UNPROVISIONING,
 	DEVLINK_LINECARD_STATE_PROVISIONING,
 	DEVLINK_LINECARD_STATE_PROVISIONED,
+	DEVLINK_LINECARD_STATE_ACTIVE,
 
 	__DEVLINK_LINECARD_STATE_MAX,
 	DEVLINK_LINECARD_STATE_MAX = __DEVLINK_LINECARD_STATE_MAX - 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 434eecc310c3..9c76edf8c8af 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8790,6 +8790,52 @@ void devlink_linecard_provision_clear(struct devlink_linecard *linecard)
 }
 EXPORT_SYMBOL_GPL(devlink_linecard_provision_clear);
 
+/**
+ *	devlink_linecard_activate - Set linecard active
+ *
+ *	@devlink_linecard: devlink linecard
+ */
+void devlink_linecard_activate(struct devlink_linecard *linecard)
+{
+	mutex_lock(&linecard->devlink->lock);
+	WARN_ON(linecard->state != DEVLINK_LINECARD_STATE_PROVISIONED);
+	linecard->state = DEVLINK_LINECARD_STATE_ACTIVE;
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	mutex_unlock(&linecard->devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_activate);
+
+/**
+ *	devlink_linecard_deactivate - Set linecard deactive
+ *
+ *	@devlink_linecard: devlink linecard
+ */
+void devlink_linecard_deactivate(struct devlink_linecard *linecard)
+{
+	mutex_lock(&linecard->devlink->lock);
+	WARN_ON(linecard->state != DEVLINK_LINECARD_STATE_ACTIVE);
+	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONED;
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	mutex_unlock(&linecard->devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_deactivate);
+
+/**
+ *	devlink_linecard_is_active - Check if active
+ *
+ *	@devlink_linecard: devlink linecard
+ */
+bool devlink_linecard_is_active(struct devlink_linecard *linecard)
+{
+	bool active;
+
+	mutex_lock(&linecard->devlink->lock);
+	active = linecard->state == DEVLINK_LINECARD_STATE_ACTIVE;
+	mutex_unlock(&linecard->devlink->lock);
+	return active;
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_is_active);
+
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
-- 
2.26.2

