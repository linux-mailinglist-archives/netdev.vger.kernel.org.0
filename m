Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1844CDA85
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241196AbiCDRcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241142AbiCDRcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:32:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B11951CE986
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I7r/0u1wKcqwzT9dQZnDB5pb1zco56GPsVeprvV5Efs=;
        b=QUT6l6x5pavni2nHGNl44sHEVNpid//KdsmqzYuLLh/OQ2FwXRn3ZgpiuGEZpDJ1wkOV45
        19dmg8NqwODmiQ0NAA+5NNXPq0s1XtDqMU6j24nZsjqJWLdykIkwYNubkmA4vj/hv65Gn1
        TimvZAP4dlPQX3669ceU0DnHrSQJUqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-6IzWbtDMMw2t5rOlvY6QRw-1; Fri, 04 Mar 2022 12:31:15 -0500
X-MC-Unique: 6IzWbtDMMw2t5rOlvY6QRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B974801AFE;
        Fri,  4 Mar 2022 17:31:11 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D8C986595;
        Fri,  4 Mar 2022 17:31:07 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 05/28] selftests/bpf: add tests for the HID-bpf initial implementation
Date:   Fri,  4 Mar 2022 18:28:29 +0100
Message-Id: <20220304172852.274126-6-benjamin.tissoires@redhat.com>
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

The test is pretty basic:
- create a virtual uhid device that no userspace will like (to not mess
  up the running system)
- attach a BPF prog to it
- open the matching hidraw node
- inject one event and check:
  * that the BPF program can do something on the event stream
  * can modify the event stream

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 335 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      |  20 ++
 2 files changed, 355 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
 create mode 100644 tools/testing/selftests/bpf/progs/hid.c

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
new file mode 100644
index 000000000000..ee495d5a8bd5
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -0,0 +1,335 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Red Hat */
+#include <test_progs.h>
+#include <testing_helpers.h>
+#include "hid.skel.h"
+
+#include <fcntl.h>
+#include <fnmatch.h>
+#include <dirent.h>
+#include <poll.h>
+#include <stdbool.h>
+#include <linux/uhid.h>
+
+static unsigned char rdesc[] = {
+	0x06, 0x00, 0xff,	/* Usage Page (Vendor Defined Page 1) */
+	0x09, 0x21,		/* Usage (Vendor Usage 0x21) */
+	0xa1, 0x01,		/* COLLECTION (Application) */
+	0x09, 0x01,			/* Usage (Vendor Usage 0x01) */
+	0xa1, 0x00,			/* COLLECTION (Physical) */
+	0x85, 0x01,				/* REPORT_ID (1) */
+	0x06, 0x00, 0xff,			/* Usage Page (Vendor Defined Page 1) */
+	0x19, 0x01,				/* USAGE_MINIMUM (1) */
+	0x29, 0x03,				/* USAGE_MAXIMUM (3) */
+	0x15, 0x00,				/* LOGICAL_MINIMUM (0) */
+	0x25, 0x01,				/* LOGICAL_MAXIMUM (1) */
+	0x95, 0x03,				/* REPORT_COUNT (3) */
+	0x75, 0x01,				/* REPORT_SIZE (1) */
+	0x81, 0x02,				/* INPUT (Data,Var,Abs) */
+	0x95, 0x01,				/* REPORT_COUNT (1) */
+	0x75, 0x05,				/* REPORT_SIZE (5) */
+	0x81, 0x01,				/* INPUT (Cnst,Var,Abs) */
+	0x05, 0x01,				/* USAGE_PAGE (Generic Desktop) */
+	0x09, 0x30,				/* USAGE (X) */
+	0x09, 0x31,				/* USAGE (Y) */
+	0x15, 0x81,				/* LOGICAL_MINIMUM (-127) */
+	0x25, 0x7f,				/* LOGICAL_MAXIMUM (127) */
+	0x75, 0x10,				/* REPORT_SIZE (16) */
+	0x95, 0x02,				/* REPORT_COUNT (2) */
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
+static int uhid_write(int fd, const struct uhid_event *ev)
+{
+	ssize_t ret;
+
+	ret = write(fd, ev, sizeof(*ev));
+	if (ret < 0) {
+		fprintf(stderr, "Cannot write to uhid: %m\n");
+		return -errno;
+	} else if (ret != sizeof(*ev)) {
+		fprintf(stderr, "Wrong size written to uhid: %zd != %zu\n",
+			ret, sizeof(ev));
+		return -EFAULT;
+	} else {
+		return 0;
+	}
+}
+
+static int create(int fd, int rand_nb)
+{
+	struct uhid_event ev;
+	char buf[25];
+
+	sprintf(buf, "test-uhid-device-%d", rand_nb);
+
+	memset(&ev, 0, sizeof(ev));
+	ev.type = UHID_CREATE;
+	strcpy((char *)ev.u.create.name, buf);
+	ev.u.create.rd_data = rdesc;
+	ev.u.create.rd_size = sizeof(rdesc);
+	ev.u.create.bus = BUS_USB;
+	ev.u.create.vendor = 0x0001;
+	ev.u.create.product = 0x0a37;
+	ev.u.create.version = 0;
+	ev.u.create.country = 0;
+
+	sprintf(buf, "%d", rand_nb);
+	strcpy((char *)ev.u.create.phys, buf);
+
+	return uhid_write(fd, &ev);
+}
+
+static void destroy(int fd)
+{
+	struct uhid_event ev;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.type = UHID_DESTROY;
+
+	uhid_write(fd, &ev);
+}
+
+static int send_event(int fd, u8 *buf, size_t size)
+{
+	struct uhid_event ev;
+
+	if (size > sizeof(ev.u.input.data))
+		return -E2BIG;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.type = UHID_INPUT2;
+	ev.u.input2.size = size;
+
+	memcpy(ev.u.input2.data, buf, size);
+
+	return uhid_write(fd, &ev);
+}
+
+static int setup_uhid(int rand_nb)
+{
+	int fd;
+	const char *path = "/dev/uhid";
+	int ret;
+
+	fd = open(path, O_RDWR | O_CLOEXEC);
+	if (!ASSERT_GE(fd, 0, "open uhid-cdev"))
+		return -EPERM;
+
+	ret = create(fd, rand_nb);
+	if (!ASSERT_OK(ret, "create uhid device")) {
+		close(fd);
+		return -EPERM;
+	}
+
+	return fd;
+}
+
+static int get_sysfs_fd(int rand_nb)
+{
+	const char *workdir = "/sys/devices/virtual/misc/uhid";
+	const char *target = "0003:0001:0A37.*";
+	char uevent[1024];
+	char temp[512];
+	char phys[512];
+	DIR *d;
+	struct dirent *dir;
+	int fd, nread;
+	int found = -1;
+
+	/* it would be nice to be able to use nftw, but the no_alu32 target doesn't support it */
+
+	sprintf(phys, "PHYS=%d", rand_nb);
+
+	d = opendir(workdir);
+	if (d) {
+		while ((dir = readdir(d)) != NULL) {
+			if (fnmatch(target, dir->d_name, 0))
+				continue;
+
+			/* we found the correct VID/PID, now check for phys */
+			sprintf(uevent, "%s/%s/uevent", workdir, dir->d_name);
+			fd = open(uevent, O_RDONLY | O_NONBLOCK);
+			if (fd < 0)
+				continue;
+
+			nread = read(fd, temp, ARRAY_SIZE(temp));
+			if (nread > 0 && (strstr(temp, phys)) != NULL) {
+				found = fd;
+				break;
+			}
+
+			close(fd);
+			fd = 0;
+		}
+		closedir(d);
+	}
+
+	return found;
+}
+
+static int get_hidraw(struct bpf_link *link)
+{
+	struct bpf_link_info info = {0};
+	int prog_id, i;
+
+	/* retry 5 times in case the system is loaded */
+	for (i = 5; i > 0; i--) {
+		usleep(10);
+		prog_id = link_info_prog_id(link, &info);
+		if (!prog_id)
+			continue;
+		if (info.hid.hidraw_ino >= 0)
+			break;
+	}
+
+	if (!prog_id)
+		return -1;
+
+	return info.hid.hidraw_ino;
+}
+
+/*
+ * Attach hid_first_event to the given uhid device,
+ * retrieve and open the matching hidraw node,
+ * inject one event in the uhid device,
+ * check that the program sees it and can change the data
+ */
+static int test_hid_raw_event(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
+{
+	int err, hidraw_ino, hidraw_fd = -1;
+	char hidraw_path[64] = {0};
+	u8 buf[10] = {0};
+	int ret = -1;
+
+	/* check that the program is correctly loaded */
+	ASSERT_EQ(hid_skel->data->callback_check, 52, "callback_check1");
+	ASSERT_EQ(hid_skel->data->callback2_check, 52, "callback2_check1");
+
+	/* attach the first program */
+	hid_skel->links.hid_first_event =
+		bpf_program__attach_hid(hid_skel->progs.hid_first_event, sysfs_fd);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_first_event,
+			   "attach_hid(hid_first_event)"))
+		return PTR_ERR(hid_skel->links.hid_first_event);
+
+	hidraw_ino = get_hidraw(hid_skel->links.hid_first_event);
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
+	/* check that hid_first_event() was executed */
+	ASSERT_EQ(hid_skel->data->callback_check, 42, "callback_check1");
+
+	/* read the data from hidraw */
+	memset(buf, 0, sizeof(buf));
+	err = read(hidraw_fd, buf, sizeof(buf));
+	if (!ASSERT_EQ(err, 6, "read_hidraw"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[2], 47, "hid_first_event"))
+		goto cleanup;
+
+	/* inject another event */
+	buf[0] = 1;
+	buf[1] = 47;
+	send_event(uhid_fd, buf, 6);
+
+	/* check that hid_first_event() was executed */
+	ASSERT_EQ(hid_skel->data->callback_check, 47, "callback_check1");
+
+	/* read the data from hidraw */
+	memset(buf, 0, sizeof(buf));
+	err = read(hidraw_fd, buf, sizeof(buf));
+	if (!ASSERT_EQ(err, 6, "read_hidraw"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[2], 52, "hid_first_event"))
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
+void serial_test_hid_bpf(void)
+{
+	struct hid *hid_skel = NULL;
+	int err, uhid_fd, sysfs_fd;
+	time_t t;
+	int rand_nb;
+
+	/* initialize random number generator */
+	srand((unsigned int)time(&t));
+
+	rand_nb = rand() % 1024;
+
+	uhid_fd = setup_uhid(rand_nb);
+	if (!ASSERT_GE(uhid_fd, 0, "setup uhid"))
+		return;
+
+	/* give a little bit of time for the device to appear */
+	/* TODO: check on uhid events */
+	usleep(1000);
+
+	/* locate the uevent file of the created device */
+	sysfs_fd = get_sysfs_fd(rand_nb);
+	if (!ASSERT_GE(sysfs_fd, 0, "locate sysfs uhid device"))
+		goto cleanup;
+
+	hid_skel = hid__open_and_load();
+	if (!ASSERT_OK_PTR(hid_skel, "hid_skel_load"))
+		goto cleanup;
+
+	/* start the tests! */
+	err = test_hid_raw_event(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid");
+
+cleanup:
+	hid__destroy(hid_skel);
+	destroy(uhid_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
new file mode 100644
index 000000000000..2201dd3b105d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Red hat */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <linux/bpf_hid.h>
+
+char _license[] SEC("license") = "GPL";
+
+__u64 callback_check = 52;
+__u64 callback2_check = 52;
+
+SEC("hid/device_event")
+int hid_first_event(struct hid_bpf_ctx *ctx)
+{
+	callback_check = ctx->data[1];
+
+	ctx->data[2] = ctx->data[1] + 5;
+
+	return 0;
+}
-- 
2.35.1

