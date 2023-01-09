Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6BB662F43
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237734AbjAISfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237873AbjAISdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:33:51 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627AA4D738
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:31:56 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso13757376pjt.0
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVRHYOF+iKfblag+GFexRnpMuNLYonH7OYMTB4LPPx4=;
        b=e4OZi9eki1sckoESgC3PfjePThicFfNQVimXK6LMgviOwEDhwY9wIIv8E3OppmEN5D
         B+nPQqrZ/p1/EI03RRGoBMPbdDRvxIhpr5+0vPovMsLtx+H2U3uk81ZvHChy8kHuM8Tu
         iXQIkSNIsM/IfQYF3GUgT1fsq8fnblGrNd1EeMJVCq1aE/mMlK/ZoDfAMcbxF3wkaW5T
         Hz+25FxhcqwkvIfvmMGsafIS+6akISCIi0E2GGAitfDgrPqI+Q/Fk5TWllFACHObknjm
         oUdv+u7wwctbUKPVa0/py1FYvg4CrrCK9YK0IepHY1ptqPTIchWNWsFYZQWjBjD8K3lZ
         i38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zVRHYOF+iKfblag+GFexRnpMuNLYonH7OYMTB4LPPx4=;
        b=VZJU55CUFTn2R8L4fBMgEN+Ti32Qx/z0l5niF9YgHhwfkMVThn1L8llkHZQe+dJ3BU
         7wZo2lX1WHr0f82sWSehgdR+ARqM/BnSnYgsHi9Q/AEib79OktzLxAXe4n8GNUDsXOlc
         foaP12wbVPmZFcDOYuX77+lMLEvCmLI9CcNo2p5QGHMyW7wlBn1QhZSZRyQ2EY6oqJAZ
         GRZ7Lg9RQMC52AYPJmfeNcXwmsJmPnlNRFTo6qRoxenDOar91tWMKjazqR/Rmbbr9yqk
         833HwLZeQt0+tSDJhfll0qWSoff6ZVjVlF/tx+IZ2KnptAPPTrJN0tuwCt3KOEQh2w+U
         xdmQ==
X-Gm-Message-State: AFqh2kruPZEgCYi2boJMNaFEz8wt9W9V8oaGv1UujV1R9NpKEYnkcdzv
        WAOsIx1UC0eRFfKFqpNArj11xa6l4jCJbJ0qZKl52g==
X-Google-Smtp-Source: AMrXdXtCVUDMuO4hkrwik0w/psDcGi0btk/3AqNxppLK+DFusHFljwckoNVyX4dhSjfsmsPUQ6pc8w==
X-Received: by 2002:a17:90b:158e:b0:223:b1e4:146 with SMTP id lc14-20020a17090b158e00b00223b1e40146mr65040783pjb.37.1673289115832;
        Mon, 09 Jan 2023 10:31:55 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id co9-20020a17090afe8900b001ef8ab65052sm5794484pjb.11.2023.01.09.10.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 10:31:55 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v3 09/11] devlink: convert reporters dump to devlink_nl_instance_iter_dump()
Date:   Mon,  9 Jan 2023 19:31:18 +0100
Message-Id: <20230109183120.649825-10-jiri@resnulli.us>
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
index a6a6342270b7..c54d51432f13 100644
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

