Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA556386F5
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiKYKDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiKYKDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:03:05 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7210F2792D
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 02:02:59 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id vv4so9234324ejc.2
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 02:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aSYZPs3esc05WctlmmpPJtr+26/4G4F/VwmkQh7mckM=;
        b=heZgOGMOET/No+eErEgjX40wyRbMv/7i56Z8AfPf1RHe9M2FebckFCbl+SGj1ZInAP
         X435MhBiUKbno/PJju0BHtX9CPy7wh5jnMTBgNGIIyfePUabrNCekfQLuQPntJ6LGnmD
         uOplOtyPX7QpXqShgZtOw1JAuiZYLh5bG1J2bqZ2t3fOTqo2f7g0ZQe/veGDeZUR3UpO
         zKgM8iuA5LK+uBjkEOhNTw+I/hWky7lYjlJKRaSprsw8n/SxHWB2l7MDsQia2BgavNLm
         Dg18qG6P/t/Uxu3ZvhOfycZEloF21wUCywYufrAcs5whAC+6iXLdGjkEo4aI7pYqNdRp
         +b5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aSYZPs3esc05WctlmmpPJtr+26/4G4F/VwmkQh7mckM=;
        b=P8mnKgEx8tLZpCi27TX0sXGjam5t3Oh339HlcrKMxmPzl8j6jIynmiXCVgSbfkc4rF
         mP8KI1XvQA6o75TVh47l0k3dDkFM8RiXP5QOTO/EqKsZs1F4UA+HvphZfHVQBXtcrdmn
         vPkXEefUypQZSyXUjUrGHytGYmHRwksy/Kei91BAF7glG7Ls5/pVcFLkB1qbWTirj2Uy
         UdXmgMP3pVXmgUN7TTG6Q57J916Zv+eWfZffAoOJ/nrGJkdPqhomp1EJluH5k6R5eidi
         NxsTgt11xz4jqsO2E/8nDjVM1zuphMv2oLCPu4ALbjzxv37ldThk4VcCs7TqZiwDqWD9
         oXww==
X-Gm-Message-State: ANoB5pmGjxtYbhwy90atyXy54e2YmfrcI9M7lG8Pe2EhRSsh0NV+D60m
        A7PQbNXjN8MlmhHHVX1usaQbQHNTwrY6q/qI
X-Google-Smtp-Source: AA0mqf4FeXs9hLa2AJCBW7ZFnKtXZdzckPP4TuhhqbwvgtPwGUGf7mt6lvLCpDschO9H5iNwOpF3jA==
X-Received: by 2002:a17:906:564c:b0:7b2:4a9c:37e5 with SMTP id v12-20020a170906564c00b007b24a9c37e5mr32802312ejr.268.1669370578289;
        Fri, 25 Nov 2022 02:02:58 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n10-20020a170906088a00b0074136cac2e7sm1371380eje.81.2022.11.25.02.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 02:02:57 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, idosch@idosch.org
Subject: [patch net-next] net: devlink: add WARN_ON_ONCE to check return value of unregister_netdevice_notifier_net() call
Date:   Fri, 25 Nov 2022 11:02:55 +0100
Message-Id: <20221125100255.1786741-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
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

As the return value is not 0 only in case there is no such notifier
block registered, add a WARN_ON_ONCE() to yell about it.

Suggested-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index cea154ddce7a..0e10a8a68c5e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9907,8 +9907,8 @@ void devlink_free(struct devlink *devlink)
 
 	xa_destroy(&devlink->snapshot_ids);
 
-	unregister_netdevice_notifier_net(devlink_net(devlink),
-					  &devlink->netdevice_nb);
+	WARN_ON_ONCE(unregister_netdevice_notifier_net(devlink_net(devlink),
+						       &devlink->netdevice_nb));
 
 	xa_erase(&devlinks, devlink->index);
 
-- 
2.37.3

