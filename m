Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1D757CFD7
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbiGUPlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiGUPik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:38:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A572388F17
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658417847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vw7euc09RGEhvy8GTYW4MjayxsDSqrSdUdcRbZ+P2wM=;
        b=C6mAAvhuD0RlCbUqzS36IdngibSxnlv5lPe7dqhj4TuXyTZBdUOtKY6ldRGkDqHGdi1QP0
        FvGhc7afsUKtNBxv7X+jRyuaVU9p7O1YzRooWAGRrN0CKKfLngG71qo30BhW8+HhUuh8tq
        j9UgxRY6d9ULL8oEAnbHzQicoEcg2lw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-d74IfDtjOBeFaH9Dy3f2AA-1; Thu, 21 Jul 2022 11:37:24 -0400
X-MC-Unique: d74IfDtjOBeFaH9Dy3f2AA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 621532804063;
        Thu, 21 Jul 2022 15:37:23 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 182602166B26;
        Thu, 21 Jul 2022 15:37:19 +0000 (UTC)
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
Subject: [PATCH bpf-next v7 15/24] HID: bpf: allocate data memory for device_event BPF programs
Date:   Thu, 21 Jul 2022 17:36:16 +0200
Message-Id: <20220721153625.1282007-16-benjamin.tissoires@redhat.com>
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

We need to also be able to change the size of the report.
Reducing it is easy, because we already have the incoming buffer that is
big enough, but extending it is harder.

Pre-allocate a buffer that is big enough to handle all reports of the
device, and use that as the primary buffer for BPF programs.
To be able to change the size of the buffer, we change the device_event
API and request it to return the size of the buffer.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

no changes in v7

no changes in v6

new-ish in v5
---
 drivers/hid/bpf/hid_bpf_dispatch.c  | 116 +++++++++++++++++++++++++---
 drivers/hid/bpf/hid_bpf_jmp_table.c |   4 +-
 drivers/hid/hid-core.c              |  12 ++-
 include/linux/hid_bpf.h             |  37 +++++++--
 4 files changed, 151 insertions(+), 18 deletions(-)

diff --git a/drivers/hid/bpf/hid_bpf_dispatch.c b/drivers/hid/bpf/hid_bpf_dispatch.c
index 513c570c60a6..5224af4a1c2a 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -28,8 +28,9 @@ EXPORT_SYMBOL(hid_bpf_ops);
  *
  * @ctx: The HID-BPF context
  *
- * @return %0 on success and keep processing; a negative error code to interrupt
- * the processing of this event
+ * @return %0 on success and keep processing; a positive value to change the
+ * incoming size buffer; a negative error code to interrupt the processing
+ * of this event
  *
  * Declare an %fmod_ret tracing bpf program to this function and attach this
  * program through hid_bpf_attach_prog() to have this helper called for
@@ -44,23 +45,43 @@ __weak noinline int hid_bpf_device_event(struct hid_bpf_ctx *ctx)
 }
 ALLOW_ERROR_INJECTION(hid_bpf_device_event, ERRNO);
 
-int
+u8 *
 dispatch_hid_bpf_device_event(struct hid_device *hdev, enum hid_report_type type, u8 *data,
-			      u32 size, int interrupt)
+			      u32 *size, int interrupt)
 {
 	struct hid_bpf_ctx_kern ctx_kern = {
 		.ctx = {
 			.hid = hdev,
 			.report_type = type,
-			.size = size,
+			.allocated_size = hdev->bpf.allocated_data,
+			.size = *size,
 		},
-		.data = data,
+		.data = hdev->bpf.device_data,
 	};
+	int ret;
 
 	if (type >= HID_REPORT_TYPES)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
+
+	/* no program has been attached yet */
+	if (!hdev->bpf.device_data)
+		return data;
+
+	memset(ctx_kern.data, 0, hdev->bpf.allocated_data);
+	memcpy(ctx_kern.data, data, *size);
+
+	ret = hid_bpf_prog_run(hdev, HID_BPF_PROG_TYPE_DEVICE_EVENT, &ctx_kern);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	if (ret) {
+		if (ret > ctx_kern.ctx.allocated_size)
+			return ERR_PTR(-EINVAL);
 
-	return hid_bpf_prog_run(hdev, HID_BPF_PROG_TYPE_DEVICE_EVENT, &ctx_kern);
+		*size = ret;
+	}
+
+	return ctx_kern.data;
 }
 EXPORT_SYMBOL_GPL(dispatch_hid_bpf_device_event);
 
@@ -83,7 +104,7 @@ hid_bpf_get_data(struct hid_bpf_ctx *ctx, unsigned int offset, const size_t rdwr
 
 	ctx_kern = container_of(ctx, struct hid_bpf_ctx_kern, ctx);
 
-	if (rdwr_buf_size + offset > ctx->size)
+	if (rdwr_buf_size + offset > ctx->allocated_size)
 		return NULL;
 
 	return ctx_kern->data + offset;
@@ -122,6 +143,51 @@ static int device_match_id(struct device *dev, const void *id)
 	return hdev->id == *(int *)id;
 }
 
+static int __hid_bpf_allocate_data(struct hid_device *hdev, u8 **data, u32 *size)
+{
+	u8 *alloc_data;
+	unsigned int i, j, max_report_len = 0;
+	size_t alloc_size = 0;
+
+	/* compute the maximum report length for this device */
+	for (i = 0; i < HID_REPORT_TYPES; i++) {
+		struct hid_report_enum *report_enum = hdev->report_enum + i;
+
+		for (j = 0; j < HID_MAX_IDS; j++) {
+			struct hid_report *report = report_enum->report_id_hash[j];
+
+			if (report)
+				max_report_len = max(max_report_len, hid_report_len(report));
+		}
+	}
+
+	/*
+	 * Give us a little bit of extra space and some predictability in the
+	 * buffer length we create. This way, we can tell users that they can
+	 * work on chunks of 64 bytes of memory without having the bpf verifier
+	 * scream at them.
+	 */
+	alloc_size = DIV_ROUND_UP(max_report_len, 64) * 64;
+
+	alloc_data = kzalloc(alloc_size, GFP_KERNEL);
+	if (!alloc_data)
+		return -ENOMEM;
+
+	*data = alloc_data;
+	*size = alloc_size;
+
+	return 0;
+}
+
+static int hid_bpf_allocate_event_data(struct hid_device *hdev)
+{
+	/* hdev->bpf.device_data is already allocated, abort */
+	if (hdev->bpf.device_data)
+		return 0;
+
+	return __hid_bpf_allocate_data(hdev, &hdev->bpf.device_data, &hdev->bpf.allocated_data);
+}
+
 /**
  * hid_bpf_attach_prog - Attach the given @prog_fd to the given HID device
  *
@@ -137,7 +203,7 @@ hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, __u32 flags)
 {
 	struct hid_device *hdev;
 	struct device *dev;
-	int prog_type = hid_bpf_get_prog_attach_type(prog_fd);
+	int err, prog_type = hid_bpf_get_prog_attach_type(prog_fd);
 
 	if (!hid_bpf_ops)
 		return -EINVAL;
@@ -157,6 +223,12 @@ hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, __u32 flags)
 
 	hdev = to_hid_device(dev);
 
+	if (prog_type == HID_BPF_PROG_TYPE_DEVICE_EVENT) {
+		err = hid_bpf_allocate_event_data(hdev);
+		if (err)
+			return err;
+	}
+
 	return __hid_bpf_attach_prog(hdev, prog_type, prog_fd, flags);
 }
 
@@ -170,6 +242,30 @@ static const struct btf_kfunc_id_set hid_bpf_syscall_kfunc_set = {
 	.check_set     = &hid_bpf_syscall_kfunc_ids,
 };
 
+int hid_bpf_connect_device(struct hid_device *hdev)
+{
+	struct hid_bpf_prog_list *prog_list;
+
+	rcu_read_lock();
+	prog_list = rcu_dereference(hdev->bpf.progs[HID_BPF_PROG_TYPE_DEVICE_EVENT]);
+	rcu_read_unlock();
+
+	/* only allocate BPF data if there are programs attached */
+	if (!prog_list)
+		return 0;
+
+	return hid_bpf_allocate_event_data(hdev);
+}
+EXPORT_SYMBOL_GPL(hid_bpf_connect_device);
+
+void hid_bpf_disconnect_device(struct hid_device *hdev)
+{
+	kfree(hdev->bpf.device_data);
+	hdev->bpf.device_data = NULL;
+	hdev->bpf.allocated_data = 0;
+}
+EXPORT_SYMBOL_GPL(hid_bpf_disconnect_device);
+
 void hid_bpf_destroy_device(struct hid_device *hdev)
 {
 	if (!hdev)
diff --git a/drivers/hid/bpf/hid_bpf_jmp_table.c b/drivers/hid/bpf/hid_bpf_jmp_table.c
index 05225ff3cc27..0f20deab81ff 100644
--- a/drivers/hid/bpf/hid_bpf_jmp_table.c
+++ b/drivers/hid/bpf/hid_bpf_jmp_table.c
@@ -123,8 +123,10 @@ int hid_bpf_prog_run(struct hid_device *hdev, enum hid_bpf_prog_type type,
 
 		ctx_kern->ctx.index = idx;
 		err = __hid_bpf_tail_call(&ctx_kern->ctx);
-		if (err)
+		if (err < 0)
 			break;
+		if (err)
+			ctx_kern->ctx.retval = err;
 	}
 
  out_unlock:
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 47cc288fde63..c2589106ea4b 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2040,9 +2040,11 @@ int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data
 	report_enum = hid->report_enum + type;
 	hdrv = hid->driver;
 
-	ret = dispatch_hid_bpf_device_event(hid, type, data, size, interrupt);
-	if (ret)
+	data = dispatch_hid_bpf_device_event(hid, type, data, &size, interrupt);
+	if (IS_ERR(data)) {
+		ret = PTR_ERR(data);
 		goto unlock;
+	}
 
 	if (!size) {
 		dbg_hid("empty report\n");
@@ -2157,6 +2159,10 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	int len;
 	int ret;
 
+	ret = hid_bpf_connect_device(hdev);
+	if (ret)
+		return ret;
+
 	if (hdev->quirks & HID_QUIRK_HIDDEV_FORCE)
 		connect_mask |= (HID_CONNECT_HIDDEV_FORCE | HID_CONNECT_HIDDEV);
 	if (hdev->quirks & HID_QUIRK_HIDINPUT_FORCE)
@@ -2258,6 +2264,8 @@ void hid_disconnect(struct hid_device *hdev)
 	if (hdev->claimed & HID_CLAIMED_HIDRAW)
 		hidraw_disconnect(hdev);
 	hdev->claimed = 0;
+
+	hid_bpf_disconnect_device(hdev);
 }
 EXPORT_SYMBOL_GPL(hid_disconnect);
 
diff --git a/include/linux/hid_bpf.h b/include/linux/hid_bpf.h
index 51ab2e3822e0..86af0a79e6be 100644
--- a/include/linux/hid_bpf.h
+++ b/include/linux/hid_bpf.h
@@ -29,15 +29,32 @@ struct hid_device;
  *         a bigger index).
  * @hid: the ``struct hid_device`` representing the device itself
  * @report_type: used for ``hid_bpf_device_event()``
+ * @allocated_size: Allocated size of data.
+ *
+ *                  This is how much memory is available and can be requested
+ *                  by the HID program.
+ *                  Note that for ``HID_BPF_RDESC_FIXUP``, that memory is set to
+ *                  ``4096`` (4 KB)
  * @size: Valid data in the data field.
  *
  *        Programs can get the available valid size in data by fetching this field.
+ *        Programs can also change this value by returning a positive number in the
+ *        program.
+ *        To discard the event, return a negative error code.
+ *
+ *        ``size`` must always be less or equal than ``allocated_size`` (it is enforced
+ *        once all BPF programs have been run).
+ * @retval: Return value of the previous program.
  */
 struct hid_bpf_ctx {
 	__u32 index;
 	const struct hid_device *hid;
+	__u32 allocated_size;
 	enum hid_report_type report_type;
-	__s32 size;
+	union {
+		__s32 retval;
+		__s32 size;
+	};
 };
 
 /* Following functions are tracepoints that BPF programs can attach to */
@@ -81,6 +98,12 @@ struct hid_bpf_prog_list {
 
 /* stored in each device */
 struct hid_bpf {
+	u8 *device_data;		/* allocated when a bpf program of type
+					 * SEC(f.../hid_bpf_device_event) has been attached
+					 * to this HID device
+					 */
+	u32 allocated_data;
+
 	struct hid_bpf_prog_list __rcu *progs[HID_BPF_PROG_TYPE_MAX];	/* attached BPF progs */
 	bool destroyed;			/* prevents the assignment of any progs */
 
@@ -88,13 +111,17 @@ struct hid_bpf {
 };
 
 #ifdef CONFIG_HID_BPF
-int dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
-				  u32 size, int interrupt);
+u8 *dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
+				  u32 *size, int interrupt);
+int hid_bpf_connect_device(struct hid_device *hdev);
+void hid_bpf_disconnect_device(struct hid_device *hdev);
 void hid_bpf_destroy_device(struct hid_device *hid);
 void hid_bpf_device_init(struct hid_device *hid);
 #else /* CONFIG_HID_BPF */
-static inline int dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
-						u32 size, int interrupt) { return 0; }
+static inline u8 *dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
+						u32 *size, int interrupt) { return 0; }
+static inline int hid_bpf_connect_device(struct hid_device *hdev) { return 0; }
+static inline void hid_bpf_disconnect_device(struct hid_device *hdev) {}
 static inline void hid_bpf_destroy_device(struct hid_device *hid) {}
 static inline void hid_bpf_device_init(struct hid_device *hid) {}
 #endif /* CONFIG_HID_BPF */
-- 
2.36.1

