Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7214CDAE6
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241387AbiCDRg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241410AbiCDRg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:36:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB9CFC4295
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tSkkv8IlHvaGufTNbPlZ5hq4BEbTEZB+75KA4cY5Zt0=;
        b=f5yIfOo/oiLVSOcnQ4OwYls2eFWJ8jn9cJo7sqbagXsvkX/YBLrAMX40fT/43ACoG23hiU
        YlcnK87l+mVg21h8wn0P0vyjI0PgwDV3erOyUpMiNN63YIvK4qrI2iao2d1vu2mQR6tiK1
        87Tn0RLd8ihsP/Cb0NdpOXXbX+RwRvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-giQO_BOyOtWSB_hzw5-eSQ-1; Fri, 04 Mar 2022 12:35:05 -0500
X-MC-Unique: giQO_BOyOtWSB_hzw5-eSQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE98F18766D0;
        Fri,  4 Mar 2022 17:35:02 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE57186595;
        Fri,  4 Mar 2022 17:34:58 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 27/28] selftests/bpf: Add a test for BPF_F_INSERT_HEAD
Date:   Fri,  4 Mar 2022 18:28:51 +0100
Message-Id: <20220304172852.274126-28-benjamin.tissoires@redhat.com>
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

Insert 3 programs to check that we are doing the correct thing:
'2', '1', '3' are inserted, but '1' is supposed to be executed first.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

new in v2
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 90 ++++++++++++++++++--
 tools/testing/selftests/bpf/progs/hid.c      | 36 ++++++++
 2 files changed, 121 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index a2bab6a799a1..f7fec748a0b9 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -353,7 +353,7 @@ static int test_hid_raw_event(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
 
 	/* attach the first program */
 	hid_skel->links.hid_first_event =
-		bpf_program__attach_hid(hid_skel->progs.hid_first_event, sysfs_fd);
+		bpf_program__attach_hid(hid_skel->progs.hid_first_event, sysfs_fd, 0);
 	if (!ASSERT_OK_PTR(hid_skel->links.hid_first_event,
 			   "attach_hid(hid_first_event)"))
 		return PTR_ERR(hid_skel->links.hid_first_event);
@@ -429,7 +429,7 @@ static int test_hid_set_get_data(struct hid *hid_skel, int uhid_fd, int sysfs_fd
 
 	/* attach hid_set_get_data program */
 	hid_skel->links.hid_set_get_data =
-		bpf_program__attach_hid(hid_skel->progs.hid_set_get_data, sysfs_fd);
+		bpf_program__attach_hid(hid_skel->progs.hid_set_get_data, sysfs_fd, 0);
 	if (!ASSERT_OK_PTR(hid_skel->links.hid_set_get_data,
 			   "attach_hid(hid_set_get_data)"))
 		return PTR_ERR(hid_skel->links.hid_set_get_data);
@@ -498,7 +498,7 @@ static int test_hid_user_call(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
 	);
 
 	/* attach hid_user program */
-	hid_skel->links.hid_user = bpf_program__attach_hid(hid_skel->progs.hid_user, sysfs_fd);
+	hid_skel->links.hid_user = bpf_program__attach_hid(hid_skel->progs.hid_user, sysfs_fd, 0);
 	if (!ASSERT_OK_PTR(hid_skel->links.hid_user,
 			   "attach_hid(hid_user)"))
 		return PTR_ERR(hid_skel->links.hid_user);
@@ -552,7 +552,7 @@ static int test_hid_user_raw_request_call(struct hid *hid_skel, int uhid_fd, int
 
 	/* attach hid_user_raw_request program */
 	hid_skel->links.hid_user_raw_request =
-		bpf_program__attach_hid(hid_skel->progs.hid_user_raw_request, sysfs_fd);
+		bpf_program__attach_hid(hid_skel->progs.hid_user_raw_request, sysfs_fd, 0);
 	if (!ASSERT_OK_PTR(hid_skel->links.hid_user_raw_request,
 			   "attach_hid(hid_user_raw_request)"))
 		return PTR_ERR(hid_skel->links.hid_user_raw_request);
@@ -582,6 +582,83 @@ static int test_hid_user_raw_request_call(struct hid *hid_skel, int uhid_fd, int
 	return ret;
 }
 
+/*
+ * Attach hid_insert{0,1,2} to the given uhid device,
+ * retrieve and open the matching hidraw node,
+ * inject one event in the uhid device,
+ * check that the programs have been inserted in the correct order.
+ */
+static int test_hid_attach_flags(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
+{
+	int err, hidraw_ino, hidraw_fd = -1;
+	char hidraw_path[64] = {0};
+	u8 buf[10] = {0};
+	int ret = -1;
+
+	/* attach hid_test_insert2 program */
+	hid_skel->links.hid_test_insert2 =
+		bpf_program__attach_hid(hid_skel->progs.hid_test_insert2, sysfs_fd, 0);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_test_insert2,
+			   "attach_hid(hid_test_insert2)"))
+		return PTR_ERR(hid_skel->links.hid_test_insert2);
+
+	/* then attach hid_test_insert1 program before the previous*/
+	hid_skel->links.hid_test_insert1 =
+		bpf_program__attach_hid(hid_skel->progs.hid_test_insert1,
+					sysfs_fd,
+					BPF_F_INSERT_HEAD);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_test_insert1,
+			   "attach_hid(hid_test_insert1)"))
+		return PTR_ERR(hid_skel->links.hid_test_insert1);
+
+	/* finally attach hid_test_insert3 at the end */
+	hid_skel->links.hid_test_insert3 =
+		bpf_program__attach_hid(hid_skel->progs.hid_test_insert3, sysfs_fd, 0);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_test_insert3,
+			   "attach_hid(hid_test_insert3)"))
+		return PTR_ERR(hid_skel->links.hid_test_insert3);
+
+	hidraw_ino = get_hidraw(hid_skel->links.hid_test_insert1);
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
+	/* inject one event */
+	buf[0] = 1;
+	send_event(uhid_fd, buf, 6);
+
+	/* read the data from hidraw */
+	memset(buf, 0, sizeof(buf));
+	err = read(hidraw_fd, buf, sizeof(buf));
+	if (!ASSERT_EQ(err, 6, "read_hidraw"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[1], 1, "hid_test_insert1"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[2], 2, "hid_test_insert2"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[3], 3, "hid_test_insert3"))
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
 /*
  * Attach hid_rdesc_fixup to the given uhid device,
  * retrieve and open the matching hidraw node,
@@ -598,7 +675,7 @@ static int test_rdesc_fixup(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
 
 	/* attach the program */
 	hid_skel->links.hid_rdesc_fixup =
-		bpf_program__attach_hid(hid_skel->progs.hid_rdesc_fixup, sysfs_fd);
+		bpf_program__attach_hid(hid_skel->progs.hid_rdesc_fixup, sysfs_fd, 0);
 	if (!ASSERT_OK_PTR(hid_skel->links.hid_rdesc_fixup,
 			   "attach_hid(hid_rdesc_fixup)"))
 		return PTR_ERR(hid_skel->links.hid_rdesc_fixup);
@@ -695,6 +772,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_user_raw_request_call(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_user_raw_request");
 
+	err = test_hid_attach_flags(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_user_raw_request");
+
 	err = test_rdesc_fixup(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_rdesc_fixup");
 
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index ea011ff9e752..40161aa8cb6e 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -178,3 +178,39 @@ int hid_user_raw_request(struct hid_bpf_ctx *ctx)
 
 	return ret;
 }
+
+SEC("hid/device_event")
+int hid_test_insert1(struct hid_bpf_ctx *ctx)
+{
+	/* we need to be run first */
+	if (ctx->data[2] || ctx->data[3])
+		return -1;
+
+	ctx->data[1] = 1;
+
+	return 0;
+}
+
+SEC("hid/device_event")
+int hid_test_insert2(struct hid_bpf_ctx *ctx)
+{
+	/* after insert0 and before insert2 */
+	if (!ctx->data[1] || ctx->data[3])
+		return -1;
+
+	ctx->data[2] = 2;
+
+	return 0;
+}
+
+SEC("hid/device_event")
+int hid_test_insert3(struct hid_bpf_ctx *ctx)
+{
+	/* at the end */
+	if (!ctx->data[1] || !ctx->data[2])
+		return -1;
+
+	ctx->data[3] = 3;
+
+	return 0;
+}
-- 
2.35.1

