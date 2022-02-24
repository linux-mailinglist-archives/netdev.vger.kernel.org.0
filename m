Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD9E4C2A64
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbiBXLKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbiBXLJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:09:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CFBC14A21F
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 03:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645700966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7YFf/SYfa0TO9SFiqYAnYqx3zzId6FxMxZIck8PhS+Y=;
        b=NjoV4jeCm1/bEwHhm5/o/fWSD0ffhOOOKclXHqei+Gz/CtJG+w5Kk3L88DncetSSHjE/Fz
        ZkZ26yuCgfyxzBeRXRGWU8umdqNw3B40NM4oaI8+SpZiV8ePI8MCdCe/TS6IArf/HzvnO3
        +279DOjVH1P5La11N6Ju8RTLZBIFWnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271--wjlzGryM4OVMnRi6itedA-1; Thu, 24 Feb 2022 06:09:21 -0500
X-MC-Unique: -wjlzGryM4OVMnRi6itedA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A7A6824FA7;
        Thu, 24 Feb 2022 11:09:18 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C310F79A22;
        Thu, 24 Feb 2022 11:09:14 +0000 (UTC)
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
Subject: [PATCH bpf-next v1 3/6] HID: bpf: add hid_{get|set}_data helpers
Date:   Thu, 24 Feb 2022 12:08:25 +0100
Message-Id: <20220224110828.2168231-4-benjamin.tissoires@redhat.com>
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

When we process an incoming HID report, it is common to have to account
for fields that are not aligned in the report. HID is using 2 helpers
hid_field_extract() and implement() to pick up any data at any offset
within the report.

Export those 2 helpers in BPF programs so users can also rely on them.
The second net worth advantage of those helpers is that now we can
fetch data anywhere in the report without knowing at compile time the
location of it. The boundary checks are done in hid-bpf.c, to prevent
a memory leak.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-bpf.c                        | 22 +++++++
 drivers/hid/hid-core.c                       |  4 +-
 include/linux/bpf-hid.h                      |  2 +
 include/linux/hid.h                          |  2 +
 include/uapi/linux/bpf.h                     | 16 +++++
 kernel/bpf/hid.c                             | 68 ++++++++++++++++++++
 tools/include/uapi/linux/bpf.h               | 16 +++++
 tools/testing/selftests/bpf/prog_tests/hid.c | 59 +++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 14 ++++
 9 files changed, 201 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
index 2d54c87cda1a..d775bda9d28d 100644
--- a/drivers/hid/hid-bpf.c
+++ b/drivers/hid/hid-bpf.c
@@ -118,6 +118,26 @@ static void hid_bpf_array_detached(struct hid_device *hdev, enum bpf_hid_attach_
 	}
 }
 
+int hid_bpf_get_data(struct hid_device *hdev, u8 *buf, u64 offset, u8 n)
+{
+	if (n > 32 ||
+	    ((offset + n) >> 3) >= HID_BPF_MAX_BUFFER_SIZE)
+		return 0;
+
+	return hid_field_extract(hdev, buf, offset, n);
+}
+
+int hid_bpf_set_data(struct hid_device *hdev, u8 *buf, u64 offset, u8 n, u32 data)
+{
+	if (n > 32 ||
+	    ((offset + n) >> 3) >= HID_BPF_MAX_BUFFER_SIZE)
+		return -EINVAL;
+
+	implement(hdev, buf, offset, n, data);
+
+	return 0;
+}
+
 static int hid_bpf_run_progs(struct hid_device *hdev, enum bpf_hid_attach_type type,
 			     struct hid_bpf_ctx *ctx, u8 *data, int size)
 {
@@ -229,6 +249,8 @@ int __init hid_bpf_module_init(void)
 		.link_attach = hid_bpf_link_attach,
 		.link_attached = hid_bpf_link_attached,
 		.array_detached = hid_bpf_array_detached,
+		.hid_get_data = hid_bpf_get_data,
+		.hid_set_data = hid_bpf_set_data,
 	};
 
 	bpf_hid_set_hooks(&hooks);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 0eb8189faaee..d3f4499ee4cd 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1416,8 +1416,8 @@ static void __implement(u8 *report, unsigned offset, int n, u32 value)
 	}
 }
 
-static void implement(const struct hid_device *hid, u8 *report,
-		      unsigned offset, unsigned n, u32 value)
+void implement(const struct hid_device *hid, u8 *report, unsigned int offset, unsigned int n,
+	       u32 value)
 {
 	if (unlikely(n > 32)) {
 		hid_warn(hid, "%s() called with n (%d) > 32! (%s)\n",
diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
index 377012a019da..07cbd5cf595c 100644
--- a/include/linux/bpf-hid.h
+++ b/include/linux/bpf-hid.h
@@ -72,6 +72,8 @@ struct bpf_hid_hooks {
 	int (*link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
 	void (*link_attached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
 	void (*array_detached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
+	int (*hid_get_data)(struct hid_device *hdev, u8 *buf, u64 offset, u8 size);
+	int (*hid_set_data)(struct hid_device *hdev, u8 *buf, u64 offset, u8 size, u32 data);
 };
 
 #ifdef CONFIG_BPF
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 66d949d10b78..7454e844324c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -944,6 +944,8 @@ bool hid_compare_device_paths(struct hid_device *hdev_a,
 s32 hid_snto32(__u32 value, unsigned n);
 __u32 hid_field_extract(const struct hid_device *hid, __u8 *report,
 		     unsigned offset, unsigned n);
+void implement(const struct hid_device *hid, u8 *report, unsigned int offset, unsigned int n,
+	       u32 value);
 
 #ifdef CONFIG_PM
 int hid_driver_suspend(struct hid_device *hdev, pm_message_t state);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a7a8d9cfcf24..0571d9b954c9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5090,6 +5090,20 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure. On error
  *		*dst* buffer is zeroed out.
+ *
+ * u32 bpf_hid_get_data(void *ctx, u64 offset, u8 n)
+ *	Description
+ *		Get the data of size n at the given offset in the
+ *		ctx->event.data field
+ *	Return
+ *		The value at offset. In case of error: 0.
+ *
+ * int bpf_hid_set_data(void *ctx, u64 offset, u8 n, u32 data)
+ *	Description
+ *		Set the data of size n at the given offset in the
+ *		ctx->event.data field
+ *	Return
+ *		0 on success, a negative error on failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5284,6 +5298,8 @@ union bpf_attr {
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
 	FN(copy_from_user_task),	\
+	FN(hid_get_data),		\
+	FN(hid_set_data),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
index 47cb0580b14a..9eb7bd6ac6c8 100644
--- a/kernel/bpf/hid.c
+++ b/kernel/bpf/hid.c
@@ -37,10 +37,78 @@ void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks)
 }
 EXPORT_SYMBOL_GPL(bpf_hid_set_hooks);
 
+BPF_CALL_3(bpf_hid_get_data, void*, ctx, u64, offset, u8, n)
+{
+	struct hid_bpf_ctx *bpf_ctx = ctx;
+	u8 *buf;
+
+	if (!hid_hooks.hid_get_data)
+		return -EOPNOTSUPP;
+
+	switch (bpf_ctx->type) {
+	case HID_BPF_DEVICE_EVENT:
+		buf = bpf_ctx->u.device.data;
+		break;
+	case HID_BPF_RDESC_FIXUP:
+		buf = bpf_ctx->u.rdesc.data;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return hid_hooks.hid_get_data(bpf_ctx->hdev, buf, offset, n);
+}
+
+static const struct bpf_func_proto bpf_hid_get_data_proto = {
+	.func      = bpf_hid_get_data,
+	.gpl_only  = true,
+	.ret_type  = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_ANYTHING,
+	.arg3_type = ARG_ANYTHING,
+};
+
+BPF_CALL_4(bpf_hid_set_data, void*, ctx, u64, offset, u8, n, u32, data)
+{
+	struct hid_bpf_ctx *bpf_ctx = ctx;
+	u8 *buf;
+
+	if (!hid_hooks.hid_set_data)
+		return -EOPNOTSUPP;
+
+	switch (bpf_ctx->type) {
+	case HID_BPF_DEVICE_EVENT:
+		buf = bpf_ctx->u.device.data;
+		break;
+	case HID_BPF_RDESC_FIXUP:
+		buf = bpf_ctx->u.rdesc.data;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	hid_hooks.hid_set_data(bpf_ctx->hdev, buf, offset, n, data);
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_hid_set_data_proto = {
+	.func      = bpf_hid_set_data,
+	.gpl_only  = true,
+	.ret_type  = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_ANYTHING,
+	.arg3_type = ARG_ANYTHING,
+	.arg4_type = ARG_ANYTHING,
+};
+
 static const struct bpf_func_proto *
 hid_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
+	case BPF_FUNC_hid_get_data:
+		return &bpf_hid_get_data_proto;
+	case BPF_FUNC_hid_set_data:
+		return &bpf_hid_set_data_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a7a8d9cfcf24..0571d9b954c9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5090,6 +5090,20 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure. On error
  *		*dst* buffer is zeroed out.
+ *
+ * u32 bpf_hid_get_data(void *ctx, u64 offset, u8 n)
+ *	Description
+ *		Get the data of size n at the given offset in the
+ *		ctx->event.data field
+ *	Return
+ *		The value at offset. In case of error: 0.
+ *
+ * int bpf_hid_set_data(void *ctx, u64 offset, u8 n, u32 data)
+ *	Description
+ *		Set the data of size n at the given offset in the
+ *		ctx->event.data field
+ *	Return
+ *		0 on success, a negative error on failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5284,6 +5298,8 @@ union bpf_attr {
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
 	FN(copy_from_user_task),	\
+	FN(hid_get_data),		\
+	FN(hid_set_data),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index dccbbcaa69e5..7d4f740a0a08 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -280,6 +280,62 @@ static int test_hid_raw_event(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
 	return ret;
 }
 
+/*
+ * Attach hid_set_get_data to the given uhid device,
+ * retrieve and open the matching hidraw node,
+ * inject one event in the uhid device,
+ * check that the program makes correct use of bpf_hid_{set|get}_data.
+ */
+static int test_hid_set_get_data(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
+{
+	int err, hidraw_ino, hidraw_fd = -1;
+	char hidraw_path[64] = {0};
+	u8 buf[10] = {0};
+	int ret = -1;
+
+	/* attach hid_set_get_data program */
+	hid_skel->links.hid_set_get_data =
+		bpf_program__attach_hid(hid_skel->progs.hid_set_get_data, sysfs_fd);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_set_get_data,
+			   "attach_hid(hid_set_get_data)"))
+		return PTR_ERR(hid_skel->links.hid_set_get_data);
+
+	hidraw_ino = get_hidraw(hid_skel->links.hid_set_get_data);
+	if (!ASSERT_GE(hidraw_ino, 0, "get_hidraw"))
+		goto cleanup;
+
+	/* open hidraw node to check the other side of the pipe */
+	sprintf(hidraw_path, "/dev/hidraw%d", hidraw_ino);
+	hidraw_fd = open(hidraw_path, O_RDWR | O_NONBLOCK);
+
+	if (!ASSERT_GE(hidraw_fd, 0, "open_hidraw"))
+		goto cleanup;
+
+	/* inject one event */
+	buf[0] = 1;
+	buf[1] = 42;
+	send_event(uhid_fd, buf, 4);
+
+	/* read the data from hidraw */
+	memset(buf, 0, sizeof(buf));
+	err = read(hidraw_fd, buf, sizeof(buf));
+	if (!ASSERT_EQ(err, 4, "read_hidraw"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[2], (42 >> 2), "hid_set_get_data"))
+		goto cleanup;
+
+	ret = 0;
+
+cleanup:
+	if (hidraw_fd >= 0)
+		close(hidraw_fd);
+
+	hid__detach(hid_skel);
+
+	return ret;
+}
+
 /*
  * Attach hid_rdesc_fixup to the given uhid device,
  * retrieve and open the matching hidraw node,
@@ -378,6 +434,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_raw_event(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid");
 
+	err = test_hid_set_get_data(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_set_get_data");
+
 	err = test_rdesc_fixup(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_rdesc_fixup");
 
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index f7a64c637782..01d9c556a3a1 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -66,3 +66,17 @@ int hid_rdesc_fixup(struct hid_bpf_ctx *ctx)
 
 	return 0;
 }
+
+SEC("hid/device_event")
+int hid_set_get_data(struct hid_bpf_ctx *ctx)
+{
+	__u32 x;
+
+	/* extract data at bit offset 10 of size 4 (half a byte) */
+	x = bpf_hid_get_data(ctx, 10, 4);
+
+	/* reinject it */
+	bpf_hid_set_data(ctx, 16, 4, x);
+
+	return 0;
+}
-- 
2.35.1

