Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CEC4CDAB5
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241236AbiCDRd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241234AbiCDRdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:33:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2493333E14
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ux6twZOFT9lb2qTfIZn2kGfR1Z5YetNZFcKf5G8re3c=;
        b=V2o/Y64/Z/iu0s3iSvY0JMrwHhYddrC0uWnh5xQ9rOwASV4E2gao6le1yZbMS9rBga1Lwu
        9PvTqvldTILhaGgLuYHO79pLTrx1KtX+SMqriJnVucNtjKzohSzZvr7fUoH1P0241unKtt
        6ty3wvSaIIo+8cebZUwT/Gt7yCZ9EmA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-PycJhc6zM8GUH9sRgyf9ng-1; Fri, 04 Mar 2022 12:32:47 -0500
X-MC-Unique: PycJhc6zM8GUH9sRgyf9ng-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8702B824FA7;
        Fri,  4 Mar 2022 17:32:44 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABB6786595;
        Fri,  4 Mar 2022 17:32:40 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 14/28] selftests/bpf: add tests for hid_{get|set}_data helpers
Date:   Fri,  4 Mar 2022 18:28:38 +0100
Message-Id: <20220304172852.274126-15-benjamin.tissoires@redhat.com>
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

Simple test added here, with one use of each helper.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the patch with libbpf left outside.
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 65 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 45 ++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index 91543b8078ca..74426523dd6f 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -297,6 +297,68 @@ static int test_hid_raw_event(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
 	return ret;
 }
 
+/*
+ * Attach hid_set_get_data to the given uhid device,
+ * retrieve and open the matching hidraw node,
+ * inject one event in the uhid device,
+ * check that the program makes correct use of bpf_hid_{set|get}_data.
+ */
+static int test_hid_set_get_data(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
+{
+	int err, hidraw_ino, hidraw_fd = -1;
+	char hidraw_path[64] = {0};
+	u8 buf[10] = {0};
+	int ret = -1;
+
+	/* attach hid_set_get_data program */
+	hid_skel->links.hid_set_get_data =
+		bpf_program__attach_hid(hid_skel->progs.hid_set_get_data, sysfs_fd);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_set_get_data,
+			   "attach_hid(hid_set_get_data)"))
+		return PTR_ERR(hid_skel->links.hid_set_get_data);
+
+	hidraw_ino = get_hidraw(hid_skel->links.hid_set_get_data);
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
+	buf[1] = 42;
+	send_event(uhid_fd, buf, 6);
+
+	/* read the data from hidraw */
+	memset(buf, 0, sizeof(buf));
+	err = read(hidraw_fd, buf, sizeof(buf));
+	if (!ASSERT_EQ(err, 6, "read_hidraw"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[2], (42 >> 2), "hid_set_get_data"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[3], 1, "hid_set_get_data"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[4], 42, "hid_set_get_data"))
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
@@ -395,6 +457,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_raw_event(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid");
 
+	err = test_hid_set_get_data(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_set_get_data");
+
 	err = test_rdesc_fixup(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_rdesc_fixup");
 
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index 2270448d0d3f..de6668471940 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -66,3 +66,48 @@ int hid_rdesc_fixup(struct hid_bpf_ctx *ctx)
 
 	return 0;
 }
+
+SEC("hid/device_event")
+int hid_set_get_data(struct hid_bpf_ctx *ctx)
+{
+	int ret;
+	__u8 *buf;
+
+	buf = bpf_ringbuf_reserve(&ringbuf, 8, 0);
+	if (!buf)
+		return -12; /* -ENOMEM */
+
+	/* first try read/write with n > 32 */
+	ret = bpf_hid_get_data(ctx, 0, 64, buf, 8);
+	if (ret < 0)
+		goto discard;
+
+	/* reinject it */
+	ret = bpf_hid_set_data(ctx, 24, 64, buf, 8);
+	if (ret < 0)
+		goto discard;
+
+	/* extract data at bit offset 10 of size 4 (half a byte) */
+	ret = bpf_hid_get_data(ctx, 10, 4, buf, 8);  /* expected to fail */
+	if (ret > 0) {
+		ret = -1;
+		goto discard;
+	}
+
+	ret = bpf_hid_get_data(ctx, 10, 4, buf, 4);
+	if (ret < 0)
+		goto discard;
+
+	/* reinject it */
+	ret = bpf_hid_set_data(ctx, 16, 4, buf, 4);
+	if (ret < 0)
+		goto discard;
+
+	ret = 0;
+
+ discard:
+
+	bpf_ringbuf_discard(buf, 0);
+
+	return ret;
+}
-- 
2.35.1

