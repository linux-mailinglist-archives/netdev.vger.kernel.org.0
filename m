Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A87DCCBE0
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbfJESEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:04:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35766 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbfJESEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:04:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id y21so8689150wmi.0
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 11:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hwjfmOljkqfzzf/k7PcsSrFnt43Wl81orVeG588p8X0=;
        b=gSTCQSIMtih6z7mLERHIUIJXukB9N22uU/0QSbFRBQZwBAxyaMtFSt5kMY9ilxA51N
         3IQ5mGVj/3Qn9LNVzs070eN0eb5E8ah/RAC0vBsbegjIScY5A10+EJWtLnrkKXcBhXXA
         O6pq8hi+i0mBWWQeulmalM3Q8nLN8F8KRfMFKX0WZL+A6nCmOvj3k3ktFiVViYuHdYY1
         rxsvFFPbPdyWWU3mwH1R9B+PBGGQJ7OC5JpNJQAz4KPjUPf6KfxXO3nyY21soxzjEW+M
         /sX6uIrHflofUnHDTxUc4xe2///btmx3pIuyVJvfJVKcdraNEB4AH3lT9s3M0OsxoILp
         eFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hwjfmOljkqfzzf/k7PcsSrFnt43Wl81orVeG588p8X0=;
        b=CWVMqjHmve+KW6d2obXz0TqICz0svaHNeZcXz1rJtXND62IBcZfVpGDWV2xiJF+JZR
         N+jK5wN3JbvlqfuGdvpOYQK20xIAL/dSvUNemaZaoH9v6X8ZNdkRU0GeQiFDef/7pc1p
         q1xtmAwjm7xnGx6umcnJV7tjAL0nRKUuAcZSwDLsqIsutrvvvScAue+7jphx1s1GMTe5
         c86jFpsHW2mwmM+RahtAHaF5eQstQVZeL7O6tshVcgTaVj9xfedjc1n3ABWJmQEZl0tJ
         iBXc6IRIbMKDHhyVKN4q29Qxq6EyHhK33P66VR0SsgKcjBABa0zKYK8vbn0JcthY23+f
         1H3Q==
X-Gm-Message-State: APjAAAVCfy7U71jSv6k8FQrDCjZANBmokVN1mqV0NPZPLazhkgvV6f5v
        YEifg7RXCZ9qgwVxyiGp0+M4rb6i7CA=
X-Google-Smtp-Source: APXvYqxqsFDG1ZHnX6UfCr2oGS0AO/X+r6Px+OsOZNzKkDgnDlTys1qFUAdNGUYvOh4RASfxAY0tAg==
X-Received: by 2002:a05:600c:2115:: with SMTP id u21mr14571639wml.168.1570298685742;
        Sat, 05 Oct 2019 11:04:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a7sm20969611wra.43.2019.10.05.11.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 11:04:45 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: [patch net-next 02/10] net: genetlink: introduce dump info struct to be available during dumpit op
Date:   Sat,  5 Oct 2019 20:04:34 +0200
Message-Id: <20191005180442.11788-3-jiri@resnulli.us>
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

Currently the cb->data is taken by ops during non-parallel dumping.
Introduce a new structure genl_dumpit_info and store the ops there.
Distribute the info to both non-parallel and parallel dumping. Also add
a helper genl_dumpit_info() to easily get the info structure in the
dumpit callback from cb.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/genetlink.h | 14 ++++++++++++
 net/netlink/genetlink.c | 47 +++++++++++++++++++++++++++++++++--------
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 9292f1c588b7..fb838f4b0089 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -127,6 +127,20 @@ enum genl_validate_flags {
 	GENL_DONT_VALIDATE_DUMP_STRICT		= BIT(2),
 };
 
+/**
+ * struct genl_info - info that is available during dumpit op call
+ * @ops: generic netlink ops - for internal genl code usage
+ */
+struct genl_dumpit_info {
+	const struct genl_ops *ops;
+};
+
+static inline const struct genl_dumpit_info *
+genl_dumpit_info(struct netlink_callback *cb)
+{
+	return cb->data;
+}
+
 /**
  * struct genl_ops - generic netlink operations
  * @cmd: command identifier
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index b5fa98b1577d..c785080e9401 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -458,10 +458,19 @@ void *genlmsg_put(struct sk_buff *skb, u32 portid, u32 seq,
 }
 EXPORT_SYMBOL(genlmsg_put);
 
+static struct genl_dumpit_info *genl_dumpit_info_alloc(void)
+{
+	return kmalloc(sizeof(struct genl_dumpit_info), GFP_KERNEL);
+}
+
+static void genl_dumpit_info_free(const struct genl_dumpit_info *info)
+{
+	kfree(info);
+}
+
 static int genl_lock_start(struct netlink_callback *cb)
 {
-	/* our ops are always const - netlink API doesn't propagate that */
-	const struct genl_ops *ops = cb->data;
+	const struct genl_ops *ops = genl_dumpit_info(cb)->ops;
 	int rc = 0;
 
 	if (ops->start) {
@@ -474,8 +483,7 @@ static int genl_lock_start(struct netlink_callback *cb)
 
 static int genl_lock_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	/* our ops are always const - netlink API doesn't propagate that */
-	const struct genl_ops *ops = cb->data;
+	const struct genl_ops *ops = genl_dumpit_info(cb)->ops;
 	int rc;
 
 	genl_lock();
@@ -486,8 +494,8 @@ static int genl_lock_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 
 static int genl_lock_done(struct netlink_callback *cb)
 {
-	/* our ops are always const - netlink API doesn't propagate that */
-	const struct genl_ops *ops = cb->data;
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
+	const struct genl_ops *ops = info->ops;
 	int rc = 0;
 
 	if (ops->done) {
@@ -495,6 +503,19 @@ static int genl_lock_done(struct netlink_callback *cb)
 		rc = ops->done(cb);
 		genl_unlock();
 	}
+	genl_dumpit_info_free(info);
+	return rc;
+}
+
+static int genl_parallel_done(struct netlink_callback *cb)
+{
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
+	const struct genl_ops *ops = info->ops;
+	int rc = 0;
+
+	if (ops->done)
+		rc = ops->done(cb);
+	genl_dumpit_info_free(info);
 	return rc;
 }
 
@@ -505,6 +526,7 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 				      const struct genl_ops *ops,
 				      int hdrlen, struct net *net)
 {
+	struct genl_dumpit_info *info;
 	int err;
 
 	if (!ops->dumpit)
@@ -528,11 +550,17 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 		}
 	}
 
+	/* Allocate dumpit info. It is going to be freed by done() callback. */
+	info = genl_dumpit_info_alloc();
+	if (!info)
+		return -ENOMEM;
+
+	info->ops = ops;
+
 	if (!family->parallel_ops) {
 		struct netlink_dump_control c = {
 			.module = family->module,
-			/* we have const, but the netlink API doesn't */
-			.data = (void *)ops,
+			.data = info,
 			.start = genl_lock_start,
 			.dump = genl_lock_dumpit,
 			.done = genl_lock_done,
@@ -545,9 +573,10 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 	} else {
 		struct netlink_dump_control c = {
 			.module = family->module,
+			.data = info,
 			.start = ops->start,
 			.dump = ops->dumpit,
-			.done = ops->done,
+			.done = genl_parallel_done,
 		};
 
 		err = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
-- 
2.21.0

