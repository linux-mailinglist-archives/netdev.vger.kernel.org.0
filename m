Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3507052E1DB
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344506AbiETBV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344449AbiETBVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:21:55 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2315227CD5
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:21:47 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id rj11-20020a17090b3e8b00b001df51eb1831so5985972pjb.3
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sKIQnfquWdecZ9McyX/vUzv09szePilO1xsOhvXjmng=;
        b=isgv2TCt315YbAOh0HfR4pphfXmJ/2o+6Wca+8ICKvBOFXfyPEGcJt1prDu0BVd2k5
         7P8U54t3vvjAb1hdXqaAEdSMXX4wkCdUx2AkSM65AEVy8s9WZAw3rC+dhJKTv1MVMIxy
         iXtpitmzLriGkuSOpDbePkAA7MHsIljJs/ZFel35PXAsOc7V6S7Y/thwtlYoScHXTyjN
         ExWHPuj2Zuy9Fawx347aqcUkiNQuLyRkuxW/Dw6YMq8m1F92TPUfW998qS60AtVw//8X
         N1nqenn4AKF07BlLCAIlDRSXPvSVjeQKVEUHuvdiVBSOHAPawwYV+fA3jAvDEL7L5imO
         ctBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sKIQnfquWdecZ9McyX/vUzv09szePilO1xsOhvXjmng=;
        b=2B+zjfI5N4RF6mAMvevX1YCXgaJCWsVwBCD5U3w9ayda2zsiA7DrhEqppngyObs9ls
         GA8G/bY5yoEgkIC71gFqqyw1r9fULv5NfRAhPm+aeHqFZTxammWSshLMjAK1p/LbxBmF
         bq11BhQ0Os9KrimtxzlsO6wKO2lLwQfy2Rgi+W3scgkgVogc2SqMqw3TiB9oAMl8GmfS
         FpeF+eXJVE1CLVETp7j1xD5SvacGPPBlHyISBijb7LZfmE6Pqi3vW3EsJYmkL+9zykPy
         X4oWFMjqSnc7MKOvdLqLvYvPtjaEFqLGQsu0UqZGPnVEwO1fZ/L8j7z+WoF+wn8/fVKa
         AevQ==
X-Gm-Message-State: AOAM530STOpUlDjL7CFwElIcoJiClSahkFOvKZmOtcLFae7+QcreouEM
        nq1uEv/PLyTWNSCjTVk7Evw/ptkzUD5rWHOa
X-Google-Smtp-Source: ABdhPJxvj+oMT/Y1pEfemNuKHmAw+Kf5AHjgGvizfR6T4uMhOa4z8z3lx+IYbfPMX0AKaZgdtChZ9Xcla2S3YZb1
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a65:554d:0:b0:3c6:3f22:72cd with SMTP
 id t13-20020a65554d000000b003c63f2272cdmr6274189pgr.283.1653009706668; Thu,
 19 May 2022 18:21:46 -0700 (PDT)
Date:   Fri, 20 May 2022 01:21:33 +0000
In-Reply-To: <20220520012133.1217211-1-yosryahmed@google.com>
Message-Id: <20220520012133.1217211-6-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup hierarchical
 stats collection
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a selftest that tests the whole workflow for collecting,
aggregating, and display cgroup hierarchical stats.

TL;DR:
- Whenever reclaim happens, vmscan_start and vmscan_end update
  per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
  have updates.
- When userspace tries to read the stats, vmscan_dump calls rstat to flush
  the stats.
- rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
  updates, vmscan_flush aggregates cpu readings and propagates updates
  to parents.

Detailed explanation:
- The test loads tracing bpf programs, vmscan_start and vmscan_end, to
  measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
  percpu maps for efficiency. When a cgroup reading is updated on a cpu,
  cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
  rstat updated tree on that cpu.

- A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
  each cgroup. Reading this file invokes the program, which calls
  cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
  cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
  the stats are exposed to the user.

- An ftrace program, vmscan_flush, is also loaded and attached to
  bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
  once for each (cgroup, cpu) pair that has updates. cgroups are popped
  from the rstat tree in a bottom-up fashion, so calls will always be
  made for cgroups that have updates before their parents. The program
  aggregates percpu readings to a total per-cgroup reading, and also
  propagates them to the parent cgroup. After rstat flushing is over, all
  cgroups will have correct updated hierarchical readings (including all
  cpus and all their descendants).

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 .../test_cgroup_hierarchical_stats.c          | 339 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
 .../selftests/bpf/progs/cgroup_vmscan.c       | 221 ++++++++++++
 3 files changed, 567 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_vmscan.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
new file mode 100644
index 000000000000..e560c1f6291f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
@@ -0,0 +1,339 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Functions to manage eBPF programs attached to cgroup subsystems
+ *
+ * Copyright 2022 Google LLC.
+ */
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include <bpf/libbpf.h>
+#include <bpf/bpf.h>
+#include <test_progs.h>
+
+#include "cgroup_helpers.h"
+#include "cgroup_vmscan.skel.h"
+
+#define PAGE_SIZE 4096
+#define MB(x) (x << 20)
+
+#define BPFFS_ROOT "/sys/fs/bpf/"
+#define BPFFS_VMSCAN BPFFS_ROOT"vmscan/"
+
+#define CG_ROOT_NAME "root"
+#define CG_ROOT_ID 1
+
+#define CGROUP_PATH(p, n) {.name = #n, .path = #p"/"#n}
+
+static struct {
+	const char *name, *path;
+	unsigned long long id;
+	int fd;
+} cgroups[] = {
+	CGROUP_PATH(/, test),
+	CGROUP_PATH(/test, child1),
+	CGROUP_PATH(/test, child2),
+	CGROUP_PATH(/test/child1, child1_1),
+	CGROUP_PATH(/test/child1, child1_2),
+	CGROUP_PATH(/test/child2, child2_1),
+	CGROUP_PATH(/test/child2, child2_2),
+};
+
+#define N_CGROUPS ARRAY_SIZE(cgroups)
+#define N_NON_LEAF_CGROUPS 3
+
+bool mounted_bpffs;
+static int duration;
+
+static int read_from_file(const char *path, char *buf, size_t size)
+{
+	int fd, len;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		log_err("Open %s", path);
+		return -errno;
+	}
+	len = read(fd, buf, size);
+	if (len < 0)
+		log_err("Read %s", path);
+	else
+		buf[len] = 0;
+	close(fd);
+	return len < 0 ? -errno : 0;
+}
+
+static int setup_bpffs(void)
+{
+	int err;
+
+	/* Mount bpffs */
+	err = mount("bpf", BPFFS_ROOT, "bpf", 0, NULL);
+	mounted_bpffs = !err;
+	if (CHECK(err && errno != EBUSY, "mount bpffs",
+	      "failed to mount bpffs at %s (%s)\n", BPFFS_ROOT,
+	      strerror(errno)))
+		return err;
+
+	/* Create a directory to contain stat files in bpffs */
+	err = mkdir(BPFFS_VMSCAN, 0755);
+	CHECK(err, "mkdir bpffs", "failed to mkdir %s (%s)\n",
+	      BPFFS_VMSCAN, strerror(errno));
+	return err;
+}
+
+static void cleanup_bpffs(void)
+{
+	/* Remove created directory in bpffs */
+	CHECK(rmdir(BPFFS_VMSCAN), "rmdir", "failed to rmdir %s (%s)\n",
+	      BPFFS_VMSCAN, strerror(errno));
+
+	/* Unmount bpffs, if it wasn't already mounted when we started */
+	if (mounted_bpffs)
+		return;
+	CHECK(umount(BPFFS_ROOT), "umount", "failed to unmount bpffs (%s)\n",
+	      strerror(errno));
+}
+
+static int setup_cgroups(void)
+{
+	int i, err;
+
+	err = setup_cgroup_environment();
+	if (CHECK(err, "setup_cgroup_environment", "failed: %d\n", err))
+		return err;
+
+	for (i = 0; i < N_CGROUPS; i++) {
+		int fd;
+
+		fd = create_and_get_cgroup(cgroups[i].path);
+		if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
+			return fd;
+
+		cgroups[i].fd = fd;
+		cgroups[i].id = get_cgroup_id(cgroups[i].path);
+		if (i < N_NON_LEAF_CGROUPS) {
+			err = enable_controllers(cgroups[i].path, "memory");
+			if (!ASSERT_OK(err, "enable_controllers"))
+				return err;
+		}
+	}
+	return 0;
+}
+
+static void cleanup_cgroups(void)
+{
+	for (int i = 0; i < N_CGROUPS; i++)
+		close(cgroups[i].fd);
+	cleanup_cgroup_environment();
+}
+
+
+static int setup_hierarchy(void)
+{
+	return setup_bpffs() || setup_cgroups();
+}
+
+static void destroy_hierarchy(void)
+{
+	cleanup_cgroups();
+	cleanup_bpffs();
+}
+
+static void alloc_anon(size_t size)
+{
+	char *buf, *ptr;
+
+	buf = malloc(size);
+	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+		*ptr = 0;
+	free(buf);
+}
+
+static int induce_vmscan(void)
+{
+	char size[128];
+	int i, err;
+
+	/*
+	 * Set memory.high for test parent cgroup to 1 MB to throttle
+	 * allocations and invoke reclaim in children.
+	 */
+	snprintf(size, 128, "%d", MB(1));
+	err = write_cgroup_file(cgroups[0].path, "memory.high",	size);
+	if (!ASSERT_OK(err, "write memory.high"))
+		return err;
+	/*
+	 * In every leaf cgroup, run a memory hog for a few seconds to induce
+	 * reclaim then kill it.
+	 */
+	for (i = N_NON_LEAF_CGROUPS; i < N_CGROUPS; i++) {
+		pid_t pid = fork();
+
+		if (pid == 0) {
+			/* Join cgroup in the parent process workdir */
+			join_parent_cgroup(cgroups[i].path);
+
+			/* Allocate more memory than memory.high */
+			alloc_anon(MB(2));
+			exit(0);
+		} else {
+			/* Wait for child to cause reclaim then kill it */
+			if (!ASSERT_GT(pid, 0, "fork"))
+				return pid;
+			sleep(2);
+			kill(pid, SIGKILL);
+			waitpid(pid, NULL, 0);
+		}
+	}
+	return 0;
+}
+
+static unsigned long long get_cgroup_vmscan(unsigned long long cgroup_id,
+					    const char *file_name)
+{
+	char buf[128], path[128];
+	unsigned long long vmscan = 0, id = 0;
+	int err;
+
+	/* For every cgroup, read the file generated by cgroup_iter */
+	snprintf(path, 128, "%s%s", BPFFS_VMSCAN, file_name);
+	err = read_from_file(path, buf, 128);
+	if (CHECK(err, "read", "failed to read from %s (%s)\n",
+		   path, strerror(errno)))
+		return 0;
+
+	/* Check the output file formatting */
+	ASSERT_EQ(sscanf(buf, "cg_id: %llu, total_vmscan_delay: %llu\n",
+			 &id, &vmscan), 2, "output format");
+
+	/* Check that the cgroup_id is displayed correctly */
+	ASSERT_EQ(cgroup_id, id, "cgroup_id");
+	/* Check that the vmscan reading is non-zero */
+	ASSERT_NEQ(vmscan, 0, "vmscan_reading");
+	return vmscan;
+}
+
+static void check_vmscan_stats(void)
+{
+	int i;
+	unsigned long long vmscan_readings[N_CGROUPS], vmscan_root;
+
+	for (i = 0; i < N_CGROUPS; i++)
+		vmscan_readings[i] = get_cgroup_vmscan(cgroups[i].id,
+						       cgroups[i].name);
+
+	/* Read stats for root too */
+	vmscan_root = get_cgroup_vmscan(CG_ROOT_ID, CG_ROOT_NAME);
+
+	/* Check that child1 == child1_1 + child1_2 */
+	ASSERT_EQ(vmscan_readings[1], vmscan_readings[3] + vmscan_readings[4],
+		  "child1_vmscan");
+	/* Check that child2 == child2_1 + child2_2 */
+	ASSERT_EQ(vmscan_readings[2], vmscan_readings[5] + vmscan_readings[6],
+		  "child2_vmscan");
+	/* Check that test == child1 + child2 */
+	ASSERT_EQ(vmscan_readings[0], vmscan_readings[1] + vmscan_readings[2],
+		  "test_vmscan");
+	/* Check that root >= test */
+	ASSERT_GE(vmscan_root, vmscan_readings[1], "root_vmscan");
+}
+
+static int setup_cgroup_iter(struct cgroup_vmscan *obj,
+			     unsigned long long cgroup_id,
+			     const char *file_name)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo = {};
+	struct bpf_link *link;
+	char path[128];
+	int err;
+
+	/* Create an iter link, parameterized by cgroup id */
+	linfo.cgroup.cgroup_id = cgroup_id;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+	link = bpf_program__attach_iter(obj->progs.dump_vmscan, &opts);
+	if (!ASSERT_OK_PTR(link, "attach iter"))
+		return libbpf_get_error(link);
+
+	/* Pin the link to a bpffs file */
+	snprintf(path, 128, "%s%s", BPFFS_VMSCAN, file_name);
+	err = bpf_link__pin(link, path);
+	CHECK(err, "pin iter", "failed to pin iter at %s", path);
+	return err;
+}
+
+static int setup_progs(struct cgroup_vmscan **skel)
+{
+	int i;
+	struct bpf_link *link;
+	struct cgroup_vmscan *obj;
+
+	obj = cgroup_vmscan__open_and_load();
+	if (!ASSERT_OK_PTR(obj, "open_and_load"))
+		return libbpf_get_error(obj);
+
+	/* Attach cgroup_iter program that will dump the stats to cgroups */
+	for (i = 0; i < N_CGROUPS; i++)
+		setup_cgroup_iter(obj, cgroups[i].id, cgroups[i].name);
+	/* Also dump stats for root */
+	setup_cgroup_iter(obj, CG_ROOT_ID, CG_ROOT_NAME);
+
+	/* Attach rstat flusher */
+	link = bpf_program__attach(obj->progs.vmscan_flush);
+	if (!ASSERT_OK_PTR(link, "attach rstat"))
+		return libbpf_get_error(link);
+
+	/* Attach tracing programs that will calculate vmscan delays */
+	link = bpf_program__attach(obj->progs.vmscan_start);
+	if (!ASSERT_OK_PTR(obj, "attach raw_tracepoint"))
+		return libbpf_get_error(obj);
+
+	link = bpf_program__attach(obj->progs.vmscan_end);
+	if (!ASSERT_OK_PTR(obj, "attach raw_tracepoint"))
+		return libbpf_get_error(obj);
+
+	*skel = obj;
+	return 0;
+}
+
+void destroy_progs(struct cgroup_vmscan *skel)
+{
+	char path[128];
+	int i;
+
+	for (i = 0; i < N_CGROUPS; i++) {
+		/* Delete files in bpffs that cgroup_iters are pinned in */
+		snprintf(path, 128, "%s%s", BPFFS_VMSCAN,
+			 cgroups[i].name);
+		CHECK(remove(path), "remove", "failed to remove %s (%s)\n",
+		      path, strerror(errno));
+	}
+
+	/* Delete root file in bpffs */
+	snprintf(path, 128, "%s%s", BPFFS_VMSCAN, CG_ROOT_NAME);
+	CHECK(remove(path), "remove", "failed to remove %s (%s)\n", path,
+	      strerror(errno));
+	cgroup_vmscan__destroy(skel);
+}
+
+void test_cgroup_hierarchical_stats(void)
+{
+	struct cgroup_vmscan *skel = NULL;
+
+	if (setup_hierarchy())
+		goto hierarchy_cleanup;
+	if (setup_progs(&skel))
+		goto cleanup;
+	if (induce_vmscan())
+		goto cleanup;
+	check_vmscan_stats();
+cleanup:
+	destroy_progs(skel);
+hierarchy_cleanup:
+	destroy_hierarchy();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing/selftests/bpf/progs/bpf_iter.h
index 97ec8bc76ae6..df91f1daf74d 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
@@ -17,6 +17,7 @@
 #define bpf_iter__bpf_sk_storage_map bpf_iter__bpf_sk_storage_map___not_used
 #define bpf_iter__sockmap bpf_iter__sockmap___not_used
 #define bpf_iter__bpf_link bpf_iter__bpf_link___not_used
+#define bpf_iter__cgroup bpf_iter__cgroup__not_used
 #define btf_ptr btf_ptr___not_used
 #define BTF_F_COMPACT BTF_F_COMPACT___not_used
 #define BTF_F_NONAME BTF_F_NONAME___not_used
@@ -39,6 +40,7 @@
 #undef bpf_iter__bpf_sk_storage_map
 #undef bpf_iter__sockmap
 #undef bpf_iter__bpf_link
+#undef bpf_iter__cgroup
 #undef btf_ptr
 #undef BTF_F_COMPACT
 #undef BTF_F_NONAME
@@ -139,6 +141,11 @@ struct bpf_iter__bpf_link {
 	struct bpf_link *link;
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
index 000000000000..9d7c72c213ad
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_vmscan.c
@@ -0,0 +1,221 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Functions to manage eBPF programs attached to cgroup subsystems
+ *
+ * Copyright 2022 Google LLC.
+ */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
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
+extern void cgroup_rstat_updated(struct cgroup *cgrp, int cpu) __ksym;
+extern void cgroup_rstat_flush(struct cgroup *cgrp) __ksym;
+
+static inline bool memory_subsys_enabled(struct cgroup *cgrp)
+{
+	return cgrp->subsys[memory_cgrp_id] != NULL;
+}
+
+static inline struct cgroup *task_memcg(struct task_struct *task)
+{
+	return task->cgroups->subsys[memory_cgrp_id]->cgroup;
+}
+
+static inline uint64_t cgroup_id(struct cgroup *cgrp)
+{
+	return cgrp->kn->id;
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
+SEC("tp_btf/mm_vmscan_memcg_reclaim_begin")
+int BPF_PROG(vmscan_start, struct lruvec *lruvec, struct scan_control *sc)
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
+SEC("tp_btf/mm_vmscan_memcg_reclaim_end")
+int BPF_PROG(vmscan_end, struct lruvec *lruvec, struct scan_control *sc)
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
+	cgroup_rstat_updated(cgrp, bpf_get_smp_processor_id());
+	return 0;
+}
+
+SEC("fentry/bpf_rstat_flush")
+int BPF_PROG(vmscan_flush, struct cgroup *cgrp, struct cgroup *parent, int cpu)
+{
+	struct vmscan_percpu *pcpu_stat;
+	struct vmscan *total_stat, *parent_stat;
+	__u64 cg_id = cgroup_id(cgrp);
+	__u64 parent_cg_id = parent ? cgroup_id(parent) : 0;
+	__u64 *pcpu_vmscan;
+	__u64 state;
+	__u64 delta = 0;
+
+	if (!memory_subsys_enabled(cgrp))
+		return 0;
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
+SEC("iter.s/cgroup")
+int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup *cgrp)
+{
+	struct seq_file *seq = meta->seq;
+	struct vmscan *total_stat;
+	__u64 cg_id = cgroup_id(cgrp);
+
+	/* Flush the stats to make sure we get the most updated numbers */
+	cgroup_rstat_flush(cgrp);
+
+	total_stat = bpf_map_lookup_elem(&cgroup_vmscan_elapsed, &cg_id);
+	if (!total_stat) {
+		bpf_printk("error finding stats for cgroup %llu\n", cg_id);
+		BPF_SEQ_PRINTF(seq, "cg_id: -1, total_vmscan_delay: -1\n");
+		return 0;
+	}
+	BPF_SEQ_PRINTF(seq, "cg_id: %llu, total_vmscan_delay: %llu\n",
+		       cg_id, total_stat->state);
+	return 0;
+}
+
-- 
2.36.1.124.g0e6072fb45-goog

