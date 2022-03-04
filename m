Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFAC4CDA7F
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241118AbiCDRcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241134AbiCDRcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:32:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97FF71CE98B
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1ZQuxqUPl7vDCQpUuTYcwfRw9C5mZXz4jQogneyXZWU=;
        b=g3b4mepJf1irF2cgoEBcFfFrc6PH7O0QbNv1E0FHsBIYT/JzHxPo0TQCr0idHLZtJrutdj
        zzb5EwraETHAAqNcumYSW5t4oTO92QuXrFAZ2SH29I1JyKIjFjJ+c+PY/Ti6DS9CX80hPk
        rbyDO6187fUxB1UfZias2qL1ZPx12MU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-o3Q7OgITME-QB5bLizegwA-1; Fri, 04 Mar 2022 12:31:05 -0500
X-MC-Unique: o3Q7OgITME-QB5bLizegwA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A50C518766D0;
        Fri,  4 Mar 2022 17:31:02 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD5CE86595;
        Fri,  4 Mar 2022 17:30:53 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 03/28] HID: hook up with bpf
Date:   Fri,  4 Mar 2022 18:28:27 +0100
Message-Id: <20220304172852.274126-4-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that BPF can be compatible with HID, add the capability into HID.
drivers/hid/hid-bpf.c takes care of the glue between bpf and HID, and
hid-core can then inject any incoming event from the device into a BPF
program to filter/analyze it.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
- addressed review comments from v1
---
 drivers/hid/Makefile   |   1 +
 drivers/hid/hid-bpf.c  | 157 +++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c |  21 +++++-
 include/linux/hid.h    |  11 +++
 4 files changed, 187 insertions(+), 3 deletions(-)
 create mode 100644 drivers/hid/hid-bpf.c

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
index 000000000000..8120e598de9f
--- /dev/null
+++ b/drivers/hid/hid-bpf.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *  BPF in HID support for Linux
+ *
+ *  Copyright (c) 2022 Benjamin Tissoires
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
+static int hid_bpf_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
+{
+	int err = 0;
+
+	switch (type) {
+	case BPF_HID_ATTACH_DEVICE_EVENT:
+		if (!hdev->bpf.ctx) {
+			hdev->bpf.ctx = bpf_hid_allocate_ctx(hdev, HID_BPF_MAX_BUFFER_SIZE);
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
+	if (size > ctx->allocated_size)
+		return -E2BIG;
+
+	switch (type) {
+	case BPF_HID_ATTACH_DEVICE_EVENT:
+		event = HID_BPF_DEVICE_EVENT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!hdev->bpf.run_array[type])
+		return 0;
+
+	memset(ctx->data, 0, ctx->allocated_size);
+	ctx->type = event;
+
+	if (size && data) {
+		memcpy(ctx->data, data, size);
+		ctx->size = size;
+	} else {
+		ctx->size = 0;
+	}
+
+	return BPF_PROG_RUN_ARRAY(hdev->bpf.run_array[type], ctx, bpf_prog_run);
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
+		return ERR_PTR(ret);
+
+	if (!hdev->bpf.ctx->size)
+		return ERR_PTR(-EINVAL);
+
+	*size = hdev->bpf.ctx->size;
+
+	return hdev->bpf.ctx->data;
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
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 56f6f4ad45a7..8fd79011f461 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -27,6 +27,7 @@
 #include <linux/mutex.h>
 #include <linux/power_supply.h>
 #include <uapi/linux/hid.h>
+#include <uapi/linux/bpf_hid.h>
 
 /*
  * We parse each description item into this structure. Short items data
@@ -1210,4 +1211,14 @@ do {									\
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
-- 
2.35.1

