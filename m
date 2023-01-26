Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F263C67C540
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbjAZH66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235767AbjAZH6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:58:52 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554CD66FB8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:46 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r2so875162wrv.7
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2DExkzM5D8GtIOGGAkvL+7P+nPyHumEReELNCOHSSo=;
        b=HrY1h3/ZEWtuST5+z+595QkrZFfbH+zCnGYGnrZTREO1zIJ+pvt2jDC5hN7Hxqg7w2
         jSTL41ACeK88wZBZr1+e0kixgnIhtc58q12W7QAPYyWLomHv44/tkoZzJx7sGtuzjXnH
         8uYvS/pUCTUpCwSh21XFB0R2tAGLFZ3Jtp3QMY2B8AMzs6W8CkKEiiLO6p+LTDZV0O3t
         xM4mVkXrPquYcQYpReRf0g3n+zBRBpD681b8WJGfGeQifuYh1dA9TvVIn3EAA0fiuX67
         YCYD6BbPPHEfThJZIojO/3AQPIR/Y/1F65nS+55IhuXXzF5YEHCiLotH+rtXBFfzw4fa
         iakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H2DExkzM5D8GtIOGGAkvL+7P+nPyHumEReELNCOHSSo=;
        b=CUY5dmEioyJGlZB/LokIu32SmQRJM7h/awllxkhO56I5C0g1JqEk3S3v1R0BRk5K5l
         fMMgpkKYOTFwi6p/aSVKz9XWVTlQfe+UGoEmmIzMW/hG1Q2Ppgn4chta/ScFpXxUpvwg
         sOlsQyIH2/lyVNTPrZK6Vc3UOUW2XMi2J6BYjGpKymgFws1ZqqatGR7/F2sj/mH7aP+y
         SfCtXxtaWKzgr9FvXBvzHCe9qHxcW+Z8Ou+rvl1Qlem0s0BHFIJpzjAuA2qMfMXAUT2e
         GZVVDnCFYjFzeSlB/jAElWriq3mhY/GCM3isFuNl8eLb7MGLYBawrKF5rswYjN/V1Laf
         qPBQ==
X-Gm-Message-State: AO0yUKXNH5008qEV5H7cja+Fwzb0jwI2hJjN31vSSlyWzlAduPm+QOf9
        T+tUlU+bQKrRRZ7FDDTSf/0ZpbIH45FisUont6S3hQ==
X-Google-Smtp-Source: AK7set8FTFmeWkn4nb9vhQYKMHfmVWXOo2MXFbaoiIXiNZjlkecPc4sGFhVbJV1C+8rYI16XcQNWww==
X-Received: by 2002:a5d:5311:0:b0:2bf:ae1e:84d2 with SMTP id e17-20020a5d5311000000b002bfae1e84d2mr7622754wrv.12.1674719924788;
        Wed, 25 Jan 2023 23:58:44 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l12-20020a05600002ac00b0029100e8dedasm591804wry.28.2023.01.25.23.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:58:44 -0800 (PST)
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
Subject: [patch net-next v2 03/12] devlink: make devlink_param_register/unregister static
Date:   Thu, 26 Jan 2023 08:58:29 +0100
Message-Id: <20230126075838.1643665-4-jiri@resnulli.us>
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

There is no user outside the devlink code, so remove the export and make
the functions static. Move them before callers to avoid forward
declarations.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/net/devlink.h  |  4 --
 net/devlink/leftover.c | 90 +++++++++++++++++-------------------------
 2 files changed, 37 insertions(+), 57 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 608a0c198be8..cf74b6391896 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1773,10 +1773,6 @@ int devlink_params_register(struct devlink *devlink,
 void devlink_params_unregister(struct devlink *devlink,
 			       const struct devlink_param *params,
 			       size_t params_count);
-int devlink_param_register(struct devlink *devlink,
-			   const struct devlink_param *param);
-void devlink_param_unregister(struct devlink *devlink,
-			      const struct devlink_param *param);
 int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value *init_val);
 int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 74621287f4e5..b1216b8f0acc 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -10793,6 +10793,43 @@ static int devlink_param_verify(const struct devlink_param *param)
 		return devlink_param_driver_verify(param);
 }
 
+static int devlink_param_register(struct devlink *devlink,
+				  const struct devlink_param *param)
+{
+	struct devlink_param_item *param_item;
+
+	WARN_ON(devlink_param_verify(param));
+	WARN_ON(devlink_param_find_by_name(&devlink->param_list, param->name));
+
+	if (param->supported_cmodes == BIT(DEVLINK_PARAM_CMODE_DRIVERINIT))
+		WARN_ON(param->get || param->set);
+	else
+		WARN_ON(!param->get || !param->set);
+
+	param_item = kzalloc(sizeof(*param_item), GFP_KERNEL);
+	if (!param_item)
+		return -ENOMEM;
+
+	param_item->param = param;
+
+	list_add_tail(&param_item->list, &devlink->param_list);
+	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
+	return 0;
+}
+
+static void devlink_param_unregister(struct devlink *devlink,
+				     const struct devlink_param *param)
+{
+	struct devlink_param_item *param_item;
+
+	param_item =
+		devlink_param_find_by_name(&devlink->param_list, param->name);
+	WARN_ON(!param_item);
+	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_DEL);
+	list_del(&param_item->list);
+	kfree(param_item);
+}
+
 /**
  *	devlink_params_register - register configuration parameters
  *
@@ -10844,59 +10881,6 @@ void devlink_params_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_params_unregister);
 
-/**
- * devlink_param_register - register one configuration parameter
- *
- * @devlink: devlink
- * @param: one configuration parameter
- *
- * Register the configuration parameter supported by the driver.
- * Return: returns 0 on successful registration or error code otherwise.
- */
-int devlink_param_register(struct devlink *devlink,
-			   const struct devlink_param *param)
-{
-	struct devlink_param_item *param_item;
-
-	WARN_ON(devlink_param_verify(param));
-	WARN_ON(devlink_param_find_by_name(&devlink->param_list, param->name));
-
-	if (param->supported_cmodes == BIT(DEVLINK_PARAM_CMODE_DRIVERINIT))
-		WARN_ON(param->get || param->set);
-	else
-		WARN_ON(!param->get || !param->set);
-
-	param_item = kzalloc(sizeof(*param_item), GFP_KERNEL);
-	if (!param_item)
-		return -ENOMEM;
-
-	param_item->param = param;
-
-	list_add_tail(&param_item->list, &devlink->param_list);
-	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_param_register);
-
-/**
- * devlink_param_unregister - unregister one configuration parameter
- * @devlink: devlink
- * @param: configuration parameter to unregister
- */
-void devlink_param_unregister(struct devlink *devlink,
-			      const struct devlink_param *param)
-{
-	struct devlink_param_item *param_item;
-
-	param_item =
-		devlink_param_find_by_name(&devlink->param_list, param->name);
-	WARN_ON(!param_item);
-	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_DEL);
-	list_del(&param_item->list);
-	kfree(param_item);
-}
-EXPORT_SYMBOL_GPL(devlink_param_unregister);
-
 /**
  *	devlink_param_driverinit_value_get - get configuration parameter
  *					     value for driver initializing
-- 
2.39.0

