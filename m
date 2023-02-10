Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B9A691C29
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjBJKB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbjBJKBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:01:40 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455CB7AE09
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:39 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id c26so9578001ejz.10
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XpjOo4lHR2rZDTWwmoSXeMhFODr1URFgGK3G2GVEA5U=;
        b=X2TPt58DTlknF3z+a45it7omO038a0GLlFAiGSnKTA7L4xZFv7RCuOMux88YGFwwQJ
         0/ZCs4NvBsJnZ022QtPHiJjULJFpUgUtqxvdw+L/2AZ+rca75mfuQYBRcWoep36Ea3yl
         BKGCk8oAFAYe/kuX64J6ORrymN9+TSyBJ2etSi+oqniMLOoMe2BsVKLJ423TWmknMHrT
         ED0oPKUO5j8TAOSQBUrwv6OnA76ZbDVQlfy4Sn0wSudPpJJxdQwbG6lQTT630Rnmwol4
         LTF9JLiEoO2UTAQ3aBZFOreSI/upPDijy+3iIbj1e/z+0Ap7lJg07QWg80oW/1XnnO6T
         77kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XpjOo4lHR2rZDTWwmoSXeMhFODr1URFgGK3G2GVEA5U=;
        b=1pJOjd1us9aqsKuEBkWqNd7zranAVjp0HJvELFuHNVVfmz3uwTHub0ZNO5fzg5QpY1
         eUBLQATpUkCIQNRyKFF3KOPtXOH14JzAwIs54adA1z5W/xc7Cua7UEXJtNpBzAzFKjnf
         H8YDUdspXosiXBPiMLEk7kAgIp/59GpJjj9aBHmtgO2wnKFfyHRkI5VhHrioenbFFGX6
         +BEmPpz5M7tRF3ATZ1fPgGhG1TOZy8muWd9kotkPr81MKrHiER7N4TdzbX0i64xjljiH
         w6NXvVyiXvbsWQ6Q63ZRO38Gj+izbJccJtQoKnICSdgUpZQIFaRP2XbVG0ky7ulxsGMr
         vZhg==
X-Gm-Message-State: AO0yUKWkitYgvHtSBZ332zHZ0VAvrOk8u8nO2CvA8BE7FTEcIZlsgcrp
        1BZD3pddtf84N6ailHQ1L36NYVx7jAq2VSRaKuA=
X-Google-Smtp-Source: AK7set9Gob2i07qP+eu4ekGZPeBszD+985q87aGK/12JiQV2J8umq4j/PxaoKuEpuWy8IBxadlldXA==
X-Received: by 2002:a17:907:94ca:b0:8aa:be1a:c4bf with SMTP id dn10-20020a17090794ca00b008aabe1ac4bfmr17456758ejc.16.1676023297843;
        Fri, 10 Feb 2023 02:01:37 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e26-20020a170906081a00b008786675d086sm2165681ejd.29.2023.02.10.02.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 02:01:37 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com, simon.horman@corigine.com, idosch@nvidia.com
Subject: [patch net-next v2 3/7] devlink: fix the name of value arg of devl_param_driverinit_value_get()
Date:   Fri, 10 Feb 2023 11:01:27 +0100
Message-Id: <20230210100131.3088240-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230210100131.3088240-1-jiri@resnulli.us>
References: <20230210100131.3088240-1-jiri@resnulli.us>
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

Probably due to copy-paste error, the name of the arg is "init_val"
which is misleading, as the pointer is used to point to struct where to
store the current value. Rename it to "val" and change the arg comment
a bit on the way.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h  | 2 +-
 net/devlink/leftover.c | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8ed960345f37..6a942e70e451 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1784,7 +1784,7 @@ void devlink_params_unregister(struct devlink *devlink,
 			       const struct devlink_param *params,
 			       size_t params_count);
 int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
-				    union devlink_param_value *init_val);
+				    union devlink_param_value *val);
 void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 				     union devlink_param_value init_val);
 void devl_param_value_changed(struct devlink *devlink, u32 param_id);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 61e59556ea03..dab7326dc3ea 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -9630,13 +9630,14 @@ EXPORT_SYMBOL_GPL(devlink_params_unregister);
  *
  *	@devlink: devlink
  *	@param_id: parameter ID
- *	@init_val: value of parameter in driverinit configuration mode
+ *	@val: pointer to store the value of parameter in driverinit
+ *	      configuration mode
  *
  *	This function should be used by the driver to get driverinit
  *	configuration for initialization after reload command.
  */
 int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
-				    union devlink_param_value *init_val)
+				    union devlink_param_value *val)
 {
 	struct devlink_param_item *param_item;
 
@@ -9656,7 +9657,7 @@ int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 						      DEVLINK_PARAM_CMODE_DRIVERINIT)))
 		return -EOPNOTSUPP;
 
-	*init_val = param_item->driverinit_value;
+	*val = param_item->driverinit_value;
 
 	return 0;
 }
-- 
2.39.0

