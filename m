Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 417895B166
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 21:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfF3T3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 15:29:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53170 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfF3T3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 15:29:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so13678043wms.2
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 12:29:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wri5o8e2GU8OC5zRxAvhvttOb5MLU3K/Z+c/ok0hyB4=;
        b=sqLj5BaWHT6Z0Yket8gVVyKkHjFn/prUVduOKfBePIAj40lq3/94Q0VkWJ8sQZNgoT
         3kfGpJHlz6AAE1b3P8bUBjuyV0+DcZI1CkvralD+sJqyAMDm/+wjPCBTq4QtG6g8pWPq
         vqD3zIZnGqwmwHtD+oQHVM7aMDp5WBh03q9w7mGQ1YO9UcNrcJFQ61xNmT9Xup+lEJrt
         RupoGGGhlZDGgFjzD0EX4O9DHLzYi1gZ63bORcMgcrvbnMacXu+UxU2tC88/AS4wAAGm
         4p0xnIh58p+XU/pRB820OR2uceSt/1wa13WV02ao0ZPxx7n7/KXJyCofvRPxx1Bv+qu0
         xxMw==
X-Gm-Message-State: APjAAAWRpS6V+maigKEswaSqHGOnfHce6QjAPpIeC53rm/rSYL1Jy8rs
        2YD7Z4vNT3/9aIYegJL7Q15zJ2aHam8=
X-Google-Smtp-Source: APXvYqxzQc+saBdPIbmQaKwycBJfaPHQUS170NtmfUL/fXMIZT2/LBGKcKczfZL2EsseyxhgGKM4/w==
X-Received: by 2002:a7b:cf32:: with SMTP id m18mr14576913wmg.27.1561922980840;
        Sun, 30 Jun 2019 12:29:40 -0700 (PDT)
Received: from raver.teknoraver.net (net-188-216-18-190.cust.vodafonedsl.it. [188.216.18.190])
        by smtp.gmail.com with ESMTPSA id h19sm13667411wrb.81.2019.06.30.12.29.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 30 Jun 2019 12:29:40 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Alexander Aring <aring@mojatatu.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [RFC iproute2] netns: add mounting state file for each netns
Date:   Sun, 30 Jun 2019 21:29:33 +0200
Message-Id: <20190630192933.30743-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ip creates a netns, there is a small time interval between the
placeholder file creation in NETNS_RUN_DIR and the bind mount from /proc.

Add a temporary file named .mounting-$netns which gets deleted after the
bind mount, so watching for delete event matching the .mounting-* name
will notify watchers only after the bind mount has been done.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 ip/ipnetns.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index a883f210..23b95173 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -24,6 +24,8 @@
 #include "namespace.h"
 #include "json_print.h"
 
+#define TMP_PREFIX ".mounting-"
+
 static int usage(void)
 {
 	fprintf(stderr,
@@ -47,6 +49,10 @@ static struct rtnl_handle rtnsh = { .fd = -1 };
 static int have_rtnl_getnsid = -1;
 static int saved_netns = -1;
 
+static int is_mounting_stab(const char *name) {
+	return !strncmp(name, TMP_PREFIX, sizeof(TMP_PREFIX) - 1);
+}
+
 static int ipnetns_accept_msg(struct rtnl_ctrl_data *ctrl,
 			      struct nlmsghdr *n, void *arg)
 {
@@ -379,6 +385,8 @@ static int netns_list(int argc, char **argv)
 			continue;
 		if (strcmp(entry->d_name, "..") == 0)
 			continue;
+		if (is_mounting_stab(entry->d_name))
+			continue;
 
 		open_json_object(NULL);
 		print_string(PRINT_ANY, "name",
@@ -676,7 +684,7 @@ static int netns_add(int argc, char **argv, bool create)
 	 * userspace tweaks like remounting /sys, or bind mounting
 	 * a new /etc/resolv.conf can be shared between users.
 	 */
-	char netns_path[PATH_MAX], proc_path[PATH_MAX];
+	char netns_path[PATH_MAX], tmp_path[PATH_MAX], proc_path[PATH_MAX];
 	const char *name;
 	pid_t pid;
 	int fd;
@@ -701,6 +709,7 @@ static int netns_add(int argc, char **argv, bool create)
 	name = argv[0];
 
 	snprintf(netns_path, sizeof(netns_path), "%s/%s", NETNS_RUN_DIR, name);
+	snprintf(tmp_path, sizeof(tmp_path), "%s/"TMP_PREFIX"%s", NETNS_RUN_DIR, name);
 
 	if (create_netns_dir())
 		return -1;
@@ -737,6 +746,14 @@ static int netns_add(int argc, char **argv, bool create)
 	}
 	close(fd);
 
+	fd = open(tmp_path, O_RDONLY|O_CREAT|O_EXCL, 0);
+	if (fd < 0) {
+		fprintf(stderr, "Cannot create namespace file \"%s\": %s\n",
+			tmp_path, strerror(errno));
+		goto out_delete;
+	}
+	close(fd);
+
 	if (create) {
 		netns_save();
 		if (unshare(CLONE_NEWNET) < 0) {
@@ -757,6 +774,7 @@ static int netns_add(int argc, char **argv, bool create)
 		goto out_delete;
 	}
 	netns_restore();
+	unlink(tmp_path);
 
 	return 0;
 out_delete:
@@ -767,6 +785,10 @@ out_delete:
 		fprintf(stderr, "Cannot remove namespace file \"%s\": %s\n",
 			netns_path, strerror(errno));
 	}
+	if (unlink(tmp_path) < 0) {
+		fprintf(stderr, "Cannot remove namespace file \"%s\": %s\n",
+			tmp_path, strerror(errno));
+	}
 	return -1;
 }
 
@@ -849,7 +871,7 @@ static int netns_monitor(int argc, char **argv)
 	if (create_netns_dir())
 		return -1;
 
-	if (inotify_add_watch(fd, NETNS_RUN_DIR, IN_CREATE | IN_DELETE) < 0) {
+	if (inotify_add_watch(fd, NETNS_RUN_DIR, IN_DELETE) < 0) {
 		fprintf(stderr, "inotify_add_watch failed: %s\n",
 			strerror(errno));
 		return -1;
@@ -865,9 +887,9 @@ static int netns_monitor(int argc, char **argv)
 		for (event = (struct inotify_event *)buf;
 		     (char *)event < &buf[len];
 		     event = (struct inotify_event *)((char *)event + sizeof(*event) + event->len)) {
-			if (event->mask & IN_CREATE)
-				printf("add %s\n", event->name);
-			if (event->mask & IN_DELETE)
+			if (is_mounting_stab(event->name))
+				printf("add %s\n", event->name + sizeof(TMP_PREFIX) - 1);
+			else
 				printf("delete %s\n", event->name);
 		}
 	}
@@ -876,8 +898,9 @@ static int netns_monitor(int argc, char **argv)
 
 static int invalid_name(const char *name)
 {
-	return !*name || strlen(name) > NAME_MAX ||
-		strchr(name, '/') || !strcmp(name, ".") || !strcmp(name, "..");
+	return !*name || strlen(name) + sizeof(TMP_PREFIX) - 1 > NAME_MAX ||
+		strchr(name, '/') || !strcmp(name, ".") || !strcmp(name, "..") ||
+		is_mounting_stab(name);
 }
 
 int do_netns(int argc, char **argv)
-- 
2.21.0

