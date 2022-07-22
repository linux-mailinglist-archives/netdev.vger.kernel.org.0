Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DDD57D866
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 04:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbiGVCOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 22:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiGVCNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 22:13:39 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE88A97A1D
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 19:13:30 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b17-20020a170903229100b0016d3e892112so572774plh.6
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 19:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HOwdfV0kQVcvXzV/MDEJCcsRY757dpSKj3aMvVkstxM=;
        b=NhU1jOOQDIb2jXxidEhbTSKmMEJHvLYYMhgLDXu1dZTDFul0W8KCiALo+x8/1epflb
         IL8yo3pdwlQFCKaXZtTyKVZqkZZawp8rIUbSdkfiB3aWPD07V8UTCdf9s0LlQT0whkVd
         /hdl7GEo9oxlGr3FDx6RncuB1C+LRwH5t74sdtdB2S/gCd1TVNIRaIpSHE59NToXAaZr
         QfDAhNz4A3iXxxPYvo01GxRa5Jo8pQfwqRH/MJAamW2ZjdFxvPsWfxf8El6UYnACEius
         MaGhYmV0EX+uVbYPpqW6rJtRAeUedFIkkwkrFlXElX/fmXiwm429+yp4uR/kCRmP+19k
         cMEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HOwdfV0kQVcvXzV/MDEJCcsRY757dpSKj3aMvVkstxM=;
        b=nK6a1kPT27aYS2j+LlGHHlPDJaI5oNxoUicWUEmT5ErfrRh6M7OgCeHn5RBODNtZck
         SWIOk8i+SOBX9NV6I+dDSGT0LlhoyvGm9Q8EH1rGWUbcOjpqLCAt55JaUeozWKYVp6ev
         Vby4TX9RjW+aXKoV62lC3Tl1A99Vz/SsCuV6CsRdQSHTgnfwVPzHR3tH6SQWpN7T5zhV
         740AuvXn6XiofpcUpytX5GHNCfSbCG8tyDbU3wTtUBFFlzRFWIniCcBhiQcQdMN8enIn
         f/ZgFVmw4f3I6C8rGnO++M2qhplNxbh8s/KX5y6llaf8PtsHxfPwwq1anhBBN6rrBZMA
         HClA==
X-Gm-Message-State: AJIora/JkgxVmi4A4MhFqc/9RMcz46ykQqupybSBixy9F6B3JOYwxva1
        KjtoR23D1BpxwTkkGZunvQaUb/d3G/ZNycxk
X-Google-Smtp-Source: AGRyM1upr5DvJx59FAbjhpLFzAnoCmrPiXCVkc2lY4qjlVCShTLJQfKdz2qMB6D2+XCZMnIdUB4yvsSZ+ZGiSP4a
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:902:bb90:b0:16d:2d15:3a91 with SMTP
 id m16-20020a170902bb9000b0016d2d153a91mr1351226pls.4.1658456009302; Thu, 21
 Jul 2022 19:13:29 -0700 (PDT)
Date:   Fri, 22 Jul 2022 02:13:13 +0000
In-Reply-To: <20220722021313.3150035-1-yosryahmed@google.com>
Message-Id: <20220722021313.3150035-9-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220722021313.3150035-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH bpf-next v4 8/8] bpf: add a selftest for cgroup hierarchical
 stats collection
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a selftest that tests the whole workflow for collecting,
aggregating (flushing), and displaying cgroup hierarchical stats.

TL;DR:
- Userspace program creates a cgroup hierarchy and induces memcg reclaim
  in parts of it.
- Whenever reclaim happens, vmscan_start and vmscan_end update
  per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
  have updates.
- When userspace tries to read the stats, vmscan_dump calls rstat to flush
  the stats, and outputs the stats in text format to userspace (similar
  to cgroupfs stats).
- rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
  updates, vmscan_flush aggregates cpu readings and propagates updates
  to parents.
- Userspace program makes sure the stats are aggregated and read
  correctly.

Detailed explanation:
- The test loads tracing bpf programs, vmscan_start and vmscan_end, to
  measure the latency of cgroup reclaim. Per-cgroup readings are stored in
  percpu maps for efficiency. When a cgroup reading is updated on a cpu,
  cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
  rstat updated tree on that cpu.

- A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
  each cgroup. Reading this file invokes the program, which calls
  cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
  cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
  the stats are exposed to the user. vmscan_dump returns 1 to terminate
  iteration early, so that we only expose stats for one cgroup per read.

- An ftrace program, vmscan_flush, is also loaded and attached to
  bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
  once for each (cgroup, cpu) pair that has updates. cgroups are popped
  from the rstat tree in a bottom-up fashion, so calls will always be
  made for cgroups that have updates before their parents. The program
  aggregates percpu readings to a total per-cgroup reading, and also
  propagates them to the parent cgroup. After rstat flushing is over, all
  cgroups will have correct updated hierarchical readings (including all
  cpus and all their descendants).

- Finally, the test creates a cgroup hierarchy and induces memcg reclaim
  in parts of it, and makes sure that the stats collection, aggregation,
  and reading workflow works as expected.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 .../prog_tests/cgroup_hierarchical_stats.c    | 364 ++++++++++++++++++
 .../bpf/progs/cgroup_hierarchical_stats.c     | 239 ++++++++++++
 2 files changed, 603 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
new file mode 100644
index 000000000000..e01fac401ec5
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
@@ -0,0 +1,364 @@
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
+#include <test_progs.h>
+#include <bpf/libbpf.h>
+#include <bpf/bpf.h>
+
+#include "cgroup_helpers.h"
+#include "cgroup_hierarchical_stats.skel.h"
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
+#define CGROUP_PATH(p, n) {.path = #p"/"#n, .name = #n}
+
+static struct {
+	const char *path, *name;
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
+int root_cgroup_fd;
+bool mounted_bpffs;
+
+static int read_from_file(const char *path, char *buf, size_t size)
+{
+	int fd, len;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		log_err("Open %s", path);
+		return 1;
+	}
+	len = read(fd, buf, size);
+	if (len < 0)
+		log_err("Read %s", path);
+	else
+		buf[len] = 0;
+	close(fd);
+	return len < 0;
+}
+
+static int setup_bpffs(void)
+{
+	int err;
+
+	/* Mount bpffs */
+	err = mount("bpf", BPFFS_ROOT, "bpf", 0, NULL);
+	mounted_bpffs = !err;
+	if (!ASSERT_OK(err && errno != EBUSY, "mount bpffs"))
+		return err;
+
+	/* Create a directory to contain stat files in bpffs */
+	err = mkdir(BPFFS_VMSCAN, 0755);
+	ASSERT_OK(err, "mkdir bpffs");
+	return err;
+}
+
+static void cleanup_bpffs(void)
+{
+	/* Remove created directory in bpffs */
+	ASSERT_OK(rmdir(BPFFS_VMSCAN), "rmdir "BPFFS_VMSCAN);
+
+	/* Unmount bpffs, if it wasn't already mounted when we started */
+	if (mounted_bpffs)
+		return;
+	ASSERT_OK(umount(BPFFS_ROOT), "unmount bpffs");
+}
+
+static int setup_cgroups(void)
+{
+	int i, fd, err;
+
+	err = setup_cgroup_environment();
+	if (!ASSERT_OK(err, "setup_cgroup_environment"))
+		return err;
+
+	root_cgroup_fd = get_root_cgroup();
+	if (!ASSERT_GE(root_cgroup_fd, 0, "get_root_cgroup"))
+		return root_cgroup_fd;
+
+	for (i = 0; i < N_CGROUPS; i++) {
+		fd = create_and_get_cgroup(cgroups[i].path);
+		if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
+			return fd;
+
+		cgroups[i].fd = fd;
+		cgroups[i].id = get_cgroup_id(cgroups[i].path);
+
+		/*
+		 * Enable memcg controller for the entire hierarchy.
+		 * Note that stats are collected for all cgroups in a hierarchy
+		 * with memcg enabled anyway, but are only exposed for cgroups
+		 * that have memcg enabled.
+		 */
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
+	close(root_cgroup_fd);
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
+static void reclaimer(const char *cgroup_path, size_t size)
+{
+	char *buf, *ptr;
+	char size_buf[128];
+	int err;
+
+	/* Join cgroup in the parent process workdir */
+	if (join_parent_cgroup(cgroup_path))
+		exit(EACCES);
+
+	/* Allocate memory */
+	buf = malloc(size);
+	if (!buf)
+		exit(ENOMEM);
+
+	/* Write to memory to make sure it's actually allocated */
+	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+		*ptr = 1;
+
+	/* Try to reclaim memory */
+	snprintf(size_buf, 128, "%lu", size);
+	err = write_cgroup_file_parent(cgroup_path, "memory.reclaim", size_buf);
+
+	free(buf);
+	/* memory.reclaim returns EAGAIN if the amount is not fully reclaimed */
+	exit(err && errno != EAGAIN ? errno : 0);
+}
+
+static int induce_vmscan(void)
+{
+	int i, status;
+
+	/*
+	 * In every leaf cgroup, run a child process that allocates some memory
+	 * and attempts to reclaim some of it.
+	 */
+	for (i = N_NON_LEAF_CGROUPS; i < N_CGROUPS; i++) {
+		pid_t pid;
+
+		/* Create reclaimer child */
+		pid = fork();
+		if (pid == 0)
+			reclaimer(cgroups[i].path, MB(5));
+		if (!ASSERT_GT(pid, 0, "fork reclaimer"))
+			return pid;
+
+		/* Cleanup reclaimer child */
+		waitpid(pid, &status, 0);
+		ASSERT_TRUE(WIFEXITED(status), "reclaimer exited");
+		ASSERT_EQ(WEXITSTATUS(status), 0, "reclaim exit code");
+	}
+	return 0;
+}
+
+static unsigned long long get_cgroup_vmscan_delay(unsigned long long cgroup_id,
+						  const char *file_name)
+{
+	static char buf[128], path[128];
+	unsigned long long vmscan = 0, id = 0;
+	int err;
+
+	/* For every cgroup, read the file generated by cgroup_iter */
+	snprintf(path, 128, "%s%s", BPFFS_VMSCAN, file_name);
+	err = read_from_file(path, buf, 128);
+	if (!ASSERT_OK(err, "read cgroup_iter"))
+		return 0;
+
+	/* Check the output file formatting */
+	ASSERT_EQ(sscanf(buf, "cg_id: %llu, total_vmscan_delay: %llu\n",
+			 &id, &vmscan), 2, "output format");
+
+	/* Check that the cgroup_id is displayed correctly */
+	ASSERT_EQ(id, cgroup_id, "cgroup_id");
+	/* Check that the vmscan reading is non-zero */
+	ASSERT_GT(vmscan, 0, "vmscan_reading");
+	return vmscan;
+}
+
+static void check_vmscan_stats(void)
+{
+	int i;
+	unsigned long long vmscan_readings[N_CGROUPS], vmscan_root;
+
+	for (i = 0; i < N_CGROUPS; i++)
+		vmscan_readings[i] = get_cgroup_vmscan_delay(cgroups[i].id,
+							     cgroups[i].name);
+
+	/* Read stats for root too */
+	vmscan_root = get_cgroup_vmscan_delay(CG_ROOT_ID, CG_ROOT_NAME);
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
+static int setup_cgroup_iter(struct cgroup_hierarchical_stats *obj, int cgroup_fd,
+			     const char *file_name)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo = {};
+	struct bpf_link *link;
+	char path[128];
+	int err;
+
+	/*
+	 * Create an iter link, parameterized by cgroup_fd.
+	 * We only want to traverse one cgroup, so set the traversal order to
+	 * "pre", and return 1 from dump_vmscan to stop iteration after the
+	 * first cgroup.
+	 */
+	linfo.cgroup.cgroup_fd = cgroup_fd;
+	linfo.cgroup.traversal_order = BPF_ITER_CGROUP_PRE;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+	link = bpf_program__attach_iter(obj->progs.dump_vmscan, &opts);
+	if (!ASSERT_OK_PTR(link, "attach iter"))
+		return libbpf_get_error(link);
+
+	/* Pin the link to a bpffs file */
+	snprintf(path, 128, "%s%s", BPFFS_VMSCAN, file_name);
+	err = bpf_link__pin(link, path);
+	if (!ASSERT_OK(err, "pin cgroup_iter"))
+		return err;
+
+	/* Remove the link, leaving only the ref held by the pinned file */
+	err = bpf_link__destroy(link);
+	ASSERT_OK(err, "destroy cgroup_iter link");
+	return err;
+}
+
+static int setup_progs(struct cgroup_hierarchical_stats **skel)
+{
+	int i, err;
+	struct bpf_link *link;
+	struct cgroup_hierarchical_stats *obj;
+
+	obj = cgroup_hierarchical_stats__open_and_load();
+	if (!ASSERT_OK_PTR(obj, "open_and_load"))
+		return libbpf_get_error(obj);
+
+	/* Attach cgroup_iter program that will dump the stats to cgroups */
+	for (i = 0; i < N_CGROUPS; i++) {
+		err = setup_cgroup_iter(obj, cgroups[i].fd, cgroups[i].name);
+		if (!ASSERT_OK(err, "setup_cgroup_iter"))
+			return err;
+	}
+	/* Also dump stats for root */
+	err = setup_cgroup_iter(obj, root_cgroup_fd, CG_ROOT_NAME);
+	if (!ASSERT_OK(err, "setup_cgroup_iter"))
+		return err;
+
+	/* Attach rstat flusher */
+	link = bpf_program__attach(obj->progs.vmscan_flush);
+	if (!ASSERT_OK_PTR(link, "attach rstat"))
+		return libbpf_get_error(link);
+	obj->links.vmscan_flush = link;
+
+	/* Attach tracing programs that will calculate vmscan delays */
+	link = bpf_program__attach(obj->progs.vmscan_start);
+	if (!ASSERT_OK_PTR(obj, "attach raw_tracepoint"))
+		return libbpf_get_error(link);
+	obj->links.vmscan_start = link;
+
+	link = bpf_program__attach(obj->progs.vmscan_end);
+	if (!ASSERT_OK_PTR(obj, "attach raw_tracepoint"))
+		return libbpf_get_error(link);
+	obj->links.vmscan_end = link;
+
+	*skel = obj;
+	return 0;
+}
+
+void destroy_progs(struct cgroup_hierarchical_stats *skel)
+{
+	char path[128];
+	int i;
+
+	for (i = 0; i < N_CGROUPS; i++) {
+		/* Delete files in bpffs that cgroup_iters are pinned in */
+		snprintf(path, 128, "%s%s", BPFFS_VMSCAN,
+			 cgroups[i].name);
+		ASSERT_OK(remove(path), "remove cgroup_iter pin");
+	}
+
+	/* Delete root file in bpffs */
+	snprintf(path, 128, "%s%s", BPFFS_VMSCAN, CG_ROOT_NAME);
+	ASSERT_OK(remove(path), "remove cgroup_iter root pin");
+	cgroup_hierarchical_stats__destroy(skel);
+}
+
+void test_cgroup_hierarchical_stats(void)
+{
+	struct cgroup_hierarchical_stats *skel = NULL;
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
diff --git a/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
new file mode 100644
index 000000000000..85a65a72482e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Functions to manage eBPF programs attached to cgroup subsystems
+ *
+ * Copyright 2022 Google LLC.
+ */
+#include "vmlinux.h"
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
+	__uint(max_entries, 100);
+	__type(key, __u64);
+	__type(value, struct vmscan_percpu);
+} pcpu_cgroup_vmscan_elapsed SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 100);
+	__type(key, __u64);
+	__type(value, struct vmscan);
+} cgroup_vmscan_elapsed SEC(".maps");
+
+extern void cgroup_rstat_updated(struct cgroup *cgrp, int cpu) __ksym;
+extern void cgroup_rstat_flush(struct cgroup *cgrp) __ksym;
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
+	int err;
+
+	err = bpf_map_update_elem(&pcpu_cgroup_vmscan_elapsed, &cg_id,
+				  &pcpu_init, BPF_NOEXIST);
+	if (err) {
+		bpf_printk("failed to create pcpu entry for cgroup %llu: %d\n"
+			   , cg_id, err);
+		return 1;
+	}
+	return 0;
+}
+
+static inline int create_vmscan_elem(__u64 cg_id, __u64 state, __u64 pending)
+{
+	struct vmscan init = {.state = state, .pending = pending};
+	int err;
+
+	err = bpf_map_update_elem(&cgroup_vmscan_elapsed, &cg_id,
+				  &init, BPF_NOEXIST);
+	if (err) {
+		bpf_printk("failed to create entry for cgroup %llu: %d\n"
+			   , cg_id, err);
+		return 1;
+	}
+	return 0;
+}
+
+SEC("tp_btf/mm_vmscan_memcg_reclaim_begin")
+int BPF_PROG(vmscan_start, int order, gfp_t gfp_flags)
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
+int BPF_PROG(vmscan_end, unsigned long nr_reclaimed)
+{
+	struct vmscan_percpu *pcpu_stat;
+	struct task_struct *current = bpf_get_current_task_btf();
+	struct cgroup *cgrp;
+	__u64 *start_time_ptr;
+	__u64 current_elapsed, cg_id;
+	__u64 end_time = bpf_ktime_get_ns();
+
+	/*
+	 * cgrp is the first parent cgroup of current that has memcg enabled in
+	 * its subtree_control, or NULL if memcg is disabled in the entire tree.
+	 * In a cgroup hierarchy like this:
+	 *                               a
+	 *                              / \
+	 *                             b   c
+	 *  If "a" has memcg enabled, while "b" doesn't, then processes in "b"
+	 *  will accumulate their stats directly to "a". This makes sure that no
+	 *  stats are lost from processes in leaf cgroups that don't have memcg
+	 *  enabled, but only exposes stats for cgroups that have memcg enabled.
+	 */
+	cgrp = task_memcg(current);
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
+		pcpu_stat->state += current_elapsed;
+	else if (create_vmscan_percpu_elem(cg_id, current_elapsed))
+		return 0;
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
+		if (create_vmscan_elem(cg_id, delta, 0))
+			return 0;
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
+	__u64 cg_id = cgrp ? cgroup_id(cgrp) : 0;
+
+	/* Do nothing for the terminal call */
+	if (!cg_id)
+		return 1;
+
+	/* Flush the stats to make sure we get the most updated numbers */
+	cgroup_rstat_flush(cgrp);
+
+	total_stat = bpf_map_lookup_elem(&cgroup_vmscan_elapsed, &cg_id);
+	if (!total_stat) {
+		bpf_printk("error finding stats for cgroup %llu\n", cg_id);
+		BPF_SEQ_PRINTF(seq, "cg_id: %llu, total_vmscan_delay: 0\n",
+			       cg_id);
+		return 1;
+	}
+	BPF_SEQ_PRINTF(seq, "cg_id: %llu, total_vmscan_delay: %llu\n",
+		       cg_id, total_stat->state);
+
+	/*
+	 * We only dump stats for one cgroup here, so return 1 to stop
+	 * iteration after the first cgroup.
+	 */
+	return 1;
+}
-- 
2.37.1.359.gd136c6c3e2-goog

