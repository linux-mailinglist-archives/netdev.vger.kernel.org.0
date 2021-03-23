Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878AF3455C5
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 03:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCWCwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 22:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhCWCv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 22:51:56 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5BEC061574;
        Mon, 22 Mar 2021 19:51:45 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id g20so12966959qkk.1;
        Mon, 22 Mar 2021 19:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aXRkbPr5evH4vo/g8h5sz3BYjvs8YssE9s0+neI0mfM=;
        b=sLoellt9v8ugioZgjloCW57uqmvQpkX5N68fYMQBim1adkY8rp52LO9FrxuZjxc/GF
         MOSVOcFeJC9T8ounFkOCRklJhx5mTPT05AhWwNEH4HNDWzPXaOFwXoId+AcmjKyC8U35
         aH+8aVwJS4T6VzUp1KZbyilfGxX3LZyFAIOMfo3JAqGbcu3obxTNQ5sKPcfEuZOZlVeV
         mWLGCssRcItCK6AbZQSr5ZR98OA/WOCHivERRPzoSG6MWUFkCfbifHYkOJcxXALrchm2
         u/gqyKt0APyFN16HGTnijfaI1FA1AxRuaAtNP6LHffinOIIAP3KUC3YjYgGbn+/pGGCb
         AgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aXRkbPr5evH4vo/g8h5sz3BYjvs8YssE9s0+neI0mfM=;
        b=iPKr/dkjHKXBFYhCMtkXQXWiPb76iVvJh49nFQO0MyrOpgmJ8ddWVAWmjDxiW3m+XZ
         u6YjcFwTSJtkL/oPm7sZcDoXmOZ4UUPQ6ZAlogGRWs6g8qgMicmNjoJlAvgZpg+y+ZUq
         im2dJXEimo6A47KdiXyzo7ByKPYqlO+4LVeAyVscB+fp+Ic1SE7v7StCaadAMfSuR4De
         TsnxTddYgRHzI8OQuH5QTqCyp9byFodmLIiP39Ps64gIbunSifEeOlkBIfKQHNIFGttL
         8RMbEE2jOS8XlNhv1P0o7XkaBHTHex2dmC8V3CHzreTJcyprC49spqc9iRboqG/KtE4z
         hA1g==
X-Gm-Message-State: AOAM530pM/OiiDt5t1rrwJdYEa/JkZ2f+a3smlpmEXJOUUWFd7wyNvdF
        rkcwjizJy69MrnvELm2zYZA=
X-Google-Smtp-Source: ABdhPJxG99u8YAT+7kA3y9w1Ww1RgiU3DlfrhRnyw1CNtbCpSenq+mSDO/hV6O2RF13QPCS15+sSBA==
X-Received: by 2002:a05:620a:791:: with SMTP id 17mr3443873qka.170.1616467904835;
        Mon, 22 Mar 2021 19:51:44 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id h13sm292265qtn.26.2021.03.22.19.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 19:51:44 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 2/2] bpf: selftests: add tests for batched ops in LPM trie maps
Date:   Mon, 22 Mar 2021 23:50:54 -0300
Message-Id: <20210323025058.315763-3-pctammela@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323025058.315763-1-pctammela@gmail.com>
References: <20210323025058.315763-1-pctammela@gmail.com>
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
index 000000000000..2e986e5e4cac
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
+	char buff[16] = { 0 };
+	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
+		.elem_flags = 0,
+		.flags = 0,
+	);
+
+	for (i = 0; i < max_entries; i++) {
+		keys[i].prefix = 32;
+		snprintf(buff, 16, "192.168.1.%d", i + 1);
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
+	char buff[16] = { 0 };
+	int lower_byte = 0;
+	__u32 i;
+
+	memset(visited, 0, max_entries * sizeof(*visited));
+	for (i = 0; i < max_entries; i++) {
+		inet_ntop(AF_INET, &keys[i].ipv4, buff, 32);
+		CHECK(sscanf(buff, "192.168.1.%d", &lower_byte) == EOF,
+		      "sscanf()", "error: i %d\n", i);
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
+			err = bpf_map_lookup_batch(map_fd,
+				total ? &batch : NULL, &batch,
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

