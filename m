Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DB267C543
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbjAZH7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236032AbjAZH6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:58:55 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B9367794
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:53 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id d4-20020a05600c3ac400b003db1de2aef0so555203wms.2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2y6eMJEtPPxSnmLzQcAfCO/sJMx7E/Fo1bD37xCi7Sk=;
        b=mMD83L35Ts7jGZ9CKKdJxUGZn8w6TFex4JlznbNbv96g7PAlO9p6YsnDUWfeiCDOlf
         b/l3MHS620i8+4Efh1BR9zS7SuaJP8RSyCCpccAlePta9YCYs5DkntjsRCcUr8CvCvv0
         gCubJpiT/zPbB0svre3qq2MeFVYHvZ+fm3Git7i/Y9W+y0BHyF+5Yvna725cgHbNMePm
         KrnaLAcbuTmzVYhVEr9mXUaaw9kUdEjKdwUfkLpcTQk6Whvmf6Kw2rw8/WrQ+TlBxBL8
         AiPTfAlKgwvhcEcYLzalCtTNZLgw31jGAMsO14bT15WoSYUlKurIyYxfHivTJJSuR3tR
         yEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2y6eMJEtPPxSnmLzQcAfCO/sJMx7E/Fo1bD37xCi7Sk=;
        b=2SAOutd1JyfYBxUSKUa4ofVQgOVwwTc6xenKw7KNapOjK6/zr03iK0ha8HIKu+9fw4
         uyh5m5QCbYZYTlqjhN0yxmHHDFOUrP8QlW3KAq3J1KEcqED+/lJ+AjvA9B3tJUhcddSi
         1RS4JDXrEGcavoXY5bEsjQR21Y/dKkMPXAT/EOSwjVWUIfw+xuBESFVi9UybfLBrZ9fB
         Aza/hRAow4Hye20pCXrLSeaLXB7KRbP1MXzvrV1mqtRfF6x6aCkHuUqGIFeFpVDRHUqq
         DsCH7afdgq6RmQ2rxMQjeXiaF9jzeDY506rS75pIELxyv4+rbKwhW+8oos/eOuvG1H8n
         cTOw==
X-Gm-Message-State: AFqh2koqwqc0So8M7PkbLxasuN7J2x8Ww04ADWoEgPl2KAXTl18vknIV
        0PuFWVtscXE+ZR5nAhaQoI6fMd8oVV0Al0szqwonrA==
X-Google-Smtp-Source: AMrXdXtV/SzOMu8RixRozbb8+NHk6YKpfrTbw3MzZeYQleVCcwalBq/mjdw1ovqaJBw7c8Ujejrhsg==
X-Received: by 2002:a05:600c:1c1b:b0:3d9:ebf9:7004 with SMTP id j27-20020a05600c1c1b00b003d9ebf97004mr32737213wms.29.1674719932800;
        Wed, 25 Jan 2023 23:58:52 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id iz17-20020a05600c555100b003db07420d14sm697149wmb.39.2023.01.25.23.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:58:52 -0800 (PST)
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
Subject: [patch net-next v2 08/12] devlink: put couple of WARN_ONs in devlink_param_driverinit_value_get()
Date:   Thu, 26 Jan 2023 08:58:34 +0100
Message-Id: <20230126075838.1643665-9-jiri@resnulli.us>
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

Put couple of WARN_ONs in devlink_param_driverinit_value_get() function
to clearly indicate, that it is a driver bug if used without reload
support or for non-driverinit param.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/devlink/leftover.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 693470af548f..512ed4ccbdc7 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -10898,16 +10898,18 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 {
 	struct devlink_param_item *param_item;
 
-	if (!devlink_reload_supported(devlink->ops))
+	if (WARN_ON(!devlink_reload_supported(devlink->ops)))
 		return -EOPNOTSUPP;
 
 	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
 	if (!param_item)
 		return -EINVAL;
 
-	if (!param_item->driverinit_value_valid ||
-	    !devlink_param_cmode_is_supported(param_item->param,
-					      DEVLINK_PARAM_CMODE_DRIVERINIT))
+	if (!param_item->driverinit_value_valid)
+		return -EOPNOTSUPP;
+
+	if (WARN_ON(!devlink_param_cmode_is_supported(param_item->param,
+						      DEVLINK_PARAM_CMODE_DRIVERINIT)))
 		return -EOPNOTSUPP;
 
 	if (param_item->param->type == DEVLINK_PARAM_TYPE_STRING)
-- 
2.39.0

