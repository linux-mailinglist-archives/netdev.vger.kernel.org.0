Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118E252750F
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 04:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbiEOCgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 22:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbiEOCfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 22:35:39 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7586ACE03
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 19:35:22 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e4-20020a635004000000b003f252bb65faso269444pgb.2
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 19:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=s9mC8a74/srzDfRXqOZJ2sLxbf44Cz+oTregtiTYZa4=;
        b=sio8SB9GLeVm2ABq3LCIwDcFrLFp0wymSz5h06ZJ9wWecTaz3Y41jkp0lbsGSrHfds
         6cd/vVLTz39FDO5PyFS+XMKzB3MdXpee7BgBbh876pPGTZXyXFyvovqLsX1H8zoAkCbr
         fTmZaftXfpfyu7Jj66usYonyOPxGvmO3pQvbgoS0PmzvIa5M4UuJsB4a6TlChO3sRD9H
         iy/OslzUKo3n3mIVLWzbm6hgdNPCMOgQPkcxjoF6df1JmpZQOs3Y2f5HYQXu9DaviHL7
         N8vSYg2UVvfOi4JGAyvfRSrNYDMCmtbg63jTJ6cEGNjprmoKxgnmWnX8bacMYkthLT+c
         Cz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s9mC8a74/srzDfRXqOZJ2sLxbf44Cz+oTregtiTYZa4=;
        b=FaRYxE2HEWnEaFfNQox4nHqZ7ssmPVxxSv2aXV7a/ZciAZpj6/UHmr+kbmyK7+vSrA
         AWmXOx8NVM4QX21ZnStRzbUWuNiLtJqIzKLjLWOnrzEVcrQmi/eLMVlhbdcyiri44wwT
         YZkt4Gk/y6vAFm7kYHtuCNVXLvhV9/xivbY4GMANahCSTUM/10FaYqfrAfqfgCG6kKw4
         xBnp205zlgngbmxcC6etQKI3xatbLmB+Ot//5Xu89yf/pni8onunRFfr/DqI0qGO367j
         pXhInHfKMKbU/IA/klWB523mmiO8is4d2KDY65bcmmL2hG0HdL8XtTcStZG2eXBiWHa0
         r6ag==
X-Gm-Message-State: AOAM533P+eIxjcD/7Y3Op9220Ou8neoA+23dB4clfaaI0snHsPuxoPGk
        ES4GLqnV4AGKwe0GbQa0Yc4sWtEWKwqLztUM
X-Google-Smtp-Source: ABdhPJx3mm1lS9ipjv+p2kumWtYDrRS1+5bYHsLTMf3wedJTnbNM63b6Qf8gFubzZGVLeCNkV1++qQnGzWdRObSl
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a05:6a00:1145:b0:4f6:3ebc:a79b with
 SMTP id b5-20020a056a00114500b004f63ebca79bmr11679069pfm.41.1652582121541;
 Sat, 14 May 2022 19:35:21 -0700 (PDT)
Date:   Sun, 15 May 2022 02:35:03 +0000
In-Reply-To: <20220515023504.1823463-1-yosryahmed@google.com>
Message-Id: <20220515023504.1823463-7-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220515023504.1823463-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [RFC PATCH bpf-next v2 6/7] selftests/bpf: extend cgroup helpers
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends bpf selftests cgroup helpers in various ways:
- Expose enable_controllers() that allows tests to enable all or a
  subset of controllers for a specific cgroup.
- Add write_cgroup_file().
- Add join_cgroup_parent(). The cgroup workdir is based on the pid,
  therefore a spawned child cannot join the same cgroup hierarchy of the
  test through join_cgroup(). join_cgroup_parent() is used in child
  processes to join a cgroup under the parent's workdir.
- Distinguish relative and absolute cgroup paths in function arguments.
  Now relative paths are called relative_path, and absolute paths are
  called cgroup_path.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 tools/testing/selftests/bpf/cgroup_helpers.c | 158 ++++++++++++++-----
 tools/testing/selftests/bpf/cgroup_helpers.h |  14 +-
 2 files changed, 126 insertions(+), 46 deletions(-)

diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
index 9d59c3990ca8..065270b2387f 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -33,49 +33,51 @@
 #define CGROUP_MOUNT_DFLT		"/sys/fs/cgroup"
 #define NETCLS_MOUNT_PATH		CGROUP_MOUNT_DFLT "/net_cls"
 #define CGROUP_WORK_DIR			"/cgroup-test-work-dir"
-#define format_cgroup_path(buf, path) \
+
+#define format_cgroup_path_pid(buf, path, pid) \
 	snprintf(buf, sizeof(buf), "%s%s%d%s", CGROUP_MOUNT_PATH, \
-	CGROUP_WORK_DIR, getpid(), path)
+	CGROUP_WORK_DIR, pid, path)
+
+#define format_cgroup_path(buf, path) \
+	format_cgroup_path_pid(buf, path, getpid())
+
+#define format_parent_cgroup_path(buf, path) \
+	format_cgroup_path_pid(buf, path, getppid())
 
 #define format_classid_path(buf)				\
 	snprintf(buf, sizeof(buf), "%s%s", NETCLS_MOUNT_PATH,	\
 		 CGROUP_WORK_DIR)
 
-/**
- * enable_all_controllers() - Enable all available cgroup v2 controllers
- *
- * Enable all available cgroup v2 controllers in order to increase
- * the code coverage.
- *
- * If successful, 0 is returned.
- */
-static int enable_all_controllers(char *cgroup_path)
+
+static int __enable_controllers(const char *cgroup_path, const char *controllers)
 {
 	char path[PATH_MAX + 1];
-	char buf[PATH_MAX];
+	char enable[PATH_MAX + 1];
 	char *c, *c2;
 	int fd, cfd;
 	ssize_t len;
 
-	snprintf(path, sizeof(path), "%s/cgroup.controllers", cgroup_path);
-	fd = open(path, O_RDONLY);
-	if (fd < 0) {
-		log_err("Opening cgroup.controllers: %s", path);
-		return 1;
-	}
+	/* If not controllers are passed, enable all available controllers */
+	if (!controllers) {
+		snprintf(path, sizeof(path), "%s/cgroup.controllers",
+			 cgroup_path);
+		fd = open(path, O_RDONLY);
+		if (fd < 0) {
+			log_err("Opening cgroup.controllers: %s", path);
+			return 1;
+		}
 
-	len = read(fd, buf, sizeof(buf) - 1);
-	if (len < 0) {
+		len = read(fd, enable, sizeof(enable) - 1);
+		if (len < 0) {
+			close(fd);
+			log_err("Reading cgroup.controllers: %s", path);
+			return 1;
+		} else if (len == 0) /* No controllers to enable */
+			return 0;
+		enable[len] = 0;
 		close(fd);
-		log_err("Reading cgroup.controllers: %s", path);
-		return 1;
-	}
-	buf[len] = 0;
-	close(fd);
-
-	/* No controllers available? We're probably on cgroup v1. */
-	if (len == 0)
-		return 0;
+	} else
+		strncpy(enable, controllers, sizeof(enable));
 
 	snprintf(path, sizeof(path), "%s/cgroup.subtree_control", cgroup_path);
 	cfd = open(path, O_RDWR);
@@ -84,7 +86,7 @@ static int enable_all_controllers(char *cgroup_path)
 		return 1;
 	}
 
-	for (c = strtok_r(buf, " ", &c2); c; c = strtok_r(NULL, " ", &c2)) {
+	for (c = strtok_r(enable, " ", &c2); c; c = strtok_r(NULL, " ", &c2)) {
 		if (dprintf(cfd, "+%s\n", c) <= 0) {
 			log_err("Enabling controller %s: %s", c, path);
 			close(cfd);
@@ -95,6 +97,63 @@ static int enable_all_controllers(char *cgroup_path)
 	return 0;
 }
 
+/**
+ * enable_controllers() - Enable cgroup v2 controllers
+ * @relative_path: The cgroup path, relative to the workdir
+ * @controllers: List of controllers to enable in cgroup.controllers format
+ *
+ *
+ * Enable given cgroup v2 controllers, if @controllers is NULL, enable all
+ * available controllers.
+ *
+ * If successful, 0 is returned.
+ */
+int enable_controllers(const char *relative_path, const char *controllers)
+{
+	char cgroup_path[PATH_MAX + 1];
+
+	format_cgroup_path(cgroup_path, relative_path);
+	return __enable_controllers(cgroup_path, controllers);
+}
+
+
+
+/**
+ * write_cgroup_file() - Write to a cgroup file
+ * @relative_path: The cgroup path, relative to the workdir
+ * @buf: Buffer to write to the file
+ *
+ * Write to a file in the given cgroup's directory.
+ *
+ * If successful, 0 is returned.
+ */
+int write_cgroup_file(const char *relative_path, const char *file,
+		      const char *buf)
+{
+	char cgroup_path[PATH_MAX - 24];
+	char file_path[PATH_MAX + 1];
+	int fd;
+
+	format_cgroup_path(cgroup_path, relative_path);
+
+	snprintf(file_path, sizeof(file_path), "%s/%s", cgroup_path, file);
+	fd = open(file_path, O_RDWR);
+	if (fd < 0) {
+		log_err("Opening cgroup.subtree_control: %s", file_path);
+		return 1;
+	}
+
+	if (dprintf(fd, "%s", buf) <= 0) {
+		log_err("Writing to %s", file_path);
+		close(fd);
+		return 1;
+	}
+	close(fd);
+	return 0;
+}
+
+
+
 /**
  * setup_cgroup_environment() - Setup the cgroup environment
  *
@@ -133,7 +192,8 @@ int setup_cgroup_environment(void)
 		return 1;
 	}
 
-	if (enable_all_controllers(cgroup_workdir))
+	/* Enable all available controllers to increase test coverage */
+	if (__enable_controllers(cgroup_workdir, NULL))
 		return 1;
 
 	return 0;
@@ -173,7 +233,7 @@ static int join_cgroup_from_top(const char *cgroup_path)
 
 /**
  * join_cgroup() - Join a cgroup
- * @path: The cgroup path, relative to the workdir, to join
+ * @relative_path: The cgroup path, relative to the workdir, to join
  *
  * This function expects a cgroup to already be created, relative to the cgroup
  * work dir, and it joins it. For example, passing "/my-cgroup" as the path
@@ -182,11 +242,27 @@ static int join_cgroup_from_top(const char *cgroup_path)
  *
  * On success, it returns 0, otherwise on failure it returns 1.
  */
-int join_cgroup(const char *path)
+int join_cgroup(const char *relative_path)
+{
+	char cgroup_path[PATH_MAX + 1];
+
+	format_cgroup_path(cgroup_path, relative_path);
+	return join_cgroup_from_top(cgroup_path);
+}
+
+/**
+ * join_parent_cgroup() - Join a cgroup in the parent process workdir
+ * @relative_path: The cgroup path, relative to parent process workdir, to join
+ *
+ * See join_cgroup().
+ *
+ * On success, it returns 0, otherwise on failure it returns 1.
+ */
+int join_parent_cgroup(const char *relative_path)
 {
 	char cgroup_path[PATH_MAX + 1];
 
-	format_cgroup_path(cgroup_path, path);
+	format_parent_cgroup_path(cgroup_path, relative_path);
 	return join_cgroup_from_top(cgroup_path);
 }
 
@@ -214,7 +290,7 @@ void cleanup_cgroup_environment(void)
 
 /**
  * create_and_get_cgroup() - Create a cgroup, relative to workdir, and get the FD
- * @path: The cgroup path, relative to the workdir, to join
+ * @relative_path: The cgroup path, relative to the workdir, to join
  *
  * This function creates a cgroup under the top level workdir and returns the
  * file descriptor. It is idempotent.
@@ -222,14 +298,14 @@ void cleanup_cgroup_environment(void)
  * On success, it returns the file descriptor. On failure it returns -1.
  * If there is a failure, it prints the error to stderr.
  */
-int create_and_get_cgroup(const char *path)
+int create_and_get_cgroup(const char *relative_path)
 {
 	char cgroup_path[PATH_MAX + 1];
 	int fd;
 
-	format_cgroup_path(cgroup_path, path);
+	format_cgroup_path(cgroup_path, relative_path);
 	if (mkdir(cgroup_path, 0777) && errno != EEXIST) {
-		log_err("mkdiring cgroup %s .. %s", path, cgroup_path);
+		log_err("mkdiring cgroup %s .. %s", relative_path, cgroup_path);
 		return -1;
 	}
 
@@ -244,13 +320,13 @@ int create_and_get_cgroup(const char *path)
 
 /**
  * get_cgroup_id() - Get cgroup id for a particular cgroup path
- * @path: The cgroup path, relative to the workdir, to join
+ * @relative_path: The cgroup path, relative to the workdir, to join
  *
  * On success, it returns the cgroup id. On failure it returns 0,
  * which is an invalid cgroup id.
  * If there is a failure, it prints the error to stderr.
  */
-unsigned long long get_cgroup_id(const char *path)
+unsigned long long get_cgroup_id(const char *relative_path)
 {
 	int dirfd, err, flags, mount_id, fhsize;
 	union {
@@ -261,7 +337,7 @@ unsigned long long get_cgroup_id(const char *path)
 	struct file_handle *fhp, *fhp2;
 	unsigned long long ret = 0;
 
-	format_cgroup_path(cgroup_workdir, path);
+	format_cgroup_path(cgroup_workdir, relative_path);
 
 	dirfd = AT_FDCWD;
 	flags = 0;
diff --git a/tools/testing/selftests/bpf/cgroup_helpers.h b/tools/testing/selftests/bpf/cgroup_helpers.h
index fcc9cb91b211..6b1d905557c7 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.h
+++ b/tools/testing/selftests/bpf/cgroup_helpers.h
@@ -10,11 +10,15 @@
 	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)
 
 /* cgroupv2 related */
-int cgroup_setup_and_join(const char *path);
-int create_and_get_cgroup(const char *path);
-unsigned long long get_cgroup_id(const char *path);
+int enable_controllers(const char *relative_path, const char *controllers);
+int write_cgroup_file(const char *relative_path, const char *file,
+		      const char *buf);
+int cgroup_setup_and_join(const char *relative_path);
+int create_and_get_cgroup(const char *relative_path);
+unsigned long long get_cgroup_id(const char *relative_path);
 
-int join_cgroup(const char *path);
+int join_cgroup(const char *relative_path);
+int join_parent_cgroup(const char *relative_path);
 
 int setup_cgroup_environment(void);
 void cleanup_cgroup_environment(void);
@@ -26,4 +30,4 @@ int join_classid(void);
 int setup_classid_environment(void);
 void cleanup_classid_environment(void);
 
-#endif /* __CGROUP_HELPERS_H */
\ No newline at end of file
+#endif /* __CGROUP_HELPERS_H */
-- 
2.36.0.550.gb090851708-goog

