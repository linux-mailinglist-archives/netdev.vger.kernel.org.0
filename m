Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D713D65FEC4
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbjAFKZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbjAFKYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:24:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7923A6B5FF
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 02:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673000632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wf1YklaqcAiXjW3N2/GPx9e6Ol6MPpmodCEeSsCG99s=;
        b=RAGCJ8OMm7UZWfQ8SX/OPVfN2d3/fKDhJzHInFI/k5m/i8Oi7XkNScEYml+aVmNjv0h+mF
        uVMMl8jH64ZM6PW6tXrPl8WY616AoihlezU65wED0A2YrzA7EMadD3sgbsxhmEX04J52RN
        CRgqSQUt0z5ZNtG5OWsokrR6Zj9zPfI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-GwZWDMXMPGeajLp47YMaZQ-1; Fri, 06 Jan 2023 05:23:47 -0500
X-MC-Unique: GwZWDMXMPGeajLp47YMaZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 721378533DA;
        Fri,  6 Jan 2023 10:23:46 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80C49C15BAD;
        Fri,  6 Jan 2023 10:23:44 +0000 (UTC)
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
        linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH HID for-next v1 3/9] selftests: hid: attach/detach 2 bpf programs, not just one
Date:   Fri,  6 Jan 2023 11:23:26 +0100
Message-Id: <20230106102332.1019632-4-benjamin.tissoires@redhat.com>
In-Reply-To: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
References: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a second BPF program to attach to the device, as the development of
this feature showed that we also need to ensure we can detach multiple
programs to a device (hid_bpf_link->index was actually not set initially,
and this lead to any BPF program not being released except for the first
one).

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 tools/testing/selftests/hid/hid_bpf.c   |  8 +++++++-
 tools/testing/selftests/hid/progs/hid.c | 13 +++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/hid/hid_bpf.c b/tools/testing/selftests/hid/hid_bpf.c
index 6615c26fb5dd..d215bb492eb4 100644
--- a/tools/testing/selftests/hid/hid_bpf.c
+++ b/tools/testing/selftests/hid/hid_bpf.c
@@ -616,6 +616,7 @@ TEST_F(hid_bpf, test_attach_detach)
 {
 	const struct test_program progs[] = {
 		{ .name = "hid_first_event" },
+		{ .name = "hid_second_event" },
 	};
 	__u8 buf[10] = {0};
 	int err;
@@ -634,7 +635,10 @@ TEST_F(hid_bpf, test_attach_detach)
 	ASSERT_EQ(buf[0], 1);
 	ASSERT_EQ(buf[2], 47);
 
-	/* pin the program and immediately unpin it */
+	/* make sure both programs are run */
+	ASSERT_EQ(buf[3], 52);
+
+	/* pin the first program and immediately unpin it */
 #define PIN_PATH "/sys/fs/bpf/hid_first_event"
 	bpf_program__pin(self->skel->progs.hid_first_event, PIN_PATH);
 	remove(PIN_PATH);
@@ -660,6 +664,7 @@ TEST_F(hid_bpf, test_attach_detach)
 	ASSERT_EQ(buf[0], 1);
 	ASSERT_EQ(buf[1], 47);
 	ASSERT_EQ(buf[2], 0);
+	ASSERT_EQ(buf[3], 0);
 
 	/* re-attach our program */
 
@@ -677,6 +682,7 @@ TEST_F(hid_bpf, test_attach_detach)
 	ASSERT_EQ(err, 6) TH_LOG("read_hidraw");
 	ASSERT_EQ(buf[0], 1);
 	ASSERT_EQ(buf[2], 47);
+	ASSERT_EQ(buf[3], 52);
 }
 
 /*
diff --git a/tools/testing/selftests/hid/progs/hid.c b/tools/testing/selftests/hid/progs/hid.c
index 6a86af0aa545..88c593f753b5 100644
--- a/tools/testing/selftests/hid/progs/hid.c
+++ b/tools/testing/selftests/hid/progs/hid.c
@@ -32,6 +32,19 @@ int BPF_PROG(hid_first_event, struct hid_bpf_ctx *hid_ctx)
 	return hid_ctx->size;
 }
 
+SEC("?fmod_ret/hid_bpf_device_event")
+int BPF_PROG(hid_second_event, struct hid_bpf_ctx *hid_ctx)
+{
+	__u8 *rw_data = hid_bpf_get_data(hid_ctx, 0 /* offset */, 4 /* size */);
+
+	if (!rw_data)
+		return 0; /* EPERM check */
+
+	rw_data[3] = rw_data[2] + 5;
+
+	return hid_ctx->size;
+}
+
 SEC("?fmod_ret/hid_bpf_device_event")
 int BPF_PROG(hid_change_report_id, struct hid_bpf_ctx *hid_ctx)
 {
-- 
2.38.1

