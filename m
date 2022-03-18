Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF214DDEB2
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbiCRQW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239041AbiCRQWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:22:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F2F62F09EE
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iDasbQdKPIktrclpqHMmE3acJqdiFWhVrVqJ26AsKBw=;
        b=aChWACSla+1uwWtGZOWJ2eYuyE/pVcA/Co7y3ZEll0r0LofqbX0MtgvohSqYbiriUZzv/c
        KW3LqNRWK/zyCw1BDkR5GNcdlfpVeyTRJ+CS1VrCf3QNMLCGi/S9XRSsIBDTOT/43R2NtF
        sF3WJ75Oa63As6+ZWnFDvr59pNi3XYo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-_EBLqudMNQKjWXIXAtoJpg-1; Fri, 18 Mar 2022 12:18:16 -0400
X-MC-Unique: _EBLqudMNQKjWXIXAtoJpg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 416FB38035BF;
        Fri, 18 Mar 2022 16:18:15 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 328A533250;
        Fri, 18 Mar 2022 16:18:06 +0000 (UTC)
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
Subject: [PATCH bpf-next v3 16/17] selftests/bpf: add tests for bpf_hid_hw_request
Date:   Fri, 18 Mar 2022 17:15:27 +0100
Message-Id: <20220318161528.1531164-17-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for the newly implemented function.
We test here only the GET_REPORT part because the other calls are pure
HID protocol and won't infer the result of the test of the bpf hook.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v3:
- use the new hid_get_data API
- directly use HID_FEATURE_REPORT and HID_REQ_GET_REPORT from uapi

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 72 +++++++++++++++++++-
 tools/testing/selftests/bpf/progs/hid.c      | 41 +++++++++++
 2 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index e8aa1c6357e8..27b6ea7da599 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -11,6 +11,7 @@
 #include <stdbool.h>
 #include <linux/hidraw.h>
 #include <linux/uhid.h>
+#include <linux/hid.h>
 
 static unsigned char rdesc[] = {
 	0x06, 0x00, 0xff,	/* Usage Page (Vendor Defined Page 1) */
@@ -67,6 +68,8 @@ static unsigned char rdesc[] = {
 	0xc0,			/* END_COLLECTION */
 };
 
+static u8 feature_data[] = { 1, 2 };
+
 static pthread_mutex_t uhid_started_mtx = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t uhid_started = PTHREAD_COND_INITIALIZER;
 
@@ -126,7 +129,7 @@ static void destroy(int fd)
 
 static int event(int fd)
 {
-	struct uhid_event ev;
+	struct uhid_event ev, answer;
 	ssize_t ret;
 
 	memset(&ev, 0, sizeof(ev));
@@ -143,6 +146,8 @@ static int event(int fd)
 		return -EFAULT;
 	}
 
+	memset(&answer, 0, sizeof(answer));
+
 	switch (ev.type) {
 	case UHID_START:
 		pthread_mutex_lock(&uhid_started_mtx);
@@ -167,6 +172,15 @@ static int event(int fd)
 		break;
 	case UHID_GET_REPORT:
 		fprintf(stderr, "UHID_GET_REPORT from uhid-dev\n");
+
+		answer.type = UHID_GET_REPORT_REPLY;
+		answer.u.get_report_reply.id = ev.u.get_report.id;
+		answer.u.get_report_reply.err = ev.u.get_report.rnum == 1 ? 0 : -EIO;
+		answer.u.get_report_reply.size = sizeof(feature_data);
+		memcpy(answer.u.get_report_reply.data, feature_data, sizeof(feature_data));
+
+		uhid_write(fd, &answer);
+
 		break;
 	case UHID_SET_REPORT:
 		fprintf(stderr, "UHID_SET_REPORT from uhid-dev\n");
@@ -587,6 +601,59 @@ static int test_hid_set_get_bits(struct hid *hid_skel, int uhid_fd, int sysfs_fd
 	return ret;
 }
 
+/*
+ * Attach hid_user_raw_request to the given uhid device,
+ * call the bpf program from userspace
+ * check that the program is called and does the expected.
+ */
+static int test_hid_user_raw_request_call(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
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
+	/* attach hid_user_raw_request program */
+	hid_skel->links.hid_user_raw_request =
+		bpf_program__attach_hid(hid_skel->progs.hid_user_raw_request, sysfs_fd, 0);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_user_raw_request,
+			   "attach_hid(hid_user_raw_request)"))
+		return PTR_ERR(hid_skel->links.hid_user_raw_request);
+
+	buf[0] = HID_FEATURE_REPORT;
+	buf[1] = HID_REQ_GET_REPORT;
+	buf[2] = 1; /* report ID */
+
+	prog_fd = bpf_program__fd(hid_skel->progs.hid_user_raw_request);
+
+	err = bpf_prog_test_run_opts(prog_fd, &run_attrs);
+	if (!ASSERT_EQ(err, 0, "bpf_prog_test_run_xattr"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(run_attrs.retval, 2, "bpf_prog_test_run_xattr_retval"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[3], 2, "hid_user_raw_request_check_in"))
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
@@ -700,6 +767,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_set_get_bits(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_set_get_data");
 
+	err = test_hid_user_raw_request_call(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_user_raw_request");
+
 	/*
 	 * this test should be run last because we disconnect/reconnect
 	 * the device, meaning that it changes the overall uhid device
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index d57571b9af9a..d7b75c0cba4b 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -162,3 +162,44 @@ int hid_set_get_bits(struct hid_bpf_ctx *ctx)
 
 	return 0;
 }
+
+SEC("hid/user_event")
+int hid_user_raw_request(struct hid_bpf_ctx *ctx)
+{
+	int ret;
+	__u32 size;
+	__u8 rtype, reqtype;
+	__u8 *data = bpf_hid_get_data(ctx, 0 /* offset */, 10 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	/*
+	 * build up a custom API for our needs:
+	 * offset 0, size 1: report type
+	 * offset 1, size 1: request type
+	 * offset 2+: data
+	 */
+	rtype = data[0];
+	reqtype = data[1];
+	size = ctx->size - 2;
+
+	if (size <= 8) {  /* 8 = len(data) - 2 */
+		ret = bpf_hid_raw_request(ctx,
+					  &data[2],
+					  size,
+					  rtype,
+					  reqtype);
+		if (ret < 0)
+			return ret;
+	} else {
+		return -7; /* -E2BIG */
+	}
+
+	ctx->size = ret + 2;
+	ctx->retval = ret;
+
+	ret = 0;
+
+	return ret;
+}
-- 
2.35.1

