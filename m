Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEB9637CBF
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiKXPTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiKXPTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:19:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B9816F0DD
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669302987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ypQ0SpHVkNHir4A6yQp/geR9p4ucQgVAX8Ozo4Lqh9o=;
        b=VeF6BdDNnpGiJxF1hgW9XkenGgjrocLnYKdOQBCAXH4Swq7NKhb+VZfKNT17uNt+hR9Hio
        stSP8+5AXA02Sxz3WhYEXi62oufztoYGxoZD+5WWa3ZTr4HqPeSubbnMkeWbuR5x+XH5I1
        LvG8picdAST0Akup+W8Qz6R4Y8dHgcA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-k0Kc5RVSP-2hPsqur3AHug-1; Thu, 24 Nov 2022 10:16:24 -0500
X-MC-Unique: k0Kc5RVSP-2hPsqur3AHug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C691E1C05B0C;
        Thu, 24 Nov 2022 15:16:23 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9C1840C2064;
        Thu, 24 Nov 2022 15:16:21 +0000 (UTC)
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
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [RFC hid v1 07/10] selftests: hid: Add a variant parameter so we can emulate specific devices
Date:   Thu, 24 Nov 2022 16:16:00 +0100
Message-Id: <20221124151603.807536-8-benjamin.tissoires@redhat.com>
In-Reply-To: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
References: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When testing with in-kernel bpf programs, we need to emulate a specific
device, because otherwise we won't be loading the matching bpf program.

Add a variant parameter to the fixture hid_bpf so that we can re-use it
later with different devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 tools/testing/selftests/hid/hid_bpf.c | 75 +++++++++++++++++++--------
 1 file changed, 53 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/hid/hid_bpf.c b/tools/testing/selftests/hid/hid_bpf.c
index 6615c26fb5dd..738ddb2c6a62 100644
--- a/tools/testing/selftests/hid/hid_bpf.c
+++ b/tools/testing/selftests/hid/hid_bpf.c
@@ -114,6 +114,15 @@ static pthread_cond_t uhid_started = PTHREAD_COND_INITIALIZER;
 /* no need to protect uhid_stopped, only one thread accesses it */
 static bool uhid_stopped;
 
+struct hid_device_id {
+	int bus;
+	int vendor;
+	int product;
+	int version;
+	unsigned char *rdesc;
+	const size_t rdesc_sz;
+};
+
 static int uhid_write(struct __test_metadata *_metadata, int fd, const struct uhid_event *ev)
 {
 	ssize_t ret;
@@ -131,7 +140,8 @@ static int uhid_write(struct __test_metadata *_metadata, int fd, const struct uh
 	}
 }
 
-static int uhid_create(struct __test_metadata *_metadata, int fd, int rand_nb)
+static int uhid_create(struct __test_metadata *_metadata, const struct hid_device_id *variant,
+		       int fd, int rand_nb)
 {
 	struct uhid_event ev;
 	char buf[25];
@@ -141,12 +151,12 @@ static int uhid_create(struct __test_metadata *_metadata, int fd, int rand_nb)
 	memset(&ev, 0, sizeof(ev));
 	ev.type = UHID_CREATE;
 	strcpy((char *)ev.u.create.name, buf);
-	ev.u.create.rd_data = rdesc;
-	ev.u.create.rd_size = sizeof(rdesc);
-	ev.u.create.bus = BUS_USB;
-	ev.u.create.vendor = 0x0001;
-	ev.u.create.product = 0x0a37;
-	ev.u.create.version = 0;
+	ev.u.create.rd_data = variant->rdesc;
+	ev.u.create.rd_size = variant->rdesc_sz;
+	ev.u.create.bus = variant->bus;
+	ev.u.create.vendor = variant->vendor;
+	ev.u.create.product = variant->product;
+	ev.u.create.version = variant->version;
 	ev.u.create.country = 0;
 
 	sprintf(buf, "%d", rand_nb);
@@ -299,7 +309,8 @@ static int uhid_send_event(struct __test_metadata *_metadata, int fd, __u8 *buf,
 	return uhid_write(_metadata, fd, &ev);
 }
 
-static int setup_uhid(struct __test_metadata *_metadata, int rand_nb)
+static int setup_uhid(struct __test_metadata *_metadata, const struct hid_device_id *variant,
+		      int rand_nb)
 {
 	int fd;
 	const char *path = "/dev/uhid";
@@ -308,7 +319,7 @@ static int setup_uhid(struct __test_metadata *_metadata, int rand_nb)
 	fd = open(path, O_RDWR | O_CLOEXEC);
 	ASSERT_GE(fd, 0) TH_LOG("open uhid-cdev failed; %d", fd);
 
-	ret = uhid_create(_metadata, fd, rand_nb);
+	ret = uhid_create(_metadata, variant, fd, rand_nb);
 	ASSERT_EQ(0, ret) {
 		TH_LOG("create uhid device failed: %d", ret);
 		close(fd);
@@ -317,15 +328,19 @@ static int setup_uhid(struct __test_metadata *_metadata, int rand_nb)
 	return fd;
 }
 
-static bool match_sysfs_device(int dev_id, const char *workdir, struct dirent *dir)
+static bool match_sysfs_device(int dev_id, const struct hid_device_id *variant,
+			       const char *workdir, struct dirent *dir)
 {
-	const char *target = "0003:0001:0A37.*";
+	char target[17] = "0003:0001:0A37.*";
 	char phys[512];
 	char uevent[1024];
 	char temp[512];
 	int fd, nread;
 	bool found = false;
 
+	snprintf(target, sizeof(target), "0003:%04X:%04X.*",
+		 variant->vendor, variant->product);
+
 	if (fnmatch(target, dir->d_name, 0))
 		return false;
 
@@ -347,7 +362,7 @@ static bool match_sysfs_device(int dev_id, const char *workdir, struct dirent *d
 	return found;
 }
 
-static int get_hid_id(int dev_id)
+static int get_hid_id(int dev_id, const struct hid_device_id *variant)
 {
 	const char *workdir = "/sys/devices/virtual/misc/uhid";
 	const char *str_id;
@@ -362,7 +377,7 @@ static int get_hid_id(int dev_id)
 		d = opendir(workdir);
 		if (d) {
 			while ((dir = readdir(d)) != NULL) {
-				if (!match_sysfs_device(dev_id, workdir, dir))
+				if (!match_sysfs_device(dev_id, variant, workdir, dir))
 					continue;
 
 				str_id = dir->d_name + sizeof("0003:0001:0A37.");
@@ -379,7 +394,7 @@ static int get_hid_id(int dev_id)
 	return found;
 }
 
-static int get_hidraw(int dev_id)
+static int get_hidraw(int dev_id, const struct hid_device_id *variant)
 {
 	const char *workdir = "/sys/devices/virtual/misc/uhid";
 	char sysfs[1024];
@@ -396,7 +411,7 @@ static int get_hidraw(int dev_id)
 			continue;
 
 		while ((dir = readdir(d)) != NULL) {
-			if (!match_sysfs_device(dev_id, workdir, dir))
+			if (!match_sysfs_device(dev_id, variant, workdir, dir))
 				continue;
 
 			sprintf(sysfs, "%s/%s/hidraw", workdir, dir->d_name);
@@ -423,12 +438,12 @@ static int get_hidraw(int dev_id)
 	return found;
 }
 
-static int open_hidraw(int dev_id)
+static int open_hidraw(int dev_id, const struct hid_device_id *variant)
 {
 	int hidraw_number;
 	char hidraw_path[64] = { 0 };
 
-	hidraw_number = get_hidraw(dev_id);
+	hidraw_number = get_hidraw(dev_id, variant);
 	if (hidraw_number < 0)
 		return hidraw_number;
 
@@ -445,6 +460,22 @@ FIXTURE(hid_bpf) {
 	pthread_t tid;
 	struct hid *skel;
 };
+
+FIXTURE_VARIANT(hid_bpf) {
+	const struct hid_device_id id;
+};
+
+FIXTURE_VARIANT_ADD(hid_bpf, generic_device) {
+	.id = {
+		.bus = BUS_USB,
+		.vendor = 0x0001,
+		.product = 0x0a37,
+		.version = 0,
+		.rdesc = rdesc,
+		.rdesc_sz = sizeof(rdesc),
+	},
+};
+
 static void detach_bpf(FIXTURE_DATA(hid_bpf) * self)
 {
 	if (self->hidraw_fd)
@@ -478,10 +509,10 @@ FIXTURE_SETUP(hid_bpf)
 
 	self->dev_id = rand() % 1024;
 
-	self->uhid_fd = setup_uhid(_metadata, self->dev_id);
+	self->uhid_fd = setup_uhid(_metadata, &variant->id, self->dev_id);
 
-	/* locate the uev, self, variant);ent file of the created device */
-	self->hid_id = get_hid_id(self->dev_id);
+	/* locate the file of the created device */
+	self->hid_id = get_hid_id(self->dev_id, &variant->id);
 	ASSERT_GT(self->hid_id, 0)
 		TEARDOWN_LOG("Could not locate uhid device id: %d", self->hid_id);
 
@@ -546,7 +577,7 @@ static void load_programs(const struct test_program programs[],
 		ASSERT_OK(args.retval) TH_LOG("attach_hid(%s): %d", programs[i].name, args.retval);
 	}
 
-	self->hidraw_fd = open_hidraw(self->dev_id);
+	self->hidraw_fd = open_hidraw(self->dev_id, &variant->id);
 	ASSERT_GE(self->hidraw_fd, 0) TH_LOG("open_hidraw");
 }
 
@@ -644,7 +675,7 @@ TEST_F(hid_bpf, test_attach_detach)
 	/* detach the program */
 	detach_bpf(self);
 
-	self->hidraw_fd = open_hidraw(self->dev_id);
+	self->hidraw_fd = open_hidraw(self->dev_id, &variant->id);
 	ASSERT_GE(self->hidraw_fd, 0) TH_LOG("open_hidraw");
 
 	/* inject another event */
-- 
2.38.1

