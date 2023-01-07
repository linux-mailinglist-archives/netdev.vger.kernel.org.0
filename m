Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8DE660DAA
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 11:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbjAGKMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 05:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjAGKMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 05:12:20 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0249B8060F
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 02:12:18 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id e21so2818965pfl.1
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 02:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yVFHtWNBkX8tTWYG0uORVsJ2wKs2WIoCL8X5iHUTNEE=;
        b=gkLCyt9o3jHiMGjr9t8mE9gKaZlbdZv8hjsMvC2gwVqnQjUQ6+QzCrDzVXsHsT4Xnq
         AZar1wTITD1DcHDJNHH1dk43V/xrn/pbVDR0VisJpn+deVePZvT71VT8F0rjQ82R0V+Q
         SI2tz7BTRtXIqna7H/V4XfoiCTPSCXnPyWWrvcGDvrnUFAZ1KlkB/JakOz/dMDG6yJeI
         7PXTz41pgO6MN9cOYAoxT/qHYlVX/A26BAy4LSTrG87vgFjAuX/lDXOe9SzlWDtK6iYs
         hAaR0Xts1LmYO43A+3A+R+1EOlYg2I+AdEEroqgkEqsr4ps8s5LyqKIrnUkcoZZpyFxJ
         fnJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yVFHtWNBkX8tTWYG0uORVsJ2wKs2WIoCL8X5iHUTNEE=;
        b=F0H+3uuFX9h8HCMslV/AYyVAVKaL/ZgnS21HB/NH6dDjJ/seWl6v5pNggEDVogUzl/
         Ns42MCKvRinK3/5Sqy5I5bVXf3dO2Tuu/TMqnh06MsD28MuboA4MQQyNH7/KJU+gE5qw
         nclPRaypcZP35F8cqsWdqMSQAKNewQNjXzOKl9SkwUEq0oF7QXkvZmJaP6Y+iJKwHgmy
         HR9N7AYRGZCRAcWSN/YxnVXNHB3fHhXtYlbdAKTfSLPUN93mwHc9ZC7nM0Fp/UYCh33a
         7n3mnwYIMPxPkZiDKA4ABWPNaphgtDTkImjYs4T0mGfZvHzYRZ2dnjfWTZVxuaHJ/T7P
         s0OQ==
X-Gm-Message-State: AFqh2kpw4Mn8mLTDiu4vHMDcMnzgewzuPa3xZ4QbAR7pM+gShJdm9YAK
        HH3XkjAdQvkzentMET9+Nw31j7WrzYThduRtJtvi0A==
X-Google-Smtp-Source: AMrXdXsmDKxZYPBfMXt8Qzm4F5BtuPXf9qIIxMl5TLUVe4dcCwO4Yd4UzYeyL+/CiusrXFnOMjx3xQ==
X-Received: by 2002:a62:506:0:b0:56c:7216:fbc6 with SMTP id 6-20020a620506000000b0056c7216fbc6mr58370884pff.30.1673086338703;
        Sat, 07 Jan 2023 02:12:18 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id i131-20020a628789000000b00573eb4a775esm2598728pfe.17.2023.01.07.02.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 02:12:18 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v2 7/9] devlink: convert reporters dump to devlink_nl_instance_iter_dump()
Date:   Sat,  7 Jan 2023 11:11:48 +0100
Message-Id: <20230107101151.532611-8-jiri@resnulli.us>
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
reporters .dumpit generic netlink callback to use it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- unsquashed the next patch (devlink: remove
  devlink_dump_for_each_instance_get() helper) from this one
---
 net/devlink/devl_internal.h |  1 +
 net/devlink/leftover.c      | 87 ++++++++++++++++---------------------
 net/devlink/netlink.c       |  1 +
 3 files changed, 40 insertions(+), 49 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 52d958c1c977..1f046b4ab638 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -162,6 +162,7 @@ extern const struct devlink_gen_cmd devl_gen_selftests;
 extern const struct devlink_gen_cmd devl_gen_param;
 extern const struct devlink_gen_cmd devl_gen_region;
 extern const struct devlink_gen_cmd devl_gen_info;
+extern const struct devlink_gen_cmd devl_gen_health_reporter;
 extern const struct devlink_gen_cmd devl_gen_trap;
 extern const struct devlink_gen_cmd devl_gen_trap_group;
 extern const struct devlink_gen_cmd devl_gen_trap_policer;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index c5feda997932..59fa5f543e8f 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7749,70 +7749,59 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 }
 
 static int
-devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
-					  struct netlink_callback *cb)
+devlink_nl_cmd_health_reporter_get_dump_one(struct sk_buff *msg,
+					    struct devlink *devlink,
+					    struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
+	struct devlink_health_reporter *reporter;
+	struct devlink_port *port;
+	unsigned long port_index;
+	int idx = 0;
 	int err;
 
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		struct devlink_health_reporter *reporter;
-		struct devlink_port *port;
-		unsigned long port_index;
-		int idx = 0;
-
-		devl_lock(devlink);
-		if (!devl_is_registered(devlink))
-			goto next_devlink;
-
-		list_for_each_entry(reporter, &devlink->reporter_list,
-				    list) {
+	list_for_each_entry(reporter, &devlink->reporter_list, list) {
+		if (idx < state->idx) {
+			idx++;
+			continue;
+		}
+		err = devlink_nl_health_reporter_fill(msg, reporter,
+						      DEVLINK_CMD_HEALTH_REPORTER_GET,
+						      NETLINK_CB(cb->skb).portid,
+						      cb->nlh->nlmsg_seq,
+						      NLM_F_MULTI);
+		if (err) {
+			state->idx = idx;
+			return err;
+		}
+		idx++;
+	}
+	xa_for_each(&devlink->ports, port_index, port) {
+		list_for_each_entry(reporter, &port->reporter_list, list) {
 			if (idx < state->idx) {
 				idx++;
 				continue;
 			}
-			err = devlink_nl_health_reporter_fill(
-				msg, reporter, DEVLINK_CMD_HEALTH_REPORTER_GET,
-				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
-				NLM_F_MULTI);
+			err = devlink_nl_health_reporter_fill(msg, reporter,
+							      DEVLINK_CMD_HEALTH_REPORTER_GET,
+							      NETLINK_CB(cb->skb).portid,
+							      cb->nlh->nlmsg_seq,
+							      NLM_F_MULTI);
 			if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
 				state->idx = idx;
-				goto out;
+				return err;
 			}
 			idx++;
 		}
-
-		xa_for_each(&devlink->ports, port_index, port) {
-			list_for_each_entry(reporter, &port->reporter_list, list) {
-				if (idx < state->idx) {
-					idx++;
-					continue;
-				}
-				err = devlink_nl_health_reporter_fill(
-					msg, reporter,
-					DEVLINK_CMD_HEALTH_REPORTER_GET,
-					NETLINK_CB(cb->skb).portid,
-					cb->nlh->nlmsg_seq, NLM_F_MULTI);
-				if (err) {
-					devl_unlock(devlink);
-					devlink_put(devlink);
-					state->idx = idx;
-					goto out;
-				}
-				idx++;
-			}
-		}
-next_devlink:
-		devl_unlock(devlink);
-		devlink_put(devlink);
 	}
-out:
-	return msg->len;
+
+	return 0;
 }
 
+const struct devlink_gen_cmd devl_gen_health_reporter = {
+	.dump_one		= devlink_nl_cmd_health_reporter_get_dump_one,
+};
+
 static int
 devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 					struct genl_info *info)
@@ -9179,7 +9168,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_get_doit,
-		.dumpit = devlink_nl_cmd_health_reporter_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 		/* can be retrieved by unprivileged users */
 	},
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index b18e216e09b0..d4539c1aedea 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -187,6 +187,7 @@ static const struct devlink_gen_cmd *devl_gen_cmds[] = {
 	[DEVLINK_CMD_PARAM_GET]		= &devl_gen_param,
 	[DEVLINK_CMD_REGION_GET]	= &devl_gen_region,
 	[DEVLINK_CMD_INFO_GET]		= &devl_gen_info,
+	[DEVLINK_CMD_HEALTH_REPORTER_GET] = &devl_gen_health_reporter,
 	[DEVLINK_CMD_RATE_GET]		= &devl_gen_rate_get,
 	[DEVLINK_CMD_TRAP_GET]		= &devl_gen_trap,
 	[DEVLINK_CMD_TRAP_GROUP_GET]	= &devl_gen_trap_group,
-- 
2.39.0

