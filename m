Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3719A67212D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjARPYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjARPXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:53 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF4648580
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:37 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id bk15so26555732ejb.9
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2vGRu8XUhbE4fgFydtufsYQZylZVxI3gUDWpNsQ2rQ=;
        b=gC8nAdpOZuc7OeLzjrYICzaLce1t89M8Z9DpzixVIJZcYRSrllCrGguAyhrjfXgj13
         fePX2auvlSEehpPNXQe/x+lM4W2p1P6qJFYyMBPnJW/dzIidwhlXcTR8uPCYeTPR436G
         XYeqNasyK+Qm/6jqk2sKF4/cc450c9PxcPi2iR8u5OY1u+8UE1jbG3wAC1k9w5pluQaT
         DfxkRF5z3bEFE5ap3ysDSPiTL9fn9vhrPwMAAkCOp0OC80WAfv6lWH3EH17IbNOzyA90
         jDV51rJY8BAN0XUGZrjB7bth6SQg41KyT2btApjv1QyZXwjWcIiSLm+8Jsrooj5HFrnT
         daog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T2vGRu8XUhbE4fgFydtufsYQZylZVxI3gUDWpNsQ2rQ=;
        b=dgaEvrHwCTVcJ2DTNJkrcUCT7o+1WKCqVEtHYXsAYi9ed9Zaid+XbZc9rMWQMTijef
         p2wgjM7WOWS5d/Y3wKqYUZWYD4K8Ees8cTyYJrjyIcxX5VrV9heckOUj1XqY2Qh4/NO2
         EhHbDwq1DNmUgi5hdoxEhTLbCsOnv/QY8NUhQTjXlFhpSkhYSBuwIL7J0/YITEntoKqP
         tf0vQkV1C79FApJ7Z7TV+w/ScSfjlw0TBzeAYAEl4nsYAtnp2Oqz3SsgD/WvkX9MNWwl
         PIYfRgn5RADPCQSMsKFNxlLp67AuW16VARhadJMULxKclhcpkXu2+EH2DED3NneMAQM6
         cN2g==
X-Gm-Message-State: AFqh2kq++ae0jtWoetgFeWJSXCCNTFWBJoYDMitZ4Z7vBKoHFFivXdgC
        tL8vxBqpKgKHlAnQb8NZByhCy/qWESkKIIPQ5tHkNw==
X-Google-Smtp-Source: AMrXdXsmcvg2zoS+toF5JN1JcjoTiVi81iqbIyZrwG43vOBMVsWzkOWBJxyzn7ZW0TnxHJFzuT9R8w==
X-Received: by 2002:a17:907:8b08:b0:860:c12c:14fd with SMTP id sz8-20020a1709078b0800b00860c12c14fdmr8216482ejc.76.1674055296485;
        Wed, 18 Jan 2023 07:21:36 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id n4-20020a170906164400b007c11e5ac250sm15084956ejd.91.2023.01.18.07.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:35 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 10/12] devlink: convert reporters dump to devlink_nl_instance_iter_dump()
Date:   Wed, 18 Jan 2023 16:21:13 +0100
Message-Id: <20230118152115.1113149-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118152115.1113149-1-jiri@resnulli.us>
References: <20230118152115.1113149-1-jiri@resnulli.us>
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
index d8f8e4bff5b4..10975e4ea2f4 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -164,6 +164,7 @@ extern const struct devlink_gen_cmd devl_gen_selftests;
 extern const struct devlink_gen_cmd devl_gen_param;
 extern const struct devlink_gen_cmd devl_gen_region;
 extern const struct devlink_gen_cmd devl_gen_info;
+extern const struct devlink_gen_cmd devl_gen_health_reporter;
 extern const struct devlink_gen_cmd devl_gen_trap;
 extern const struct devlink_gen_cmd devl_gen_trap_group;
 extern const struct devlink_gen_cmd devl_gen_trap_policer;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 8bb4c2710688..2825995704c4 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7768,70 +7768,59 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
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
@@ -9193,7 +9182,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
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

