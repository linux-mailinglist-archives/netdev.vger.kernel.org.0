Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E620930004A
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbhAVK2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbhAVJsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:48:15 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8484C0612F2
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:54 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id l12so4453255wry.2
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3CJBWdmmuIVGSAaJQ98fpqfgSJ52GyocxZJKQQiyfPA=;
        b=tZNFkAvwc+RAx2xah3HLCioBZ4UK5TOVmsipdA4FNObkJUq9HjpifXfEFyp/0nRERp
         Q8TrnO7MVrdRtpf/eQIHhD7sDm2Y6u4EvGB2RiaIJDXyu1PqogXdhyFQgJk0WGJBYuvT
         bsUlca2Ch83aVvgKrvXKHz7/xej6cvpGGPXjT+yPkEX1exfpLJqXmzt7UJzcELRb3v1P
         bH4r23zevgE3c0t+gBPnZPcmMn9mt3qf+f5gOayCLF5MdBRijlXKEcfnm35xXNLsamtP
         zTx/mvvCI7MPkUGqMFBe1cCUlH3sM+d2ZeKmvbcDPrO7YBVg1G+qiT3fjW79V+ToMTqO
         Mlrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3CJBWdmmuIVGSAaJQ98fpqfgSJ52GyocxZJKQQiyfPA=;
        b=YsXBxsmLEos8UxBpB7AcFVGUH9Kqtt55ekcmf3nkn002Zug9UZ4bTs80uo6z1RIYFL
         fy9LRw7kHpOXSNzIFSlJcfVEXmRAcHo0QfQL+XVcIAhMc7jJY4VXX+H+g4LYgDL6cToZ
         FfpIEOHj/O00PtW3wKxdCXo5AACDAl2AgN8t3aCJ4Jx+zmO3uPgdogvcWND+SYx1b+kE
         Cw8v2bWlrW5WeMtokhx5fzJfZgAP+cKFngn1XEPzKWIOvzgbF4tndhhi5/6pW86LKEPH
         +cXgraZntLu58iGnhkEe/3V7o1ls7SSjRbEVTz1cGcztGr9njOsCLBbDaDC4FE5GJFlw
         5t1g==
X-Gm-Message-State: AOAM530PuLsJmzPu54UeX3oJg0et9muQ5SkK5f7C/3s4J1VpDWlbXVxI
        dxRdOT9NFpZYHMnUDHb/StaGhm+cfUt+DUkRqKU=
X-Google-Smtp-Source: ABdhPJw0XE7ycxCWYbSidwP5Zt+kEIWFqwR2j9SZqJxazBJuMqY048jtxecA/sv299+PzDCFQYntpQ==
X-Received: by 2002:a5d:47ce:: with SMTP id o14mr3741925wrc.18.1611308813268;
        Fri, 22 Jan 2021 01:46:53 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id s25sm12862897wrs.49.2021.01.22.01.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 01:46:52 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, andrew@lunn.ch, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: [patch net-next RFCv2 03/10] devlink: implement line card active state
Date:   Fri, 22 Jan 2021 10:46:41 +0100
Message-Id: <20210122094648.1631078-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122094648.1631078-1-jiri@resnulli.us>
References: <20210122094648.1631078-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Allow driver to mark a linecard as active. Expose this state to the
userspace over devlink netlink interface with proper notifications.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- s/deactive/inactive in function comment
- removed is_active() helper which is no longer needed
---
 include/net/devlink.h        |  3 +++
 include/uapi/linux/devlink.h |  1 +
 net/core/devlink.c           | 30 ++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index bca3b2fc180a..f3b0e88add90 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -149,6 +149,7 @@ struct devlink_linecard {
 	void *priv;
 	enum devlink_linecard_state state;
 	const char *type;
+	bool active;
 };
 
 /**
@@ -1445,6 +1446,8 @@ void devlink_linecard_provision_set(struct devlink_linecard *linecard,
 				    u32 type_index);
 void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
 void devlink_linecard_provision_fail(struct devlink_linecard *linecard);
+void devlink_linecard_activate(struct devlink_linecard *linecard);
+void devlink_linecard_deactivate(struct devlink_linecard *linecard);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 24091391fa89..a27b20dc38b8 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -336,6 +336,7 @@ enum devlink_linecard_state {
 	DEVLINK_LINECARD_STATE_PROVISIONING,
 	DEVLINK_LINECARD_STATE_PROVISIONING_FAILED,
 	DEVLINK_LINECARD_STATE_PROVISIONED,
+	DEVLINK_LINECARD_STATE_ACTIVE,
 
 	__DEVLINK_LINECARD_STATE_MAX,
 	DEVLINK_LINECARD_STATE_MAX = __DEVLINK_LINECARD_STATE_MAX - 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2ff950da3417..1725820dd045 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8826,6 +8826,36 @@ void devlink_linecard_provision_fail(struct devlink_linecard *linecard)
 }
 EXPORT_SYMBOL_GPL(devlink_linecard_provision_fail);
 
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
+ *	devlink_linecard_deactivate - Set linecard inactive
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
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
-- 
2.26.2

