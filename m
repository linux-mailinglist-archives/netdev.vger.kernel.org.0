Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFC2662F40
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237450AbjAISeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237874AbjAISdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:33:51 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1951CE69
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:32:00 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o13so6169502pjg.2
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NZVtI4stkE2bwBcBvmfyyP6v0BqvbFzF3nXeWAKBr50=;
        b=q+XVna3S0fJE5GPLUBgGg7vMxomoj40esgEoOnoQI/U7F+ZZRmhItdRi8gUzPC6O8Y
         oKtx/YLnfwCoSC6FFSDXs8RlPrZQnybpaxokVdDpUhHrPaNFl05mOy3mM+Gx6FgtcOyl
         2ykAKO90aA1jcyQqj/nkvm1pmdVdMyIgNm3ZOFI0DXsN8pF4DEexPqdWe5xxwofFudlj
         H/K8uH+Kt0YyV1HHqAiHeq0p41FvdmEtSeFs4SjGmVv/dh+IhrYDuqSIv/vJ42lEJYUQ
         kkcFz0/6kLRolL/JGf04TCU3LCRHXkKu7qv3nXQAlLHl4EfnMtCsn8obSbg7mWSvANPX
         6TJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NZVtI4stkE2bwBcBvmfyyP6v0BqvbFzF3nXeWAKBr50=;
        b=p6odtUnoYnbEk7kd9bsHY7mJpfg5ke9JeMN65ftEpHAcFDZ2EZM54nJ2ESfCR76CrP
         N5W7PUqw3gjwiRaa1uwsh8JhCiKKgMzEP675DTcCkhvGvj1RJOsP5HKc30v816hdKXTi
         Oe0vQ2YrthRpATlNlF3eOfQI7dWwAX9fjcuOzryWS0Zf4JScdk1Al02CvRHD7vFGZTP1
         aTkWMSamLcvovdUIf9bLBADyUEYAFR6Q4L/foh3SNPP8JM2uRsqaqwnUD0Ft4KUIscg8
         MYrtRA31y+fe7N5r7krWQ4zOk0UHM3drflvkSvNYuqHAx1/eDF2zwBiAl4YUkPR92anf
         v3FQ==
X-Gm-Message-State: AFqh2koCgWRBNj0hkqarl1qs8XPWPG1C7OrDhjLRrZo/TVAz9NXxGATT
        Ew9SSwV/jVbQJEpvQx0eLnopSciCtP4eitqNLMsSMQ==
X-Google-Smtp-Source: AMrXdXuobOJ6fEU0Gj5NYOhxR6YnQjstD7C5b7p6s9t47N9o2HwVD7RlOBlblsxpBAN8kA6FeGwd+Q==
X-Received: by 2002:a05:6a21:1707:b0:af:7fe3:f0e7 with SMTP id nv7-20020a056a21170700b000af7fe3f0e7mr71184045pzb.31.1673289119433;
        Mon, 09 Jan 2023 10:31:59 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id t23-20020a17090ae51700b00226d4009505sm5819146pjy.3.2023.01.09.10.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 10:31:59 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v3 10/11] devlink: remove devlink_dump_for_each_instance_get() helper
Date:   Mon,  9 Jan 2023 19:31:19 +0100
Message-Id: <20230109183120.649825-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109183120.649825-1-jiri@resnulli.us>
References: <20230109183120.649825-1-jiri@resnulli.us>
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

devlink_dump_for_each_instance_get() is currently called from
a single place in netlink.c. As there is no need to use
this helper anywhere else in the future, remove it and
call devlinks_xa_find_get() directly from while loop
in devlink_nl_instance_iter_dump(). Also remove redundant
idx clear on loop end as it is already done
in devlink_nl_instance_iter_dump().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2: new patch, unsquashed from the previous one
---
 net/devlink/devl_internal.h | 11 -----------
 net/devlink/netlink.c       |  5 ++++-
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index c54d51432f13..647deecd1331 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -121,17 +121,6 @@ struct devlink_gen_cmd {
 			struct netlink_callback *cb);
 };
 
-/* Iterate over registered devlink instances for devlink dump.
- * devlink_put() needs to be called for each iterated devlink pointer
- * in loop body in order to release the reference.
- * Note: this is NOT a generic iterator, it makes assumptions about the use
- *	 of @state and can only be used once per dumpit implementation.
- */
-#define devlink_dump_for_each_instance_get(msg, state, devlink)		\
-	for (; (devlink = devlinks_xa_find_get(sock_net(msg->sk),	\
-					       &state->instance));	\
-	     state->instance++, state->idx = 0)
-
 extern const struct genl_small_ops devlink_nl_ops[56];
 
 struct devlink *
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index d4539c1aedea..3f44633af01c 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -207,7 +207,8 @@ int devlink_nl_instance_iter_dump(struct sk_buff *msg,
 
 	cmd = devl_gen_cmds[info->op.cmd];
 
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
+	while ((devlink = devlinks_xa_find_get(sock_net(msg->sk),
+					       &state->instance))) {
 		devl_lock(devlink);
 
 		if (devl_is_registered(devlink))
@@ -221,6 +222,8 @@ int devlink_nl_instance_iter_dump(struct sk_buff *msg,
 		if (err)
 			break;
 
+		state->instance++;
+
 		/* restart sub-object walk for the next instance */
 		state->idx = 0;
 	}
-- 
2.39.0

