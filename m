Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C68A682844
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjAaJKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbjAaJJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:09:45 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5644FC25
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:06:31 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lu11so2255170ejb.3
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMPnosERg8z5PlTOFy5T1BzKVF01KsvWvhgUyEpa6Oc=;
        b=H6j7dvBbOxgHcdDQSMlJKOQA96YWjdTXCxjVY/tGf/+IXBbgLjhzWW8kLs07L2i0cJ
         bF9YgjTGpWILoE278xRupLjgp+48sdBmGnBsuHVKOw0md7jrTAolIo/K/N7clJ+lMcFW
         VVAObEPtfSIuc7YWc3Fl5sLreT759j9UxTBNuZ8pt3l9JNwvdQz/JlsGwKwS+CfmqQ7z
         vgV2Z7HOqmTfY2QYu61WS8QeWAbgnvr9atA2JXsXGUG3NPrSeOMHfuCF/WT/bJkVOUCp
         CWiGlv72RZS/wf9QItA6IDs0TfdKdJL/eRXX71wcAvj548hImnSWf7tFSMHGCfBeMPug
         Y5+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uMPnosERg8z5PlTOFy5T1BzKVF01KsvWvhgUyEpa6Oc=;
        b=I01HPg7IgatGpdM/QIYCeF7mgAJHNHCMF8380kHCeBvikH2CykU047+42JyyCa0VCF
         qBcp4XiLXZ1/ndd2mWw4B7s/wEE+hWz6XdROEHToE8hiteM+QucfvZI8xFvj8S38Sl+M
         K1ihqyVxGOsIfQisVXwQIUrkaA4TQZldncmBq7fGk0OsJDlA49D6yRkcYDB/lVgiSwLH
         I+Ce4TaqNoF4+0px6jU0QCzLktoV22eJiaYWAtxMcYtQeY/vR99I8hKoxPAnfmR+x53Q
         VH+cp1oPnn33mw3gMotS0HdjKD90NEJXbBh6Wv0rLzs9AprX+Kw5D5A14hh3mvpPRWp/
         fhMg==
X-Gm-Message-State: AO0yUKVECnogTtqjYbo2tisLseUjCgPZsGOfyEnJOxtqRLfvGJUtX+Ul
        ce0vAv3ZNqaYwvsVgVClw+hqZQ6imcpVddVQnIc=
X-Google-Smtp-Source: AK7set9Cf7tlegGZeO+zWc9DqK/g3zfnfVdlRbmEXG46tfaPo7Um4qBOYje5Rfns8PVqTKNbPoKPKA==
X-Received: by 2002:a17:906:1017:b0:886:fcbf:a1e5 with SMTP id 23-20020a170906101700b00886fcbfa1e5mr12058676ejm.59.1675155979182;
        Tue, 31 Jan 2023 01:06:19 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id jz6-20020a17090775e600b00880dbd4b6d4sm5528479ejc.136.2023.01.31.01.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 01:06:18 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jacob.e.keller@intel.com
Subject: [patch net-next 2/3] devlink: remove "gen" from struct devlink_gen_cmd name
Date:   Tue, 31 Jan 2023 10:06:12 +0100
Message-Id: <20230131090613.2131740-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131090613.2131740-1-jiri@resnulli.us>
References: <20230131090613.2131740-1-jiri@resnulli.us>
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

No need to have "gen" inside name of the structure for devlink commands.
Remove it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/devl_internal.h | 36 ++++++++++++++++++------------------
 net/devlink/leftover.c      | 32 ++++++++++++++++----------------
 net/devlink/netlink.c       |  4 ++--
 3 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index dd4366c68b96..3910db5547fe 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -115,7 +115,7 @@ struct devlink_nl_dump_state {
 	};
 };
 
-struct devlink_gen_cmd {
+struct devlink_cmd {
 	int (*dump_one)(struct sk_buff *msg, struct devlink *devlink,
 			struct netlink_callback *cb);
 };
@@ -139,22 +139,22 @@ devlink_dump_state(struct netlink_callback *cb)
 	return (struct devlink_nl_dump_state *)cb->ctx;
 }
 
-/* gen cmds */
-extern const struct devlink_gen_cmd devl_gen_inst;
-extern const struct devlink_gen_cmd devl_gen_port;
-extern const struct devlink_gen_cmd devl_gen_sb;
-extern const struct devlink_gen_cmd devl_gen_sb_pool;
-extern const struct devlink_gen_cmd devl_gen_sb_port_pool;
-extern const struct devlink_gen_cmd devl_gen_sb_tc_pool_bind;
-extern const struct devlink_gen_cmd devl_gen_selftests;
-extern const struct devlink_gen_cmd devl_gen_param;
-extern const struct devlink_gen_cmd devl_gen_region;
-extern const struct devlink_gen_cmd devl_gen_info;
-extern const struct devlink_gen_cmd devl_gen_health_reporter;
-extern const struct devlink_gen_cmd devl_gen_trap;
-extern const struct devlink_gen_cmd devl_gen_trap_group;
-extern const struct devlink_gen_cmd devl_gen_trap_policer;
-extern const struct devlink_gen_cmd devl_gen_linecard;
+/* Commands */
+extern const struct devlink_cmd devl_gen_inst;
+extern const struct devlink_cmd devl_gen_port;
+extern const struct devlink_cmd devl_gen_sb;
+extern const struct devlink_cmd devl_gen_sb_pool;
+extern const struct devlink_cmd devl_gen_sb_port_pool;
+extern const struct devlink_cmd devl_gen_sb_tc_pool_bind;
+extern const struct devlink_cmd devl_gen_selftests;
+extern const struct devlink_cmd devl_gen_param;
+extern const struct devlink_cmd devl_gen_region;
+extern const struct devlink_cmd devl_gen_info;
+extern const struct devlink_cmd devl_gen_health_reporter;
+extern const struct devlink_cmd devl_gen_trap;
+extern const struct devlink_cmd devl_gen_trap_group;
+extern const struct devlink_cmd devl_gen_trap_policer;
+extern const struct devlink_cmd devl_gen_linecard;
 
 /* Ports */
 int devlink_port_netdevice_event(struct notifier_block *nb,
@@ -182,7 +182,7 @@ struct devlink_linecard *
 devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info);
 
 /* Rates */
-extern const struct devlink_gen_cmd devl_gen_rate_get;
+extern const struct devlink_cmd devl_gen_rate_get;
 
 struct devlink_rate *
 devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 1461eec423ff..16cb5975de1a 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1236,7 +1236,7 @@ devlink_nl_cmd_rate_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-const struct devlink_gen_cmd devl_gen_rate_get = {
+const struct devlink_cmd devl_gen_rate_get = {
 	.dump_one		= devlink_nl_cmd_rate_get_dump_one,
 };
 
@@ -1303,7 +1303,7 @@ devlink_nl_cmd_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 			       cb->nlh->nlmsg_seq, NLM_F_MULTI);
 }
 
-const struct devlink_gen_cmd devl_gen_inst = {
+const struct devlink_cmd devl_gen_inst = {
 	.dump_one		= devlink_nl_cmd_get_dump_one,
 };
 
@@ -1359,7 +1359,7 @@ devlink_nl_cmd_port_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-const struct devlink_gen_cmd devl_gen_port = {
+const struct devlink_cmd devl_gen_port = {
 	.dump_one		= devlink_nl_cmd_port_get_dump_one,
 };
 
@@ -2137,7 +2137,7 @@ static int devlink_nl_cmd_linecard_get_dump_one(struct sk_buff *msg,
 	return err;
 }
 
-const struct devlink_gen_cmd devl_gen_linecard = {
+const struct devlink_cmd devl_gen_linecard = {
 	.dump_one		= devlink_nl_cmd_linecard_get_dump_one,
 };
 
@@ -2392,7 +2392,7 @@ devlink_nl_cmd_sb_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-const struct devlink_gen_cmd devl_gen_sb = {
+const struct devlink_cmd devl_gen_sb = {
 	.dump_one		= devlink_nl_cmd_sb_get_dump_one,
 };
 
@@ -2530,7 +2530,7 @@ devlink_nl_cmd_sb_pool_get_dump_one(struct sk_buff *msg,
 	return err;
 }
 
-const struct devlink_gen_cmd devl_gen_sb_pool = {
+const struct devlink_cmd devl_gen_sb_pool = {
 	.dump_one		= devlink_nl_cmd_sb_pool_get_dump_one,
 };
 
@@ -2738,7 +2738,7 @@ devlink_nl_cmd_sb_port_pool_get_dump_one(struct sk_buff *msg,
 	return err;
 }
 
-const struct devlink_gen_cmd devl_gen_sb_port_pool = {
+const struct devlink_cmd devl_gen_sb_port_pool = {
 	.dump_one		= devlink_nl_cmd_sb_port_pool_get_dump_one,
 };
 
@@ -2973,7 +2973,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dump_one(struct sk_buff *msg,
 	return err;
 }
 
-const struct devlink_gen_cmd devl_gen_sb_tc_pool_bind = {
+const struct devlink_cmd devl_gen_sb_tc_pool_bind = {
 	.dump_one		= devlink_nl_cmd_sb_tc_pool_bind_get_dump_one,
 };
 
@@ -4785,7 +4785,7 @@ devlink_nl_cmd_selftests_get_dump_one(struct sk_buff *msg,
 					 cb->extack);
 }
 
-const struct devlink_gen_cmd devl_gen_selftests = {
+const struct devlink_cmd devl_gen_selftests = {
 	.dump_one		= devlink_nl_cmd_selftests_get_dump_one,
 };
 
@@ -5271,7 +5271,7 @@ devlink_nl_cmd_param_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-const struct devlink_gen_cmd devl_gen_param = {
+const struct devlink_cmd devl_gen_param = {
 	.dump_one		= devlink_nl_cmd_param_get_dump_one,
 };
 
@@ -5978,7 +5978,7 @@ devlink_nl_cmd_region_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return 0;
 }
 
-const struct devlink_gen_cmd devl_gen_region = {
+const struct devlink_cmd devl_gen_region = {
 	.dump_one		= devlink_nl_cmd_region_get_dump_one,
 };
 
@@ -6625,7 +6625,7 @@ devlink_nl_cmd_info_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-const struct devlink_gen_cmd devl_gen_info = {
+const struct devlink_cmd devl_gen_info = {
 	.dump_one		= devlink_nl_cmd_info_get_dump_one,
 };
 
@@ -7793,7 +7793,7 @@ devlink_nl_cmd_health_reporter_get_dump_one(struct sk_buff *msg,
 	return 0;
 }
 
-const struct devlink_gen_cmd devl_gen_health_reporter = {
+const struct devlink_cmd devl_gen_health_reporter = {
 	.dump_one		= devlink_nl_cmd_health_reporter_get_dump_one,
 };
 
@@ -8311,7 +8311,7 @@ devlink_nl_cmd_trap_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-const struct devlink_gen_cmd devl_gen_trap = {
+const struct devlink_cmd devl_gen_trap = {
 	.dump_one		= devlink_nl_cmd_trap_get_dump_one,
 };
 
@@ -8524,7 +8524,7 @@ devlink_nl_cmd_trap_group_get_dump_one(struct sk_buff *msg,
 	return err;
 }
 
-const struct devlink_gen_cmd devl_gen_trap_group = {
+const struct devlink_cmd devl_gen_trap_group = {
 	.dump_one		= devlink_nl_cmd_trap_group_get_dump_one,
 };
 
@@ -8817,7 +8817,7 @@ devlink_nl_cmd_trap_policer_get_dump_one(struct sk_buff *msg,
 	return err;
 }
 
-const struct devlink_gen_cmd devl_gen_trap_policer = {
+const struct devlink_cmd devl_gen_trap_policer = {
 	.dump_one		= devlink_nl_cmd_trap_policer_get_dump_one,
 };
 
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index 11666edf5cd2..33ed3984f3cb 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -177,7 +177,7 @@ static void devlink_nl_post_doit(const struct genl_split_ops *ops,
 	devlink_put(devlink);
 }
 
-static const struct devlink_gen_cmd *devl_gen_cmds[] = {
+static const struct devlink_cmd *devl_gen_cmds[] = {
 	[DEVLINK_CMD_GET]		= &devl_gen_inst,
 	[DEVLINK_CMD_PORT_GET]		= &devl_gen_port,
 	[DEVLINK_CMD_SB_GET]		= &devl_gen_sb,
@@ -201,7 +201,7 @@ int devlink_nl_instance_iter_dumpit(struct sk_buff *msg,
 {
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	const struct devlink_gen_cmd *cmd;
+	const struct devlink_cmd *cmd;
 	struct devlink *devlink;
 	int err = 0;
 
-- 
2.39.0

