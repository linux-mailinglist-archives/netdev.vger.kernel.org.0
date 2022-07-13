Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44D4573895
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbiGMOTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbiGMOTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:19:02 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61891B4B8
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:19:01 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bp15so9865996ejb.6
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qdxHGAw4fwtPClwOf0CmOMbYQKMEa4xMp9KzJ6jp6n0=;
        b=7FjdEG3xyCZnYt95lp61KRGoL3N7Lrga4eUDTttSkSWv4tz9ia35Db0a3iPapsKfK2
         6BpGhR2YNcIWX2bxt7jD/qM2fGnx1FZyDB4OOd/FvJ9L4tvqSwNNrrlxz9+eDA2GSLTI
         2dqpV3/JD0BGYMXJpCC8DU/DHFfbsqiMKexQW2QUC59DeI31oayATAO9Kleay90ZOxtz
         ErvI6/vGNlb/2wiLhplEmk34XJPJv/1ddLSIDw7Wh5brYOJ2xthfKDGcey7zWxv6g/aR
         37VFVsqhwkjOTrXyWAaajOpk7aw/VWLUtMCGvrFH7QeiggqU76yXtEKeYSTzqbvkaGSS
         IheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qdxHGAw4fwtPClwOf0CmOMbYQKMEa4xMp9KzJ6jp6n0=;
        b=ylnvryTt5GZZG+pyH/K17PZNzgOE2Hxwe4kHz+k0bY4+1Y5uubBz97VpVdh41NRDzo
         8aiXWqIdT8iQGVvJ0uEWK9kLwhEVI3YtFHuhXXPzx2aiNuZi6xKBdvQbEQ9C+pa4vZYk
         bw3xzBKgpxv+Vo86zpDvvGOgzGOb8koJglA5KD53Qi5CDFD/VLb6Nys33yBvc7XoE9nB
         tx1nDGTnHuueUFq+NXvZSlkWsyyd2YX1bw6CXfgXm1m6l8gKoHIQJcDyrAw5OE6s8m2j
         zoVLfE6n5TpBCkBeYfyipxsjGn4RvhiTLBQnYAeCW+vd6TUNSBpBEyMOApNHiYy94NG9
         ZVSA==
X-Gm-Message-State: AJIora9LmmFUW17Dak3C3jSYkwFGENyLkg9btooQfuk1/41BhF9Dfpfh
        LgD1U3fbLCyRwmZ0/U+WBk0wdOIDrk/HEFv1PX4=
X-Google-Smtp-Source: AGRyM1uz0d2y1pJpkob9X7h3UszO2ccfuw/70eylQXqXa4gvLnVdnupO4q0T4Oc9S1WoDfu98Cq1wA==
X-Received: by 2002:a17:906:8a4a:b0:72b:5b23:3065 with SMTP id gx10-20020a1709068a4a00b0072b5b233065mr3739272ejc.557.1657721940012;
        Wed, 13 Jul 2022 07:19:00 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j11-20020a50ed0b000000b0043a6b86f024sm7897036eds.67.2022.07.13.07.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 07:18:59 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next repost 3/3] net: devlink: fix return statement in devlink_port_new_notify()
Date:   Wed, 13 Jul 2022 16:18:53 +0200
Message-Id: <20220713141853.2992014-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220713141853.2992014-1-jiri@resnulli.us>
References: <20220713141853.2992014-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Return directly without intermediate value store at the end of
devlink_port_new_notify() function.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/devlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2f22ce33c3ec..a9776ea923ae 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1724,8 +1724,7 @@ static int devlink_port_new_notify(struct devlink *devlink,
 	if (err)
 		goto out;
 
-	err = genlmsg_reply(msg, info);
-	return err;
+	return genlmsg_reply(msg, info);
 
 out:
 	nlmsg_free(msg);
-- 
2.35.3

