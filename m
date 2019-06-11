Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7EC3D1EE
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405444AbfFKQLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:11:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40219 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405250AbfFKQLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:11:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so13702969wre.7
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 09:11:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ybxEPwWHhX05lJ3LYs6t1i9wKFvQmjj996x3zBLDXI=;
        b=FHwpoFSRTFHIvbzoIwHzxVytoh7OBgBVPgR81/TygZIGO3rQ5oP0qYV6zuDvoa79se
         Vy7YRsCU7hX2XiphNjDHd6LPfDZwEYoFsRelTqkQ7Jol32fUPs644qAq0QymIbl3b+bV
         6n9RWS4DXb6f/8j3oxr1PQp1uXfhRAshFKN/UPMSJyYEQuni1VdydvlGeQEXec+1gf21
         mc7SN9MeicOovwT+dPN/pThydCfv2hUIoN1vAM2s4X0eFq6f0O4ahbTwuwTmJjyhOWFN
         9ubGePa0y9UWNXyBlv2REynze2E4xf7TsFLA332mEMOsJ0ral6EAFij9PjFnAdytvUat
         OhyQ==
X-Gm-Message-State: APjAAAVJ3adOUjwIzkJme2+4nh+a4wowBHPjfK+EYDF1uQyicM2LMJee
        5jCfexM4wQMrvBVmwSI8jTr3VrqlYXk=
X-Google-Smtp-Source: APXvYqzwH4xapLDxO+DUAmu8jYaiKndHRQkzPCr3SiwRRQ1Uzm6FE2YiiSbNie8C8R1NxY2GfaVMrA==
X-Received: by 2002:adf:dfc2:: with SMTP id q2mr23867946wrn.339.1560269511280;
        Tue, 11 Jun 2019 09:11:51 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y18sm4286981wmd.29.2019.06.11.09.11.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 09:11:49 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2 v2 3/3] netns: make netns_{save,restore} static
Date:   Tue, 11 Jun 2019 18:10:31 +0200
Message-Id: <20190611161031.12898-4-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611161031.12898-1-mcroce@redhat.com>
References: <20190611161031.12898-1-mcroce@redhat.com>
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
index 1fff284e..21eb5d38 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -45,6 +45,7 @@ static int usage(void)
 static struct rtnl_handle rtnsh = { .fd = -1 };
 
 static int have_rtnl_getnsid = -1;
+static int saved_netns = -1;
 
 static int ipnetns_accept_msg(struct rtnl_ctrl_data *ctrl,
 			      struct nlmsghdr *n, void *arg)
@@ -630,6 +631,33 @@ static int create_netns_dir(void)
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
@@ -723,9 +751,12 @@ static int netns_add(int argc, char **argv, bool create)
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

