Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0473367B406
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbjAYOO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235645AbjAYOOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:14:46 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE18659577
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:32 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id az20so48065640ejc.1
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CCZ18Oyx7irm46T5EaeEt/27cDVbrJtrl/nk61Khrnc=;
        b=Ndp5NRjG0wTrILKTKrbPXi8410OFpotVRWSDjlqNe1U1LRmhnRJwgDNi33KBtfhHWR
         JtSgdPOk7c/VCECPYcvIfjVFGyVzEqYFtvUl1nzIn3oUKp2NwR1iwts3iO7ylNJHvNSf
         vjuwZ6jo3j0akTslkEvqDZAod/4/jukudhiCNrd28EH9mGtlRQ/5WjzLCVgBbK1uxLPK
         S0X3Z4EpdXmHOxs+XvqvIN9hLobXoL3abk/uy4ka9BDR8NqUmDgsD52aDkUxQhpRIai6
         Js9lQWKqIVQE2MN2zkGy03XMQJUXrEkcV4repXOBOgC83lJF0Co6JO11tLlPS4u6aHgV
         Vebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CCZ18Oyx7irm46T5EaeEt/27cDVbrJtrl/nk61Khrnc=;
        b=pT4QNAuvQwmglRvEYNUmZWoi0lzQI2co91NCqZJWv7ZpybwOyJPN1UFaWM9XON7GDZ
         pNIFLZftJ5zbs7jgfjj2REqHMqvi0aCKMZm3BqnDUd8s6NodayI8xp9uVPqUNEfujctd
         TqtBBTG7cfsBiVV5IOuzM8yHheJkuCs9S+ZVlu3JvE0ie1q9ZLrX7l+KJ9VY3bCpBH3R
         GH0bZ+fd0PwtJbSjRjsI4PHv1Yw0g9VOmKK0oqugMmD3kd1U00iC8GF0ueV/tMhYYrnX
         IGwNh5Eueg3GMl61u5grTSjNeFaxRnG/mzhqV24i5uyiMN7zexLkA0wWdFIZ3uIwLrgk
         rnVw==
X-Gm-Message-State: AFqh2krkUEhNHZFfoQ6CJRorZqiCcrWRIJd0r9fbuZYosjWXTPQm7Wot
        zuI8l4U76F3ECZ3od+H/MqBW4j4Exs1x8xNEVJk=
X-Google-Smtp-Source: AMrXdXtf2v4tza04zao+hHpn87a8WtkGJmAn2XpdmXXmRmwn3GNj/nyg9C5/Wvhh+l5z5XNVpE44FQ==
X-Received: by 2002:a17:906:3f94:b0:861:4671:a834 with SMTP id b20-20020a1709063f9400b008614671a834mr31787373ejj.71.1674656071019;
        Wed, 25 Jan 2023 06:14:31 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id wd1-20020a170907d60100b00780b1979adesm2401769ejc.218.2023.01.25.06.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:30 -0800 (PST)
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
Subject: [patch net-next 07/12] devlink: make devlink_param_driverinit_value_set() return void
Date:   Wed, 25 Jan 2023 15:14:07 +0100
Message-Id: <20230125141412.1592256-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230125141412.1592256-1-jiri@resnulli.us>
References: <20230125141412.1592256-1-jiri@resnulli.us>
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

