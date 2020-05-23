Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D881DF523
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387652AbgEWGKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387446AbgEWGKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 02:10:48 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB16C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 23:10:48 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t7so5290911plr.0
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 23:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NsdPDPhvg6w2xU4D8glYoYRtISsgYmK5RbzNhpNLe0Y=;
        b=BWuAP2ln1aRWDvNEIAjjF6QRH4oubG3z68MEJyfDCh5c0MAQaKyHdTUJNk4ESI2EeN
         LySynWQDeGWNWykDCmUWLbciMTwpjIqT4vvubu0ikNCBNO5MAlNwZydifJSRA0Ss69kf
         y/sbyxiuVirz4RcbgpJ4u9pCjQySDRlPYOwNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NsdPDPhvg6w2xU4D8glYoYRtISsgYmK5RbzNhpNLe0Y=;
        b=njSnDsaBr1DVesNvEUklJY/MWByjyZd0oSUxV/GRPW5GZBg3HV/1bQpuzDmjIDxWkS
         zKG9bXvrRSL2nPkWdPBWpmgwNoFgNFSWcmREDB0/AhGQyngztRnaGwl2ig9H4IeyI3fP
         FX7wT8hJh19KIcn52UFb2rNOnR8RbX3quyOWGYvnR1537mWmeOjMUHo6wq9hiVYeUqTy
         V9Q4XL1I2DE8BrICZCsH7N+UWdS631SB4Ij6Nx8H1f4ThW42r0GQ4DWldcY+w6/HgKC2
         DQH9MjNUDrjhRYe7J8Ra8GMV7lYLrAilQT+zHpm/E22bfGcT7JCajal0Sty/caIP0SlS
         UROg==
X-Gm-Message-State: AOAM530vtI8Nh2nEoUKzHbe1kwhoEFwIs2iTwi14FVdMZrHExCf40LWw
        RhMsyRbJ0GBTAxiD87XxsJHC20FrBfw=
X-Google-Smtp-Source: ABdhPJwICf2+cqlw1iPdLPIeLKDXF5nGdnBZ1+yYIVJdQknbfl76t/BAdB9kCnsVCVSuVf0CIWjXDw==
X-Received: by 2002:a17:902:a713:: with SMTP id w19mr17031069plq.296.1590214247842;
        Fri, 22 May 2020 23:10:47 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 1sm8455414pff.180.2020.05.22.23.10.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 May 2020 23:10:47 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset" generic device parameter.
Date:   Sat, 23 May 2020 11:38:22 +0530
Message-Id: <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new "allow_fw_live_reset" generic device bool parameter. When
parameter is set, user is allowed to reset the firmware in real time.

This parameter is employed to communicate user consent or dissent for
the live reset to happen. A separate command triggers the actual live
reset.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
v2: Rename param name to "allow_fw_live_reset" from
"enable_hot_fw_reset".
Update documentation for the param in devlink-params.rst file.
---
 Documentation/networking/devlink/devlink-params.rst | 6 ++++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index d075fd0..ad54dfb 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -108,3 +108,9 @@ own name.
    * - ``region_snapshot_enable``
      - Boolean
      - Enable capture of ``devlink-region`` snapshots.
+   * - ``allow_fw_live_reset``
+     - Boolean
+     - Firmware live reset allows users to reset the firmware in real time.
+       For example, after firmware upgrade, this feature can immediately reset
+       to run the new firmware without reloading the driver or rebooting the
+       system.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8ffc1b5c..488b61c 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -406,6 +406,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
 	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+	DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -443,6 +444,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
 #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME "allow_fw_live_reset"
+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7b76e5f..8544f23 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3011,6 +3011,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
+		.name = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
1.8.3.1

