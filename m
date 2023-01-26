Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E65F67C542
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbjAZH7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbjAZH6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:58:55 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9022966FA6
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:52 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o17-20020a05600c511100b003db021ef437so541728wms.4
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/onV282aFntC1GXe3qzoBjkqW5qz7JFW0VysSCjmKhs=;
        b=r4mk/r1fVby7GAmQSUzHOW1kNeXu93s39nzWRC/vSF0/2f/tq4uG6iMna+d0SiqekP
         mkdg3G3yEG/fpkVbwGARoEeS9XgkhGkb2DYojitvgk6iEvEdLG1iqleb0MFrEWwT7icx
         JD6Sewfu8BilshR6lwszAcQT/xBL/oBLjN4oW5tnasOA4A6FH7V+thK3JQsjv+/6cFkS
         +M1pbXN8XaIHU5p8AGfLe8Pe4KsRQO2nTA0N1ApzI5fNLnW3n/nwTtq5DmJTsc60m11P
         iJ4B0T8xh8EPKbVmvT8jHeEVZ5cOJG54iMxo/ELvDV6zDoBtLYqXjMk/kTzlGZUDFZzB
         1Hmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/onV282aFntC1GXe3qzoBjkqW5qz7JFW0VysSCjmKhs=;
        b=OcPdRiuojHg8+g5xQ7MvKhLBVuDvKquTKzeoh5bWjVLlq/EoQytBpz2rKxI6yUWQmT
         LT+C2z26E9Otrnyn5igtenTikrCglq0B4pQhqirb10yyWGZw1e0BKihHUEemKxrA7+Eq
         CZxj69bnFR55tj0gsHOZOqHfmU3Y1xqbQyafMV5qeeFFy4tAXsbldewgMp8aAi07Gq+t
         suB0+6cSexBYa9TTCx/PNeJEBDfOHrF2Rr+FmIBAh1MU0RG088eFCBchqWdOzNr5eDyb
         loDklc0Tp/H7PEZ1YSS0Ol1o0yRmsyaQc8YKr1YsOMVdZSqZJt+kwaRrvWJW6alofpQT
         83wg==
X-Gm-Message-State: AFqh2koIf7G65g2FGhg04r6e6l53PbRNx/bFEI0t+/4IQf0L/yPmkfrU
        Wy3zxM/1B/3MTxoinbE9rYBjKSaaYXmThSQpiGWuyQ==
X-Google-Smtp-Source: AMrXdXvQJojMdGm4mGYna5V7zoch8EWfAjRzG1F0NKh/IRNgmlWza1p9dZrmgch1M3fQiWRE5uyCrA==
X-Received: by 2002:a05:600c:d3:b0:3da:23a4:627e with SMTP id u19-20020a05600c00d300b003da23a4627emr33140037wmm.6.1674719931134;
        Wed, 25 Jan 2023 23:58:51 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t10-20020a05600c328a00b003d9a86a13bfsm678763wmp.28.2023.01.25.23.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:58:50 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        aelior@marvell.com, manishc@marvell.com, jacob.e.keller@intel.com,
        gal@nvidia.com, yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: [patch net-next v2 07/12] devlink: make devlink_param_driverinit_value_set() return void
Date:   Thu, 26 Jan 2023 08:58:33 +0100
Message-Id: <20230126075838.1643665-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230126075838.1643665-1-jiri@resnulli.us>
References: <20230126075838.1643665-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

devlink_param_driverinit_value_set() currently returns int with possible
error, but no user is checking it anyway. The only reason for a fail is
a driver bug. So convert the function to return void and put WARN_ONs
on error paths.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/net/devlink.h  |  4 ++--
 net/devlink/leftover.c | 15 +++++++--------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index cf74b6391896..e0d773dfa637 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1775,8 +1775,8 @@ void devlink_params_unregister(struct devlink *devlink,
 			       size_t params_count);
 int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value *init_val);
-int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
-				       union devlink_param_value init_val);
+void devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
+					union devlink_param_value init_val);
 void devlink_param_value_changed(struct devlink *devlink, u32 param_id);
 struct devlink_region *devl_region_create(struct devlink *devlink,
 					  const struct devlink_region_ops *ops,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index fca2b6661362..693470af548f 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -10931,18 +10931,18 @@ EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_get);
  *	This function should be used by the driver to set driverinit
  *	configuration mode default value.
  */
-int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
-				       union devlink_param_value init_val)
+void devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
+					union devlink_param_value init_val)
 {
 	struct devlink_param_item *param_item;
 
 	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
-	if (!param_item)
-		return -EINVAL;
+	if (WARN_ON(!param_item))
+		return;
 
-	if (!devlink_param_cmode_is_supported(param_item->param,
-					      DEVLINK_PARAM_CMODE_DRIVERINIT))
-		return -EOPNOTSUPP;
+	if (WARN_ON(!devlink_param_cmode_is_supported(param_item->param,
+						      DEVLINK_PARAM_CMODE_DRIVERINIT)))
+		return;
 
 	if (param_item->param->type == DEVLINK_PARAM_TYPE_STRING)
 		strcpy(param_item->driverinit_value.vstr, init_val.vstr);
@@ -10951,7 +10951,6 @@ int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 	param_item->driverinit_value_valid = true;
 
 	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_set);
 
-- 
2.39.0

