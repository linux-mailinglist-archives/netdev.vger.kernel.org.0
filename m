Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9E6691C28
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjBJKBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjBJKBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:01:39 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50DA7AE06
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:37 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ml19so14522594ejb.0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Doql15jQLxXBeQxIQBXCXHixNnLBHAXs+GbIOZ8EpOE=;
        b=QmRDGlKXdLwXXKTolFjZjUQEjqxeSk1Y855xVaxqAgoi4vFEkYGOZlunM0DamRgKkI
         X4XXIrp9okVbnWIV2ld6kvnE0xWauKpdrxH0Gqm6W+chQupUIqiS77idzok7QtgcTYmW
         sXvgTCwjeo4dJLhZWnwn6WEmxEoalFLOetigm2N3nB8mV/BJEh3J2NQ2pimSEpyE21Mb
         iwMH87+wbYVTe0gbR9+eCJMl16lCuFo0EuqmmhVOSz+FLBH4afTKm04E9x7U7V3DKx+g
         XjAwnaL+yYh3sy9FUfGL3U25mHmf/L91nCFGJ9anTapNm/Oeh7nik90d+euFWDW2L8WE
         5CGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Doql15jQLxXBeQxIQBXCXHixNnLBHAXs+GbIOZ8EpOE=;
        b=fTklBIHDi4dTVhdUQ4Pp03Ps4Owf56dr9arutaxIIA4gE8wIz0fpibB4Q1qvIzlcp4
         JE2nMkBHD/ESDaXLMS3Qa5tL/ItUuuvGjyxP8jkAgE1+B0/F5pr5w7sc6lCl7tk99MJJ
         QwSRGm2Dwohi3PVrFj/DjNjOLJ9oAxiZZOH05UUiG4+LH7W7sCjfu0jjmDDqHsAvVgsP
         M4enwftjWnj9RlCex6EEjRzf/34nYA+Fp6fgurBxJKnL9f6zCuMxsz0uBEejZ9QIrcmW
         yfv19FhqhUiIbZ8R522ratB7P5KQZqh3WtixKrGT8qptZ12sp2KAcGy80N6crCyb4oa/
         TaWw==
X-Gm-Message-State: AO0yUKViVgEx5ZEizrz+TIt1KglgYXsFG/YeMGTk0Kjq6oVYumpGQGB6
        s3ZZcPj0DX2RriXJcCqaj1AxqM5X0VatjXeoVJw=
X-Google-Smtp-Source: AK7set+xHwLuLET1Gn/NYX2JqSQ9png4CVapRv+ZS697Oyx6G9TARu0ze8NoKpfDZQbxG61jNiXc2g==
X-Received: by 2002:a17:907:d2a:b0:8af:3922:ace6 with SMTP id gn42-20020a1709070d2a00b008af3922ace6mr7616431ejc.40.1676023296197;
        Fri, 10 Feb 2023 02:01:36 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id qq8-20020a17090720c800b0088e7fe75736sm2153425ejb.1.2023.02.10.02.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 02:01:35 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com, simon.horman@corigine.com, idosch@nvidia.com
Subject: [patch net-next v2 2/7] devlink: make sure driver does not read updated driverinit param before reload
Date:   Fri, 10 Feb 2023 11:01:26 +0100
Message-Id: <20230210100131.3088240-3-jiri@resnulli.us>
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

The driverinit param purpose is to serve the driver during init/reload
time to provide a value, either default or set by user.

Make sure that driver does not read value updated by user before the
reload is performed. Hold the new value in a separate struct and switch
it during reload.

Note that this is required to be eventually possible to call
devl_param_driverinit_value_get() without holding instance lock.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- extended patch description with a note
- call driverinit_load_new only if action is REINIT
---
 include/net/devlink.h       |  4 ++++
 net/devlink/dev.c           |  3 +++
 net/devlink/devl_internal.h |  3 +++
 net/devlink/leftover.c      | 26 ++++++++++++++++++++++----
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 2e85a5970a32..8ed960345f37 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -489,6 +489,10 @@ struct devlink_param_item {
 	const struct devlink_param *param;
 	union devlink_param_value driverinit_value;
 	bool driverinit_value_valid;
+	union devlink_param_value driverinit_value_new; /* Not reachable
+							 * until reload.
+							 */
+	bool driverinit_value_new_valid;
 };
 
 enum devlink_param_generic_id {
diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index 78d824eda5ec..f995d88b9d04 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -369,6 +369,9 @@ int devlink_reload(struct devlink *devlink, struct net *dest_net,
 	if (dest_net && !net_eq(dest_net, curr_net))
 		devlink_reload_netns_change(devlink, curr_net, dest_net);
 
+	if (action == DEVLINK_RELOAD_ACTION_DRIVER_REINIT)
+		devlink_params_driverinit_load_new(devlink);
+
 	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
 	devlink_reload_failed_set(devlink, !!err);
 	if (err)
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 941174e157d4..5c117e8d4377 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -189,6 +189,9 @@ static inline bool devlink_reload_supported(const struct devlink_ops *ops)
 	return ops->reload_down && ops->reload_up;
 }
 
+/* Params */
+void devlink_params_driverinit_load_new(struct devlink *devlink);
+
 /* Resources */
 struct devlink_resource;
 int devlink_resources_validate(struct devlink *devlink,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index f2f6a2f42864..61e59556ea03 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -4098,9 +4098,12 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 		if (!devlink_param_cmode_is_supported(param, i))
 			continue;
 		if (i == DEVLINK_PARAM_CMODE_DRIVERINIT) {
-			if (!param_item->driverinit_value_valid)
+			if (param_item->driverinit_value_new_valid)
+				param_value[i] = param_item->driverinit_value_new;
+			else if (param_item->driverinit_value_valid)
+				param_value[i] = param_item->driverinit_value;
+			else
 				return -EOPNOTSUPP;
-			param_value[i] = param_item->driverinit_value;
 		} else {
 			ctx.cmode = i;
 			err = devlink_param_get(devlink, param, &ctx);
@@ -4388,8 +4391,8 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
 		return -EOPNOTSUPP;
 
 	if (cmode == DEVLINK_PARAM_CMODE_DRIVERINIT) {
-		param_item->driverinit_value = value;
-		param_item->driverinit_value_valid = true;
+		param_item->driverinit_value_new = value;
+		param_item->driverinit_value_new_valid = true;
 	} else {
 		if (!param->set)
 			return -EOPNOTSUPP;
@@ -9691,6 +9694,21 @@ void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 }
 EXPORT_SYMBOL_GPL(devl_param_driverinit_value_set);
 
+void devlink_params_driverinit_load_new(struct devlink *devlink)
+{
+	struct devlink_param_item *param_item;
+
+	list_for_each_entry(param_item, &devlink->param_list, list) {
+		if (!devlink_param_cmode_is_supported(param_item->param,
+						      DEVLINK_PARAM_CMODE_DRIVERINIT) ||
+		    !param_item->driverinit_value_new_valid)
+			continue;
+		param_item->driverinit_value = param_item->driverinit_value_new;
+		param_item->driverinit_value_valid = true;
+		param_item->driverinit_value_new_valid = false;
+	}
+}
+
 /**
  *	devl_param_value_changed - notify devlink on a parameter's value
  *				   change. Should be called by the driver
-- 
2.39.0

