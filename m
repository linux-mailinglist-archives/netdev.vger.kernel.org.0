Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F2B525BBD
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 08:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377416AbiEMGk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 02:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377427AbiEMGk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 02:40:28 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9585B2A28D0
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 23:40:23 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id a19so6458378pgw.6
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 23:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gEB3NbHEFaXkY+7O5LinimDmPz0C+lpCHDDyO2s1SG0=;
        b=j9XBSBxJAHXR/iQiKohExEY1bxn8g015nWIKUkNnn+CWX0u7t/ULIFexyBCN0iYoiV
         1wcBiIUMECDQSY1AzqnU4H5qRenJI8E5o4F845ZL2WkkOXzUXnF2eBMMZlFq86dp6a8G
         hlFexIB7iFK4UTWYLukjtZt2s65cU+W3n968vljMcj6XzO5dUOopEZeoBEoZKqwZ+tYB
         f04kE2YYKNrXZeApMNRSnyEeNXeM0NWvJp4POhoG2O+FN2dFRwI4NffXdpoUA9afxWIO
         AhbOR2HMFdhkvcBPDgVGmeW6FJIwQG35fl4lWZRUwUtkis3EGSofHKJLnvW/BMdE+9B4
         GlIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gEB3NbHEFaXkY+7O5LinimDmPz0C+lpCHDDyO2s1SG0=;
        b=RD2B0EG69b8OKZnnj756hYnzIFrMC1P5k91iAvvsAda5uoYE+WlRvWT9jDl7uATbjy
         62h+Nw2UTEmRlTbYi/Bz71Pa2PwWu6nojlkaEd3dvaqkjF2G/OSh0sACcKavbbBMDRTz
         QC7RKxkRauOI5Q/xCnylBpcJV75D94i9q+Sg6ijqw/3k6VTBiSYyYRZabGgYKHD2iHLE
         9Q+guZqSZoTh188oSGwbNZZkCvVxUqRFqwlVs6dy2Frlj8xpyBunyUQl4bOLedNeBLbj
         yRJFkD77uJUtwBpq8QiDmUc6RLZU0DYUDfdm1RUFGd/RA3SvDZjy7wWf9fTx8gntY+7I
         soAA==
X-Gm-Message-State: AOAM5338ux4vGwiicEzprpq3v6dOC8Om8VCmqS1CzHo+njBiEsAwRhXf
        EhU0JmrmilNlLb+dTZYExBeeUA==
X-Google-Smtp-Source: ABdhPJwzIvuxlCkOB40IyPdY/7bfjpy1/4p8yogqsh2unHhjGNAhjAspnCJQ1CqLRP9JfB6CvKkyig==
X-Received: by 2002:a63:2c4a:0:b0:3c1:df82:cf0e with SMTP id s71-20020a632c4a000000b003c1df82cf0emr2831567pgs.474.1652424022912;
        Thu, 12 May 2022 23:40:22 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id 185-20020a6204c2000000b0050dc76281d8sm934990pfe.178.2022.05.12.23.40.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 May 2022 23:40:22 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, jolsa@kernel.org, davemarchevsky@fb.com,
        joannekoong@fb.com, geliang.tang@suse.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com, yosryahmed@google.com
Subject: [PATCH bpf-next v3 2/2] selftests/bpf: add test case for bpf_map_lookup_percpu_elem
Date:   Fri, 13 May 2022 14:39:52 +0800
Message-Id: <20220513063952.41794-3-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220513063952.41794-1-zhoufeng.zf@bytedance.com>
References: <20220513063952.41794-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

test_progs:
Tests new ebpf helpers bpf_map_lookup_percpu_elem.

Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 .../bpf/prog_tests/map_lookup_percpu_elem.c   | 59 +++++++++++++++
 .../bpf/progs/test_map_lookup_percpu_elem.c   | 71 +++++++++++++++++++
 2 files changed, 130 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c

diff --git a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
new file mode 100644
index 000000000000..89ca170f1c25
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2022 Bytedance */
+
+#include <test_progs.h>
+
+#include "test_map_lookup_percpu_elem.skel.h"
+
+void test_map_lookup_percpu_elem(void)
+{
+	struct test_map_lookup_percpu_elem *skel;
+	__u64 key = 0, sum;
+	int ret, i;
+	int nr_cpus = libbpf_num_possible_cpus();
+	__u64 *buf;
+
+	buf = (__u64 *)malloc(nr_cpus*sizeof(__u64));
+	if (!ASSERT_OK_PTR(buf, "malloc"))
+		return;
+
+	for (i=0; i<nr_cpus; i++)
+		buf[i] = i;
+	sum = (nr_cpus-1)*nr_cpus/2;
+
+	skel = test_map_lookup_percpu_elem__open();
+	if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open"))
+		goto exit;
+
+	skel->rodata->nr_cpus = nr_cpus;
+
+	ret = test_map_lookup_percpu_elem__load(skel);
+	if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__load"))
+		goto cleanup;
+
+	ret = test_map_lookup_percpu_elem__attach(skel);
+	if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach"))
+		goto cleanup;
+
+	ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_array_map), &key, buf, 0);
+	ASSERT_OK(ret, "percpu_array_map update");
+
+	ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_hash_map), &key, buf, 0);
+	ASSERT_OK(ret, "percpu_hash_map update");
+
+	ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_lru_hash_map), &key, buf, 0);
+	ASSERT_OK(ret, "percpu_lru_hash_map update");
+
+	syscall(__NR_getuid);
+
+	test_map_lookup_percpu_elem__detach(skel);
+
+	ASSERT_EQ(skel->bss->percpu_array_elem_sum, sum, "percpu_array lookup percpu elem");
+	ASSERT_EQ(skel->bss->percpu_hash_elem_sum, sum, "percpu_hash lookup percpu elem");
+	ASSERT_EQ(skel->bss->percpu_lru_hash_elem_sum, sum, "percpu_lru_hash lookup percpu elem");
+
+cleanup:
+	test_map_lookup_percpu_elem__destroy(skel);
+exit:
+	free(buf);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c b/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
new file mode 100644
index 000000000000..75479180571f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2022 Bytedance */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+__u64 percpu_array_elem_sum = 0;
+__u64 percpu_hash_elem_sum = 0;
+__u64 percpu_lru_hash_elem_sum = 0;
+const volatile int nr_cpus;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} percpu_array_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(max_entries, 1);
+	__type(key, __u64);
+	__type(value, __u64);
+} percpu_hash_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_LRU_PERCPU_HASH);
+	__uint(max_entries, 1);
+	__type(key, __u64);
+	__type(value, __u64);
+} percpu_lru_hash_map SEC(".maps");
+
+struct read_percpu_elem_ctx {
+	void *map;
+	__u64 sum;
+};
+
+static int read_percpu_elem_callback(__u32 index, struct read_percpu_elem_ctx *ctx)
+{
+	__u64 key = 0;
+	__u64 *value;
+	value = bpf_map_lookup_percpu_elem(ctx->map, &key, index);
+	if (value)
+		ctx->sum += *value;
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_getuid")
+int sysenter_getuid(const void *ctx)
+{
+	struct read_percpu_elem_ctx map_ctx;
+
+	map_ctx.map = &percpu_array_map;
+	map_ctx.sum = 0;
+	bpf_loop(nr_cpus, read_percpu_elem_callback, &map_ctx, 0);
+	percpu_array_elem_sum = map_ctx.sum;
+
+	map_ctx.map = &percpu_hash_map;
+	map_ctx.sum = 0;
+	bpf_loop(nr_cpus, read_percpu_elem_callback, &map_ctx, 0);
+	percpu_hash_elem_sum = map_ctx.sum;
+
+	map_ctx.map = &percpu_lru_hash_map;
+	map_ctx.sum = 0;
+	bpf_loop(nr_cpus, read_percpu_elem_callback, &map_ctx, 0);
+	percpu_lru_hash_elem_sum = map_ctx.sum;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.20.1

