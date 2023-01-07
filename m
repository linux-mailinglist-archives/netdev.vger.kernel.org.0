Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1C7660DA9
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 11:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjAGKMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 05:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbjAGKMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 05:12:16 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA72081D45
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 02:12:15 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c4so4285198plc.5
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 02:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z7b+dIa8qQHA/Sr0355zYfqLJQAvAHw7gJ8jDK656W0=;
        b=rj4rOqW1byNAj7M60GaActInMoVW7q2m1gBUTLIfwnS6MoCrRQUJM9oy1q01X4KJvF
         X3v12AHXPvokaUqBHb5e+JbBlqwYzAzyk28GV4DDNGrJMK6wQYOhsaRvLk9LJ4hTFUw1
         b9iiui74PxAiWFNNN9Chs57xL8lac+aqt6oWZ+jttvEbKDOHUJ4ESOYW9lfoij+i1Kk7
         RhN5ksEjkrKDCU9isU3TImXeRMMfG9oVdrK+aqrYbr0Wr9KclhRYLr1NlNogOxnTHsHO
         a9R1jD6ESsvajMJoJIMpw727jBIh+pehtmKz1sRFrk8oNIcSBc1eeTQGP8Vk/8JyJswW
         /6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z7b+dIa8qQHA/Sr0355zYfqLJQAvAHw7gJ8jDK656W0=;
        b=g9addFUWptWNrW3JBTqpiK48cBMQODlTYB7pCSR2wzxjQOerTaCXoM+XvaptyHX7Vn
         0zUElsDUdkJJaZODa53iJvgPcF6cbFN/tUROnCB3eYcR/c9p8ZRqjYKvQfQQC2CbxyMf
         p6qSDrQKFGB242Y+FUjjpyXI7PVeHzfg7MkfBKGsvHGVgbb4yheowMqyxaX80KBmSyzu
         rxU01V/lrtkAOhMfZhcqbCpmX/rQWkjFIfPL3uuN/ffTkgPpNa4hn7Z/CxSWuNxA6j1m
         5bd5oQaz0ICWJSDeqjTgetFgLhq5lAhFWlDFvQSovPa4vGGNq4ms00Xr/lYUnH4DR00M
         REJA==
X-Gm-Message-State: AFqh2kpO2sEJjt+BTHoHeeWLxw1TjlTowCX1fU08TPa+TGBeLj/P32Q6
        C+hHgNJPkxtb5IQ6uI8E9Nor951DwAOUxq2RBJBcqA==
X-Google-Smtp-Source: AMrXdXupIzWrRPmwtTfCtmkZl4CX1wCaPC0xTgjNDLKykEw+cfWyHbCPJr3dKK0oiFcmV1d3JSTZ1g==
X-Received: by 2002:a17:902:f80c:b0:189:340c:20c4 with SMTP id ix12-20020a170902f80c00b00189340c20c4mr60552730plb.66.1673086335271;
        Sat, 07 Jan 2023 02:12:15 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id s14-20020a63d04e000000b00476b165ff8bsm2170206pgi.57.2023.01.07.02.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 02:12:14 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v2 6/9] devlink: convert linecards dump to devlink_nl_instance_iter_dump()
Date:   Sat,  7 Jan 2023 11:11:47 +0100
Message-Id: <20230107101151.532611-7-jiri@resnulli.us>
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

Benefit from recently introduced instance iteration and convert
linecards .dumpit generic netlink callback to use it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/devl_internal.h |  1 +
 net/devlink/leftover.c      | 64 ++++++++++++++++---------------------
 net/devlink/netlink.c       |  1 +
 3 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 69d10b93616e..52d958c1c977 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -165,6 +165,7 @@ extern const struct devlink_gen_cmd devl_gen_info;
 extern const struct devlink_gen_cmd devl_gen_trap;
 extern const struct devlink_gen_cmd devl_gen_trap_group;
 extern const struct devlink_gen_cmd devl_gen_trap_policer;
+extern const struct devlink_gen_cmd devl_gen_linecard;
 
 /* Ports */
 int devlink_port_netdevice_event(struct notifier_block *nb,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index c512ddb6bd5e..c5feda997932 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -2105,50 +2105,42 @@ static int devlink_nl_cmd_linecard_get_doit(struct sk_buff *skb,
 	return genlmsg_reply(msg, info);
 }
 
-static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
-					      struct netlink_callback *cb)
+static int devlink_nl_cmd_linecard_get_dump_one(struct sk_buff *msg,
+						struct devlink *devlink,
+						struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink_linecard *linecard;
-	struct devlink *devlink;
-	int err;
-
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		int idx = 0;
-
-		devl_lock(devlink);
-		if (!devl_is_registered(devlink))
-			goto next_devlink;
+	int idx = 0;
+	int err = 0;
 
-		list_for_each_entry(linecard, &devlink->linecard_list, list) {
-			if (idx < state->idx) {
-				idx++;
-				continue;
-			}
-			mutex_lock(&linecard->state_lock);
-			err = devlink_nl_linecard_fill(msg, devlink, linecard,
-						       DEVLINK_CMD_LINECARD_NEW,
-						       NETLINK_CB(cb->skb).portid,
-						       cb->nlh->nlmsg_seq,
-						       NLM_F_MULTI,
-						       cb->extack);
-			mutex_unlock(&linecard->state_lock);
-			if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
-				state->idx = idx;
-				goto out;
-			}
+	list_for_each_entry(linecard, &devlink->linecard_list, list) {
+		if (idx < state->idx) {
 			idx++;
+			continue;
 		}
-next_devlink:
-		devl_unlock(devlink);
-		devlink_put(devlink);
+		mutex_lock(&linecard->state_lock);
+		err = devlink_nl_linecard_fill(msg, devlink, linecard,
+					       DEVLINK_CMD_LINECARD_NEW,
+					       NETLINK_CB(cb->skb).portid,
+					       cb->nlh->nlmsg_seq,
+					       NLM_F_MULTI,
+					       cb->extack);
+		mutex_unlock(&linecard->state_lock);
+		if (err) {
+			state->idx = idx;
+			break;
+		}
+		idx++;
 	}
-out:
-	return msg->len;
+
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_linecard = {
+	.dump_one		= devlink_nl_cmd_linecard_get_dump_one,
+};
+
 static struct devlink_linecard_type *
 devlink_linecard_type_lookup(struct devlink_linecard *linecard,
 			     const char *type)
@@ -8996,7 +8988,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_LINECARD_GET,
 		.doit = devlink_nl_cmd_linecard_get_doit,
-		.dumpit = devlink_nl_cmd_linecard_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
 		/* can be retrieved by unprivileged users */
 	},
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index 3f2ab4360f11..b18e216e09b0 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -191,6 +191,7 @@ static const struct devlink_gen_cmd *devl_gen_cmds[] = {
 	[DEVLINK_CMD_TRAP_GET]		= &devl_gen_trap,
 	[DEVLINK_CMD_TRAP_GROUP_GET]	= &devl_gen_trap_group,
 	[DEVLINK_CMD_TRAP_POLICER_GET]	= &devl_gen_trap_policer,
+	[DEVLINK_CMD_LINECARD_GET]	= &devl_gen_linecard,
 	[DEVLINK_CMD_SELFTESTS_GET]	= &devl_gen_selftests,
 };
 
-- 
2.39.0

