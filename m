Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7AC1CCBE5
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387527AbfJESE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:04:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36664 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729669AbfJESEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:04:55 -0400
Received: by mail-wm1-f67.google.com with SMTP id m18so8685777wmc.1
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 11:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e13oY/jcB2hfgEI8mocTN7O+j2f/oNmSYRJH7vusZLc=;
        b=BARbttHnE9dB98gwqyj2WTDff2FNwaOlri4g/V8SjkOwIal8tvabmhqCJMNxx59PLf
         W1nVBonFK+7D9TP2/kzDd/4By4xvEKveO0BqUmMbcoRxC4LU1jvp8DuNh4RelzWAU1up
         Z9O0fb/N2EuoxQ8eTYPbvUCaKsUVAdy4zymCzGEfWq28nvfFcCL24eVE8IwMS7dmH+zK
         jUeRxNQQgDRkq0ZUxSOdN/UHMr5sHlts+EFdj5ZUvk0p9PmLYt1I3QXkRxeRbfBaS/hU
         +5MrTH+TrUgySX3aTnrHHVsBwwaA7ZKvjabBhcxiMBfnubD16ovg4r/5p5+E++fDmt/c
         7QcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e13oY/jcB2hfgEI8mocTN7O+j2f/oNmSYRJH7vusZLc=;
        b=VvxdGcdY6MzJmFafPfiOdLrVYYDhgyEWUvstdCGuzkpB5mj4y6IunNKL5qPOhzGilm
         7LsV4zIjiE8Yogmvi0oyNs5GqCjQkJ6XbtL46rZVrUUseBDWwHWnham+V1htJgkCqf2Y
         spUkYXKz/KuFXC9QxFL2xF6m01S1d114SlD7A1BP/pF/WK6Ix/MNckl8UF43/MoH8Yep
         d3c+tYn3JRuDD3/WLu4hL5F+nDJiA0jZgi3OiU7VSlkzWZ+NvOoGuJdkXcXk6egPY8Xq
         eCoOpZp9rcT4vDGxCLSqflmJskMGlJFawPNm5a/Kvx3uLD4ZOdBWtzvemQhVUKRHmrF6
         TQuQ==
X-Gm-Message-State: APjAAAWnLz9jgPoAHhFa/VsFlFKvnM3YRdHqvxcmjFx9aXfNEo/ZfWu9
        Y9Tu2U6r1qYDF0ztzCIIOweGKUPm5yg=
X-Google-Smtp-Source: APXvYqwNWj+tNXR5xIpOAvZ0nGJDhFw4aOxyOEIpv6ZQsRZ+3b4qfc7C1XCw2vghsoHSsH6Aa4F6vA==
X-Received: by 2002:a1c:4e01:: with SMTP id g1mr13746795wmh.134.1570298693053;
        Sat, 05 Oct 2019 11:04:53 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c9sm9999343wrt.7.2019.10.05.11.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 11:04:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: [patch net-next 10/10] devlink: have genetlink code to parse the attrs during dumpit
Date:   Sat,  5 Oct 2019 20:04:42 +0200
Message-Id: <20191005180442.11788-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191005180442.11788-1-jiri@resnulli.us>
References: <20191005180442.11788-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Benefit from the fact that the generic netlink code can parse the attrs
for dumpit op and avoid need to parse it in the op callback.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6d16908f34b0..ae07ddb65f34 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3935,29 +3935,19 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 					     struct netlink_callback *cb)
 {
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	u64 ret_offset, start_offset, end_offset = 0;
+	struct nlattr **attrs = info->attrs;
 	struct devlink_region *region;
 	struct nlattr *chunks_attr;
 	const char *region_name;
 	struct devlink *devlink;
-	struct nlattr **attrs;
 	bool dump = true;
 	void *hdr;
 	int err;
 
 	start_offset = *((u64 *)&cb->args[0]);
 
-	attrs = kmalloc_array(DEVLINK_ATTR_MAX + 1, sizeof(*attrs), GFP_KERNEL);
-	if (!attrs)
-		return -ENOMEM;
-
-	err = nlmsg_parse_deprecated(cb->nlh,
-				     GENL_HDRLEN + devlink_nl_family.hdrsize,
-				     attrs, DEVLINK_ATTR_MAX,
-				     devlink_nl_family.policy, cb->extack);
-	if (err)
-		goto out_free;
-
 	mutex_lock(&devlink_mutex);
 	devlink = devlink_get_from_attrs(sock_net(cb->skb->sk), attrs);
 	if (IS_ERR(devlink)) {
@@ -4034,7 +4024,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	genlmsg_end(skb, hdr);
 	mutex_unlock(&devlink->lock);
 	mutex_unlock(&devlink_mutex);
-	kfree(attrs);
 
 	return skb->len;
 
@@ -4044,8 +4033,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	mutex_unlock(&devlink->lock);
 out_dev:
 	mutex_unlock(&devlink_mutex);
-out_free:
-	kfree(attrs);
 	return err;
 }
 
@@ -4987,21 +4974,10 @@ devlink_health_reporter_get_from_info(struct devlink *devlink,
 static struct devlink_health_reporter *
 devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 {
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	struct devlink_health_reporter *reporter;
+	struct nlattr **attrs = info->attrs;
 	struct devlink *devlink;
-	struct nlattr **attrs;
-	int err;
-
-	attrs = kmalloc_array(DEVLINK_ATTR_MAX + 1, sizeof(*attrs), GFP_KERNEL);
-	if (!attrs)
-		return NULL;
-
-	err = nlmsg_parse_deprecated(cb->nlh,
-				     GENL_HDRLEN + devlink_nl_family.hdrsize,
-				     attrs, DEVLINK_ATTR_MAX,
-				     devlink_nl_family.policy, cb->extack);
-	if (err)
-		goto free;
 
 	mutex_lock(&devlink_mutex);
 	devlink = devlink_get_from_attrs(sock_net(cb->skb->sk), attrs);
@@ -5010,12 +4986,9 @@ devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 
 	reporter = devlink_health_reporter_get_from_attrs(devlink, attrs);
 	mutex_unlock(&devlink_mutex);
-	kfree(attrs);
 	return reporter;
 unlock:
 	mutex_unlock(&devlink_mutex);
-free:
-	kfree(attrs);
 	return NULL;
 }
 
@@ -6146,7 +6119,8 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_REGION_READ,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT |
+			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		.dumpit = devlink_nl_cmd_region_read_dumpit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
-- 
2.21.0

