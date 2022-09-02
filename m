Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBD15AB29A
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 16:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238728AbiIBOAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 10:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238848AbiIBN7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 09:59:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65681F63EE
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 06:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662125465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z/jR/J9rPIM6gYumG3kAHK4mPEl1prKaGQX2EjKN18k=;
        b=C+WzBpJo0CYrlZxAEJIXc0WEf1IgiVLi5ZX/HD8Bc48ISNdHyLiugRWWn/LLof13hNPXc5
        7mNehYxn0LunslbpasSLhfJxEm/QaK+HeUF+k3LnP1J5cvBivmi2t0c6bFoSlChsDkb1hK
        3v6IG1p4rFD01U2zvSef/rn+sRpUetk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-q_cRV2D3Oqq3HIga66IbrQ-1; Fri, 02 Sep 2022 09:31:00 -0400
X-MC-Unique: q_cRV2D3Oqq3HIga66IbrQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C0101C0690F;
        Fri,  2 Sep 2022 13:30:59 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B8CC492C3B;
        Fri,  2 Sep 2022 13:30:55 +0000 (UTC)
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
Subject: [PATCH bpf-next v10 19/23] selftests/bpf: add report descriptor fixup tests
Date:   Fri,  2 Sep 2022 15:29:34 +0200
Message-Id: <20220902132938.2409206-20-benjamin.tissoires@redhat.com>
In-Reply-To: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
References: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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

no changes in v10

no changes in v9

no changes in v8

no changes in v7

no changes in v6

changes in v5:
- amended for the new API

not in v4

changes in v3:
- added a comment to mention that this test needs to be run last

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 76 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 53 ++++++++++++++
 2 files changed, 129 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index 19172d3e0f44..9dc5f0038472 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -9,6 +9,7 @@
 #include <dirent.h>
 #include <poll.h>
 #include <stdbool.h>
+#include <linux/hidraw.h>
 #include <linux/uhid.h>
 
 static unsigned char rdesc[] = {
@@ -769,6 +770,73 @@ static int test_hid_user_raw_request_call(int uhid_fd, int dev_id)
 	return ret;
 }
 
+/*
+ * Attach hid_rdesc_fixup to the given uhid device,
+ * retrieve and open the matching hidraw node,
+ * check that the hidraw report descriptor has been updated.
+ */
+static int test_rdesc_fixup(void)
+{
+	struct hidraw_report_descriptor rpt_desc = {0};
+	struct test_params params;
+	int err, uhid_fd, desc_size, hidraw_fd = -1, ret = -1;
+	int dev_id;
+	void *uhid_err;
+	pthread_t tid;
+	bool started = false;
+
+	dev_id = rand() % 1024;
+
+	uhid_fd = setup_uhid(dev_id);
+	if (!ASSERT_GE(uhid_fd, 0, "setup uhid"))
+		return uhid_fd;
+
+	err = prep_test(dev_id, "hid_rdesc_fixup", &params);
+	if (!ASSERT_EQ(err, 0, "prep_test(hid_rdesc_fixup)"))
+		goto cleanup;
+
+	err = uhid_start_listener(&tid, uhid_fd);
+	ASSERT_OK(err, "uhid_start_listener");
+
+	started = true;
+
+	hidraw_fd = params.hidraw_fd;
+
+	/* check that hid_rdesc_fixup() was executed */
+	ASSERT_EQ(params.skel->data->callback2_check, 0x21, "callback_check2");
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
+	cleanup_test(&params);
+
+	if (started) {
+		destroy(uhid_fd);
+		pthread_join(tid, &uhid_err);
+		err = (int)(long)uhid_err;
+		CHECK_FAIL(err);
+	}
+
+	return ret;
+}
+
 void serial_test_hid_bpf(void)
 {
 	int err, uhid_fd;
@@ -799,6 +867,14 @@ void serial_test_hid_bpf(void)
 	err = test_hid_user_raw_request_call(uhid_fd, dev_id);
 	ASSERT_OK(err, "hid_user_raw_request");
 
+	/*
+	 * this test should be run last because we disconnect/reconnect
+	 * the device, meaning that it changes the overall uhid device
+	 * and messes up with the thread that reads uhid events.
+	 */
+	err = test_rdesc_fixup();
+	ASSERT_OK(err, "hid_rdesc_fixup");
+
 	destroy(uhid_fd);
 
 	pthread_join(tid, &uhid_err);
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index fde76f63927b..815ff94321c9 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -99,3 +99,56 @@ int hid_user_raw_request(struct hid_hw_request_syscall_args *args)
 
 	return 0;
 }
+
+static const __u8 rdesc[] = {
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
+SEC("?fmod_ret/hid_bpf_rdesc_fixup")
+int BPF_PROG(hid_rdesc_fixup, struct hid_bpf_ctx *hid_ctx)
+{
+	__u8 *data = hid_bpf_get_data(hid_ctx, 0 /* offset */, 4096 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	callback2_check = data[4];
+
+	/* insert rdesc at offset 73 */
+	__builtin_memcpy(&data[73], rdesc, sizeof(rdesc));
+
+	/* Change Usage Vendor globally */
+	data[4] = 0x42;
+
+	return sizeof(rdesc) + 73;
+}
-- 
2.36.1

