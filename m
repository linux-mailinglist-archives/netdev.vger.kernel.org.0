Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BBF1E9600
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 09:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgEaHG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 03:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgEaHG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 03:06:28 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F01C05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:06:28 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x13so8250004wrv.4
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zumKQmkO5e51NlQ/XewW19Eiw2uayLN6M0XGpwmfyZc=;
        b=Yf6/FCO3FFczNBrDKZreRpHjMqUc/1BLP2W2n3uAhiowl7ipkDpQxwaJ7CF1XWYuYH
         w/mNzBaCa/VGXnoK0ODOUr6zakA26FGKcxlrZXi+Wj67AwHItUWnG1bq740H1aE92rEf
         kgdD+nMzhdI6MeXfQuYX9rg6sf7yy0OfSHDWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zumKQmkO5e51NlQ/XewW19Eiw2uayLN6M0XGpwmfyZc=;
        b=PaKxI8hCMjmfYZtP1jBR5uzcBX/0TGXbDUtMsHhPqS8Au3nXCxi5S3YqgXM1daNNF/
         bVps17ftrocBOptEQbH+in4hXPQ3eGhefKCXlvmOVs7jpzwGTZkV9IVuZJnClmvukDO6
         r8zNK6Q7F11Cmz1MsEGm5LPZbbDN86ujLt2XC2DUsjI4NDupRpL9sUJgWYeED/aZJVJD
         q+n+j2CAT9xWyOsj+JM8wVnX/mSNJ0Xq6xRUZGQjqkCXJmZj5F/tQWshYACL6ie3FHgY
         dvPN/TWQa0N6RdicBWmbkEir4ensSlWjEWsfEQY6IomnZAhwFFQWc0G0abB9MWElwywR
         HuNA==
X-Gm-Message-State: AOAM532XNEs/U7szqkcFQRzsgzCMEqS6DmK9cAhma4VYuKcua7Q+44Xy
        hzeIHI7tSg7qeSNUPjOd/4R0xQ==
X-Google-Smtp-Source: ABdhPJzHcke0YT7pAEnmk2CrTzUFGHiXMApfP/a6kyNecRFlvrEQmBt+kjIq1XJqcTYC9z5pU7iTwg==
X-Received: by 2002:a5d:5261:: with SMTP id l1mr16759126wrc.246.1590908787118;
        Sun, 31 May 2020 00:06:27 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5sm4828731wrr.5.2020.05.31.00.06.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 May 2020 00:06:26 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 net-next 1/6] devlink: Add 'enable_live_dev_reset' generic parameter.
Date:   Sun, 31 May 2020 12:33:40 +0530
Message-Id: <1590908625-10952-2-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This parameter controls the device's live reset capability. When
enabled, a user can issue a separate command like 'ethtool --reset'
or 'devlink dev reload' to reset the entire device in real time.

This parameter can be useful, if the user wants to upgrade the
firmware quickly with a momentary network outage.

For example, if a user flashes a new firmware image and if this
parameter is enabled, the user can immediately initiate reset of
the device, to load the new firmware without reloading the driver
manually or resetting the system.

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/devlink-params.rst | 8 ++++++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 17 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index d075fd0..8e12c83 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -108,3 +108,11 @@ own name.
    * - ``region_snapshot_enable``
      - Boolean
      - Enable capture of ``devlink-region`` snapshots.
+   * - ``enable_live_dev_reset``
+     - Boolean
+     - Controls the device's live reset capability. When the parameter is true,
+       the user can use a separate command to reset the entire device in real
+       time, that resets the firmware and driver entities.
+       For example, after flashing a new firmware image, this feature allows the
+       user to initiate the reset immediately from a separate command, to load
+       the new firmware without reloading the driver or resetting the system.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8ffc1b5c..eb28fa1 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -406,6 +406,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
 	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_LIVE_DEV_RESET,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -443,6 +444,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
 #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_LIVE_DEV_RESET_NAME "enable_live_dev_reset"
+#define DEVLINK_PARAM_GENERIC_ENABLE_LIVE_DEV_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7b76e5f..7b52b38 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3011,6 +3011,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_LIVE_DEV_RESET,
+		.name = DEVLINK_PARAM_GENERIC_ENABLE_LIVE_DEV_RESET_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ENABLE_LIVE_DEV_RESET_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
1.8.3.1

