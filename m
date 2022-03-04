Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBA94CDAFD
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239338AbiCDRfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240995AbiCDRfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:35:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30C68E3383
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrwFvawmGNYLjBbdBaVrUJ4+1AcvrT1rP+FxAAGD/3Y=;
        b=RqGrJILTPB5xOkYnnbsuQSwx3muM0wgFm3HPOeERatqRoQvoKstUN36WKG3VTTFRb76UCL
        BQguTZ1KOKSzSkanAuoXoIHRLYD2GQwgOcHk5NFw3AttsQFvLHwsQPrq36EpyA1RogYfs1
        AMqsEDd50xUgghnRqrmA/3Tq5LD5qDo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-piTcRwObNu6k0pucFk9asw-1; Fri, 04 Mar 2022 12:34:13 -0500
X-MC-Unique: piTcRwObNu6k0pucFk9asw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47AB3824FA6;
        Fri,  4 Mar 2022 17:34:11 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45500865A7;
        Fri,  4 Mar 2022 17:34:07 +0000 (UTC)
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
        Joe Stringer <joe@cilium.io>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v2 21/28] selftests/bpf: add tests for bpf_hid_hw_request
Date:   Fri,  4 Mar 2022 18:28:45 +0100
Message-Id: <20220304172852.274126-22-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
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

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 71 +++++++++++++++++++-
 tools/testing/selftests/bpf/progs/hid.c      | 57 ++++++++++++++++
 2 files changed, 127 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index cc01601c1168..a2bab6a799a1 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -67,6 +67,8 @@ static unsigned char rdesc[] = {
 	0xc0,			/* END_COLLECTION */
 };
 
+static u8 feature_data[] = { 1, 2 };
+
 static pthread_mutex_t uhid_started_mtx = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t uhid_started = PTHREAD_COND_INITIALIZER;
 
@@ -126,7 +128,7 @@ static void destroy(int fd)
 
 static int event(int fd)
 {
-	struct uhid_event ev;
+	struct uhid_event ev, answer;
 	ssize_t ret;
 
 	memset(&ev, 0, sizeof(ev));
@@ -143,6 +145,8 @@ static int event(int fd)
 		return -EFAULT;
 	}
 
+	memset(&answer, 0, sizeof(answer));
+
 	switch (ev.type) {
 	case UHID_START:
 		pthread_mutex_lock(&uhid_started_mtx);
@@ -167,6 +171,15 @@ static int event(int fd)
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
@@ -516,6 +529,59 @@ static int test_hid_user_call(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
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
+		bpf_program__attach_hid(hid_skel->progs.hid_user_raw_request, sysfs_fd);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_user_raw_request,
+			   "attach_hid(hid_user_raw_request)"))
+		return PTR_ERR(hid_skel->links.hid_user_raw_request);
+
+	buf[0] = 2; /* HID_FEATURE_REPORT */
+	buf[1] = 1; /* HID_REQ_GET_REPORT */
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
@@ -626,6 +692,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_user_call(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_user");
 
+	err = test_hid_user_raw_request_call(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_user_raw_request");
+
 	err = test_rdesc_fixup(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_rdesc_fixup");
 
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index fabfaf0f2526..ea011ff9e752 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -9,6 +9,11 @@ char _license[] SEC("license") = "GPL";
 __u64 callback_check = 52;
 __u64 callback2_check = 52;
 
+struct {
+	__uint(type, BPF_MAP_TYPE_RINGBUF);
+	__uint(max_entries, 4096 * 64);
+} ringbuf SEC(".maps");
+
 SEC("hid/device_event")
 int hid_first_event(struct hid_bpf_ctx *ctx)
 {
@@ -121,3 +126,55 @@ int hid_user(struct hid_bpf_ctx *ctx)
 
 	return 0;
 }
+
+SEC("hid/user_event")
+int hid_user_raw_request(struct hid_bpf_ctx *ctx)
+{
+	const unsigned int buflen = 256;
+	const unsigned int _buflen = buflen * sizeof(__u8);
+	__u8 *buf;
+	int ret;
+	__u32 size;
+	__u8 rtype, reqtype;
+
+	buf = bpf_ringbuf_reserve(&ringbuf, _buflen, 0);
+	if (!buf)
+		return -12; /* -ENOMEM */
+
+	__builtin_memcpy(buf, ctx->data, _buflen);
+
+	/*
+	 * build up a custom API for our needs:
+	 * offset 0, size 1: report type
+	 * offset 1, size 1: request type
+	 * offset 2+: data
+	 */
+	rtype = buf[0];
+	reqtype = buf[1];
+	size = ctx->size - 2;
+
+	if (size < _buflen - 2) {
+		ret = bpf_hid_raw_request(ctx,
+					  &buf[2],
+					  size,
+					  rtype,
+					  reqtype);
+		if (ret < 0)
+			goto discard;
+	} else {
+		ret = -7; /* -E2BIG */
+		goto discard;
+	}
+
+	__builtin_memcpy(&ctx->data[2], &buf[2], _buflen - 2);
+
+	ctx->size = ret + 2;
+	ctx->u.user.retval = ret;
+
+	ret = 0;
+
+ discard:
+	bpf_ringbuf_discard(buf, 0);
+
+	return ret;
+}
-- 
2.35.1

