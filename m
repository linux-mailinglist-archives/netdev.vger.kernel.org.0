Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE2E660DAC
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 11:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjAGKMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 05:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbjAGKMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 05:12:37 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2017284615
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 02:12:26 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so4323338pjj.4
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 02:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IdrlPqsJ5NX9K+BT7ia5LiF7euqWIsDiTkfPrcsCo8M=;
        b=r8Lqw+/j2uUrFx//f7v6kUgZ7N1Sy0gCDLlB87FLXJVVayzJxZxCKVvLpg1Ra8A588
         bRySd2GAMxugaEr90dLumwNySTcGUNyzFsY1sH5DLNPo4cQtOoii9aWBNxcwQDEli+DD
         ddunL16/F1iBHWId50R6SKLCptz/an/V1gQlqSuRjnvcIT1U1f0azNrDlgrOHjKEd4vv
         ia1MaknWf7QtyMeeFZyNe8omiOxEK2LkN+XkJuLgDSuUKP3sUk9ONKtG6LQGdGUGnc6u
         OVxSIFp99tg3Ob4MEV9A7iq5Op4G9G5qhWogfqp6oUClrtDJZfUJdCR93YteP2JMGNTq
         6okw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IdrlPqsJ5NX9K+BT7ia5LiF7euqWIsDiTkfPrcsCo8M=;
        b=KeWMGx1X+2H/FznxWIVTqMMSRCwQPVepsVGPeAN8u6XhioxhQjWc4WWODzV88lvuEP
         8xBP64Azkde9NAXba7/rKqbGvAKqNg8PCVHHxvTLYdyVDUUbGWLw2vnToTcQUMq7pt2l
         TsR2chV+oQ5CgI6I1cmoNLVNSKhwJLuIz0YnM6mw0CzDg+Ys3cz6IElzjUWlizcb2cAc
         DcFTrp0HnTCRqBDmiVYov4wuAkK6+zKT83S3Kpby/tEfsyqCvoyZa5AP+iS5cCpisFkv
         fV/6FI+CwQTNKdpluIYPUrrIGOzk1MZQleumbkklvbwCAjCF166e8G0wL8ZrNvkHRktW
         uxGQ==
X-Gm-Message-State: AFqh2kqBSN0rhcmZ63uv3aTMq3S8JkZjFAWs9PdWk84y5dK2svlNZAFx
        ZEO5eyM2ldfxEKnLgaqi6hck0oyGf8aSBZ85KQS2yg==
X-Google-Smtp-Source: AMrXdXvHYuVJJx+6sFh9f5P5oj4ETUHQt4a9dmd2SAWYfezCFHwlbsaLIS76+wVZVdgjqZVcbZlqXw==
X-Received: by 2002:a05:6a20:4faf:b0:b0:f6ba:e38a with SMTP id gh47-20020a056a204faf00b000b0f6bae38amr60300193pzb.33.1673086345599;
        Sat, 07 Jan 2023 02:12:25 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id b29-20020a62a11d000000b005769ccca18csm2485079pff.85.2023.01.07.02.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 02:12:25 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v2 8/9] devlink: remove devlink_dump_for_each_instance_get() helper
Date:   Sat,  7 Jan 2023 11:11:50 +0100
Message-Id: <20230107101151.532611-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230107101151.532611-1-jiri@resnulli.us>
References: <20230107101151.532611-1-jiri@resnulli.us>
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
index 1f046b4ab638..2b0e119e7b84 100644
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

