Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E53D66570D
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238161AbjAKJMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbjAKJLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:11:47 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F8711A3E
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:12 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so19334902pjj.2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sh8YPrvl3NeIt9I8HkjFYhz/XRGOeaE5lHUcSpPCiD8=;
        b=a/Si8b2IwHxpPIMEGfUChL7EWjhxYjI/NQtcD7wgfLxFMA1yzJY//xtPnAeS0D/bve
         SbJJJ2NElQOSJTGxVXyjm2aAJtejZ/Ob0SV93qfXadUoow0XTyouX6hq7c7uFc/Z7fYK
         aGfQfZg7kb3d+fWLxpfxAUeDJvat7b/pRIZ/QC06TCUbVekmpw799TfHBNnzP6Tc2lHB
         7QgcqO2ohuk64XDNmcJjrxUKXWjZYKRCoAfJtmObY+cmLI6J07PlMyKs+AweICpGNWID
         iCEopG+C3BW3+wTDJat1F+sJXLdY4FPnQr/tiPQJFH2oT0GhpDTRKRRfcFT+Gvp8OPUP
         vzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sh8YPrvl3NeIt9I8HkjFYhz/XRGOeaE5lHUcSpPCiD8=;
        b=HoHUwO6YG9/GGJdZaLLqwLD8LTeLzJRzO4z5WtbvhUUAX/wKUz8OWQt+xd8FqVn3U+
         6mlI6Isi2vUd5WzSsprDkkUp4whNdSLZjUZU4ibN1eG+fSxdEmLjJOGlfeQNADRHAr9X
         sSHaZj4tVn1G4oALy8baFO/DNe5Cip8BQ2bGRrIwAqG2FUw0dFbh/pSej5/4riua+l8w
         lM+lVLYBbVresM2xbK2A3ab3HODHyAGoXmEjjV/wFgOAkCMIxUn58g7Q/uFflqNgjlYW
         5aA0FwnD1prR94b65gygf0R9VWEigCIcz0cuV5iKmnJh5zyR6aWvHXKnJzOSwWNWXtOV
         RruQ==
X-Gm-Message-State: AFqh2krGiSOeR6NstVUVTn+rWm+XUtueI3fnLYXIyI9P6ca1uER86Awm
        zgEsHLKUNy//kndbnUJYfFC5hKkipvW8Rz7cAiHwOQ==
X-Google-Smtp-Source: AMrXdXtrdDa59Pf414Z+Y2ZsLeNnzlIdj8JlXdNwwUsODOUt1nqrkh8yvoInUb+h1FtuXs9tKAxCUg==
X-Received: by 2002:a17:90a:7343:b0:219:20b8:a6fe with SMTP id j3-20020a17090a734300b0021920b8a6femr74394885pjs.46.1673428091835;
        Wed, 11 Jan 2023 01:08:11 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id r60-20020a17090a43c200b002271b43e528sm4539882pjg.33.2023.01.11.01.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:08:11 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v4 06/10] devlink: remove reporter reference counting
Date:   Wed, 11 Jan 2023 10:07:44 +0100
Message-Id: <20230111090748.751505-7-jiri@resnulli.us>
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

As long as the reporter life time is protected by devlink instance
lock, the reference counting is no longer needed. Remove it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3
- fixed typo in patch description
---
 net/devlink/leftover.c | 113 +++++++++++------------------------------
 1 file changed, 30 insertions(+), 83 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 40226feff49b..6072436318c3 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7269,7 +7269,6 @@ struct devlink_health_reporter {
 	u64 error_count;
 	u64 recovery_count;
 	u64 last_recovery_ts;
-	refcount_t refcount;
 };
 
 void *
@@ -7328,7 +7327,6 @@ __devlink_health_reporter_create(struct devlink *devlink,
 	reporter->auto_recover = !!ops->recover;
 	reporter->auto_dump = !!ops->dump;
 	mutex_init(&reporter->dump_lock);
-	refcount_set(&reporter->refcount, 1);
 	return reporter;
 }
 
@@ -7419,13 +7417,6 @@ devlink_health_reporter_free(struct devlink_health_reporter *reporter)
 	kfree(reporter);
 }
 
-static void
-devlink_health_reporter_put(struct devlink_health_reporter *reporter)
-{
-	if (refcount_dec_and_test(&reporter->refcount))
-		devlink_health_reporter_free(reporter);
-}
-
 /**
  *	devl_health_reporter_destroy - destroy devlink health reporter
  *
@@ -7437,7 +7428,7 @@ devl_health_reporter_destroy(struct devlink_health_reporter *reporter)
 	devl_assert_locked(reporter->devlink);
 
 	list_del(&reporter->list);
-	devlink_health_reporter_put(reporter);
+	devlink_health_reporter_free(reporter);
 }
 EXPORT_SYMBOL_GPL(devl_health_reporter_destroy);
 
@@ -7681,7 +7672,6 @@ static struct devlink_health_reporter *
 devlink_health_reporter_get_from_attrs(struct devlink *devlink,
 				       struct nlattr **attrs)
 {
-	struct devlink_health_reporter *reporter;
 	struct devlink_port *devlink_port;
 	char *reporter_name;
 
@@ -7690,17 +7680,12 @@ devlink_health_reporter_get_from_attrs(struct devlink *devlink,
 
 	reporter_name = nla_data(attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME]);
 	devlink_port = devlink_port_get_from_attrs(devlink, attrs);
-	if (IS_ERR(devlink_port)) {
-		reporter = devlink_health_reporter_find_by_name(devlink, reporter_name);
-		if (reporter)
-			refcount_inc(&reporter->refcount);
-	} else {
-		reporter = devlink_port_health_reporter_find_by_name(devlink_port, reporter_name);
-		if (reporter)
-			refcount_inc(&reporter->refcount);
-	}
-
-	return reporter;
+	if (IS_ERR(devlink_port))
+		return devlink_health_reporter_find_by_name(devlink,
+							    reporter_name);
+	else
+		return devlink_port_health_reporter_find_by_name(devlink_port,
+								 reporter_name);
 }
 
 static struct devlink_health_reporter *
@@ -7759,10 +7744,8 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 		return -EINVAL;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!msg)
+		return -ENOMEM;
 
 	err = devlink_nl_health_reporter_fill(msg, reporter,
 					      DEVLINK_CMD_HEALTH_REPORTER_GET,
@@ -7770,13 +7753,10 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 					      0);
 	if (err) {
 		nlmsg_free(msg);
-		goto out;
+		return err;
 	}
 
-	err = genlmsg_reply(msg, info);
-out:
-	devlink_health_reporter_put(reporter);
-	return err;
+	return genlmsg_reply(msg, info);
 }
 
 static int
@@ -7850,7 +7830,6 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_health_reporter *reporter;
-	int err;
 
 	reporter = devlink_health_reporter_get_from_info(devlink, info);
 	if (!reporter)
@@ -7858,15 +7837,12 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 
 	if (!reporter->ops->recover &&
 	    (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] ||
-	     info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER])) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	     info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]))
+		return -EOPNOTSUPP;
+
 	if (!reporter->ops->dump &&
-	    info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	    info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
+		return -EOPNOTSUPP;
 
 	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
 		reporter->graceful_period =
@@ -7880,11 +7856,7 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 		reporter->auto_dump =
 		nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]);
 
-	devlink_health_reporter_put(reporter);
 	return 0;
-out:
-	devlink_health_reporter_put(reporter);
-	return err;
 }
 
 static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
@@ -7892,16 +7864,12 @@ static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_health_reporter *reporter;
-	int err;
 
 	reporter = devlink_health_reporter_get_from_info(devlink, info);
 	if (!reporter)
 		return -EINVAL;
 
-	err = devlink_health_reporter_recover(reporter, NULL, info->extack);
-
-	devlink_health_reporter_put(reporter);
-	return err;
+	return devlink_health_reporter_recover(reporter, NULL, info->extack);
 }
 
 static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
@@ -7916,36 +7884,27 @@ static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 	if (!reporter)
 		return -EINVAL;
 
-	if (!reporter->ops->diagnose) {
-		devlink_health_reporter_put(reporter);
+	if (!reporter->ops->diagnose)
 		return -EOPNOTSUPP;
-	}
 
 	fmsg = devlink_fmsg_alloc();
-	if (!fmsg) {
-		devlink_health_reporter_put(reporter);
+	if (!fmsg)
 		return -ENOMEM;
-	}
 
 	err = devlink_fmsg_obj_nest_start(fmsg);
 	if (err)
-		goto out;
+		return err;
 
 	err = reporter->ops->diagnose(reporter, fmsg, info->extack);
 	if (err)
-		goto out;
+		return err;
 
 	err = devlink_fmsg_obj_nest_end(fmsg);
 	if (err)
-		goto out;
-
-	err = devlink_fmsg_snd(fmsg, info,
-			       DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE, 0);
+		return err;
 
-out:
-	devlink_fmsg_free(fmsg);
-	devlink_health_reporter_put(reporter);
-	return err;
+	return devlink_fmsg_snd(fmsg, info,
+				DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE, 0);
 }
 
 static int
@@ -7960,10 +7919,9 @@ devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
 	if (!reporter)
 		return -EINVAL;
 
-	if (!reporter->ops->dump) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	if (!reporter->ops->dump)
+		return -EOPNOTSUPP;
+
 	mutex_lock(&reporter->dump_lock);
 	if (!state->idx) {
 		err = devlink_health_do_dump(reporter, NULL, cb->extack);
@@ -7981,8 +7939,6 @@ devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
 				  DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET);
 unlock:
 	mutex_unlock(&reporter->dump_lock);
-out:
-	devlink_health_reporter_put(reporter);
 	return err;
 }
 
@@ -7997,15 +7953,12 @@ devlink_nl_cmd_health_reporter_dump_clear_doit(struct sk_buff *skb,
 	if (!reporter)
 		return -EINVAL;
 
-	if (!reporter->ops->dump) {
-		devlink_health_reporter_put(reporter);
+	if (!reporter->ops->dump)
 		return -EOPNOTSUPP;
-	}
 
 	mutex_lock(&reporter->dump_lock);
 	devlink_health_dump_clear(reporter);
 	mutex_unlock(&reporter->dump_lock);
-	devlink_health_reporter_put(reporter);
 	return 0;
 }
 
@@ -8014,21 +7967,15 @@ static int devlink_nl_cmd_health_reporter_test_doit(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_health_reporter *reporter;
-	int err;
 
 	reporter = devlink_health_reporter_get_from_info(devlink, info);
 	if (!reporter)
 		return -EINVAL;
 
-	if (!reporter->ops->test) {
-		devlink_health_reporter_put(reporter);
+	if (!reporter->ops->test)
 		return -EOPNOTSUPP;
-	}
-
-	err = reporter->ops->test(reporter, info->extack);
 
-	devlink_health_reporter_put(reporter);
-	return err;
+	return reporter->ops->test(reporter, info->extack);
 }
 
 struct devlink_stats {
-- 
2.39.0

