Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB89D4DDE43
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238931AbiCRQTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239089AbiCRQS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:18:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76E791D760C
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QH08yjZ3KjSzH4uLolphibGhSrMWYB+98W2rwbxZTxY=;
        b=JSFek9BsN2pNbPT9DvlhiFi1NbSkltjHDpPPXhjVeZmU5JTZ9SAcifw/FMnIiXQm0e62Nk
        8n3CwOYvG9cB3crepOQzMHroUTh/q24gRDkeZ2gOnlMRf5oZaKE1lUwwb9ZJa3KRmBJj+m
        GIlUOivoHeQf14IrICyANgeNhPmOhGk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-o5uZ8XKIOyGXIBy9Leg4Ow-1; Fri, 18 Mar 2022 12:17:31 -0400
X-MC-Unique: o5uZ8XKIOyGXIBy9Leg4Ow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AA613C01B94;
        Fri, 18 Mar 2022 16:17:30 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED84A7AD1;
        Fri, 18 Mar 2022 16:17:26 +0000 (UTC)
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
Subject: [PATCH bpf-next v3 11/17] samples/bpf: add new hid_mouse example
Date:   Fri, 18 Mar 2022 17:15:22 +0100
Message-Id: <20220318161528.1531164-12-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Everything should be available in the selftest part of the tree, but
providing an example without uhid and hidraw will be more easy to
follow for users.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v3:
- use the new hid_get_data API
- add a comment for the report descriptor fixup to explain what is done

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 samples/bpf/.gitignore       |   1 +
 samples/bpf/Makefile         |   4 ++
 samples/bpf/hid_mouse_kern.c | 117 +++++++++++++++++++++++++++++++
 samples/bpf/hid_mouse_user.c | 129 +++++++++++++++++++++++++++++++++++
 4 files changed, 251 insertions(+)
 create mode 100644 samples/bpf/hid_mouse_kern.c
 create mode 100644 samples/bpf/hid_mouse_user.c

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 0e7bfdbff80a..65440bd618b2 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -2,6 +2,7 @@
 cpustat
 fds_example
 hbm
+hid_mouse
 ibumad
 lathist
 lwt_len_hist
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 38638845db9d..84ef458487df 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -60,6 +60,8 @@ tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect
 tprogs-y += xdp_monitor
 
+tprogs-y += hid_mouse
+
 # Libbpf dependencies
 LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
 LIBBPF_OUTPUT = $(abspath $(BPF_SAMPLES_PATH))/libbpf
@@ -124,6 +126,7 @@ xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o $(XDP_SAMPLE)
 xdp_redirect_map-objs := xdp_redirect_map_user.o $(XDP_SAMPLE)
 xdp_redirect-objs := xdp_redirect_user.o $(XDP_SAMPLE)
 xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
+hid_mouse-objs := hid_mouse_user.o
 
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
@@ -181,6 +184,7 @@ always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
 always-y += xdpsock_kern.o
+always-y += hid_mouse_kern.o
 
 ifeq ($(ARCH), arm)
 # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
diff --git a/samples/bpf/hid_mouse_kern.c b/samples/bpf/hid_mouse_kern.c
new file mode 100644
index 000000000000..32285b1920c0
--- /dev/null
+++ b/samples/bpf/hid_mouse_kern.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022 Benjamin Tissoires
+ */
+#include <linux/version.h>
+#include <uapi/linux/bpf.h>
+#include <uapi/linux/bpf_hid.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("hid/device_event")
+int hid_y_event(struct hid_bpf_ctx *ctx)
+{
+	s16 y;
+	__u8 *data = bpf_hid_get_data(ctx, 0 /* offset */, 9 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	bpf_printk("event: %02x size: %d", ctx->type, ctx->size);
+	bpf_printk("incoming event: %02x %02x %02x",
+		   data[0],
+		   data[1],
+		   data[2]);
+	bpf_printk("                %02x %02x %02x",
+		   data[3],
+		   data[4],
+		   data[5]);
+	bpf_printk("                %02x %02x %02x",
+		   data[6],
+		   data[7],
+		   data[8]);
+
+	y = data[3] | (data[4] << 8);
+
+	y = -y;
+
+	data[3] = y & 0xFF;
+	data[4] = (y >> 8) & 0xFF;
+
+	bpf_printk("modified event: %02x %02x %02x",
+		   data[0],
+		   data[1],
+		   data[2]);
+	bpf_printk("                %02x %02x %02x",
+		   data[3],
+		   data[4],
+		   data[5]);
+	bpf_printk("                %02x %02x %02x",
+		   data[6],
+		   data[7],
+		   data[8]);
+
+	return 0;
+}
+
+SEC("hid/device_event")
+int hid_x_event(struct hid_bpf_ctx *ctx)
+{
+	s16 x;
+	__u8 *data = bpf_hid_get_data(ctx, 0 /* offset */, 9 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	x = data[1] | (data[2] << 8);
+
+	x = -x;
+
+	data[1] = x & 0xFF;
+	data[2] = (x >> 8) & 0xFF;
+	return 0;
+}
+
+SEC("hid/rdesc_fixup")
+int hid_rdesc_fixup(struct hid_bpf_ctx *ctx)
+{
+	__u8 *data = bpf_hid_get_data(ctx, 0 /* offset */, 4096 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	if (ctx->type != HID_BPF_RDESC_FIXUP)
+		return 0;
+
+	bpf_printk("rdesc: %02x %02x %02x",
+		   data[0],
+		   data[1],
+		   data[2]);
+	bpf_printk("       %02x %02x %02x",
+		   data[3],
+		   data[4],
+		   data[5]);
+	bpf_printk("       %02x %02x %02x ...",
+		   data[6],
+		   data[7],
+		   data[8]);
+
+	/*
+	 * The original report descriptor contains:
+	 *
+	 * 0x05, 0x01,                    //   Usage Page (Generic Desktop)      30
+	 * 0x16, 0x01, 0x80,              //   Logical Minimum (-32767)          32
+	 * 0x26, 0xff, 0x7f,              //   Logical Maximum (32767)           35
+	 * 0x09, 0x30,                    //   Usage (X)                         38
+	 * 0x09, 0x31,                    //   Usage (Y)                         40
+	 *
+	 * So byte 39 contains Usage X and byte 41 Usage Y.
+	 *
+	 * We simply swap the axes here.
+	 */
+	data[39] = 0x31;
+	data[41] = 0x30;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+u32 _version SEC("version") = LINUX_VERSION_CODE;
diff --git a/samples/bpf/hid_mouse_user.c b/samples/bpf/hid_mouse_user.c
new file mode 100644
index 000000000000..a8a9e7a99b14
--- /dev/null
+++ b/samples/bpf/hid_mouse_user.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022 Benjamin Tissoires
+ */
+#include <linux/bpf.h>
+#include <linux/if_link.h>
+#include <assert.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <sys/resource.h>
+
+#include "bpf_util.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+static char *sysfs_path;
+static int sysfs_fd;
+static int prog_count;
+
+struct prog {
+	int fd;
+	struct bpf_link *link;
+	enum bpf_attach_type type;
+};
+
+static struct prog progs[10];
+
+static void int_exit(int sig)
+{
+	for (prog_count--; prog_count >= 0; prog_count--)
+		bpf_link__destroy(progs[prog_count].link);
+
+	close(sysfs_fd);
+	exit(0);
+}
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"%s: %s /sys/bus/hid/devices/0BUS:0VID:0PID:00ID/uevent\n\n",
+		__func__, prog);
+}
+
+int main(int argc, char **argv)
+{
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	const char *optstr = "";
+	struct bpf_object *obj;
+	struct bpf_program *prog;
+	int opt;
+	char filename[256];
+	int err;
+
+	while ((opt = getopt(argc, argv, optstr)) != -1) {
+		switch (opt) {
+		default:
+			usage(basename(argv[0]));
+			return 1;
+		}
+	}
+
+	if (optind == argc) {
+		usage(basename(argv[0]));
+		return 1;
+	}
+
+	sysfs_path = argv[optind];
+	if (!sysfs_path) {
+		perror("sysfs");
+		return 1;
+	}
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	err = libbpf_get_error(obj);
+	if (err) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		obj = NULL;
+		err = 1;
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	err = bpf_object__load(obj);
+	if (err) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	sysfs_fd = open(sysfs_path, O_RDONLY);
+
+	bpf_object__for_each_program(prog, obj) {
+		progs[prog_count].fd = bpf_program__fd(prog);
+		progs[prog_count].type = bpf_program__get_expected_attach_type(prog);
+		progs[prog_count].link = bpf_program__attach_hid(prog, sysfs_fd, 0);
+		if (libbpf_get_error(progs[prog_count].link)) {
+			fprintf(stderr, "bpf_prog_attach: err=%m\n");
+			progs[prog_count].fd = 0;
+			progs[prog_count].link = NULL;
+			goto cleanup;
+		}
+		prog_count++;
+	}
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	err = bpf_obj_get_info_by_fd(progs[0].fd, &info, &info_len);
+	if (err) {
+		printf("can't get prog info - %s\n", strerror(errno));
+		goto cleanup;
+	}
+
+	while (1)
+		;
+
+ cleanup:
+	for (prog_count--; prog_count >= 0; prog_count--)
+		bpf_link__destroy(progs[prog_count].link);
+
+	bpf_object__close(obj);
+	return err;
+}
-- 
2.35.1

