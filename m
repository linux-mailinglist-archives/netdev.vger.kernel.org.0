Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D2759FC1D
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237981AbiHXNqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238124AbiHXNpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:45:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EF997EE1
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661348538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uDEAjKLM/dXPdlR2FULkcDcIfKFk2vu/+1H4uBpQaQk=;
        b=CUxm5XmksnAqoBb5+Dz5fCmYDKVXH00aEFFlsNkY2fPSq1yjDvqVb0kx70N7uVV475Ryhf
        bx4e041gv7qoKGw5zW3cBQPhg7eNjRirOH3SbCdf5cRBtR6NvS5MKD08MEVXCBtApafTqA
        FA6+CawphzWWMxw9piHajn1Qk935DGQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-txJgdyBNPhKvO59_eyLorg-1; Wed, 24 Aug 2022 09:42:16 -0400
X-MC-Unique: txJgdyBNPhKvO59_eyLorg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E98B31C0513D;
        Wed, 24 Aug 2022 13:42:14 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C665818ECC;
        Wed, 24 Aug 2022 13:42:11 +0000 (UTC)
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
Subject: [PATCH bpf-next v9 21/23] samples/bpf: add new hid_mouse example
Date:   Wed, 24 Aug 2022 15:40:51 +0200
Message-Id: <20220824134055.1328882-22-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Everything should be available in the selftest part of the tree, but
providing an example without uhid and hidraw will be more easy to
follow for users.

This example will probably ever only work on the Etekcity Scroll 6E
because we need to adapt the various raw values to the actual device.

On that device, the X and Y axis will be swapped and inverted, and on
any other device, chances are high that the device will not work until
Ctrl-C is hit.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v9:
- amended the usage part

no changes in v8

changes in v7:
- remove unnecessary __must_check definition

changes in v6:
- clean up code by removing old comments

changes in v5:
- bring back same features than v3, with the new API

changes in v4:
- dropped the not-yet-implemented rdesc_fixup
- use the new API

changes in v3:
- use the new hid_get_data API
- add a comment for the report descriptor fixup to explain what is done

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples

fix hid_mouse
---
 samples/bpf/.gitignore      |   1 +
 samples/bpf/Makefile        |  23 ++++++
 samples/bpf/hid_mouse.bpf.c | 134 ++++++++++++++++++++++++++++++
 samples/bpf/hid_mouse.c     | 161 ++++++++++++++++++++++++++++++++++++
 4 files changed, 319 insertions(+)
 create mode 100644 samples/bpf/hid_mouse.bpf.c
 create mode 100644 samples/bpf/hid_mouse.c

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
index 727da3c5879b..a965bbfaca47 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -57,6 +57,8 @@ tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect
 tprogs-y += xdp_monitor
 
+tprogs-y += hid_mouse
+
 # Libbpf dependencies
 LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
 LIBBPF_OUTPUT = $(abspath $(BPF_SAMPLES_PATH))/libbpf
@@ -119,6 +121,8 @@ xdp_redirect-objs := xdp_redirect_user.o $(XDP_SAMPLE)
 xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
 xdp_router_ipv4-objs := xdp_router_ipv4_user.o $(XDP_SAMPLE)
 
+hid_mouse-objs := hid_mouse.o
+
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
 always-y += sockex1_kern.o
@@ -338,6 +342,8 @@ $(obj)/hbm_out_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 $(obj)/hbm.o: $(src)/hbm.h
 $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 
+$(obj)/hid_mouse.o: $(obj)/hid_mouse.skel.h
+
 # Override includes for xdp_sample_user.o because $(srctree)/usr/include in
 # TPROGS_CFLAGS causes conflicts
 XDP_SAMPLE_CFLAGS += -Wall -O2 \
@@ -422,6 +428,23 @@ $(BPF_SKELS_LINKED): $(BPF_OBJS_LINKED) $(BPFTOOL)
 	@echo "  BPF GEN-SKEL" $(@:.skel.h=)
 	$(Q)$(BPFTOOL) gen skeleton $(@:.skel.h=.lbpf.o) name $(notdir $(@:.skel.h=)) > $@
 
+# Generate BPF skeletons for non XDP progs
+OTHER_BPF_SKELS := hid_mouse.skel.h
+
+hid_mouse.skel.h-deps := hid_mouse.bpf.o
+
+OTHER_BPF_SRCS_LINKED := $(patsubst %.skel.h,%.bpf.c, $(OTHER_BPF_SKELS))
+OTHER_BPF_OBJS_LINKED := $(patsubst %.bpf.c,$(obj)/%.bpf.o, $(OTHER_BPF_SRCS_LINKED))
+OTHER_BPF_SKELS_LINKED := $(addprefix $(obj)/,$(OTHER_BPF_SKELS))
+
+$(OTHER_BPF_SKELS_LINKED): $(OTHER_BPF_OBJS_LINKED) $(BPFTOOL)
+	@echo "  BPF GEN-OBJ " $(@:.skel.h=)
+	$(Q)$(BPFTOOL) gen object $(@:.skel.h=.lbpf.o) $(addprefix $(obj)/,$($(@F)-deps))
+	@echo "  BPF GEN-SKEL" $(@:.skel.h=)
+	$(Q)$(BPFTOOL) gen skeleton $(@:.skel.h=.lbpf.o) name $(notdir $(@:.skel.h=_lskel)) > $@
+#	$(call msg,GEN-SKEL,$@)
+#	$(Q)$(BPFTOOL) gen skeleton $< > $@
+
 # asm/sysreg.h - inline assembly used by it is incompatible with llvm.
 # But, there is no easy way to fix it, so just exclude it since it is
 # useless for BPF samples.
diff --git a/samples/bpf/hid_mouse.bpf.c b/samples/bpf/hid_mouse.bpf.c
new file mode 100644
index 000000000000..0113e603f7a7
--- /dev/null
+++ b/samples/bpf/hid_mouse.bpf.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* following are kfuncs exported by HID for HID-BPF */
+extern int hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, u32 flags) __ksym;
+extern __u8 *hid_bpf_get_data(struct hid_bpf_ctx *ctx,
+			      unsigned int offset,
+			      const size_t __sz) __ksym;
+extern void hid_bpf_data_release(__u8 *data) __ksym;
+extern int hid_bpf_hw_request(struct hid_bpf_ctx *ctx) __ksym;
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
+int BPF_PROG(hid_y_event, struct hid_bpf_ctx *hctx)
+{
+	s16 y;
+	__u8 *data = hid_bpf_get_data(hctx, 0 /* offset */, 9 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	bpf_printk("event: size: %d", hctx->size);
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
+SEC("fmod_ret/hid_bpf_device_event")
+int BPF_PROG(hid_x_event, struct hid_bpf_ctx *hctx)
+{
+	s16 x;
+	__u8 *data = hid_bpf_get_data(hctx, 0 /* offset */, 9 /* size */);
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
+SEC("fmod_ret/hid_bpf_rdesc_fixup")
+int BPF_PROG(hid_rdesc_fixup, struct hid_bpf_ctx *hctx)
+{
+	__u8 *data = hid_bpf_get_data(hctx, 0 /* offset */, 4096 /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
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
diff --git a/samples/bpf/hid_mouse.c b/samples/bpf/hid_mouse.c
new file mode 100644
index 000000000000..bea3650787c5
--- /dev/null
+++ b/samples/bpf/hid_mouse.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022 Benjamin Tissoires
+ *
+ * This is a pure HID-BPF example, and should be considered as such:
+ * on the Etekcity Scroll 6E, the X and Y axes will be swapped and
+ * inverted. On any other device... Not sure what this will do.
+ *
+ * This C main file is generic though. To adapt the code and test, users
+ * must amend only the .bpf.c file, which this program will load any
+ * eBPF program it finds.
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
+#include "hid_mouse.skel.h"
+
+static bool running = true;
+
+struct attach_prog_args {
+	int prog_fd;
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
+		"%s: %s /sys/bus/hid/devices/0BUS:0VID:0PID:00ID\n\n",
+		__func__, prog);
+	fprintf(stderr,
+		"This program will upload and attach a HID-BPF program to the given device.\n"
+		"On the Etekcity Scroll 6E, the X and Y axis will be inverted, but on any other\n"
+		"device, chances are high that the device will not be working anymore\n\n"
+		"consider this as a demo and adapt the eBPF program to your needs\n"
+		"Hit Ctrl-C to unbind the program and reset the device\n");
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
+int main(int argc, char **argv)
+{
+	struct hid_mouse_lskel *skel;
+	struct bpf_program *prog;
+	int err;
+	const char *optstr = "";
+	const char *sysfs_path;
+	int opt, hid_id, attach_fd;
+	struct attach_prog_args args = {
+		.retval = -1,
+	};
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, tattr,
+			    .ctx_in = &args,
+			    .ctx_size_in = sizeof(args),
+	);
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
+	skel = hid_mouse_lskel__open_and_load();
+	if (!skel) {
+		fprintf(stderr, "%s  %s:%d", __func__, __FILE__, __LINE__);
+		return -1;
+	}
+
+	hid_id = get_hid_id(sysfs_path);
+
+	if (hid_id < 0) {
+		fprintf(stderr, "can not open HID device: %m\n");
+		return 1;
+	}
+	args.hid = hid_id;
+
+	attach_fd = bpf_program__fd(skel->progs.attach_prog);
+	if (attach_fd < 0) {
+		fprintf(stderr, "can't locate attach prog: %m\n");
+		return 1;
+	}
+
+	bpf_object__for_each_program(prog, *skel->skeleton->obj) {
+		/* ignore syscalls */
+		if (bpf_program__get_type(prog) != BPF_PROG_TYPE_TRACING)
+			continue;
+
+		args.retval = -1;
+		args.prog_fd = bpf_program__fd(prog);
+		err = bpf_prog_test_run_opts(attach_fd, &tattr);
+		if (err) {
+			fprintf(stderr, "can't attach prog to hid device %d: %m (err: %d)\n",
+				hid_id, err);
+			return 1;
+		}
+	}
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	while (running)
+		sleep(1);
+
+	hid_mouse_lskel__destroy(skel);
+
+	return 0;
+}
-- 
2.36.1

