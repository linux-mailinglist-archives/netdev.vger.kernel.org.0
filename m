Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE3C637CCE
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiKXPTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiKXPTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:19:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B69016F0EC
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669302989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=boFPFiLPbdkddr+SwOKpAMOQtmzRdgMD7Ts21Pm6sEE=;
        b=bSi9Q46DlLrgVmZ5QjOGNyxNC7TlnLwAO6EXkndezCJbuFgSvwfuEv9V3k/MhCCdomWhU6
        8BLixqI61ZUnyj6spNOD8kCgbHgeERs/FOVJ5QfX1PWYVMaU542iczuFJ/itU8yPOOmrMW
        q6hmDVbjFZZqN6HS5UXquBHB3z5zWLA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-MQYtX7HwMFyrXd4icQ2u4g-1; Thu, 24 Nov 2022 10:16:26 -0500
X-MC-Unique: MQYtX7HwMFyrXd4icQ2u4g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF918185A78B;
        Thu, 24 Nov 2022 15:16:25 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BB6040C2064;
        Thu, 24 Nov 2022 15:16:23 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [RFC hid v1 08/10] selftests: hid: add XK-24 tests
Date:   Thu, 24 Nov 2022 16:16:01 +0100
Message-Id: <20221124151603.807536-9-benjamin.tissoires@redhat.com>
In-Reply-To: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
References: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this is the first device to be added in the kernel with a bpf program
associated, so we better use it to ensure we get the things right.

We define another fixture that will reuse everything from hid_bpf except
for the variant parameters. And then we can use that easily in a new
dedicated test.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 tools/testing/selftests/hid/hid_bpf.c | 72 +++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/tools/testing/selftests/hid/hid_bpf.c b/tools/testing/selftests/hid/hid_bpf.c
index 738ddb2c6a62..4bdd1cfa7d13 100644
--- a/tools/testing/selftests/hid/hid_bpf.c
+++ b/tools/testing/selftests/hid/hid_bpf.c
@@ -520,6 +520,51 @@ FIXTURE_SETUP(hid_bpf)
 	ASSERT_EQ(0, err) TEARDOWN_LOG("could not start udev listener: %d", err);
 }
 
+static unsigned char xk24_rdesc[] = {
+	0x05, 0x0c,                    // Usage Page (Consumer Devices)       0
+	0x09, 0x01,                    // Usage (Consumer Control)            2
+	0xa1, 0x01,                    // Collection (Application)            4
+	0xa1, 0x02,                    //  Collection (Logical)               6
+	0x05, 0x08,                    //   Usage Page (LEDs)                 8
+	0x09, 0x4b,                    //   Usage (Generic Indicator)         10
+	0x75, 0x08,                    //   Report Size (8)                   12
+	0x95, 0x23,                    //   Report Count (35)                 14
+	0x91, 0x02,                    //   Output (Data,Var,Abs)             16
+	0xc0,                          //  End Collection                     18
+	0xa1, 0x02,                    //  Collection (Logical)               19
+	0x05, 0x09,                    //   Usage Page (Button)               21
+	0x09, 0x4b,                    //   Usage (Vendor Usage 0x4b)         23
+	0x75, 0x08,                    //   Report Size (8)                   25
+	0x95, 0x20,                    //   Report Count (32)                 27
+	0x81, 0x02,                    //   Input (Data,Var,Abs)              29
+	0xc0,                          //  End Collection                     31
+	0xc0,                          // End Collection                      32
+};
+
+#define _test_data_hid_bpf_xkeys _test_data_hid_bpf
+#define _fixture_variant_hid_bpf_xkeys _fixture_variant_hid_bpf
+FIXTURE(hid_bpf_xkeys);
+FIXTURE_VARIANT(hid_bpf_xkeys);
+FIXTURE_VARIANT_ADD(hid_bpf_xkeys, xk24) {
+	.id = {
+		.bus = BUS_USB,
+		.vendor = 0x05F3,
+		.product = 0x0405,
+		.version = 0,
+		.rdesc = xk24_rdesc,
+		.rdesc_sz = sizeof(xk24_rdesc),
+	},
+};
+
+FIXTURE_SETUP(hid_bpf_xkeys)
+{
+	hid_bpf_setup(_metadata, self, variant);
+}
+FIXTURE_TEARDOWN(hid_bpf_xkeys)
+{
+	hid_bpf_teardown(_metadata, self, variant);
+}
+
 struct test_program {
 	const char *name;
 	int insert_head;
@@ -846,6 +891,33 @@ TEST_F(hid_bpf, test_rdesc_fixup)
 	ASSERT_EQ(rpt_desc.value[4], 0x42);
 }
 
+/*
+ * Attach an emulated XK24, which has an in-tree eBPF program, and ensure
+ * we got it loaded.
+ */
+TEST_F(hid_bpf_xkeys, test_xk24)
+{
+	struct hidraw_report_descriptor rpt_desc = {0};
+	int err, desc_size;
+
+	/* open the kernel provided hidraw node */
+	self->hidraw_fd = open_hidraw(self->dev_id, &variant->id);
+	ASSERT_GE(self->hidraw_fd, 0) TH_LOG("open_hidraw");
+
+	/* read the exposed report descriptor from hidraw */
+	err = ioctl(self->hidraw_fd, HIDIOCGRDESCSIZE, &desc_size);
+	ASSERT_GE(err, 0) TH_LOG("error while reading HIDIOCGRDESCSIZE: %d", err);
+
+	/* ensure the new size of the rdesc is bigger than the old one */
+	ASSERT_GT(desc_size, sizeof(xk24_rdesc));
+
+	rpt_desc.size = desc_size;
+	err = ioctl(self->hidraw_fd, HIDIOCGRDESC, &rpt_desc);
+	ASSERT_GE(err, 0) TH_LOG("error while reading HIDIOCGRDESC: %d", err);
+
+	ASSERT_EQ(rpt_desc.value[21], 0x09);
+}
+
 static int libbpf_print_fn(enum libbpf_print_level level,
 			   const char *format, va_list args)
 {
-- 
2.38.1

