Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E6C102CA6
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 20:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfKSTbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 14:31:08 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:54435 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbfKSTbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 14:31:06 -0500
Received: by mail-pf1-f202.google.com with SMTP id 2so17483970pfv.21
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 11:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UVq6jpQg/LNjDNZAINhBK5BhAgNJ+pc6Cyp4zXHQ5bk=;
        b=Cmi03rmwd//plD6T6OyZ0hvhNFrDL0J81Qra4TZilKuIiud/Eals/ds9ajIhcTHzpa
         0rxRyib9k8QYpS9iOCxXnZ4IggyuYyaP+/EeSyaUNDiDg1HRPl7FPkeBbFzOkwOYfwi0
         /wd28w4jzMYma6uMVcQXiOrwJVw9j7diDhfocjonEK6wEmJBoFFDS0o58GTZPGvPtq/v
         rydVrgkLMErJQAIZ1Wy54HCK4PUSkICy3Hqu39g9iv/2u5t4DTJZuTMPRyf4UH0vfBUw
         66Ocf89l+zmLYxIouwso9+flH4N6osHha3P5GdmKW3qRieepVOtgn0JS6Um4Z5Lu/5N/
         zHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UVq6jpQg/LNjDNZAINhBK5BhAgNJ+pc6Cyp4zXHQ5bk=;
        b=naSOoBE7hd3Nj/a+hUYXTBpNMAmZBiysmkQiHx3f4pMd/zjjbFq8ykkhNKTSXp87lr
         +2hwft+/oGcXT9Vm4WzDYZIR4V3LuSSbUNkQ3kHsWy6EKh9OMw3l7DHpoV4RZ9JQbKdA
         xspjxUz/WyIR+ilWQzk58zxnx7rTaYK8zjFo9rLLvVmSsF1vQshnsJbePQ+56ibPW0JN
         UDCxsdo7uv4S4q0dvCY6Pk0Se5R8oUiOnX75mk/UwdOkb6C5GfuOD74DelbzqkWrxDP3
         wvv3ig/r8Ut10UWGBdxdXFGU2V5MKIJsdN1hHsn42ERzOKgESEq+Rps5MF/MKJnz85IW
         kxXg==
X-Gm-Message-State: APjAAAXWERRMqgcykWt8BSdVLaBWMZdjOd9MDmhBOaJYNU/1icvVFGNb
        clAhw4LgpOhJMVzEqBV3cmtwPamy+es1
X-Google-Smtp-Source: APXvYqzM02kO6RhwHi8KQwUiwrhvbj3RsvoKVxBf7q0qYIiqEuz5qZ8IOVzl8y6qv6pOLHl2zSvlGy7/tsP5
X-Received: by 2002:a63:a804:: with SMTP id o4mr6874477pgf.401.1574191863504;
 Tue, 19 Nov 2019 11:31:03 -0800 (PST)
Date:   Tue, 19 Nov 2019 11:30:35 -0800
In-Reply-To: <20191119193036.92831-1-brianvv@google.com>
Message-Id: <20191119193036.92831-9-brianvv@google.com>
Mime-Version: 1.0
References: <20191119193036.92831-1-brianvv@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v2 bpf-next 8/9] selftests/bpf: add batch ops testing for hmap
 and hmap_percpu
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

Tested bpf_map_lookup_and_delete_batch() and bpf_map_update_batch()
functionality.
  $ ./test_maps
    ...
      test_hmap_lookup_and_delete_batch:PASS
      test_pcpu_hmap_lookup_and_delete_batch:PASS
    ...

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 .../map_lookup_and_delete_batch_htab.c        | 257 ++++++++++++++++++
 1 file changed, 257 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_htab.c

diff --git a/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_htab.c b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_htab.c
new file mode 100644
index 0000000000000..93e024cb85c60
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_htab.c
@@ -0,0 +1,257 @@
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
+	int i, j, err;
+	value *v;
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
+	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, 0, 0);
+	CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
+}
+
+static void map_batch_verify(int *visited, __u32 max_entries,
+			     int *keys, void *values, bool is_pcpu)
+{
+	typedef BPF_DECLARE_PERCPU(int, value);
+	value *v;
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
+	int map_type = is_pcpu ? BPF_MAP_TYPE_PERCPU_HASH : BPF_MAP_TYPE_HASH;
+	struct bpf_create_map_attr xattr = {
+		.name = "hash_map",
+		.map_type = map_type,
+		.key_size = sizeof(int),
+		.value_size = sizeof(int),
+	};
+	typedef BPF_DECLARE_PERCPU(int, value);
+	int map_fd, *keys, *visited, key;
+	__u32 batch = 0, count, total, total_success;
+	const __u32 max_entries = 10;
+	int err, i, step, value_size;
+	value pcpu_values[10];
+	bool nospace_err;
+	void *values;
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
+					      values, &count, 0, 0);
+	CHECK((err && errno != ENOENT), "empty map",
+	      "error: %s\n", strerror(errno));
+
+	/* populate elements to the map */
+	map_batch_update(map_fd, max_entries, keys, values, is_pcpu);
+
+	/* test 2: lookup/delete with count = 0, success */
+	batch = 0;
+	count = 0;
+	err = bpf_map_lookup_and_delete_batch(map_fd, NULL, &batch, keys,
+					      values, &count, 0, 0);
+	CHECK(err, "count = 0", "error: %s\n", strerror(errno));
+
+	/* test 3: lookup/delete with count = max_entries, success */
+	memset(keys, 0, max_entries * sizeof(*keys));
+	memset(values, 0, max_entries * value_size);
+	count = max_entries;
+	batch = 0;
+	err = bpf_map_lookup_and_delete_batch(map_fd, NULL, &batch, keys,
+					      values, &count, 0, 0);
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
+		batch = 0;
+		total = 0;
+		i = 0;
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
+						   &count, 0, 0);
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
+
+			CHECK((err && errno != ENOENT), "lookup with steps",
+			      "error: %s\n", strerror(errno));
+
+			total += count;
+			if (err)
+				break;
+
+			i++;
+		}
+		if (nospace_err == true)
+			continue;
+
+		CHECK(total != max_entries, "lookup with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+		map_batch_verify(visited, max_entries, keys, values, is_pcpu);
+
+		memset(keys, 0, max_entries * sizeof(*keys));
+		memset(values, 0, max_entries * value_size);
+		batch = 0;
+		total = 0;
+		i = 0;
+		/* iteratively lookup/delete elements with 'step'
+		 * elements each
+		 */
+		count = step;
+		nospace_err = false;
+		while (true) {
+			err = bpf_map_lookup_and_delete_batch(map_fd,
+							total ? &batch : NULL,
+							&batch, keys + total,
+							values +
+							total * value_size,
+							&count, 0, 0);
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
+			i++;
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
+}
+
+void test_hmap_lookup_and_delete_batch(void)
+{
+	__test_map_lookup_and_delete_batch(false);
+	printf("%s:PASS\n", __func__);
+}
+
+void test_pcpu_hmap_lookup_and_delete_batch(void)
+{
+	__test_map_lookup_and_delete_batch(true);
+	printf("%s:PASS\n", __func__);
+}
+
+void test_map_lookup_and_delete_batch_htab(void)
+{
+	test_hmap_lookup_and_delete_batch();
+	test_pcpu_hmap_lookup_and_delete_batch();
+}
-- 
2.24.0.432.g9d3f5f5b63-goog

