Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3324CDA8D
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241160AbiCDRca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241171AbiCDRcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:32:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01CC81CFA03
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yRMFUZZ3JBAMX0c9TwljMlvXIqWPVDlRh3QSDyZIcHU=;
        b=OQ0V4K8xM70qACuKAy2mxBxmG/XCXVIalpsy0635FRbzv40b18gaXgJpsw6/Q/8OrbcIya
        KVXqhiO1BF15NICXPT6i/HHwYQq/aNdywaSH/c+ppTGDW6iiObC1JRI5hcSu+0KZNkF+Tp
        pN0gR1+vJhlu8KjvbgQEne+2vxOH0KQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-B3pqBQAdPpO5qT85sCSGaA-1; Fri, 04 Mar 2022 12:31:18 -0500
X-MC-Unique: B3pqBQAdPpO5qT85sCSGaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB1941091DA1;
        Fri,  4 Mar 2022 17:31:15 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEB4E86595;
        Fri,  4 Mar 2022 17:31:11 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 06/28] samples/bpf: add new hid_mouse example
Date:   Fri,  4 Mar 2022 18:28:30 +0100
Message-Id: <20220304172852.274126-7-benjamin.tissoires@redhat.com>
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

Everything should be available in the selftest part of the tree, but
providing an example without uhid and hidraw will be more easy to
follow for users.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 samples/bpf/.gitignore       |   1 +
 samples/bpf/Makefile         |   4 ++
 samples/bpf/hid_mouse_kern.c |  66 ++++++++++++++++++
 samples/bpf/hid_mouse_user.c | 129 +++++++++++++++++++++++++++++++++++
 4 files changed, 200 insertions(+)
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
index 000000000000..c24a12e06b40
--- /dev/null
+++ b/samples/bpf/hid_mouse_kern.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021 Benjamin Tissoires
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
+
+	bpf_printk("event: %02x size: %d", ctx->type, ctx->size);
+	bpf_printk("incoming event: %02x %02x %02x",
+		   ctx->data[0],
+		   ctx->data[1],
+		   ctx->data[2]);
+	bpf_printk("                %02x %02x %02x",
+		   ctx->data[3],
+		   ctx->data[4],
+		   ctx->data[5]);
+	bpf_printk("                %02x %02x %02x",
+		   ctx->data[6],
+		   ctx->data[7],
+		   ctx->data[8]);
+
+	y = ctx->data[3] | (ctx->data[4] << 8);
+
+	y = -y;
+
+	ctx->data[3] = y & 0xFF;
+	ctx->data[4] = (y >> 8) & 0xFF;
+
+	bpf_printk("modified event: %02x %02x %02x",
+		   ctx->data[0],
+		   ctx->data[1],
+		   ctx->data[2]);
+	bpf_printk("                %02x %02x %02x",
+		   ctx->data[3],
+		   ctx->data[4],
+		   ctx->data[5]);
+	bpf_printk("                %02x %02x %02x",
+		   ctx->data[6],
+		   ctx->data[7],
+		   ctx->data[8]);
+
+	return 0;
+}
+
+SEC("hid/device_event")
+int hid_x_event(struct hid_bpf_ctx *ctx)
+{
+	s16 x;
+
+	x = ctx->data[1] | (ctx->data[2] << 8);
+
+	x = -x;
+
+	ctx->data[1] = x & 0xFF;
+	ctx->data[2] = (x >> 8) & 0xFF;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+u32 _version SEC("version") = LINUX_VERSION_CODE;
diff --git a/samples/bpf/hid_mouse_user.c b/samples/bpf/hid_mouse_user.c
new file mode 100644
index 000000000000..d4f37caca2fa
--- /dev/null
+++ b/samples/bpf/hid_mouse_user.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021 Benjamin Tissoires
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
+		progs[prog_count].link = bpf_program__attach_hid(prog, sysfs_fd);
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

