Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEB54DDE6C
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238851AbiCRQTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbiCRQSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:18:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECA55139AF4
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/OVyC0zaH1G/so0ZWrJlP+iwVNUqwQaVb/Gii8MLOPM=;
        b=TQvnDPY43a8b5idmlsHU9ZiVUQyRcqDIc8kGTlMzwyJ6nUbU3+O1+pd3iWlt9G4f4YDaT3
        sPJsbqP2DYxGWHdtAObEjn84S6+TrC/qqsNsoUglAEbaTAgoxRJKWak4jxWErJ/BAwUVhu
        lo9rwPjUYFGrx13oY+Fv7SHet6dkw3g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-GokVlFHFMx6rNO_pb1c6EA-1; Fri, 18 Mar 2022 12:17:27 -0400
X-MC-Unique: GokVlFHFMx6rNO_pb1c6EA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF68B83396E;
        Fri, 18 Mar 2022 16:17:26 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30DF433250;
        Fri, 18 Mar 2022 16:17:10 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v3 10/17] selftests/bpf: add test for user call of HID bpf programs
Date:   Fri, 18 Mar 2022 17:15:21 +0100
Message-Id: <20220318161528.1531164-11-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a simple test to see if we can trigger a bpf program of type
"hid/user_event".

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v3:
- use the new hid_get_data API

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 56 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 15 ++++++
 2 files changed, 71 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index b8d4dcf20b05..edc3af71e9ed 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -478,6 +478,59 @@ static int test_hid_attach_flags(struct hid *hid_skel, int uhid_fd, int sysfs_fd
 	return ret;
 }
 
+/*
+ * Attach hid_user to the given uhid device,
+ * call the bpf program from userspace
+ * check that the program is called and does the expected.
+ */
+static int test_hid_user_call(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
+{
+	int err, prog_fd;
+	u8 buf[10] = {0};
+	int ret = -1;
+
+	LIBBPF_OPTS(bpf_test_run_opts, run_attrs,
+		    .repeat = 1,
+		    .ctx_in = &sysfs_fd,
+		    .ctx_size_in = sizeof(sysfs_fd),
+		    .data_in = buf,
+		    .data_size_in = sizeof(buf),
+		    .data_out = buf,
+		    .data_size_out = sizeof(buf),
+	);
+
+	/* attach hid_user program */
+	hid_skel->links.hid_user = bpf_program__attach_hid(hid_skel->progs.hid_user, sysfs_fd, 0);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_user,
+			   "attach_hid(hid_user)"))
+		return PTR_ERR(hid_skel->links.hid_user);
+
+	buf[0] = 39;
+
+	prog_fd = bpf_program__fd(hid_skel->progs.hid_user);
+
+	err = bpf_prog_test_run_opts(prog_fd, &run_attrs);
+	if (!ASSERT_EQ(err, 0, "bpf_prog_test_run_xattr"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(run_attrs.retval, 72, "bpf_prog_test_run_opts"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[1], 42, "hid_user_check_in"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[2], 4, "hid_user_check_static_out"))
+		goto cleanup;
+
+	ret = 0;
+
+cleanup:
+
+	hid__detach(hid_skel);
+
+	return ret;
+}
+
 /*
  * Attach hid_rdesc_fixup to the given uhid device,
  * retrieve and open the matching hidraw node,
@@ -585,6 +638,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_attach_flags(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_user_raw_request");
 
+	err = test_hid_user_call(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_user");
+
 	/*
 	 * this test should be run last because we disconnect/reconnect
 	 * the device, meaning that it changes the overall uhid device
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index 390c1bb8d850..fbdbe9d1b605 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -128,3 +128,18 @@ int hid_test_insert3(struct hid_bpf_ctx *ctx)
 
 	return 0;
 }
+
+SEC("hid/user_event")
+int hid_user(struct hid_bpf_ctx *ctx)
+{
+	__u8 *data = bpf_hid_get_data(ctx, 0 /* offset */, 3 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	data[1] = data[0] + 3;
+	data[2] = 4;
+	ctx->retval = 72;
+
+	return 0;
+}
-- 
2.35.1

