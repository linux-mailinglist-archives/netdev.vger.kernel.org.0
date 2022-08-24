Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE8B59F9AF
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbiHXMUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiHXMUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:20:17 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94A51DA63
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:20:15 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id q2so19671965edb.6
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=IbLQ2Yws+qV/E/TgSaYdSHADvbVeAsBq0GTLvE9fLfY=;
        b=izzxavC6rIJ2PoYDyoprVqqCSvkJ60UPNN2AQ35qKHH+F+uuOjdc7T1gh3I7Fg3qxk
         rWEMWpoAfQ4a1y9ScJTk/zWhGY3mF9T6sKdNEqe+c11qJzSs4S+AZjF+PbzvNyvnR9AJ
         ypC57XoinuzCDzcmnP/VHG6O/M2YwCecOpAWH7tY7V2U8lxU06wCzLOAsZfgl3NFED5g
         mXcRWPKxIJyGyLpkAt8JUjM14QOwCHNra5JawohppiZ3u8jpwhbD6xh74F/WUhpNcspG
         1nRSfDbVMu1OTElfVVJfjcMv4XzXt5kPGV0SkIpIYzh80bOAtrx1P6F21f0VwQrgD9BU
         rQSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=IbLQ2Yws+qV/E/TgSaYdSHADvbVeAsBq0GTLvE9fLfY=;
        b=Mnxf8d4k0AUMkSqWemZbO/nsjrIEe5twb8dEatatVXxnwxFtFJiBjhOw1UYUN73Sxk
         pN6ymynucxSvhOuo1JNKmI9hl3bu2eNeJzot5odt0xLbVnqB46YcH9y2AEUNp2jMQoaL
         N9ej/zkavhAxWR6StoKvc2388GLS2q3CcjkshkoY7XN/f/B7Yu9GqsOE+4MF9bYvyrH+
         MSWE/SD8rpeWn+khTK21z8EszNaGuGSsyhqA14VmskYzMdJjycqrxVnL4QGMXEsiOHTP
         bGpggPeghuyDLaTZPnM44RG65wmjNjp8Ex9n2Ecm3duPyGEfBlP7IzSNRSJEDk+sceY5
         eheA==
X-Gm-Message-State: ACgBeo2ZIhw98TH+q9KzyArRnC2Ah7n2p6gNo41daOyrb0S0y4z8OScB
        zlid7Pl1Qdk6aPSU4zwczIPLP0ncV7hUL2HE
X-Google-Smtp-Source: AA6agR6m9C9e1N3OcWoTDk4a43c7EMyoOkellRZBCYAcckN8J4HKw4qk5ZPZJndogkINdnzEZ7DzNg==
X-Received: by 2002:aa7:c9c2:0:b0:440:b458:9403 with SMTP id i2-20020aa7c9c2000000b00440b4589403mr7456962edt.132.1661343614345;
        Wed, 24 Aug 2022 05:20:14 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o24-20020a170906769800b0073d89c167a1sm1093728ejm.137.2022.08.24.05.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:20:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next v3 1/3] net: devlink: extend info_get() version put to indicate a flash component
Date:   Wed, 24 Aug 2022 14:20:09 +0200
Message-Id: <20220824122011.1204330-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220824122011.1204330-1-jiri@resnulli.us>
References: <20220824122011.1204330-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Whenever the driver is called by his info_get() op, it may put multiple
version names and values to the netlink message. Extend by additional
helper devlink_info_version_running/stored_put_ext() that allows to
specify a version type that indicates when particular version name
represents a flash component.

This is going to be used in follow-up patch calling info_get() during
flash update command checking if version with this the version type
exists.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
- added "stored" variant
v1->v2:
- split from v1 patch "net: devlink: extend info_get() version put to
  indicate a flash component", no code changes
---
 include/net/devlink.h | 16 ++++++++++++++++
 net/core/devlink.c    | 34 ++++++++++++++++++++++++++++++----
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 119ed1ffb988..f50a002e5023 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1714,15 +1714,31 @@ int devlink_info_driver_name_put(struct devlink_info_req *req,
 				 const char *name);
 int devlink_info_board_serial_number_put(struct devlink_info_req *req,
 					 const char *bsn);
+
+enum devlink_info_version_type {
+	DEVLINK_INFO_VERSION_TYPE_NONE,
+	DEVLINK_INFO_VERSION_TYPE_COMPONENT, /* May be used as flash update
+					      * component by name.
+					      */
+};
+
 int devlink_info_version_fixed_put(struct devlink_info_req *req,
 				   const char *version_name,
 				   const char *version_value);
 int devlink_info_version_stored_put(struct devlink_info_req *req,
 				    const char *version_name,
 				    const char *version_value);
+int devlink_info_version_stored_put_ext(struct devlink_info_req *req,
+					const char *version_name,
+					const char *version_value,
+					enum devlink_info_version_type version_type);
 int devlink_info_version_running_put(struct devlink_info_req *req,
 				     const char *version_name,
 				     const char *version_value);
+int devlink_info_version_running_put_ext(struct devlink_info_req *req,
+					 const char *version_name,
+					 const char *version_value,
+					 enum devlink_info_version_type version_type);
 
 int devlink_fmsg_obj_nest_start(struct devlink_fmsg *fmsg);
 int devlink_fmsg_obj_nest_end(struct devlink_fmsg *fmsg);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b50bcc18b8d9..43c75b5ac039 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6579,7 +6579,8 @@ EXPORT_SYMBOL_GPL(devlink_info_board_serial_number_put);
 
 static int devlink_info_version_put(struct devlink_info_req *req, int attr,
 				    const char *version_name,
-				    const char *version_value)
+				    const char *version_value,
+				    enum devlink_info_version_type version_type)
 {
 	struct nlattr *nest;
 	int err;
@@ -6612,7 +6613,8 @@ int devlink_info_version_fixed_put(struct devlink_info_req *req,
 				   const char *version_value)
 {
 	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_FIXED,
-					version_name, version_value);
+					version_name, version_value,
+					DEVLINK_INFO_VERSION_TYPE_NONE);
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_fixed_put);
 
@@ -6621,19 +6623,43 @@ int devlink_info_version_stored_put(struct devlink_info_req *req,
 				    const char *version_value)
 {
 	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_STORED,
-					version_name, version_value);
+					version_name, version_value,
+					DEVLINK_INFO_VERSION_TYPE_NONE);
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_stored_put);
 
+int devlink_info_version_stored_put_ext(struct devlink_info_req *req,
+					const char *version_name,
+					const char *version_value,
+					enum devlink_info_version_type version_type)
+{
+	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_STORED,
+					version_name, version_value,
+					version_type);
+}
+EXPORT_SYMBOL_GPL(devlink_info_version_stored_put_ext);
+
 int devlink_info_version_running_put(struct devlink_info_req *req,
 				     const char *version_name,
 				     const char *version_value)
 {
 	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_RUNNING,
-					version_name, version_value);
+					version_name, version_value,
+					DEVLINK_INFO_VERSION_TYPE_NONE);
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_running_put);
 
+int devlink_info_version_running_put_ext(struct devlink_info_req *req,
+					 const char *version_name,
+					 const char *version_value,
+					 enum devlink_info_version_type version_type)
+{
+	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_RUNNING,
+					version_name, version_value,
+					version_type);
+}
+EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
+
 static int
 devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 		     enum devlink_command cmd, u32 portid,
-- 
2.37.1

