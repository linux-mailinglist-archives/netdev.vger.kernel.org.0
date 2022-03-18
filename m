Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB594DDE94
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239035AbiCRQWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238968AbiCRQU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:20:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F345187B9F
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LtpaW99kfZPGzmhb2z89Xff0Ygi8rBSg82+FQ185Veo=;
        b=Y1K1IZy2pzRXNAci4SS9Uj8FGfoEn3NZfRbMRtG7UZwXiyjQ3a9QtOO+WpIQist9CwI1QE
        Qi0xG7g44e8EUIAkTawYLsbNR2MXgCRvhE18N6xTPC6EMA8MD163BCu7mTgDaG/Euck9Wn
        9DR33L0IyZqSImX7vVIjP2ZGQ/qDbnM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-NJdxMPoKMhqmVt4r8-LRLQ-1; Fri, 18 Mar 2022 12:18:07 -0400
X-MC-Unique: NJdxMPoKMhqmVt4r8-LRLQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8FA21800754;
        Fri, 18 Mar 2022 16:18:05 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E515420AA;
        Fri, 18 Mar 2022 16:17:57 +0000 (UTC)
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
Subject: [PATCH bpf-next v3 15/17] selftests/bpf: add tests for hid_{get|set}_bits helpers
Date:   Fri, 18 Mar 2022 17:15:26 +0100
Message-Id: <20220318161528.1531164-16-benjamin.tissoires@redhat.com>
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

Simple test added here, with one use of each helper.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v3:
- renamed hid_{get|set}_data into hid_{get|set}_bits

changes in v2:
- split the patch with libbpf left outside.
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 59 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 19 +++++++
 2 files changed, 78 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index edc3af71e9ed..e8aa1c6357e8 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -531,6 +531,62 @@ static int test_hid_user_call(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
 	return ret;
 }
 
+/*
+ * Attach hid_set_get_bits to the given uhid device,
+ * retrieve and open the matching hidraw node,
+ * inject one event in the uhid device,
+ * check that the program makes correct use of bpf_hid_{set|get}_bits.
+ */
+static int test_hid_set_get_bits(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
+{
+	int err, hidraw_ino, hidraw_fd = -1;
+	char hidraw_path[64] = {0};
+	u8 buf[10] = {0};
+	int ret = -1;
+
+	/* attach hid_set_get_bits program */
+	hid_skel->links.hid_set_get_bits =
+		bpf_program__attach_hid(hid_skel->progs.hid_set_get_bits, sysfs_fd, 0);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_set_get_bits,
+			   "attach_hid(hid_set_get_bits)"))
+		return PTR_ERR(hid_skel->links.hid_set_get_bits);
+
+	hidraw_ino = get_hidraw(hid_skel->links.hid_set_get_bits);
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
+	if (!ASSERT_EQ(buf[2], (42 >> 2), "hid_set_get_bits"))
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
@@ -641,6 +697,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_user_call(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_user");
 
+	err = test_hid_set_get_bits(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_set_get_data");
+
 	/*
 	 * this test should be run last because we disconnect/reconnect
 	 * the device, meaning that it changes the overall uhid device
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index fbdbe9d1b605..d57571b9af9a 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -143,3 +143,22 @@ int hid_user(struct hid_bpf_ctx *ctx)
 
 	return 0;
 }
+
+SEC("hid/device_event")
+int hid_set_get_bits(struct hid_bpf_ctx *ctx)
+{
+	int ret;
+	__u32 data = 0;
+
+	/* extract data at bit offset 10 of size 4 (half a byte) */
+	ret = bpf_hid_get_bits(ctx, 10, 4, &data);
+	if (ret < 0)
+		return ret;
+
+	/* reinject it */
+	ret = bpf_hid_set_bits(ctx, 16, 4, data);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
-- 
2.35.1

