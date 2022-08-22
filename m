Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB98259C48F
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbiHVRC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235765AbiHVRCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:02:53 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA111419AE
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:02:51 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id q2so12643634edb.6
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=3sUHWDa2F0mjoZfRKLvdJDDNPwPJAlWT4DZRT16qSQM=;
        b=XztyfRCjnma9UobTeTwlFQweP39vP/0lADAAgFW5EnU+P0StsbLmn3uxEXT4OHJ/TT
         4/k8KgWojQSUMoL3zhYglU+P+tjNVVJamp6iX6q8l3VWjXwqgs2iJgJtA+R+BHybeH+d
         l2eneuAPZdjiP8sUQOTx5HxQM3n3yVvqVAniQbyMKQoBq06RTLNf4OJZWfor/TH5IlH4
         CKn2nF1VyRICe+YJoCA/t7hl/actMbq/eCgmQbsI01sHu/tbtxAFP0f/ajxKe2+hXBcF
         JIkMj1V4p0FzXVb98H6JxQYa3KStoMBXyign0p67Vl0tYzatTHe27hTyVgsfuu2JtQx+
         ediQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=3sUHWDa2F0mjoZfRKLvdJDDNPwPJAlWT4DZRT16qSQM=;
        b=N7N5ZvNMiiOnlDBrHUOrPtC5gHMv4+UpS6Iul2g15K9RH3QvtebFacRkU4SzfMjaAm
         nitxlYfrOa0Lixglu+KQl1EVlgSdLEmXmrgN2phcwbrIcsrwhD4zTGssNkZHblh3+YoT
         W+Zj8oCJuYbp4Y/59gIbClDz3DzvbVvCuQjCOOYZxU/BTRjJsva3+NTcw11X/v59gieS
         PeLumpQk9RUuso6My6bZtX3iIZgu+zmKvldo/1Z872EQctIpVSGmneF386/AdpwRv9eS
         /2zcg/lOwPN21GOj6nqKfdig1+7o0qre/AZk0CiuJNRzYtRSm7oSUOZI24oMLqoab9nU
         yDfQ==
X-Gm-Message-State: ACgBeo2UTif4QOCCSF3iHxxIA7J39hAYPJWxueEOK1pA7cB1YLh5CAT5
        KoLrZHFkgwE7lGlPA3xaEYP8pCArNNvJugWe
X-Google-Smtp-Source: AA6agR7z2UnxY6yFEBz54DR4BAaIpXPiwjk8R8Hy0NdRePdnwZoJLBKl6dawzTVwifHYm8zmP+Offg==
X-Received: by 2002:aa7:d31a:0:b0:445:f4cd:b1c3 with SMTP id p26-20020aa7d31a000000b00445f4cdb1c3mr125562edq.110.1661187770397;
        Mon, 22 Aug 2022 10:02:50 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bt2-20020a0564020a4200b0043d7b19abd0sm11560edb.39.2022.08.22.10.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 10:02:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next v2 1/4] net: devlink: extend info_get() version put to indicate a flash component
Date:   Mon, 22 Aug 2022 19:02:44 +0200
Message-Id: <20220822170247.974743-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220822170247.974743-1-jiri@resnulli.us>
References: <20220822170247.974743-1-jiri@resnulli.us>
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
helper devlink_info_version_running_put_ext() that allows to specify a
version type that indicates when particular version name represents
a flash component.

This is going to be used in follow-up patch calling info_get() during
flash update command checking if version with this the version type
exists.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- split from v1 patch "net: devlink: extend info_get() version put to
  indicate a flash component", no code changes
---
 include/net/devlink.h | 12 ++++++++++++
 net/core/devlink.c    | 23 +++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 119ed1ffb988..5f47d5cefaa6 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1714,6 +1714,14 @@ int devlink_info_driver_name_put(struct devlink_info_req *req,
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
@@ -1723,6 +1731,10 @@ int devlink_info_version_stored_put(struct devlink_info_req *req,
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
index b50bcc18b8d9..2682e968539e 100644
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
 
@@ -6621,7 +6623,8 @@ int devlink_info_version_stored_put(struct devlink_info_req *req,
 				    const char *version_value)
 {
 	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_STORED,
-					version_name, version_value);
+					version_name, version_value,
+					DEVLINK_INFO_VERSION_TYPE_NONE);
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_stored_put);
 
@@ -6630,10 +6633,22 @@ int devlink_info_version_running_put(struct devlink_info_req *req,
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

