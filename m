Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB90571E52
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbiGLPGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbiGLPGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 11:06:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F3A9C4447
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 08:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657638022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yZy/kU520bjEz6wDtwvraJBCu2Or6TJf8DYrrvVCTDk=;
        b=L3f2CBTh3fLGe/XPTa/bu1DIkCyuLoWRPusbWSO1PXcycULEwQxmJ72A/o2501U1Mv6IRE
        RAtlhRj2Or7H/BLqrx8k+StZeLFYiLgQs5+kpbMQxB1Yl1XJzDugk2Szpv71m0Yllsdjoq
        UMSs5o9qHSBAYjN1s3+wLXdERFcmzfo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-htrWjFIJNIO5wdNKO8appg-1; Tue, 12 Jul 2022 11:00:18 -0400
X-MC-Unique: htrWjFIJNIO5wdNKO8appg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83EAB802D2C;
        Tue, 12 Jul 2022 15:00:16 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.195.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35E142166B26;
        Tue, 12 Jul 2022 15:00:12 +0000 (UTC)
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
Subject: [PATCH bpf-next v6 18/23] HID: bpf: allow to change the report descriptor
Date:   Tue, 12 Jul 2022 16:58:45 +0200
Message-Id: <20220712145850.599666-19-benjamin.tissoires@redhat.com>
In-Reply-To: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new tracepoint hid_bpf_rdesc_fixup() so we can trigger a
report descriptor fixup in the bpf world.

Whenever the program gets attached/detached, the device is reconnected
meaning that userspace will see it disappearing and reappearing with
the new report descriptor.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v6:
- use BTF_ID to get the btf_id of hid_bpf_rdesc_fixup

changes in v5:
- adapted for new API

not in v4

changes in v3:
- ensure the ctx.size is properly bounded by allocated size
- s/link_attached/post_link_attach/
- removed the switch statement with only one case

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 drivers/hid/bpf/hid_bpf_dispatch.c  | 77 ++++++++++++++++++++++++++++-
 drivers/hid/bpf/hid_bpf_dispatch.h  |  1 +
 drivers/hid/bpf/hid_bpf_jmp_table.c |  7 +++
 drivers/hid/hid-core.c              |  3 +-
 include/linux/hid_bpf.h             |  8 +++
 5 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/bpf/hid_bpf_dispatch.c b/drivers/hid/bpf/hid_bpf_dispatch.c
index 8348f5ae17f8..bcaeb65ed2a8 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -85,6 +85,63 @@ dispatch_hid_bpf_device_event(struct hid_device *hdev, enum hid_report_type type
 }
 EXPORT_SYMBOL_GPL(dispatch_hid_bpf_device_event);
 
+/**
+ * hid_bpf_rdesc_fixup - Called when the probe function parses the report
+ * descriptor of the HID device
+ *
+ * @ctx: The HID-BPF context
+ *
+ * @return 0 on success and keep processing; a positive value to change the
+ * incoming size buffer; a negative error code to interrupt the processing
+ * of this event
+ *
+ * Declare an %fmod_ret tracing bpf program to this function and attach this
+ * program through hid_bpf_attach_prog() to have this helper called before any
+ * parsing of the report descriptor by HID.
+ */
+/* never used by the kernel but declared so we can load and attach a tracepoint */
+__weak noinline int hid_bpf_rdesc_fixup(struct hid_bpf_ctx *ctx)
+{
+	return 0;
+}
+ALLOW_ERROR_INJECTION(hid_bpf_rdesc_fixup, ERRNO);
+
+u8 *call_hid_bpf_rdesc_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size)
+{
+	int ret;
+	struct hid_bpf_ctx_kern ctx_kern = {
+		.ctx = {
+			.hid = hdev,
+			.size = *size,
+			.allocated_size = HID_MAX_DESCRIPTOR_SIZE,
+		},
+	};
+
+	ctx_kern.data = kmemdup(rdesc, ctx_kern.ctx.allocated_size, GFP_KERNEL);
+	if (!ctx_kern.data)
+		goto ignore_bpf;
+
+	ret = hid_bpf_prog_run(hdev, HID_BPF_PROG_TYPE_RDESC_FIXUP, &ctx_kern);
+	if (ret < 0)
+		goto ignore_bpf;
+
+	if (ret) {
+		if (ret > ctx_kern.ctx.allocated_size)
+			goto ignore_bpf;
+
+		*size = ret;
+	}
+
+	rdesc = krealloc(ctx_kern.data, *size, GFP_KERNEL);
+
+	return rdesc;
+
+ ignore_bpf:
+	kfree(ctx_kern.data);
+	return kmemdup(rdesc, *size, GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(call_hid_bpf_rdesc_fixup);
+
 /**
  * hid_bpf_get_data - Get the kernel memory pointer associated with the context @ctx
  *
@@ -188,6 +245,14 @@ static int hid_bpf_allocate_event_data(struct hid_device *hdev)
 	return __hid_bpf_allocate_data(hdev, &hdev->bpf.device_data, &hdev->bpf.allocated_data);
 }
 
+int hid_bpf_reconnect(struct hid_device *hdev)
+{
+	if (!test_and_set_bit(ffs(HID_STAT_REPROBED), &hdev->status))
+		return device_reprobe(&hdev->dev);
+
+	return 0;
+}
+
 /**
  * hid_bpf_attach_prog - Attach the given @prog_fd to the given HID device
  *
@@ -229,7 +294,17 @@ hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, __u32 flags)
 			return err;
 	}
 
-	return __hid_bpf_attach_prog(hdev, prog_type, prog_fd, flags);
+	err = __hid_bpf_attach_prog(hdev, prog_type, prog_fd, flags);
+	if (err)
+		return err;
+
+	if (prog_type == HID_BPF_PROG_TYPE_RDESC_FIXUP) {
+		err = hid_bpf_reconnect(hdev);
+		if (err)
+			return err;
+	}
+
+	return 0;
 }
 
 /**
diff --git a/drivers/hid/bpf/hid_bpf_dispatch.h b/drivers/hid/bpf/hid_bpf_dispatch.h
index 98c378e18b2b..1d1d5bcccbd7 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.h
+++ b/drivers/hid/bpf/hid_bpf_dispatch.h
@@ -18,6 +18,7 @@ int __hid_bpf_attach_prog(struct hid_device *hdev, enum hid_bpf_prog_type prog_t
 void __hid_bpf_destroy_device(struct hid_device *hdev);
 int hid_bpf_prog_run(struct hid_device *hdev, enum hid_bpf_prog_type type,
 		     struct hid_bpf_ctx_kern *ctx_kern);
+int hid_bpf_reconnect(struct hid_device *hdev);
 
 struct bpf_prog;
 
diff --git a/drivers/hid/bpf/hid_bpf_jmp_table.c b/drivers/hid/bpf/hid_bpf_jmp_table.c
index 0f20deab81ff..3a5ab70d1a95 100644
--- a/drivers/hid/bpf/hid_bpf_jmp_table.c
+++ b/drivers/hid/bpf/hid_bpf_jmp_table.c
@@ -59,12 +59,15 @@ static DECLARE_WORK(release_work, hid_bpf_release_progs);
 
 BTF_ID_LIST(hid_bpf_btf_ids)
 BTF_ID(func, hid_bpf_device_event)			/* HID_BPF_PROG_TYPE_DEVICE_EVENT */
+BTF_ID(func, hid_bpf_rdesc_fixup)			/* HID_BPF_PROG_TYPE_RDESC_FIXUP */
 
 static int hid_bpf_max_programs(enum hid_bpf_prog_type type)
 {
 	switch (type) {
 	case HID_BPF_PROG_TYPE_DEVICE_EVENT:
 		return HID_BPF_MAX_PROGS_PER_DEV;
+	case HID_BPF_PROG_TYPE_RDESC_FIXUP:
+		return 1;
 	default:
 		return -EINVAL;
 	}
@@ -234,6 +237,10 @@ static void hid_bpf_release_progs(struct work_struct *work)
 				if (next->hdev == hdev && next->type == type)
 					next->hdev = NULL;
 			}
+
+			/* if type was rdesc fixup, reconnect device */
+			if (type == HID_BPF_PROG_TYPE_RDESC_FIXUP)
+				hid_bpf_reconnect(hdev);
 		}
 	}
 
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 356d3822f17d..42aed754123c 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1218,7 +1218,8 @@ int hid_open_report(struct hid_device *device)
 		return -ENODEV;
 	size = device->dev_rsize;
 
-	buf = kmemdup(start, size, GFP_KERNEL);
+	/* call_hid_bpf_rdesc_fixup() ensures we work on a copy of rdesc */
+	buf = call_hid_bpf_rdesc_fixup(device, start, &size);
 	if (buf == NULL)
 		return -ENOMEM;
 
diff --git a/include/linux/hid_bpf.h b/include/linux/hid_bpf.h
index ade0def154b6..4f5eb27a188b 100644
--- a/include/linux/hid_bpf.h
+++ b/include/linux/hid_bpf.h
@@ -59,6 +59,7 @@ struct hid_bpf_ctx {
 
 /* Following functions are tracepoints that BPF programs can attach to */
 int hid_bpf_device_event(struct hid_bpf_ctx *ctx);
+int hid_bpf_rdesc_fixup(struct hid_bpf_ctx *ctx);
 
 /* Following functions are kfunc that we export to BPF programs */
 /* available everywhere in HID-BPF */
@@ -82,6 +83,7 @@ void hid_bpf_release_context(struct hid_bpf_ctx *ctx);
 enum hid_bpf_prog_type {
 	HID_BPF_PROG_TYPE_UNDEF = -1,
 	HID_BPF_PROG_TYPE_DEVICE_EVENT,			/* an event is emitted from the device */
+	HID_BPF_PROG_TYPE_RDESC_FIXUP,
 	HID_BPF_PROG_TYPE_MAX,
 };
 
@@ -125,6 +127,7 @@ int hid_bpf_connect_device(struct hid_device *hdev);
 void hid_bpf_disconnect_device(struct hid_device *hdev);
 void hid_bpf_destroy_device(struct hid_device *hid);
 void hid_bpf_device_init(struct hid_device *hid);
+u8 *call_hid_bpf_rdesc_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size);
 #else /* CONFIG_BPF */
 static inline u8 *dispatch_hid_bpf_device_event(struct hid_device *hid, int type, u8 *data,
 						u32 *size, int interrupt) { return 0; }
@@ -132,6 +135,11 @@ static inline int hid_bpf_connect_device(struct hid_device *hdev) { return 0; }
 static inline void hid_bpf_disconnect_device(struct hid_device *hdev) {}
 static inline void hid_bpf_destroy_device(struct hid_device *hid) {}
 static inline void hid_bpf_device_init(struct hid_device *hid) {}
+static inline u8 *call_hid_bpf_rdesc_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size)
+{
+	return kmemdup(rdesc, *size, GFP_KERNEL);
+}
+
 #endif /* CONFIG_BPF */
 
 #endif /* __HID_BPF_H */
-- 
2.36.1

