Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED2C672132
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjARPYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjARPXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:55 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D7D49958
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:41 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id vm8so84027146ejc.2
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F3D2rOW0PtnstTqBQ9TFwrlqB8EOa2WTC5VIOo9/5xE=;
        b=Wrv2nft2StJMF4BfDHMiuDIZ7YwztmYYPAglLab9B6+yfxUHaQpYbLo24Nk8+8Wud1
         8H3CecBX2YMkFR/uGgX5bcIcrydhVnIrPfxDwa5VZHqpKxQakVpNgnhxJnnH+bTazDf+
         tGAOq9HQXwO7NtBfwfmIgzxN4+wdXEM221els/SbfAiRHibWL3bYG4VilnHxfJq7mAZC
         lgkCQFOOZq5y/K4m0HfSqNOkYxE+jOYeYP77govBR3wSWoeQO600qEMkdW7+MaJIk2bl
         i5lY4hWD5MqTKCFbq7sM6dcBEOxu/Yb+JnDEVNHSrHO/o7YTA6T19hBSPHIBMO0kUdPp
         jHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F3D2rOW0PtnstTqBQ9TFwrlqB8EOa2WTC5VIOo9/5xE=;
        b=DtJqX4G+xIV8DbsUgXY7xoTwqOiQjlTQ7HhCGQDjkBkytVjv3qWBgI3ijdfxc33vDj
         UpLTSIZA3FiM3b+46PtnNxZZrWmxAIcm5KI5zGfsUFnV/yvqFpNw6/R4RzOwxrYwAKrO
         qXCD/8w/RgeXFEAHUgLuaYDkepMmLt4zXTizwUl9RJxw3ww2yAz0smsLpYPZ25xda81Y
         wFlMPlX67r7249aPOn2DeVR7+MaxiEtPvdM6DowMVWOHH52YWPZy2dUTvUoGi6QxnheZ
         pyZwvBJBKQjE738Vn85+DPEU1Ek8z1jrM41oCmQENtpF3iV+d8YqqIcsdsON2o65mZrD
         fUCw==
X-Gm-Message-State: AFqh2kppoIX0QAZooh+gaFoDdWKkUlociSOUCPrYfJ4RUo+lJZMNxrFM
        3n5HbntRKUfLFjWcvpbyNDgOInsR+eE7q9c8QugEwg==
X-Google-Smtp-Source: AMrXdXsSKouW2ZisPh8+mtmTzxJ8CrdTdCJpKXYCgo8pYXjSWZzqH6eq3g5lAWeaI0o2VFuQV0uftA==
X-Received: by 2002:a17:906:78b:b0:7c1:9b07:32cd with SMTP id l11-20020a170906078b00b007c19b0732cdmr7540415ejc.39.1674055300490;
        Wed, 18 Jan 2023 07:21:40 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id d9-20020a1709063ec900b0084c2065b388sm14690462ejj.128.2023.01.18.07.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:39 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 12/12] devlink: add instance lock assertion in devl_is_registered()
Date:   Wed, 18 Jan 2023 16:21:15 +0100
Message-Id: <20230118152115.1113149-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118152115.1113149-1-jiri@resnulli.us>
References: <20230118152115.1113149-1-jiri@resnulli.us>
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

After region and linecard lock removals, this helper is always supposed
to be called with instance lock held. So put the assertion here and
remove the comment which is no longer accurate.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/devl_internal.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 75752f8c4a26..1aa1a9549549 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -85,9 +85,7 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp);
 
 static inline bool devl_is_registered(struct devlink *devlink)
 {
-	/* To prevent races the caller must hold the instance lock
-	 * or another lock taken during unregistration.
-	 */
+	devl_assert_locked(devlink);
 	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 }
 
-- 
2.39.0

