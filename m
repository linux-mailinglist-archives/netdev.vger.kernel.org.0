Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012204CDA95
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241190AbiCDRcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241175AbiCDRcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:32:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61ED31D06FE
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OE0r/OKc2053ESgSK8t3z8KfogKogU32PwBJEY1LnEc=;
        b=VYRdRWujDG2993NligVFxyp9Rgz3/g+F/kHz+xT8LMIFZ0vhHldZ2Rl/pgvEhdq5msCO79
        VwxFCHVvCtzF9W01d3MkBsCowXLFu8amRk0Urtjq5BOSCWFcscbSHZwm7ZV1YoI85tfOKb
        L0+TBskQNB2eSgUTC07B0v7Nl3jaw6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-mJypGw2FOR24BpQcynWSUg-1; Fri, 04 Mar 2022 12:31:47 -0500
X-MC-Unique: mJypGw2FOR24BpQcynWSUg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 760178031E1;
        Fri,  4 Mar 2022 17:31:44 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7628E86595;
        Fri,  4 Mar 2022 17:31:40 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 08/28] HID: allow to change the report descriptor from an eBPF program
Date:   Fri,  4 Mar 2022 18:28:32 +0100
Message-Id: <20220304172852.274126-9-benjamin.tissoires@redhat.com>
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

Make use of BPF_HID_ATTACH_RDESC_FIXUP so we can trigger an rdesc fixup
in the bpf world.

Whenever the program gets attached/detached, the device is reconnected
meaning that userspace will see it disappearing and reappearing with
the new report descriptor.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 drivers/hid/hid-bpf.c  | 60 ++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c |  3 ++-
 include/linux/hid.h    |  6 +++++
 3 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
index 8120e598de9f..510e24f4307c 100644
--- a/drivers/hid/hid-bpf.c
+++ b/drivers/hid/hid-bpf.c
@@ -50,6 +50,14 @@ static struct hid_device *hid_bpf_fd_to_hdev(int fd)
 	return hdev;
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
@@ -71,6 +79,17 @@ static int hid_bpf_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type
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
@@ -78,6 +97,9 @@ static void hid_bpf_array_detached(struct hid_device *hdev, enum bpf_hid_attach_
 		kfree(hdev->bpf.ctx);
 		hdev->bpf.ctx = NULL;
 		break;
+	case BPF_HID_ATTACH_RDESC_FIXUP:
+		hid_reconnect(hdev);
+		break;
 	default:
 		/* do nothing */
 	}
@@ -98,6 +120,9 @@ static int hid_bpf_run_progs(struct hid_device *hdev, enum bpf_hid_attach_type t
 	case BPF_HID_ATTACH_DEVICE_EVENT:
 		event = HID_BPF_DEVICE_EVENT;
 		break;
+	case BPF_HID_ATTACH_RDESC_FIXUP:
+		event = HID_BPF_RDESC_FIXUP;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -138,11 +163,46 @@ u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *data, int *size)
 	return hdev->bpf.ctx->data;
 }
 
+u8 *hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size)
+{
+	struct hid_bpf_ctx *ctx = NULL;
+	int ret;
+
+	if (bpf_hid_link_empty(&hdev->bpf, BPF_HID_ATTACH_RDESC_FIXUP))
+		goto ignore_bpf;
+
+	ctx = bpf_hid_allocate_ctx(hdev, HID_MAX_DESCRIPTOR_SIZE);
+	if (IS_ERR(ctx))
+		goto ignore_bpf;
+
+	ret = hid_bpf_run_progs(hdev, BPF_HID_ATTACH_RDESC_FIXUP, ctx, rdesc, *size);
+	if (ret)
+		goto ignore_bpf;
+
+	*size = ctx->size;
+
+	if (!*size) {
+		rdesc = NULL;
+		goto unlock;
+	}
+
+	rdesc = kmemdup(ctx->data, *size, GFP_KERNEL);
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
-- 
2.35.1

