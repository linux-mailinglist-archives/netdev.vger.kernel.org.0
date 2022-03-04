Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864F84CDAEF
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbiCDRfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiCDRei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:34:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC298157216
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDa8V+PwdBzLVKm2f7jt5tKntZYRCDbywdKX+LuGF8o=;
        b=QcyDkkhKlBiD53auiMeSdQT3C+S7oHiozXtxAa46eGkv3EfJ7UpSRIoFPR7B68veilbDUt
        Ob9E9okCqsfLkbpprpeOzXYO4rF6+dgK4FcFXzc5QZPt5fXEG2/r1amMIZNoM8sp9ubUPo
        6zz7wMy30Uf5DzEVrFWfBIWHFH62Og8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-MRXFdnLJOSycTbX4FoI6Hg-1; Fri, 04 Mar 2022 12:33:38 -0500
X-MC-Unique: MRXFdnLJOSycTbX4FoI6Hg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0162E1006AA7;
        Fri,  4 Mar 2022 17:33:36 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1722186595;
        Fri,  4 Mar 2022 17:33:31 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 18/28] selftests/bpf: hid: rely on uhid event to know if a test device is ready
Date:   Fri,  4 Mar 2022 18:28:42 +0100
Message-Id: <20220304172852.274126-19-benjamin.tissoires@redhat.com>
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

We need this for 2 reasons:
- first we remove the ugly sleeps
- then when we try to communicate with the device, we need to have another
  thread that handles that communication and simulate a real device

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 126 ++++++++++++++++++-
 1 file changed, 120 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index eb4c0d0a4666..cc01601c1168 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -67,6 +67,12 @@ static unsigned char rdesc[] = {
 	0xc0,			/* END_COLLECTION */
 };
 
+static pthread_mutex_t uhid_started_mtx = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t uhid_started = PTHREAD_COND_INITIALIZER;
+
+/* no need to protect uhid_stopped, only one thread accesses it */
+static bool uhid_stopped;
+
 static int uhid_write(int fd, const struct uhid_event *ev)
 {
 	ssize_t ret;
@@ -118,6 +124,104 @@ static void destroy(int fd)
 	uhid_write(fd, &ev);
 }
 
+static int event(int fd)
+{
+	struct uhid_event ev;
+	ssize_t ret;
+
+	memset(&ev, 0, sizeof(ev));
+	ret = read(fd, &ev, sizeof(ev));
+	if (ret == 0) {
+		fprintf(stderr, "Read HUP on uhid-cdev\n");
+		return -EFAULT;
+	} else if (ret < 0) {
+		fprintf(stderr, "Cannot read uhid-cdev: %m\n");
+		return -errno;
+	} else if (ret != sizeof(ev)) {
+		fprintf(stderr, "Invalid size read from uhid-dev: %zd != %zu\n",
+			ret, sizeof(ev));
+		return -EFAULT;
+	}
+
+	switch (ev.type) {
+	case UHID_START:
+		pthread_mutex_lock(&uhid_started_mtx);
+		pthread_cond_signal(&uhid_started);
+		pthread_mutex_unlock(&uhid_started_mtx);
+
+		fprintf(stderr, "UHID_START from uhid-dev\n");
+		break;
+	case UHID_STOP:
+		uhid_stopped = true;
+
+		fprintf(stderr, "UHID_STOP from uhid-dev\n");
+		break;
+	case UHID_OPEN:
+		fprintf(stderr, "UHID_OPEN from uhid-dev\n");
+		break;
+	case UHID_CLOSE:
+		fprintf(stderr, "UHID_CLOSE from uhid-dev\n");
+		break;
+	case UHID_OUTPUT:
+		fprintf(stderr, "UHID_OUTPUT from uhid-dev\n");
+		break;
+	case UHID_GET_REPORT:
+		fprintf(stderr, "UHID_GET_REPORT from uhid-dev\n");
+		break;
+	case UHID_SET_REPORT:
+		fprintf(stderr, "UHID_SET_REPORT from uhid-dev\n");
+		break;
+	default:
+		fprintf(stderr, "Invalid event from uhid-dev: %u\n", ev.type);
+	}
+
+	return 0;
+}
+
+static void *read_uhid_events_thread(void *arg)
+{
+	int fd = *(int *)arg;
+	struct pollfd pfds[1];
+	int ret = 0;
+
+	pfds[0].fd = fd;
+	pfds[0].events = POLLIN;
+
+	uhid_stopped = false;
+
+	while (!uhid_stopped) {
+		ret = poll(pfds, 1, 100);
+		if (ret < 0) {
+			fprintf(stderr, "Cannot poll for fds: %m\n");
+			break;
+		}
+		if (pfds[0].revents & POLLIN) {
+			ret = event(fd);
+			if (ret)
+				break;
+		}
+	}
+
+	return (void *)(long)ret;
+}
+
+static int uhid_start_listener(pthread_t *tid, int uhid_fd)
+{
+	int fd = uhid_fd;
+
+	pthread_mutex_lock(&uhid_started_mtx);
+	if (CHECK_FAIL(pthread_create(tid, NULL, read_uhid_events_thread,
+				      (void *)&fd))) {
+		pthread_mutex_unlock(&uhid_started_mtx);
+		close(fd);
+		return -EIO;
+	}
+	pthread_cond_wait(&uhid_started, &uhid_started_mtx);
+	pthread_mutex_unlock(&uhid_started_mtx);
+
+	return 0;
+}
+
 static int send_event(int fd, u8 *buf, size_t size)
 {
 	struct uhid_event ev;
@@ -422,7 +526,9 @@ static int test_rdesc_fixup(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
 	struct hidraw_report_descriptor rpt_desc = {0};
 	int err, desc_size, hidraw_ino, hidraw_fd = -1;
 	char hidraw_path[64] = {0};
+	void *uhid_err;
 	int ret = -1;
+	pthread_t tid;
 
 	/* attach the program */
 	hid_skel->links.hid_rdesc_fixup =
@@ -431,9 +537,8 @@ static int test_rdesc_fixup(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
 			   "attach_hid(hid_rdesc_fixup)"))
 		return PTR_ERR(hid_skel->links.hid_rdesc_fixup);
 
-	/* give a little bit of time for the device to appear */
-	/* TODO: check on uhid events */
-	usleep(1000);
+	err = uhid_start_listener(&tid, uhid_fd);
+	ASSERT_OK(err, "uhid_start_listener");
 
 	hidraw_ino = get_hidraw(hid_skel->links.hid_rdesc_fixup);
 	if (!ASSERT_GE(hidraw_ino, 0, "get_hidraw"))
@@ -474,6 +579,10 @@ static int test_rdesc_fixup(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
 
 	hid__detach(hid_skel);
 
+	pthread_join(tid, &uhid_err);
+	err = (int)(long)uhid_err;
+	CHECK_FAIL(err);
+
 	return ret;
 }
 
@@ -481,7 +590,9 @@ void serial_test_hid_bpf(void)
 {
 	struct hid *hid_skel = NULL;
 	int err, uhid_fd, sysfs_fd;
+	void *uhid_err;
 	time_t t;
+	pthread_t tid;
 	int rand_nb;
 
 	/* initialize random number generator */
@@ -493,9 +604,8 @@ void serial_test_hid_bpf(void)
 	if (!ASSERT_GE(uhid_fd, 0, "setup uhid"))
 		return;
 
-	/* give a little bit of time for the device to appear */
-	/* TODO: check on uhid events */
-	usleep(1000);
+	err = uhid_start_listener(&tid, uhid_fd);
+	ASSERT_OK(err, "uhid_start_listener");
 
 	/* locate the uevent file of the created device */
 	sysfs_fd = get_sysfs_fd(rand_nb);
@@ -522,4 +632,8 @@ void serial_test_hid_bpf(void)
 cleanup:
 	hid__destroy(hid_skel);
 	destroy(uhid_fd);
+
+	pthread_join(tid, &uhid_err);
+	err = (int)(long)uhid_err;
+	CHECK_FAIL(err);
 }
-- 
2.35.1

