Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAACE3BF66
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390558AbfFJWRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:17:14 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36004 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390535AbfFJWRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:17:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id u8so827796wmm.1
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WMkAXEcpXiS14xa5KFlOYd+r0apCw0Uv7ggIyWKB/YE=;
        b=oVCKplp3skZQbF1OPXb9DGNewAVpQw+9flM0y8pRIxiSJcRvcL5yHMR4bST7QiBIi5
         Fa7pSq1hEVNbX25pmWYs2pSyDZXcT4TKStq0QTtqVlZnP9aeLsR4NF4bxYUqrETx7Dk7
         ZB9ONd1sI3SK84k5sYsrls08UJ1IyLAg3I4A2UfIuEllbZrssqmdExSm4E4wQ4dBiFd9
         iYf3fvIwJMn55brGfITYaKyEH3SuHcnbGj6ueOLrZ+tHIOTkr3w0TsPOrd+CVGXUp6MA
         f9uRV7xmKGNXdUmj+ubRG17BcQS+lgjiEZNOQx4Hc5LBdmcrGWp2DYoSUducZezGPm52
         wCXQ==
X-Gm-Message-State: APjAAAV86+FxpSR+WFMp5O0TwuZUYtoEVjWMRlqYmvgo//0t6BJDpebN
        MxyDQiZM7xgfomn5ZGrHa4x6HpFxInk=
X-Google-Smtp-Source: APXvYqzU3dmbsO3XLqJhkWKNLFt3vLN7DrThars1Ig5G3IgRhJp/4UnOPg9PBSR8OPUqjSBxxIVxxw==
X-Received: by 2002:a1c:7604:: with SMTP id r4mr15339429wmc.89.1560205030175;
        Mon, 10 Jun 2019 15:17:10 -0700 (PDT)
Received: from raver.teknoraver.net (net-93-144-152-91.cust.dsl.teletu.it. [93.144.152.91])
        by smtp.gmail.com with ESMTPSA id e13sm26724539wra.16.2019.06.10.15.17.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 15:17:09 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 2/2] netns: make netns_{save,restore} static
Date:   Tue, 11 Jun 2019 00:16:13 +0200
Message-Id: <20190610221613.7554-3-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190610221613.7554-1-mcroce@redhat.com>
References: <20190610221613.7554-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netns_{save,restore} functions are only used in ipnetns.c now, since
the restore is not needed anymore after the netns exec command.
Move them in ipnetns.c, and make them static.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/namespace.h |  2 --
 ip/ip.c             |  1 -
 ip/ipnetns.c        | 31 +++++++++++++++++++++++++++++++
 lib/namespace.c     | 31 -------------------------------
 4 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/include/namespace.h b/include/namespace.h
index 89cdda11..e47f9b5d 100644
--- a/include/namespace.h
+++ b/include/namespace.h
@@ -49,8 +49,6 @@ static inline int setns(int fd, int nstype)
 }
 #endif /* HAVE_SETNS */
 
-void netns_save(void);
-void netns_restore(void);
 int netns_switch(char *netns);
 int netns_get_fd(const char *netns);
 int netns_foreach(int (*func)(char *nsname, void *arg), void *arg);
diff --git a/ip/ip.c b/ip/ip.c
index 49b3aa49..b71ae816 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -158,7 +158,6 @@ static int batch(const char *name)
 			if (!force)
 				break;
 		}
-		netns_restore();
 	}
 	if (line)
 		free(line);
diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 9e414b55..beb7fb8f 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -45,6 +45,7 @@ static int usage(void)
 static struct rtnl_handle rtnsh = { .fd = -1 };
 
 static int have_rtnl_getnsid = -1;
+static int saved_netns = -1;
 
 static int ipnetns_accept_msg(struct rtnl_ctrl_data *ctrl,
 			      struct nlmsghdr *n, void *arg)
@@ -623,6 +624,33 @@ static int create_netns_dir(void)
 	return 0;
 }
 
+/* Obtain a FD for the current namespace, so we can reenter it later */
+static void netns_save(void)
+{
+	if (saved_netns != -1)
+		return;
+
+	saved_netns = open("/proc/self/ns/net", O_RDONLY | O_CLOEXEC);
+	if (saved_netns == -1) {
+		perror("Cannot open init namespace");
+		exit(1);
+	}
+}
+
+static void netns_restore(void)
+{
+	if (saved_netns == -1)
+		return;
+
+	if (setns(saved_netns, CLONE_NEWNET)) {
+		perror("setns");
+		exit(1);
+	}
+
+	close(saved_netns);
+	saved_netns = -1;
+}
+
 static int netns_add(int argc, char **argv, bool create)
 {
 	/* This function creates a new network namespace and
@@ -716,9 +744,12 @@ static int netns_add(int argc, char **argv, bool create)
 			proc_path, netns_path, strerror(errno));
 		goto out_delete;
 	}
+	netns_restore();
+
 	return 0;
 out_delete:
 	if (create) {
+		netns_restore();
 		netns_delete(argc, argv);
 	} else if (unlink(netns_path) < 0) {
 		fprintf(stderr, "Cannot remove namespace file \"%s\": %s\n",
diff --git a/lib/namespace.c b/lib/namespace.c
index a2aea57a..06ae0a48 100644
--- a/lib/namespace.c
+++ b/lib/namespace.c
@@ -15,35 +15,6 @@
 #include "utils.h"
 #include "namespace.h"
 
-static int saved_netns = -1;
-
-/* Obtain a FD for the current namespace, so we can reenter it later */
-void netns_save(void)
-{
-	if (saved_netns != -1)
-		return;
-
-	saved_netns = open("/proc/self/ns/net", O_RDONLY | O_CLOEXEC);
-	if (saved_netns == -1) {
-		perror("Cannot open init namespace");
-		exit(1);
-	}
-}
-
-void netns_restore(void)
-{
-	if (saved_netns == -1)
-		return;
-
-	if (setns(saved_netns, CLONE_NEWNET)) {
-		perror("setns");
-		exit(1);
-	}
-
-	close(saved_netns);
-	saved_netns = -1;
-}
-
 static void bind_etc(const char *name)
 {
 	char etc_netns_path[sizeof(NETNS_ETC_DIR) + NAME_MAX];
@@ -90,8 +61,6 @@ int netns_switch(char *name)
 		return -1;
 	}
 
-	netns_save();
-
 	if (setns(netns, CLONE_NEWNET) < 0) {
 		fprintf(stderr, "setting the network namespace \"%s\" failed: %s\n",
 			name, strerror(errno));
-- 
2.21.0

