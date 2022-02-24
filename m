Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB804C2A80
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbiBXLKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiBXLKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:10:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 630C121D0AA
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 03:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645700987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Co9gM4NcroP5T8KaacXR96ovTPx67wSvELeX0sLff8Q=;
        b=FHGll2/qAt5ZbtVJWssc2nyqRIy2zoXv69aEtoEsF8Pu4fhWHtRsie4T+rb4K7lDyizuI8
        1q6/9xkwHML54UFZVW0dVIz4DLp78GZBcIsbdXhE2+JN1XHDkyp10C0FXbqh5OvPZH2lJJ
        K4sfXeP+oEpM7VCla9sW62obR2ZXPyM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-FF2gvOBhMCqk5gb9g44ZyA-1; Thu, 24 Feb 2022 06:09:44 -0500
X-MC-Unique: FF2gvOBhMCqk5gb9g44ZyA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1918824FA6;
        Thu, 24 Feb 2022 11:09:41 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33DA37A526;
        Thu, 24 Feb 2022 11:09:38 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
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
Subject: [PATCH bpf-next v1 6/6] HID: bpf: add bpf_hid_raw_request helper function
Date:   Thu, 24 Feb 2022 12:08:28 +0100
Message-Id: <20220224110828.2168231-7-benjamin.tissoires@redhat.com>
In-Reply-To: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we are in a user_event context, we can talk to the device to fetch
or set features/outputs/inputs reports.
Add a bpf helper to do so. This helper is thus only available to
user_events, because calling this function while in IRQ context (any
other BPF type) is forbidden.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-bpf.c                        | 63 +++++++++++++++++
 drivers/hid/hid-core.c                       |  3 +-
 include/linux/bpf-hid.h                      |  2 +
 include/linux/hid.h                          |  1 +
 include/uapi/linux/bpf.h                     |  8 +++
 kernel/bpf/hid.c                             | 26 +++++++
 tools/include/uapi/linux/bpf.h               |  8 +++
 tools/testing/selftests/bpf/prog_tests/hid.c | 71 +++++++++++++++++++-
 tools/testing/selftests/bpf/progs/hid.c      | 57 ++++++++++++++++
 9 files changed, 236 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
index d775bda9d28d..180941061e53 100644
--- a/drivers/hid/hid-bpf.c
+++ b/drivers/hid/hid-bpf.c
@@ -138,6 +138,68 @@ int hid_bpf_set_data(struct hid_device *hdev, u8 *buf, u64 offset, u8 n, u32 dat
 	return 0;
 }
 
+int hid_bpf_raw_request(struct hid_device *hdev, u8 *buf, size_t size,
+			u8 rtype, u8 reqtype)
+{
+	struct hid_report *report;
+	struct hid_report_enum *report_enum;
+	u8 *dma_data;
+	u32 report_len;
+	int ret;
+
+	/* check arguments */
+	switch (rtype) {
+	case HID_INPUT_REPORT:
+	case HID_OUTPUT_REPORT:
+	case HID_FEATURE_REPORT:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (reqtype) {
+	case HID_REQ_GET_REPORT:
+	case HID_REQ_GET_IDLE:
+	case HID_REQ_GET_PROTOCOL:
+	case HID_REQ_SET_REPORT:
+	case HID_REQ_SET_IDLE:
+	case HID_REQ_SET_PROTOCOL:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (size < 1)
+		return -EINVAL;
+
+	report_enum = hdev->report_enum + rtype;
+	report = hid_get_report(report_enum, buf);
+	if (!report)
+		return -EINVAL;
+
+	report_len = hid_report_len(report);
+
+	if (size > report_len)
+		size = report_len;
+
+	dma_data = kmemdup(buf, size, GFP_KERNEL);
+	if (!dma_data)
+		return -ENOMEM;
+
+	ret = hid_hw_raw_request(hdev,
+				 dma_data[0],
+				 dma_data,
+				 size,
+				 rtype,
+				 reqtype);
+
+	if (ret > 0)
+		memcpy(buf, dma_data, ret);
+
+	kfree(dma_data);
+	return ret;
+}
+
 static int hid_bpf_run_progs(struct hid_device *hdev, enum bpf_hid_attach_type type,
 			     struct hid_bpf_ctx *ctx, u8 *data, int size)
 {
@@ -251,6 +313,7 @@ int __init hid_bpf_module_init(void)
 		.array_detached = hid_bpf_array_detached,
 		.hid_get_data = hid_bpf_get_data,
 		.hid_set_data = hid_bpf_set_data,
+		.hid_raw_request  = hid_bpf_raw_request,
 	};
 
 	bpf_hid_set_hooks(&hooks);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d3f4499ee4cd..d0e015986e17 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1686,8 +1686,7 @@ int hid_set_field(struct hid_field *field, unsigned offset, __s32 value)
 }
 EXPORT_SYMBOL_GPL(hid_set_field);
 
-static struct hid_report *hid_get_report(struct hid_report_enum *report_enum,
-		const u8 *data)
+struct hid_report *hid_get_report(struct hid_report_enum *report_enum, const u8 *data)
 {
 	struct hid_report *report;
 	unsigned int n = 0;	/* Normally report number is 0 */
diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
index 00ac4555aa5b..05d88b48c315 100644
--- a/include/linux/bpf-hid.h
+++ b/include/linux/bpf-hid.h
@@ -77,6 +77,8 @@ struct bpf_hid_hooks {
 	void (*array_detached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
 	int (*hid_get_data)(struct hid_device *hdev, u8 *buf, u64 offset, u8 size);
 	int (*hid_set_data)(struct hid_device *hdev, u8 *buf, u64 offset, u8 size, u32 data);
+	int (*hid_raw_request)(struct hid_device *hdev, u8 *buf, size_t size,
+			       u8 rtype, u8 reqtype);
 };
 
 #ifdef CONFIG_BPF
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 7454e844324c..b2698df31e5b 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -946,6 +946,7 @@ __u32 hid_field_extract(const struct hid_device *hid, __u8 *report,
 		     unsigned offset, unsigned n);
 void implement(const struct hid_device *hid, u8 *report, unsigned int offset, unsigned int n,
 	       u32 value);
+struct hid_report *hid_get_report(struct hid_report_enum *report_enum, const u8 *data);
 
 #ifdef CONFIG_PM
 int hid_driver_suspend(struct hid_device *hdev, pm_message_t state);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a374cc4aade6..058095d9961d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5105,6 +5105,13 @@ union bpf_attr {
  *		ctx->event.data field
  *	Return
  *		0 on success, a negative error on failure.
+ *
+ * int bpf_hid_raw_request(void *ctx, void *buf, u64 size, u8 rtype, u8 reqtype)
+ *	Description
+ *		communicate with the HID device
+ *	Return
+ *		0 on success.
+ *		negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5301,6 +5308,7 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(hid_get_data),		\
 	FN(hid_set_data),		\
+	FN(hid_raw_request),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
index 3714413e1eb6..9dfb66f9b1b6 100644
--- a/kernel/bpf/hid.c
+++ b/kernel/bpf/hid.c
@@ -107,6 +107,28 @@ static const struct bpf_func_proto bpf_hid_set_data_proto = {
 	.arg4_type = ARG_ANYTHING,
 };
 
+BPF_CALL_5(bpf_hid_raw_request, void*, ctx, void*, buf, u64, size,
+	   u8, rtype, u8, reqtype)
+{
+	struct hid_bpf_ctx *bpf_ctx = ctx;
+
+	if (!hid_hooks.hid_raw_request)
+		return -EOPNOTSUPP;
+
+	return hid_hooks.hid_raw_request(bpf_ctx->hdev, buf, size, rtype, reqtype);
+}
+
+static const struct bpf_func_proto bpf_hid_raw_request_proto = {
+	.func      = bpf_hid_raw_request,
+	.gpl_only  = true, /* hid_raw_request is EXPORT_SYMBOL_GPL */
+	.ret_type  = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_PTR_TO_MEM,
+	.arg3_type = ARG_CONST_SIZE_OR_ZERO,
+	.arg4_type = ARG_ANYTHING,
+	.arg5_type = ARG_ANYTHING,
+};
+
 static const struct bpf_func_proto *
 hid_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -115,6 +137,10 @@ hid_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_hid_get_data_proto;
 	case BPF_FUNC_hid_set_data:
 		return &bpf_hid_set_data_proto;
+	case BPF_FUNC_hid_raw_request:
+		if (prog->expected_attach_type != BPF_HID_DEVICE_EVENT)
+			return &bpf_hid_raw_request_proto;
+		return NULL;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a374cc4aade6..058095d9961d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5105,6 +5105,13 @@ union bpf_attr {
  *		ctx->event.data field
  *	Return
  *		0 on success, a negative error on failure.
+ *
+ * int bpf_hid_raw_request(void *ctx, void *buf, u64 size, u8 rtype, u8 reqtype)
+ *	Description
+ *		communicate with the HID device
+ *	Return
+ *		0 on success.
+ *		negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5301,6 +5308,7 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(hid_get_data),		\
 	FN(hid_set_data),		\
+	FN(hid_raw_request),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index b0cf615b0d0f..3dbad78ec121 100644
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
@@ -493,6 +506,59 @@ static int test_hid_user_call(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
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
@@ -603,6 +669,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_user_call(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_user");
 
+	err = test_hid_user_raw_request_call(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_user_raw_request");
+
 	err = test_rdesc_fixup(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_rdesc_fixup");
 
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index b2db809b3367..d49eb9e0e745 100644
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
@@ -90,3 +95,55 @@ int hid_user(struct hid_bpf_ctx *ctx)
 
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
+	__builtin_memcpy(buf, ctx->u.user.data, _buflen);
+
+	/*
+	 * build up a custom API for our needs:
+	 * offset 0, size 1: report type
+	 * offset 1, size 1: request type
+	 * offset 2+: data
+	 */
+	rtype = buf[0];
+	reqtype = buf[1];
+	size = ctx->u.user.size - 2;
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
+	__builtin_memcpy(&ctx->u.user.data[2], &buf[2], _buflen - 2);
+
+	ctx->u.user.size = ret + 2;
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

