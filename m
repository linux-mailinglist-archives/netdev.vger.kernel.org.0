Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5715691C2F
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjBJKCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjBJKCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:02:03 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6867B151
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:43 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id l37-20020a05600c1d2500b003dfe46a9801so3679258wms.0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z2swvARs3+1rEHJor5k+uiBH7RWFOlRwmGe5F17Zm3w=;
        b=qgRlRHu96ymiWgSpcK1dctuW2CSZmE45Xmf1p1oOJQtfZuhwOFXT2FIbZvW9HalOsP
         R44NnBWBzPLjH8xHeOpNj1a0MwE18JV3HBg86tgNWe96SPCVBkutC0/rWQQK9WKSFyH1
         gCAORXqBL+q4njecehEfvv+e73O3T7MaYBnXF+XHrKrAB6jXUILBPRAS2gr59rvnpVhF
         aPd1y2Ig+DRsjzfF4aDwft3Qzzr/wqKy/u/SXPKJUUjAWb/SORDCf8ET6wKYXkNIEfDx
         OYkNqpHv79Ctq+3k4M9BHe40kaOqncvgb9CllozJVY17MawFSYPklTUALUuglt2srv+N
         u3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z2swvARs3+1rEHJor5k+uiBH7RWFOlRwmGe5F17Zm3w=;
        b=5XLZR9iQo6m63bdkOnRsGUDRkwHcUhbwCwBCJJUc8iTpsXfGXhcKGFoLbRE1TWCEBc
         ufnAUsnvL8bo+a6IGDMHa0ydtOD2o3+ROqXRdbszlEXy6NTeGGZ+Ircc8qanhO3eberG
         241NnB84Cgy5xdQbh85cM3US4siehrGWude8C9dLO0xn7oRKNkieEseOBjps/cGY9/U/
         vYpIBXi+DLsfS7uLPQJE52x1AXfta8viSdp7Vojf3bFIjyPadn6XPFnu8txdOsqD/l0h
         xAnbJgiTiF2wJiwGi/yeUKwyNbmGex2ew0cuQoWfvEEkueCVAPjwYoj+a41zR3q59DJc
         6SYQ==
X-Gm-Message-State: AO0yUKWIEKv8pnepvLmwtMidusXF7jZu/p0EU/eV6OSjG8EyMS/3BR2x
        DtxNla0QEA8y4NqI0TRv5GBslDF5ILwAvISjJGE=
X-Google-Smtp-Source: AK7set+RWp5xjr/s5OPzmEh9tYNUoF77YG7Kh0ky4R0KlVJHECQLmTv76rbg1ehNkPpd48kYLuPqNw==
X-Received: by 2002:a05:600c:3510:b0:3dc:42d2:aeee with SMTP id h16-20020a05600c351000b003dc42d2aeeemr12620334wmq.25.1676023302490;
        Fri, 10 Feb 2023 02:01:42 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p21-20020a05600c359500b003db06224953sm4881037wmq.41.2023.02.10.02.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 02:01:41 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com, simon.horman@corigine.com, idosch@nvidia.com
Subject: [patch net-next v2 6/7] devlink: allow to call devl_param_driverinit_value_get() without holding instance lock
Date:   Fri, 10 Feb 2023 11:01:30 +0100
Message-Id: <20230210100131.3088240-7-jiri@resnulli.us>
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

If the driver maintains following basic sane behavior, the
devl_param_driverinit_value_get() function could be called without
holding instance lock:

1) Driver ensures a call to devl_param_driverinit_value_get() cannot
   race with registering/unregistering the parameter with
   the same parameter ID.
2) Driver ensures a call to devl_param_driverinit_value_get() cannot
   race with devl_param_driverinit_value_set() call with
   the same parameter ID.
3) Driver ensures a call to devl_param_driverinit_value_get() cannot
   race with reload operation.

By the nature of params usage, these requirements should be
trivially achievable. If the driver for some off reason
is not able to comply, it has to take the devlink->lock while
calling devl_param_driverinit_value_get().

Remove the lock assertion and add comment describing
the locking requirements.

This fixes a splat in mlx5 driver introduced by the commit
referenced in the "Fixes" tag.

Lore: https://lore.kernel.org/netdev/719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com/
Reported-by: Kim Phillips <kim.phillips@amd.com>
Fixes: 075935f0ae0f ("devlink: protect devlink param list by instance lock")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 6d3988f4e843..9f0256c2c323 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -9628,14 +9628,23 @@ EXPORT_SYMBOL_GPL(devlink_params_unregister);
  *
  *	This function should be used by the driver to get driverinit
  *	configuration for initialization after reload command.
+ *
+ *	Note that lockless call of this function relies on the
+ *	driver to maintain following basic sane behavior:
+ *	1) Driver ensures a call to this function cannot race with
+ *	   registering/unregistering the parameter with the same parameter ID.
+ *	2) Driver ensures a call to this function cannot race with
+ *	   devl_param_driverinit_value_set() call with the same parameter ID.
+ *	3) Driver ensures a call to this function cannot race with
+ *	   reload operation.
+ *	If the driver is not able to comply, it has to take the devlink->lock
+ *	while calling this.
  */
 int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				    union devlink_param_value *val)
 {
 	struct devlink_param_item *param_item;
 
-	lockdep_assert_held(&devlink->lock);
-
 	if (WARN_ON(!devlink_reload_supported(devlink->ops)))
 		return -EOPNOTSUPP;
 
-- 
2.39.0

