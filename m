Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC96966570B
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbjAKJM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238312AbjAKJLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:11:50 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCD2270A
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:19 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so16414273pjj.4
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fObE2+uPvvnYzP/wzsaOWEGjMZQIekRJ+GUkS+KBydo=;
        b=yIADSut8dhHeDKd//ufmcspacqyp3S9F0Xh7Rxj6KcyaI5rPz079okSahrTn2CbWio
         KX/CaE6wCSpldvHJLMMwmjuLsfCQnzpMZf7+zDzO3p/XzZtDG08HZBxpfGi/Gi0137rG
         m4wIWsQNqEAm0bvZME889bB9Pbv3qkosGlq8wnm9qkM8plnyXdVWqJSR8yrFuWhKXkF/
         WycgdqjAcxNvqrXxY7cmUWScsmOAqkgA3Z8sThYGj06OhPoAvkrGBjRqhSS1KQLZbtXc
         HK0yApQNFZ4Ep/dkbQN2e1eJjkiP8CO6t//raYc0sUCFoAD+WwKeg4CRJRNKJThju+Qw
         RCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fObE2+uPvvnYzP/wzsaOWEGjMZQIekRJ+GUkS+KBydo=;
        b=TRb0hwXgdsIUbJ1qf95JHZxk1JrNX76Ai1h1EwS/UJofmzuqhfe/Mg8fq+kPY0zcCu
         W8intlq9CcdS0qeInwpf/evZq3k6aeAbSKw7XaRZ0yBcQ0ykWeo/sGq36zLzIVYldiDb
         t81hXq3ZzVmSB8D09AKlw7Y20of4sl0Av1A3aBsXpI60n0eFd1BZGyI3xd8WkUPpHQku
         t1atwhRX9uZEefsJJAgVqhgbHr/kLPB6iRhg2IW4TfIpzcszPMazJTRmOfa+eqRiKLnw
         5dpHJb9enXSxWi2ZAoLLM75MlS7loINvt+RjdgzZvKW7yazQtspmvRqftNFRQHRISnQG
         qLHg==
X-Gm-Message-State: AFqh2krDe+Mz9vsbDia8Oo12ZAUeriMYaryYUC3zfFs5d1C61GAcA/am
        k3e+rprBPnnC2piSrTWd/LhyLTGg4GdtLt9mZiq7aw==
X-Google-Smtp-Source: AMrXdXt8LTK8eZTxMMc1PhcvYqIm8e9KY2sC+duBA7WIflz35CCSBZXG807T07TKl1MkNGrjPF6zZA==
X-Received: by 2002:a17:90b:94c:b0:228:d1d5:5468 with SMTP id dw12-20020a17090b094c00b00228d1d55468mr4768917pjb.25.1673428098805;
        Wed, 11 Jan 2023 01:08:18 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id 14-20020a630c4e000000b00478f87eaa44sm7895036pgm.35.2023.01.11.01.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:08:18 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v4 08/10] devlink: convert reporters dump to devlink_nl_instance_iter_dump()
Date:   Wed, 11 Jan 2023 10:07:46 +0100
Message-Id: <20230111090748.751505-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111090748.751505-1-jiri@resnulli.us>
References: <20230111090748.751505-1-jiri@resnulli.us>
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
index 3a3bbc0afad9..2c53759421eb 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -163,6 +163,7 @@ extern const struct devlink_gen_cmd devl_gen_selftests;
 extern const struct devlink_gen_cmd devl_gen_param;
 extern const struct devlink_gen_cmd devl_gen_region;
 extern const struct devlink_gen_cmd devl_gen_info;
+extern const struct devlink_gen_cmd devl_gen_health_reporter;
 extern const struct devlink_gen_cmd devl_gen_trap;
 extern const struct devlink_gen_cmd devl_gen_trap_group;
 extern const struct devlink_gen_cmd devl_gen_trap_policer;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 4d335095eef2..11688bd6e758 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7752,70 +7752,59 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
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
@@ -9182,7 +9171,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
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

