Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B262B2C6B51
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 19:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732683AbgK0SHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 13:07:05 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:32889 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732607AbgK0SHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 13:07:05 -0500
Received: by mail-wm1-f68.google.com with SMTP id u10so2178298wmm.0
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 10:07:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WWFi7aiMWXFi2RS46UNud1ZFmvEUf9i+6CWXc3pIBig=;
        b=UAmPTxzxgiMZm27Zu3bylYby0vUi/jBhOCThm8SbGL2X8t/A61HhnugjqtJw/bheoN
         ZD8k/rxqUeBjfUeWygpnskGumM9DErdz+itopd6kfGSqJz08TDAMbh+W0uFOpteVg8N7
         Ce7yg9PC5P941qjZB/GaInPVOXrEq2ZpGukYhQ8ldLussAq3FcY6FEVKHpL7OM2HWfhU
         QQQnIuwwznn2zOKNQTlWoS0ecRMayeBjbAcjqCPjIbFpLGylcJes/4XcdDb7d8AF3iuZ
         dBMgACprVhUI/MeOp6yaFFybWQ3zF8QDA2viQzRMKG8zaVZZaB8CTJ+KKG0O6RkB+V8k
         I49Q==
X-Gm-Message-State: AOAM530bQ5/ZQZBthZ18EWpPdWMJC8Xx+3X2hHeK1DrpA8Pmd/83vEwt
        N+V91RfQgeZxuEn7qllbxhaJoLM3yc/xUg==
X-Google-Smtp-Source: ABdhPJzQtJIO4mstwnu1v+J3+iyEi+2NYi8klDmu2GgTY+Al7QNy8Ro7Jim64doA03VjZn0Z0GXk8A==
X-Received: by 2002:a1c:1bc9:: with SMTP id b192mr2089688wmb.136.1606500422138;
        Fri, 27 Nov 2020 10:07:02 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id l23sm13317703wmh.40.2020.11.27.10.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 10:07:00 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
Subject: [PATCH iproute2] ip/netns: use flock when setting up /run/netns
Date:   Fri, 27 Nov 2020 18:06:51 +0000
Message-Id: <20201127180651.80283-1-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If multiple ip processes are ran at the same time to set up
separate network namespaces, and it is the first time so /run/netns
has to be set up first, and they end up doing it at the same time,
the processes might enter a recursive loop creating thousands of
mount points, which might crash the system depending on resources
available.

Try to take a flock on /run/netns before doing the mount() dance, to
ensure this cannot happen. But do not try too hard, and if it fails
continue after printing a warning, to avoid introducing regressions.

First reported on Debian: https://bugs.debian.org/949235

To reproduce (WARNING: run in a VM to avoid system lockups):

for i in {0..9}
do
        strace -e trace=mount -e inject=mount:delay_exit=1000000 ip \
 netns add "testnetns$i" 2>&1 | tee "$i.log" &
done
wait

The strace is to ensure the problem always reproduces, to add an
artificial synchronization point after the first mount().

Reported-by: Etienne Dechamps <etienne@edechamps.fr>
Signed-off-by: Luca Boccassi <bluca@debian.org>
---
 ip/ipnetns.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 14e8e087..3e96d267 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #define _ATFILE_SOURCE
+#include <sys/file.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
@@ -801,6 +802,7 @@ static int netns_add(int argc, char **argv, bool create)
 	const char *name;
 	pid_t pid;
 	int fd;
+	int lock;
 	int made_netns_run_dir_mount = 0;
 
 	if (create) {
@@ -831,12 +833,37 @@ static int netns_add(int argc, char **argv, bool create)
 	 * namespace file in one namespace will unmount the network namespace
 	 * file in all namespaces allowing the network namespace to be freed
 	 * sooner.
+	 * These setup steps need to happen only once, as if multiple ip processes
+	 * try to attempt the same operation at the same time, the mountpoints will
+	 * be recursively created multiple times, eventually causing the system
+	 * to lock up. For example, this has been observed when multiple netns
+	 * namespaces are created in parallel at boot. See:
+	 * https://bugs.debian.org/949235
+	 * Try to take an exclusive file lock on the top level directory to ensure
+	 * this cannot happen, but proceed nonetheless if it cannot happen for any
+	 * reason.
 	 */
+	lock = open(NETNS_RUN_DIR, O_RDONLY|O_DIRECTORY, 0);
+	if (lock < 0) {
+		fprintf(stderr, "Cannot open netns runtime directory \"%s\": %s\n",
+			NETNS_RUN_DIR, strerror(errno));
+		return -1;
+	}
+	if (flock(lock, LOCK_EX) < 0) {
+		fprintf(stderr, "Warning: could not flock netns runtime directory \"%s\": %s\n",
+			NETNS_RUN_DIR, strerror(errno));
+		close(lock);
+		lock = -1;
+	}
 	while (mount("", NETNS_RUN_DIR, "none", MS_SHARED | MS_REC, NULL)) {
 		/* Fail unless we need to make the mount point */
 		if (errno != EINVAL || made_netns_run_dir_mount) {
 			fprintf(stderr, "mount --make-shared %s failed: %s\n",
 				NETNS_RUN_DIR, strerror(errno));
+			if (lock != -1) {
+				flock(lock, LOCK_UN);
+				close(lock);
+			}
 			return -1;
 		}
 
@@ -844,10 +871,18 @@ static int netns_add(int argc, char **argv, bool create)
 		if (mount(NETNS_RUN_DIR, NETNS_RUN_DIR, "none", MS_BIND | MS_REC, NULL)) {
 			fprintf(stderr, "mount --bind %s %s failed: %s\n",
 				NETNS_RUN_DIR, NETNS_RUN_DIR, strerror(errno));
+			if (lock != -1) {
+				flock(lock, LOCK_UN);
+				close(lock);
+			}
 			return -1;
 		}
 		made_netns_run_dir_mount = 1;
 	}
+	if (lock != -1) {
+		flock(lock, LOCK_UN);
+		close(lock);
+	}
 
 	/* Create the filesystem state */
 	fd = open(netns_path, O_RDONLY|O_CREAT|O_EXCL, 0);
-- 
2.29.2

