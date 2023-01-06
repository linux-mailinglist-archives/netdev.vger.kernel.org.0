Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102C765FEED
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbjAFK04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjAFK0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:26:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3816F7148D
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 02:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673000697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3H/Euuxq7LIt7GwPww0Ivp2k4XBNQIOZw45JfduHe6c=;
        b=jGUnWw8jdOHu1z3302RQC/cXEYkDc5FMmW+QS43EYjrg4FJbvTe6ab64msVVV/02mfwp1j
        FgJ/KnAn7qzUlmgX12N/FhAxX/ol7s7aJh+kmQMuNZgDfXnYiwRRiRgF2uEh/hHUniRXDy
        64zSW9HrBriCjut01vMf05KhngF3jr8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-VYt_rQIsME2M06_D17bI_w-1; Fri, 06 Jan 2023 05:23:52 -0500
X-MC-Unique: VYt_rQIsME2M06_D17bI_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 617FF1871D94;
        Fri,  6 Jan 2023 10:23:51 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFD14C15BAD;
        Fri,  6 Jan 2023 10:23:48 +0000 (UTC)
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
Subject: [PATCH HID for-next v1 5/9] selftests: hid: prepare tests for HID_BPF API change
Date:   Fri,  6 Jan 2023 11:23:28 +0100
Message-Id: <20230106102332.1019632-6-benjamin.tissoires@redhat.com>
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

We plan on changing the return value of hid_bpf_attach_prog().
Instead of returning an error code, it will return an fd to a bpf_link.
This bpf_link is responsible for the binding between the bpf program and
the hid device.

Add a fallback mechanism to not break bisections by pinning the program
when we run this test against the non changed kernel.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
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

