Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDD8642BA0
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiLEP0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbiLEP0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:26:01 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4200C17AA5
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:23:17 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id v8so16274257edi.3
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 07:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TjGik1YCfVvk2OROi2oUxneeZOigUKQC8x1oTnCEtY=;
        b=r475m4VzjVvvtt8oprpcO4Uyo87wY2H6lJYXmR8dXtawEvg+T3valSqTJscNoRv06Y
         9ybdA7DZdxP8sLx2dwdwM90rGxVxpZpaDuQpQXccUWWYJ+QQvoFn7+6mbQEiJooTB0Zl
         2bW+Ki2+z33TU0i2UwKSQZMif4UgqPNJEqJD54HAk3xeBKkXFujJbJVulqkRPcMTUtqc
         4hFXGVI+pgbiiV0knvAtLqiO/y52M37aeY5UKH4NMVUZkiCp6790O+pRR6uepgkNfaby
         /6Jjh01Lq+mVFQ5AASwDfcqWQY5OMT32Ya5b0/b5Arak/dvxyHsCKaUxOYCgpeKBZJeG
         0CMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/TjGik1YCfVvk2OROi2oUxneeZOigUKQC8x1oTnCEtY=;
        b=oRhCqT72+G0vU9DYXyuAP5MkdZeMCqf3T/Y6oymj8j4wB3pscJi/jnpDBOSwIk3RPR
         eCLp4eAWz1rcpP1kep7x6nnzxH5oPkpRL7Z7fonawteDGS579doCR8aZQ02gn998CWJ4
         xkACGwMvY45ahxz7Sjv8Y1mnWnz8l3FJk6TwFnSaNYLgy5vmgT10mDtcvb8rQLrw+kan
         ZdXV7gzMSVLQVMcWikAyJSgrZrO8LxDUNoO2YimHc2OlvrMVMMdvI6fiMjhtAqzIcW7l
         WhJW0gwG/5rGQz0my0GJBymdMypMNoMf3OrOv9FAyuLbKf3IJFhICs0Yg4J3xoJOFVNM
         tp4w==
X-Gm-Message-State: ANoB5pm/XMQzPQD7apjv+LbLoH1svo6KSKHvy0cu1cZGk3V0RkKk2pVa
        JbeI5K97jF8bCwt6Z0EjKn801rmV0SoHtiLwNJYlRQ==
X-Google-Smtp-Source: AA0mqf5Fdi1C8HoKjWocGcQIozD8mKXegPPtG5z4KwdepZ0NhjD1vYymHbvlBEf2O4Jby0ejFMrO1w==
X-Received: by 2002:a05:6402:4497:b0:46c:cff8:207d with SMTP id er23-20020a056402449700b0046ccff8207dmr3006031edb.370.1670253796859;
        Mon, 05 Dec 2022 07:23:16 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kv21-20020a17090778d500b0078de26f66b9sm6322565ejc.114.2022.12.05.07.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 07:23:16 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: [patch net-next 8/8] devlink: remove port notifications from devlink_register/unregister()
Date:   Mon,  5 Dec 2022 16:22:57 +0100
Message-Id: <20221205152257.454610-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205152257.454610-1-jiri@resnulli.us>
References: <20221205152257.454610-1-jiri@resnulli.us>
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

Now when all drivers do call devl_port_register/unregister() within the
time frame during which the devlink is registered, don't walk
through empty list for port notifications in
devlink_register/unregister().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->v1:
- new patch
---
 net/core/devlink.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9b9775bc10b3..1293069896c9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9859,9 +9859,6 @@ static void devlink_notify_register(struct devlink *devlink)
 	list_for_each_entry(linecard, &devlink->linecard_list, list)
 		devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
 
-	xa_for_each(&devlink->ports, port_index, devlink_port)
-		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
-
 	list_for_each_entry(policer_item, &devlink->trap_policer_list, list)
 		devlink_trap_policer_notify(devlink, policer_item,
 					    DEVLINK_CMD_TRAP_POLICER_NEW);
@@ -9916,8 +9913,6 @@ static void devlink_notify_unregister(struct devlink *devlink)
 		devlink_trap_policer_notify(devlink, policer_item,
 					    DEVLINK_CMD_TRAP_POLICER_DEL);
 
-	xa_for_each(&devlink->ports, port_index, devlink_port)
-		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 }
 
-- 
2.37.3

