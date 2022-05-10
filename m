Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7555209FF
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbiEJAWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiEJAWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:22:32 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2566028C9C2
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:18:36 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i4-20020a17090332c400b0015f099f9582so3264074plr.11
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 17:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yleCgo5t9C6YacjTYCtxTmlRlPjnqWARraxO62V68mA=;
        b=Fp4BJuetfuu6Ty0lIR/0DFM7sGyxvJ+bf+ulXF9vG82QDrH+IEkboQxEjoPgcm/vxq
         HvNdU5oIysMV32+GOvDlYQ2xGBcQZC4OKSTfQ0JPIMEUMLvxu1/u/ISWWWIz3+5Ojrxn
         WCVMCbYTD3FiN/6Vc05CDBzDVgcx24F4HkTAV3C3aEMj0bnLLNRujIqeR0V7iPD94C+A
         XJDuojBy85yQJBGBAhFPVgjBVJ+YPCtvblcc532kThu+M6QDgb02OTC/kBDtaIWoZd+v
         ZVvApmbFfKQRM+mwtmL5n7qO/MTmkftMpVjvFQzmB5tj0zQaATeErjclHX1AE2o/2sB5
         x5rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yleCgo5t9C6YacjTYCtxTmlRlPjnqWARraxO62V68mA=;
        b=vsbSDhwGv3fjBcA39ka0hg6VEyWbDpNsNG3JuUkk5nNB6Rse1EJS/r8lr7h5p4myY1
         P/Px0s7+DhB29rPoMaQjHokjvumojVQNOVxcgYE05/BRv71N3Uu7SUikEXVk695wgpOq
         cYYKzJOEPOiKCCp+pg4zjTYqtovJ90bqTNxUFtGS/JQ8ER9DNr1GmBBruV1xfGgexOVd
         x2GkHVONPJPflK61/XbHf0DHUrwmIAYNBgJO6zTJRldPfUSifCML1rzXy6DlM7dcgxDa
         AN59W9nvJvsZ/VGZasMkhn3hDkF4CxYLbo4ZPF+2W1VW7c6BDv/k57OI4tjzA0nhlr/p
         1THQ==
X-Gm-Message-State: AOAM532ISPf2TUCbqCchbexDQ/6hVCnxM/ltc+bltKwOdpJUbv4tGRE1
        5rLVvP94eTohLz8qN91EUzLE9RQoy8N+gCUH
X-Google-Smtp-Source: ABdhPJx4SZliFgzZyoTIVBSCG5wxcX7td1JaH//1a81pbc8lkx3duw6U7LddmTeTtox8F6g3I1LlRI+yhqY0Cjsl
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:903:30c3:b0:15b:4232:e5d2 with SMTP
 id s3-20020a17090330c300b0015b4232e5d2mr18030341plc.167.1652141915596; Mon,
 09 May 2022 17:18:35 -0700 (PDT)
Date:   Tue, 10 May 2022 00:18:07 +0000
In-Reply-To: <20220510001807.4132027-1-yosryahmed@google.com>
Message-Id: <20220510001807.4132027-10-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220510001807.4132027-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [RFC PATCH bpf-next 9/9] selftest/bpf: add a selftest for cgroup
 hierarchical stats
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

Add a selftest that tests the whole workflow for collecting,
aggregating, and display cgroup hierarchical stats.

The test loads tracing bpf programs at the beginning and ending of
direct reclaim to measure the vmscan latency. Per-cgroup readings are
stored in percpu maps for efficiency. When a cgroup reading is updated,
bpf_cgroup_rstat_updated() is called to add the cgroup (and the current
cpu) to the rstat updated tree. When a cgroup is added to the rstat
updated tree, all its parents are added as well. rstat makes sure
cgroups are popped in a bottom up fashion.

When an rstat flush is invoked, an rstat flusher program is called for
per-cgroup per-cpu pairs on the updated tree. The program aggregates
percpu readings to a total reading, and also propagates them to the
parent. After rstat flushing is over, the program will have been invoked
for all (cgroup, cpu) pairs that have updates as well as their parents,
so the whole hierarchy will have updated (flushed) stats.

Finally, a cgroup_iter program is pinned to a file for each cgroup.
Reading this file invokes the cgroup_iter program to flush the stats and
display them to the user.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 .../test_cgroup_hierarchical_stats.c          | 335 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
 .../selftests/bpf/progs/cgroup_vmscan.c       | 211 +++++++++++
 3 files changed, 553 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_vmscan.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
new file mode 100644
index 000000000000..7c4d199967d7
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
@@ -0,0 +1,335 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Functions to manage eBPF programs attached to cgroup subsystems
+ *
+ * Copyright 2022 Google LLC.
+ */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mount.h>
+#include <unistd.h>
+#include <errno.h>
+
+#include <bpf/libbpf.h>
+#include <bpf/bpf.h>
+#include <test_progs.h>
+
+#include "cgroup_vmscan.skel.h"
+
+#define PAGE_SIZE 4096
+#define MB(x) (x << 20)
+
+#define BPFFS_ROOT "/sys/fs/bpf/"
+#define BPFFS_VMSCAN BPFFS_ROOT"vmscan/"
+#define CGROUP_ROOT "/sys/fs/cgroup/"
+
+#define RET_IF_ERR(exp, t, f...) ({		\
+	int ___res = (exp);			\
+	if (CHECK(___res, t, f))		\
+		return ___res;			\
+})
+
+struct cgroup_path {
+	const char *name, *path;
+};
+
+#define CGROUP_PATH(p, n) {.name = #n, .path = CGROUP_ROOT#p"/"#n}
+#define CGROUP_ROOT_PATH {.name = "root", .path = CGROUP_ROOT}
+
+static struct cgroup_path cgroup_hierarchy[] = {
+	CGROUP_ROOT_PATH,
+	CGROUP_PATH(, test),
+	CGROUP_PATH(test, child1),
+	CGROUP_PATH(test, child2),
+	CGROUP_PATH(test/child1, child1_1),
+	CGROUP_PATH(test/child1, child1_2),
+	CGROUP_PATH(test/child2, child2_1),
+	CGROUP_PATH(test/child2, child2_2),
+};
+
+#define N_CGROUPS (sizeof(cgroup_hierarchy)/sizeof(struct cgroup_path))
+
+static const int non_leaf_cgroups = 4;
+static __u64 cgroup_ids[N_CGROUPS];
+
+static int duration;
+
+static __u64 cgroup_id_from_path(const char *cgroup_path)
+{
+	struct stat file_stat;
+
+	if (stat(cgroup_path, &file_stat))
+		return -1;
+	return file_stat.st_ino;
+}
+
+int write_to_file(const char *path, const char *buf, size_t size)
+{
+	int fd, len, err = 0;
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -errno;
+	len = write(fd, buf, size);
+	if (len < 0)
+		err = -errno;
+	else if (len < size)
+		err = -1;
+	close(fd);
+	return err;
+}
+
+int read_from_file(const char *path, char *buf, size_t size)
+{
+	int fd, len;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+	len = read(fd, buf, size);
+	if (len >= 0)
+		buf[len] = 0;
+	close(fd);
+	return len < 0 ? -errno : 0;
+}
+
+int setup_hierarchy(void)
+{
+	int i, len;
+	char path[128];
+
+	/* Mount bpffs, and create a directory to pin cgroup_iters in */
+	RET_IF_ERR(mount("bpf", BPFFS_ROOT, "bpf", 0, NULL), "mount",
+		   "failed to mount bpffs at %s (%s)\n", BPFFS_ROOT,
+		   strerror(errno));
+	RET_IF_ERR(mkdir(BPFFS_VMSCAN, 0755), "mkdir",
+		   "failed to mkdir %s (%s)\n", BPFFS_VMSCAN, strerror(errno));
+
+	/* Mount cgroup v2 */
+	RET_IF_ERR(mount("none", CGROUP_ROOT, "cgroup2", 0, NULL),
+		   "mount", "failed to mount cgroup2 at %s (%s)\n",
+		   CGROUP_ROOT, strerror(errno));
+
+	/* Enable memory controller in cgroup v2 root */
+	len = snprintf(path, 128, "%scgroup.subtree_control", CGROUP_ROOT);
+	RET_IF_ERR(write_to_file(path, "+memory", len), "+memory",
+		   "+memory failed in root (%s)\n",
+		   strerror(errno));
+	/* Root cgroup id is 1 in v2*/
+	cgroup_ids[0] = 1;
+
+	for (i = 1; i < N_CGROUPS; i++) {
+		/* Create cgroup */
+		RET_IF_ERR(mkdir(cgroup_hierarchy[i].path, 0666),
+			   "mkdir", "failed to mkdir %s (%s)\n",
+			   cgroup_hierarchy[i].path, strerror(errno));
+
+		cgroup_ids[i] = cgroup_id_from_path(cgroup_hierarchy[i].path);
+
+		/* Enable memory controller non-leaf cgroups */
+		if (i < non_leaf_cgroups)  {
+			len = snprintf(path, 128, "%s/cgroup.subtree_control",
+				       cgroup_hierarchy[i].path);
+			RET_IF_ERR(write_to_file(path, "+memory", len),
+				   "+memory", "+memory failed in %s (%s)\n",
+				   cgroup_hierarchy[i].name, strerror(errno));
+		}
+	}
+	return 0;
+}
+
+void destroy_hierarchy(void)
+{
+	int i;
+	char path[128];
+
+	for (i = N_CGROUPS - 1; i >= 0; i--) {
+		/* Delete files in bpffs that cgroup_iters are pinned in */
+		snprintf(path, 128, "%s%s", BPFFS_VMSCAN,
+			 cgroup_hierarchy[i].name);
+		CHECK(remove(path), "remove", "failed to remove %s (%s)\n",
+		      path, strerror(errno));
+
+		if (i == 0)
+			break;
+
+		/* Delete cgroup */
+		CHECK(rmdir(cgroup_hierarchy[i].path), "rmdir",
+		      "failed to rmdir %s (%s)\n", cgroup_hierarchy[i].path,
+		      strerror(errno));
+	}
+	/* Remove created directory in bpffs */
+	CHECK(rmdir(BPFFS_VMSCAN), "rmdir", "failed to rmdir %s (%s)\n",
+	      BPFFS_VMSCAN, strerror(errno));
+	/* Unmount bpffs */
+	CHECK(umount(BPFFS_ROOT), "umount", "failed to unmount bpffs (%s)\n",
+	      strerror(errno));
+	/* Unmount cgroup v2 */
+	CHECK(umount(CGROUP_ROOT), "umount", "failed to unmount cgroup2 (%s)\n",
+	      strerror(errno));
+}
+
+void alloc_anon(size_t size)
+{
+	char *buf, *ptr;
+
+	buf = malloc(size);
+	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+		*ptr = 0;
+	free(buf);
+}
+
+int induce_vmscan(void)
+{
+	char cmd[128], path[128];
+	int i, pid, len;
+
+	/*
+	 * Set memory.high for test parent cgroup to 1 MB to throttle
+	 * allocations and invoke reclaim in children.
+	 */
+	snprintf(path, 128, "%s/memory.high", cgroup_hierarchy[1].path);
+	len = snprintf(cmd, 128, "%d", MB(1));
+	RET_IF_ERR(write_to_file(path, cmd, len), "memory.high",
+		   "failed to write to %s (%s)\n", path, strerror(errno));
+
+	/*
+	 * In every leaf cgroup, run a memory hog for a few seconds to induce
+	 * reclaim then kill it.
+	 */
+	for (i = non_leaf_cgroups; i < N_CGROUPS; i++) {
+		pid = fork();
+		if (pid == 0) {
+			pid = getpid();
+
+			/* Add child to leaf cgroup */
+			snprintf(path, 128, "%s/cgroup.procs",
+				 cgroup_hierarchy[i].path);
+			len = snprintf(cmd, 128, "%d", pid);
+			RET_IF_ERR(write_to_file(path, cmd, len),
+				   "cgroup.procs",
+				   "failed to add pid %d to cgroup %s (%s)\n",
+				   pid, cgroup_hierarchy[i].name,
+				   strerror(errno));
+
+			/* Allocate 2 MB  */
+			alloc_anon(MB(2));
+			exit(0);
+		} else {
+			/* Wait for child to cause reclaim then kill it */
+			sleep(3);
+			kill(pid, SIGKILL);
+			waitpid(pid, NULL, 0);
+		}
+	}
+	return 0;
+}
+
+int check_vmscan_stats(void)
+{
+	char buf[128], path[128];
+	int i;
+	__u64 vmscan_readings[N_CGROUPS];
+
+	for (i = 0; i < N_CGROUPS; i++) {
+		__u64 id;
+
+		/* For every cgroup, read the file generated by cgroup_iter */
+		snprintf(path, 128, "%s%s", BPFFS_VMSCAN,
+			cgroup_hierarchy[i].name);
+		RET_IF_ERR(read_from_file(path, buf, 128), "read",
+			   "failed to read from %s (%s)\n",
+			   path, strerror(errno));
+		/* Check the output file formatting */
+		ASSERT_EQ(sscanf(buf, "cg_id: %llu, total_vmscan_delay: %llu\n",
+				 &id, &vmscan_readings[i]), 2, "output format");
+
+		/* Check that the cgroup_id is displayed correctly */
+		ASSERT_EQ(cgroup_ids[i], id, "cgroup_id");
+		/* Check that the vmscan reading is non-zerp */
+		ASSERT_NEQ(vmscan_readings[i], 0, "vmscan_reading");
+	}
+
+	/* Check that child1 == child1_1 + child1_2 */
+	ASSERT_EQ(vmscan_readings[2], vmscan_readings[4] + vmscan_readings[5],
+		  "child1_vmscan");
+	/* Check that child2 == child2_1 + child2_2 */
+	ASSERT_EQ(vmscan_readings[3], vmscan_readings[6] + vmscan_readings[7],
+		  "child2_vmscan");
+	/* Check that test == child1 + child2 */
+	ASSERT_EQ(vmscan_readings[1], vmscan_readings[2] + vmscan_readings[3],
+		  "test_vmscan");
+	/* Check that root >= test */
+	ASSERT_GE(vmscan_readings[0], vmscan_readings[1], "root_vmscan");
+
+	return 0;
+}
+
+int setup_progs(struct cgroup_vmscan **skel)
+{
+	int i;
+	struct bpf_link *link;
+	struct cgroup_vmscan *obj;
+
+	obj = cgroup_vmscan__open_and_load();
+	if (!ASSERT_OK_PTR(obj, "open_and_load"))
+		return libbpf_get_error(obj);
+
+	/* Attach rstat flusher to memory subsystem */
+	link = bpf_program__attach_subsys(obj->progs.vmscan_flush, "memory");
+	if (!ASSERT_OK_PTR(link, "attach_subsys"))
+		return libbpf_get_error(link);
+
+	/* Attach cgroup_iter program that will dump the stats to cgroups */
+	for (i = 0; i < N_CGROUPS; i++) {
+		DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+		union bpf_iter_link_info linfo = {};
+		char path[128];
+
+		/* Create an iter link, parameterized by cgroup id */
+		linfo.cgroup.cgroup_id = cgroup_ids[i];
+		opts.link_info = &linfo;
+		opts.link_info_len = sizeof(linfo);
+		link = bpf_program__attach_iter(obj->progs.dump_vmscan, &opts);
+		if (!ASSERT_OK_PTR(link, "attach_iter"))
+			return libbpf_get_error(link);
+
+		/* Pin the link to a bpffs file */
+		snprintf(path, 128, "%s%s", BPFFS_VMSCAN,
+			 cgroup_hierarchy[i].name);
+		bpf_link__pin(link, path);
+	}
+
+	/* Attach tracing programs that will calculate vmscan delays */
+	link = bpf_program__attach(obj->progs.vmscan_start);
+	if (!ASSERT_OK_PTR(obj, "attach"))
+		return libbpf_get_error(obj);
+
+	link = bpf_program__attach(obj->progs.vmscan_end);
+	if (!ASSERT_OK_PTR(obj, "attach"))
+		return libbpf_get_error(obj);
+
+	*skel = obj;
+	return 0;
+}
+
+void destroy_progs(struct cgroup_vmscan *skel)
+{
+	cgroup_vmscan__destroy(skel);
+}
+
+void test_cgroup_hierarchical_stats(void)
+{
+	struct cgroup_vmscan *skel = NULL;
+
+	if (setup_hierarchy())
+		goto cleanup;
+	if (setup_progs(&skel))
+		goto cleanup;
+	if (induce_vmscan())
+		goto cleanup;
+	check_vmscan_stats();
+cleanup:
+	destroy_progs(skel);
+	destroy_hierarchy();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing/selftests/bpf/progs/bpf_iter.h
index 8cfaeba1ddbf..b10ad01e878a 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
@@ -16,6 +16,7 @@
 #define bpf_iter__bpf_map_elem bpf_iter__bpf_map_elem___not_used
 #define bpf_iter__bpf_sk_storage_map bpf_iter__bpf_sk_storage_map___not_used
 #define bpf_iter__sockmap bpf_iter__sockmap___not_used
+#define bpf_iter__cgroup bpf_iter__cgroup__not_used
 #define btf_ptr btf_ptr___not_used
 #define BTF_F_COMPACT BTF_F_COMPACT___not_used
 #define BTF_F_NONAME BTF_F_NONAME___not_used
@@ -37,6 +38,7 @@
 #undef bpf_iter__bpf_map_elem
 #undef bpf_iter__bpf_sk_storage_map
 #undef bpf_iter__sockmap
+#undef bpf_iter__cgroup
 #undef btf_ptr
 #undef BTF_F_COMPACT
 #undef BTF_F_NONAME
@@ -132,6 +134,11 @@ struct bpf_iter__sockmap {
 	struct sock *sk;
 };
 
+struct bpf_iter__cgroup {
+	struct bpf_iter_meta *meta;
+	struct cgroup *cgroup;
+} __attribute((preserve_access_index));
+
 struct btf_ptr {
 	void *ptr;
 	__u32 type_id;
diff --git a/tools/testing/selftests/bpf/progs/cgroup_vmscan.c b/tools/testing/selftests/bpf/progs/cgroup_vmscan.c
new file mode 100644
index 000000000000..41516f8263b3
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_vmscan.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Functions to manage eBPF programs attached to cgroup subsystems
+ *
+ * Copyright 2022 Google LLC.
+ */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+char _license[] SEC("license") = "GPL";
+
+/*
+ * Start times are stored per-task, not per-cgroup, as multiple tasks in one
+ * cgroup can perform reclain concurrently.
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, __u64);
+} vmscan_start_time SEC(".maps");
+
+struct vmscan_percpu {
+	/* Previous percpu state, to figure out if we have new updates */
+	__u64 prev;
+	/* Current percpu state */
+	__u64 state;
+};
+
+struct vmscan {
+	/* State propagated through children, pending aggregation */
+	__u64 pending;
+	/* Total state, including all cpus and all children */
+	__u64 state;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(max_entries, 10);
+	__type(key, __u64);
+	__type(value, struct vmscan_percpu);
+} pcpu_cgroup_vmscan_elapsed SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 10);
+	__type(key, __u64);
+	__type(value, struct vmscan);
+} cgroup_vmscan_elapsed SEC(".maps");
+
+static inline struct cgroup *task_memcg(struct task_struct *task)
+{
+	return BPF_CORE_READ(task, cgroups, subsys[memory_cgrp_id], cgroup);
+}
+
+static inline uint64_t cgroup_id(struct cgroup *cgrp)
+{
+	return BPF_CORE_READ(cgrp, kn, id);
+}
+
+static inline int create_vmscan_percpu_elem(__u64 cg_id, __u64 state)
+{
+	struct vmscan_percpu pcpu_init = {.state = state, .prev = 0};
+
+	if (bpf_map_update_elem(&pcpu_cgroup_vmscan_elapsed, &cg_id,
+				&pcpu_init, BPF_NOEXIST)) {
+		bpf_printk("failed to create pcpu entry for cgroup %llu\n"
+			   , cg_id);
+		return 1;
+	}
+	return 0;
+}
+
+static inline int create_vmscan_elem(__u64 cg_id, __u64 state, __u64 pending)
+{
+	struct vmscan init = {.state = state, .pending = pending};
+
+	if (bpf_map_update_elem(&cgroup_vmscan_elapsed, &cg_id,
+				&init, BPF_NOEXIST)) {
+		bpf_printk("failed to create entry for cgroup %llu\n"
+			   , cg_id);
+		return 1;
+	}
+	return 0;
+}
+
+SEC("raw_tp/mm_vmscan_memcg_reclaim_begin")
+int vmscan_start(struct lruvec *lruvec, struct scan_control *sc)
+{
+	struct task_struct *task = bpf_get_current_task_btf();
+	__u64 *start_time_ptr;
+
+	start_time_ptr = bpf_task_storage_get(&vmscan_start_time, task, 0,
+					  BPF_LOCAL_STORAGE_GET_F_CREATE);
+	if (!start_time_ptr) {
+		bpf_printk("error retrieving storage\n");
+		return 0;
+	}
+
+	*start_time_ptr = bpf_ktime_get_ns();
+	return 0;
+}
+
+SEC("raw_tp/mm_vmscan_memcg_reclaim_end")
+int vmscan_end(struct lruvec *lruvec, struct scan_control *sc)
+{
+	struct vmscan_percpu *pcpu_stat;
+	struct task_struct *current = bpf_get_current_task_btf();
+	struct cgroup *cgrp = task_memcg(current);
+	__u64 *start_time_ptr;
+	__u64 current_elapsed, cg_id;
+	__u64 end_time = bpf_ktime_get_ns();
+
+	/* cgrp may not have memory controller enabled */
+	if (!cgrp)
+		return 0;
+
+	cg_id = cgroup_id(cgrp);
+	start_time_ptr = bpf_task_storage_get(&vmscan_start_time, current, 0,
+					      BPF_LOCAL_STORAGE_GET_F_CREATE);
+	if (!start_time_ptr) {
+		bpf_printk("error retrieving storage local storage\n");
+		return 0;
+	}
+
+	current_elapsed = end_time - *start_time_ptr;
+	pcpu_stat = bpf_map_lookup_elem(&pcpu_cgroup_vmscan_elapsed,
+					&cg_id);
+	if (pcpu_stat)
+		__sync_fetch_and_add(&pcpu_stat->state, current_elapsed);
+	else
+		create_vmscan_percpu_elem(cg_id, current_elapsed);
+
+	bpf_cgroup_rstat_updated(cgrp);
+	return 0;
+}
+
+SEC("cgroup_subsys/rstat")
+int vmscan_flush(struct bpf_rstat_ctx *ctx)
+{
+	struct vmscan_percpu *pcpu_stat;
+	struct vmscan *total_stat, *parent_stat;
+	__u64 *pcpu_vmscan;
+	__u64 state;
+	__u64 delta = 0;
+	__u64 cg_id = ctx->cgroup_id;
+	__u64 parent_cg_id = ctx->parent_cgroup_id;
+	__s32 cpu = ctx->cpu;
+
+	/* Add CPU changes on this level since the last flush */
+	pcpu_stat = bpf_map_lookup_percpu_elem(&pcpu_cgroup_vmscan_elapsed,
+					       &cg_id, cpu);
+	if (pcpu_stat) {
+		state = pcpu_stat->state;
+		delta += state - pcpu_stat->prev;
+		pcpu_stat->prev = state;
+	}
+
+	total_stat = bpf_map_lookup_elem(&cgroup_vmscan_elapsed, &cg_id);
+	if (!total_stat) {
+		create_vmscan_elem(cg_id, delta, 0);
+		goto update_parent;
+	}
+
+	/* Collect pending stats from subtree */
+	if (total_stat->pending) {
+		delta += total_stat->pending;
+		total_stat->pending = 0;
+	}
+
+	/* Propagate changes to this cgroup's total */
+	total_stat->state += delta;
+
+update_parent:
+	/* Skip if there are no changes to propagate, or no parent */
+	if (!delta || !parent_cg_id)
+		return 0;
+
+	/* Propagate changes to cgroup's parent */
+	parent_stat = bpf_map_lookup_elem(&cgroup_vmscan_elapsed,
+					  &parent_cg_id);
+	if (parent_stat)
+		parent_stat->pending += delta;
+	else
+		create_vmscan_elem(parent_cg_id, 0, delta);
+
+	return 0;
+}
+
+SEC("iter/cgroup")
+int dump_vmscan(struct bpf_iter__cgroup *ctx)
+{
+	struct seq_file *seq = ctx->meta->seq;
+	struct cgroup *cgroup = ctx->cgroup;
+	struct vmscan *total_stat;
+	__u64 cg_id = cgroup_id(cgroup);
+
+	/* Flush the stats to make sure we get the most updated numbers */
+	bpf_cgroup_rstat_flush(cgroup);
+
+	total_stat = bpf_map_lookup_elem(&cgroup_vmscan_elapsed, &cg_id);
+	if (!total_stat) {
+		bpf_printk("error finding stats for cgroup %llu\n", cg_id);
+		return 0;
+	}
+	BPF_SEQ_PRINTF(seq, "cg_id: %llu, total_vmscan_delay: %llu\n",
+		       cg_id, total_stat->state);
+	return 0;
+}
+
-- 
2.36.0.512.ge40c2bad7a-goog

