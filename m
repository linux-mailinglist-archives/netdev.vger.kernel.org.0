Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7D84C2A5C
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiBXLJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiBXLJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:09:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 050BF14893C
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 03:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645700944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pdCtIwX6TvapsyaeSBYuI4Jikta/5NiEYvF5VaQm/IM=;
        b=Zh7t9Br2wRqDoIuA3NYvQ8RXllw3sCPRM2lJTt0hf+oWN7jyPBMmpWpzTDv9UdMVCd8cO5
        xu8S9LcwZzWcE8gBCNfxlLEgH4w8UHvvsRObZZ5FPZO22lSv6R1hyDLa9lnfByguyKUdfG
        6na/YYb6Wtn9M2+INMulhXeKAKH81bI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-3LfxZROOPUWCd5Cv48yiqg-1; Thu, 24 Feb 2022 06:09:00 -0500
X-MC-Unique: 3LfxZROOPUWCd5Cv48yiqg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C01B824FA7;
        Thu, 24 Feb 2022 11:08:58 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A342079A22;
        Thu, 24 Feb 2022 11:08:47 +0000 (UTC)
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
Subject: [PATCH bpf-next v1 1/6] HID: initial BPF implementation
Date:   Thu, 24 Feb 2022 12:08:23 +0100
Message-Id: <20220224110828.2168231-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HID is a protocol that could benefit from using BPF too.

This patch implements a net-like use of BPF capability for HID.
Any incoming report coming from the device gets injected into a series
of BPF programs that can modify it or even discard it by setting the
size in the context to 0.

The kernel/bpf implementation is based on net-namespace.c, with only
the bpf_link part kept, there is no real points in keeping the
bpf_prog_{attach|detach} API.

The implementation is split into 2 parts:
- the kernel/bpf part which isn't aware of the HID usage, but takes care
  of handling the BPF links
- the drivers/hid/hid-bpf.c part which knows about HID

Note that HID can be compiled in as a module, and so the functions that
kernel/bpf/hid.c needs to call in hid.ko are exported in struct hid_hooks.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/Makefile                         |   1 +
 drivers/hid/hid-bpf.c                        | 176 ++++++++
 drivers/hid/hid-core.c                       |  21 +-
 include/linux/bpf-hid.h                      |  87 ++++
 include/linux/bpf_types.h                    |   4 +
 include/linux/hid.h                          |  16 +
 include/uapi/linux/bpf.h                     |   7 +
 include/uapi/linux/bpf_hid.h                 |  39 ++
 kernel/bpf/Makefile                          |   3 +
 kernel/bpf/hid.c                             | 437 +++++++++++++++++++
 kernel/bpf/syscall.c                         |   8 +
 samples/bpf/.gitignore                       |   1 +
 samples/bpf/Makefile                         |   4 +
 samples/bpf/hid_mouse_kern.c                 |  66 +++
 samples/bpf/hid_mouse_user.c                 | 129 ++++++
 tools/include/uapi/linux/bpf.h               |   7 +
 tools/lib/bpf/libbpf.c                       |   7 +
 tools/lib/bpf/libbpf.h                       |   2 +
 tools/lib/bpf/libbpf.map                     |   1 +
 tools/testing/selftests/bpf/prog_tests/hid.c | 318 ++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      |  20 +
 21 files changed, 1351 insertions(+), 3 deletions(-)
 create mode 100644 drivers/hid/hid-bpf.c
 create mode 100644 include/linux/bpf-hid.h
 create mode 100644 include/uapi/linux/bpf_hid.h
 create mode 100644 kernel/bpf/hid.c
 create mode 100644 samples/bpf/hid_mouse_kern.c
 create mode 100644 samples/bpf/hid_mouse_user.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
 create mode 100644 tools/testing/selftests/bpf/progs/hid.c

diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 6d3e630e81af..08d2d7619937 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -4,6 +4,7 @@
 #
 hid-y			:= hid-core.o hid-input.o hid-quirks.o
 hid-$(CONFIG_DEBUG_FS)		+= hid-debug.o
+hid-$(CONFIG_BPF)		+= hid-bpf.o
 
 obj-$(CONFIG_HID)		+= hid.o
 obj-$(CONFIG_UHID)		+= uhid.o
diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
new file mode 100644
index 000000000000..6c8445820944
--- /dev/null
+++ b/drivers/hid/hid-bpf.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *  BPF in HID support for Linux
+ *
+ *  Copyright (c) 2021 Benjamin Tissoires
+ */
+
+#include <linux/filter.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#include <uapi/linux/bpf_hid.h>
+#include <linux/hid.h>
+
+static int __hid_bpf_match_sysfs(struct device *dev, const void *data)
+{
+	struct kernfs_node *kn = dev->kobj.sd;
+	struct kernfs_node *uevent_kn;
+
+	uevent_kn = kernfs_find_and_get_ns(kn, "uevent", NULL);
+
+	return uevent_kn == data;
+}
+
+static struct hid_device *hid_bpf_fd_to_hdev(int fd)
+{
+	struct device *dev;
+	struct hid_device *hdev;
+	struct fd f = fdget(fd);
+	struct inode *inode;
+	struct kernfs_node *node;
+
+	if (!f.file) {
+		hdev = ERR_PTR(-EBADF);
+		goto out;
+	}
+
+	inode = file_inode(f.file);
+	node = inode->i_private;
+
+	dev = bus_find_device(&hid_bus_type, NULL, node, __hid_bpf_match_sysfs);
+
+	if (dev)
+		hdev = to_hid_device(dev);
+	else
+		hdev = ERR_PTR(-EINVAL);
+
+ out:
+	fdput(f);
+	return hdev;
+}
+
+static struct hid_bpf_ctx *hid_bpf_allocate_ctx(struct hid_device *hdev)
+{
+	struct hid_bpf_ctx *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ctx->hdev = hdev;
+
+	return ctx;
+}
+
+static int hid_bpf_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
+{
+	int err = 0;
+
+	switch (type) {
+	case BPF_HID_ATTACH_DEVICE_EVENT:
+		if (!hdev->bpf.ctx) {
+			hdev->bpf.ctx = hid_bpf_allocate_ctx(hdev);
+			if (IS_ERR(hdev->bpf.ctx)) {
+				err = PTR_ERR(hdev->bpf.ctx);
+				hdev->bpf.ctx = NULL;
+			}
+		}
+		break;
+	default:
+		/* do nothing */
+	}
+
+	return err;
+}
+
+static void hid_bpf_array_detached(struct hid_device *hdev, enum bpf_hid_attach_type type)
+{
+	switch (type) {
+	case BPF_HID_ATTACH_DEVICE_EVENT:
+		kfree(hdev->bpf.ctx);
+		hdev->bpf.ctx = NULL;
+		break;
+	default:
+		/* do nothing */
+	}
+}
+
+static int hid_bpf_run_progs(struct hid_device *hdev, enum bpf_hid_attach_type type,
+			     struct hid_bpf_ctx *ctx, u8 *data, int size)
+{
+	enum hid_bpf_event event = HID_BPF_UNDEF;
+
+	if (type < 0 || !ctx)
+		return -EINVAL;
+
+	switch (type) {
+	case BPF_HID_ATTACH_DEVICE_EVENT:
+		event = HID_BPF_DEVICE_EVENT;
+		if (size > sizeof(ctx->u.device.data))
+			return -E2BIG;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!hdev->bpf.run_array[type])
+		return 0;
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->hdev = hdev;
+	ctx->type = event;
+
+	if (size && data) {
+		switch (event) {
+		case HID_BPF_DEVICE_EVENT:
+			memcpy(ctx->u.device.data, data, size);
+			ctx->u.device.size = size;
+			break;
+		default:
+			/* do nothing */
+		}
+	}
+
+	BPF_PROG_RUN_ARRAY(hdev->bpf.run_array[type], ctx, bpf_prog_run);
+
+	return 0;
+}
+
+u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *data, int *size)
+{
+	int ret;
+
+	if (bpf_hid_link_empty(&hdev->bpf, BPF_HID_ATTACH_DEVICE_EVENT))
+		return data;
+
+	ret = hid_bpf_run_progs(hdev, BPF_HID_ATTACH_DEVICE_EVENT,
+				hdev->bpf.ctx, data, *size);
+	if (ret)
+		return data;
+
+	if (!hdev->bpf.ctx->u.device.size)
+		return ERR_PTR(-EINVAL);
+
+	*size = hdev->bpf.ctx->u.device.size;
+
+	return hdev->bpf.ctx->u.device.data;
+}
+
+int __init hid_bpf_module_init(void)
+{
+	struct bpf_hid_hooks hooks = {
+		.hdev_from_fd = hid_bpf_fd_to_hdev,
+		.link_attach = hid_bpf_link_attach,
+		.array_detached = hid_bpf_array_detached,
+	};
+
+	bpf_hid_set_hooks(&hooks);
+
+	return 0;
+}
+
+void __exit hid_bpf_module_exit(void)
+{
+	bpf_hid_set_hooks(NULL);
+}
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f1aed5bbd000..a80bffe6ce4a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1748,13 +1748,21 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
 	struct hid_driver *hdrv;
 	unsigned int a;
 	u32 rsize, csize = size;
-	u8 *cdata = data;
+	u8 *cdata;
 	int ret = 0;
 
+	data = hid_bpf_raw_event(hid, data, &size);
+	if (IS_ERR(data)) {
+		ret = PTR_ERR(data);
+		goto out;
+	}
+
 	report = hid_get_report(report_enum, data);
 	if (!report)
 		goto out;
 
+	cdata = data;
+
 	if (report_enum->numbered) {
 		cdata++;
 		csize--;
@@ -2528,10 +2536,12 @@ int hid_add_device(struct hid_device *hdev)
 
 	hid_debug_register(hdev, dev_name(&hdev->dev));
 	ret = device_add(&hdev->dev);
-	if (!ret)
+	if (!ret) {
 		hdev->status |= HID_STAT_ADDED;
-	else
+	} else {
 		hid_debug_unregister(hdev);
+		bpf_hid_exit(hdev);
+	}
 
 	return ret;
 }
@@ -2567,6 +2577,7 @@ struct hid_device *hid_allocate_device(void)
 	spin_lock_init(&hdev->debug_list_lock);
 	sema_init(&hdev->driver_input_lock, 1);
 	mutex_init(&hdev->ll_open_lock);
+	bpf_hid_init(hdev);
 
 	return hdev;
 }
@@ -2574,6 +2585,7 @@ EXPORT_SYMBOL_GPL(hid_allocate_device);
 
 static void hid_remove_device(struct hid_device *hdev)
 {
+	bpf_hid_exit(hdev);
 	if (hdev->status & HID_STAT_ADDED) {
 		device_del(&hdev->dev);
 		hid_debug_unregister(hdev);
@@ -2700,6 +2712,8 @@ static int __init hid_init(void)
 
 	hid_debug_init();
 
+	hid_bpf_module_init();
+
 	return 0;
 err_bus:
 	bus_unregister(&hid_bus_type);
@@ -2709,6 +2723,7 @@ static int __init hid_init(void)
 
 static void __exit hid_exit(void)
 {
+	hid_bpf_module_exit();
 	hid_debug_exit();
 	hidraw_exit();
 	bus_unregister(&hid_bus_type);
diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
new file mode 100644
index 000000000000..363fb6a4923f
--- /dev/null
+++ b/include/linux/bpf-hid.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BPF_HID_H
+#define _BPF_HID_H
+
+#include <linux/mutex.h>
+#include <uapi/linux/bpf.h>
+#include <uapi/linux/bpf_hid.h>
+#include <linux/list.h>
+
+struct bpf_prog;
+struct bpf_prog_array;
+struct hid_device;
+
+enum bpf_hid_attach_type {
+	BPF_HID_ATTACH_INVALID = -1,
+	BPF_HID_ATTACH_DEVICE_EVENT = 0,
+	MAX_BPF_HID_ATTACH_TYPE
+};
+
+struct bpf_hid {
+	struct hid_bpf_ctx *ctx;
+
+	/* Array of programs to run compiled from links */
+	struct bpf_prog_array __rcu *run_array[MAX_BPF_HID_ATTACH_TYPE];
+	struct list_head links[MAX_BPF_HID_ATTACH_TYPE];
+};
+
+static inline enum bpf_hid_attach_type
+to_bpf_hid_attach_type(enum bpf_attach_type attach_type)
+{
+	switch (attach_type) {
+	case BPF_HID_DEVICE_EVENT:
+		return BPF_HID_ATTACH_DEVICE_EVENT;
+	default:
+		return BPF_HID_ATTACH_INVALID;
+	}
+}
+
+union bpf_attr;
+struct bpf_prog;
+
+#if IS_ENABLED(CONFIG_HID)
+int bpf_hid_prog_query(const union bpf_attr *attr,
+		       union bpf_attr __user *uattr);
+int bpf_hid_link_create(const union bpf_attr *attr,
+			struct bpf_prog *prog);
+#else
+static inline int bpf_hid_prog_query(const union bpf_attr *attr,
+				     union bpf_attr __user *uattr)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int bpf_hid_link_create(const union bpf_attr *attr,
+				      struct bpf_prog *prog)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+static inline bool bpf_hid_link_empty(struct bpf_hid *bpf,
+				      enum bpf_hid_attach_type type)
+{
+	return list_empty(&bpf->links[type]);
+}
+
+struct bpf_hid_hooks {
+	struct hid_device *(*hdev_from_fd)(int fd);
+	int (*link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
+	void (*array_detached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
+};
+
+#ifdef CONFIG_BPF
+int bpf_hid_init(struct hid_device *hdev);
+void bpf_hid_exit(struct hid_device *hdev);
+void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks);
+#else
+static inline int bpf_hid_init(struct hid_device *hdev)
+{
+	return 0;
+}
+
+static inline void bpf_hid_exit(struct hid_device *hdev) {}
+static inline void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks) {}
+#endif
+
+#endif /* _BPF_HID_H */
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 48a91c51c015..1509862aacc4 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -76,6 +76,10 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_EXT, bpf_extension,
 BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
 	       void *, void *)
 #endif /* CONFIG_BPF_LSM */
+#if IS_ENABLED(CONFIG_HID)
+BPF_PROG_TYPE(BPF_PROG_TYPE_HID, hid,
+	      __u32, u32)
+#endif
 #endif
 BPF_PROG_TYPE(BPF_PROG_TYPE_SYSCALL, bpf_syscall,
 	      void *, void *)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 7487b0586fe6..8fd79011f461 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -15,6 +15,7 @@
 
 
 #include <linux/bitops.h>
+#include <linux/bpf-hid.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/list.h>
@@ -26,6 +27,7 @@
 #include <linux/mutex.h>
 #include <linux/power_supply.h>
 #include <uapi/linux/hid.h>
+#include <uapi/linux/bpf_hid.h>
 
 /*
  * We parse each description item into this structure. Short items data
@@ -639,6 +641,10 @@ struct hid_device {							/* device report descriptor */
 	struct list_head debug_list;
 	spinlock_t  debug_list_lock;
 	wait_queue_head_t debug_wait;
+
+#ifdef CONFIG_BPF
+	struct bpf_hid bpf;
+#endif
 };
 
 #define to_hid_device(pdev) \
@@ -1205,4 +1211,14 @@ do {									\
 #define hid_dbg_once(hid, fmt, ...)			\
 	dev_dbg_once(&(hid)->dev, fmt, ##__VA_ARGS__)
 
+#ifdef CONFIG_BPF
+u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *rd, int *size);
+int hid_bpf_module_init(void);
+void hid_bpf_module_exit(void);
+#else
+static inline u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *rd, int *size) { return rd; }
+static inline int hid_bpf_module_init(void) { return 0; }
+static inline void hid_bpf_module_exit(void) {}
+#endif
+
 #endif
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index afe3d0d7f5f2..5978b92cacd3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -952,6 +952,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_HID,
 };
 
 enum bpf_attach_type {
@@ -997,6 +998,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_HID_DEVICE_EVENT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1011,6 +1013,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_HID = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -5870,6 +5873,10 @@ struct bpf_link_info {
 		struct {
 			__u32 ifindex;
 		} xdp;
+		struct  {
+			__s32 hidraw_ino;
+			__u32 attach_type;
+		} hid;
 	};
 } __attribute__((aligned(8)));
 
diff --git a/include/uapi/linux/bpf_hid.h b/include/uapi/linux/bpf_hid.h
new file mode 100644
index 000000000000..243ac45a253f
--- /dev/null
+++ b/include/uapi/linux/bpf_hid.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later WITH Linux-syscall-note */
+
+/*
+ *  HID BPF public headers
+ *
+ *  Copyright (c) 2021 Benjamin Tissoires
+ */
+
+#ifndef _UAPI__LINUX_BPF_HID_H__
+#define _UAPI__LINUX_BPF_HID_H__
+
+#include <linux/types.h>
+
+#define HID_BPF_MAX_BUFFER_SIZE		16384		/* 16kb */
+
+struct hid_device;
+
+enum hid_bpf_event {
+	HID_BPF_UNDEF = 0,
+	HID_BPF_DEVICE_EVENT,
+};
+
+/* type is HID_BPF_DEVICE_EVENT */
+struct hid_bpf_ctx_device_event {
+	__u8 data[HID_BPF_MAX_BUFFER_SIZE];
+	unsigned long size;
+};
+
+struct hid_bpf_ctx {
+	enum hid_bpf_event type;
+	struct hid_device *hdev;
+
+	union {
+		struct hid_bpf_ctx_device_event device;
+	} u;
+};
+
+#endif /* _UAPI__LINUX_BPF_HID_H__ */
+
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index c1a9be6a4b9f..8d5619d3d7e5 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -35,6 +35,9 @@ ifeq ($(CONFIG_BPF_JIT),y)
 obj-$(CONFIG_BPF_SYSCALL) += bpf_struct_ops.o
 obj-${CONFIG_BPF_LSM} += bpf_lsm.o
 endif
+ifneq ($(CONFIG_HID),)
+obj-$(CONFIG_BPF_SYSCALL) += hid.o
+endif
 obj-$(CONFIG_BPF_PRELOAD) += preload/
 
 obj-$(CONFIG_BPF_SYSCALL) += relo_core.o
diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
new file mode 100644
index 000000000000..d3cb952bfc26
--- /dev/null
+++ b/kernel/bpf/hid.c
@@ -0,0 +1,437 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * based on kernel/bpf/net-namespace.c
+ */
+
+#include <linux/bpf.h>
+#include <linux/bpf-hid.h>
+#include <linux/filter.h>
+#include <linux/hid.h>
+#include <linux/hidraw.h>
+
+/*
+ * Functions to manage BPF programs attached to hid
+ */
+
+struct bpf_hid_link {
+	struct bpf_link link;
+	enum bpf_attach_type type;
+	enum bpf_hid_attach_type hid_type;
+
+	/* Must be accessed with bpf_hid_mutex held. */
+	struct hid_device *hdev;
+	struct list_head node; /* node in list of links attached to hid */
+};
+
+/* Protects updates to bpf_hid */
+DEFINE_MUTEX(bpf_hid_mutex);
+
+static struct bpf_hid_hooks hid_hooks = {0};
+
+void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks)
+{
+	if (hooks)
+		hid_hooks = *hooks;
+	else
+		memset(&hid_hooks, 0, sizeof(hid_hooks));
+}
+EXPORT_SYMBOL_GPL(bpf_hid_set_hooks);
+
+static const struct bpf_func_proto *
+hid_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	default:
+		return bpf_base_func_proto(func_id);
+	}
+}
+
+static bool hid_is_valid_access(int off, int size,
+				enum bpf_access_type access_type,
+				const struct bpf_prog *prog,
+				struct bpf_insn_access_aux *info)
+{
+	/* everything not in ctx is prohibited */
+	if (off < 0 || off + size > sizeof(struct hid_bpf_ctx))
+		return false;
+
+	switch (off) {
+	/* type, hdev are read-only */
+	case bpf_ctx_range_till(struct hid_bpf_ctx, type, hdev):
+		return access_type == BPF_READ;
+	}
+
+	/* everything else is read/write */
+	return true;
+}
+
+const struct bpf_verifier_ops hid_verifier_ops = {
+	.get_func_proto  = hid_func_proto,
+	.is_valid_access = hid_is_valid_access
+};
+
+/* Must be called with bpf_hid_mutex held. */
+static void bpf_hid_run_array_detach(struct hid_device *hdev,
+				     enum bpf_hid_attach_type type)
+{
+	struct bpf_prog_array *run_array;
+
+	run_array = rcu_replace_pointer(hdev->bpf.run_array[type], NULL,
+					lockdep_is_held(&bpf_hid_mutex));
+	bpf_prog_array_free(run_array);
+
+	if (hid_hooks.array_detached)
+		hid_hooks.array_detached(hdev, type);
+}
+
+static int link_index(struct hid_device *hdev, enum bpf_hid_attach_type type,
+		      struct bpf_hid_link *link)
+{
+	struct bpf_hid_link *pos;
+	int i = 0;
+
+	list_for_each_entry(pos, &hdev->bpf.links[type], node) {
+		if (pos == link)
+			return i;
+		i++;
+	}
+	return -ENOENT;
+}
+
+static int link_count(struct hid_device *hdev, enum bpf_hid_attach_type type)
+{
+	struct list_head *pos;
+	int i = 0;
+
+	list_for_each(pos, &hdev->bpf.links[type])
+		i++;
+	return i;
+}
+
+static void fill_prog_array(struct hid_device *hdev, enum bpf_hid_attach_type type,
+			    struct bpf_prog_array *prog_array)
+{
+	struct bpf_hid_link *pos;
+	unsigned int i = 0;
+
+	list_for_each_entry(pos, &hdev->bpf.links[type], node) {
+		prog_array->items[i].prog = pos->link.prog;
+		i++;
+	}
+}
+
+static void bpf_hid_link_release(struct bpf_link *link)
+{
+	struct bpf_hid_link *hid_link =
+		container_of(link, struct bpf_hid_link, link);
+	enum bpf_hid_attach_type type = hid_link->hid_type;
+	struct bpf_prog_array *old_array, *new_array;
+	struct hid_device *hdev;
+	int cnt, idx;
+
+	mutex_lock(&bpf_hid_mutex);
+
+	hdev = hid_link->hdev;
+	if (!hdev)
+		goto out_unlock;
+
+	/* Remember link position in case of safe delete */
+	idx = link_index(hdev, type, hid_link);
+	list_del(&hid_link->node);
+
+	cnt = link_count(hdev, type);
+	if (!cnt) {
+		bpf_hid_run_array_detach(hdev, type);
+		goto out_unlock;
+	}
+
+	old_array = rcu_dereference_protected(hdev->bpf.run_array[type],
+					      lockdep_is_held(&bpf_hid_mutex));
+	new_array = bpf_prog_array_alloc(cnt, GFP_KERNEL);
+	if (!new_array) {
+		WARN_ON(bpf_prog_array_delete_safe_at(old_array, idx));
+		goto out_unlock;
+	}
+	fill_prog_array(hdev, type, new_array);
+	rcu_assign_pointer(hdev->bpf.run_array[type], new_array);
+	bpf_prog_array_free(old_array);
+
+out_unlock:
+	hid_link->hdev = NULL;
+	mutex_unlock(&bpf_hid_mutex);
+}
+
+static int bpf_hid_link_detach(struct bpf_link *link)
+{
+	bpf_hid_link_release(link);
+	return 0;
+}
+
+static void bpf_hid_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_hid_link *hid_link =
+		container_of(link, struct bpf_hid_link, link);
+
+	kfree(hid_link);
+}
+
+static int bpf_hid_link_update_prog(struct bpf_link *link,
+				    struct bpf_prog *new_prog,
+				    struct bpf_prog *old_prog)
+{
+	struct bpf_hid_link *hid_link =
+		container_of(link, struct bpf_hid_link, link);
+	enum bpf_hid_attach_type type = hid_link->hid_type;
+	struct bpf_prog_array *run_array;
+	struct hid_device *hdev;
+	int idx, ret;
+
+	if (old_prog && old_prog != link->prog)
+		return -EPERM;
+	if (new_prog->type != link->prog->type)
+		return -EINVAL;
+
+	mutex_lock(&bpf_hid_mutex);
+
+	hdev = hid_link->hdev;
+	if (!hdev) {
+		/* hid dying */
+		ret = -ENOLINK;
+		goto out_unlock;
+	}
+
+	run_array = rcu_dereference_protected(hdev->bpf.run_array[type],
+					      lockdep_is_held(&bpf_hid_mutex));
+	idx = link_index(hdev, type, hid_link);
+	ret = bpf_prog_array_update_at(run_array, idx, new_prog);
+	if (ret)
+		goto out_unlock;
+
+	old_prog = xchg(&link->prog, new_prog);
+	bpf_prog_put(old_prog);
+
+out_unlock:
+	mutex_unlock(&bpf_hid_mutex);
+	return ret;
+}
+
+static int bpf_hid_link_fill_info(const struct bpf_link *link,
+				  struct bpf_link_info *info)
+{
+	const struct bpf_hid_link *hid_link =
+		container_of(link, struct bpf_hid_link, link);
+	int hidraw_ino = -1;
+	struct hid_device *hdev;
+	struct hidraw *hidraw;
+
+	mutex_lock(&bpf_hid_mutex);
+	hdev = hid_link->hdev;
+	if (hdev && hdev->hidraw) {
+		hidraw = hdev->hidraw;
+		hidraw_ino = hidraw->minor;
+	}
+	mutex_unlock(&bpf_hid_mutex);
+
+	info->hid.hidraw_ino = hidraw_ino;
+	info->hid.attach_type = hid_link->type;
+	return 0;
+}
+
+static void bpf_hid_link_show_fdinfo(const struct bpf_link *link,
+				     struct seq_file *seq)
+{
+	struct bpf_link_info info = {};
+
+	bpf_hid_link_fill_info(link, &info);
+	seq_printf(seq,
+		   "hidraw_ino:\t%u\n"
+		   "attach_type:\t%u\n",
+		   info.hid.hidraw_ino,
+		   info.hid.attach_type);
+}
+
+static const struct bpf_link_ops bpf_hid_link_ops = {
+	.release = bpf_hid_link_release,
+	.dealloc = bpf_hid_link_dealloc,
+	.detach = bpf_hid_link_detach,
+	.update_prog = bpf_hid_link_update_prog,
+	.fill_link_info = bpf_hid_link_fill_info,
+	.show_fdinfo = bpf_hid_link_show_fdinfo,
+};
+
+/* Must be called with bpf_hid_mutex held. */
+static int __bpf_hid_prog_query(const union bpf_attr *attr,
+				union bpf_attr __user *uattr,
+				  struct hid_device *hdev,
+				  enum bpf_hid_attach_type type)
+{
+	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
+	struct bpf_prog_array *run_array;
+	u32 prog_cnt = 0, flags = 0;
+
+	run_array = rcu_dereference_protected(hdev->bpf.run_array[type],
+					      lockdep_is_held(&bpf_hid_mutex));
+	if (run_array)
+		prog_cnt = bpf_prog_array_length(run_array);
+
+	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
+		return -EFAULT;
+	if (copy_to_user(&uattr->query.prog_cnt, &prog_cnt, sizeof(prog_cnt)))
+		return -EFAULT;
+	if (!attr->query.prog_cnt || !prog_ids || !prog_cnt)
+		return 0;
+
+	return bpf_prog_array_copy_to_user(run_array, prog_ids,
+					   attr->query.prog_cnt);
+}
+
+int bpf_hid_prog_query(const union bpf_attr *attr,
+		       union bpf_attr __user *uattr)
+{
+	enum bpf_hid_attach_type type;
+	struct hid_device *hdev;
+	int ret;
+
+	if (attr->query.query_flags || !hid_hooks.hdev_from_fd)
+		return -EINVAL;
+
+	type = to_bpf_hid_attach_type(attr->query.attach_type);
+	if (type < 0)
+		return -EINVAL;
+
+	hdev = hid_hooks.hdev_from_fd(attr->query.target_fd);
+	if (IS_ERR(hdev))
+		return PTR_ERR(hdev);
+
+	mutex_lock(&bpf_hid_mutex);
+	ret = __bpf_hid_prog_query(attr, uattr, hdev, type);
+	mutex_unlock(&bpf_hid_mutex);
+
+	return ret;
+}
+
+static int bpf_hid_max_progs(enum bpf_hid_attach_type type)
+{
+	switch (type) {
+	case BPF_HID_ATTACH_DEVICE_EVENT:
+		return 64;
+	default:
+		return 0;
+	}
+}
+
+static int bpf_hid_link_attach(struct hid_device *hdev, struct bpf_link *link,
+			       enum bpf_hid_attach_type type)
+{
+	struct bpf_hid_link *hid_link =
+		container_of(link, struct bpf_hid_link, link);
+	struct bpf_prog_array *run_array;
+	int cnt, err = 0;
+
+	mutex_lock(&bpf_hid_mutex);
+
+	cnt = link_count(hdev, type);
+	if (cnt >= bpf_hid_max_progs(type)) {
+		err = -E2BIG;
+		goto out_unlock;
+	}
+
+	if (hid_hooks.link_attach) {
+		err = hid_hooks.link_attach(hdev, type);
+		if (err)
+			goto out_unlock;
+	}
+
+	run_array = bpf_prog_array_alloc(cnt + 1, GFP_KERNEL);
+	if (!run_array) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+
+	list_add_tail(&hid_link->node, &hdev->bpf.links[type]);
+
+	fill_prog_array(hdev, type, run_array);
+	run_array = rcu_replace_pointer(hdev->bpf.run_array[type], run_array,
+					lockdep_is_held(&bpf_hid_mutex));
+	bpf_prog_array_free(run_array);
+
+out_unlock:
+	mutex_unlock(&bpf_hid_mutex);
+	return err;
+}
+
+int bpf_hid_link_create(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	enum bpf_hid_attach_type hid_type;
+	struct bpf_link_primer link_primer;
+	struct bpf_hid_link *hid_link;
+	enum bpf_attach_type type;
+	struct hid_device *hdev;
+	int err;
+
+	if (attr->link_create.flags || !hid_hooks.hdev_from_fd)
+		return -EINVAL;
+
+	type = attr->link_create.attach_type;
+	hid_type = to_bpf_hid_attach_type(type);
+	if (hid_type < 0)
+		return -EINVAL;
+
+	hdev = hid_hooks.hdev_from_fd(attr->link_create.target_fd);
+	if (IS_ERR(hdev))
+		return PTR_ERR(hdev);
+
+	hid_link = kzalloc(sizeof(*hid_link), GFP_USER);
+	if (!hid_link)
+		return -ENOMEM;
+
+	bpf_link_init(&hid_link->link, BPF_LINK_TYPE_HID,
+		      &bpf_hid_link_ops, prog);
+	hid_link->hdev = hdev;
+	hid_link->type = type;
+	hid_link->hid_type = hid_type;
+
+	err = bpf_link_prime(&hid_link->link, &link_primer);
+	if (err) {
+		kfree(hid_link);
+		return err;
+	}
+
+	err = bpf_hid_link_attach(hdev, &hid_link->link, hid_type);
+	if (err) {
+		bpf_link_cleanup(&link_primer);
+		return err;
+	}
+
+	return bpf_link_settle(&link_primer);
+}
+
+const struct bpf_prog_ops hid_prog_ops = {
+};
+
+int bpf_hid_init(struct hid_device *hdev)
+{
+	int type;
+
+	for (type = 0; type < MAX_BPF_HID_ATTACH_TYPE; type++)
+		INIT_LIST_HEAD(&hdev->bpf.links[type]);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(bpf_hid_init);
+
+void bpf_hid_exit(struct hid_device *hdev)
+{
+	enum bpf_hid_attach_type type;
+	struct bpf_hid_link *hid_link;
+
+	mutex_lock(&bpf_hid_mutex);
+	for (type = 0; type < MAX_BPF_HID_ATTACH_TYPE; type++) {
+		bpf_hid_run_array_detach(hdev, type);
+		list_for_each_entry(hid_link, &hdev->bpf.links[type], node) {
+			hid_link->hdev = NULL; /* auto-detach link */
+		}
+	}
+	mutex_unlock(&bpf_hid_mutex);
+}
+EXPORT_SYMBOL_GPL(bpf_hid_exit);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9c7a72b65eee..230ca6964a7e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3,6 +3,7 @@
  */
 #include <linux/bpf.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/bpf-hid.h>
 #include <linux/bpf_trace.h>
 #include <linux/bpf_lirc.h>
 #include <linux/bpf_verifier.h>
@@ -2174,6 +2175,7 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
 	case BPF_PROG_TYPE_EXT: /* extends any prog */
+	case BPF_PROG_TYPE_HID:
 		return true;
 	case BPF_PROG_TYPE_CGROUP_SKB:
 		/* always unpriv */
@@ -3188,6 +3190,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_SK_LOOKUP;
 	case BPF_XDP:
 		return BPF_PROG_TYPE_XDP;
+	case BPF_HID_DEVICE_EVENT:
+		return BPF_PROG_TYPE_HID;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -3331,6 +3335,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_SK_MSG_VERDICT:
 	case BPF_SK_SKB_VERDICT:
 		return sock_map_bpf_prog_query(attr, uattr);
+	case BPF_HID_DEVICE_EVENT:
+		return bpf_hid_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
 	}
@@ -4325,6 +4331,8 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		ret = bpf_perf_link_attach(attr, prog);
 		break;
 #endif
+	case BPF_PROG_TYPE_HID:
+		return bpf_hid_link_create(attr, prog);
 	default:
 		ret = -EINVAL;
 	}
diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 0e7bfdbff80a..65440bd618b2 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -2,6 +2,7 @@
 cpustat
 fds_example
 hbm
+hid_mouse
 ibumad
 lathist
 lwt_len_hist
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 38638845db9d..84ef458487df 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -60,6 +60,8 @@ tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect
 tprogs-y += xdp_monitor
 
+tprogs-y += hid_mouse
+
 # Libbpf dependencies
 LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
 LIBBPF_OUTPUT = $(abspath $(BPF_SAMPLES_PATH))/libbpf
@@ -124,6 +126,7 @@ xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o $(XDP_SAMPLE)
 xdp_redirect_map-objs := xdp_redirect_map_user.o $(XDP_SAMPLE)
 xdp_redirect-objs := xdp_redirect_user.o $(XDP_SAMPLE)
 xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
+hid_mouse-objs := hid_mouse_user.o
 
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
@@ -181,6 +184,7 @@ always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
 always-y += xdpsock_kern.o
+always-y += hid_mouse_kern.o
 
 ifeq ($(ARCH), arm)
 # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
diff --git a/samples/bpf/hid_mouse_kern.c b/samples/bpf/hid_mouse_kern.c
new file mode 100644
index 000000000000..83b0ab5a04d0
--- /dev/null
+++ b/samples/bpf/hid_mouse_kern.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021 Benjamin Tissoires
+ */
+#include <linux/version.h>
+#include <uapi/linux/bpf.h>
+#include <uapi/linux/bpf_hid.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("hid/device_event")
+int hid_y_event(struct hid_bpf_ctx *ctx)
+{
+	s16 y;
+
+	bpf_printk("event: %02x size: %d", ctx->type, ctx->u.device.size);
+	bpf_printk("incoming event: %02x %02x %02x",
+		   ctx->u.device.data[0],
+		   ctx->u.device.data[1],
+		   ctx->u.device.data[2]);
+	bpf_printk("                %02x %02x %02x",
+		   ctx->u.device.data[3],
+		   ctx->u.device.data[4],
+		   ctx->u.device.data[5]);
+	bpf_printk("                %02x %02x %02x",
+		   ctx->u.device.data[6],
+		   ctx->u.device.data[7],
+		   ctx->u.device.data[8]);
+
+	y = ctx->u.device.data[3] | (ctx->u.device.data[4] << 8);
+
+	y = -y;
+
+	ctx->u.device.data[3] = y & 0xFF;
+	ctx->u.device.data[4] = (y >> 8) & 0xFF;
+
+	bpf_printk("modified event: %02x %02x %02x",
+		   ctx->u.device.data[0],
+		   ctx->u.device.data[1],
+		   ctx->u.device.data[2]);
+	bpf_printk("                %02x %02x %02x",
+		   ctx->u.device.data[3],
+		   ctx->u.device.data[4],
+		   ctx->u.device.data[5]);
+	bpf_printk("                %02x %02x %02x",
+		   ctx->u.device.data[6],
+		   ctx->u.device.data[7],
+		   ctx->u.device.data[8]);
+
+	return 0;
+}
+
+SEC("hid/device_event")
+int hid_x_event(struct hid_bpf_ctx *ctx)
+{
+	s16 x;
+
+	x = ctx->u.device.data[1] | (ctx->u.device.data[2] << 8);
+
+	x = -x;
+
+	ctx->u.device.data[1] = x & 0xFF;
+	ctx->u.device.data[2] = (x >> 8) & 0xFF;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+u32 _version SEC("version") = LINUX_VERSION_CODE;
diff --git a/samples/bpf/hid_mouse_user.c b/samples/bpf/hid_mouse_user.c
new file mode 100644
index 000000000000..d4f37caca2fa
--- /dev/null
+++ b/samples/bpf/hid_mouse_user.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021 Benjamin Tissoires
+ */
+#include <linux/bpf.h>
+#include <linux/if_link.h>
+#include <assert.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <sys/resource.h>
+
+#include "bpf_util.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+static char *sysfs_path;
+static int sysfs_fd;
+static int prog_count;
+
+struct prog {
+	int fd;
+	struct bpf_link *link;
+	enum bpf_attach_type type;
+};
+
+static struct prog progs[10];
+
+static void int_exit(int sig)
+{
+	for (prog_count--; prog_count >= 0; prog_count--)
+		bpf_link__destroy(progs[prog_count].link);
+
+	close(sysfs_fd);
+	exit(0);
+}
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"%s: %s /sys/bus/hid/devices/0BUS:0VID:0PID:00ID/uevent\n\n",
+		__func__, prog);
+}
+
+int main(int argc, char **argv)
+{
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	const char *optstr = "";
+	struct bpf_object *obj;
+	struct bpf_program *prog;
+	int opt;
+	char filename[256];
+	int err;
+
+	while ((opt = getopt(argc, argv, optstr)) != -1) {
+		switch (opt) {
+		default:
+			usage(basename(argv[0]));
+			return 1;
+		}
+	}
+
+	if (optind == argc) {
+		usage(basename(argv[0]));
+		return 1;
+	}
+
+	sysfs_path = argv[optind];
+	if (!sysfs_path) {
+		perror("sysfs");
+		return 1;
+	}
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	err = libbpf_get_error(obj);
+	if (err) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		obj = NULL;
+		err = 1;
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	err = bpf_object__load(obj);
+	if (err) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	sysfs_fd = open(sysfs_path, O_RDONLY);
+
+	bpf_object__for_each_program(prog, obj) {
+		progs[prog_count].fd = bpf_program__fd(prog);
+		progs[prog_count].type = bpf_program__get_expected_attach_type(prog);
+		progs[prog_count].link = bpf_program__attach_hid(prog, sysfs_fd);
+		if (libbpf_get_error(progs[prog_count].link)) {
+			fprintf(stderr, "bpf_prog_attach: err=%m\n");
+			progs[prog_count].fd = 0;
+			progs[prog_count].link = NULL;
+			goto cleanup;
+		}
+		prog_count++;
+	}
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	err = bpf_obj_get_info_by_fd(progs[0].fd, &info, &info_len);
+	if (err) {
+		printf("can't get prog info - %s\n", strerror(errno));
+		goto cleanup;
+	}
+
+	while (1)
+		;
+
+ cleanup:
+	for (prog_count--; prog_count >= 0; prog_count--)
+		bpf_link__destroy(progs[prog_count].link);
+
+	bpf_object__close(obj);
+	return err;
+}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index afe3d0d7f5f2..5978b92cacd3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -952,6 +952,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_HID,
 };
 
 enum bpf_attach_type {
@@ -997,6 +998,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_HID_DEVICE_EVENT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1011,6 +1013,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_HID = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -5870,6 +5873,10 @@ struct bpf_link_info {
 		struct {
 			__u32 ifindex;
 		} xdp;
+		struct  {
+			__s32 hidraw_ino;
+			__u32 attach_type;
+		} hid;
 	};
 } __attribute__((aligned(8)));
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7e978feaf822..bad16e85032e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8676,6 +8676,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("cgroup/setsockopt",	CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("struct_ops+",		STRUCT_OPS, 0, SEC_NONE),
 	SEC_DEF("sk_lookup",		SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
+	SEC_DEF("hid/device_event",	HID, BPF_HID_DEVICE_EVENT, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 };
 
 #define MAX_TYPE_NAME_SIZE 32
@@ -10655,6 +10656,12 @@ static struct bpf_link *attach_iter(const struct bpf_program *prog, long cookie)
 	return bpf_program__attach_iter(prog, NULL);
 }
 
+struct bpf_link *
+bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd)
+{
+	return bpf_program__attach_fd(prog, hid_fd, 0, "hid");
+}
+
 struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
 {
 	if (!prog->sec_def || !prog->sec_def->attach_fn)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c8d8daad212e..f677ac0a9ede 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -529,6 +529,8 @@ struct bpf_iter_attach_opts {
 LIBBPF_API struct bpf_link *
 bpf_program__attach_iter(const struct bpf_program *prog,
 			 const struct bpf_iter_attach_opts *opts);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd);
 
 /*
  * Libbpf allows callers to adjust BPF programs before being loaded
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 47e70c9058d9..fdc6fa743953 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -424,6 +424,7 @@ LIBBPF_0.6.0 {
 LIBBPF_0.7.0 {
 	global:
 		bpf_btf_load;
+		bpf_program__attach_hid;
 		bpf_program__expected_attach_type;
 		bpf_program__log_buf;
 		bpf_program__log_level;
diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
new file mode 100644
index 000000000000..692d78b9dc4a
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -0,0 +1,318 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Red Hat */
+#include <test_progs.h>
+#include <testing_helpers.h>
+#include "hid.skel.h"
+
+#include <fcntl.h>
+#include <fnmatch.h>
+#include <dirent.h>
+#include <poll.h>
+#include <stdbool.h>
+#include <linux/uhid.h>
+
+static unsigned char rdesc[] = {
+	0x06, 0x00, 0xff,	/* Usage Page (Vendor Defined Page 1) */
+	0x09, 0x21,		/* Usage (Vendor Usage 0x21) */
+	0xa1, 0x01,		/* COLLECTION (Application) */
+	0x09, 0x01,			/* Usage (Vendor Usage 0x01) */
+	0xa1, 0x00,			/* COLLECTION (Physical) */
+	0x85, 0x01,				/* REPORT_ID (1) */
+	0x06, 0x00, 0xff,			/* Usage Page (Vendor Defined Page 1) */
+	0x19, 0x01,				/* USAGE_MINIMUM (1) */
+	0x29, 0x03,				/* USAGE_MAXIMUM (3) */
+	0x15, 0x00,				/* LOGICAL_MINIMUM (0) */
+	0x25, 0x01,				/* LOGICAL_MAXIMUM (1) */
+	0x95, 0x03,				/* REPORT_COUNT (3) */
+	0x75, 0x01,				/* REPORT_SIZE (1) */
+	0x81, 0x02,				/* INPUT (Data,Var,Abs) */
+	0x95, 0x01,				/* REPORT_COUNT (1) */
+	0x75, 0x05,				/* REPORT_SIZE (5) */
+	0x81, 0x01,				/* INPUT (Cnst,Var,Abs) */
+	0x05, 0x01,				/* USAGE_PAGE (Generic Desktop) */
+	0x09, 0x30,				/* USAGE (X) */
+	0x09, 0x31,				/* USAGE (Y) */
+	0x15, 0x81,				/* LOGICAL_MINIMUM (-127) */
+	0x25, 0x7f,				/* LOGICAL_MAXIMUM (127) */
+	0x75, 0x08,				/* REPORT_SIZE (8) */
+	0x95, 0x02,				/* REPORT_COUNT (2) */
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
+static int uhid_write(int fd, const struct uhid_event *ev)
+{
+	ssize_t ret;
+
+	ret = write(fd, ev, sizeof(*ev));
+	if (ret < 0) {
+		fprintf(stderr, "Cannot write to uhid: %m\n");
+		return -errno;
+	} else if (ret != sizeof(*ev)) {
+		fprintf(stderr, "Wrong size written to uhid: %zd != %zu\n",
+			ret, sizeof(ev));
+		return -EFAULT;
+	} else {
+		return 0;
+	}
+}
+
+static int create(int fd, int rand_nb)
+{
+	struct uhid_event ev;
+	char buf[25];
+
+	sprintf(buf, "test-uhid-device-%d", rand_nb);
+
+	memset(&ev, 0, sizeof(ev));
+	ev.type = UHID_CREATE;
+	strcpy((char *)ev.u.create.name, buf);
+	ev.u.create.rd_data = rdesc;
+	ev.u.create.rd_size = sizeof(rdesc);
+	ev.u.create.bus = BUS_USB;
+	ev.u.create.vendor = 0x0001;
+	ev.u.create.product = 0x0a37;
+	ev.u.create.version = 0;
+	ev.u.create.country = 0;
+
+	sprintf(buf, "%d", rand_nb);
+	strcpy((char *)ev.u.create.phys, buf);
+
+	return uhid_write(fd, &ev);
+}
+
+static void destroy(int fd)
+{
+	struct uhid_event ev;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.type = UHID_DESTROY;
+
+	uhid_write(fd, &ev);
+}
+
+static int send_event(int fd, u8 *buf, size_t size)
+{
+	struct uhid_event ev;
+
+	if (size > sizeof(ev.u.input.data))
+		return -E2BIG;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.type = UHID_INPUT2;
+	ev.u.input2.size = size;
+
+	memcpy(ev.u.input2.data, buf, size);
+
+	return uhid_write(fd, &ev);
+}
+
+static int setup_uhid(int rand_nb)
+{
+	int fd;
+	const char *path = "/dev/uhid";
+	int ret;
+
+	fd = open(path, O_RDWR | O_CLOEXEC);
+	if (!ASSERT_GE(fd, 0, "open uhid-cdev"))
+		return -EPERM;
+
+	ret = create(fd, rand_nb);
+	if (!ASSERT_OK(ret, "create uhid device")) {
+		close(fd);
+		return -EPERM;
+	}
+
+	return fd;
+}
+
+static int get_sysfs_fd(int rand_nb)
+{
+	const char *workdir = "/sys/devices/virtual/misc/uhid";
+	const char *target = "0003:0001:0A37.*";
+	char uevent[1024];
+	char temp[512];
+	char phys[512];
+	DIR *d;
+	struct dirent *dir;
+	int fd, nread;
+	int found = -1;
+
+	/* it would be nice to be able to use nftw, but the no_alu32 target doesn't support it */
+
+	sprintf(phys, "PHYS=%d", rand_nb);
+
+	d = opendir(workdir);
+	if (d) {
+		while ((dir = readdir(d)) != NULL) {
+			if (fnmatch(target, dir->d_name, 0))
+				continue;
+
+			/* we found the correct VID/PID, now check for phys */
+			sprintf(uevent, "%s/%s/uevent", workdir, dir->d_name);
+			fd = open(uevent, O_RDONLY | O_NONBLOCK);
+			if (fd < 0)
+				continue;
+
+			nread = read(fd, temp, ARRAY_SIZE(temp));
+			if (nread > 0 && (strstr(temp, phys)) != NULL) {
+				found = fd;
+				break;
+			}
+
+			close(fd);
+			fd = 0;
+		}
+		closedir(d);
+	}
+
+	return found;
+}
+
+static int get_hidraw(struct bpf_link *link)
+{
+	struct bpf_link_info info = {0};
+	int prog_id, i;
+
+	/* retry 5 times in case the system is loaded */
+	for (i = 5; i > 0; i--) {
+		usleep(10);
+		prog_id = link_info_prog_id(link, &info);
+		if (!prog_id)
+			continue;
+		if (info.hid.hidraw_ino >= 0)
+			break;
+	}
+
+	if (!prog_id)
+		return -1;
+
+	return info.hid.hidraw_ino;
+}
+
+/*
+ * Attach hid_first_event to the given uhid device,
+ * retrieve and open the matching hidraw node,
+ * inject one event in the uhid device,
+ * check that the program sees it and can change the data
+ */
+static int test_hid_raw_event(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
+{
+	int err, hidraw_ino, hidraw_fd = -1;
+	char hidraw_path[64] = {0};
+	u8 buf[10] = {0};
+	int ret = -1;
+
+	/* check that the program is correctly loaded */
+	ASSERT_EQ(hid_skel->data->callback_check, 52, "callback_check1");
+	ASSERT_EQ(hid_skel->data->callback2_check, 52, "callback2_check1");
+
+	/* attach the first program */
+	hid_skel->links.hid_first_event =
+		bpf_program__attach_hid(hid_skel->progs.hid_first_event, sysfs_fd);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_first_event,
+			   "attach_hid(hid_first_event)"))
+		return PTR_ERR(hid_skel->links.hid_first_event);
+
+	hidraw_ino = get_hidraw(hid_skel->links.hid_first_event);
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
+	/* check that hid_first_event() was executed */
+	ASSERT_EQ(hid_skel->data->callback_check, 42, "callback_check1");
+
+	/* read the data from hidraw */
+	memset(buf, 0, sizeof(buf));
+	err = read(hidraw_fd, buf, sizeof(buf));
+	if (!ASSERT_EQ(err, 4, "read_hidraw"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[2], 47, "hid_first_event"))
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
+void serial_test_hid_bpf(void)
+{
+	struct hid *hid_skel = NULL;
+	int err, uhid_fd, sysfs_fd;
+	time_t t;
+	int rand_nb;
+
+	/* initialize random number generator */
+	srand((unsigned int)time(&t));
+
+	rand_nb = rand() % 1024;
+
+	uhid_fd = setup_uhid(rand_nb);
+	if (!ASSERT_GE(uhid_fd, 0, "setup uhid"))
+		return;
+
+	/* give a little bit of time for the device to appear */
+	/* TODO: check on uhid events */
+	usleep(1000);
+
+	/* locate the uevent file of the created device */
+	sysfs_fd = get_sysfs_fd(rand_nb);
+	if (!ASSERT_GE(sysfs_fd, 0, "locate sysfs uhid device"))
+		goto cleanup;
+
+	hid_skel = hid__open_and_load();
+	if (!ASSERT_OK_PTR(hid_skel, "hid_skel_load"))
+		goto cleanup;
+
+	/* start the tests! */
+	err = test_hid_raw_event(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid");
+
+cleanup:
+	hid__destroy(hid_skel);
+	destroy(uhid_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
new file mode 100644
index 000000000000..f28bb6007875
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Red hat */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <linux/bpf_hid.h>
+
+char _license[] SEC("license") = "GPL";
+
+__u64 callback_check = 52;
+__u64 callback2_check = 52;
+
+SEC("hid/device_event")
+int hid_first_event(struct hid_bpf_ctx *ctx)
+{
+	callback_check = ctx->u.device.data[1];
+
+	ctx->u.device.data[2] = ctx->u.device.data[1] + 5;
+
+	return 0;
+}
-- 
2.35.1

