Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774174CDAFE
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbiCDRfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239039AbiCDRfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:35:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79B75C4285
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4uaRcXJGT7eJtc1mwhxALaaVlywKZULlCyjWv5ugIh0=;
        b=OY2m3QKHXDPIg/B3DzPniCv+YLvqKuj+MEztUnOaESSH4vliScrRKiwrerBhKyPKtkLNW4
        wOUze/SsCXZVTwC4e86Qq6SmmvUcE3aJXlfl3H/0kCRdtz0obLDZUEpSL+ml8iqUew7wog
        NBxnurscjYaFALF01Jb4Kkf7JqTT3U0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-0XfFFxquOmClpCb5GaO1Kw-1; Fri, 04 Mar 2022 12:34:09 -0500
X-MC-Unique: 0XfFFxquOmClpCb5GaO1Kw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED6331091DA0;
        Fri,  4 Mar 2022 17:34:06 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DBA6865A4;
        Fri,  4 Mar 2022 17:34:02 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 20/28] HID: add implementation of bpf_hid_raw_request
Date:   Fri,  4 Mar 2022 18:28:44 +0100
Message-Id: <20220304172852.274126-21-benjamin.tissoires@redhat.com>
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

Hook up BPF to hid_hw_raw_request.
Not much to report here except that we need to export hid_get_report
from hid-core so it gets available in hid-bpf.c

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 drivers/hid/hid-bpf.c  | 63 ++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c |  3 +-
 include/linux/hid.h    |  1 +
 3 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
index 8ae247fba5bc..b8c0060f3180 100644
--- a/drivers/hid/hid-bpf.c
+++ b/drivers/hid/hid-bpf.c
@@ -171,6 +171,68 @@ int hid_bpf_set_data(struct hid_device *hdev, u8 *buf, size_t buf_size, u64 offs
 	return n;
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
@@ -272,6 +334,7 @@ int __init hid_bpf_module_init(void)
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
-- 
2.35.1

