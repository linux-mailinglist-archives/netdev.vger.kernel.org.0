Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AE44CDACF
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbiCDRfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241315AbiCDRec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:34:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E50AE4484
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ipdlvVgLqb/o8JixuAcNZBiqSMV+zn+7l3KEEPsCPfk=;
        b=QD+8kYJ8f1Bzxc0QjB5cVekFo2R1NXnQGElg5rZQBQ5CC4oTNC8dXN735YUZ0xIh+yOhNc
        bFY/f5hFFlFfw4E2bdXG3h42dm2TfZ28tg8hSWHLWwkTMdOCYOAydFc1RE28Qjr+Z7jr1n
        qTL5Hm4nRekiZDh4uv9i4ZPj3CnyUBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-1_tlnEw-PxaPkP19iknvew-1; Fri, 04 Mar 2022 12:33:34 -0500
X-MC-Unique: 1_tlnEw-PxaPkP19iknvew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7CDB18766D0;
        Fri,  4 Mar 2022 17:33:31 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D402686595;
        Fri,  4 Mar 2022 17:33:27 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 17/28] selftests/bpf: add test for user call of HID bpf programs
Date:   Fri,  4 Mar 2022 18:28:41 +0100
Message-Id: <20220304172852.274126-18-benjamin.tissoires@redhat.com>
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

Add a simple test to see if we can trigger a bpf program of type
"hid/user_event".

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 56 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 10 ++++
 2 files changed, 66 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index 74426523dd6f..eb4c0d0a4666 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -359,6 +359,59 @@ static int test_hid_set_get_data(struct hid *hid_skel, int uhid_fd, int sysfs_fd
 	return ret;
 }
 
+/*
+ * Attach hid_user to the given uhid device,
+ * call the bpf program from userspace
+ * check that the program is called and does the expected.
+ */
+static int test_hid_user_call(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
+{
+	int err, prog_fd;
+	u8 buf[10] = {0};
+	int ret = -1;
+
+	LIBBPF_OPTS(bpf_test_run_opts, run_attrs,
+		    .repeat = 1,
+		    .ctx_in = &sysfs_fd,
+		    .ctx_size_in = sizeof(sysfs_fd),
+		    .data_in = buf,
+		    .data_size_in = sizeof(buf),
+		    .data_out = buf,
+		    .data_size_out = sizeof(buf),
+	);
+
+	/* attach hid_user program */
+	hid_skel->links.hid_user = bpf_program__attach_hid(hid_skel->progs.hid_user, sysfs_fd);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_user,
+			   "attach_hid(hid_user)"))
+		return PTR_ERR(hid_skel->links.hid_user);
+
+	buf[0] = 39;
+
+	prog_fd = bpf_program__fd(hid_skel->progs.hid_user);
+
+	err = bpf_prog_test_run_opts(prog_fd, &run_attrs);
+	if (!ASSERT_EQ(err, 0, "bpf_prog_test_run_xattr"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(run_attrs.retval, 72, "bpf_prog_test_run_opts"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[1], 42, "hid_user_check_in"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[2], 4, "hid_user_check_static_out"))
+		goto cleanup;
+
+	ret = 0;
+
+cleanup:
+
+	hid__detach(hid_skel);
+
+	return ret;
+}
+
 /*
  * Attach hid_rdesc_fixup to the given uhid device,
  * retrieve and open the matching hidraw node,
@@ -460,6 +513,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_set_get_data(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_set_get_data");
 
+	err = test_hid_user_call(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_user");
+
 	err = test_rdesc_fixup(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_rdesc_fixup");
 
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index de6668471940..fabfaf0f2526 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -111,3 +111,13 @@ int hid_set_get_data(struct hid_bpf_ctx *ctx)
 
 	return ret;
 }
+
+SEC("hid/user_event")
+int hid_user(struct hid_bpf_ctx *ctx)
+{
+	ctx->data[1] = ctx->data[0] + 3;
+	ctx->data[2] = 4;
+	ctx->u.user.retval = 72;
+
+	return 0;
+}
-- 
2.35.1

