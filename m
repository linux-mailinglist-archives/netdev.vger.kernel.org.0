Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4DC176E12
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgCCEc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:32:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21802 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727407AbgCCEc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:32:29 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0234SrDh030907
        for <netdev@vger.kernel.org>; Mon, 2 Mar 2020 20:32:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=qyVhPGmp3ezkdda4gNOK0tREMIZBeQy3ChgkVcwVWZs=;
 b=IypjOSupI49cOdKjcibyIRGNL7VlRcQEGgBUQAvFgCgruywP9CPhmIf5vjVbaj08ltNN
 jOaFlgndHZcz0EADoSBOTxQg2a4JnMiGjdWBIO9gc3UUcDr6yVpK7QEQg0Et1fv0gnHI
 IYSU/l2/yAkGxNDOoVhogj1yRArH372GIN4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yg8x7gn7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 20:32:27 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 20:32:26 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D7B8B2EC2DD1; Mon,  2 Mar 2020 20:32:10 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/3] selftests/bpf: add link pinning selftests
Date:   Mon, 2 Mar 2020 20:31:59 -0800
Message-ID: <20200303043159.323675-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303043159.323675-1-andriin@fb.com>
References: <20200303043159.323675-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_09:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 suspectscore=8 bulkscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 phishscore=0 mlxlogscore=962 clxscore=1015 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030033
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests validating link pinning/unpinning and associated BPF link
(attachment) lifetime.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/link_pinning.c   | 105 ++++++++++++++++++
 .../selftests/bpf/progs/test_link_pinning.c   |  25 +++++
 2 files changed, 130 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/link_pinning.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_link_pinning.c

diff --git a/tools/testing/selftests/bpf/prog_tests/link_pinning.c b/tools/testing/selftests/bpf/prog_tests/link_pinning.c
new file mode 100644
index 000000000000..a743288cf384
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/link_pinning.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <test_progs.h>
+#include <sys/stat.h>
+
+#include "test_link_pinning.skel.h"
+
+static int duration = 0;
+
+void test_link_pinning_subtest(struct bpf_program *prog,
+			       struct test_link_pinning__bss *bss)
+{
+	const char *link_pin_path = "/sys/fs/bpf/pinned_link_test";
+	struct stat statbuf = {};
+	struct bpf_link *link;
+	int err, i;
+
+	link = bpf_program__attach(prog);
+	if (CHECK(IS_ERR(link), "link_attach", "err: %ld\n", PTR_ERR(link)))
+		goto cleanup;
+
+	bss->in = 1;
+	usleep(1);
+	CHECK(bss->out != 1, "res_check1", "exp %d, got %d\n", 1, bss->out);
+
+	/* pin link */
+	err = bpf_link__pin(link, link_pin_path);
+	if (CHECK(err, "link_pin", "err: %d\n", err))
+		goto cleanup;
+
+	CHECK(strcmp(link_pin_path, bpf_link__pin_path(link)), "pin_path1",
+	      "exp %s, got %s\n", link_pin_path, bpf_link__pin_path(link));
+
+	/* check that link was pinned */
+	err = stat(link_pin_path, &statbuf);
+	if (CHECK(err, "stat_link", "err %d errno %d\n", err, errno))
+		goto cleanup;
+
+	bss->in = 2;
+	usleep(1);
+	CHECK(bss->out != 2, "res_check2", "exp %d, got %d\n", 2, bss->out);
+
+	/* destroy link, pinned link should keep program attached */
+	bpf_link__destroy(link);
+	link = NULL;
+
+	bss->in = 3;
+	usleep(1);
+	CHECK(bss->out != 3, "res_check3", "exp %d, got %d\n", 3, bss->out);
+
+	/* re-open link from BPFFS */
+	link = bpf_link__open(link_pin_path);
+	if (CHECK(IS_ERR(link), "link_open", "err: %ld\n", PTR_ERR(link)))
+		goto cleanup;
+
+	CHECK(strcmp(link_pin_path, bpf_link__pin_path(link)), "pin_path2",
+	      "exp %s, got %s\n", link_pin_path, bpf_link__pin_path(link));
+
+	/* unpin link from BPFFS, program still attached */
+	err = bpf_link__unpin(link);
+	if (CHECK(err, "link_unpin", "err: %d\n", err))
+		goto cleanup;
+
+	/* still active, as we have FD open now */
+	bss->in = 4;
+	usleep(1);
+	CHECK(bss->out != 4, "res_check4", "exp %d, got %d\n", 4, bss->out);
+
+	bpf_link__destroy(link);
+	link = NULL;
+
+	/* Validate it's finally detached.
+	 * Actual detachment might get delayed a bit, so there is no reliable
+	 * way to validate it immediately here, let's count up for long enough
+	 * and see if eventually output stops being updated
+	 */
+	for (i = 5; i < 10000; i++) {
+		bss->in = i;
+		usleep(1);
+		if (bss->out == i - 1)
+			break;
+	}
+	CHECK(i == 10000, "link_attached", "got to iteration #%d\n", i);
+
+cleanup:
+	if (!IS_ERR(link))
+		bpf_link__destroy(link);
+}
+
+void test_link_pinning(void)
+{
+	struct test_link_pinning* skel;
+
+	skel = test_link_pinning__open_and_load();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+
+	if (test__start_subtest("pin_raw_tp"))
+		test_link_pinning_subtest(skel->progs.raw_tp_prog, skel->bss);
+	if (test__start_subtest("pin_tp_btf"))
+		test_link_pinning_subtest(skel->progs.tp_btf_prog, skel->bss);
+
+	test_link_pinning__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_link_pinning.c b/tools/testing/selftests/bpf/progs/test_link_pinning.c
new file mode 100644
index 000000000000..bbf2a5264dc0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_link_pinning.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <stdbool.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+int in = 0;
+int out = 0;
+
+SEC("raw_tp/sys_enter")
+int raw_tp_prog(const void *ctx)
+{
+	out = in;
+	return 0;
+}
+
+SEC("tp_btf/sys_enter")
+int tp_btf_prog(const void *ctx)
+{
+	out = in;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.17.1

