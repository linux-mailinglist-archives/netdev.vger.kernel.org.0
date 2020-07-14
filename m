Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF8D21FE44
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgGNUNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729092AbgGNUNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 16:13:02 -0400
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F049CC061794;
        Tue, 14 Jul 2020 13:13:01 -0700 (PDT)
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 886292E11DD;
        Tue, 14 Jul 2020 23:13:00 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id cFKYEUW4na-Cxs0Uej8;
        Tue, 14 Jul 2020 23:13:00 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1594757580; bh=ued7izyOQoiHrOno/il6Km3f4v4Tapg481qGbU9U7Dk=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=WGZI39P9V2o2Sj58mPdETV2EKfJ2tfo6jsjkwaWAuMYOqnrMg/lIfke3YLYG3W9oR
         QWRyOUwi6fmePr9YV/UPjd/ebb3VvNfnPz6gJYfXhTJJ83Yo0zgsqglzNTnGvSlfuB
         kJnc7LMPJG3G51PKmcOUoxuZ0GxNCfjqpbTO/0lM=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 37.9.72.161-iva.dhcp.yndx.net (37.9.72.161-iva.dhcp.yndx.net [37.9.72.161])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id PwhVeBFRq1-CxjCQftL;
        Tue, 14 Jul 2020 23:12:59 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
Subject: [PATCH bpf-next v2 4/4] bpf: try to use existing cgroup storage in bpf_prog_test_run_skb
Date:   Tue, 14 Jul 2020 23:12:45 +0300
Message-Id: <20200714201245.99528-5-zeil@yandex-team.ru>
In-Reply-To: <20200714201245.99528-1-zeil@yandex-team.ru>
References: <20200714201245.99528-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now we cannot check results in cgroup storage after running
BPF_PROG_TEST_RUN command because it allocates dummy cgroup storage
during test. This patch implements simple logic for searching already
allocated cgroup storage through iterating effective programs of current
cgroup and finding the first match. If match is not found fallback to
temporary storage is happened.

v2:
  - fix build without CONFIG_CGROUP_BPF (kernel test robot <lkp@intel.com>)

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 net/bpf/test_run.c                                 | 64 +++++++++++++++++-
 .../selftests/bpf/prog_tests/cgroup_skb_prog_run.c | 78 ++++++++++++++++++++++
 2 files changed, 139 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_skb_prog_run.c

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 5c4835c..737b8c4 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -15,15 +15,67 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/bpf_test_run.h>
 
+#ifdef CONFIG_CGROUP_BPF
+
+static struct bpf_prog_array_item *bpf_prog_find_active(struct bpf_prog *prog,
+							struct bpf_prog_array *effective)
+{
+	struct bpf_prog_array_item *item;
+	struct bpf_prog_array *array;
+	struct bpf_prog *p;
+
+	array = rcu_dereference(effective);
+	if (!array)
+		return NULL;
+
+	item = &array->items[0];
+	while ((p = READ_ONCE(item->prog))) {
+		if (p == prog)
+			return item;
+		item++;
+	}
+
+	return NULL;
+}
+
+static struct bpf_cgroup_storage **bpf_prog_find_active_storage(struct bpf_prog *prog)
+{
+	struct bpf_prog_array_item *item;
+	struct cgroup *cgrp;
+
+	if (prog->type != BPF_PROG_TYPE_CGROUP_SKB)
+		return NULL;
+
+	cgrp = task_dfl_cgroup(current);
+
+	item = bpf_prog_find_active(prog,
+				    cgrp->bpf.effective[BPF_CGROUP_INET_INGRESS]);
+	if (!item)
+		item = bpf_prog_find_active(prog,
+					    cgrp->bpf.effective[BPF_CGROUP_INET_EGRESS]);
+
+	return item ? item->cgroup_storage : NULL;
+}
+
+#else
+
+static struct bpf_cgroup_storage **bpf_prog_find_active_storage(struct bpf_prog *prog)
+{
+	return NULL;
+}
+
+#endif
+
 static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 			u32 *retval, u32 *time, bool xdp)
 {
-	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = { NULL };
+	struct bpf_cgroup_storage *dummy_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = { NULL };
+	struct bpf_cgroup_storage **storage = dummy_storage;
 	u64 time_start, time_spent = 0;
 	int ret = 0;
 	u32 i;
 
-	ret = bpf_cgroup_storages_alloc(storage, prog);
+	ret = bpf_cgroup_storages_alloc(dummy_storage, prog);
 	if (ret)
 		return ret;
 
@@ -31,6 +83,9 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 		repeat = 1;
 
 	rcu_read_lock();
+	storage = bpf_prog_find_active_storage(prog);
+	if (!storage)
+		storage = dummy_storage;
 	migrate_disable();
 	time_start = ktime_get_ns();
 	for (i = 0; i < repeat; i++) {
@@ -54,6 +109,9 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 			cond_resched();
 
 			rcu_read_lock();
+			storage = bpf_prog_find_active_storage(prog);
+			if (!storage)
+				storage = dummy_storage;
 			migrate_disable();
 			time_start = ktime_get_ns();
 		}
@@ -65,7 +123,7 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 	do_div(time_spent, repeat);
 	*time = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
 
-	bpf_cgroup_storages_free(storage);
+	bpf_cgroup_storages_free(dummy_storage);
 
 	return ret;
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_skb_prog_run.c b/tools/testing/selftests/bpf/prog_tests/cgroup_skb_prog_run.c
new file mode 100644
index 0000000..12ca881
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_skb_prog_run.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+
+#include "cgroup_helpers.h"
+#include "network_helpers.h"
+
+static char bpf_log_buf[BPF_LOG_BUF_SIZE];
+
+void test_cgroup_skb_prog_run(void)
+{
+	struct bpf_insn prog[] = {
+		BPF_LD_MAP_FD(BPF_REG_1, 0), /* map fd */
+		BPF_MOV64_IMM(BPF_REG_2, 0), /* flags, not used */
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_local_storage),
+		BPF_MOV64_IMM(BPF_REG_1, 1),
+		BPF_RAW_INSN(BPF_STX | BPF_XADD | BPF_W, BPF_REG_0, BPF_REG_1, 0, 0),
+
+		BPF_MOV64_IMM(BPF_REG_0, 1), /* r0 = 1 */
+		BPF_EXIT_INSN(),
+	};
+	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
+	int storage_fd = -1, prog_fd = -1, cg_fd = -1;
+	struct bpf_cgroup_storage_key key;
+	__u32 duration, retval, size;
+	char buf[128];
+	__u64 value;
+	int err;
+
+	storage_fd = bpf_create_map(BPF_MAP_TYPE_CGROUP_STORAGE,
+				    sizeof(struct bpf_cgroup_storage_key),
+				    8, 0, 0);
+	if (CHECK(storage_fd < 0, "create_map", "%s\n", strerror(errno)))
+		goto out;
+
+	prog[0].imm = storage_fd;
+
+	prog_fd = bpf_load_program(BPF_PROG_TYPE_CGROUP_SKB,
+				   prog, insns_cnt, "GPL", 0,
+				   bpf_log_buf, BPF_LOG_BUF_SIZE);
+	if (CHECK(prog_fd < 0, "prog_load",
+		  "verifier output:\n%s\n-------\n", bpf_log_buf))
+		goto out;
+
+	if (CHECK_FAIL(setup_cgroup_environment()))
+		goto out;
+
+	cg_fd = create_and_get_cgroup("/cg");
+	if (CHECK_FAIL(cg_fd < 0))
+		goto out;
+
+	if (CHECK_FAIL(join_cgroup("/cg")))
+		goto out;
+
+	if (CHECK(bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_INET_EGRESS, 0),
+		  "prog_attach", "%s\n", strerror(errno)))
+		goto out;
+
+	err = bpf_prog_test_run(prog_fd, NUM_ITER, &pkt_v4, sizeof(pkt_v4),
+				buf, &size, &retval, &duration);
+	CHECK(err || retval != 1, "prog_test_run",
+	      "err %d errno %d retval %d\n", err, errno, retval);
+
+	/* check that cgroup storage results are available after test run */
+
+	err = bpf_map_get_next_key(storage_fd, NULL, &key);
+	CHECK(err, "map_get_next_key", "%s\n", strerror(errno));
+
+	err = bpf_map_lookup_elem(storage_fd, &key, &value);
+	CHECK(err || value != NUM_ITER,
+	      "map_lookup_elem",
+	      "err %d errno %d cnt %lld(%d)\n", err, errno, value, NUM_ITER);
+out:
+	close(storage_fd);
+	close(prog_fd);
+	close(cg_fd);
+	cleanup_cgroup_environment();
+}
-- 
2.7.4

