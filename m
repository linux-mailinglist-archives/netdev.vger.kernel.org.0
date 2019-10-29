Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69485E901B
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 20:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732457AbfJ2Tjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 15:39:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732310AbfJ2Tjc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 15:39:32 -0400
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E8ADFC05A1BE
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 19:39:30 +0000 (UTC)
Received: by mail-lf1-f71.google.com with SMTP id c15so86546lfg.4
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 12:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mQb1uT6i/aW9lEp+uYRlf8mFGYalqNcO7R4V6FqicfA=;
        b=RwrmaqPJdTWJOBTm1VkYB0qB2gipciLCwVOy5i3uax1oUtbzFL/RxT20V2gNzWy+WV
         QLqcbaxuvEAvXDr0OBa77Li6MfUZ/sKxBNcTNiX8CBwP12nWRG5+7l4H84GmyOzL1Idx
         AcWku9QKAGD0bDaIjJV5iu8V51AMwWldu3TSosO0rlhI8HDmDOOa3YRSup1DR2qkdGqx
         7t4jzkNsR/YsGrOH21cbd3VpoxjuN0QVZ2qoH8niXXCz5965OxM6anmoZ/0VN2bC5lZV
         JJdHINy44g/YFjaIB5H9jKvPGXhvMnakjpjklTvZ+q9IFPxyBeXRyebEfpODmnHEG6jo
         vRBg==
X-Gm-Message-State: APjAAAU/cijKfmFrD03syXu5bNSzygRQJ2pfhhM9h7qbJfq3lVGU9SDF
        4QtCc7aXoioO/ERNvnMvGVIVDIjyYJ2Ff/xAMIIkIniC3CxC+G0N5ED7DS1WZBEt6LjY8GCB1a1
        D3svBJascT2oVK1ST
X-Received: by 2002:a19:6813:: with SMTP id d19mr3664158lfc.144.1572377969471;
        Tue, 29 Oct 2019 12:39:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyUbv2TsARrYFYuxNfkOeKA34xM1A5bLMyn/nOaoJFaDG4GtHHRy7lf6rRt7FdQmKYVSoOWDQ==
X-Received: by 2002:a19:6813:: with SMTP id d19mr3664141lfc.144.1572377969219;
        Tue, 29 Oct 2019 12:39:29 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id p4sm5839942ljp.103.2019.10.29.12.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 12:39:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E02F41818B7; Tue, 29 Oct 2019 20:39:27 +0100 (CET)
Subject: [PATCH bpf-next v4 5/5] selftests: Add tests for automatic map
 pinning
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Tue, 29 Oct 2019 20:39:27 +0100
Message-ID: <157237796779.169521.16760790702202542513.stgit@toke.dk>
In-Reply-To: <157237796219.169521.2129132883251452764.stgit@toke.dk>
References: <157237796219.169521.2129132883251452764.stgit@toke.dk>
User-Agent: StGit/0.20
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds a new BPF selftest to exercise the new automatic map pinning
code.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/pinning.c |  157 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_pinning.c |   29 ++++
 2 files changed, 186 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/pinning.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pinning.c

diff --git a/tools/testing/selftests/bpf/prog_tests/pinning.c b/tools/testing/selftests/bpf/prog_tests/pinning.c
new file mode 100644
index 000000000000..71f7dc51edc7
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/pinning.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <test_progs.h>
+
+__u32 get_map_id(struct bpf_object *obj, const char *name)
+{
+	__u32 map_info_len, duration, retval;
+	struct bpf_map_info map_info = {};
+	struct bpf_map *map;
+	int err;
+
+	map_info_len = sizeof(map_info);
+
+	map = bpf_object__find_map_by_name(obj, name);
+	if (CHECK(!map, "find map", "NULL map"))
+		return 0;
+
+	err = bpf_obj_get_info_by_fd(bpf_map__fd(map),
+				     &map_info, &map_info_len);
+	CHECK(err, "get map info", "err %d errno %d", err, errno);
+	return map_info.id;
+}
+
+void test_pinning(void)
+{
+	__u32 duration, retval, size, map_id, map_id2;
+	const char *custpinpath = "/sys/fs/bpf/custom/pinmap";
+	const char *nopinpath = "/sys/fs/bpf/nopinmap";
+	const char *custpath = "/sys/fs/bpf/custom";
+	const char *pinpath = "/sys/fs/bpf/pinmap";
+	const char *file = "./test_pinning.o";
+	struct stat statbuf = {};
+	struct bpf_object *obj;
+	struct bpf_map *map;
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
+		.pin_root_path = custpath,
+	);
+
+	int err;
+	obj = bpf_object__open_file(file, NULL);
+	if (CHECK_FAIL(libbpf_get_error(obj)))
+		return;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "default load", "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* check that pinmap was pinned */
+	err = stat(pinpath, &statbuf);
+	if (CHECK(err, "stat pinpath", "err %d errno %d\n", err, errno))
+		goto out;
+
+        /* check that nopinmap was *not* pinned */
+	err = stat(nopinpath, &statbuf);
+	if (CHECK(!err || errno != ENOENT, "stat nopinpath",
+		  "err %d errno %d\n", err, errno))
+		goto out;
+
+        map_id = get_map_id(obj, "pinmap");
+	if (!map_id)
+		goto out;
+
+	bpf_object__close(obj);
+
+	obj = bpf_object__open_file(file, NULL);
+	if (CHECK_FAIL(libbpf_get_error(obj)))
+		goto out;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "default load", "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* check that same map ID was reused for second load */
+	map_id2 = get_map_id(obj, "pinmap");
+	if (CHECK(map_id != map_id2, "check reuse",
+		  "err %d errno %d id %d id2 %d\n", err, errno, map_id, map_id2))
+		goto out;
+
+	/* should be no-op to re-pin same map */
+	map = bpf_object__find_map_by_name(obj, "pinmap");
+	if (CHECK(!map, "find map", "NULL map"))
+		goto out;
+
+	err = bpf_map__pin(map, NULL);
+	if (CHECK(err, "re-pin map", "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* but error to pin at different location */
+	err = bpf_map__pin(map, "/sys/fs/bpf/other");
+	if (CHECK(!err, "pin map different", "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* unpin maps with a pin_path set */
+	err = bpf_object__unpin_maps(obj, NULL);
+	if (CHECK(err, "unpin maps", "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* and re-pin them... */
+	err = bpf_object__pin_maps(obj, NULL);
+	if (CHECK(err, "pin maps", "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* set pinning path of other map and re-pin all */
+	map = bpf_object__find_map_by_name(obj, "nopinmap");
+	if (CHECK(!map, "find map", "NULL map"))
+		goto out;
+
+	err = bpf_map__set_pin_path(map, custpinpath);
+	if (CHECK(err, "set pin path", "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* should only pin the one unpinned map */
+	err = bpf_object__pin_maps(obj, NULL);
+	if (CHECK(err, "pin maps", "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* check that nopinmap was pinned at the custom path */
+	err = stat(custpinpath, &statbuf);
+	if (CHECK(err, "stat custpinpath", "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* remove the custom pin path to re-test it with auto-pinning below */
+	err = unlink(custpinpath);
+	if (CHECK(err, "unlink custpinpath", "err %d errno %d\n", err, errno))
+		goto out;
+
+	err = rmdir(custpath);
+	if (CHECK(err, "rmdir custpindir", "err %d errno %d\n", err, errno))
+		goto out;
+
+	bpf_object__close(obj);
+
+	/* test auto-pinning at custom path with open opt */
+	obj = bpf_object__open_file(file, &opts);
+	if (CHECK_FAIL(libbpf_get_error(obj)))
+		return;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "custom load", "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* check that pinmap was pinned at the custom path */
+	err = stat(custpinpath, &statbuf);
+	if (CHECK(err, "stat custpinpath", "err %d errno %d\n", err, errno))
+		goto out;
+
+out:
+	unlink(pinpath);
+	unlink(nopinpath);
+	unlink(custpinpath);
+	rmdir(custpath);
+	if (obj)
+		bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/tools/testing/selftests/bpf/progs/test_pinning.c
new file mode 100644
index 000000000000..ff2d7447777e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_pinning.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+int _version SEC("version") = 1;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+	__uint(pinning, LIBBPF_PIN_BY_NAME);
+} pinmap SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} nopinmap SEC(".maps");
+
+SEC("xdp_prog")
+int _xdp_prog(struct xdp_md *xdp)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";

