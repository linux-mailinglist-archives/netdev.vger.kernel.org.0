Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC0659FC0B
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238794AbiHXNqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238753AbiHXNp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:45:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9D483BEE
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661348546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=myASVuDtf0/22oUIrsPDrmBSpL+6DJQcFIv1o1ky+qo=;
        b=LsK2NGb5kZJzda4KszmXpNIku3nZJgF2ZGBfS332xAE1fPnkhpoubMKjDQ5bHSavjOxnXx
        l2elLPl/RUEkJjM44W6ZJvbfFXCjNXeQVqxeO9ofJG3hCJKcAghyWxPRnLGBe7cUVuUm5M
        MOyq6hJaHamumMvuWFw3BPk6LxTbdKM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-CpUbmY6mNeiOMfDisTQN2A-1; Wed, 24 Aug 2022 09:42:22 -0400
X-MC-Unique: CpUbmY6mNeiOMfDisTQN2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C30521C13941;
        Wed, 24 Aug 2022 13:42:21 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9844C18ECC;
        Wed, 24 Aug 2022 13:42:18 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v9 22/23] HID: bpf: add Surface Dial example
Date:   Wed, 24 Aug 2022 15:40:53 +0200
Message-Id: <20220824134055.1328882-24-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a more complete HID-BPF example.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v9:
- extend the usage section
- add sleep while waiting

no changes in v8

changes in v7:
- remove unnecessary __must_check definition

new in v6

fix surface dial
---
 samples/bpf/.gitignore             |   1 +
 samples/bpf/Makefile               |   6 +-
 samples/bpf/hid_surface_dial.bpf.c | 161 ++++++++++++++++++++
 samples/bpf/hid_surface_dial.c     | 232 +++++++++++++++++++++++++++++
 4 files changed, 399 insertions(+), 1 deletion(-)
 create mode 100644 samples/bpf/hid_surface_dial.bpf.c
 create mode 100644 samples/bpf/hid_surface_dial.c

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 65440bd618b2..6a1079d3d064 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -3,6 +3,7 @@ cpustat
 fds_example
 hbm
 hid_mouse
+hid_surface_dial
 ibumad
 lathist
 lwt_len_hist
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index a965bbfaca47..5f5aa7b32565 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -58,6 +58,7 @@ tprogs-y += xdp_redirect
 tprogs-y += xdp_monitor
 
 tprogs-y += hid_mouse
+tprogs-y += hid_surface_dial
 
 # Libbpf dependencies
 LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
@@ -122,6 +123,7 @@ xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
 xdp_router_ipv4-objs := xdp_router_ipv4_user.o $(XDP_SAMPLE)
 
 hid_mouse-objs := hid_mouse.o
+hid_surface_dial-objs := hid_surface_dial.o
 
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
@@ -343,6 +345,7 @@ $(obj)/hbm.o: $(src)/hbm.h
 $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 
 $(obj)/hid_mouse.o: $(obj)/hid_mouse.skel.h
+$(obj)/hid_surface_dial.o: $(obj)/hid_surface_dial.skel.h
 
 # Override includes for xdp_sample_user.o because $(srctree)/usr/include in
 # TPROGS_CFLAGS causes conflicts
@@ -429,9 +432,10 @@ $(BPF_SKELS_LINKED): $(BPF_OBJS_LINKED) $(BPFTOOL)
 	$(Q)$(BPFTOOL) gen skeleton $(@:.skel.h=.lbpf.o) name $(notdir $(@:.skel.h=)) > $@
 
 # Generate BPF skeletons for non XDP progs
-OTHER_BPF_SKELS := hid_mouse.skel.h
+OTHER_BPF_SKELS := hid_mouse.skel.h hid_surface_dial.skel.h
 
 hid_mouse.skel.h-deps := hid_mouse.bpf.o
+hid_surface_dial.skel.h-deps := hid_surface_dial.bpf.o
 
 OTHER_BPF_SRCS_LINKED := $(patsubst %.skel.h,%.bpf.c, $(OTHER_BPF_SKELS))
 OTHER_BPF_OBJS_LINKED := $(patsubst %.bpf.c,$(obj)/%.bpf.o, $(OTHER_BPF_SRCS_LINKED))
diff --git a/samples/bpf/hid_surface_dial.bpf.c b/samples/bpf/hid_surface_dial.bpf.c
new file mode 100644
index 000000000000..16c821d3decf
--- /dev/null
+++ b/samples/bpf/hid_surface_dial.bpf.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022 Benjamin Tissoires
+ */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#define HID_UP_BUTTON		0x0009
+#define HID_GD_WHEEL		0x0038
+
+/* following are kfuncs exported by HID for HID-BPF */
+extern __u8 *hid_bpf_get_data(struct hid_bpf_ctx *ctx,
+			      unsigned int offset,
+			      const size_t __sz) __ksym;
+extern int hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, u32 flags) __ksym;
+extern struct hid_bpf_ctx *hid_bpf_allocate_context(unsigned int hid_id) __ksym;
+extern void hid_bpf_release_context(struct hid_bpf_ctx *ctx) __ksym;
+extern int hid_bpf_hw_request(struct hid_bpf_ctx *ctx,
+			      __u8 *data,
+			      size_t buf__sz,
+			      enum hid_report_type type,
+			      enum hid_class_request reqtype) __ksym;
+
+struct attach_prog_args {
+	int prog_fd;
+	unsigned int hid;
+	int retval;
+};
+
+SEC("syscall")
+int attach_prog(struct attach_prog_args *ctx)
+{
+	ctx->retval = hid_bpf_attach_prog(ctx->hid,
+					  ctx->prog_fd,
+					  0);
+	return 0;
+}
+
+SEC("fmod_ret/hid_bpf_device_event")
+int BPF_PROG(hid_event, struct hid_bpf_ctx *hctx)
+{
+	__u8 *data = hid_bpf_get_data(hctx, 0 /* offset */, 9 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	/* Touch */
+	data[1] &= 0xfd;
+
+	/* X */
+	data[4] = 0;
+	data[5] = 0;
+
+	/* Y */
+	data[6] = 0;
+	data[7] = 0;
+
+	return 0;
+}
+
+/* 72 == 360 / 5 -> 1 report every 5 degrees */
+int resolution = 72;
+int physical = 5;
+
+struct haptic_syscall_args {
+	unsigned int hid;
+	int retval;
+};
+
+static __u8 haptic_data[8];
+
+SEC("syscall")
+int set_haptic(struct haptic_syscall_args *args)
+{
+	struct hid_bpf_ctx *ctx;
+	const size_t size = sizeof(haptic_data);
+	u16 *res;
+	int ret;
+
+	if (size > sizeof(haptic_data))
+		return -7; /* -E2BIG */
+
+	ctx = hid_bpf_allocate_context(args->hid);
+	if (!ctx)
+		return -1; /* EPERM check */
+
+	haptic_data[0] = 1;  /* report ID */
+
+	ret = hid_bpf_hw_request(ctx, haptic_data, size, HID_FEATURE_REPORT, HID_REQ_GET_REPORT);
+
+	bpf_printk("probed/remove event ret value: %d", ret);
+	bpf_printk("buf: %02x %02x %02x",
+		   haptic_data[0],
+		   haptic_data[1],
+		   haptic_data[2]);
+	bpf_printk("     %02x %02x %02x",
+		   haptic_data[3],
+		   haptic_data[4],
+		   haptic_data[5]);
+	bpf_printk("     %02x %02x",
+		   haptic_data[6],
+		   haptic_data[7]);
+
+	/* whenever resolution multiplier is not 3600, we have the fixed report descriptor */
+	res = (u16 *)&haptic_data[1];
+	if (*res != 3600) {
+//		haptic_data[1] = 72; /* resolution multiplier */
+//		haptic_data[2] = 0;  /* resolution multiplier */
+//		haptic_data[3] = 0;  /* Repeat Count */
+		haptic_data[4] = 3;  /* haptic Auto Trigger */
+//		haptic_data[5] = 5;  /* Waveform Cutoff Time */
+//		haptic_data[6] = 80; /* Retrigger Period */
+//		haptic_data[7] = 0;  /* Retrigger Period */
+	} else {
+		haptic_data[4] = 0;
+	}
+
+	ret = hid_bpf_hw_request(ctx, haptic_data, size, HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
+
+	bpf_printk("set haptic ret value: %d -> %d", ret, haptic_data[4]);
+
+	args->retval = ret;
+
+	hid_bpf_release_context(ctx);
+
+	return 0;
+}
+
+/* Convert REL_DIAL into REL_WHEEL */
+SEC("fmod_ret/hid_bpf_rdesc_fixup")
+int BPF_PROG(hid_rdesc_fixup, struct hid_bpf_ctx *hctx)
+{
+	__u8 *data = hid_bpf_get_data(hctx, 0 /* offset */, 4096 /* size */);
+	__u16 *res, *phys;
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	/* Convert TOUCH into a button */
+	data[31] = HID_UP_BUTTON;
+	data[33] = 2;
+
+	/* Convert REL_DIAL into REL_WHEEL */
+	data[45] = HID_GD_WHEEL;
+
+	/* Change Resolution Multiplier */
+	phys = (__u16 *)&data[61];
+	*phys = physical;
+	res = (__u16 *)&data[66];
+	*res = resolution;
+
+	/* Convert X,Y from Abs to Rel */
+	data[88] = 0x06;
+	data[98] = 0x06;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+u32 _version SEC("version") = 1;
diff --git a/samples/bpf/hid_surface_dial.c b/samples/bpf/hid_surface_dial.c
new file mode 100644
index 000000000000..c700bb0afa81
--- /dev/null
+++ b/samples/bpf/hid_surface_dial.c
@@ -0,0 +1,232 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022 Benjamin Tissoires
+ *
+ * This program will morph the Microsoft Surface Dial into a mouse,
+ * and depending on the chosen resolution enable or not the haptic feedback:
+ * - a resolution (-r) of 3600 will report 3600 "ticks" in one full rotation
+ *   wihout haptic feedback
+ * - any other resolution will report N "ticks" in a full rotation with haptic
+ *   feedback
+ *
+ * A good default for low resolution haptic scrolling is 72 (1 "tick" every 5
+ * degrees), and set to 3600 for smooth scrolling.
+ */
+
+#include <assert.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <libgen.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/resource.h>
+#include <unistd.h>
+
+#include <linux/bpf.h>
+#include <linux/errno.h>
+
+#include "bpf_util.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "hid_surface_dial.skel.h"
+
+static bool running = true;
+
+struct attach_prog_args {
+	int prog_fd;
+	unsigned int hid;
+	int retval;
+};
+
+struct haptic_syscall_args {
+	unsigned int hid;
+	int retval;
+};
+
+static void int_exit(int sig)
+{
+	running = false;
+	exit(0);
+}
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"%s: %s [OPTIONS] /sys/bus/hid/devices/0BUS:0VID:0PID:00ID\n\n"
+		"  OPTIONS:\n"
+		"    -r N\t set the given resolution to the device (number of ticks per 360°)\n\n",
+		__func__, prog);
+	fprintf(stderr,
+		"This program will morph the Microsoft Surface Dial into a mouse,\n"
+		"and depending on the chosen resolution enable or not the haptic feedback:\n"
+		"- a resolution (-r) of 3600 will report 3600 'ticks' in one full rotation\n"
+		"  wihout haptic feedback\n"
+		"- any other resolution will report N 'ticks' in a full rotation with haptic\n"
+		"  feedback\n"
+		"\n"
+		"A good default for low resolution haptic scrolling is 72 (1 'tick' every 5\n"
+		"degrees), and set to 3600 for smooth scrolling.\n");
+}
+
+static int get_hid_id(const char *path)
+{
+	const char *str_id, *dir;
+	char uevent[1024];
+	int fd;
+
+	memset(uevent, 0, sizeof(uevent));
+	snprintf(uevent, sizeof(uevent) - 1, "%s/uevent", path);
+
+	fd = open(uevent, O_RDONLY | O_NONBLOCK);
+	if (fd < 0)
+		return -ENOENT;
+
+	close(fd);
+
+	dir = basename((char *)path);
+
+	str_id = dir + sizeof("0003:0001:0A37.");
+	return (int)strtol(str_id, NULL, 16);
+}
+
+static int attach_prog(struct hid_surface_dial_lskel *skel, struct bpf_program *prog, int hid_id)
+{
+	struct attach_prog_args args = {
+		.hid = hid_id,
+		.retval = -1,
+	};
+	int attach_fd, err;
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, tattr,
+			    .ctx_in = &args,
+			    .ctx_size_in = sizeof(args),
+	);
+
+	attach_fd = bpf_program__fd(skel->progs.attach_prog);
+	if (attach_fd < 0) {
+		fprintf(stderr, "can't locate attach prog: %m\n");
+		return 1;
+	}
+
+	args.prog_fd = bpf_program__fd(prog);
+	err = bpf_prog_test_run_opts(attach_fd, &tattr);
+	if (err) {
+		fprintf(stderr, "can't attach prog to hid device %d: %m (err: %d)\n",
+			hid_id, err);
+		return 1;
+	}
+	return 0;
+}
+
+static int set_haptic(struct hid_surface_dial_lskel *skel, int hid_id)
+{
+	struct haptic_syscall_args args = {
+		.hid = hid_id,
+		.retval = -1,
+	};
+	int haptic_fd, err;
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, tattr,
+			    .ctx_in = &args,
+			    .ctx_size_in = sizeof(args),
+	);
+
+	haptic_fd = bpf_program__fd(skel->progs.set_haptic);
+	if (haptic_fd < 0) {
+		fprintf(stderr, "can't locate haptic prog: %m\n");
+		return 1;
+	}
+
+	err = bpf_prog_test_run_opts(haptic_fd, &tattr);
+	if (err) {
+		fprintf(stderr, "can't set haptic configuration to hid device %d: %m (err: %d)\n",
+			hid_id, err);
+		return 1;
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	struct hid_surface_dial_lskel *skel;
+	struct bpf_program *prog;
+	const char *optstr = "r:";
+	const char *sysfs_path;
+	int opt, hid_id, resolution = 72;
+
+	while ((opt = getopt(argc, argv, optstr)) != -1) {
+		switch (opt) {
+		case 'r':
+			{
+				char *endp = NULL;
+				long l = -1;
+
+				if (optarg) {
+					l = strtol(optarg, &endp, 10);
+					if (endp && *endp)
+						l = -1;
+				}
+
+				if (l < 0) {
+					fprintf(stderr,
+						"invalid r option %s - expecting a number\n",
+						optarg ? optarg : "");
+					exit(EXIT_FAILURE);
+				};
+
+				resolution = (int) l;
+				break;
+			}
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
+	skel = hid_surface_dial_lskel__open_and_load();
+	if (!skel) {
+		fprintf(stderr, "%s  %s:%d", __func__, __FILE__, __LINE__);
+		return -1;
+	}
+
+	hid_id = get_hid_id(sysfs_path);
+	if (hid_id < 0) {
+		fprintf(stderr, "can not open HID device: %m\n");
+		return 1;
+	}
+
+	skel->data->resolution = resolution;
+	skel->data->physical = (int)(resolution / 72);
+
+	bpf_object__for_each_program(prog, *skel->skeleton->obj) {
+		/* ignore syscalls */
+		if (bpf_program__get_type(prog) != BPF_PROG_TYPE_TRACING)
+			continue;
+
+		attach_prog(skel, prog, hid_id);
+	}
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	set_haptic(skel, hid_id);
+
+	while (running)
+		sleep(1);
+
+	hid_surface_dial_lskel__destroy(skel);
+
+	return 0;
+}
-- 
2.36.1

