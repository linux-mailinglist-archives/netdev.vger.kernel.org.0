Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F514DDEA1
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238807AbiCRQU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239161AbiCRQTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:19:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CEB5139AD8
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o+M0hzPfXbSknPCIGxa8xOYfbwK5d3tQ9k5sjS0RFo8=;
        b=gRCuns2QOhYXhZ272fCckaIDqL+g9WQBylK+FzcN983zWOzqxnYCVyYexeu2td+gF5JyhS
        SXysKbPcSTWJiOsDXqshOTUrUT88u2xmuyST6rOzToUQoIwptc//SEmnHhBJU8FXzJ7FK6
        BCejSCRwLVyrV35IziF/N0UaZYI/GDQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-8ira-iG9MMGUCiNAErdmrA-1; Fri, 18 Mar 2022 12:17:58 -0400
X-MC-Unique: 8ira-iG9MMGUCiNAErdmrA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52C271C0691C;
        Fri, 18 Mar 2022 16:17:57 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EB7D7AD1;
        Fri, 18 Mar 2022 16:17:53 +0000 (UTC)
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
Subject: [PATCH bpf-next v3 14/17] HID: add implementation of bpf_hid_raw_request
Date:   Fri, 18 Mar 2022 17:15:25 +0100
Message-Id: <20220318161528.1531164-15-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hook up BPF to hid_hw_raw_request.
Not much to report here except that we need to export hid_get_report
from hid-core so it gets available in hid-bpf.c

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v3:
- export HID_*_REPORT definitions in uapi as they are not following
  the specs

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 drivers/hid/hid-bpf.c    | 63 ++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c   |  3 +-
 include/linux/hid.h      | 12 ++------
 include/uapi/linux/hid.h | 10 +++++++
 4 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
index 650dd5e54919..66724aa2ff42 100644
--- a/drivers/hid/hid-bpf.c
+++ b/drivers/hid/hid-bpf.c
@@ -149,6 +149,68 @@ static int hid_bpf_set_bits(struct hid_device *hdev, u8 *buf, size_t buf_size, u
 	return n;
 }
 
+static int hid_bpf_raw_request(struct hid_device *hdev, u8 *buf, size_t size,
+			       u8 rtype, u8 reqtype)
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
 static int hid_bpf_run_progs(struct hid_device *hdev, struct hid_bpf_ctx_kern *ctx)
 {
 	enum bpf_hid_attach_type type;
@@ -252,6 +314,7 @@ int __init hid_bpf_module_init(void)
 		.array_detach = hid_bpf_array_detach,
 		.hid_get_bits = hid_bpf_get_bits,
 		.hid_set_bits = hid_bpf_set_bits,
+		.hid_raw_request  = hid_bpf_raw_request,
 	};
 
 	bpf_hid_set_hooks(&hooks);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 4f669dcddc08..f4b5d22f0831 100644
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
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 7454e844324c..2f1b40d48265 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -316,15 +316,6 @@ struct hid_item {
 #define HID_BAT_ABSOLUTESTATEOFCHARGE	0x00850065
 
 #define HID_VD_ASUS_CUSTOM_MEDIA_KEYS	0xff310076
-/*
- * HID report types --- Ouch! HID spec says 1 2 3!
- */
-
-#define HID_INPUT_REPORT	0
-#define HID_OUTPUT_REPORT	1
-#define HID_FEATURE_REPORT	2
-
-#define HID_REPORT_TYPES	3
 
 /*
  * HID connect requests
@@ -344,7 +335,7 @@ struct hid_item {
  * HID device quirks.
  */
 
-/* 
+/*
  * Increase this if you need to configure more HID quirks at module load time
  */
 #define MAX_USBHID_BOOT_QUIRKS 4
@@ -946,6 +937,7 @@ __u32 hid_field_extract(const struct hid_device *hid, __u8 *report,
 		     unsigned offset, unsigned n);
 void implement(const struct hid_device *hid, u8 *report, unsigned int offset, unsigned int n,
 	       u32 value);
+struct hid_report *hid_get_report(struct hid_report_enum *report_enum, const u8 *data);
 
 #ifdef CONFIG_PM
 int hid_driver_suspend(struct hid_device *hdev, pm_message_t state);
diff --git a/include/uapi/linux/hid.h b/include/uapi/linux/hid.h
index b34492a87a8a..bb690343cf9a 100644
--- a/include/uapi/linux/hid.h
+++ b/include/uapi/linux/hid.h
@@ -42,6 +42,16 @@
 #define USB_INTERFACE_PROTOCOL_KEYBOARD	1
 #define USB_INTERFACE_PROTOCOL_MOUSE	2
 
+/*
+ * HID report types --- Ouch! HID spec says 1 2 3!
+ */
+
+#define HID_INPUT_REPORT	0
+#define HID_OUTPUT_REPORT	1
+#define HID_FEATURE_REPORT	2
+
+#define HID_REPORT_TYPES	3
+
 /*
  * HID class requests
  */
-- 
2.35.1

