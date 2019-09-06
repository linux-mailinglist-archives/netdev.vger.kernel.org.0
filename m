Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 696C6ABD31
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395025AbfIFQBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:01:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44591 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfIFQBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:01:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id 30so7106377wrk.11
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cQM8y3SyXrcUvODCK1LQLKm1BW+/BGm1Zw6QSw7VtKU=;
        b=QnX105rc78G2A+TQu5KVgKRaqgJCrcOeQAPRyn5rDkTUT07/+eSz2yyz9VuxvyfF4n
         D4wTOycehf682XbDD8E1GK9GcfEMP5ALA1CIkacdFXGqoWzL1Ahgqcd5KD3cMI9DE8k5
         GGnSkKL/CZMnAYQkAMSurHtkMgCWdC0j+iSBMYNgy8WNmiBTqsZm2mRrSoBfw7g4nkOA
         lgd96uzXw7lMfO/IUpIy7lFNBvFDAQ8ikiM4Z3UrM+wCKjVVsYL21cStaZIBsrHy1zkq
         nDWX1uVx/z9jq5oI7sYtTgb798BMPvlqEdyhAGTATGJnHeNm3OyOu7Dovx4f1JUN5vUN
         y3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cQM8y3SyXrcUvODCK1LQLKm1BW+/BGm1Zw6QSw7VtKU=;
        b=Hlj6gvwhV17oD5Q6wIzPWLBEA3lThbrhxTgtG4m0K30C1Bij+hX8r4XP9IpApYyzIb
         rnkWyYV8gWExGYVaRF5mtlQeuvzd8XjtBULExMlZiQG+GUxC4ej0umc9RhDmW2ci10Rz
         vBjJMfnR85qzlaDXiELVFSqGPl40o/w6+kF7hqHOu8G1/1BqANOF25U14zpXbNf0tEZx
         jjw4O6t6pLplMRp68hLM1m4szNcMEJlZZUBXmmZoXUAv01Iw+6hEmsoyqjfQObyu20j3
         GsBj9utx6M21bWRSXVGQsPduVSqOXFVhLGsOSGKgj297jdrREDre535zvuwGzaL0te0K
         E7gA==
X-Gm-Message-State: APjAAAWBUK20lc138YKIV8Pp+uRUswvJtcyIwl5D03CFQ4bJyRASfoJJ
        a35wni+Xa6WgSUzM4InE8v6iGA==
X-Google-Smtp-Source: APXvYqxtfcsRKhoGicFH1HbXgwRF6UfDoFt1txnl7+dobn3nZ9i34Fwbrd6bpcuMyTINADkYCBryrg==
X-Received: by 2002:a5d:5606:: with SMTP id l6mr7444837wrv.108.1567785673691;
        Fri, 06 Sep 2019 09:01:13 -0700 (PDT)
Received: from reginn.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id s1sm8524567wrg.80.2019.09.06.09.01.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:01:13 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [net-next 02/11] devlink: add 'reset_dev_on_drv_probe' param
Date:   Fri,  6 Sep 2019 18:00:52 +0200
Message-Id: <20190906160101.14866-3-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906160101.14866-1-simon.horman@netronome.com>
References: <20190906160101.14866-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Add the 'reset_dev_on_drv_probe' devlink parameter, controlling the
device reset policy on driver probe.

This parameter is useful in conjunction with the existing
'fw_load_policy' parameter.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 Documentation/networking/devlink-params.txt | 14 ++++++++++++++
 include/net/devlink.h                       |  4 ++++
 include/uapi/linux/devlink.h                |  7 +++++++
 net/core/devlink.c                          |  5 +++++
 4 files changed, 30 insertions(+)

diff --git a/Documentation/networking/devlink-params.txt b/Documentation/networking/devlink-params.txt
index fadb5436188d..f9e30d686243 100644
--- a/Documentation/networking/devlink-params.txt
+++ b/Documentation/networking/devlink-params.txt
@@ -51,3 +51,17 @@ fw_load_policy		[DEVICE, GENERIC]
 			* DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK (2)
 			  Load firmware currently available on host's disk.
 			Type: u8
+
+reset_dev_on_drv_probe	[DEVICE, GENERIC]
+			Controls the device's reset policy on driver probe.
+			Valid values:
+			* DEVLINK_PARAM_RESET_DEV_VALUE_UNKNOWN (0)
+			  Unknown or invalid value.
+			* DEVLINK_PARAM_RESET_DEV_VALUE_ALWAYS (1)
+			  Always reset device on driver probe.
+			* DEVLINK_PARAM_RESET_DEV_VALUE_NEVER (2)
+			  Never reset device on driver probe.
+			* DEVLINK_PARAM_RESET_DEV_VALUE_DISK (3)
+			  Reset only if device firmware can be found in the
+			  filesystem.
+			Type: u8
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 460bc629d1a4..d880de5b8d3a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -398,6 +398,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_MSIX_VEC_PER_PF_MAX,
 	DEVLINK_PARAM_GENERIC_ID_MSIX_VEC_PER_PF_MIN,
 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
+	DEVLINK_PARAM_GENERIC_ID_RESET_DEV,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -428,6 +429,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_NAME "fw_load_policy"
 #define DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_TYPE DEVLINK_PARAM_TYPE_U8
 
+#define DEVLINK_PARAM_GENERIC_RESET_DEV_NAME "reset_dev_on_drv_probe"
+#define DEVLINK_PARAM_GENERIC_RESET_DEV_TYPE DEVLINK_PARAM_TYPE_U8
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index c25cc29a6647..3172d1b3329f 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -205,6 +205,13 @@ enum devlink_param_fw_load_policy_value {
 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK,
 };
 
+enum devlink_param_reset_dev_value {
+	DEVLINK_PARAM_RESET_DEV_VALUE_UNKNOWN,
+	DEVLINK_PARAM_RESET_DEV_VALUE_ALWAYS,
+	DEVLINK_PARAM_RESET_DEV_VALUE_NEVER,
+	DEVLINK_PARAM_RESET_DEV_VALUE_DISK,
+};
+
 enum {
 	DEVLINK_ATTR_STATS_RX_PACKETS,		/* u64 */
 	DEVLINK_ATTR_STATS_RX_BYTES,		/* u64 */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6e52d639dac6..e8bc96f104a7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2852,6 +2852,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_NAME,
 		.type = DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_RESET_DEV,
+		.name = DEVLINK_PARAM_GENERIC_RESET_DEV_NAME,
+		.type = DEVLINK_PARAM_GENERIC_RESET_DEV_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.11.0

