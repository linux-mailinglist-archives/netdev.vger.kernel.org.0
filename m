Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6462257CFE4
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbiGUPlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGUPjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:39:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B13BA88CCA
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658417874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=htzi/5/aEWtM5W/NEX7+vfj6H/micuCnuN8qkKkPzfI=;
        b=HtY+d0qUnOOwpHZxwWEh6eAFmpe0LHTE9LuLhTJYLnDH3nu0KN3Wl2+hB1MJHQco5BeH4z
        sBR31pvzC6x9EQ/qZZebiaTQTV3YPE5R4YlYiNBAUeIt2+NQOFQ4BDW5vBi3Ur/GTV51wr
        zRxuz1AEiBdzTjYCPjJ+nRjYDxAStQU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-GJtnGBmvOJ2JSNtssmEm4A-1; Thu, 21 Jul 2022 11:37:44 -0400
X-MC-Unique: GJtnGBmvOJ2JSNtssmEm4A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9B8985A5B9;
        Thu, 21 Jul 2022 15:37:43 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91ED22166B26;
        Thu, 21 Jul 2022 15:37:40 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v7 21/24] selftests/bpf: Add a test for BPF_F_INSERT_HEAD
Date:   Thu, 21 Jul 2022 17:36:22 +0200
Message-Id: <20220721153625.1282007-22-benjamin.tissoires@redhat.com>
In-Reply-To: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Insert 3 programs to check that we are doing the correct thing:
'2', '1', '3' are inserted, but '1' is supposed to be executed first.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

no changes in v7

changes in v6:
- fixed copy/paste in ASSERT_OK and test execution order

changes in v5:
- use the new API

not in v4

changes in v3:
- use the new hid_get_data API

new in v2
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 107 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      |  54 +++++++++-
 2 files changed, 160 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index 9dc5f0038472..a86e16554e68 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -9,6 +9,7 @@
 #include <dirent.h>
 #include <poll.h>
 #include <stdbool.h>
+#include <linux/hid_bpf.h>
 #include <linux/hidraw.h>
 #include <linux/uhid.h>
 
@@ -83,6 +84,7 @@ static u8 feature_data[] = { 1, 2 };
 struct attach_prog_args {
 	int prog_fd;
 	unsigned int hid;
+	unsigned int flags;
 	int retval;
 };
 
@@ -770,6 +772,109 @@ static int test_hid_user_raw_request_call(int uhid_fd, int dev_id)
 	return ret;
 }
 
+/*
+ * Attach hid_insert{0,1,2} to the given uhid device,
+ * retrieve and open the matching hidraw node,
+ * inject one event in the uhid device,
+ * check that the programs have been inserted in the correct order.
+ */
+static int test_hid_attach_flags(int uhid_fd, int dev_id)
+{
+	struct hid *hid_skel = NULL;
+	u8 buf[64] = {0};
+	int hidraw_fd = -1;
+	int hid_id, attach_fd, err = -EINVAL;
+	struct attach_prog_args args = {
+		.retval = -1,
+	};
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, tattr,
+			    .ctx_in = &args,
+			    .ctx_size_in = sizeof(args),
+	);
+
+	/* locate the uevent file of the created device */
+	hid_id = get_hid_id(dev_id);
+	if (!ASSERT_GE(hid_id, 0, "locate uhid device id"))
+		goto cleanup;
+
+	args.hid = hid_id;
+
+	hid_skel = hid__open();
+	if (!ASSERT_OK_PTR(hid_skel, "hid_skel_open"))
+		goto cleanup;
+
+	bpf_program__set_autoload(hid_skel->progs.hid_test_insert1, true);
+	bpf_program__set_autoload(hid_skel->progs.hid_test_insert2, true);
+	bpf_program__set_autoload(hid_skel->progs.hid_test_insert3, true);
+
+	err = hid__load(hid_skel);
+	if (!ASSERT_OK(err, "hid_skel_load"))
+		goto cleanup;
+
+	attach_fd = bpf_program__fd(hid_skel->progs.attach_prog);
+	if (!ASSERT_GE(attach_fd, 0, "locate attach_prog")) {
+		err = attach_fd;
+		goto cleanup;
+	}
+
+	/* attach hid_test_insert2 program */
+	args.prog_fd = bpf_program__fd(hid_skel->progs.hid_test_insert2);
+	args.flags = HID_BPF_FLAG_NONE;
+	args.retval = 1;
+	err = bpf_prog_test_run_opts(attach_fd, &tattr);
+	if (!ASSERT_EQ(args.retval, 0, "attach_hid_test_insert2"))
+		goto cleanup;
+
+	/* then attach hid_test_insert1 program before the previous*/
+	args.prog_fd = bpf_program__fd(hid_skel->progs.hid_test_insert1);
+	args.flags = HID_BPF_FLAG_INSERT_HEAD;
+	args.retval = 1;
+	err = bpf_prog_test_run_opts(attach_fd, &tattr);
+	if (!ASSERT_EQ(args.retval, 0, "attach_hid_test_insert1"))
+		goto cleanup;
+
+	/* finally attach hid_test_insert3 at the end */
+	args.prog_fd = bpf_program__fd(hid_skel->progs.hid_test_insert3);
+	args.flags = HID_BPF_FLAG_NONE;
+	args.retval = 1;
+	err = bpf_prog_test_run_opts(attach_fd, &tattr);
+	if (!ASSERT_EQ(args.retval, 0, "attach_hid_test_insert3"))
+		goto cleanup;
+
+	hidraw_fd = open_hidraw(dev_id);
+	if (!ASSERT_GE(hidraw_fd, 0, "open_hidraw"))
+		goto cleanup;
+
+	/* inject one event */
+	buf[0] = 1;
+	send_event(uhid_fd, buf, 6);
+
+	/* read the data from hidraw */
+	memset(buf, 0, sizeof(buf));
+	err = read(hidraw_fd, buf, sizeof(buf));
+	if (!ASSERT_EQ(err, 6, "read_hidraw"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[1], 1, "hid_test_insert1"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[2], 2, "hid_test_insert2"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[3], 3, "hid_test_insert3"))
+		goto cleanup;
+
+	err = 0;
+
+ cleanup:
+	if (hidraw_fd >= 0)
+		close(hidraw_fd);
+
+	hid__destroy(hid_skel);
+
+	return err;
+}
+
 /*
  * Attach hid_rdesc_fixup to the given uhid device,
  * retrieve and open the matching hidraw node,
@@ -866,6 +971,8 @@ void serial_test_hid_bpf(void)
 	ASSERT_OK(err, "hid_change_report");
 	err = test_hid_user_raw_request_call(uhid_fd, dev_id);
 	ASSERT_OK(err, "hid_user_raw_request");
+	err = test_hid_attach_flags(uhid_fd, dev_id);
+	ASSERT_OK(err, "hid_attach_flags");
 
 	/*
 	 * this test should be run last because we disconnect/reconnect
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index 863c37ddf5ff..92cf57d2be3e 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -21,6 +21,7 @@ extern int hid_bpf_hw_request(struct hid_bpf_ctx *ctx,
 struct attach_prog_args {
 	int prog_fd;
 	unsigned int hid;
+	unsigned int flags;
 	int retval;
 };
 
@@ -60,7 +61,7 @@ int attach_prog(struct attach_prog_args *ctx)
 {
 	ctx->retval = hid_bpf_attach_prog(ctx->hid,
 					  ctx->prog_fd,
-					  0);
+					  ctx->flags);
 	return 0;
 }
 
@@ -152,3 +153,54 @@ int BPF_PROG(hid_rdesc_fixup, struct hid_bpf_ctx *hid_ctx)
 
 	return sizeof(rdesc) + 73;
 }
+
+SEC("?fmod_ret/hid_bpf_device_event")
+int BPF_PROG(hid_test_insert1, struct hid_bpf_ctx *hid_ctx)
+{
+	__u8 *data = hid_bpf_get_data(hid_ctx, 0 /* offset */, 4 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	/* we need to be run first */
+	if (data[2] || data[3])
+		return -1;
+
+	data[1] = 1;
+
+	return 0;
+}
+
+SEC("?fmod_ret/hid_bpf_device_event")
+int BPF_PROG(hid_test_insert2, struct hid_bpf_ctx *hid_ctx)
+{
+	__u8 *data = hid_bpf_get_data(hid_ctx, 0 /* offset */, 4 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	/* after insert0 and before insert2 */
+	if (!data[1] || data[3])
+		return -1;
+
+	data[2] = 2;
+
+	return 0;
+}
+
+SEC("?fmod_ret/hid_bpf_device_event")
+int BPF_PROG(hid_test_insert3, struct hid_bpf_ctx *hid_ctx)
+{
+	__u8 *data = hid_bpf_get_data(hid_ctx, 0 /* offset */, 4 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	/* at the end */
+	if (!data[1] || !data[2])
+		return -1;
+
+	data[3] = 3;
+
+	return 0;
+}
-- 
2.36.1

