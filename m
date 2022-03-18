Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCB44DDE81
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbiCRQTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238856AbiCRQSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:18:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A964A2EF0D8
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g5tRmrZUKM3tsTBn6dkiecWK2nGanjyI5ExDEzCAG/c=;
        b=eqcPX29FiZO8y/dVbhMJMuS/OsvhPEQa8bMIXFTP7ArdFtuYFnoJ4UnCavnBmFIs2R20YZ
        fmU0I2hvym94vquwxI2TUULrQyLirnEUuKUcvj0zPIBhNFxScYzp++TpHdndZ3QoZI8P0G
        FAvnNaZTfhcCHWxvc7tk3c4JiSq0hLM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-ejlFZfI0P8WeJMJ7D26siA-1; Fri, 18 Mar 2022 12:16:41 -0400
X-MC-Unique: ejlFZfI0P8WeJMJ7D26siA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C180380407F;
        Fri, 18 Mar 2022 16:16:39 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83F933543C;
        Fri, 18 Mar 2022 16:16:32 +0000 (UTC)
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
Subject: [PATCH bpf-next v3 06/17] HID: allow to change the report descriptor from an eBPF program
Date:   Fri, 18 Mar 2022 17:15:17 +0100
Message-Id: <20220318161528.1531164-7-benjamin.tissoires@redhat.com>
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

Make use of BPF_HID_ATTACH_RDESC_FIXUP so we can trigger an rdesc fixup
in the bpf world.

Whenever the program gets attached/detached, the device is reconnected
meaning that userspace will see it disappearing and reappearing with
the new report descriptor.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v3:
- ensure the ctx.size is properly bounded by allocated size
- s/link_attached/post_link_attach/
- removed the switch statement with only one case

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 drivers/hid/hid-bpf.c  | 62 ++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c |  3 +-
 include/linux/hid.h    |  6 ++++
 3 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
index 5060ebcb9979..45c87ff47324 100644
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
 static int hid_bpf_pre_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
 {
 	int err = 0;
@@ -92,6 +100,12 @@ static int hid_bpf_pre_link_attach(struct hid_device *hdev, enum bpf_hid_attach_
 	return err;
 }
 
+static void hid_bpf_post_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
+{
+	if (type == BPF_HID_ATTACH_RDESC_FIXUP)
+		hid_reconnect(hdev);
+}
+
 static void hid_bpf_array_detach(struct hid_device *hdev, enum bpf_hid_attach_type type)
 {
 	switch (type) {
@@ -99,6 +113,9 @@ static void hid_bpf_array_detach(struct hid_device *hdev, enum bpf_hid_attach_ty
 		kfree(hdev->bpf.device_data);
 		hdev->bpf.device_data = NULL;
 		break;
+	case BPF_HID_ATTACH_RDESC_FIXUP:
+		hid_reconnect(hdev);
+		break;
 	default:
 		/* do nothing */
 		break;
@@ -116,6 +133,9 @@ static int hid_bpf_run_progs(struct hid_device *hdev, struct hid_bpf_ctx_kern *c
 	case HID_BPF_DEVICE_EVENT:
 		type = BPF_HID_ATTACH_DEVICE_EVENT;
 		break;
+	case HID_BPF_RDESC_FIXUP:
+		type = BPF_HID_ATTACH_RDESC_FIXUP;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -155,11 +175,53 @@ u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *data, int *size)
 	return ctx.data;
 }
 
+u8 *hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size)
+{
+	int ret;
+	struct hid_bpf_ctx_kern ctx = {
+		.type = HID_BPF_RDESC_FIXUP,
+		.hdev = hdev,
+		.size = *size,
+	};
+
+	if (bpf_hid_link_empty(&hdev->bpf, BPF_HID_ATTACH_RDESC_FIXUP))
+		goto ignore_bpf;
+
+	ctx.data = kmemdup(rdesc, HID_MAX_DESCRIPTOR_SIZE, GFP_KERNEL);
+	if (!ctx.data)
+		goto ignore_bpf;
+
+	ctx.allocated_size = HID_MAX_DESCRIPTOR_SIZE;
+
+	ret = hid_bpf_run_progs(hdev, &ctx);
+	if (ret)
+		goto ignore_bpf;
+
+	if (ctx.size > ctx.allocated_size)
+		goto ignore_bpf;
+
+	*size = ctx.size;
+
+	if (*size) {
+		rdesc = krealloc(ctx.data, *size, GFP_KERNEL);
+	} else {
+		rdesc = NULL;
+		kfree(ctx.data);
+	}
+
+	return rdesc;
+
+ ignore_bpf:
+	kfree(ctx.data);
+	return kmemdup(rdesc, *size, GFP_KERNEL);
+}
+
 int __init hid_bpf_module_init(void)
 {
 	struct bpf_hid_hooks hooks = {
 		.hdev_from_fd = hid_bpf_fd_to_hdev,
 		.pre_link_attach = hid_bpf_pre_link_attach,
+		.post_link_attach = hid_bpf_post_link_attach,
 		.array_detach = hid_bpf_array_detach,
 	};
 
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 937fab7eb9c6..3182c39db006 100644
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

