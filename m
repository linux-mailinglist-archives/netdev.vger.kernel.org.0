Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C214CDA9B
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238474AbiCDRdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241313AbiCDRdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:33:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87CEB1CD9D0
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=keWwWK0FSYCv+KDSFFo0E62Z2+V4Q5lYFQr59m0uXhY=;
        b=NXcZpkoFsS5LU6ZllD3S0e4qtRl9immt/7MD/MFWJZ5pPprn1sPr8ZoMURji0C9qXD7ebx
        qVBafEntXdESOeWIwqKWpuqTlcWm8KlkCz+0nlBrYML6yzFH67N+hnBj+g7g8MWfoHNPCf
        EdVcduY/kpKTKn9DGJt0ZGUXl6bSpY8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-UzYFijzsP3uGYt2lwCK8bg-1; Fri, 04 Mar 2022 12:32:08 -0500
X-MC-Unique: UzYFijzsP3uGYt2lwCK8bg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED8B51091DA0;
        Fri,  4 Mar 2022 17:32:05 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DED686595;
        Fri,  4 Mar 2022 17:32:01 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 10/28] selftests/bpf: add report descriptor fixup tests
Date:   Fri,  4 Mar 2022 18:28:34 +0100
Message-Id: <20220304172852.274126-11-benjamin.tissoires@redhat.com>
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

Simple report descriptor override in HID: replace part of the report
descriptor from a static definition in the bpf kernel program.

Note that this test should be run last because we disconnect/reconnect
the device, meaning that it changes the overall uhid device.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 69 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 48 ++++++++++++++
 2 files changed, 117 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index ee495d5a8bd5..91543b8078ca 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -9,6 +9,7 @@
 #include <dirent.h>
 #include <poll.h>
 #include <stdbool.h>
+#include <linux/hidraw.h>
 #include <linux/uhid.h>
 
 static unsigned char rdesc[] = {
@@ -296,6 +297,71 @@ static int test_hid_raw_event(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
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
@@ -329,6 +395,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_raw_event(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid");
 
+	err = test_rdesc_fixup(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_rdesc_fixup");
+
 cleanup:
 	hid__destroy(hid_skel);
 	destroy(uhid_fd);
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index 2201dd3b105d..2270448d0d3f 100644
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
+	callback2_check = ctx->data[4];
+
+	/* insert rdesc at offset 52 */
+	__builtin_memcpy(&ctx->data[52], rdesc, sizeof(rdesc));
+	ctx->size = sizeof(rdesc) + 52;
+
+	ctx->data[4] = 0x42;
+
+	return 0;
+}
-- 
2.35.1

