Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5107A59FBC7
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbiHXNnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238640AbiHXNmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:42:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ABE87094
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661348508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yzP2Bwa3PKSJT7yyR8CRNEautp2jHMusw6LB6gjhXd8=;
        b=Tk+WAxDwwBIJAv+Rcw/gE8bRGWTh5FTMo0kffSqPGKwafrKGvm/5tj4UYnGlZ+p4WVWKnQ
        RLpBD2izTxreM9+pFvRRrOezVMyc+8Z47QcqboQXhnHjxD418BPYzVtpol2ynyOy+AcFxC
        K4PIMo5FZElQt41nTCxNdxt0lSnve88=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-Fd5T-DdUPAGps3AxFdLSrQ-1; Wed, 24 Aug 2022 09:41:44 -0400
X-MC-Unique: Fd5T-DdUPAGps3AxFdLSrQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E69C1185A7BA;
        Wed, 24 Aug 2022 13:41:43 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89A2618ECC;
        Wed, 24 Aug 2022 13:41:40 +0000 (UTC)
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
Subject: [PATCH bpf-next v9 12/23] HID: initial BPF implementation
Date:   Wed, 24 Aug 2022 15:40:42 +0200
Message-Id: <20220824134055.1328882-13-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Declare an entry point that can use fmod_ret BPF programs, and
also an API to access and change the incoming data.

A simpler implementation would consist in just calling
hid_bpf_device_event() for any incoming event and let users deal
with the fact that they will be called for any event of any device.

The goal of HID-BPF is to partially replace drivers, so this situation
can be problematic because we might have programs which will step on
each other toes.

For that, we add a new API hid_bpf_attach_prog() that can be called
from a syscall and we manually deal with a jump table in hid-bpf.

Whenever we add a program to the jump table (in other words, when we
attach a program to a HID device), we keep the number of time we added
this program in the jump table so we can release it whenever there are
no other users.

HID devices have an RCU protected list of available programs in the
jump table, and those programs are called one after the other thanks
to bpf_tail_call().

To achieve the detection of users losing their fds on the programs we
attached, we add 2 tracing facilities on bpf_prog_release() (for when
a fd is closed) and bpf_free_inode() (for when a pinned program gets
unpinned).

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v9:
- fixed the kfunc declaration according to the latest upstream changes
- tiny change in the SPDX header of include/linux/hid_bpf.h
- removal of one obsolete comment in drivers/hid/bpf/Kconfig

no changes in v8

changes in v7:
- generate the entrypoints bpf lskel through bootstrop of bpftool for
  efficiency
- fix warning detected by kernel test robot <lkp@intel.com> where
  CONFIG_BPF was used instead of CONFIG_HID_BPF
- declare __hid_bpf_tail_call in hid_bpf.h to shut up warning
- fix static declarations of __init and __exit functions
- changed the default Kconfig to be `default HID_SUPPORT` and do not
  select HID

changes in v6:
- use BTF_ID to get the btf_id of hid_bpf_device_event instead of
  loading/unloading a dummy eBPF program.

changes in v5:
- all the HID bpf operations are in their dedicated module
- a bpf program is preloaded on startup so we can call subsequent
  calls with bpf_tail_call
- make hid_bpf_ctx more compact
- add a dedicated hid_bpf_attach_prog() API
- store the list of progs in each hdev
- monitor the calls to bpf_prog_release to automatically release
  attached progs when there are no other users
- add kernel docs directly when functions are defined

new-ish in v4:
- far from complete, but gives an overview of what we can do now.
---
 drivers/hid/Kconfig                           |   2 +
 drivers/hid/Makefile                          |   2 +
 drivers/hid/bpf/Kconfig                       |  17 +
 drivers/hid/bpf/Makefile                      |  11 +
 drivers/hid/bpf/entrypoints/Makefile          |  93 +++
 drivers/hid/bpf/entrypoints/README            |   4 +
 drivers/hid/bpf/entrypoints/entrypoints.bpf.c |  66 ++
 .../hid/bpf/entrypoints/entrypoints.lskel.h   | 682 ++++++++++++++++++
 drivers/hid/bpf/hid_bpf_dispatch.c            | 223 ++++++
 drivers/hid/bpf/hid_bpf_dispatch.h            |  27 +
 drivers/hid/bpf/hid_bpf_jmp_table.c           | 568 +++++++++++++++
 drivers/hid/hid-core.c                        |  15 +
 include/linux/hid.h                           |   5 +
 include/linux/hid_bpf.h                       | 102 +++
 include/uapi/linux/hid_bpf.h                  |  25 +
 tools/include/uapi/linux/hid.h                |  62 ++
 tools/include/uapi/linux/hid_bpf.h            |  25 +
 17 files changed, 1929 insertions(+)
 create mode 100644 drivers/hid/bpf/Kconfig
 create mode 100644 drivers/hid/bpf/Makefile
 create mode 100644 drivers/hid/bpf/entrypoints/Makefile
 create mode 100644 drivers/hid/bpf/entrypoints/README
 create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.bpf.c
 create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.lskel.h
 create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.c
 create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.h
 create mode 100644 drivers/hid/bpf/hid_bpf_jmp_table.c
 create mode 100644 include/linux/hid_bpf.h
 create mode 100644 include/uapi/linux/hid_bpf.h
 create mode 100644 tools/include/uapi/linux/hid.h
 create mode 100644 tools/include/uapi/linux/hid_bpf.h

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 4f24e42372dc..1a2a65c68205 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -1328,6 +1328,8 @@ config HID_KUNIT_TEST
 
 endmenu
 
+source "drivers/hid/bpf/Kconfig"
+
 source "drivers/hid/usbhid/Kconfig"
 
 source "drivers/hid/i2c-hid/Kconfig"
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index b0bef8098139..e3ac587b9a21 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -5,6 +5,8 @@
 hid-y			:= hid-core.o hid-input.o hid-quirks.o
 hid-$(CONFIG_DEBUG_FS)		+= hid-debug.o
 
+obj-$(CONFIG_HID_BPF)		+= bpf/
+
 obj-$(CONFIG_HID)		+= hid.o
 obj-$(CONFIG_UHID)		+= uhid.o
 
diff --git a/drivers/hid/bpf/Kconfig b/drivers/hid/bpf/Kconfig
new file mode 100644
index 000000000000..298634fc3335
--- /dev/null
+++ b/drivers/hid/bpf/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-only
+menu "HID-BPF support"
+
+config HID_BPF
+	bool "HID-BPF support"
+	default HID_SUPPORT
+	depends on BPF && BPF_SYSCALL
+	help
+	This option allows to support eBPF programs on the HID subsystem.
+	eBPF programs can fix HID devices in a lighter way than a full
+	kernel patch and allow a lot more flexibility.
+
+	For documentation, see Documentation/hid/hid-bpf.rst
+
+	If unsure, say Y.
+
+endmenu
diff --git a/drivers/hid/bpf/Makefile b/drivers/hid/bpf/Makefile
new file mode 100644
index 000000000000..cf55120cf7d6
--- /dev/null
+++ b/drivers/hid/bpf/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for HID-BPF
+#
+
+LIBBPF_INCLUDE = $(srctree)/tools/lib
+
+obj-$(CONFIG_HID_BPF) += hid_bpf.o
+CFLAGS_hid_bpf_dispatch.o += -I$(LIBBPF_INCLUDE)
+CFLAGS_hid_bpf_jmp_table.o += -I$(LIBBPF_INCLUDE)
+hid_bpf-objs += hid_bpf_dispatch.o hid_bpf_jmp_table.o
diff --git a/drivers/hid/bpf/entrypoints/Makefile b/drivers/hid/bpf/entrypoints/Makefile
new file mode 100644
index 000000000000..a12edcfa4fe3
--- /dev/null
+++ b/drivers/hid/bpf/entrypoints/Makefile
@@ -0,0 +1,93 @@
+# SPDX-License-Identifier: GPL-2.0
+OUTPUT := .output
+abs_out := $(abspath $(OUTPUT))
+
+CLANG ?= clang
+LLC ?= llc
+LLVM_STRIP ?= llvm-strip
+
+TOOLS_PATH := $(abspath ../../../../tools)
+BPFTOOL_SRC := $(TOOLS_PATH)/bpf/bpftool
+BPFTOOL_OUTPUT := $(abs_out)/bpftool
+DEFAULT_BPFTOOL := $(BPFTOOL_OUTPUT)/bootstrap/bpftool
+BPFTOOL ?= $(DEFAULT_BPFTOOL)
+
+LIBBPF_SRC := $(TOOLS_PATH)/lib/bpf
+LIBBPF_OUTPUT := $(abs_out)/libbpf
+LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
+LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
+BPFOBJ := $(LIBBPF_OUTPUT)/libbpf.a
+
+INCLUDES := -I$(OUTPUT) -I$(LIBBPF_INCLUDE) -I$(TOOLS_PATH)/include/uapi
+CFLAGS := -g -Wall
+
+VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
+		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
+		     ../../../../vmlinux				\
+		     /sys/kernel/btf/vmlinux				\
+		     /boot/vmlinux-$(shell uname -r)
+VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+ifeq ($(VMLINUX_BTF),)
+$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
+endif
+
+ifeq ($(V),1)
+Q =
+msg =
+else
+Q = @
+msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
+MAKEFLAGS += --no-print-directory
+submake_extras := feature_display=0
+endif
+
+.DELETE_ON_ERROR:
+
+.PHONY: all clean
+
+all: entrypoints.lskel.h
+
+clean:
+	$(call msg,CLEAN)
+	$(Q)rm -rf $(OUTPUT) entrypoints
+
+entrypoints.lskel.h: $(OUTPUT)/entrypoints.bpf.o | $(BPFTOOL)
+	$(call msg,GEN-SKEL,$@)
+	$(Q)$(BPFTOOL) gen skeleton -L $< > $@
+
+
+$(OUTPUT)/entrypoints.bpf.o: entrypoints.bpf.c $(OUTPUT)/vmlinux.h $(BPFOBJ) | $(OUTPUT)
+	$(call msg,BPF,$@)
+	$(Q)$(CLANG) -g -O2 -target bpf $(INCLUDES)			      \
+		 -c $(filter %.c,$^) -o $@ &&				      \
+	$(LLVM_STRIP) -g $@
+
+$(OUTPUT)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
+ifeq ($(VMLINUX_H),)
+	$(call msg,GEN,,$@)
+	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
+else
+	$(call msg,CP,,$@)
+	$(Q)cp "$(VMLINUX_H)" $@
+endif
+
+$(OUTPUT) $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
+	$(call msg,MKDIR,$@)
+	$(Q)mkdir -p $@
+
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)			       \
+		    OUTPUT=$(abspath $(dir $@))/ prefix=		       \
+		    DESTDIR=$(LIBBPF_DESTDIR) $(abspath $@) install_headers
+
+ifeq ($(CROSS_COMPILE),)
+$(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BPFTOOL_OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)			       \
+		    OUTPUT=$(BPFTOOL_OUTPUT)/				       \
+		    LIBBPF_BOOTSTRAP_OUTPUT=$(LIBBPF_OUTPUT)/		       \
+		    LIBBPF_BOOTSTRAP_DESTDIR=$(LIBBPF_DESTDIR)/ bootstrap
+else
+$(DEFAULT_BPFTOOL): | $(BPFTOOL_OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)			       \
+		    OUTPUT=$(BPFTOOL_OUTPUT)/ bootstrap
+endif
diff --git a/drivers/hid/bpf/entrypoints/README b/drivers/hid/bpf/entrypoints/README
new file mode 100644
index 000000000000..147e0d41509f
--- /dev/null
+++ b/drivers/hid/bpf/entrypoints/README
@@ -0,0 +1,4 @@
+WARNING:
+If you change "entrypoints.bpf.c" do "make -j" in this directory to rebuild "entrypoints.skel.h".
+Make sure to have clang 10 installed.
+See Documentation/bpf/bpf_devel_QA.rst
diff --git a/drivers/hid/bpf/entrypoints/entrypoints.bpf.c b/drivers/hid/bpf/entrypoints/entrypoints.bpf.c
new file mode 100644
index 000000000000..41dd66d5fc7a
--- /dev/null
+++ b/drivers/hid/bpf/entrypoints/entrypoints.bpf.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Benjamin Tissoires */
+
+#include ".output/vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#define HID_BPF_MAX_PROGS 1024
+
+extern bool call_hid_bpf_prog_release(u64 prog, int table_cnt) __ksym;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, HID_BPF_MAX_PROGS);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} hid_jmp_table SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, HID_BPF_MAX_PROGS * HID_BPF_PROG_TYPE_MAX);
+	__type(key, void *);
+	__type(value, __u8);
+} progs_map SEC(".maps");
+
+SEC("fmod_ret/__hid_bpf_tail_call")
+int BPF_PROG(hid_tail_call, struct hid_bpf_ctx *hctx)
+{
+	bpf_tail_call(ctx, &hid_jmp_table, hctx->index);
+
+	return 0;
+}
+
+static void release_prog(u64 prog)
+{
+	u8 *value;
+
+	value = bpf_map_lookup_elem(&progs_map, &prog);
+	if (!value)
+		return;
+
+	if (call_hid_bpf_prog_release(prog, *value))
+		bpf_map_delete_elem(&progs_map, &prog);
+}
+
+SEC("fexit/bpf_prog_release")
+int BPF_PROG(hid_prog_release, struct inode *inode, struct file *filp)
+{
+	u64 prog = (u64)filp->private_data;
+
+	release_prog(prog);
+
+	return 0;
+}
+
+SEC("fexit/bpf_free_inode")
+int BPF_PROG(hid_free_inode, struct inode *inode)
+{
+	u64 prog = (u64)inode->i_private;
+
+	release_prog(prog);
+
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/drivers/hid/bpf/entrypoints/entrypoints.lskel.h b/drivers/hid/bpf/entrypoints/entrypoints.lskel.h
new file mode 100644
index 000000000000..d6a6045a06fe
--- /dev/null
+++ b/drivers/hid/bpf/entrypoints/entrypoints.lskel.h
@@ -0,0 +1,682 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+/* THIS FILE IS AUTOGENERATED BY BPFTOOL! */
+#ifndef __ENTRYPOINTS_BPF_SKEL_H__
+#define __ENTRYPOINTS_BPF_SKEL_H__
+
+#include <bpf/skel_internal.h>
+
+struct entrypoints_bpf {
+	struct bpf_loader_ctx ctx;
+	struct {
+		struct bpf_map_desc hid_jmp_table;
+		struct bpf_map_desc progs_map;
+	} maps;
+	struct {
+		struct bpf_prog_desc hid_tail_call;
+		struct bpf_prog_desc hid_prog_release;
+		struct bpf_prog_desc hid_free_inode;
+	} progs;
+	struct {
+		int hid_tail_call_fd;
+		int hid_prog_release_fd;
+		int hid_free_inode_fd;
+	} links;
+};
+
+static inline int
+entrypoints_bpf__hid_tail_call__attach(struct entrypoints_bpf *skel)
+{
+	int prog_fd = skel->progs.hid_tail_call.prog_fd;
+	int fd = skel_raw_tracepoint_open(NULL, prog_fd);
+
+	if (fd > 0)
+		skel->links.hid_tail_call_fd = fd;
+	return fd;
+}
+
+static inline int
+entrypoints_bpf__hid_prog_release__attach(struct entrypoints_bpf *skel)
+{
+	int prog_fd = skel->progs.hid_prog_release.prog_fd;
+	int fd = skel_raw_tracepoint_open(NULL, prog_fd);
+
+	if (fd > 0)
+		skel->links.hid_prog_release_fd = fd;
+	return fd;
+}
+
+static inline int
+entrypoints_bpf__hid_free_inode__attach(struct entrypoints_bpf *skel)
+{
+	int prog_fd = skel->progs.hid_free_inode.prog_fd;
+	int fd = skel_raw_tracepoint_open(NULL, prog_fd);
+
+	if (fd > 0)
+		skel->links.hid_free_inode_fd = fd;
+	return fd;
+}
+
+static inline int
+entrypoints_bpf__attach(struct entrypoints_bpf *skel)
+{
+	int ret = 0;
+
+	ret = ret < 0 ? ret : entrypoints_bpf__hid_tail_call__attach(skel);
+	ret = ret < 0 ? ret : entrypoints_bpf__hid_prog_release__attach(skel);
+	ret = ret < 0 ? ret : entrypoints_bpf__hid_free_inode__attach(skel);
+	return ret < 0 ? ret : 0;
+}
+
+static inline void
+entrypoints_bpf__detach(struct entrypoints_bpf *skel)
+{
+	skel_closenz(skel->links.hid_tail_call_fd);
+	skel_closenz(skel->links.hid_prog_release_fd);
+	skel_closenz(skel->links.hid_free_inode_fd);
+}
+static void
+entrypoints_bpf__destroy(struct entrypoints_bpf *skel)
+{
+	if (!skel)
+		return;
+	entrypoints_bpf__detach(skel);
+	skel_closenz(skel->progs.hid_tail_call.prog_fd);
+	skel_closenz(skel->progs.hid_prog_release.prog_fd);
+	skel_closenz(skel->progs.hid_free_inode.prog_fd);
+	skel_closenz(skel->maps.hid_jmp_table.map_fd);
+	skel_closenz(skel->maps.progs_map.map_fd);
+	skel_free(skel);
+}
+static inline struct entrypoints_bpf *
+entrypoints_bpf__open(void)
+{
+	struct entrypoints_bpf *skel;
+
+	skel = skel_alloc(sizeof(*skel));
+	if (!skel)
+		goto cleanup;
+	skel->ctx.sz = (void *)&skel->links - (void *)skel;
+	return skel;
+cleanup:
+	entrypoints_bpf__destroy(skel);
+	return NULL;
+}
+
+static inline int
+entrypoints_bpf__load(struct entrypoints_bpf *skel)
+{
+	struct bpf_load_and_run_opts opts = {};
+	int err;
+
+	opts.ctx = (struct bpf_loader_ctx *)skel;
+	opts.data_sz = 11504;
+	opts.data = (void *)"\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x9f\xeb\x01\0\
+\x18\0\0\0\0\0\0\0\x78\x14\0\0\x78\x14\0\0\xf4\x0c\0\0\0\0\0\0\0\0\0\x02\x03\0\
+\0\0\x01\0\0\0\0\0\0\x01\x04\0\0\0\x20\0\0\x01\0\0\0\0\0\0\0\x03\0\0\0\0\x02\0\
+\0\0\x04\0\0\0\x03\0\0\0\x05\0\0\0\0\0\0\x01\x04\0\0\0\x20\0\0\0\0\0\0\0\0\0\0\
+\x02\x06\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x02\0\0\0\x04\0\0\0\0\x04\0\0\0\0\0\0\
+\0\0\0\x02\x08\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x02\0\0\0\x04\0\0\0\x04\0\0\0\0\
+\0\0\0\x04\0\0\x04\x20\0\0\0\x19\0\0\0\x01\0\0\0\0\0\0\0\x1e\0\0\0\x05\0\0\0\
+\x40\0\0\0\x2a\0\0\0\x07\0\0\0\x80\0\0\0\x33\0\0\0\x07\0\0\0\xc0\0\0\0\x3e\0\0\
+\0\0\0\0\x0e\x09\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\x02\x0c\0\0\0\0\0\0\0\0\0\0\x03\
+\0\0\0\0\x02\0\0\0\x04\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\x02\x0e\0\0\0\0\0\0\0\0\0\
+\0\x03\0\0\0\0\x02\0\0\0\x04\0\0\0\0\x08\0\0\0\0\0\0\0\0\0\x02\x10\0\0\0\0\0\0\
+\0\0\0\0\x02\0\0\0\0\0\0\0\0\0\0\0\x02\x12\0\0\0\x4c\0\0\0\0\0\0\x08\x13\0\0\0\
+\x51\0\0\0\0\0\0\x01\x01\0\0\0\x08\0\0\0\0\0\0\0\x04\0\0\x04\x20\0\0\0\x19\0\0\
+\0\x0b\0\0\0\0\0\0\0\x1e\0\0\0\x0d\0\0\0\x40\0\0\0\x5f\0\0\0\x0f\0\0\0\x80\0\0\
+\0\x63\0\0\0\x11\0\0\0\xc0\0\0\0\x69\0\0\0\0\0\0\x0e\x14\0\0\0\x01\0\0\0\0\0\0\
+\0\0\0\0\x02\x17\0\0\0\x73\0\0\0\0\0\0\x01\x08\0\0\0\x40\0\0\0\0\0\0\0\x01\0\0\
+\x0d\x02\0\0\0\x86\0\0\0\x16\0\0\0\x8a\0\0\0\x01\0\0\x0c\x18\0\0\0\x30\x01\0\0\
+\x05\0\0\x04\x20\0\0\0\x3c\x01\0\0\x1b\0\0\0\0\0\0\0\x42\x01\0\0\x1d\0\0\0\x40\
+\0\0\0\x46\x01\0\0\x1b\0\0\0\x80\0\0\0\x55\x01\0\0\x1f\0\0\0\xa0\0\0\0\0\0\0\0\
+\x20\0\0\0\xc0\0\0\0\x61\x01\0\0\0\0\0\x08\x1c\0\0\0\x67\x01\0\0\0\0\0\x01\x04\
+\0\0\0\x20\0\0\0\0\0\0\0\0\0\0\x02\x1e\0\0\0\0\0\0\0\0\0\0\x0a\xb5\0\0\0\x74\
+\x01\0\0\x04\0\0\x06\x04\0\0\0\x84\x01\0\0\0\0\0\0\x95\x01\0\0\x01\0\0\0\xa7\
+\x01\0\0\x02\0\0\0\xba\x01\0\0\x03\0\0\0\0\0\0\0\x02\0\0\x05\x04\0\0\0\xcb\x01\
+\0\0\x21\0\0\0\0\0\0\0\xd2\x01\0\0\x21\0\0\0\0\0\0\0\xd7\x01\0\0\0\0\0\x08\x02\
+\0\0\0\0\0\0\0\x01\0\0\x0d\x02\0\0\0\x86\0\0\0\x16\0\0\0\x13\x02\0\0\x01\0\0\
+\x0c\x22\0\0\0\x82\x02\0\0\x14\0\0\x04\xc8\x01\0\0\x87\x02\0\0\x25\0\0\0\0\0\0\
+\0\x8b\x02\0\0\x2c\0\0\0\x80\0\0\0\x92\x02\0\0\x2f\0\0\0\0\x01\0\0\x9a\x02\0\0\
+\x30\0\0\0\x40\x01\0\0\x9f\x02\0\0\x32\0\0\0\x80\x01\0\0\xa6\x02\0\0\x59\0\0\0\
+\x80\x03\0\0\xae\x02\0\0\x1c\0\0\0\xc0\x03\0\0\xb6\x02\0\0\x5f\0\0\0\xe0\x03\0\
+\0\xbd\x02\0\0\x60\0\0\0\0\x04\0\0\xc8\x02\0\0\x63\0\0\0\x80\x08\0\0\xce\x02\0\
+\0\x65\0\0\0\xc0\x08\0\0\xd6\x02\0\0\x73\0\0\0\x80\x0b\0\0\xdd\x02\0\0\x75\0\0\
+\0\xc0\x0b\0\0\xe2\x02\0\0\x76\0\0\0\xc0\x0c\0\0\xec\x02\0\0\x10\0\0\0\0\x0d\0\
+\0\xf7\x02\0\0\x10\0\0\0\x40\x0d\0\0\x04\x03\0\0\x78\0\0\0\x80\x0d\0\0\x09\x03\
+\0\0\x79\0\0\0\xc0\x0d\0\0\x13\x03\0\0\x7a\0\0\0\0\x0e\0\0\x1c\x03\0\0\x7a\0\0\
+\0\x20\x0e\0\0\0\0\0\0\x02\0\0\x05\x10\0\0\0\x25\x03\0\0\x26\0\0\0\0\0\0\0\x2e\
+\x03\0\0\x28\0\0\0\0\0\0\0\x39\x03\0\0\x01\0\0\x04\x08\0\0\0\x44\x03\0\0\x27\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\x02\x26\0\0\0\x49\x03\0\0\x02\0\0\x04\x10\0\0\0\x44\
+\x03\0\0\x29\0\0\0\0\0\0\0\x57\x03\0\0\x2a\0\0\0\x40\0\0\0\0\0\0\0\0\0\0\x02\
+\x28\0\0\0\0\0\0\0\0\0\0\x02\x2b\0\0\0\0\0\0\0\x01\0\0\x0d\0\0\0\0\0\0\0\0\x29\
+\0\0\0\x5c\x03\0\0\x02\0\0\x04\x10\0\0\0\x61\x03\0\0\x2d\0\0\0\0\0\0\0\x65\x03\
+\0\0\x2e\0\0\0\x40\0\0\0\0\0\0\0\0\0\0\x02\xbe\0\0\0\0\0\0\0\0\0\0\x02\xb1\0\0\
+\0\0\0\0\0\0\0\0\x02\x81\0\0\0\0\0\0\0\0\0\0\x02\x31\0\0\0\0\0\0\0\0\0\0\x0a\
+\xb3\0\0\0\x6c\x03\0\0\0\0\0\x08\x33\0\0\0\x77\x03\0\0\x01\0\0\x04\x40\0\0\0\0\
+\0\0\0\x34\0\0\0\0\0\0\0\0\0\0\0\x02\0\0\x05\x40\0\0\0\x80\x03\0\0\x35\0\0\0\0\
+\0\0\0\0\0\0\0\x57\0\0\0\0\0\0\0\x86\x03\0\0\x05\0\0\x04\x40\0\0\0\x93\x03\0\0\
+\x36\0\0\0\0\0\0\0\x9c\x03\0\0\x1c\0\0\0\x20\0\0\0\xa2\x03\0\0\x1c\0\0\0\x40\0\
+\0\0\xac\x03\0\0\x10\0\0\0\x80\0\0\0\xb2\x03\0\0\x41\0\0\0\xc0\0\0\0\xba\x03\0\
+\0\0\0\0\x08\x37\0\0\0\xca\x03\0\0\x01\0\0\x04\x04\0\0\0\0\0\0\0\x38\0\0\0\0\0\
+\0\0\0\0\0\0\x03\0\0\x05\x04\0\0\0\xd4\x03\0\0\x39\0\0\0\0\0\0\0\0\0\0\0\x3b\0\
+\0\0\0\0\0\0\0\0\0\0\x3d\0\0\0\0\0\0\0\xd8\x03\0\0\0\0\0\x08\x3a\0\0\0\0\0\0\0\
+\x01\0\0\x04\x04\0\0\0\xe1\x03\0\0\x02\0\0\0\0\0\0\0\0\0\0\0\x02\0\0\x04\x02\0\
+\0\0\xe9\x03\0\0\x3c\0\0\0\0\0\0\0\xf0\x03\0\0\x3c\0\0\0\x08\0\0\0\xf8\x03\0\0\
+\0\0\0\x08\x12\0\0\0\0\0\0\0\x02\0\0\x04\x04\0\0\0\xfb\x03\0\0\x3e\0\0\0\0\0\0\
+\0\x0a\x04\0\0\x3e\0\0\0\x10\0\0\0\x0f\x04\0\0\0\0\0\x08\x3f\0\0\0\x13\x04\0\0\
+\0\0\0\x08\x40\0\0\0\x19\x04\0\0\0\0\0\x01\x02\0\0\0\x10\0\0\0\x28\x04\0\0\x06\
+\0\0\x04\x28\0\0\0\x5f\0\0\0\x42\0\0\0\0\0\0\0\x34\x04\0\0\x56\0\0\0\x40\0\0\0\
+\x40\x04\0\0\x53\0\0\0\xc0\0\0\0\x45\x04\0\0\x3c\0\0\0\0\x01\0\0\x55\x04\0\0\
+\x3c\0\0\0\x08\x01\0\0\x65\x04\0\0\x3c\0\0\0\x10\x01\0\0\0\0\0\0\0\0\0\x02\xb7\
+\0\0\0\0\0\0\0\0\0\0\x02\x44\0\0\0\x6f\x04\0\0\x0e\0\0\x04\xc0\0\0\0\x7a\x04\0\
+\0\x45\0\0\0\0\0\0\0\x85\x04\0\0\x48\0\0\0\x80\0\0\0\x90\x04\0\0\x48\0\0\0\0\
+\x01\0\0\x9c\x04\0\0\x48\0\0\0\x80\x01\0\0\x5f\0\0\0\x4a\0\0\0\0\x02\0\0\xa9\
+\x04\0\0\x1c\0\0\0\x40\x02\0\0\xb2\x04\0\0\x1c\0\0\0\x60\x02\0\0\xbd\x04\0\0\
+\x4c\0\0\0\x80\x02\0\0\xc8\x04\0\0\x52\0\0\0\xc0\x02\0\0\xd5\x04\0\0\x02\0\0\0\
+\x40\x05\0\0\x40\x04\0\0\x53\0\0\0\x80\x05\0\0\x55\x04\0\0\x3c\0\0\0\xc0\x05\0\
+\0\x45\x04\0\0\x3c\0\0\0\xc8\x05\0\0\x65\x04\0\0\x3c\0\0\0\xd0\x05\0\0\xe2\x04\
+\0\0\x02\0\0\x04\x10\0\0\0\x44\x03\0\0\x46\0\0\0\0\0\0\0\xed\x04\0\0\x47\0\0\0\
+\x40\0\0\0\0\0\0\0\0\0\0\x02\x45\0\0\0\0\0\0\0\0\0\0\x02\x46\0\0\0\xf3\x04\0\0\
+\x02\0\0\x04\x10\0\0\0\x44\x03\0\0\x49\0\0\0\0\0\0\0\xfd\x04\0\0\x49\0\0\0\x40\
+\0\0\0\0\0\0\0\0\0\0\x02\x48\0\0\0\0\0\0\0\0\0\0\x02\x4b\0\0\0\0\0\0\0\0\0\0\
+\x0a\xb8\0\0\0\x02\x05\0\0\0\0\0\x01\x08\0\0\0\x40\0\0\0\0\0\0\0\0\0\0\x02\x4e\
+\0\0\0\0\0\0\0\0\0\0\x0a\x4f\0\0\0\x10\x05\0\0\x04\0\0\x04\x18\0\0\0\x7a\x04\0\
+\0\x45\0\0\0\0\0\0\0\x1b\x05\0\0\x50\0\0\0\x80\0\0\0\x20\x05\0\0\x50\0\0\0\xa0\
+\0\0\0\x2b\x05\0\0\x51\0\0\0\xc0\0\0\0\x33\x05\0\0\0\0\0\x08\x1b\0\0\0\0\0\0\0\
+\0\0\0\x03\0\0\0\0\x4c\0\0\0\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x4d\0\
+\0\0\x04\0\0\0\x0a\0\0\0\0\0\0\0\0\0\0\x02\x54\0\0\0\0\0\0\0\0\0\0\x0a\x55\0\0\
+\0\x37\x05\0\0\0\0\0\x01\x01\0\0\0\x08\0\0\x01\0\0\0\0\0\0\0\x03\0\0\0\0\x43\0\
+\0\0\x04\0\0\0\x02\0\0\0\0\0\0\0\x02\0\0\x04\x40\0\0\0\x3c\x05\0\0\x58\0\0\0\0\
+\0\0\0\xb2\x03\0\0\x41\0\0\0\xc0\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x3c\0\0\0\x04\
+\0\0\0\x18\0\0\0\x46\x05\0\0\0\0\0\x08\x5a\0\0\0\x54\x05\0\0\0\0\0\x08\x5b\0\0\
+\0\0\0\0\0\x01\0\0\x04\x08\0\0\0\xe1\x03\0\0\x5c\0\0\0\0\0\0\0\x5f\x05\0\0\0\0\
+\0\x08\x5d\0\0\0\x63\x05\0\0\0\0\0\x08\x5e\0\0\0\x69\x05\0\0\0\0\0\x01\x08\0\0\
+\0\x40\0\0\x01\x73\x05\0\0\0\0\0\x08\x1c\0\0\0\x7b\x05\0\0\x06\0\0\x04\x90\0\0\
+\0\xac\x03\0\0\x59\0\0\0\0\0\0\0\x81\x05\0\0\x61\0\0\0\x40\0\0\0\x8b\x05\0\0\
+\x62\0\0\0\x40\x02\0\0\x8f\x05\0\0\x48\0\0\0\x80\x02\0\0\x9c\x03\0\0\x10\0\0\0\
+\0\x03\0\0\xb2\x03\0\0\x41\0\0\0\x40\x03\0\0\x99\x05\0\0\0\0\0\x08\x35\0\0\0\
+\xa8\x05\0\0\x01\0\0\x04\x04\0\0\0\x0a\x04\0\0\x39\0\0\0\0\0\0\0\xbe\x05\0\0\0\
+\0\0\x08\x64\0\0\0\xc5\x05\0\0\0\0\0\x08\x5e\0\0\0\xd5\x05\0\0\x06\0\0\x04\x58\
+\0\0\0\xe1\x05\0\0\x66\0\0\0\0\0\0\0\xe6\x05\0\0\x6d\0\0\0\0\x02\0\0\xea\x05\0\
+\0\x6e\0\0\0\x40\x02\0\0\xf3\x05\0\0\x6f\0\0\0\x60\x02\0\0\xf7\x05\0\0\x6f\0\0\
+\0\x80\x02\0\0\xfc\x05\0\0\x02\0\0\0\xa0\x02\0\0\x03\x06\0\0\0\0\0\x08\x67\0\0\
+\0\0\0\0\0\x05\0\0\x04\x40\0\0\0\x93\x03\0\0\x68\0\0\0\0\0\0\0\x9c\x03\0\0\x1c\
+\0\0\0\x40\0\0\0\xa2\x03\0\0\x1c\0\0\0\x60\0\0\0\xac\x03\0\0\x10\0\0\0\x80\0\0\
+\0\xb2\x03\0\0\x41\0\0\0\xc0\0\0\0\x0c\x06\0\0\0\0\0\x08\x69\0\0\0\x1a\x06\0\0\
+\x02\0\0\x04\x08\0\0\0\0\0\0\0\x6a\0\0\0\0\0\0\0\x81\x05\0\0\x36\0\0\0\x20\0\0\
+\0\0\0\0\0\x02\0\0\x05\x04\0\0\0\x22\x06\0\0\x39\0\0\0\0\0\0\0\0\0\0\0\x6b\0\0\
+\0\0\0\0\0\0\0\0\0\x02\0\0\x04\x04\0\0\0\x27\x06\0\0\x3c\0\0\0\0\0\0\0\x2f\x06\
+\0\0\x6c\0\0\0\x08\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x3c\0\0\0\x04\0\0\0\x03\0\0\
+\0\0\0\0\0\0\0\0\x02\xb9\0\0\0\xea\x05\0\0\x05\0\0\x06\x04\0\0\0\x38\x06\0\0\0\
+\0\0\0\x44\x06\0\0\x01\0\0\0\x51\x06\0\0\x02\0\0\0\x5e\x06\0\0\x03\0\0\0\x6a\
+\x06\0\0\x04\0\0\0\x76\x06\0\0\0\0\0\x08\x70\0\0\0\0\0\0\0\x01\0\0\x04\x04\0\0\
+\0\xd4\x03\0\0\x71\0\0\0\0\0\0\0\x7d\x06\0\0\0\0\0\x08\x72\0\0\0\x83\x06\0\0\0\
+\0\0\x08\x1c\0\0\0\0\0\0\0\0\0\0\x02\x74\0\0\0\0\0\0\0\0\0\0\x0a\xb0\0\0\0\x94\
+\x06\0\0\x06\0\0\x04\x20\0\0\0\xa2\x06\0\0\x4c\0\0\0\0\0\0\0\xd2\x01\0\0\x1c\0\
+\0\0\x40\0\0\0\xa8\x06\0\0\x1c\0\0\0\x60\0\0\0\xb3\x06\0\0\x1c\0\0\0\x80\0\0\0\
+\xbc\x06\0\0\x1c\0\0\0\xa0\0\0\0\xc6\x06\0\0\x63\0\0\0\xc0\0\0\0\xcf\x06\0\0\0\
+\0\0\x08\x77\0\0\0\xd3\x06\0\0\0\0\0\x08\x17\0\0\0\0\0\0\0\0\0\0\x02\x96\0\0\0\
+\0\0\0\0\0\0\0\x02\x9b\0\0\0\xd9\x06\0\0\0\0\0\x08\x50\0\0\0\0\0\0\0\x02\0\0\
+\x0d\x7c\0\0\0\xe9\x0c\0\0\x76\0\0\0\xe9\x0c\0\0\x02\0\0\0\xa2\x07\0\0\0\0\0\
+\x08\x7d\0\0\0\xa7\x07\0\0\0\0\0\x01\x01\0\0\0\x08\0\0\x04\xad\x07\0\0\x01\0\0\
+\x0c\x7b\0\0\0\0\0\0\0\x01\0\0\x0d\x02\0\0\0\x86\0\0\0\x16\0\0\0\xc7\x07\0\0\
+\x01\0\0\x0c\x7f\0\0\0\x1d\x08\0\0\x34\0\0\x04\x78\x04\0\0\x23\x08\0\0\x82\0\0\
+\0\0\0\0\0\x2a\x08\0\0\x40\0\0\0\x10\0\0\0\x34\x08\0\0\x6f\0\0\0\x20\0\0\0\x3a\
+\x08\0\0\x83\0\0\0\x40\0\0\0\x40\x08\0\0\x1c\0\0\0\x60\0\0\0\x48\x08\0\0\x87\0\
+\0\0\x80\0\0\0\x4e\x08\0\0\x87\0\0\0\xc0\0\0\0\x5c\x08\0\0\x88\0\0\0\0\x01\0\0\
+\x61\x08\0\0\x8a\0\0\0\x40\x01\0\0\x66\x08\0\0\x79\0\0\0\x80\x01\0\0\x70\x08\0\
+\0\x10\0\0\0\xc0\x01\0\0\x7b\x08\0\0\x4c\0\0\0\0\x02\0\0\0\0\0\0\x8b\0\0\0\x40\
+\x02\0\0\x81\x08\0\0\x8d\0\0\0\x60\x02\0\0\x88\x08\0\0\x63\0\0\0\x80\x02\0\0\
+\x8f\x08\0\0\x8f\0\0\0\xc0\x02\0\0\x97\x08\0\0\x8f\0\0\0\x40\x03\0\0\x9f\x08\0\
+\0\x8f\0\0\0\xc0\x03\0\0\xa7\x08\0\0\x32\0\0\0\x40\x04\0\0\xae\x08\0\0\x40\0\0\
+\0\x40\x06\0\0\xb6\x08\0\0\x3c\0\0\0\x50\x06\0\0\xc0\x08\0\0\x3c\0\0\0\x58\x06\
+\0\0\xcd\x08\0\0\x92\0\0\0\x80\x06\0\0\xd6\x08\0\0\x4c\0\0\0\xc0\x06\0\0\xde\
+\x08\0\0\x93\0\0\0\0\x07\0\0\xe6\x08\0\0\x4c\0\0\0\xc0\x0b\0\0\xf3\x08\0\0\x4c\
+\0\0\0\0\x0c\0\0\x05\x09\0\0\x45\0\0\0\x40\x0c\0\0\x0c\x09\0\0\x48\0\0\0\xc0\
+\x0c\0\0\x16\x09\0\0\x94\0\0\0\x40\x0d\0\0\x1b\x09\0\0\x02\0\0\0\x80\x0d\0\0\
+\x2b\x09\0\0\x3e\0\0\0\xa0\x0d\0\0\x3d\x09\0\0\x3e\0\0\0\xb0\x0d\0\0\x4e\x09\0\
+\0\x48\0\0\0\xc0\x0d\0\0\x54\x09\0\0\x48\0\0\0\x40\x0e\0\0\x5e\x09\0\0\x48\0\0\
+\0\xc0\x0e\0\0\0\0\0\0\x95\0\0\0\x40\x0f\0\0\x68\x09\0\0\x5a\0\0\0\xc0\x0f\0\0\
+\x72\x09\0\0\x5a\0\0\0\0\x10\0\0\x7d\x09\0\0\x39\0\0\0\x40\x10\0\0\x85\x09\0\0\
+\x39\0\0\0\x60\x10\0\0\x91\x09\0\0\x39\0\0\0\x80\x10\0\0\x9e\x09\0\0\x39\0\0\0\
+\xa0\x10\0\0\0\0\0\0\x97\0\0\0\xc0\x10\0\0\xaa\x09\0\0\x9a\0\0\0\0\x11\0\0\xb2\
+\x09\0\0\x9b\0\0\0\x40\x11\0\0\xb9\x09\0\0\x48\0\0\0\x40\x22\0\0\0\0\0\0\xa3\0\
+\0\0\xc0\x22\0\0\xc3\x09\0\0\x1b\0\0\0\0\x23\0\0\xd0\x09\0\0\x1b\0\0\0\x20\x23\
+\0\0\xe0\x09\0\0\xa7\0\0\0\x40\x23\0\0\xf1\x09\0\0\x10\0\0\0\x80\x23\0\0\xfb\
+\x09\0\0\0\0\0\x08\x40\0\0\0\x03\x0a\0\0\0\0\0\x08\x84\0\0\0\0\0\0\0\x01\0\0\
+\x04\x04\0\0\0\xd4\x03\0\0\x85\0\0\0\0\0\0\0\x0a\x0a\0\0\0\0\0\x08\x86\0\0\0\
+\x10\x0a\0\0\0\0\0\x08\x1c\0\0\0\0\0\0\0\0\0\0\x02\xbb\0\0\0\0\0\0\0\0\0\0\x02\
+\x89\0\0\0\0\0\0\0\0\0\0\x0a\xb6\0\0\0\0\0\0\0\0\0\0\x02\xbd\0\0\0\0\0\0\0\x02\
+\0\0\x05\x04\0\0\0\x21\x0a\0\0\x8c\0\0\0\0\0\0\0\x29\x0a\0\0\x1c\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\x0a\x1c\0\0\0\x33\x0a\0\0\0\0\0\x08\x8e\0\0\0\x39\x0a\0\0\0\0\0\
+\x08\x50\0\0\0\x48\x0a\0\0\x02\0\0\x04\x10\0\0\0\x53\x0a\0\0\x90\0\0\0\0\0\0\0\
+\x5a\x0a\0\0\x91\0\0\0\x40\0\0\0\x62\x0a\0\0\0\0\0\x08\x5d\0\0\0\x6b\x0a\0\0\0\
+\0\0\x01\x08\0\0\0\x40\0\0\x01\x70\x0a\0\0\0\0\0\x08\x76\0\0\0\x79\x0a\0\0\x07\
+\0\0\x04\x98\0\0\0\x86\x0a\0\0\x59\0\0\0\0\0\0\0\xac\x03\0\0\x59\0\0\0\x40\0\0\
+\0\x8b\x05\0\0\x62\0\0\0\x80\0\0\0\x81\x05\0\0\x61\0\0\0\xc0\0\0\0\x8f\x05\0\0\
+\x48\0\0\0\xc0\x02\0\0\x9c\x03\0\0\x10\0\0\0\x40\x03\0\0\xb2\x03\0\0\x41\0\0\0\
+\x80\x03\0\0\0\0\0\0\0\0\0\x02\xae\0\0\0\0\0\0\0\x02\0\0\x05\x10\0\0\0\x8c\x0a\
+\0\0\x96\0\0\0\0\0\0\0\x95\x0a\0\0\x28\0\0\0\0\0\0\0\x9b\x0a\0\0\x01\0\0\x04\
+\x08\0\0\0\xa6\x0a\0\0\x46\0\0\0\0\0\0\0\0\0\0\0\x02\0\0\x05\x08\0\0\0\xac\x0a\
+\0\0\x30\0\0\0\0\0\0\0\xb2\x0a\0\0\x98\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x02\x99\0\0\
+\0\0\0\0\0\x01\0\0\x0d\0\0\0\0\0\0\0\0\x2f\0\0\0\0\0\0\0\0\0\0\x02\xb2\0\0\0\
+\xbd\x0a\0\0\x0f\0\0\x04\x20\x02\0\0\xcb\x0a\0\0\x2f\0\0\0\0\0\0\0\xd0\x0a\0\0\
+\x9c\0\0\0\x40\0\0\0\xd8\x0a\0\0\x93\0\0\0\xc0\x02\0\0\xe8\x0a\0\0\x9d\0\0\0\
+\x80\x07\0\0\xf1\x0a\0\0\x39\0\0\0\xa0\x07\0\0\x01\x0b\0\0\x9e\0\0\0\xc0\x07\0\
+\0\x08\x0b\0\0\x93\0\0\0\x40\x08\0\0\x15\x0b\0\0\x4c\0\0\0\0\x0d\0\0\x1d\x0b\0\
+\0\x4c\0\0\0\x40\x0d\0\0\x2d\x0b\0\0\xa1\0\0\0\x80\x0d\0\0\x33\x0b\0\0\x4c\0\0\
+\0\xc0\x0d\0\0\x39\x0b\0\0\x7a\0\0\0\0\x0e\0\0\x40\x0b\0\0\x32\0\0\0\x40\x0e\0\
+\0\x4d\x0b\0\0\x48\0\0\0\x40\x10\0\0\xf7\x02\0\0\x10\0\0\0\xc0\x10\0\0\x5a\x0b\
+\0\0\x03\0\0\x04\x50\0\0\0\x61\x0b\0\0\x32\0\0\0\0\0\0\0\x69\x0b\0\0\x9d\0\0\0\
+\0\x02\0\0\x72\x0b\0\0\x10\0\0\0\x40\x02\0\0\x7a\x0b\0\0\0\0\0\x08\x1c\0\0\0\
+\x80\x0b\0\0\x02\0\0\x04\x10\0\0\0\x8f\x0b\0\0\x9f\0\0\0\0\0\0\0\x97\x0b\0\0\
+\xa0\0\0\0\x40\0\0\0\x8f\x0b\0\0\x01\0\0\x04\x08\0\0\0\xa3\x0b\0\0\xa0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\x02\xbc\0\0\0\0\0\0\0\0\0\0\x02\xa2\0\0\0\0\0\0\0\0\0\0\
+\x0a\xad\0\0\0\0\0\0\0\x04\0\0\x05\x08\0\0\0\xab\x0b\0\0\xa4\0\0\0\0\0\0\0\xb2\
+\x0b\0\0\xa5\0\0\0\0\0\0\0\xb9\x0b\0\0\xa6\0\0\0\0\0\0\0\xc0\x0b\0\0\x1c\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\x02\xba\0\0\0\0\0\0\0\0\0\0\x02\xaf\0\0\0\0\0\0\0\0\0\0\
+\x02\x55\0\0\0\0\0\0\0\0\0\0\x02\xb4\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x55\0\0\0\
+\x04\0\0\0\x04\0\0\0\xf2\x0b\0\0\0\0\0\x0e\xa8\0\0\0\x01\0\0\0\xfa\x0b\0\0\x01\
+\0\0\x0f\x04\0\0\0\xbf\0\0\0\0\0\0\0\x04\0\0\0\x01\x0c\0\0\x02\0\0\x0f\x40\0\0\
+\0\x0a\0\0\0\0\0\0\0\x20\0\0\0\x15\0\0\0\x20\0\0\0\x20\0\0\0\x07\x0c\0\0\x01\0\
+\0\x0f\x04\0\0\0\xa9\0\0\0\0\0\0\0\x04\0\0\0\x0f\x0c\0\0\0\0\0\x07\0\0\0\0\x28\
+\x0c\0\0\0\0\0\x07\0\0\0\0\x36\x0c\0\0\0\0\0\x07\0\0\0\0\x3b\x0c\0\0\0\0\0\x07\
+\0\0\0\0\x65\x03\0\0\0\0\0\x07\0\0\0\0\x40\x0c\0\0\0\0\0\x07\0\0\0\0\x52\x0c\0\
+\0\0\0\0\x07\0\0\0\0\x62\x0c\0\0\0\0\0\x07\0\0\0\0\x7a\x0c\0\0\0\0\0\x07\0\0\0\
+\0\x85\x0c\0\0\0\0\0\x07\0\0\0\0\x96\x0c\0\0\0\0\0\x07\0\0\0\0\xa5\x0c\0\0\0\0\
+\0\x07\0\0\0\0\xe6\x05\0\0\0\0\0\x07\0\0\0\0\xba\x0c\0\0\0\0\0\x07\0\0\0\0\xca\
+\x0c\0\0\0\0\0\x07\0\0\0\0\xa3\x0b\0\0\0\0\0\x07\0\0\0\0\xd4\x0c\0\0\0\0\0\x07\
+\0\0\0\0\xe0\x0c\0\0\0\0\0\x07\0\0\0\0\xe9\x0c\0\0\0\0\0\x0e\x02\0\0\0\x01\0\0\
+\0\0\x69\x6e\x74\0\x5f\x5f\x41\x52\x52\x41\x59\x5f\x53\x49\x5a\x45\x5f\x54\x59\
+\x50\x45\x5f\x5f\0\x74\x79\x70\x65\0\x6d\x61\x78\x5f\x65\x6e\x74\x72\x69\x65\
+\x73\0\x6b\x65\x79\x5f\x73\x69\x7a\x65\0\x76\x61\x6c\x75\x65\x5f\x73\x69\x7a\
+\x65\0\x68\x69\x64\x5f\x6a\x6d\x70\x5f\x74\x61\x62\x6c\x65\0\x5f\x5f\x75\x38\0\
+\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x63\x68\x61\x72\0\x6b\x65\x79\0\x76\x61\
+\x6c\x75\x65\0\x70\x72\x6f\x67\x73\x5f\x6d\x61\x70\0\x75\x6e\x73\x69\x67\x6e\
+\x65\x64\x20\x6c\x6f\x6e\x67\x20\x6c\x6f\x6e\x67\0\x63\x74\x78\0\x68\x69\x64\
+\x5f\x74\x61\x69\x6c\x5f\x63\x61\x6c\x6c\0\x66\x6d\x6f\x64\x5f\x72\x65\x74\x2f\
+\x5f\x5f\x68\x69\x64\x5f\x62\x70\x66\x5f\x74\x61\x69\x6c\x5f\x63\x61\x6c\x6c\0\
+\x2f\x68\x6f\x6d\x65\x2f\x62\x74\x69\x73\x73\x6f\x69\x72\x2f\x53\x72\x63\x2f\
+\x68\x69\x64\x2f\x64\x72\x69\x76\x65\x72\x73\x2f\x68\x69\x64\x2f\x62\x70\x66\
+\x2f\x65\x6e\x74\x72\x79\x70\x6f\x69\x6e\x74\x73\x2f\x65\x6e\x74\x72\x79\x70\
+\x6f\x69\x6e\x74\x73\x2e\x62\x70\x66\x2e\x63\0\x69\x6e\x74\x20\x42\x50\x46\x5f\
+\x50\x52\x4f\x47\x28\x68\x69\x64\x5f\x74\x61\x69\x6c\x5f\x63\x61\x6c\x6c\x2c\
+\x20\x73\x74\x72\x75\x63\x74\x20\x68\x69\x64\x5f\x62\x70\x66\x5f\x63\x74\x78\
+\x20\x2a\x68\x63\x74\x78\x29\0\x68\x69\x64\x5f\x62\x70\x66\x5f\x63\x74\x78\0\
+\x69\x6e\x64\x65\x78\0\x68\x69\x64\0\x61\x6c\x6c\x6f\x63\x61\x74\x65\x64\x5f\
+\x73\x69\x7a\x65\0\x72\x65\x70\x6f\x72\x74\x5f\x74\x79\x70\x65\0\x5f\x5f\x75\
+\x33\x32\0\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x69\x6e\x74\0\x68\x69\x64\x5f\
+\x72\x65\x70\x6f\x72\x74\x5f\x74\x79\x70\x65\0\x48\x49\x44\x5f\x49\x4e\x50\x55\
+\x54\x5f\x52\x45\x50\x4f\x52\x54\0\x48\x49\x44\x5f\x4f\x55\x54\x50\x55\x54\x5f\
+\x52\x45\x50\x4f\x52\x54\0\x48\x49\x44\x5f\x46\x45\x41\x54\x55\x52\x45\x5f\x52\
+\x45\x50\x4f\x52\x54\0\x48\x49\x44\x5f\x52\x45\x50\x4f\x52\x54\x5f\x54\x59\x50\
+\x45\x53\0\x72\x65\x74\x76\x61\x6c\0\x73\x69\x7a\x65\0\x5f\x5f\x73\x33\x32\0\
+\x30\x3a\x30\0\x09\x62\x70\x66\x5f\x74\x61\x69\x6c\x5f\x63\x61\x6c\x6c\x28\x63\
+\x74\x78\x2c\x20\x26\x68\x69\x64\x5f\x6a\x6d\x70\x5f\x74\x61\x62\x6c\x65\x2c\
+\x20\x68\x63\x74\x78\x2d\x3e\x69\x6e\x64\x65\x78\x29\x3b\0\x68\x69\x64\x5f\x70\
+\x72\x6f\x67\x5f\x72\x65\x6c\x65\x61\x73\x65\0\x66\x65\x78\x69\x74\x2f\x62\x70\
+\x66\x5f\x70\x72\x6f\x67\x5f\x72\x65\x6c\x65\x61\x73\x65\0\x69\x6e\x74\x20\x42\
+\x50\x46\x5f\x50\x52\x4f\x47\x28\x68\x69\x64\x5f\x70\x72\x6f\x67\x5f\x72\x65\
+\x6c\x65\x61\x73\x65\x2c\x20\x73\x74\x72\x75\x63\x74\x20\x69\x6e\x6f\x64\x65\
+\x20\x2a\x69\x6e\x6f\x64\x65\x2c\x20\x73\x74\x72\x75\x63\x74\x20\x66\x69\x6c\
+\x65\x20\x2a\x66\x69\x6c\x70\x29\0\x66\x69\x6c\x65\0\x66\x5f\x75\0\x66\x5f\x70\
+\x61\x74\x68\0\x66\x5f\x69\x6e\x6f\x64\x65\0\x66\x5f\x6f\x70\0\x66\x5f\x6c\x6f\
+\x63\x6b\0\x66\x5f\x63\x6f\x75\x6e\x74\0\x66\x5f\x66\x6c\x61\x67\x73\0\x66\x5f\
+\x6d\x6f\x64\x65\0\x66\x5f\x70\x6f\x73\x5f\x6c\x6f\x63\x6b\0\x66\x5f\x70\x6f\
+\x73\0\x66\x5f\x6f\x77\x6e\x65\x72\0\x66\x5f\x63\x72\x65\x64\0\x66\x5f\x72\x61\
+\0\x66\x5f\x76\x65\x72\x73\x69\x6f\x6e\0\x66\x5f\x73\x65\x63\x75\x72\x69\x74\
+\x79\0\x70\x72\x69\x76\x61\x74\x65\x5f\x64\x61\x74\x61\0\x66\x5f\x65\x70\0\x66\
+\x5f\x6d\x61\x70\x70\x69\x6e\x67\0\x66\x5f\x77\x62\x5f\x65\x72\x72\0\x66\x5f\
+\x73\x62\x5f\x65\x72\x72\0\x66\x75\x5f\x6c\x6c\x69\x73\x74\0\x66\x75\x5f\x72\
+\x63\x75\x68\x65\x61\x64\0\x6c\x6c\x69\x73\x74\x5f\x6e\x6f\x64\x65\0\x6e\x65\
+\x78\x74\0\x63\x61\x6c\x6c\x62\x61\x63\x6b\x5f\x68\x65\x61\x64\0\x66\x75\x6e\
+\x63\0\x70\x61\x74\x68\0\x6d\x6e\x74\0\x64\x65\x6e\x74\x72\x79\0\x73\x70\x69\
+\x6e\x6c\x6f\x63\x6b\x5f\x74\0\x73\x70\x69\x6e\x6c\x6f\x63\x6b\0\x72\x6c\x6f\
+\x63\x6b\0\x72\x61\x77\x5f\x73\x70\x69\x6e\x6c\x6f\x63\x6b\0\x72\x61\x77\x5f\
+\x6c\x6f\x63\x6b\0\x6d\x61\x67\x69\x63\0\x6f\x77\x6e\x65\x72\x5f\x63\x70\x75\0\
+\x6f\x77\x6e\x65\x72\0\x64\x65\x70\x5f\x6d\x61\x70\0\x61\x72\x63\x68\x5f\x73\
+\x70\x69\x6e\x6c\x6f\x63\x6b\x5f\x74\0\x71\x73\x70\x69\x6e\x6c\x6f\x63\x6b\0\
+\x76\x61\x6c\0\x61\x74\x6f\x6d\x69\x63\x5f\x74\0\x63\x6f\x75\x6e\x74\x65\x72\0\
+\x6c\x6f\x63\x6b\x65\x64\0\x70\x65\x6e\x64\x69\x6e\x67\0\x75\x38\0\x6c\x6f\x63\
+\x6b\x65\x64\x5f\x70\x65\x6e\x64\x69\x6e\x67\0\x74\x61\x69\x6c\0\x75\x31\x36\0\
+\x5f\x5f\x75\x31\x36\0\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x73\x68\x6f\x72\x74\
+\0\x6c\x6f\x63\x6b\x64\x65\x70\x5f\x6d\x61\x70\0\x63\x6c\x61\x73\x73\x5f\x63\
+\x61\x63\x68\x65\0\x6e\x61\x6d\x65\0\x77\x61\x69\x74\x5f\x74\x79\x70\x65\x5f\
+\x6f\x75\x74\x65\x72\0\x77\x61\x69\x74\x5f\x74\x79\x70\x65\x5f\x69\x6e\x6e\x65\
+\x72\0\x6c\x6f\x63\x6b\x5f\x74\x79\x70\x65\0\x6c\x6f\x63\x6b\x5f\x63\x6c\x61\
+\x73\x73\0\x68\x61\x73\x68\x5f\x65\x6e\x74\x72\x79\0\x6c\x6f\x63\x6b\x5f\x65\
+\x6e\x74\x72\x79\0\x6c\x6f\x63\x6b\x73\x5f\x61\x66\x74\x65\x72\0\x6c\x6f\x63\
+\x6b\x73\x5f\x62\x65\x66\x6f\x72\x65\0\x73\x75\x62\x63\x6c\x61\x73\x73\0\x64\
+\x65\x70\x5f\x67\x65\x6e\x5f\x69\x64\0\x75\x73\x61\x67\x65\x5f\x6d\x61\x73\x6b\
+\0\x75\x73\x61\x67\x65\x5f\x74\x72\x61\x63\x65\x73\0\x6e\x61\x6d\x65\x5f\x76\
+\x65\x72\x73\x69\x6f\x6e\0\x68\x6c\x69\x73\x74\x5f\x6e\x6f\x64\x65\0\x70\x70\
+\x72\x65\x76\0\x6c\x69\x73\x74\x5f\x68\x65\x61\x64\0\x70\x72\x65\x76\0\x75\x6e\
+\x73\x69\x67\x6e\x65\x64\x20\x6c\x6f\x6e\x67\0\x6c\x6f\x63\x6b\x5f\x74\x72\x61\
+\x63\x65\0\x68\x61\x73\x68\0\x6e\x72\x5f\x65\x6e\x74\x72\x69\x65\x73\0\x65\x6e\
+\x74\x72\x69\x65\x73\0\x75\x33\x32\0\x63\x68\x61\x72\0\x5f\x5f\x70\x61\x64\x64\
+\x69\x6e\x67\0\x61\x74\x6f\x6d\x69\x63\x5f\x6c\x6f\x6e\x67\x5f\x74\0\x61\x74\
+\x6f\x6d\x69\x63\x36\x34\x5f\x74\0\x73\x36\x34\0\x5f\x5f\x73\x36\x34\0\x6c\x6f\
+\x6e\x67\x20\x6c\x6f\x6e\x67\0\x66\x6d\x6f\x64\x65\x5f\x74\0\x6d\x75\x74\x65\
+\x78\0\x77\x61\x69\x74\x5f\x6c\x6f\x63\x6b\0\x6f\x73\x71\0\x77\x61\x69\x74\x5f\
+\x6c\x69\x73\x74\0\x72\x61\x77\x5f\x73\x70\x69\x6e\x6c\x6f\x63\x6b\x5f\x74\0\
+\x6f\x70\x74\x69\x6d\x69\x73\x74\x69\x63\x5f\x73\x70\x69\x6e\x5f\x71\x75\x65\
+\x75\x65\0\x6c\x6f\x66\x66\x5f\x74\0\x5f\x5f\x6b\x65\x72\x6e\x65\x6c\x5f\x6c\
+\x6f\x66\x66\x5f\x74\0\x66\x6f\x77\x6e\x5f\x73\x74\x72\x75\x63\x74\0\x6c\x6f\
+\x63\x6b\0\x70\x69\x64\0\x70\x69\x64\x5f\x74\x79\x70\x65\0\x75\x69\x64\0\x65\
+\x75\x69\x64\0\x73\x69\x67\x6e\x75\x6d\0\x72\x77\x6c\x6f\x63\x6b\x5f\x74\0\x61\
+\x72\x63\x68\x5f\x72\x77\x6c\x6f\x63\x6b\x5f\x74\0\x71\x72\x77\x6c\x6f\x63\x6b\
+\0\x63\x6e\x74\x73\0\x77\x6c\x6f\x63\x6b\x65\x64\0\x5f\x5f\x6c\x73\x74\x61\x74\
+\x65\0\x50\x49\x44\x54\x59\x50\x45\x5f\x50\x49\x44\0\x50\x49\x44\x54\x59\x50\
+\x45\x5f\x54\x47\x49\x44\0\x50\x49\x44\x54\x59\x50\x45\x5f\x50\x47\x49\x44\0\
+\x50\x49\x44\x54\x59\x50\x45\x5f\x53\x49\x44\0\x50\x49\x44\x54\x59\x50\x45\x5f\
+\x4d\x41\x58\0\x6b\x75\x69\x64\x5f\x74\0\x75\x69\x64\x5f\x74\0\x5f\x5f\x6b\x65\
+\x72\x6e\x65\x6c\x5f\x75\x69\x64\x33\x32\x5f\x74\0\x66\x69\x6c\x65\x5f\x72\x61\
+\x5f\x73\x74\x61\x74\x65\0\x73\x74\x61\x72\x74\0\x61\x73\x79\x6e\x63\x5f\x73\
+\x69\x7a\x65\0\x72\x61\x5f\x70\x61\x67\x65\x73\0\x6d\x6d\x61\x70\x5f\x6d\x69\
+\x73\x73\0\x70\x72\x65\x76\x5f\x70\x6f\x73\0\x75\x36\x34\0\x5f\x5f\x75\x36\x34\
+\0\x65\x72\x72\x73\x65\x71\x5f\x74\0\x30\x3a\x31\x35\0\x09\x75\x36\x34\x20\x70\
+\x72\x6f\x67\x20\x3d\x20\x28\x75\x36\x34\x29\x66\x69\x6c\x70\x2d\x3e\x70\x72\
+\x69\x76\x61\x74\x65\x5f\x64\x61\x74\x61\x3b\0\x09\x76\x61\x6c\x75\x65\x20\x3d\
+\x20\x62\x70\x66\x5f\x6d\x61\x70\x5f\x6c\x6f\x6f\x6b\x75\x70\x5f\x65\x6c\x65\
+\x6d\x28\x26\x70\x72\x6f\x67\x73\x5f\x6d\x61\x70\x2c\x20\x26\x70\x72\x6f\x67\
+\x29\x3b\0\x09\x69\x66\x20\x28\x21\x76\x61\x6c\x75\x65\x29\0\x09\x69\x66\x20\
+\x28\x63\x61\x6c\x6c\x5f\x68\x69\x64\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\x5f\
+\x72\x65\x6c\x65\x61\x73\x65\x28\x70\x72\x6f\x67\x2c\x20\x2a\x76\x61\x6c\x75\
+\x65\x29\x29\0\x09\x09\x62\x70\x66\x5f\x6d\x61\x70\x5f\x64\x65\x6c\x65\x74\x65\
+\x5f\x65\x6c\x65\x6d\x28\x26\x70\x72\x6f\x67\x73\x5f\x6d\x61\x70\x2c\x20\x26\
+\x70\x72\x6f\x67\x29\x3b\0\x62\x6f\x6f\x6c\0\x5f\x42\x6f\x6f\x6c\0\x63\x61\x6c\
+\x6c\x5f\x68\x69\x64\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\x5f\x72\x65\x6c\x65\
+\x61\x73\x65\0\x68\x69\x64\x5f\x66\x72\x65\x65\x5f\x69\x6e\x6f\x64\x65\0\x66\
+\x65\x78\x69\x74\x2f\x62\x70\x66\x5f\x66\x72\x65\x65\x5f\x69\x6e\x6f\x64\x65\0\
+\x69\x6e\x74\x20\x42\x50\x46\x5f\x50\x52\x4f\x47\x28\x68\x69\x64\x5f\x66\x72\
+\x65\x65\x5f\x69\x6e\x6f\x64\x65\x2c\x20\x73\x74\x72\x75\x63\x74\x20\x69\x6e\
+\x6f\x64\x65\x20\x2a\x69\x6e\x6f\x64\x65\x29\0\x69\x6e\x6f\x64\x65\0\x69\x5f\
+\x6d\x6f\x64\x65\0\x69\x5f\x6f\x70\x66\x6c\x61\x67\x73\0\x69\x5f\x75\x69\x64\0\
+\x69\x5f\x67\x69\x64\0\x69\x5f\x66\x6c\x61\x67\x73\0\x69\x5f\x61\x63\x6c\0\x69\
+\x5f\x64\x65\x66\x61\x75\x6c\x74\x5f\x61\x63\x6c\0\x69\x5f\x6f\x70\0\x69\x5f\
+\x73\x62\0\x69\x5f\x6d\x61\x70\x70\x69\x6e\x67\0\x69\x5f\x73\x65\x63\x75\x72\
+\x69\x74\x79\0\x69\x5f\x69\x6e\x6f\0\x69\x5f\x72\x64\x65\x76\0\x69\x5f\x73\x69\
+\x7a\x65\0\x69\x5f\x61\x74\x69\x6d\x65\0\x69\x5f\x6d\x74\x69\x6d\x65\0\x69\x5f\
+\x63\x74\x69\x6d\x65\0\x69\x5f\x6c\x6f\x63\x6b\0\x69\x5f\x62\x79\x74\x65\x73\0\
+\x69\x5f\x62\x6c\x6b\x62\x69\x74\x73\0\x69\x5f\x77\x72\x69\x74\x65\x5f\x68\x69\
+\x6e\x74\0\x69\x5f\x62\x6c\x6f\x63\x6b\x73\0\x69\x5f\x73\x74\x61\x74\x65\0\x69\
+\x5f\x72\x77\x73\x65\x6d\0\x64\x69\x72\x74\x69\x65\x64\x5f\x77\x68\x65\x6e\0\
+\x64\x69\x72\x74\x69\x65\x64\x5f\x74\x69\x6d\x65\x5f\x77\x68\x65\x6e\0\x69\x5f\
+\x68\x61\x73\x68\0\x69\x5f\x69\x6f\x5f\x6c\x69\x73\x74\0\x69\x5f\x77\x62\0\x69\
+\x5f\x77\x62\x5f\x66\x72\x6e\x5f\x77\x69\x6e\x6e\x65\x72\0\x69\x5f\x77\x62\x5f\
+\x66\x72\x6e\x5f\x61\x76\x67\x5f\x74\x69\x6d\x65\0\x69\x5f\x77\x62\x5f\x66\x72\
+\x6e\x5f\x68\x69\x73\x74\x6f\x72\x79\0\x69\x5f\x6c\x72\x75\0\x69\x5f\x73\x62\
+\x5f\x6c\x69\x73\x74\0\x69\x5f\x77\x62\x5f\x6c\x69\x73\x74\0\x69\x5f\x76\x65\
+\x72\x73\x69\x6f\x6e\0\x69\x5f\x73\x65\x71\x75\x65\x6e\x63\x65\0\x69\x5f\x63\
+\x6f\x75\x6e\x74\0\x69\x5f\x64\x69\x6f\x5f\x63\x6f\x75\x6e\x74\0\x69\x5f\x77\
+\x72\x69\x74\x65\x63\x6f\x75\x6e\x74\0\x69\x5f\x72\x65\x61\x64\x63\x6f\x75\x6e\
+\x74\0\x69\x5f\x66\x6c\x63\x74\x78\0\x69\x5f\x64\x61\x74\x61\0\x69\x5f\x64\x65\
+\x76\x69\x63\x65\x73\0\x69\x5f\x67\x65\x6e\x65\x72\x61\x74\x69\x6f\x6e\0\x69\
+\x5f\x66\x73\x6e\x6f\x74\x69\x66\x79\x5f\x6d\x61\x73\x6b\0\x69\x5f\x66\x73\x6e\
+\x6f\x74\x69\x66\x79\x5f\x6d\x61\x72\x6b\x73\0\x69\x5f\x70\x72\x69\x76\x61\x74\
+\x65\0\x75\x6d\x6f\x64\x65\x5f\x74\0\x6b\x67\x69\x64\x5f\x74\0\x67\x69\x64\x5f\
+\x74\0\x5f\x5f\x6b\x65\x72\x6e\x65\x6c\x5f\x67\x69\x64\x33\x32\x5f\x74\0\x69\
+\x5f\x6e\x6c\x69\x6e\x6b\0\x5f\x5f\x69\x5f\x6e\x6c\x69\x6e\x6b\0\x64\x65\x76\
+\x5f\x74\0\x5f\x5f\x6b\x65\x72\x6e\x65\x6c\x5f\x64\x65\x76\x5f\x74\0\x74\x69\
+\x6d\x65\x73\x70\x65\x63\x36\x34\0\x74\x76\x5f\x73\x65\x63\0\x74\x76\x5f\x6e\
+\x73\x65\x63\0\x74\x69\x6d\x65\x36\x34\x5f\x74\0\x6c\x6f\x6e\x67\0\x62\x6c\x6b\
+\x63\x6e\x74\x5f\x74\0\x72\x77\x5f\x73\x65\x6d\x61\x70\x68\x6f\x72\x65\0\x63\
+\x6f\x75\x6e\x74\0\x69\x5f\x64\x65\x6e\x74\x72\x79\0\x69\x5f\x72\x63\x75\0\x68\
+\x6c\x69\x73\x74\x5f\x68\x65\x61\x64\0\x66\x69\x72\x73\x74\0\x69\x5f\x66\x6f\
+\x70\0\x66\x72\x65\x65\x5f\x69\x6e\x6f\x64\x65\0\x61\x64\x64\x72\x65\x73\x73\
+\x5f\x73\x70\x61\x63\x65\0\x68\x6f\x73\x74\0\x69\x5f\x70\x61\x67\x65\x73\0\x69\
+\x6e\x76\x61\x6c\x69\x64\x61\x74\x65\x5f\x6c\x6f\x63\x6b\0\x67\x66\x70\x5f\x6d\
+\x61\x73\x6b\0\x69\x5f\x6d\x6d\x61\x70\x5f\x77\x72\x69\x74\x61\x62\x6c\x65\0\
+\x69\x5f\x6d\x6d\x61\x70\0\x69\x5f\x6d\x6d\x61\x70\x5f\x72\x77\x73\x65\x6d\0\
+\x6e\x72\x70\x61\x67\x65\x73\0\x77\x72\x69\x74\x65\x62\x61\x63\x6b\x5f\x69\x6e\
+\x64\x65\x78\0\x61\x5f\x6f\x70\x73\0\x66\x6c\x61\x67\x73\0\x77\x62\x5f\x65\x72\
+\x72\0\x70\x72\x69\x76\x61\x74\x65\x5f\x6c\x6f\x63\x6b\0\x70\x72\x69\x76\x61\
+\x74\x65\x5f\x6c\x69\x73\x74\0\x78\x61\x72\x72\x61\x79\0\x78\x61\x5f\x6c\x6f\
+\x63\x6b\0\x78\x61\x5f\x66\x6c\x61\x67\x73\0\x78\x61\x5f\x68\x65\x61\x64\0\x67\
+\x66\x70\x5f\x74\0\x72\x62\x5f\x72\x6f\x6f\x74\x5f\x63\x61\x63\x68\x65\x64\0\
+\x72\x62\x5f\x72\x6f\x6f\x74\0\x72\x62\x5f\x6c\x65\x66\x74\x6d\x6f\x73\x74\0\
+\x72\x62\x5f\x6e\x6f\x64\x65\0\x69\x5f\x70\x69\x70\x65\0\x69\x5f\x63\x64\x65\
+\x76\0\x69\x5f\x6c\x69\x6e\x6b\0\x69\x5f\x64\x69\x72\x5f\x73\x65\x71\0\x30\x3a\
+\x35\x31\0\x09\x75\x36\x34\x20\x70\x72\x6f\x67\x20\x3d\x20\x28\x75\x36\x34\x29\
+\x69\x6e\x6f\x64\x65\x2d\x3e\x69\x5f\x70\x72\x69\x76\x61\x74\x65\x3b\0\x4c\x49\
+\x43\x45\x4e\x53\x45\0\x2e\x6b\x73\x79\x6d\x73\0\x2e\x6d\x61\x70\x73\0\x6c\x69\
+\x63\x65\x6e\x73\x65\0\x61\x64\x64\x72\x65\x73\x73\x5f\x73\x70\x61\x63\x65\x5f\
+\x6f\x70\x65\x72\x61\x74\x69\x6f\x6e\x73\0\x62\x64\x69\x5f\x77\x72\x69\x74\x65\
+\x62\x61\x63\x6b\0\x63\x64\x65\x76\0\x63\x72\x65\x64\0\x66\x69\x6c\x65\x5f\x6c\
+\x6f\x63\x6b\x5f\x63\x6f\x6e\x74\x65\x78\x74\0\x66\x69\x6c\x65\x5f\x6f\x70\x65\
+\x72\x61\x74\x69\x6f\x6e\x73\0\x66\x73\x6e\x6f\x74\x69\x66\x79\x5f\x6d\x61\x72\
+\x6b\x5f\x63\x6f\x6e\x6e\x65\x63\x74\x6f\x72\0\x68\x69\x64\x5f\x64\x65\x76\x69\
+\x63\x65\0\x69\x6e\x6f\x64\x65\x5f\x6f\x70\x65\x72\x61\x74\x69\x6f\x6e\x73\0\
+\x6c\x6f\x63\x6b\x5f\x63\x6c\x61\x73\x73\x5f\x6b\x65\x79\0\x6c\x6f\x63\x6b\x64\
+\x65\x70\x5f\x73\x75\x62\x63\x6c\x61\x73\x73\x5f\x6b\x65\x79\0\x70\x69\x70\x65\
+\x5f\x69\x6e\x6f\x64\x65\x5f\x69\x6e\x66\x6f\0\x70\x6f\x73\x69\x78\x5f\x61\x63\
+\x6c\0\x73\x75\x70\x65\x72\x5f\x62\x6c\x6f\x63\x6b\0\x76\x66\x73\x6d\x6f\x75\
+\x6e\x74\0\x64\x75\x6d\x6d\x79\x5f\x6b\x73\x79\x6d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\x84\x21\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\x04\0\0\0\x04\0\0\
+\0\0\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x68\x69\x64\x5f\x6a\x6d\x70\x5f\x74\x61\
+\x62\x6c\x65\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\
+\0\0\0\x08\0\0\0\x01\0\0\0\0\x08\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x70\x72\x6f\x67\
+\x73\x5f\x6d\x61\x70\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x10\0\0\0\x12\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\x47\x50\x4c\0\0\0\0\0\x79\x12\0\0\0\0\0\0\x61\x23\0\0\0\0\0\0\
+\x18\x52\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85\0\0\0\x0c\0\0\0\xb7\0\0\0\0\0\0\0\x95\
+\0\0\0\0\0\0\0\0\0\0\0\x19\0\0\0\0\0\0\0\xb5\0\0\0\xfa\0\0\0\x05\x6c\0\0\x01\0\
+\0\0\xb5\0\0\0\xe1\x01\0\0\x02\x74\0\0\x05\0\0\0\xb5\0\0\0\xfa\0\0\0\x05\x6c\0\
+\0\x08\0\0\0\x1a\0\0\0\xdd\x01\0\0\0\0\0\0\x1a\0\0\0\x07\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x68\x69\x64\
+\x5f\x74\x61\x69\x6c\x5f\x63\x61\x6c\x6c\0\0\0\0\0\0\0\x1a\0\0\0\0\0\0\0\x08\0\
+\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\x10\0\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\x01\0\0\0\0\
+\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x5f\x5f\x68\
+\x69\x64\x5f\x62\x70\x66\x5f\x74\x61\x69\x6c\x5f\x63\x61\x6c\x6c\0\0\0\0\0\x47\
+\x50\x4c\0\0\0\0\0\x79\x11\x08\0\0\0\0\0\x79\x11\xa8\x01\0\0\0\0\x7b\x1a\xf8\
+\xff\0\0\0\0\xbf\xa2\0\0\0\0\0\0\x07\x02\0\0\xf8\xff\xff\xff\x18\x51\0\0\x01\0\
+\0\0\0\0\0\0\0\0\0\0\x85\0\0\0\x01\0\0\0\x15\0\x09\0\0\0\0\0\x71\x02\0\0\0\0\0\
+\0\x79\xa1\xf8\xff\0\0\0\0\x85\x20\0\0\0\0\0\0\x15\0\x05\0\0\0\0\0\xbf\xa2\0\0\
+\0\0\0\0\x07\x02\0\0\xf8\xff\xff\xff\x18\x51\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\x85\
+\0\0\0\x03\0\0\0\xb7\0\0\0\0\0\0\0\x95\0\0\0\0\0\0\0\0\0\0\0\x23\0\0\0\0\0\0\0\
+\xb5\0\0\0\x3b\x02\0\0\x05\xbc\0\0\x01\0\0\0\xb5\0\0\0\xe7\x06\0\0\x18\xc4\0\0\
+\x04\0\0\0\xb5\0\0\0\0\0\0\0\0\0\0\0\x05\0\0\0\xb5\0\0\0\x0c\x07\0\0\x0a\x98\0\
+\0\x08\0\0\0\xb5\0\0\0\x3d\x07\0\0\x06\x9c\0\0\x09\0\0\0\xb5\0\0\0\x4a\x07\0\0\
+\x26\xa8\0\0\x0a\0\0\0\xb5\0\0\0\x4a\x07\0\0\x20\xa8\0\0\x0b\0\0\0\xb5\0\0\0\
+\x4a\x07\0\0\x06\xa8\0\0\x0c\0\0\0\xb5\0\0\0\x4a\x07\0\0\x06\xa8\0\0\x0e\0\0\0\
+\xb5\0\0\0\0\0\0\0\0\0\0\0\x0f\0\0\0\xb5\0\0\0\x78\x07\0\0\x03\xac\0\0\x12\0\0\
+\0\xb5\0\0\0\x3b\x02\0\0\x05\xbc\0\0\x08\0\0\0\x24\0\0\0\xe2\x06\0\0\0\0\0\0\
+\x1a\0\0\0\x14\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\x68\x69\x64\x5f\x70\x72\x6f\x67\x5f\x72\x65\x6c\x65\x61\
+\x73\0\0\0\0\0\x19\0\0\0\0\0\0\0\x08\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\x10\0\0\0\
+\0\0\0\0\0\0\0\0\x0c\0\0\0\x01\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\x10\0\0\0\0\0\0\0\x62\x70\x66\x5f\x70\x72\x6f\x67\x5f\x72\x65\x6c\x65\
+\x61\x73\x65\0\0\0\0\0\0\0\0\x63\x61\x6c\x6c\x5f\x68\x69\x64\x5f\x62\x70\x66\
+\x5f\x70\x72\x6f\x67\x5f\x72\x65\x6c\x65\x61\x73\x65\0\0\0\0\0\0\0\x47\x50\x4c\
+\0\0\0\0\0\x79\x11\0\0\0\0\0\0\x79\x11\x70\x04\0\0\0\0\x7b\x1a\xf8\xff\0\0\0\0\
+\xbf\xa2\0\0\0\0\0\0\x07\x02\0\0\xf8\xff\xff\xff\x18\x51\0\0\x01\0\0\0\0\0\0\0\
+\0\0\0\0\x85\0\0\0\x01\0\0\0\x15\0\x09\0\0\0\0\0\x71\x02\0\0\0\0\0\0\x79\xa1\
+\xf8\xff\0\0\0\0\x85\x20\0\0\0\0\0\0\x15\0\x05\0\0\0\0\0\xbf\xa2\0\0\0\0\0\0\
+\x07\x02\0\0\xf8\xff\xff\xff\x18\x51\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\x85\0\0\0\
+\x03\0\0\0\xb7\0\0\0\0\0\0\0\x95\0\0\0\0\0\0\0\0\0\0\0\x80\0\0\0\0\0\0\0\xb5\0\
+\0\0\xeb\x07\0\0\x05\xe4\0\0\x01\0\0\0\xb5\0\0\0\xcf\x0b\0\0\x19\xec\0\0\x04\0\
+\0\0\xb5\0\0\0\0\0\0\0\0\0\0\0\x05\0\0\0\xb5\0\0\0\x0c\x07\0\0\x0a\x98\0\0\x08\
+\0\0\0\xb5\0\0\0\x3d\x07\0\0\x06\x9c\0\0\x09\0\0\0\xb5\0\0\0\x4a\x07\0\0\x26\
+\xa8\0\0\x0a\0\0\0\xb5\0\0\0\x4a\x07\0\0\x20\xa8\0\0\x0b\0\0\0\xb5\0\0\0\x4a\
+\x07\0\0\x06\xa8\0\0\x0c\0\0\0\xb5\0\0\0\x4a\x07\0\0\x06\xa8\0\0\x0e\0\0\0\xb5\
+\0\0\0\0\0\0\0\0\0\0\0\x0f\0\0\0\xb5\0\0\0\x78\x07\0\0\x03\xac\0\0\x12\0\0\0\
+\xb5\0\0\0\xeb\x07\0\0\x05\xe4\0\0\x08\0\0\0\x81\0\0\0\xca\x0b\0\0\0\0\0\0\x1a\
+\0\0\0\x14\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\x68\x69\x64\x5f\x66\x72\x65\x65\x5f\x69\x6e\x6f\x64\x65\0\0\
+\0\0\0\0\x19\0\0\0\0\0\0\0\x08\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\x10\0\0\0\0\0\0\
+\0\0\0\0\0\x0c\0\0\0\x01\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\x10\0\0\0\0\0\0\0\x62\x70\x66\x5f\x66\x72\x65\x65\x5f\x69\x6e\x6f\x64\x65\0\
+\0\x63\x61\x6c\x6c\x5f\x68\x69\x64\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\x5f\x72\
+\x65\x6c\x65\x61\x73\x65\0\0\0\0\0\0\0";
+	opts.insns_sz = 3152;
+	opts.insns = (void *)"\
+\xbf\x16\0\0\0\0\0\0\xbf\xa1\0\0\0\0\0\0\x07\x01\0\0\x78\xff\xff\xff\xb7\x02\0\
+\0\x88\0\0\0\xb7\x03\0\0\0\0\0\0\x85\0\0\0\x71\0\0\0\x05\0\x1d\0\0\0\0\0\x61\
+\xa1\x78\xff\0\0\0\0\xd5\x01\x01\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\x61\xa1\x7c\xff\
+\0\0\0\0\xd5\x01\x01\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\x61\xa1\x80\xff\0\0\0\0\xd5\
+\x01\x01\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\x61\xa1\x84\xff\0\0\0\0\xd5\x01\x01\0\0\
+\0\0\0\x85\0\0\0\xa8\0\0\0\x61\xa1\x88\xff\0\0\0\0\xd5\x01\x01\0\0\0\0\0\x85\0\
+\0\0\xa8\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x61\x01\0\0\0\0\0\0\xd5\x01\
+\x02\0\0\0\0\0\xbf\x19\0\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\x18\x60\0\0\0\0\0\0\0\0\
+\0\0\x04\0\0\0\x61\x01\0\0\0\0\0\0\xd5\x01\x02\0\0\0\0\0\xbf\x19\0\0\0\0\0\0\
+\x85\0\0\0\xa8\0\0\0\xbf\x70\0\0\0\0\0\0\x95\0\0\0\0\0\0\0\x61\x60\x08\0\0\0\0\
+\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xa0\x26\0\0\x63\x01\0\0\0\0\0\0\x61\x60\x0c\0\0\
+\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x9c\x26\0\0\x63\x01\0\0\0\0\0\0\x79\x60\x10\
+\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x90\x26\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\
+\0\0\0\0\0\0\0\0\0\0\0\x05\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x88\x26\0\0\x7b\x01\
+\0\0\0\0\0\0\xb7\x01\0\0\x12\0\0\0\x18\x62\0\0\0\0\0\0\0\0\0\0\x88\x26\0\0\xb7\
+\x03\0\0\x1c\0\0\0\x85\0\0\0\xa6\0\0\0\xbf\x07\0\0\0\0\0\0\xc5\x07\xcb\xff\0\0\
+\0\0\x63\x7a\x78\xff\0\0\0\0\x61\x60\x1c\0\0\0\0\0\x15\0\x03\0\0\0\0\0\x18\x61\
+\0\0\0\0\0\0\0\0\0\0\xb4\x26\0\0\x63\x01\0\0\0\0\0\0\xb7\x01\0\0\0\0\0\0\x18\
+\x62\0\0\0\0\0\0\0\0\0\0\xa8\x26\0\0\xb7\x03\0\0\x48\0\0\0\x85\0\0\0\xa6\0\0\0\
+\xbf\x07\0\0\0\0\0\0\xc5\x07\xbe\xff\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\x63\x71\0\0\0\0\0\0\x61\xa0\x78\xff\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x20\
+\x27\0\0\x63\x01\0\0\0\0\0\0\x61\x60\x2c\0\0\0\0\0\x15\0\x03\0\0\0\0\0\x18\x61\
+\0\0\0\0\0\0\0\0\0\0\xfc\x26\0\0\x63\x01\0\0\0\0\0\0\xb7\x01\0\0\0\0\0\0\x18\
+\x62\0\0\0\0\0\0\0\0\0\0\xf0\x26\0\0\xb7\x03\0\0\x48\0\0\0\x85\0\0\0\xa6\0\0\0\
+\xbf\x07\0\0\0\0\0\0\xc5\x07\xab\xff\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x04\0\
+\0\0\x63\x71\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x38\x27\0\0\x18\x61\0\0\0\
+\0\0\0\0\0\0\0\xd0\x27\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x40\
+\x27\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xc8\x27\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\
+\0\0\0\0\0\0\0\0\0\x78\x27\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x10\x28\0\0\x7b\x01\
+\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x80\x27\0\0\x18\x61\0\0\0\0\0\0\0\0\0\
+\0\x20\x28\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\xb0\x27\0\0\x18\
+\x61\0\0\0\0\0\0\0\0\0\0\x40\x28\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x38\x28\0\0\x7b\x01\0\0\0\0\0\0\x61\
+\x60\x08\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xd8\x27\0\0\x63\x01\0\0\0\0\0\0\
+\x61\x60\x0c\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xdc\x27\0\0\x63\x01\0\0\0\0\
+\0\0\x79\x60\x10\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xe0\x27\0\0\x7b\x01\0\0\
+\0\0\0\0\x61\xa0\x78\xff\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x08\x28\0\0\x63\
+\x01\0\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x50\x28\0\0\xb7\x02\0\0\x14\0\0\0\
+\xb7\x03\0\0\x0c\0\0\0\xb7\x04\0\0\0\0\0\0\x85\0\0\0\xa7\0\0\0\xbf\x07\0\0\0\0\
+\0\0\xc5\x07\x72\xff\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\xc0\x27\0\0\x63\x70\
+\x6c\0\0\0\0\0\x77\x07\0\0\x20\0\0\0\x63\x70\x70\0\0\0\0\0\xb7\x01\0\0\x05\0\0\
+\0\x18\x62\0\0\0\0\0\0\0\0\0\0\xc0\x27\0\0\xb7\x03\0\0\x8c\0\0\0\x85\0\0\0\xa6\
+\0\0\0\xbf\x07\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x30\x28\0\0\x61\x01\0\0\
+\0\0\0\0\xd5\x01\x02\0\0\0\0\0\xbf\x19\0\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\xc5\x07\
+\x60\xff\0\0\0\0\x63\x7a\x80\xff\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x68\x28\0\
+\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xf8\x29\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\
+\0\0\0\0\0\0\x70\x28\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xf0\x29\0\0\x7b\x01\0\0\0\
+\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x10\x29\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x38\
+\x2a\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x18\x29\0\0\x18\x61\0\
+\0\0\0\0\0\0\0\0\0\x48\x2a\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\
+\xd8\x29\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x68\x2a\0\0\x7b\x01\0\0\0\0\0\0\x18\
+\x60\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x60\x2a\0\0\x7b\
+\x01\0\0\0\0\0\0\x61\x60\x08\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\0\x2a\0\0\
+\x63\x01\0\0\0\0\0\0\x61\x60\x0c\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x04\x2a\
+\0\0\x63\x01\0\0\0\0\0\0\x79\x60\x10\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x08\
+\x2a\0\0\x7b\x01\0\0\0\0\0\0\x61\xa0\x78\xff\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\
+\0\x30\x2a\0\0\x63\x01\0\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x78\x2a\0\0\xb7\
+\x02\0\0\x11\0\0\0\xb7\x03\0\0\x0c\0\0\0\xb7\x04\0\0\0\0\0\0\x85\0\0\0\xa7\0\0\
+\0\xbf\x07\0\0\0\0\0\0\xc5\x07\x29\xff\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\xe8\
+\x29\0\0\x63\x70\x6c\0\0\0\0\0\x77\x07\0\0\x20\0\0\0\x63\x70\x70\0\0\0\0\0\x18\
+\x68\0\0\0\0\0\0\0\0\0\0\xc8\x28\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x90\x2a\0\0\
+\xb7\x02\0\0\x1a\0\0\0\xb7\x03\0\0\x0c\0\0\0\xb7\x04\0\0\0\0\0\0\x85\0\0\0\xa7\
+\0\0\0\xbf\x07\0\0\0\0\0\0\xc5\x07\x1a\xff\0\0\0\0\x75\x07\x03\0\0\0\0\0\x62\
+\x08\x04\0\0\0\0\0\x6a\x08\x02\0\0\0\0\0\x05\0\x0a\0\0\0\0\0\x63\x78\x04\0\0\0\
+\0\0\xbf\x79\0\0\0\0\0\0\x77\x09\0\0\x20\0\0\0\x55\x09\x02\0\0\0\0\0\x6a\x08\
+\x02\0\0\0\0\0\x05\0\x04\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\x63\
+\x90\0\0\0\0\0\0\x6a\x08\x02\0\x40\0\0\0\xb7\x01\0\0\x05\0\0\0\x18\x62\0\0\0\0\
+\0\0\0\0\0\0\xe8\x29\0\0\xb7\x03\0\0\x8c\0\0\0\x85\0\0\0\xa6\0\0\0\xbf\x07\0\0\
+\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\x61\x01\0\0\0\0\0\0\xd5\x01\x02\
+\0\0\0\0\0\xbf\x19\0\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\
+\x58\x2a\0\0\x61\x01\0\0\0\0\0\0\xd5\x01\x02\0\0\0\0\0\xbf\x19\0\0\0\0\0\0\x85\
+\0\0\0\xa8\0\0\0\xc5\x07\xf9\xfe\0\0\0\0\x63\x7a\x84\xff\0\0\0\0\x18\x60\0\0\0\
+\0\0\0\0\0\0\0\xb0\x2a\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x40\x2c\0\0\x7b\x01\0\0\
+\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\xb8\x2a\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\
+\x38\x2c\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x58\x2b\0\0\x18\
+\x61\0\0\0\0\0\0\0\0\0\0\x80\x2c\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\
+\0\0\0\x60\x2b\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x90\x2c\0\0\x7b\x01\0\0\0\0\0\0\
+\x18\x60\0\0\0\0\0\0\0\0\0\0\x20\x2c\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xb0\x2c\0\
+\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x18\x61\0\0\0\0\0\0\
+\0\0\0\0\xa8\x2c\0\0\x7b\x01\0\0\0\0\0\0\x61\x60\x08\0\0\0\0\0\x18\x61\0\0\0\0\
+\0\0\0\0\0\0\x48\x2c\0\0\x63\x01\0\0\0\0\0\0\x61\x60\x0c\0\0\0\0\0\x18\x61\0\0\
+\0\0\0\0\0\0\0\0\x4c\x2c\0\0\x63\x01\0\0\0\0\0\0\x79\x60\x10\0\0\0\0\0\x18\x61\
+\0\0\0\0\0\0\0\0\0\0\x50\x2c\0\0\x7b\x01\0\0\0\0\0\0\x61\xa0\x78\xff\0\0\0\0\
+\x18\x61\0\0\0\0\0\0\0\0\0\0\x78\x2c\0\0\x63\x01\0\0\0\0\0\0\x18\x61\0\0\0\0\0\
+\0\0\0\0\0\xc0\x2c\0\0\xb7\x02\0\0\x0f\0\0\0\xb7\x03\0\0\x0c\0\0\0\xb7\x04\0\0\
+\0\0\0\0\x85\0\0\0\xa7\0\0\0\xbf\x07\0\0\0\0\0\0\xc5\x07\xc2\xfe\0\0\0\0\x18\
+\x60\0\0\0\0\0\0\0\0\0\0\x30\x2c\0\0\x63\x70\x6c\0\0\0\0\0\x77\x07\0\0\x20\0\0\
+\0\x63\x70\x70\0\0\0\0\0\x18\x68\0\0\0\0\0\0\0\0\0\0\x10\x2b\0\0\x18\x61\0\0\0\
+\0\0\0\0\0\0\0\xd0\x2c\0\0\xb7\x02\0\0\x1a\0\0\0\xb7\x03\0\0\x0c\0\0\0\xb7\x04\
+\0\0\0\0\0\0\x85\0\0\0\xa7\0\0\0\xbf\x07\0\0\0\0\0\0\xc5\x07\xb3\xfe\0\0\0\0\
+\x75\x07\x03\0\0\0\0\0\x62\x08\x04\0\0\0\0\0\x6a\x08\x02\0\0\0\0\0\x05\0\x0a\0\
+\0\0\0\0\x63\x78\x04\0\0\0\0\0\xbf\x79\0\0\0\0\0\0\x77\x09\0\0\x20\0\0\0\x55\
+\x09\x02\0\0\0\0\0\x6a\x08\x02\0\0\0\0\0\x05\0\x04\0\0\0\0\0\x18\x60\0\0\0\0\0\
+\0\0\0\0\0\0\x01\0\0\x63\x90\0\0\0\0\0\0\x6a\x08\x02\0\x40\0\0\0\xb7\x01\0\0\
+\x05\0\0\0\x18\x62\0\0\0\0\0\0\0\0\0\0\x30\x2c\0\0\xb7\x03\0\0\x8c\0\0\0\x85\0\
+\0\0\xa6\0\0\0\xbf\x07\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\x61\
+\x01\0\0\0\0\0\0\xd5\x01\x02\0\0\0\0\0\xbf\x19\0\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\
+\x18\x60\0\0\0\0\0\0\0\0\0\0\xa0\x2c\0\0\x61\x01\0\0\0\0\0\0\xd5\x01\x02\0\0\0\
+\0\0\xbf\x19\0\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\xc5\x07\x92\xfe\0\0\0\0\x63\x7a\
+\x88\xff\0\0\0\0\x61\xa1\x78\xff\0\0\0\0\xd5\x01\x02\0\0\0\0\0\xbf\x19\0\0\0\0\
+\0\0\x85\0\0\0\xa8\0\0\0\x61\xa0\x80\xff\0\0\0\0\x63\x06\x38\0\0\0\0\0\x61\xa0\
+\x84\xff\0\0\0\0\x63\x06\x3c\0\0\0\0\0\x61\xa0\x88\xff\0\0\0\0\x63\x06\x40\0\0\
+\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x61\x10\0\0\0\0\0\0\x63\x06\x18\0\0\
+\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x04\0\0\0\x61\x10\0\0\0\0\0\0\x63\x06\x28\0\
+\0\0\0\0\xb7\0\0\0\0\0\0\0\x95\0\0\0\0\0\0\0";
+	err = bpf_load_and_run(&opts);
+	if (err < 0)
+		return err;
+	return 0;
+}
+
+static inline struct entrypoints_bpf *
+entrypoints_bpf__open_and_load(void)
+{
+	struct entrypoints_bpf *skel;
+
+	skel = entrypoints_bpf__open();
+	if (!skel)
+		return NULL;
+	if (entrypoints_bpf__load(skel)) {
+		entrypoints_bpf__destroy(skel);
+		return NULL;
+	}
+	return skel;
+}
+
+__attribute__((unused)) static void
+entrypoints_bpf__assert(struct entrypoints_bpf *s __attribute__((unused)))
+{
+#ifdef __cplusplus
+#define _Static_assert static_assert
+#endif
+#ifdef __cplusplus
+#undef _Static_assert
+#endif
+}
+
+#endif /* __ENTRYPOINTS_BPF_SKEL_H__ */
diff --git a/drivers/hid/bpf/hid_bpf_dispatch.c b/drivers/hid/bpf/hid_bpf_dispatch.c
new file mode 100644
index 000000000000..600b00fdf6c1
--- /dev/null
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ *  HID-BPF support for Linux
+ *
+ *  Copyright (c) 2022 Benjamin Tissoires
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/bitops.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
+#include <linux/filter.h>
+#include <linux/hid.h>
+#include <linux/hid_bpf.h>
+#include <linux/init.h>
+#include <linux/kfifo.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include "hid_bpf_dispatch.h"
+#include "entrypoints/entrypoints.lskel.h"
+
+struct hid_bpf_ops *hid_bpf_ops;
+EXPORT_SYMBOL(hid_bpf_ops);
+
+/**
+ * hid_bpf_device_event - Called whenever an event is coming in from the device
+ *
+ * @ctx: The HID-BPF context
+ *
+ * @return %0 on success and keep processing; a negative error code to interrupt
+ * the processing of this event
+ *
+ * Declare an %fmod_ret tracing bpf program to this function and attach this
+ * program through hid_bpf_attach_prog() to have this helper called for
+ * any incoming event from the device itself.
+ *
+ * The function is called while on IRQ context, so we can not sleep.
+ */
+/* never used by the kernel but declared so we can load and attach a tracepoint */
+__weak noinline int hid_bpf_device_event(struct hid_bpf_ctx *ctx)
+{
+	return 0;
+}
+ALLOW_ERROR_INJECTION(hid_bpf_device_event, ERRNO);
+
+int
+dispatch_hid_bpf_device_event(struct hid_device *hdev, enum hid_report_type type, u8 *data,
+			      u32 size, int interrupt)
+{
+	struct hid_bpf_ctx_kern ctx_kern = {
+		.ctx = {
+			.hid = hdev,
+			.report_type = type,
+			.size = size,
+		},
+		.data = data,
+	};
+
+	if (type >= HID_REPORT_TYPES)
+		return -EINVAL;
+
+	return hid_bpf_prog_run(hdev, HID_BPF_PROG_TYPE_DEVICE_EVENT, &ctx_kern);
+}
+EXPORT_SYMBOL_GPL(dispatch_hid_bpf_device_event);
+
+/**
+ * hid_bpf_get_data - Get the kernel memory pointer associated with the context @ctx
+ *
+ * @ctx: The HID-BPF context
+ * @offset: The offset within the memory
+ * @rdwr_buf_size: the const size of the buffer
+ *
+ * @returns %NULL on error, an %__u8 memory pointer on success
+ */
+noinline __u8 *
+hid_bpf_get_data(struct hid_bpf_ctx *ctx, unsigned int offset, const size_t rdwr_buf_size)
+{
+	struct hid_bpf_ctx_kern *ctx_kern;
+
+	if (!ctx)
+		return NULL;
+
+	ctx_kern = container_of(ctx, struct hid_bpf_ctx_kern, ctx);
+
+	if (rdwr_buf_size + offset > ctx->size)
+		return NULL;
+
+	return ctx_kern->data + offset;
+}
+
+/*
+ * The following set contains all functions we agree BPF programs
+ * can use.
+ */
+BTF_SET8_START(hid_bpf_kfunc_ids)
+BTF_ID_FLAGS(func, call_hid_bpf_prog_release)
+BTF_ID_FLAGS(func, hid_bpf_get_data, KF_RET_NULL)
+BTF_SET8_END(hid_bpf_kfunc_ids)
+
+static const struct btf_kfunc_id_set hid_bpf_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &hid_bpf_kfunc_ids,
+};
+
+static int device_match_id(struct device *dev, const void *id)
+{
+	struct hid_device *hdev = to_hid_device(dev);
+
+	return hdev->id == *(int *)id;
+}
+
+/**
+ * hid_bpf_attach_prog - Attach the given @prog_fd to the given HID device
+ *
+ * @hid_id: the system unique identifier of the HID device
+ * @prog_fd: an fd in the user process representing the program to attach
+ * @flags: any logical OR combination of &enum hid_bpf_attach_flags
+ *
+ * @returns %0 on success, an error code otherwise.
+ */
+/* called from syscall */
+noinline int
+hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, __u32 flags)
+{
+	struct hid_device *hdev;
+	struct device *dev;
+	int prog_type = hid_bpf_get_prog_attach_type(prog_fd);
+
+	if (!hid_bpf_ops)
+		return -EINVAL;
+
+	if (prog_type < 0)
+		return prog_type;
+
+	if (prog_type >= HID_BPF_PROG_TYPE_MAX)
+		return -EINVAL;
+
+	if ((flags & ~HID_BPF_FLAG_MASK))
+		return -EINVAL;
+
+	dev = bus_find_device(hid_bpf_ops->bus_type, NULL, &hid_id, device_match_id);
+	if (!dev)
+		return -EINVAL;
+
+	hdev = to_hid_device(dev);
+
+	return __hid_bpf_attach_prog(hdev, prog_type, prog_fd, flags);
+}
+
+/* for syscall HID-BPF */
+BTF_SET8_START(hid_bpf_syscall_kfunc_ids)
+BTF_ID_FLAGS(func, hid_bpf_attach_prog)
+BTF_SET8_END(hid_bpf_syscall_kfunc_ids)
+
+static const struct btf_kfunc_id_set hid_bpf_syscall_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &hid_bpf_syscall_kfunc_ids,
+};
+
+void hid_bpf_destroy_device(struct hid_device *hdev)
+{
+	if (!hdev)
+		return;
+
+	/* mark the device as destroyed in bpf so we don't reattach it */
+	hdev->bpf.destroyed = true;
+
+	__hid_bpf_destroy_device(hdev);
+}
+EXPORT_SYMBOL_GPL(hid_bpf_destroy_device);
+
+void hid_bpf_device_init(struct hid_device *hdev)
+{
+	spin_lock_init(&hdev->bpf.progs_lock);
+}
+EXPORT_SYMBOL_GPL(hid_bpf_device_init);
+
+static int __init hid_bpf_init(void)
+{
+	int err;
+
+	/* Note: if we exit with an error any time here, we would entirely break HID, which
+	 * is probably not something we want. So we log an error and return success.
+	 *
+	 * This is not a big deal: the syscall allowing to attach a BPF program to a HID device
+	 * will not be available, so nobody will be able to use the functionality.
+	 */
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &hid_bpf_kfunc_set);
+	if (err) {
+		pr_warn("error while setting HID BPF tracing kfuncs: %d", err);
+		return 0;
+	}
+
+	err = hid_bpf_preload_skel();
+	if (err) {
+		pr_warn("error while preloading HID BPF dispatcher: %d", err);
+		return 0;
+	}
+
+	/* register syscalls after we are sure we can load our preloaded bpf program */
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &hid_bpf_syscall_kfunc_set);
+	if (err) {
+		pr_warn("error while setting HID BPF syscall kfuncs: %d", err);
+		return 0;
+	}
+
+	return 0;
+}
+
+static void __exit hid_bpf_exit(void)
+{
+	/* HID depends on us, so if we hit that code, we are guaranteed that hid
+	 * has been removed and thus we do not need to clear the HID devices
+	 */
+	hid_bpf_free_links_and_skel();
+}
+
+late_initcall(hid_bpf_init);
+module_exit(hid_bpf_exit);
+MODULE_AUTHOR("Benjamin Tissoires");
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/bpf/hid_bpf_dispatch.h b/drivers/hid/bpf/hid_bpf_dispatch.h
new file mode 100644
index 000000000000..98c378e18b2b
--- /dev/null
+++ b/drivers/hid/bpf/hid_bpf_dispatch.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _BPF_HID_BPF_DISPATCH_H
+#define _BPF_HID_BPF_DISPATCH_H
+
+#include <linux/hid.h>
+
+struct hid_bpf_ctx_kern {
+	struct hid_bpf_ctx ctx;
+	u8 *data;
+};
+
+int hid_bpf_preload_skel(void);
+void hid_bpf_free_links_and_skel(void);
+int hid_bpf_get_prog_attach_type(int prog_fd);
+int __hid_bpf_attach_prog(struct hid_device *hdev, enum hid_bpf_prog_type prog_type, int prog_fd,
+			  __u32 flags);
+void __hid_bpf_destroy_device(struct hid_device *hdev);
+int hid_bpf_prog_run(struct hid_device *hdev, enum hid_bpf_prog_type type,
+		     struct hid_bpf_ctx_kern *ctx_kern);
+
+struct bpf_prog;
+
+/* HID-BPF internal kfuncs API */
+bool call_hid_bpf_prog_release(u64 prog, int table_cnt);
+
+#endif
diff --git a/drivers/hid/bpf/hid_bpf_jmp_table.c b/drivers/hid/bpf/hid_bpf_jmp_table.c
new file mode 100644
index 000000000000..05225ff3cc27
--- /dev/null
+++ b/drivers/hid/bpf/hid_bpf_jmp_table.c
@@ -0,0 +1,568 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ *  HID-BPF support for Linux
+ *
+ *  Copyright (c) 2022 Benjamin Tissoires
+ */
+
+#include <linux/bitops.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
+#include <linux/circ_buf.h>
+#include <linux/filter.h>
+#include <linux/hid.h>
+#include <linux/hid_bpf.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include "hid_bpf_dispatch.h"
+#include "entrypoints/entrypoints.lskel.h"
+
+#define HID_BPF_MAX_PROGS 1024 /* keep this in sync with preloaded bpf,
+				* needs to be a power of 2 as we use it as
+				* a circular buffer
+				*/
+
+#define NEXT(idx) (((idx) + 1) & (HID_BPF_MAX_PROGS - 1))
+#define PREV(idx) (((idx) - 1) & (HID_BPF_MAX_PROGS - 1))
+
+/*
+ * represents one attached program stored in the hid jump table
+ */
+struct hid_bpf_prog_entry {
+	struct bpf_prog *prog;
+	struct hid_device *hdev;
+	enum hid_bpf_prog_type type;
+	u16 idx;
+};
+
+struct hid_bpf_jmp_table {
+	struct bpf_map *map;
+	struct bpf_map *prog_keys;
+	struct hid_bpf_prog_entry entries[HID_BPF_MAX_PROGS]; /* compacted list, circular buffer */
+	int tail, head;
+	struct bpf_prog *progs[HID_BPF_MAX_PROGS]; /* idx -> progs mapping */
+	unsigned long enabled[BITS_TO_LONGS(HID_BPF_MAX_PROGS)];
+};
+
+#define FOR_ENTRIES(__i, __start, __end) \
+	for (__i = __start; CIRC_CNT(__end, __i, HID_BPF_MAX_PROGS); __i = NEXT(__i))
+
+static struct hid_bpf_jmp_table jmp_table;
+
+static DEFINE_MUTEX(hid_bpf_attach_lock);		/* held when attaching/detaching programs */
+
+static void hid_bpf_release_progs(struct work_struct *work);
+
+static DECLARE_WORK(release_work, hid_bpf_release_progs);
+
+BTF_ID_LIST(hid_bpf_btf_ids)
+BTF_ID(func, hid_bpf_device_event)			/* HID_BPF_PROG_TYPE_DEVICE_EVENT */
+
+static int hid_bpf_max_programs(enum hid_bpf_prog_type type)
+{
+	switch (type) {
+	case HID_BPF_PROG_TYPE_DEVICE_EVENT:
+		return HID_BPF_MAX_PROGS_PER_DEV;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int hid_bpf_program_count(struct hid_device *hdev,
+				 struct bpf_prog *prog,
+				 enum hid_bpf_prog_type type)
+{
+	int i, n = 0;
+
+	if (type >= HID_BPF_PROG_TYPE_MAX)
+		return -EINVAL;
+
+	FOR_ENTRIES(i, jmp_table.tail, jmp_table.head) {
+		struct hid_bpf_prog_entry *entry = &jmp_table.entries[i];
+
+		if (type != HID_BPF_PROG_TYPE_UNDEF && entry->type != type)
+			continue;
+
+		if (hdev && entry->hdev != hdev)
+			continue;
+
+		if (prog && entry->prog != prog)
+			continue;
+
+		n++;
+	}
+
+	return n;
+}
+
+__weak noinline int __hid_bpf_tail_call(struct hid_bpf_ctx *ctx)
+{
+	return 0;
+}
+ALLOW_ERROR_INJECTION(__hid_bpf_tail_call, ERRNO);
+
+int hid_bpf_prog_run(struct hid_device *hdev, enum hid_bpf_prog_type type,
+		     struct hid_bpf_ctx_kern *ctx_kern)
+{
+	struct hid_bpf_prog_list *prog_list;
+	int i, idx, err = 0;
+
+	rcu_read_lock();
+	prog_list = rcu_dereference(hdev->bpf.progs[type]);
+
+	if (!prog_list)
+		goto out_unlock;
+
+	for (i = 0; i < prog_list->prog_cnt; i++) {
+		idx = prog_list->prog_idx[i];
+
+		if (!test_bit(idx, jmp_table.enabled))
+			continue;
+
+		ctx_kern->ctx.index = idx;
+		err = __hid_bpf_tail_call(&ctx_kern->ctx);
+		if (err)
+			break;
+	}
+
+ out_unlock:
+	rcu_read_unlock();
+
+	return err;
+}
+
+/*
+ * assign the list of programs attached to a given hid device.
+ */
+static void __hid_bpf_set_hdev_progs(struct hid_device *hdev, struct hid_bpf_prog_list *new_list,
+				     enum hid_bpf_prog_type type)
+{
+	struct hid_bpf_prog_list *old_list;
+
+	spin_lock(&hdev->bpf.progs_lock);
+	old_list = rcu_dereference_protected(hdev->bpf.progs[type],
+					     lockdep_is_held(&hdev->bpf.progs_lock));
+	rcu_assign_pointer(hdev->bpf.progs[type], new_list);
+	spin_unlock(&hdev->bpf.progs_lock);
+	synchronize_rcu();
+
+	kfree(old_list);
+}
+
+/*
+ * allocate and populate the list of programs attached to a given hid device.
+ *
+ * Must be called under lock.
+ */
+static int hid_bpf_populate_hdev(struct hid_device *hdev, enum hid_bpf_prog_type type)
+{
+	struct hid_bpf_prog_list *new_list;
+	int i;
+
+	if (type >= HID_BPF_PROG_TYPE_MAX || !hdev)
+		return -EINVAL;
+
+	if (hdev->bpf.destroyed)
+		return 0;
+
+	new_list = kzalloc(sizeof(*new_list), GFP_KERNEL);
+	if (!new_list)
+		return -ENOMEM;
+
+	FOR_ENTRIES(i, jmp_table.tail, jmp_table.head) {
+		struct hid_bpf_prog_entry *entry = &jmp_table.entries[i];
+
+		if (entry->type == type && entry->hdev == hdev &&
+		    test_bit(entry->idx, jmp_table.enabled))
+			new_list->prog_idx[new_list->prog_cnt++] = entry->idx;
+	}
+
+	__hid_bpf_set_hdev_progs(hdev, new_list, type);
+
+	return 0;
+}
+
+static void __hid_bpf_do_release_prog(int map_fd, unsigned int idx)
+{
+	skel_map_delete_elem(map_fd, &idx);
+	jmp_table.progs[idx] = NULL;
+}
+
+static void hid_bpf_release_progs(struct work_struct *work)
+{
+	int i, j, n, map_fd = -1;
+
+	if (!jmp_table.map)
+		return;
+
+	/* retrieve a fd of our prog_array map in BPF */
+	map_fd = skel_map_get_fd_by_id(jmp_table.map->id);
+	if (map_fd < 0)
+		return;
+
+	mutex_lock(&hid_bpf_attach_lock); /* protects against attaching new programs */
+
+	/* detach unused progs from HID devices */
+	FOR_ENTRIES(i, jmp_table.tail, jmp_table.head) {
+		struct hid_bpf_prog_entry *entry = &jmp_table.entries[i];
+		enum hid_bpf_prog_type type;
+		struct hid_device *hdev;
+
+		if (test_bit(entry->idx, jmp_table.enabled))
+			continue;
+
+		/* we have an attached prog */
+		if (entry->hdev) {
+			hdev = entry->hdev;
+			type = entry->type;
+
+			hid_bpf_populate_hdev(hdev, type);
+
+			/* mark all other disabled progs from hdev of the given type as detached */
+			FOR_ENTRIES(j, i, jmp_table.head) {
+				struct hid_bpf_prog_entry *next;
+
+				next = &jmp_table.entries[j];
+
+				if (test_bit(next->idx, jmp_table.enabled))
+					continue;
+
+				if (next->hdev == hdev && next->type == type)
+					next->hdev = NULL;
+			}
+		}
+	}
+
+	/* remove all unused progs from the jump table */
+	FOR_ENTRIES(i, jmp_table.tail, jmp_table.head) {
+		struct hid_bpf_prog_entry *entry = &jmp_table.entries[i];
+
+		if (test_bit(entry->idx, jmp_table.enabled))
+			continue;
+
+		if (entry->prog)
+			__hid_bpf_do_release_prog(map_fd, entry->idx);
+	}
+
+	/* compact the entry list */
+	n = jmp_table.tail;
+	FOR_ENTRIES(i, jmp_table.tail, jmp_table.head) {
+		struct hid_bpf_prog_entry *entry = &jmp_table.entries[i];
+
+		if (!test_bit(entry->idx, jmp_table.enabled))
+			continue;
+
+		jmp_table.entries[n] = jmp_table.entries[i];
+		n = NEXT(n);
+	}
+
+	jmp_table.head = n;
+
+	mutex_unlock(&hid_bpf_attach_lock);
+
+	if (map_fd >= 0)
+		close_fd(map_fd);
+}
+
+static void hid_bpf_release_prog_at(int idx)
+{
+	int map_fd = -1;
+
+	/* retrieve a fd of our prog_array map in BPF */
+	map_fd = skel_map_get_fd_by_id(jmp_table.map->id);
+	if (map_fd < 0)
+		return;
+
+	__hid_bpf_do_release_prog(map_fd, idx);
+
+	close(map_fd);
+}
+
+/*
+ * Insert the given BPF program represented by its fd in the jmp table.
+ * Returns the index in the jump table or a negative error.
+ */
+static int hid_bpf_insert_prog(int prog_fd, struct bpf_prog *prog)
+{
+	int i, cnt, index = -1, map_fd = -1, progs_map_fd = -1, err = -EINVAL;
+
+	/* retrieve a fd of our prog_array map in BPF */
+	map_fd = skel_map_get_fd_by_id(jmp_table.map->id);
+	/* take an fd for the table of progs we monitor with SEC("fexit/bpf_prog_release") */
+	progs_map_fd = skel_map_get_fd_by_id(jmp_table.prog_keys->id);
+
+	if (map_fd < 0 || progs_map_fd < 0) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	cnt = 0;
+	/* find the first available index in the jmp_table
+	 * and count how many time this program has been inserted
+	 */
+	for (i = 0; i < HID_BPF_MAX_PROGS; i++) {
+		if (!jmp_table.progs[i] && index < 0) {
+			/* mark the index as used */
+			jmp_table.progs[i] = prog;
+			index = i;
+			__set_bit(i, jmp_table.enabled);
+			cnt++;
+		} else {
+			if (jmp_table.progs[i] == prog)
+				cnt++;
+		}
+	}
+	if (index < 0) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* insert the program in the jump table */
+	err = skel_map_update_elem(map_fd, &index, &prog_fd, 0);
+	if (err)
+		goto out;
+
+	/* insert the program in the prog list table */
+	err = skel_map_update_elem(progs_map_fd, &prog, &cnt, 0);
+	if (err)
+		goto out;
+
+	/* return the index */
+	err = index;
+
+ out:
+	if (err < 0)
+		__hid_bpf_do_release_prog(map_fd, index);
+	if (map_fd >= 0)
+		close_fd(map_fd);
+	if (progs_map_fd >= 0)
+		close_fd(progs_map_fd);
+	return err;
+}
+
+int hid_bpf_get_prog_attach_type(int prog_fd)
+{
+	struct bpf_prog *prog = NULL;
+	int i;
+	int prog_type = HID_BPF_PROG_TYPE_UNDEF;
+
+	prog = bpf_prog_get(prog_fd);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	for (i = 0; i < HID_BPF_PROG_TYPE_MAX; i++) {
+		if (hid_bpf_btf_ids[i] == prog->aux->attach_btf_id) {
+			prog_type = i;
+			break;
+		}
+	}
+
+	bpf_prog_put(prog);
+
+	return prog_type;
+}
+
+/* called from syscall */
+noinline int
+__hid_bpf_attach_prog(struct hid_device *hdev, enum hid_bpf_prog_type prog_type,
+		      int prog_fd, __u32 flags)
+{
+	struct bpf_prog *prog = NULL;
+	struct hid_bpf_prog_entry *prog_entry;
+	int cnt, err = -EINVAL, prog_idx = -1;
+
+	/* take a ref on the prog itself */
+	prog = bpf_prog_get(prog_fd);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	mutex_lock(&hid_bpf_attach_lock);
+
+	/* do not attach too many programs to a given HID device */
+	cnt = hid_bpf_program_count(hdev, NULL, prog_type);
+	if (cnt < 0) {
+		err = cnt;
+		goto out_unlock;
+	}
+
+	if (cnt >= hid_bpf_max_programs(prog_type)) {
+		err = -E2BIG;
+		goto out_unlock;
+	}
+
+	prog_idx = hid_bpf_insert_prog(prog_fd, prog);
+	/* if the jmp table is full, abort */
+	if (prog_idx < 0) {
+		err = prog_idx;
+		goto out_unlock;
+	}
+
+	if (flags & HID_BPF_FLAG_INSERT_HEAD) {
+		/* take the previous prog_entry slot */
+		jmp_table.tail = PREV(jmp_table.tail);
+		prog_entry = &jmp_table.entries[jmp_table.tail];
+	} else {
+		/* take the next prog_entry slot */
+		prog_entry = &jmp_table.entries[jmp_table.head];
+		jmp_table.head = NEXT(jmp_table.head);
+	}
+
+	/* we steal the ref here */
+	prog_entry->prog = prog;
+	prog_entry->idx = prog_idx;
+	prog_entry->hdev = hdev;
+	prog_entry->type = prog_type;
+
+	/* finally store the index in the device list */
+	err = hid_bpf_populate_hdev(hdev, prog_type);
+	if (err)
+		hid_bpf_release_prog_at(prog_idx);
+
+ out_unlock:
+	mutex_unlock(&hid_bpf_attach_lock);
+
+	/* we only use prog as a key in the various tables, so we don't need to actually
+	 * increment the ref count.
+	 */
+	bpf_prog_put(prog);
+
+	return err;
+}
+
+void __hid_bpf_destroy_device(struct hid_device *hdev)
+{
+	int type, i;
+	struct hid_bpf_prog_list *prog_list;
+
+	rcu_read_lock();
+
+	for (type = 0; type < HID_BPF_PROG_TYPE_MAX; type++) {
+		prog_list = rcu_dereference(hdev->bpf.progs[type]);
+
+		if (!prog_list)
+			continue;
+
+		for (i = 0; i < prog_list->prog_cnt; i++)
+			__clear_bit(prog_list->prog_idx[i], jmp_table.enabled);
+	}
+
+	rcu_read_unlock();
+
+	for (type = 0; type < HID_BPF_PROG_TYPE_MAX; type++)
+		__hid_bpf_set_hdev_progs(hdev, NULL, type);
+
+	/* schedule release of all detached progs */
+	schedule_work(&release_work);
+}
+
+noinline bool
+call_hid_bpf_prog_release(u64 prog_key, int table_cnt)
+{
+	/* compare with how many refs are left in the bpf program */
+	struct bpf_prog *prog = (struct bpf_prog *)prog_key;
+	int idx;
+
+	if (!prog)
+		return false;
+
+	if (atomic64_read(&prog->aux->refcnt) != table_cnt)
+		return false;
+
+	/* we don't need locking here because the entries in the progs table
+	 * are stable:
+	 * if there are other users (and the progs entries might change), we
+	 * would return in the statement above.
+	 */
+	for (idx = 0; idx < HID_BPF_MAX_PROGS; idx++) {
+		if (jmp_table.progs[idx] == prog) {
+			__clear_bit(idx, jmp_table.enabled);
+			break;
+		}
+	}
+	if (idx >= HID_BPF_MAX_PROGS) {
+		/* should never happen if we get our refcount right */
+		idx = -1;
+	}
+
+	/* schedule release of all detached progs */
+	schedule_work(&release_work);
+	return idx >= 0;
+}
+
+#define HID_BPF_PROGS_COUNT 3
+
+static struct bpf_link *links[HID_BPF_PROGS_COUNT];
+static struct entrypoints_bpf *skel;
+
+void hid_bpf_free_links_and_skel(void)
+{
+	int i;
+
+	/* the following is enough to release all programs attached to hid */
+	if (jmp_table.prog_keys)
+		bpf_map_put_with_uref(jmp_table.prog_keys);
+
+	if (jmp_table.map)
+		bpf_map_put_with_uref(jmp_table.map);
+
+	for (i = 0; i < ARRAY_SIZE(links); i++) {
+		if (!IS_ERR_OR_NULL(links[i]))
+			bpf_link_put(links[i]);
+	}
+	entrypoints_bpf__destroy(skel);
+}
+
+#define ATTACH_AND_STORE_LINK(__name) do {					\
+	err = entrypoints_bpf__##__name##__attach(skel);			\
+	if (err)								\
+		goto out;							\
+										\
+	links[idx] = bpf_link_get_from_fd(skel->links.__name##_fd);		\
+	if (IS_ERR(links[idx])) {						\
+		err = PTR_ERR(links[idx]);					\
+		goto out;							\
+	}									\
+										\
+	/* Avoid taking over stdin/stdout/stderr of init process. Zeroing out	\
+	 * makes skel_closenz() a no-op later in iterators_bpf__destroy().	\
+	 */									\
+	close_fd(skel->links.__name##_fd);					\
+	skel->links.__name##_fd = 0;						\
+	idx++;									\
+} while (0)
+
+int hid_bpf_preload_skel(void)
+{
+	int err, idx = 0;
+
+	skel = entrypoints_bpf__open();
+	if (!skel)
+		return -ENOMEM;
+
+	err = entrypoints_bpf__load(skel);
+	if (err)
+		goto out;
+
+	jmp_table.map = bpf_map_get_with_uref(skel->maps.hid_jmp_table.map_fd);
+	if (IS_ERR(jmp_table.map)) {
+		err = PTR_ERR(jmp_table.map);
+		goto out;
+	}
+
+	jmp_table.prog_keys = bpf_map_get_with_uref(skel->maps.progs_map.map_fd);
+	if (IS_ERR(jmp_table.prog_keys)) {
+		err = PTR_ERR(jmp_table.prog_keys);
+		goto out;
+	}
+
+	ATTACH_AND_STORE_LINK(hid_tail_call);
+	ATTACH_AND_STORE_LINK(hid_prog_release);
+	ATTACH_AND_STORE_LINK(hid_free_inode);
+
+	return 0;
+out:
+	hid_bpf_free_links_and_skel();
+	return err;
+}
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index aff37d6f587c..0d0bd8fc69c7 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2040,6 +2040,10 @@ int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data
 	report_enum = hid->report_enum + type;
 	hdrv = hid->driver;
 
+	ret = dispatch_hid_bpf_device_event(hid, type, data, size, interrupt);
+	if (ret)
+		goto unlock;
+
 	if (!size) {
 		dbg_hid("empty report\n");
 		ret = -1;
@@ -2789,6 +2793,8 @@ struct hid_device *hid_allocate_device(void)
 	sema_init(&hdev->driver_input_lock, 1);
 	mutex_init(&hdev->ll_open_lock);
 
+	hid_bpf_device_init(hdev);
+
 	return hdev;
 }
 EXPORT_SYMBOL_GPL(hid_allocate_device);
@@ -2815,6 +2821,7 @@ static void hid_remove_device(struct hid_device *hdev)
  */
 void hid_destroy_device(struct hid_device *hdev)
 {
+	hid_bpf_destroy_device(hdev);
 	hid_remove_device(hdev);
 	put_device(&hdev->dev);
 }
@@ -2901,6 +2908,11 @@ int hid_check_keys_pressed(struct hid_device *hid)
 }
 EXPORT_SYMBOL_GPL(hid_check_keys_pressed);
 
+static struct hid_bpf_ops hid_ops = {
+	.owner = THIS_MODULE,
+	.bus_type = &hid_bus_type,
+};
+
 static int __init hid_init(void)
 {
 	int ret;
@@ -2915,6 +2927,8 @@ static int __init hid_init(void)
 		goto err;
 	}
 
+	hid_bpf_ops = &hid_ops;
+
 	ret = hidraw_init();
 	if (ret)
 		goto err_bus;
@@ -2930,6 +2944,7 @@ static int __init hid_init(void)
 
 static void __exit hid_exit(void)
 {
+	hid_bpf_ops = NULL;
 	hid_debug_exit();
 	hidraw_exit();
 	bus_unregister(&hid_bus_type);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 8677ae38599e..cd3c52fae7b1 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -26,6 +26,7 @@
 #include <linux/mutex.h>
 #include <linux/power_supply.h>
 #include <uapi/linux/hid.h>
+#include <linux/hid_bpf.h>
 
 /*
  * We parse each description item into this structure. Short items data
@@ -651,6 +652,10 @@ struct hid_device {							/* device report descriptor */
 	wait_queue_head_t debug_wait;
 
 	unsigned int id;						/* system unique id */
+
+#ifdef CONFIG_BPF
+	struct hid_bpf bpf;						/* hid-bpf data */
+#endif /* CONFIG_BPF */
 };
 
 #define to_hid_device(pdev) \
diff --git a/include/linux/hid_bpf.h b/include/linux/hid_bpf.h
new file mode 100644
index 000000000000..5d53b12c6ea0
--- /dev/null
+++ b/include/linux/hid_bpf.h
@@ -0,0 +1,102 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef __HID_BPF_H
+#define __HID_BPF_H
+
+#include <linux/spinlock.h>
+#include <uapi/linux/hid.h>
+#include <uapi/linux/hid_bpf.h>
+
+struct hid_device;
+
+/*
+ * The following is the HID BPF API.
+ *
+ * It should be treated as UAPI, so extra care is required
+ * when making change to this file.
+ */
+
+/**
+ * struct hid_bpf_ctx - User accessible data for all HID programs
+ *
+ * ``data`` is not directly accessible from the context. We need to issue
+ * a call to ``hid_bpf_get_data()`` in order to get a pointer to that field.
+ *
+ * All of these fields are currently read-only.
+ *
+ * @index: program index in the jump table. No special meaning (a smaller index
+ *         doesn't mean the program will be executed before another program with
+ *         a bigger index).
+ * @hid: the ``struct hid_device`` representing the device itself
+ * @report_type: used for ``hid_bpf_device_event()``
+ * @size: Valid data in the data field.
+ *
+ *        Programs can get the available valid size in data by fetching this field.
+ */
+struct hid_bpf_ctx {
+	__u32 index;
+	const struct hid_device *hid;
+	enum hid_report_type report_type;
+	__s32 size;
+};
+
+/* Following functions are tracepoints that BPF programs can attach to */
+int hid_bpf_device_event(struct hid_bpf_ctx *ctx);
+
+/* Following functions are kfunc that we export to BPF programs */
+/* only available in tracing */
+__u8 *hid_bpf_get_data(struct hid_bpf_ctx *ctx, unsigned int offset, const size_t __sz);
+
+/* only available in syscall */
+int hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, __u32 flags);
+
+/*
+ * Below is HID internal
+ */
+
+/* internal function to call eBPF programs, not to be used by anybody */
+int __hid_bpf_tail_call(struct hid_bpf_ctx *ctx);
+
+#define HID_BPF_MAX_PROGS_PER_DEV 64
+#define HID_BPF_FLAG_MASK (((HID_BPF_FLAG_MAX - 1) << 1) - 1)
+
+/* types of HID programs to attach to */
+enum hid_bpf_prog_type {
+	HID_BPF_PROG_TYPE_UNDEF = -1,
+	HID_BPF_PROG_TYPE_DEVICE_EVENT,			/* an event is emitted from the device */
+	HID_BPF_PROG_TYPE_MAX,
+};
+
+struct hid_bpf_ops {
+	struct module *owner;
+	struct bus_type *bus_type;
+};
+
+extern struct hid_bpf_ops *hid_bpf_ops;
+
+struct hid_bpf_prog_list {
+	u16 prog_idx[HID_BPF_MAX_PROGS_PER_DEV];
+	u8 prog_cnt;
+};
+
+/* stored in each device */
+struct hid_bpf {
+	struct hid_bpf_prog_list __rcu *progs[HID_BPF_PROG_TYPE_MAX];	/* attached BPF progs */
+	bool destroyed;			/* prevents the assignment of any progs */
+
+	spinlock_t progs_lock;		/* protects RCU update of progs */
+};
+
+#ifdef CONFIG_HID_BPF
+int dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
+				  u32 size, int interrupt);
+void hid_bpf_destroy_device(struct hid_device *hid);
+void hid_bpf_device_init(struct hid_device *hid);
+#else /* CONFIG_HID_BPF */
+static inline int dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
+						u32 size, int interrupt) { return 0; }
+static inline void hid_bpf_destroy_device(struct hid_device *hid) {}
+static inline void hid_bpf_device_init(struct hid_device *hid) {}
+#endif /* CONFIG_HID_BPF */
+
+#endif /* __HID_BPF_H */
diff --git a/include/uapi/linux/hid_bpf.h b/include/uapi/linux/hid_bpf.h
new file mode 100644
index 000000000000..ba8caf9b60ee
--- /dev/null
+++ b/include/uapi/linux/hid_bpf.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI_HID_BPF_H
+#define _UAPI_HID_BPF_H
+
+#include <linux/const.h>
+#include <linux/hid.h>
+
+/**
+ * enum hid_bpf_attach_flags - flags used when attaching a HIF-BPF program
+ *
+ * @HID_BPF_FLAG_NONE: no specific flag is used, the kernel choses where to
+ *                     insert the program
+ * @HID_BPF_FLAG_INSERT_HEAD: insert the given program before any other program
+ *                            currently attached to the device. This doesn't
+ *                            guarantee that this program will always be first
+ * @HID_BPF_FLAG_MAX: sentinel value, not to be used by the callers
+ */
+enum hid_bpf_attach_flags {
+	HID_BPF_FLAG_NONE = 0,
+	HID_BPF_FLAG_INSERT_HEAD = _BITUL(0),
+	HID_BPF_FLAG_MAX,
+};
+
+#endif /* _UAPI_HID_BPF_H */
diff --git a/tools/include/uapi/linux/hid.h b/tools/include/uapi/linux/hid.h
new file mode 100644
index 000000000000..3e63bea3b3e2
--- /dev/null
+++ b/tools/include/uapi/linux/hid.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ *  Copyright (c) 1999 Andreas Gal
+ *  Copyright (c) 2000-2001 Vojtech Pavlik
+ *  Copyright (c) 2006-2007 Jiri Kosina
+ */
+#ifndef _UAPI__HID_H
+#define _UAPI__HID_H
+
+
+
+/*
+ * USB HID (Human Interface Device) interface class code
+ */
+
+#define USB_INTERFACE_CLASS_HID		3
+
+/*
+ * USB HID interface subclass and protocol codes
+ */
+
+#define USB_INTERFACE_SUBCLASS_BOOT	1
+#define USB_INTERFACE_PROTOCOL_KEYBOARD	1
+#define USB_INTERFACE_PROTOCOL_MOUSE	2
+
+/*
+ * HID report types --- Ouch! HID spec says 1 2 3!
+ */
+
+enum hid_report_type {
+	HID_INPUT_REPORT		= 0,
+	HID_OUTPUT_REPORT		= 1,
+	HID_FEATURE_REPORT		= 2,
+
+	HID_REPORT_TYPES,
+};
+
+/*
+ * HID class requests
+ */
+
+enum hid_class_request {
+	HID_REQ_GET_REPORT		= 0x01,
+	HID_REQ_GET_IDLE		= 0x02,
+	HID_REQ_GET_PROTOCOL		= 0x03,
+	HID_REQ_SET_REPORT		= 0x09,
+	HID_REQ_SET_IDLE		= 0x0A,
+	HID_REQ_SET_PROTOCOL		= 0x0B,
+};
+
+/*
+ * HID class descriptor types
+ */
+
+#define HID_DT_HID			(USB_TYPE_CLASS | 0x01)
+#define HID_DT_REPORT			(USB_TYPE_CLASS | 0x02)
+#define HID_DT_PHYSICAL			(USB_TYPE_CLASS | 0x03)
+
+#define HID_MAX_DESCRIPTOR_SIZE		4096
+
+
+#endif /* _UAPI__HID_H */
diff --git a/tools/include/uapi/linux/hid_bpf.h b/tools/include/uapi/linux/hid_bpf.h
new file mode 100644
index 000000000000..ba8caf9b60ee
--- /dev/null
+++ b/tools/include/uapi/linux/hid_bpf.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI_HID_BPF_H
+#define _UAPI_HID_BPF_H
+
+#include <linux/const.h>
+#include <linux/hid.h>
+
+/**
+ * enum hid_bpf_attach_flags - flags used when attaching a HIF-BPF program
+ *
+ * @HID_BPF_FLAG_NONE: no specific flag is used, the kernel choses where to
+ *                     insert the program
+ * @HID_BPF_FLAG_INSERT_HEAD: insert the given program before any other program
+ *                            currently attached to the device. This doesn't
+ *                            guarantee that this program will always be first
+ * @HID_BPF_FLAG_MAX: sentinel value, not to be used by the callers
+ */
+enum hid_bpf_attach_flags {
+	HID_BPF_FLAG_NONE = 0,
+	HID_BPF_FLAG_INSERT_HEAD = _BITUL(0),
+	HID_BPF_FLAG_MAX,
+};
+
+#endif /* _UAPI_HID_BPF_H */
-- 
2.36.1

