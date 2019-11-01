Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F234EC0D6
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 10:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfKAJxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 05:53:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbfKAJxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 05:53:06 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8E1EB83F4C
        for <netdev@vger.kernel.org>; Fri,  1 Nov 2019 09:53:05 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id c13so1911438lfk.23
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 02:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=a+/jPDyYUPXgZvYFzolXS5yTEYs2kB4f64mmykZ8Hpc=;
        b=CgjOyLhVuwltNNU7Pa9ZxDN5AuIG0NzO00u5g+zZzvfNpcJJeoqAWNE9LK89wlF8QG
         nhRMwcMThZpqz3z2qEuHQRE9NeYuPayNDgz5Fcg4eE2zA263ZzUr2HXllfEyMK8eLkJp
         Y5QV2gHqSQk28Mll3Fiojx+IjHDsHWxKk8zVFYpbE8CsildSax0bJp9bEkSHuri5VDyH
         gzR4f547LTyycIQEf9Vzp7qLMLF+xO4RNhrqlyfYCBFWyHg9TegWyhqtPwVljxG/CKq/
         Xx9OD6/EPHl81ZoqXFKhEHt/Ri7iaWb3DRTsB4hTrTjsjoJuwwAyBitU3TLgBvX69DKj
         XpdQ==
X-Gm-Message-State: APjAAAUiIsyOHdendQ7abQZ4+ub6uchA3MWBfejEFib0e9M5v6yVzG4O
        mka4nCu5wDt/qWwmA2DcJTylgcyeBYtp/yu0wXs/rMVKs1y03zj3mqjL9xGKs3S1pLugsLV/GSa
        j0WWbyD3x1W7HFMxL
X-Received: by 2002:a19:c3d1:: with SMTP id t200mr6528133lff.52.1572601984042;
        Fri, 01 Nov 2019 02:53:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwPegN5BNXBTkUnoROpZCldMSuV1E884wAeDxo1rzA9n+1JA6wDG6oCqXid0E5gOpmnMZXjBA==
X-Received: by 2002:a19:c3d1:: with SMTP id t200mr6528116lff.52.1572601983732;
        Fri, 01 Nov 2019 02:53:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id z24sm2539269lfj.40.2019.11.01.02.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 02:53:02 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 29D221818B6; Fri,  1 Nov 2019 10:53:02 +0100 (CET)
Subject: [PATCH bpf-next v5 5/5] selftests: Add tests for automatic map
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
Date:   Fri, 01 Nov 2019 10:53:02 +0100
Message-ID: <157260198209.335202.12139424443191715742.stgit@toke.dk>
In-Reply-To: <157260197645.335202.2393286837980792460.stgit@toke.dk>
References: <157260197645.335202.2393286837980792460.stgit@toke.dk>
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/pinning.c   |  208 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_pinning.c   |   31 +++
 .../selftests/bpf/progs/test_pinning_invalid.c     |   16 ++
 3 files changed, 255 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/pinning.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pinning.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pinning_invalid.c

diff --git a/tools/testing/selftests/bpf/prog_tests/pinning.c b/tools/testing/selftests/bpf/prog_tests/pinning.c
new file mode 100644
index 000000000000..ff089912c229
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/pinning.c
@@ -0,0 +1,208 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <test_progs.h>
+
+__u32 get_map_id(struct bpf_object *obj, const char *name)
+{
+	struct bpf_map_info map_info = {};
+	__u32 map_info_len, duration = 0;
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
+	const char *file_invalid = "./test_pinning_invalid.o";
+	const char *custpinpath = "/sys/fs/bpf/custom/pinmap";
+	const char *nopinpath = "/sys/fs/bpf/nopinmap";
+	const char *nopinpath2 = "/sys/fs/bpf/nopinmap2";
+	const char *custpath = "/sys/fs/bpf/custom";
+	const char *pinpath = "/sys/fs/bpf/pinmap";
+	const char *file = "./test_pinning.o";
+	__u32 map_id, map_id2, duration = 0;
+	struct stat statbuf = {};
+	struct bpf_object *obj;
+	struct bpf_map *map;
+	int err;
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
+		.pin_root_path = custpath,
+	);
+
+	/* check that opening fails with invalid pinning value in map def */
+	obj = bpf_object__open_file(file_invalid, NULL);
+	err = libbpf_get_error(obj);
+	if (CHECK(err != -EINVAL, "invalid open", "err %d errno %d\n", err, errno)) {
+		obj = NULL;
+		goto out;
+	}
+
+	/* open the valid object file  */
+	obj = bpf_object__open_file(file, NULL);
+	err = libbpf_get_error(obj);
+	if (CHECK(err, "default open", "err %d errno %d\n", err, errno)) {
+		obj = NULL;
+		goto out;
+	}
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
+	/* check that nopinmap was *not* pinned */
+	err = stat(nopinpath, &statbuf);
+	if (CHECK(!err || errno != ENOENT, "stat nopinpath",
+		  "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* check that nopinmap2 was *not* pinned */
+	err = stat(nopinpath2, &statbuf);
+	if (CHECK(!err || errno != ENOENT, "stat nopinpath2",
+		  "err %d errno %d\n", err, errno))
+		goto out;
+
+	map_id = get_map_id(obj, "pinmap");
+	if (!map_id)
+		goto out;
+
+	bpf_object__close(obj);
+
+	obj = bpf_object__open_file(file, NULL);
+	if (CHECK_FAIL(libbpf_get_error(obj))) {
+		obj = NULL;
+		goto out;
+	}
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
+	/* open the valid object file again */
+	obj = bpf_object__open_file(file, NULL);
+	err = libbpf_get_error(obj);
+	if (CHECK(err, "default open", "err %d errno %d\n", err, errno)) {
+		obj = NULL;
+		goto out;
+	}
+
+	/* swap pin paths of the two maps */
+	bpf_object__for_each_map(map, obj) {
+		if (!strcmp(bpf_map__name(map), "nopinmap"))
+			err = bpf_map__set_pin_path(map, pinpath);
+		else if (!strcmp(bpf_map__name(map), "pinmap"))
+			err = bpf_map__set_pin_path(map, NULL);
+		else
+			continue;
+
+		if (CHECK(err, "set pin path", "err %d errno %d\n", err, errno))
+			goto out;
+	}
+
+	/* should fail because of map parameter mismatch */
+	err = bpf_object__load(obj);
+	if (CHECK(err != -EINVAL, "param mismatch load", "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* test auto-pinning at custom path with open opt */
+	obj = bpf_object__open_file(file, &opts);
+	if (CHECK_FAIL(libbpf_get_error(obj))) {
+		obj = NULL;
+		goto out;
+	}
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
+	unlink(nopinpath2);
+	unlink(custpinpath);
+	rmdir(custpath);
+	if (obj)
+		bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/tools/testing/selftests/bpf/progs/test_pinning.c
new file mode 100644
index 000000000000..f69a4a50d056
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_pinning.c
@@ -0,0 +1,31 @@
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
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} nopinmap SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+	__uint(pinning, LIBBPF_PIN_NONE);
+} nopinmap2 SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_pinning_invalid.c b/tools/testing/selftests/bpf/progs/test_pinning_invalid.c
new file mode 100644
index 000000000000..51b38abe7ba1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_pinning_invalid.c
@@ -0,0 +1,16 @@
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
+	__uint(pinning, 2); /* invalid */
+} nopinmap3 SEC(".maps");
+
+char _license[] SEC("license") = "GPL";

