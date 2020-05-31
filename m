Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20C81E9601
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 09:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgEaHGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 03:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgEaHGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 03:06:40 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F678C05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:06:40 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x14so8288792wrp.2
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qXOsLRWOxhLNoFMu89LdsxTD7a2Zk6hJGB1S7/GPv44=;
        b=gp+KTcu53hmYWMDsGV23Bhp+ktOsiT9nJEmyurR6CWeR+4RfasCM8XMLkOUrAmgAzm
         cxft9ag6eIQ8Wmnodlwkp2RuQ8N/k+g4FkTSNl5UlkI2joRTff1qpbaBcrRG+4hPO71W
         dYs6Gr1zYnISDIXrh15QlhT6/QP22ypta7Sck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qXOsLRWOxhLNoFMu89LdsxTD7a2Zk6hJGB1S7/GPv44=;
        b=IEszP1FvYw7HzpaLGMcCM6+KtbPTbLwFT4ATSZWc8KtS8M8TkvfxRrNQQh7azGnvB6
         GI9MhMN2gg5/kUq+o0iycF/RaCSWdjE1G4DWskrIzH0arlXVDSa5LbNFHK8Fuqn/FXTh
         a5Gmtr7GIoTz29VX4p7r7Qn1nULa4evKMca9znwPH5gVhmJbK7mzr0l5y5H+Ycv3UVCW
         Q/L832DOHdZlU41lEtSH7qr9pzhgiAyn6R310NnBJ/3+UW3E/a/1NK51e60XzzuQfpf+
         fcrpbknOwMjlJ+cDTN2oNrm3iQGIXP5uuOrxlSrDK8OzBF8zHrLt7nsgjoxX6rqz1eEE
         0a1A==
X-Gm-Message-State: AOAM5336xnNpR5/MzeBWSa4pZataqzikhkmvgphNI9xtHw9UULusLLac
        32moRtXUJmVUqRgLqnJyn7+3zA==
X-Google-Smtp-Source: ABdhPJwEZl32/U9WKPfEMQNrp/4oEoEsb5SIIboP9cLn5ClR87noI19pwdViiIWqgnNi3+GfCx3eHQ==
X-Received: by 2002:adf:f4d2:: with SMTP id h18mr16531498wrp.370.1590908798615;
        Sun, 31 May 2020 00:06:38 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5sm4828731wrr.5.2020.05.31.00.06.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 May 2020 00:06:38 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 net-next 2/6] devlink: Add 'allow_live_dev_reset' generic parameter.
Date:   Sun, 31 May 2020 12:33:41 +0530
Message-Id: <1590908625-10952-3-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This parameter is supported only when 'enable_live_dev_reset' is
true. The purpose of this parameter is to allow the user on a
host to temporarily disable the live reset feature of the device.

For example, if a host is running a mission critical application,
a user from the host can set this parameter to false, to avoid
a potential live reset from disrupting it.

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/devlink-params.rst | 20 ++++++++++++++++++++
 include/net/devlink.h                               |  4 ++++
 net/core/devlink.c                                  |  5 +++++
 3 files changed, 29 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 8e12c83..450fe18 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -116,3 +116,23 @@ own name.
        For example, after flashing a new firmware image, this feature allows the
        user to initiate the reset immediately from a separate command, to load
        the new firmware without reloading the driver or resetting the system.
+
+       A user can set the 'allow_live_dev_reset' parameter to false to
+       momentarily disable the live reset capability.
+   * - ``allow_live_dev_reset``
+     - Boolean
+     - This parameter is supported only when 'enable_live_dev_reset' is true.
+       The purpose of this parameter is to allow the user on a host to
+       temporarily disable the live reset feature of the device. When this
+       parameter is set to true from all the hosts in a multi-host environment
+       for example, a user from any host can initiate live device reset from any
+       of the host drivers.
+
+       For the parameter to be true, all the loaded host drivers must support
+       the live reset and the parameter must be set to true for all the host
+       drivers. For example, if any of the host (in case of multi-host NIC) is
+       loaded with an old driver which is not aware of the feature, then the
+       value of the parameter will be false until the old driver is upgraded
+       or unloaded. Also if the user has set the parameter to false on one of
+       the host (say A), the parameter will be false for all the hosts until the
+       user sets the parameter to true in the host (A).
diff --git a/include/net/devlink.h b/include/net/devlink.h
index eb28fa1..d922033 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -407,6 +407,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_LIVE_DEV_RESET,
+	DEVLINK_PARAM_GENERIC_ID_ALLOW_LIVE_DEV_RESET,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -447,6 +448,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_LIVE_DEV_RESET_NAME "enable_live_dev_reset"
 #define DEVLINK_PARAM_GENERIC_ENABLE_LIVE_DEV_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_ALLOW_LIVE_DEV_RESET_NAME "allow_live_dev_reset"
+#define DEVLINK_PARAM_GENERIC_ALLOW_LIVE_DEV_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7b52b38..e36f6c4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3016,6 +3016,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_LIVE_DEV_RESET_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_LIVE_DEV_RESET_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ALLOW_LIVE_DEV_RESET,
+		.name = DEVLINK_PARAM_GENERIC_ALLOW_LIVE_DEV_RESET_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ALLOW_LIVE_DEV_RESET_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
1.8.3.1

