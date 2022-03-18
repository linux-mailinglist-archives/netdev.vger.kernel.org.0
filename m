Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791DE4DDE74
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbiCRQTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238995AbiCRQSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:18:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28B801D7891
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MMsWOein3F9RlSJ9iIFQqy8YzC2KAiacG1VeEjo2p8E=;
        b=VpWtyquCJhZUZZAx51kDj1SSeu5YQFoJZf4KdBM5H8cWJlFqK8hMb9xGD7Z3jdN7XxBtzk
        EKOJ+DU9l2WiyyRNXnQvXp7o2FZbbn7qHKB5wO97O2HKOIM6Y5oZgL10+EtbJoedJRZjD2
        HX2CM0iw67C8YOlX1Mp2kX/OQgZtQrI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-O2UuoHtVNNKjpEuy8iLloQ-1; Fri, 18 Mar 2022 12:17:10 -0400
X-MC-Unique: O2UuoHtVNNKjpEuy8iLloQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E73563C01B91;
        Fri, 18 Mar 2022 16:17:09 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADD397AD1;
        Fri, 18 Mar 2022 16:17:05 +0000 (UTC)
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
Subject: [PATCH bpf-next v3 09/17] selftests/bpf: Add a test for BPF_F_INSERT_HEAD
Date:   Fri, 18 Mar 2022 17:15:20 +0100
Message-Id: <20220318161528.1531164-10-benjamin.tissoires@redhat.com>
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

Insert 3 programs to check that we are doing the correct thing:
'2', '1', '3' are inserted, but '1' is supposed to be executed first.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v3:
- use the new hid_get_data API

new in v2
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 80 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 51 +++++++++++++
 2 files changed, 131 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index 8c8e17e7385f..b8d4dcf20b05 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -401,6 +401,83 @@ static int test_hid_raw_event(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
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
@@ -505,6 +582,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_raw_event(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid");
 
+	err = test_hid_attach_flags(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_user_raw_request");
+
 	/*
 	 * this test should be run last because we disconnect/reconnect
 	 * the device, meaning that it changes the overall uhid device
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index c9ce0e36e7b9..390c1bb8d850 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -77,3 +77,54 @@ int hid_rdesc_fixup(struct hid_bpf_ctx *ctx)
 
 	return 0;
 }
+
+SEC("hid/device_event")
+int hid_test_insert1(struct hid_bpf_ctx *ctx)
+{
+	__u8 *data = bpf_hid_get_data(ctx, 0 /* offset */, 4 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	/* we need to be run first */
+	if (data[2] || data[3])
+		return -1;
+
+	data[1] = 1;
+
+	return 0;
+}
+
+SEC("hid/device_event")
+int hid_test_insert2(struct hid_bpf_ctx *ctx)
+{
+	__u8 *data = bpf_hid_get_data(ctx, 0 /* offset */, 4 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	/* after insert0 and before insert2 */
+	if (!data[1] || data[3])
+		return -1;
+
+	data[2] = 2;
+
+	return 0;
+}
+
+SEC("hid/device_event")
+int hid_test_insert3(struct hid_bpf_ctx *ctx)
+{
+	__u8 *data = bpf_hid_get_data(ctx, 0 /* offset */, 4 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	/* at the end */
+	if (!data[1] || !data[2])
+		return -1;
+
+	data[3] = 3;
+
+	return 0;
+}
-- 
2.35.1

