Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6504D4C2A57
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbiBXLJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiBXLJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:09:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 055E314FBDB
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 03:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645700960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N3cp1+AUEw8KVSjrTX4gG0oeNe61qbEHhfSUqcT0Biw=;
        b=NWoLE/CLzTSz5vSCf6tNRGRMg4Jd0eOM49RIK3lBG1mTiHFHvhXjbM8SX4NOiEPeOht3Zo
        2k2UFvOjVCIa9ew38VCmPzTUTeCdE04VKWna3N7a7tMOHF/A8p5Kr/fxPvbvuxjTZJWIFM
        GaM3e5zxvCBqtEhLzGoBo2QHVV/cP8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-aqdgt50QOw2APlfdXy7NtA-1; Thu, 24 Feb 2022 06:09:16 -0500
X-MC-Unique: aqdgt50QOw2APlfdXy7NtA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 725E41006AA5;
        Thu, 24 Feb 2022 11:09:14 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C44C79A22;
        Thu, 24 Feb 2022 11:08:58 +0000 (UTC)
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
Subject: [PATCH bpf-next v1 2/6] HID: bpf: allow to change the report descriptor from an eBPF program
Date:   Thu, 24 Feb 2022 12:08:24 +0100
Message-Id: <20220224110828.2168231-3-benjamin.tissoires@redhat.com>
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

The report descriptor is the dictionary of the HID protocol specific
to the given device.
Changing it is a common habit in the HID world, and making that feature
accessible from eBPF allows to fix devices without having to install a
new kernel.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-bpf.c                        | 66 +++++++++++++++++++
 drivers/hid/hid-core.c                       |  3 +-
 include/linux/bpf-hid.h                      |  4 ++
 include/linux/hid.h                          |  6 ++
 include/uapi/linux/bpf.h                     |  1 +
 include/uapi/linux/bpf_hid.h                 |  8 +++
 kernel/bpf/hid.c                             |  5 ++
 kernel/bpf/syscall.c                         |  2 +
 samples/bpf/hid_mouse_kern.c                 | 25 +++++++
 tools/include/uapi/linux/bpf.h               |  1 +
 tools/lib/bpf/libbpf.c                       |  1 +
 tools/testing/selftests/bpf/prog_tests/hid.c | 69 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 48 ++++++++++++++
 13 files changed, 238 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
index 6c8445820944..2d54c87cda1a 100644
--- a/drivers/hid/hid-bpf.c
+++ b/drivers/hid/hid-bpf.c
@@ -63,6 +63,14 @@ static struct hid_bpf_ctx *hid_bpf_allocate_ctx(struct hid_device *hdev)
 	return ctx;
 }
 
+static int hid_reconnect(struct hid_device *hdev)
+{
+	if (!test_and_set_bit(ffs(HID_STAT_REPROBED), &hdev->status))
+		return device_reprobe(&hdev->dev);
+
+	return 0;
+}
+
 static int hid_bpf_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
 {
 	int err = 0;
@@ -84,6 +92,17 @@ static int hid_bpf_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type
 	return err;
 }
 
+static void hid_bpf_link_attached(struct hid_device *hdev, enum bpf_hid_attach_type type)
+{
+	switch (type) {
+	case BPF_HID_ATTACH_RDESC_FIXUP:
+		hid_reconnect(hdev);
+		break;
+	default:
+		/* do nothing */
+	}
+}
+
 static void hid_bpf_array_detached(struct hid_device *hdev, enum bpf_hid_attach_type type)
 {
 	switch (type) {
@@ -91,6 +110,9 @@ static void hid_bpf_array_detached(struct hid_device *hdev, enum bpf_hid_attach_
 		kfree(hdev->bpf.ctx);
 		hdev->bpf.ctx = NULL;
 		break;
+	case BPF_HID_ATTACH_RDESC_FIXUP:
+		hid_reconnect(hdev);
+		break;
 	default:
 		/* do nothing */
 	}
@@ -110,6 +132,11 @@ static int hid_bpf_run_progs(struct hid_device *hdev, enum bpf_hid_attach_type t
 		if (size > sizeof(ctx->u.device.data))
 			return -E2BIG;
 		break;
+	case BPF_HID_ATTACH_RDESC_FIXUP:
+		event = HID_BPF_RDESC_FIXUP;
+		if (size > sizeof(ctx->u.rdesc.data))
+			return -E2BIG;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -127,6 +154,10 @@ static int hid_bpf_run_progs(struct hid_device *hdev, enum bpf_hid_attach_type t
 			memcpy(ctx->u.device.data, data, size);
 			ctx->u.device.size = size;
 			break;
+		case HID_BPF_RDESC_FIXUP:
+			memcpy(ctx->u.rdesc.data, data, size);
+			ctx->u.device.size = size;
+			break;
 		default:
 			/* do nothing */
 		}
@@ -157,11 +188,46 @@ u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *data, int *size)
 	return hdev->bpf.ctx->u.device.data;
 }
 
+u8 *hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size)
+{
+	struct hid_bpf_ctx *ctx = NULL;
+	int ret;
+
+	if (bpf_hid_link_empty(&hdev->bpf, BPF_HID_ATTACH_RDESC_FIXUP))
+		goto ignore_bpf;
+
+	ctx = hid_bpf_allocate_ctx(hdev);
+	if (IS_ERR(ctx))
+		goto ignore_bpf;
+
+	ret = hid_bpf_run_progs(hdev, BPF_HID_ATTACH_RDESC_FIXUP, ctx, rdesc, *size);
+	if (ret)
+		goto ignore_bpf;
+
+	*size = ctx->u.rdesc.size;
+
+	if (!*size) {
+		rdesc = NULL;
+		goto unlock;
+	}
+
+	rdesc = kmemdup(ctx->u.rdesc.data, *size, GFP_KERNEL);
+
+ unlock:
+	kfree(ctx);
+	return rdesc;
+
+ ignore_bpf:
+	kfree(ctx);
+	return kmemdup(rdesc, *size, GFP_KERNEL);
+}
+
 int __init hid_bpf_module_init(void)
 {
 	struct bpf_hid_hooks hooks = {
 		.hdev_from_fd = hid_bpf_fd_to_hdev,
 		.link_attach = hid_bpf_link_attach,
+		.link_attached = hid_bpf_link_attached,
 		.array_detached = hid_bpf_array_detached,
 	};
 
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a80bffe6ce4a..0eb8189faaee 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1213,7 +1213,8 @@ int hid_open_report(struct hid_device *device)
 		return -ENODEV;
 	size = device->dev_rsize;
 
-	buf = kmemdup(start, size, GFP_KERNEL);
+	/* hid_bpf_report_fixup() ensures we work on a copy of rdesc */
+	buf = hid_bpf_report_fixup(device, start, &size);
 	if (buf == NULL)
 		return -ENOMEM;
 
diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
index 363fb6a4923f..377012a019da 100644
--- a/include/linux/bpf-hid.h
+++ b/include/linux/bpf-hid.h
@@ -14,6 +14,7 @@ struct hid_device;
 enum bpf_hid_attach_type {
 	BPF_HID_ATTACH_INVALID = -1,
 	BPF_HID_ATTACH_DEVICE_EVENT = 0,
+	BPF_HID_ATTACH_RDESC_FIXUP,
 	MAX_BPF_HID_ATTACH_TYPE
 };
 
@@ -31,6 +32,8 @@ to_bpf_hid_attach_type(enum bpf_attach_type attach_type)
 	switch (attach_type) {
 	case BPF_HID_DEVICE_EVENT:
 		return BPF_HID_ATTACH_DEVICE_EVENT;
+	case BPF_HID_RDESC_FIXUP:
+		return BPF_HID_ATTACH_RDESC_FIXUP;
 	default:
 		return BPF_HID_ATTACH_INVALID;
 	}
@@ -67,6 +70,7 @@ static inline bool bpf_hid_link_empty(struct bpf_hid *bpf,
 struct bpf_hid_hooks {
 	struct hid_device *(*hdev_from_fd)(int fd);
 	int (*link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
+	void (*link_attached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
 	void (*array_detached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
 };
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 8fd79011f461..66d949d10b78 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1213,10 +1213,16 @@ do {									\
 
 #ifdef CONFIG_BPF
 u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *rd, int *size);
+u8 *hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size);
 int hid_bpf_module_init(void);
 void hid_bpf_module_exit(void);
 #else
 static inline u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *rd, int *size) { return rd; }
+static inline u8 *hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc,
+				       unsigned int *size)
+{
+	return kmemdup(rdesc, *size, GFP_KERNEL);
+}
 static inline int hid_bpf_module_init(void) { return 0; }
 static inline void hid_bpf_module_exit(void) {}
 #endif
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 5978b92cacd3..a7a8d9cfcf24 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -999,6 +999,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
 	BPF_HID_DEVICE_EVENT,
+	BPF_HID_RDESC_FIXUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/include/uapi/linux/bpf_hid.h b/include/uapi/linux/bpf_hid.h
index 243ac45a253f..c0801d7174c3 100644
--- a/include/uapi/linux/bpf_hid.h
+++ b/include/uapi/linux/bpf_hid.h
@@ -18,6 +18,7 @@ struct hid_device;
 enum hid_bpf_event {
 	HID_BPF_UNDEF = 0,
 	HID_BPF_DEVICE_EVENT,
+	HID_BPF_RDESC_FIXUP,
 };
 
 /* type is HID_BPF_DEVICE_EVENT */
@@ -26,12 +27,19 @@ struct hid_bpf_ctx_device_event {
 	unsigned long size;
 };
 
+/* type is HID_BPF_RDESC_FIXUP */
+struct hid_bpf_ctx_rdesc_fixup {
+	__u8 data[HID_BPF_MAX_BUFFER_SIZE];
+	unsigned long size;
+};
+
 struct hid_bpf_ctx {
 	enum hid_bpf_event type;
 	struct hid_device *hdev;
 
 	union {
 		struct hid_bpf_ctx_device_event device;
+		struct hid_bpf_ctx_rdesc_fixup rdesc;
 	} u;
 };
 
diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
index d3cb952bfc26..47cb0580b14a 100644
--- a/kernel/bpf/hid.c
+++ b/kernel/bpf/hid.c
@@ -315,6 +315,8 @@ static int bpf_hid_max_progs(enum bpf_hid_attach_type type)
 	switch (type) {
 	case BPF_HID_ATTACH_DEVICE_EVENT:
 		return 64;
+	case BPF_HID_ATTACH_RDESC_FIXUP:
+		return 1;
 	default:
 		return 0;
 	}
@@ -355,6 +357,9 @@ static int bpf_hid_link_attach(struct hid_device *hdev, struct bpf_link *link,
 					lockdep_is_held(&bpf_hid_mutex));
 	bpf_prog_array_free(run_array);
 
+	if (hid_hooks.link_attached)
+		hid_hooks.link_attached(hdev, type);
+
 out_unlock:
 	mutex_unlock(&bpf_hid_mutex);
 	return err;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 230ca6964a7e..62889cc71a02 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3191,6 +3191,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_XDP:
 		return BPF_PROG_TYPE_XDP;
 	case BPF_HID_DEVICE_EVENT:
+	case BPF_HID_RDESC_FIXUP:
 		return BPF_PROG_TYPE_HID;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
@@ -3336,6 +3337,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_SK_SKB_VERDICT:
 		return sock_map_bpf_prog_query(attr, uattr);
 	case BPF_HID_DEVICE_EVENT:
+	case BPF_HID_RDESC_FIXUP:
 		return bpf_hid_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
diff --git a/samples/bpf/hid_mouse_kern.c b/samples/bpf/hid_mouse_kern.c
index 83b0ab5a04d0..b4fac1c8bf6e 100644
--- a/samples/bpf/hid_mouse_kern.c
+++ b/samples/bpf/hid_mouse_kern.c
@@ -62,5 +62,30 @@ int hid_x_event(struct hid_bpf_ctx *ctx)
 	return 0;
 }
 
+SEC("hid/rdesc_fixup")
+int hid_rdesc_fixup(struct hid_bpf_ctx *ctx)
+{
+	if (ctx->type != HID_BPF_RDESC_FIXUP)
+		return 0;
+
+	bpf_printk("rdesc: %02x %02x %02x",
+		   ctx->u.rdesc.data[0],
+		   ctx->u.rdesc.data[1],
+		   ctx->u.rdesc.data[2]);
+	bpf_printk("       %02x %02x %02x",
+		   ctx->u.rdesc.data[3],
+		   ctx->u.rdesc.data[4],
+		   ctx->u.rdesc.data[5]);
+	bpf_printk("       %02x %02x %02x ...",
+		   ctx->u.rdesc.data[6],
+		   ctx->u.rdesc.data[7],
+		   ctx->u.rdesc.data[8]);
+
+	ctx->u.rdesc.data[39] = 0x31;
+	ctx->u.rdesc.data[41] = 0x30;
+
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
 u32 _version SEC("version") = LINUX_VERSION_CODE;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5978b92cacd3..a7a8d9cfcf24 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -999,6 +999,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
 	BPF_HID_DEVICE_EVENT,
+	BPF_HID_RDESC_FIXUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index bad16e85032e..b7af873116fb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8677,6 +8677,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("struct_ops+",		STRUCT_OPS, 0, SEC_NONE),
 	SEC_DEF("sk_lookup",		SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("hid/device_event",	HID, BPF_HID_DEVICE_EVENT, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
+	SEC_DEF("hid/rdesc_fixup",	HID, BPF_HID_RDESC_FIXUP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 };
 
 #define MAX_TYPE_NAME_SIZE 32
diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index 692d78b9dc4a..dccbbcaa69e5 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -9,6 +9,7 @@
 #include <dirent.h>
 #include <poll.h>
 #include <stdbool.h>
+#include <linux/hidraw.h>
 #include <linux/uhid.h>
 
 static unsigned char rdesc[] = {
@@ -279,6 +280,71 @@ static int test_hid_raw_event(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
 	return ret;
 }
 
+/*
+ * Attach hid_rdesc_fixup to the given uhid device,
+ * retrieve and open the matching hidraw node,
+ * check that the hidraw report descriptor has been updated.
+ */
+static int test_rdesc_fixup(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
+{
+	struct hidraw_report_descriptor rpt_desc = {0};
+	int err, desc_size, hidraw_ino, hidraw_fd = -1;
+	char hidraw_path[64] = {0};
+	int ret = -1;
+
+	/* attach the program */
+	hid_skel->links.hid_rdesc_fixup =
+		bpf_program__attach_hid(hid_skel->progs.hid_rdesc_fixup, sysfs_fd);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_rdesc_fixup,
+			   "attach_hid(hid_rdesc_fixup)"))
+		return PTR_ERR(hid_skel->links.hid_rdesc_fixup);
+
+	/* give a little bit of time for the device to appear */
+	/* TODO: check on uhid events */
+	usleep(1000);
+
+	hidraw_ino = get_hidraw(hid_skel->links.hid_rdesc_fixup);
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
+	/* check that hid_rdesc_fixup() was executed */
+	ASSERT_EQ(hid_skel->data->callback2_check, 0x21, "callback_check2");
+
+	/* read the exposed report descriptor from hidraw */
+	err = ioctl(hidraw_fd, HIDIOCGRDESCSIZE, &desc_size);
+	if (!ASSERT_GE(err, 0, "HIDIOCGRDESCSIZE"))
+		goto cleanup;
+
+	/* ensure the new size of the rdesc is bigger than the old one */
+	if (!ASSERT_GT(desc_size, sizeof(rdesc), "new_rdesc_size"))
+		goto cleanup;
+
+	rpt_desc.size = desc_size;
+	err = ioctl(hidraw_fd, HIDIOCGRDESC, &rpt_desc);
+	if (!ASSERT_GE(err, 0, "HIDIOCGRDESC"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(rpt_desc.value[4], 0x42, "hid_rdesc_fixup"))
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
 void serial_test_hid_bpf(void)
 {
 	struct hid *hid_skel = NULL;
@@ -312,6 +378,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_raw_event(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid");
 
+	err = test_rdesc_fixup(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_rdesc_fixup");
+
 cleanup:
 	hid__destroy(hid_skel);
 	destroy(uhid_fd);
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index f28bb6007875..f7a64c637782 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -18,3 +18,51 @@ int hid_first_event(struct hid_bpf_ctx *ctx)
 
 	return 0;
 }
+
+static __u8 rdesc[] = {
+	0x05, 0x01,				/* USAGE_PAGE (Generic Desktop) */
+	0x09, 0x32,				/* USAGE (Z) */
+	0x95, 0x01,				/* REPORT_COUNT (1) */
+	0x81, 0x06,				/* INPUT (Data,Var,Rel) */
+
+	0x06, 0x00, 0xff,			/* Usage Page (Vendor Defined Page 1) */
+	0x19, 0x01,				/* USAGE_MINIMUM (1) */
+	0x29, 0x03,				/* USAGE_MAXIMUM (3) */
+	0x15, 0x00,				/* LOGICAL_MINIMUM (0) */
+	0x25, 0x01,				/* LOGICAL_MAXIMUM (1) */
+	0x95, 0x03,				/* REPORT_COUNT (3) */
+	0x75, 0x01,				/* REPORT_SIZE (1) */
+	0x91, 0x02,				/* Output (Data,Var,Abs) */
+	0x95, 0x01,				/* REPORT_COUNT (1) */
+	0x75, 0x05,				/* REPORT_SIZE (5) */
+	0x91, 0x01,				/* Output (Cnst,Var,Abs) */
+
+	0x06, 0x00, 0xff,			/* Usage Page (Vendor Defined Page 1) */
+	0x19, 0x06,				/* USAGE_MINIMUM (6) */
+	0x29, 0x08,				/* USAGE_MAXIMUM (8) */
+	0x15, 0x00,				/* LOGICAL_MINIMUM (0) */
+	0x25, 0x01,				/* LOGICAL_MAXIMUM (1) */
+	0x95, 0x03,				/* REPORT_COUNT (3) */
+	0x75, 0x01,				/* REPORT_SIZE (1) */
+	0xb1, 0x02,				/* Feature (Data,Var,Abs) */
+	0x95, 0x01,				/* REPORT_COUNT (1) */
+	0x75, 0x05,				/* REPORT_SIZE (5) */
+	0x91, 0x01,				/* Output (Cnst,Var,Abs) */
+
+	0xc0,				/* END_COLLECTION */
+	0xc0,			/* END_COLLECTION */
+};
+
+SEC("hid/rdesc_fixup")
+int hid_rdesc_fixup(struct hid_bpf_ctx *ctx)
+{
+	callback2_check = ctx->u.rdesc.data[4];
+
+	/* insert rdesc at offset 52 */
+	__builtin_memcpy(&ctx->u.rdesc.data[52], rdesc, sizeof(rdesc));
+	ctx->u.rdesc.size = sizeof(rdesc) + 52;
+
+	ctx->u.rdesc.data[4] = 0x42;
+
+	return 0;
+}
-- 
2.35.1

