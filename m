Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B0713AFDB
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgANQrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:47:01 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:54585 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgANQq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:46:59 -0500
Received: by mail-pf1-f201.google.com with SMTP id v14so9084032pfm.21
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=utFWUT6wlMosbqdVUWks9jGqk+aaGoz4H9C5fn7YGjc=;
        b=suons98sXGv+WZP3A0WOzWUhmDaJzA6cISir0AQCPvyueitlHsxzE44GK+dKUUr7zc
         EMvkPYuT+d8+lefNZ3Dz84eqb0HXbkq4WzC2Jv4RgH72LPXXLTE+wMLzPv7oQfhG0OvT
         FBf+2aPSjBU5WLejdzHOg6Bg+FQnu5P9s387y41rraratirCb495x0yv1zX9d4SFk/7m
         ta4YXNpmQUy1BACaHa95A4ckd1dgWon2VH/Kvtv6C93tJhcFU0WGzAr/WhSn1Gs5NpRY
         9YLfdwOqpeYbcxhPdYcLRu2Qup2ndWwJM4ujCNuOvRflKsxN0XT/zKE102LansKoa+LO
         h65Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=utFWUT6wlMosbqdVUWks9jGqk+aaGoz4H9C5fn7YGjc=;
        b=rITrLIajMx8BhnVunUB3PsCAC+49BsV/rH5Qojo8hnXIlMea+lyGSqwqhbNwlml7FF
         S/Lei8Bem66+2Oj2CYI1wW0b8IxwKCohR7VKVxmYpGB8gOJLbMpTTJoQhh8fapbLEMyo
         wn7p+8KeFc8ZNEWH/VnZMdzxG/W08i+b2KlDwlhDmf4zcJbEuFTWhi0PFv30lLp3hA3D
         yXbkEbrVHdyKROAW5YmZdUstugnrKaCK0+0cMQh59rEXn6OrODLimZ3LVhaUMc7ZvVcC
         BKb+6rAS6iHN83bNeV8IcXAMHgy2ati5euXpM0H7oJweyakgvgW27l2GoT7wTV6WWGLW
         wO+A==
X-Gm-Message-State: APjAAAUheUNPJH+US9VT5DH4jPHvRHYoUqX+haIlwVCYmAgaDoTgwZ9c
        GxfOPCvHf/BiGkAb60ece5qVy0XHIvld
X-Google-Smtp-Source: APXvYqwCbXHUN96hD1m5fhRfxiQHBzeJoLHzVq40CD8wueDkFEN9quREbNiy+kM8hP5feUtpk9+shhAo33Gm
X-Received: by 2002:a63:30c:: with SMTP id 12mr27766270pgd.276.1579020418779;
 Tue, 14 Jan 2020 08:46:58 -0800 (PST)
Date:   Tue, 14 Jan 2020 08:46:14 -0800
In-Reply-To: <20200114164614.47029-1-brianvv@google.com>
Message-Id: <20200114164614.47029-11-brianvv@google.com>
Mime-Version: 1.0
References: <20200114164614.47029-1-brianvv@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v4 bpf-next 9/9] selftests/bpf: add batch ops testing to array
 bpf map
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

Tested bpf_map_lookup_batch() and bpf_map_update_batch()
functionality.

  $ ./test_maps
      ...
        test_array_map_batch_ops:PASS
      ...

Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../bpf/map_tests/array_map_batch_ops.c       | 131 ++++++++++++++++++
 1 file changed, 131 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c

diff --git a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
new file mode 100644
index 0000000000000..05b7caea6a444
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include <test_maps.h>
+
+static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
+			     int *values)
+{
+	int i, err;
+
+	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
+		.elem_flags = 0,
+		.flags = 0,
+	);
+
+	for (i = 0; i < max_entries; i++) {
+		keys[i] = i;
+		values[i] = i + 1;
+	}
+
+	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, &opts);
+	CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
+}
+
+static void map_batch_verify(int *visited, __u32 max_entries,
+			     int *keys, int *values)
+{
+	int i;
+
+	memset(visited, 0, max_entries * sizeof(*visited));
+	for (i = 0; i < max_entries; i++) {
+		CHECK(keys[i] + 1 != values[i], "key/value checking",
+		      "error: i %d key %d value %d\n", i, keys[i], values[i]);
+		visited[i] = 1;
+	}
+	for (i = 0; i < max_entries; i++) {
+		CHECK(visited[i] != 1, "visited checking",
+		      "error: keys array at index %d missing\n", i);
+	}
+}
+
+void test_array_map_batch_ops(void)
+{
+	struct bpf_create_map_attr xattr = {
+		.name = "array_map",
+		.map_type = BPF_MAP_TYPE_ARRAY,
+		.key_size = sizeof(int),
+		.value_size = sizeof(int),
+	};
+	int map_fd, *keys, *values, *visited;
+	__u32 count, total, total_success;
+	const __u32 max_entries = 10000;
+	bool nospace_err;
+	__u64 batch = 0;
+	int err, step;
+
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
+	keys = malloc(max_entries * sizeof(int));
+	values = malloc(max_entries * sizeof(int));
+	visited = malloc(max_entries * sizeof(int));
+	CHECK(!keys || !values || !visited, "malloc()", "error:%s\n",
+	      strerror(errno));
+
+	/* populate elements to the map */
+	map_batch_update(map_fd, max_entries, keys, values);
+
+	/* test 1: lookup in a loop with various steps. */
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
+		nospace_err = false;
+		while (true) {
+			err = bpf_map_lookup_batch(map_fd,
+						total ? &batch : NULL, &batch,
+						keys + total,
+						values + total,
+						&count, &opts);
+
+			CHECK((err && errno != ENOENT), "lookup with steps",
+			      "error: %s\n", strerror(errno));
+
+			total += count;
+			if (err)
+				break;
+
+		}
+
+		if (nospace_err == true)
+			continue;
+
+		CHECK(total != max_entries, "lookup with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+
+		map_batch_verify(visited, max_entries, keys, values);
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
2.25.0.rc1.283.g88dfdc4193-goog

