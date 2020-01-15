Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C06B13CC5F
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgAOSno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:43:44 -0500
Received: from mail-yw1-f74.google.com ([209.85.161.74]:40185 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbgAOSnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:43:43 -0500
Received: by mail-yw1-f74.google.com with SMTP id v126so20252890ywf.7
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JYxxPDoIoQLQ7jSjLTKBV8X5KqxpPi921MyZWpnHjqU=;
        b=XqtMHQB+U0yAw+XVUIxEcaRCAhli3s1ROc/oIWs8LbfkiKTc+0ENuEqOWDku3k/6g2
         gxZi+1dKUlCsBMJaK0AKRWk803ini5/XilajvN51/9VAXyLDHmJ1RAvfVd3np5vJWmF2
         8VKUVQ4Wwo6ZxclMMmWFCth9emobgxC339Mgo1hLFDpKZ2LQ9EdOYfRsr3/CHadNkBZk
         2xNXMntXDCgqvHMbJWSGVwc/b5GySPMgvUI39KMxARm3SC+MsZvroqfBEin0oZz03FiB
         L5h4poPsQd886MpPGK8wjQvcM5KuI3GRrUIdkZQdDTF+FgXxiIdbo270WL7Q0Zp+Dhyc
         TKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JYxxPDoIoQLQ7jSjLTKBV8X5KqxpPi921MyZWpnHjqU=;
        b=UPi/khaIFpe1O+UuhTKbiUOQB2IqYB7nLTnnxDFN/Q76KBf4KCmPr1nxr5ke7B79L3
         9d5XqmbEsKWXIkzF/G+bQCxlbIKv71xU0Ml1si0CS649SubFeY7FuOTg7NzG73v6p5Ec
         wqA+lqyFqHbbD4XOi46PC3f2hgfzfzapYe9tfQ8xgayCuGGh5sCq42Pss6gCiAOU7Iez
         utIfNetW7ycgsqT0snaqGnCwRSPOCPOZMWFYDcWCBgwAyy6DkTY6BUTMIMrfx9wF9DPg
         Hc/p0BDqA8bW4Fu7Ivr6nua8ntj4F4ri7A1I2UHzvgs7SUN2ZTpJrdWd+oohlxFvIGc5
         Q3dw==
X-Gm-Message-State: APjAAAXp03A29x4alyqGym37blM+S1vf9JKLLhPSYS1qqGgQmFNdGOCN
        aEk39C+sGH3YA8zX935gvC9na1LFtKP8
X-Google-Smtp-Source: APXvYqxex6z0GwTJOrUDLiV/7gvzf8X06XuXIyOqPdxxp1iFy4sLec/60idqj4kurlP3GpIUPmEW/77OphKn
X-Received: by 2002:a81:9ac8:: with SMTP id r191mr22271033ywg.20.1579113821826;
 Wed, 15 Jan 2020 10:43:41 -0800 (PST)
Date:   Wed, 15 Jan 2020 10:43:07 -0800
In-Reply-To: <20200115184308.162644-1-brianvv@google.com>
Message-Id: <20200115184308.162644-9-brianvv@google.com>
Mime-Version: 1.0
References: <20200115184308.162644-1-brianvv@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v5 bpf-next 8/9] selftests/bpf: add batch ops testing for htab
 and htab_percpu map
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

Tested bpf_map_lookup_batch(), bpf_map_lookup_and_delete_batch(),
bpf_map_update_batch(), and bpf_map_delete_batch() functionality.
  $ ./test_maps
    ...
      test_htab_map_batch_ops:PASS
      test_htab_percpu_map_batch_ops:PASS
    ...

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 .../bpf/map_tests/htab_map_batch_ops.c        | 283 ++++++++++++++++++
 1 file changed, 283 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c

diff --git a/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c
new file mode 100644
index 0000000000000..976bf415fbdd9
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c
@@ -0,0 +1,283 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook  */
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include <bpf_util.h>
+#include <test_maps.h>
+
+static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
+			     void *values, bool is_pcpu)
+{
+	typedef BPF_DECLARE_PERCPU(int, value);
+	value *v = NULL;
+	int i, j, err;
+	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
+		.elem_flags = 0,
+		.flags = 0,
+	);
+
+	if (is_pcpu)
+		v = (value *)values;
+
+	for (i = 0; i < max_entries; i++) {
+		keys[i] = i + 1;
+		if (is_pcpu)
+			for (j = 0; j < bpf_num_possible_cpus(); j++)
+				bpf_percpu(v[i], j) = i + 2 + j;
+		else
+			((int *)values)[i] = i + 2;
+	}
+
+	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, &opts);
+	CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
+}
+
+static void map_batch_verify(int *visited, __u32 max_entries,
+			     int *keys, void *values, bool is_pcpu)
+{
+	typedef BPF_DECLARE_PERCPU(int, value);
+	value *v = NULL;
+	int i, j;
+
+	if (is_pcpu)
+		v = (value *)values;
+
+	memset(visited, 0, max_entries * sizeof(*visited));
+	for (i = 0; i < max_entries; i++) {
+
+		if (is_pcpu) {
+			for (j = 0; j < bpf_num_possible_cpus(); j++) {
+				CHECK(keys[i] + 1 + j != bpf_percpu(v[i], j),
+				      "key/value checking",
+				      "error: i %d j %d key %d value %d\n",
+				      i, j, keys[i], bpf_percpu(v[i],  j));
+			}
+		} else {
+			CHECK(keys[i] + 1 != ((int *)values)[i],
+			      "key/value checking",
+			      "error: i %d key %d value %d\n", i, keys[i],
+			      ((int *)values)[i]);
+		}
+
+		visited[i] = 1;
+
+	}
+	for (i = 0; i < max_entries; i++) {
+		CHECK(visited[i] != 1, "visited checking",
+		      "error: keys array at index %d missing\n", i);
+	}
+}
+
+void __test_map_lookup_and_delete_batch(bool is_pcpu)
+{
+	__u32 batch, count, total, total_success;
+	typedef BPF_DECLARE_PERCPU(int, value);
+	int map_fd, *keys, *visited, key;
+	const __u32 max_entries = 10;
+	value pcpu_values[max_entries];
+	int err, step, value_size;
+	bool nospace_err;
+	void *values;
+	struct bpf_create_map_attr xattr = {
+		.name = "hash_map",
+		.map_type = is_pcpu ? BPF_MAP_TYPE_PERCPU_HASH :
+			    BPF_MAP_TYPE_HASH,
+		.key_size = sizeof(int),
+		.value_size = sizeof(int),
+	};
+	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
+		.elem_flags = 0,
+		.flags = 0,
+	);
+
+	xattr.max_entries = max_entries;
+	map_fd = bpf_create_map_xattr(&xattr);
+	CHECK(map_fd == -1,
+	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
+
+	value_size = is_pcpu ? sizeof(value) : sizeof(int);
+	keys = malloc(max_entries * sizeof(int));
+	if (is_pcpu)
+		values = pcpu_values;
+	else
+		values = malloc(max_entries * sizeof(int));
+	visited = malloc(max_entries * sizeof(int));
+	CHECK(!keys || !values || !visited, "malloc()",
+	      "error:%s\n", strerror(errno));
+
+	/* test 1: lookup/delete an empty hash table, -ENOENT */
+	count = max_entries;
+	err = bpf_map_lookup_and_delete_batch(map_fd, NULL, &batch, keys,
+					      values, &count, &opts);
+	CHECK((err && errno != ENOENT), "empty map",
+	      "error: %s\n", strerror(errno));
+
+	/* populate elements to the map */
+	map_batch_update(map_fd, max_entries, keys, values, is_pcpu);
+
+	/* test 2: lookup/delete with count = 0, success */
+	count = 0;
+	err = bpf_map_lookup_and_delete_batch(map_fd, NULL, &batch, keys,
+					      values, &count, &opts);
+	CHECK(err, "count = 0", "error: %s\n", strerror(errno));
+
+	/* test 3: lookup/delete with count = max_entries, success */
+	memset(keys, 0, max_entries * sizeof(*keys));
+	memset(values, 0, max_entries * value_size);
+	count = max_entries;
+	err = bpf_map_lookup_and_delete_batch(map_fd, NULL, &batch, keys,
+					      values, &count, &opts);
+	CHECK((err && errno != ENOENT), "count = max_entries",
+	       "error: %s\n", strerror(errno));
+	CHECK(count != max_entries, "count = max_entries",
+	      "count = %u, max_entries = %u\n", count, max_entries);
+	map_batch_verify(visited, max_entries, keys, values, is_pcpu);
+
+	/* bpf_map_get_next_key() should return -ENOENT for an empty map. */
+	err = bpf_map_get_next_key(map_fd, NULL, &key);
+	CHECK(!err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
+
+	/* test 4: lookup/delete in a loop with various steps. */
+	total_success = 0;
+	for (step = 1; step < max_entries; step++) {
+		map_batch_update(map_fd, max_entries, keys, values, is_pcpu);
+		memset(keys, 0, max_entries * sizeof(*keys));
+		memset(values, 0, max_entries * value_size);
+		total = 0;
+		/* iteratively lookup/delete elements with 'step'
+		 * elements each
+		 */
+		count = step;
+		nospace_err = false;
+		while (true) {
+			err = bpf_map_lookup_batch(map_fd,
+						   total ? &batch : NULL,
+						   &batch, keys + total,
+						   values +
+						   total * value_size,
+						   &count, &opts);
+			/* It is possible that we are failing due to buffer size
+			 * not big enough. In such cases, let us just exit and
+			 * go with large steps. Not that a buffer size with
+			 * max_entries should always work.
+			 */
+			if (err && errno == ENOSPC) {
+				nospace_err = true;
+				break;
+			}
+
+			CHECK((err && errno != ENOENT), "lookup with steps",
+			      "error: %s\n", strerror(errno));
+
+			total += count;
+			if (err)
+				break;
+
+		}
+		if (nospace_err == true)
+			continue;
+
+		CHECK(total != max_entries, "lookup with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+		map_batch_verify(visited, max_entries, keys, values, is_pcpu);
+
+		total = 0;
+		count = step;
+		while (total < max_entries) {
+			if (max_entries - total < step)
+				count = max_entries - total;
+			err = bpf_map_delete_batch(map_fd,
+						   keys + total,
+						   &count, &opts);
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
+		/* iteratively lookup/delete elements with 'step'
+		 * elements each
+		 */
+		map_batch_update(map_fd, max_entries, keys, values, is_pcpu);
+		memset(keys, 0, max_entries * sizeof(*keys));
+		memset(values, 0, max_entries * value_size);
+		total = 0;
+		count = step;
+		nospace_err = false;
+		while (true) {
+			err = bpf_map_lookup_and_delete_batch(map_fd,
+							total ? &batch : NULL,
+							&batch, keys + total,
+							values +
+							total * value_size,
+							&count, &opts);
+			/* It is possible that we are failing due to buffer size
+			 * not big enough. In such cases, let us just exit and
+			 * go with large steps. Not that a buffer size with
+			 * max_entries should always work.
+			 */
+			if (err && errno == ENOSPC) {
+				nospace_err = true;
+				break;
+			}
+
+			CHECK((err && errno != ENOENT), "lookup with steps",
+			      "error: %s\n", strerror(errno));
+
+			total += count;
+			if (err)
+				break;
+		}
+
+		if (nospace_err == true)
+			continue;
+
+		CHECK(total != max_entries, "lookup/delete with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+
+		map_batch_verify(visited, max_entries, keys, values, is_pcpu);
+		err = bpf_map_get_next_key(map_fd, NULL, &key);
+		CHECK(!err, "bpf_map_get_next_key()", "error: %s\n",
+		      strerror(errno));
+
+		total_success++;
+	}
+
+	CHECK(total_success == 0, "check total_success",
+	      "unexpected failure\n");
+	free(keys);
+	free(visited);
+	if (!is_pcpu)
+		free(values);
+}
+
+void htab_map_batch_ops(void)
+{
+	__test_map_lookup_and_delete_batch(false);
+	printf("test_%s:PASS\n", __func__);
+}
+
+void htab_percpu_map_batch_ops(void)
+{
+	__test_map_lookup_and_delete_batch(true);
+	printf("test_%s:PASS\n", __func__);
+}
+
+void test_htab_map_batch_ops(void)
+{
+	htab_map_batch_ops();
+	htab_percpu_map_batch_ops();
+}
-- 
2.25.0.rc1.283.g88dfdc4193-goog

