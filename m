Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D87533582
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 04:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242730AbiEYCxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 22:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237327AbiEYCxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 22:53:33 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DD83E0FB
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:53:32 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id l82so11762752qke.3
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QVrNttX2vQ/YNgTwkjoNxyvvw+b0QnDYuwI8Qdo2f8c=;
        b=IwGWi+bUsD96+US/EVzUTP37ly1J9hQRPGXUhSZp4lW9alJ9BD0hS/XV8EBWJscZEU
         uRSvwdj7HjZ3k7m4wuUmFUxcpI4+Rfpya35R2wplOCm8jBGx+VoudDwkmv5BJi99tGaD
         S25NaFXNuJsT292cgw/PL4zaosb0hy55DrgbT5ZZGi0t/LZIS1WNvKFH8n3n/aNzK/2a
         YAm9aUKt8nGnrGgm1fLca/MpOl2rndIySmSRgSwZFoAxDanT1SpTOlPmOKuQLeCISyLt
         0+3z6zX8Kq1/AV7ReXsvEI2yJKC99yPXhIXUPhiFwktEQhLenaxlxv38qbUYPMEFJ3Zr
         j7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QVrNttX2vQ/YNgTwkjoNxyvvw+b0QnDYuwI8Qdo2f8c=;
        b=2SRl2rUgi4UZn4aZDC37aXyYgE7L1He+ecKgFQgLBHRPoh2OxUmvin/yd3/8hn5Vxg
         7IGjMwK0FpQM0HagEVxpjGHRtkI32h6/4UQk8vBQNaRuuKsvEak/oKc+vca73NPXqnZ3
         petQ8/ay2MquS9xsvOpKmGUWCkUj8RPjMtvM8yrdEnFjuq1PlNHNnSrA+o1IS0gnlQcZ
         vpnr5ZapCc51KGU4inZ7ydE+png3BM8Nxos+ImeMfBTgvyXk3BwGMDWC38ZDdrQphKhf
         L1UcehXzZsRjTuz0GZNZ0SfbxOwa1suP4DVM4VCEed1xXWpGwyVzDKNKOQenm7dy0wkc
         w2CA==
X-Gm-Message-State: AOAM530jMbjf0xjFzJ7TOwguId7vTMaENdskkDV/59HMaYcMavpZ6S/S
        oXiJX8qN3qZkdyQdyx288Q==
X-Google-Smtp-Source: ABdhPJyzXwhPQp7IIa6MUuiIyyXnmVEZhlI90JInpmaHfUyHe231jIpzfk5ClJsoY19kGo2VqVOVFw==
X-Received: by 2002:a05:620a:459f:b0:6a3:a9e1:407d with SMTP id bp31-20020a05620a459f00b006a3a9e1407dmr6650337qkb.724.1653447211158;
        Tue, 24 May 2022 19:53:31 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id d15-20020a05622a15cf00b002f77a8bc37fsm658328qty.51.2022.05.24.19.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 19:53:30 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2-next 6/7] ss: Factor out fd iterating logic from user_ent_hash_build()
Date:   Tue, 24 May 2022 19:53:21 -0700
Message-Id: <cd4c5b7f756d900cf767f8e21ed084bd1e899096.1653446538.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1653446538.git.peilin.ye@bytedance.com>
References: <cover.1653446538.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

We are planning to add a thread version of the -p, --process option.
Move the logic iterating $PROC_ROOT/$PID/fd/ into a new function,
user_ent_hash_build_task(), to make it easier.

Since we will use this function for both processes and threads, rename
local variables as such (e.g. from "process" to "task").

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 misc/ss.c | 144 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 79 insertions(+), 65 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index 42d04bf432eb..07d0057b22cc 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -567,6 +567,81 @@ static void user_ent_add(unsigned int ino, char *process,
 	*pp = p;
 }
 
+#define MAX_PATH_LEN	1024
+
+static void user_ent_hash_build_task(char *path, int pid)
+{
+	const char *no_ctx = "unavailable";
+	char task[16] = {'\0', };
+	char stat[MAX_PATH_LEN];
+	int pos_id, pos_fd;
+	char *task_context;
+	struct dirent *d;
+	DIR *dir;
+
+	if (getpidcon(pid, &task_context) != 0)
+		task_context = strdup(no_ctx);
+
+	pos_id = strlen(path);	/* $PROC_ROOT/$ID/ */
+
+	snprintf(path + pos_id, MAX_PATH_LEN - pos_id, "fd/");
+	dir = opendir(path);
+	if (!dir) {
+		freecon(task_context);
+		return;
+	}
+
+	pos_fd = strlen(path);	/* $PROC_ROOT/$ID/fd/ */
+
+	while ((d = readdir(dir)) != NULL) {
+		const char *pattern = "socket:[";
+		char *sock_context;
+		unsigned int ino;
+		ssize_t link_len;
+		char lnk[64];
+		int fd;
+
+		if (sscanf(d->d_name, "%d%*c", &fd) != 1)
+			continue;
+
+		snprintf(path + pos_fd, MAX_PATH_LEN - pos_fd, "%d", fd);
+
+		link_len = readlink(path, lnk, sizeof(lnk) - 1);
+		if (link_len == -1)
+			continue;
+		lnk[link_len] = '\0';
+
+		if (strncmp(lnk, pattern, strlen(pattern)))
+			continue;
+
+		if (sscanf(lnk, "socket:[%u]", &ino) != 1)
+			continue;
+
+		if (getfilecon(path, &sock_context) <= 0)
+			sock_context = strdup(no_ctx);
+
+		if (task[0] == '\0') {
+			FILE *fp;
+
+			strlcpy(stat, path, pos_id + 1);
+			snprintf(stat + pos_id, sizeof(stat) - pos_id, "stat");
+
+			fp = fopen(stat, "r");
+			if (fp) {
+				if (fscanf(fp, "%*d (%[^)])", task) < 1)
+					; /* ignore */
+				fclose(fp);
+			}
+		}
+
+		user_ent_add(ino, task, pid, fd, task_context, sock_context);
+		freecon(sock_context);
+	}
+
+	freecon(task_context);
+	closedir(dir);
+}
+
 static void user_ent_destroy(void)
 {
 	struct user_ent *p, *p_next;
@@ -589,13 +664,10 @@ static void user_ent_destroy(void)
 static void user_ent_hash_build(void)
 {
 	const char *root = getenv("PROC_ROOT") ? : "/proc/";
+	char name[MAX_PATH_LEN];
 	struct dirent *d;
-	char name[1024];
 	int nameoff;
 	DIR *dir;
-	char *pid_context;
-	char *sock_context;
-	const char *no_ctx = "unavailable";
 
 	strlcpy(name, root, sizeof(name));
 
@@ -609,71 +681,13 @@ static void user_ent_hash_build(void)
 		return;
 
 	while ((d = readdir(dir)) != NULL) {
-		struct dirent *d1;
-		char process[16];
-		int pid, pos;
-		DIR *dir1;
+		int pid;
 
 		if (sscanf(d->d_name, "%d%*c", &pid) != 1)
 			continue;
 
-		if (getpidcon(pid, &pid_context) != 0)
-			pid_context = strdup(no_ctx);
-
-		snprintf(name + nameoff, sizeof(name) - nameoff, "%d/fd/", pid);
-		pos = strlen(name);
-		dir1 = opendir(name);
-		if (!dir1) {
-			freecon(pid_context);
-			continue;
-		}
-
-		process[0] = '\0';
-
-		while ((d1 = readdir(dir1)) != NULL) {
-			const char *pattern = "socket:[";
-			unsigned int ino;
-			char lnk[64];
-			int fd;
-			ssize_t link_len;
-			char tmp[1024];
-
-			if (sscanf(d1->d_name, "%d%*c", &fd) != 1)
-				continue;
-
-			snprintf(name + pos, sizeof(name) - pos, "%d", fd);
-
-			link_len = readlink(name, lnk, sizeof(lnk) - 1);
-			if (link_len == -1)
-				continue;
-			lnk[link_len] = '\0';
-
-			if (strncmp(lnk, pattern, strlen(pattern)))
-				continue;
-
-			if (sscanf(lnk, "socket:[%u]", &ino) != 1)
-				continue;
-
-			if (getfilecon(name, &sock_context) <= 0)
-				sock_context = strdup(no_ctx);
-
-			if (process[0] == '\0') {
-				FILE *fp;
-
-				snprintf(tmp, sizeof(tmp), "%s/%d/stat", root, pid);
-
-				fp = fopen(tmp, "r");
-				if (fp) {
-					if (fscanf(fp, "%*d (%[^)])", process) < 1)
-						; /* ignore */
-					fclose(fp);
-				}
-			}
-			user_ent_add(ino, process, pid, fd, pid_context, sock_context);
-			freecon(sock_context);
-		}
-		freecon(pid_context);
-		closedir(dir1);
+		snprintf(name + nameoff, sizeof(name) - nameoff, "%d/", pid);
+		user_ent_hash_build_task(name, pid);
 	}
 	closedir(dir);
 }
-- 
2.20.1

