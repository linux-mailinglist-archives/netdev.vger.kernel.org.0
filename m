Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9D066929B
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 10:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241260AbjAMJNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 04:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240969AbjAMJMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 04:12:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AE2B867
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 01:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673600997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MReTfoZEtCBJ7/7PQF8RRjqn13uVX9nIzOsfgV2wfAI=;
        b=Q67YvBPKe6sBk1UtX0h0Qt+HWoqtJ8xWeEm8RxaW1f7wBZABbWZdjveZQC9kRf/8hHLs9m
        JUfH7ZGdxeccnUPl+1WbxlXzRUrmt5pE1ScVbRj0I53qWE7dMTlMMKxtoJsooz1H1o70Lw
        yDHbpvatfZu0sl+zf/hwNX1LjXm7yOo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-d_eDA-nsMrqEu5o1F0dG5A-1; Fri, 13 Jan 2023 04:09:52 -0500
X-MC-Unique: d_eDA-nsMrqEu5o1F0dG5A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28E18802C1C;
        Fri, 13 Jan 2023 09:09:52 +0000 (UTC)
Received: from plouf.redhat.com (ovpn-193-50.brq.redhat.com [10.40.193.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECEA11121315;
        Fri, 13 Jan 2023 09:09:49 +0000 (UTC)
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
Subject: [PATCH HID for-next v2 5/9] selftests: hid: prepare tests for HID_BPF API change
Date:   Fri, 13 Jan 2023 10:09:31 +0100
Message-Id: <20230113090935.1763477-6-benjamin.tissoires@redhat.com>
In-Reply-To: <20230113090935.1763477-1-benjamin.tissoires@redhat.com>
References: <20230113090935.1763477-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We plan on changing the return value of hid_bpf_attach_prog().
Instead of returning an error code, it will return an fd to a bpf_link.
This bpf_link is responsible for the binding between the bpf program and
the hid device.

Add a fallback mechanism to not break bisections by pinning the program
when we run this test against the non changed kernel.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

no changes in v2
---
 tools/testing/selftests/hid/hid_bpf.c | 29 +++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/hid/hid_bpf.c b/tools/testing/selftests/hid/hid_bpf.c
index 3b204a15e44b..9a262fe99b32 100644
--- a/tools/testing/selftests/hid/hid_bpf.c
+++ b/tools/testing/selftests/hid/hid_bpf.c
@@ -444,13 +444,21 @@ FIXTURE(hid_bpf) {
 	int hid_id;
 	pthread_t tid;
 	struct hid *skel;
+	int hid_links[3]; /* max number of programs loaded in a single test */
 };
 static void detach_bpf(FIXTURE_DATA(hid_bpf) * self)
 {
+	int i;
+
 	if (self->hidraw_fd)
 		close(self->hidraw_fd);
 	self->hidraw_fd = 0;
 
+	for (i = 0; i < ARRAY_SIZE(self->hid_links); i++) {
+		if (self->hid_links[i])
+			close(self->hid_links[i]);
+	}
+
 	hid__destroy(self->skel);
 	self->skel = NULL;
 }
@@ -512,6 +520,9 @@ static void load_programs(const struct test_program programs[],
 			    .ctx_size_in = sizeof(args),
 	);
 
+	ASSERT_LE(progs_count, ARRAY_SIZE(self->hid_links))
+		TH_LOG("too many programs are to be loaded");
+
 	/* open the bpf file */
 	self->skel = hid__open();
 	ASSERT_OK_PTR(self->skel) TEARDOWN_LOG("Error while calling hid__open");
@@ -543,7 +554,10 @@ static void load_programs(const struct test_program programs[],
 		args.hid = self->hid_id;
 		args.insert_head = programs[i].insert_head;
 		err = bpf_prog_test_run_opts(attach_fd, &tattr);
-		ASSERT_OK(args.retval) TH_LOG("attach_hid(%s): %d", programs[i].name, args.retval);
+		ASSERT_GE(args.retval, 0)
+			TH_LOG("attach_hid(%s): %d", programs[i].name, args.retval);
+
+		self->hid_links[i] = args.retval;
 	}
 
 	self->hidraw_fd = open_hidraw(self->dev_id);
@@ -619,10 +633,17 @@ TEST_F(hid_bpf, test_attach_detach)
 		{ .name = "hid_second_event" },
 	};
 	__u8 buf[10] = {0};
-	int err;
+	int err, link;
 
 	LOAD_PROGRAMS(progs);
 
+	link = self->hid_links[0];
+	/* we might not be using the new code path where hid_bpf_attach_prog()
+	 * returns a link.
+	 */
+	if (!link)
+		link = bpf_program__fd(self->skel->progs.hid_first_event);
+
 	/* inject one event */
 	buf[0] = 1;
 	buf[1] = 42;
@@ -640,8 +661,8 @@ TEST_F(hid_bpf, test_attach_detach)
 
 	/* pin the first program and immediately unpin it */
 #define PIN_PATH "/sys/fs/bpf/hid_first_event"
-	err = bpf_program__pin(self->skel->progs.hid_first_event, PIN_PATH);
-	ASSERT_OK(err) TH_LOG("error while calling bpf_program__pin");
+	err = bpf_obj_pin(link, PIN_PATH);
+	ASSERT_OK(err) TH_LOG("error while calling bpf_obj_pin");
 	remove(PIN_PATH);
 #undef PIN_PATH
 	usleep(100000);
-- 
2.38.1

