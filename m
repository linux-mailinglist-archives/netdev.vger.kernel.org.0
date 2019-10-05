Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7397CCBE7
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387556AbfJESFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:05:00 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42454 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfJESEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:04:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id n14so10655928wrw.9
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 11:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EwuIzklYF/EmlvjnlnIv7EG4mHTt/uPbZNf9bEpwLZs=;
        b=UATqotWeiecONOd/kdLnk68Lp03HQ9sVYN3Lrr8b+vfUqRR8Wd+XvVntcF31469P0B
         zDx1lFypWNWmxEFpCszCDX7Av+62aYLAiyis1BRJxTNw+rpXcZpV+pWWPS+1Hne5YBr+
         MJZgvrFbGTrA7jqlAfGt51zC+W5V9Vwt9/3hEKRgJaTiFZJnwktwtQ7Wt6IpaO533K+L
         AQOMnqAmZZfFRQWyHt9/f9bFZnTy9fkTScBkD45cvip2eKFtjtAVrLSkaiXiPx7xJu6+
         IkdGYYHqqbjEECGo7JomBSpEKK71aLIL/8jAsa0jpUgkuDvBjp4/6ZYme/3x3p5J2oFm
         8Smg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EwuIzklYF/EmlvjnlnIv7EG4mHTt/uPbZNf9bEpwLZs=;
        b=RMJgyzqpkV+zNqL9bqxeU1VxRR82A7p9pesO2TNiGjlXQjtVQOxPn+0uTqFmgdGIPL
         8kgG71FaT9iGExPQT4ShJe8OeXgEDMAbrbXkMH6G/SCwfGC8u58dywY2iuhmbtPOc+kH
         9l4SMeil6SxtKMHIaeP5/H7mzrPO5HEu32Z17UXSGxYDHykqGCn7MhEYiUAx1c3T18GF
         MeSKZ+4IG8BxYo5BOdMJ34fzMG1Jf/jbGDWzYL7IfOLfRwC/4C0egxh2E1os3igqNHB9
         3g/KPksEHMxLztcG9T9HiYWDbgpc6JyAfI+fbhVgSq3Osggp9SaKKP1oQ0MOrqWYehOw
         cPUQ==
X-Gm-Message-State: APjAAAX4l5Jp912OKZRPaYofy7lAEioCCvkFJl95pzrgUB0Bza/gzmu9
        JI6UaLTBYDWosfOarvDudBGHcYFzRM8=
X-Google-Smtp-Source: APXvYqzHNGQTUxykOKtoUXtMA9IE8je4wCIcEJxQaSb4Co8rty8fr3z31tEBjVTtKuX1tUUQQlPGgA==
X-Received: by 2002:a5d:52c2:: with SMTP id r2mr16718224wrv.367.1570298691317;
        Sat, 05 Oct 2019 11:04:51 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h10sm9815445wrq.95.2019.10.05.11.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 11:04:50 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: [patch net-next 08/10] net: tipc: allocate attrs locally instead of using genl_family_attrbuf in compat_dumpit()
Date:   Sat,  5 Oct 2019 20:04:40 +0200
Message-Id: <20191005180442.11788-9-jiri@resnulli.us>
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

As this is the last user of genl_family_attrbuf, convert to allocate
attrs locally and do it in a similar way this is done in compat_doit().

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/tipc/netlink.c        | 12 ------------
 net/tipc/netlink.h        |  1 -
 net/tipc/netlink_compat.c | 19 +++++++++++++++----
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
index 5f5df232d72b..d32bbd0f5e46 100644
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -271,18 +271,6 @@ struct genl_family tipc_genl_family __ro_after_init = {
 	.n_ops		= ARRAY_SIZE(tipc_genl_v2_ops),
 };
 
-int tipc_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr ***attr)
-{
-	u32 maxattr = tipc_genl_family.maxattr;
-
-	*attr = genl_family_attrbuf(&tipc_genl_family);
-	if (!*attr)
-		return -EOPNOTSUPP;
-
-	return nlmsg_parse_deprecated(nlh, GENL_HDRLEN, *attr, maxattr,
-				      tipc_nl_policy, NULL);
-}
-
 int __init tipc_netlink_start(void)
 {
 	int res;
diff --git a/net/tipc/netlink.h b/net/tipc/netlink.h
index 4ba0ad422110..7cf777723e3e 100644
--- a/net/tipc/netlink.h
+++ b/net/tipc/netlink.h
@@ -38,7 +38,6 @@
 #include <net/netlink.h>
 
 extern struct genl_family tipc_genl_family;
-int tipc_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr ***buf);
 
 struct tipc_nl_msg {
 	struct sk_buff *skb;
diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index e135d4e11231..4950b754dacd 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -186,6 +186,7 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 	struct sk_buff *buf;
 	struct nlmsghdr *nlmsg;
 	struct netlink_callback cb;
+	struct nlattr **attrbuf;
 
 	memset(&cb, 0, sizeof(cb));
 	cb.nlh = (struct nlmsghdr *)arg->data;
@@ -201,19 +202,28 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 		return -ENOMEM;
 	}
 
+	attrbuf = kmalloc_array(tipc_genl_family.maxattr + 1,
+				sizeof(struct nlattr *), GFP_KERNEL);
+	if (!attrbuf) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
 	do {
 		int rem;
 
 		len = (*cmd->dumpit)(buf, &cb);
 
 		nlmsg_for_each_msg(nlmsg, nlmsg_hdr(buf), len, rem) {
-			struct nlattr **attrs;
-
-			err = tipc_nlmsg_parse(nlmsg, &attrs);
+			err = nlmsg_parse_deprecated(nlmsg, GENL_HDRLEN,
+						     attrbuf,
+						     tipc_genl_family.maxattr,
+						     tipc_genl_family.policy,
+						     NULL);
 			if (err)
 				goto err_out;
 
-			err = (*cmd->format)(msg, attrs);
+			err = (*cmd->format)(msg, attrbuf);
 			if (err)
 				goto err_out;
 
@@ -231,6 +241,7 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 	err = 0;
 
 err_out:
+	kfree(attrbuf);
 	tipc_dump_done(&cb);
 	kfree_skb(buf);
 
-- 
2.21.0

