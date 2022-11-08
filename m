Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70ADA621235
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiKHNWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234414AbiKHNWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:22:20 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82934FF8F
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:22:19 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id i5-20020a1c3b05000000b003cfa97c05cdso1061538wma.4
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 05:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5Lf7LmKTzQVhRwnB5rqynMZXJln8mqbatzlfehPGMo=;
        b=Yjn6UtGE1PW7badfqoDXfn5LWbn3olf5HSKgyhtqeDgFBQe9eghFGzMYub2B48JfnP
         DM4DOZZ2iC830yEBqh51a4A9vt7Y29IVeL+iMVsXX/PPRqK+x1Vb0OxycP9rF3Mj1s1W
         irMYzczohzXQFOA5FVHxA8uCtCg0mKjmf3Loseuxa8wrCgJSCBZ9KQtPsjuv0i5HwnSz
         v0/m9YgWcdxWSI0wK7WAGWYYpLb65bTSj3uyvbDuVqKUrkNEd23anKnFlEKoJ+Zcm9DW
         HCYXEo8PP9iDEH43EOob6r84lfL8klZl61t4hBPCXBKXAvaALdy0N/1d/YJ8w9xnXYSA
         J8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5Lf7LmKTzQVhRwnB5rqynMZXJln8mqbatzlfehPGMo=;
        b=h/LZ6pUv7IcXeLXNoAp7EIzmJkeGAwHoOFRcWhmbx27U6dh5xlZ2EQeOZRA98QGdf7
         WNrkJulZTxdX9QsX6jgG2V3TJMnKiB2HVpP6YYq6MNCCMesi6YocdqQmyzIgKNvzEu7x
         Vo4csPzOI3eP/gyp1dBt87X5luU1mVjZSnF7QaFQjNJtFOBdaqQKXN+v2ICfchZBBPPp
         17qUxkY15LeWzi/wO8gnqkCOihaTt1vGeCf919tsKszaO2eVaInBTQYc9914fUpSbhKy
         Y3fYpQXZrHAaD3LdnsTHtBce5yEUiD8t4C6JJhtBr/hHhDr5DDMziJE2JJlfy9jP8HZA
         kBXQ==
X-Gm-Message-State: ACrzQf2Ra30O2O/PFDPD3kupVerPxttxDOgTBK9mWt1m8C9WO+KeamPV
        JNhTPRt/K9CxTGqWtIILbEscIqr6t3oEnfFp
X-Google-Smtp-Source: AMsMyM44r/PQTojXbMsIqOsrSYGMFkXQoW9gYIYl7fjAodDTCfPED5kyqoN//YNSmN08SMGfyY+ynA==
X-Received: by 2002:a7b:cb41:0:b0:3b3:34d6:189f with SMTP id v1-20020a7bcb41000000b003b334d6189fmr47293696wmj.6.1667913738435;
        Tue, 08 Nov 2022 05:22:18 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n41-20020a05600c502900b003c6c4639ac6sm11586686wmr.34.2022.11.08.05.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 05:22:17 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, idosch@idosch.org, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: [patch net-next v2 3/3] net: devlink: add WARN_ON to check return value of unregister_netdevice_notifier_net() call
Date:   Tue,  8 Nov 2022 14:22:08 +0100
Message-Id: <20221108132208.938676-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221108132208.938676-1-jiri@resnulli.us>
References: <20221108132208.938676-1-jiri@resnulli.us>
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
block registered, add a WARN_ON() to yell about it.

Suggested-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index ea0b319385fc..6096baf74b00 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9843,8 +9843,8 @@ void devlink_free(struct devlink *devlink)
 
 	xa_destroy(&devlink->snapshot_ids);
 
-	unregister_netdevice_notifier_net(devlink_net(devlink),
-					  &devlink->netdevice_nb);
+	WARN_ON(unregister_netdevice_notifier_net(devlink_net(devlink),
+						  &devlink->netdevice_nb));
 
 	xa_erase(&devlinks, devlink->index);
 
-- 
2.37.3

