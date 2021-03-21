Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876FB343581
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 23:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhCUWrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 18:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhCUWqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 18:46:33 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0382DC061574;
        Sun, 21 Mar 2021 15:46:33 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id h7so11055200qtx.3;
        Sun, 21 Mar 2021 15:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ly08jgegs+pIqpL7gXfYm3S03fbXbYfaOyO7/zCU9iA=;
        b=XfbeLePCvyckLV/hvwZllGXz+MxJ1T+EyQAxn+H6YIiwHFZxRpQmy50trw60PTcRGF
         tWUBSWox8uPjAgaoGIhA6CArPQN4VKQMuqFfr8nfUZsOQg6eft0myhz7JuAUVGL6mKD5
         61f9Qb5gpkJIvDlTjCi4exal2igilIIg1Kt66RXY1nt9KpcGm/2B0WPMiQQ9cjFSZi6/
         gR7kksJUZKFSyciLFU454gx730zMuuNUm9bkJzFIE6MHozLpKo1YqsqTUuWk7ybYaZWn
         i6CkfxNrS/k87sZi0Gsz45gwDINfFo1ht6JEoEKRRzQc+cg4NhBFj1xOwKS4AucrNDaG
         aC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ly08jgegs+pIqpL7gXfYm3S03fbXbYfaOyO7/zCU9iA=;
        b=eJYTS8AJNpDornZ1nYFwvOFa7YosWgQIOxWKGehAXERYDN33QbWtWtF516H1dLNNYY
         jhwQ7hr0kOXvb8b2mNWHCUb6n8RnrLY4G5e6fvmqnn21tMseXCnehP+P+7kYym8bdvbc
         NelMqqreKfFZwVWYib/TYhesnHbJL5E6bat0vmA8RArr1Xhcl8HHnShqSzGtnCWgcojo
         VC1a5c5Vb9qaGKyj/90PlyznTXVHHLJurglATnrFdo74CGqpXQffuY1ndRjQ9iSqrH1i
         M7k8QnYw9wzx0D9sEmWI+jZg0BGhAzrFvR8qD/f6JQOR6fomBpMZyUygJVnCCcyeBT+w
         4Alw==
X-Gm-Message-State: AOAM53115Li0JpyZjAFJ+Mrz1VPgaXrl2S4ON0ARfWWttXAjdYGZsXl7
        +NCAbaw3TqZRjwVbSlvnPF8=
X-Google-Smtp-Source: ABdhPJxNz47fgib02/DUbYyFHFBmkc7bvnaXYEOB50C2HTTQngWae2JqwdQUpARPZaBFZcB7ntbgtw==
X-Received: by 2002:a05:622a:11cd:: with SMTP id n13mr7545369qtk.52.1616366792270;
        Sun, 21 Mar 2021 15:46:32 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id k16sm6556825qkj.55.2021.03.21.15.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 15:46:31 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
Cc:     jhs@mojatatu.com, Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 2/2] bpf: selftests: add tests for batched ops in LPM trie maps
Date:   Sun, 21 Mar 2021 19:45:21 -0300
Message-Id: <20210321224525.223432-3-pctammela@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210321224525.223432-1-pctammela@gmail.com>
References: <20210321224525.223432-1-pctammela@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pedro Tammela <pctammela@mojatatu.com>

Uses the already existing infrastructure for testing batched ops.
The testing code is essentially the same, with minor tweaks for this use
case.

Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 .../map_tests/lpm_trie_map_batch_ops.c (new)  | 158 ++++++++++++++++++
 1 file changed, 158 insertions(+)

diff --git a/tools/testing/selftests/bpf/map_tests/lpm_trie_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/lpm_trie_map_batch_ops.c
new file mode 100644
index 000000000000..166d0464a0d1
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/lpm_trie_map_batch_ops.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <arpa/inet.h>
+#include <linux/bpf.h>
+#include <netinet/in.h>
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include <test_maps.h>
+
+struct test_lpm_key {
+	__u32 prefix;
+	struct in_addr ipv4;
+};
+
+static void map_batch_update(int map_fd, __u32 max_entries,
+			     struct test_lpm_key *keys, int *values)
+{
+	__u32 i;
+	int err;
+	char buff[32] = { 0 };
+	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
+		.elem_flags = 0,
+		.flags = 0,
+	);
+
+	for (i = 0; i < max_entries; i++) {
+		keys[i].prefix = 32;
+		sprintf(buff, "192.168.1.%d", i + 1);
+		inet_pton(AF_INET, buff, &keys[i].ipv4);
+		values[i] = i + 1;
+	}
+
+	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, &opts);
+	CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
+}
+
+static void map_batch_verify(int *visited, __u32 max_entries,
+			     struct test_lpm_key *keys, int *values)
+{
+	char buff[32] = { 0 };
+	__u32 i;
+	int lower_byte;
+
+	memset(visited, 0, max_entries * sizeof(*visited));
+	for (i = 0; i < max_entries; i++) {
+		inet_ntop(AF_INET, &keys[i].ipv4, buff, 32);
+		sscanf(buff, "192.168.1.%d", &lower_byte);
+		CHECK(lower_byte != values[i], "key/value checking",
+		      "error: i %d key %s value %d\n", i, buff, values[i]);
+		visited[i] = 1;
+	}
+	for (i = 0; i < max_entries; i++) {
+		CHECK(visited[i] != 1, "visited checking",
+		      "error: keys array at index %d missing\n", i);
+	}
+}
+
+void test_lpm_trie_map_batch_ops(void)
+{
+	struct bpf_create_map_attr xattr = {
+		.name = "lpm_trie_map",
+		.map_type = BPF_MAP_TYPE_LPM_TRIE,
+		.key_size = sizeof(struct test_lpm_key),
+		.value_size = sizeof(int),
+		.map_flags = BPF_F_NO_PREALLOC,
+	};
+	struct test_lpm_key *keys, key;
+	int map_fd, *values, *visited;
+	__u32 step, count, total, total_success;
+	const __u32 max_entries = 10;
+	__u64 batch = 0;
+	int err;
+	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
+		.elem_flags = 0,
+		.flags = 0,
+	);
+
+
+	xattr.max_entries = max_entries;
+	map_fd = bpf_create_map_xattr(&xattr);
+	CHECK(map_fd == -1, "bpf_create_map_xattr()", "error:%s\n",
+	      strerror(errno));
+
+	keys = malloc(max_entries * sizeof(struct test_lpm_key));
+	values = malloc(max_entries * sizeof(int));
+	visited = malloc(max_entries * sizeof(int));
+	CHECK(!keys || !values || !visited, "malloc()", "error:%s\n",
+	      strerror(errno));
+
+	total_success = 0;
+	for (step = 1; step < max_entries; step++) {
+		map_batch_update(map_fd, max_entries, keys, values);
+		map_batch_verify(visited, max_entries, keys, values);
+		memset(keys, 0, max_entries * sizeof(*keys));
+		memset(values, 0, max_entries * sizeof(*values));
+		batch = 0;
+		total = 0;
+		/* iteratively lookup/delete elements with 'step'
+		 * elements each.
+		 */
+		count = step;
+		while (true) {
+			err = bpf_map_lookup_batch(
+				map_fd, total ? &batch : NULL, &batch,
+				keys + total, values + total, &count, &opts);
+
+			CHECK((err && errno != ENOENT), "lookup with steps",
+			      "error: %s\n", strerror(errno));
+
+			total += count;
+			if (err)
+				break;
+		}
+
+		CHECK(total != max_entries, "lookup with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+
+		map_batch_verify(visited, max_entries, keys, values);
+
+		total = 0;
+		count = step;
+		while (total < max_entries) {
+			if (max_entries - total < step)
+				count = max_entries - total;
+			err = bpf_map_delete_batch(map_fd, keys + total, &count,
+						   &opts);
+			CHECK((err && errno != ENOENT), "delete batch",
+			      "error: %s\n", strerror(errno));
+			total += count;
+			if (err)
+				break;
+		}
+		CHECK(total != max_entries, "delete with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+
+		/* check map is empty, errono == ENOENT */
+		err = bpf_map_get_next_key(map_fd, NULL, &key);
+		CHECK(!err || errno != ENOENT, "bpf_map_get_next_key()",
+		      "error: %s\n", strerror(errno));
+
+		total_success++;
+	}
+
+	CHECK(total_success == 0, "check total_success",
+	      "unexpected failure\n");
+
+	printf("%s:PASS\n", __func__);
+
+	free(keys);
+	free(values);
+	free(visited);
+}
-- 
2.25.1

