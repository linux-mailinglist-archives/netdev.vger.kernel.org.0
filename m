Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8CD48B800
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfHMMH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:07:29 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36254 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfHMMH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:07:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id w2so681630pfi.3;
        Tue, 13 Aug 2019 05:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8/8NsF2jfxOSjSgasYfm8ctYMNupvW30/NVGZbFK9U8=;
        b=px+en4B7B+KhoMW/+lWytzTuEr1kbpCm22dyaArq8i4a8tzMcmBY4z17TtCn64FZm9
         rZ39uCN0FBH1DycfjH3V6z+vpfbuF3GrPWHdyArO1scwMPKsXkJNCnTt/U/wW42Qy+Sa
         QpeiQk4gVVHeYXwbcC9T/Nn+cFTloShunmZWytvb47aBlA0xcNF/I7SqZvDXFPRzWY7z
         YAUIsYzIBqNybUEc0v2RoPmYDQrEXVat+8ByQ6eJf0Mvbq983BD1pVa77sJ7gbGk1wLT
         ZjD6Orj/RHU5jhVKDoyLbYFiWMCTc2mP6Esf+T/3MFA7nqjXMoljVvUnCqtmtzlwWTLr
         njgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8/8NsF2jfxOSjSgasYfm8ctYMNupvW30/NVGZbFK9U8=;
        b=lRpE/nsfd0k9uKuFkHT3LqJtAAPm151FUFLNAzBPm+sdmfFrY5maFi1086bdxYaOYM
         wMI9z1BZ1MZUrLM/AvwEwTrTDeEiWeBZzAV83KxI2TnvR93RsXDtyvBRvzfk+o9N/EdH
         Cvpay1ZGjGkcCdfZfcU8eYuBgTOfoNPEbc002vN++ANylXYDzRTemgYuqPVnjbVJu05K
         wSupv9IyVA+zFJgVmOX8JBpPmNci1I3xkdJfOBycrDjwKRCj+SLLJTQtf8vZZfQ9gSr0
         gd4WP3BuqStzW/I9FLnRd5bsZ/ZgezowNQHr5p+MVsLlb1R2ZKZL7L44GBgcSY3P1Wqu
         pg1w==
X-Gm-Message-State: APjAAAVpkQ063plYpT/n0PH91QdxUp4lQ/bdIM2ymN9LJbm6TbPAsL/M
        BMrmu3MIK4ywLAvQDcaJeIg=
X-Google-Smtp-Source: APXvYqwdNwzRt9Ejpfehx9WPIpV97NU7T4pBxebgSOGDewAlmDnExQAilB+OyMcrSkMbC4h6zYP52A==
X-Received: by 2002:a63:e10:: with SMTP id d16mr34540517pgl.444.1565698047652;
        Tue, 13 Aug 2019 05:07:27 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.07.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:07:27 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: [RFC PATCH bpf-next 02/14] xdp_flow: Add skeleton bpf program for XDP
Date:   Tue, 13 Aug 2019 21:05:46 +0900
Message-Id: <20190813120558.6151-3-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The program is meant to be loaded when a device is bound to an ingress
TC block and should be attached to XDP on the device.
Typically it should be loaded when TC ingress or clsact qdisc is added.

The program is prebuilt and embedded in the UMH, instead of generated
dynamically. This is because TC filter is frequently changed when it is
used by OVS, and the latency of TC filter change will affect the latency
of datapath.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 net/xdp_flow/Makefile                 |  87 +++++++++++-
 net/xdp_flow/xdp_flow_kern_bpf.c      |  12 ++
 net/xdp_flow/xdp_flow_kern_bpf_blob.S |   7 +
 net/xdp_flow/xdp_flow_umh.c           | 241 +++++++++++++++++++++++++++++++++-
 4 files changed, 343 insertions(+), 4 deletions(-)
 create mode 100644 net/xdp_flow/xdp_flow_kern_bpf.c
 create mode 100644 net/xdp_flow/xdp_flow_kern_bpf_blob.S

diff --git a/net/xdp_flow/Makefile b/net/xdp_flow/Makefile
index f6138c2..b3a0416 100644
--- a/net/xdp_flow/Makefile
+++ b/net/xdp_flow/Makefile
@@ -2,25 +2,106 @@
 
 obj-$(CONFIG_XDP_FLOW) += xdp_flow_core.o
 
+XDP_FLOW_PATH ?= $(abspath $(srctree)/$(src))
+TOOLS_PATH := $(XDP_FLOW_PATH)/../../tools
+
+# Libbpf dependencies
+LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
+
+LLC ?= llc
+CLANG ?= clang
+LLVM_OBJCOPY ?= llvm-objcopy
+BTF_PAHOLE ?= pahole
+
+ifdef CROSS_COMPILE
+CLANG_ARCH_ARGS = -target $(ARCH)
+endif
+
+BTF_LLC_PROBE := $(shell $(LLC) -march=bpf -mattr=help 2>&1 | grep dwarfris)
+BTF_PAHOLE_PROBE := $(shell $(BTF_PAHOLE) --help 2>&1 | grep BTF)
+BTF_OBJCOPY_PROBE := $(shell $(LLVM_OBJCOPY) --help 2>&1 | grep -i 'usage.*llvm')
+BTF_LLVM_PROBE := $(shell echo "int main() { return 0; }" | \
+			  $(CLANG) -target bpf -O2 -g -c -x c - -o ./llvm_btf_verify.o; \
+			  readelf -S ./llvm_btf_verify.o | grep BTF; \
+			  /bin/rm -f ./llvm_btf_verify.o)
+
+ifneq ($(BTF_LLVM_PROBE),)
+	EXTRA_CFLAGS += -g
+else
+ifneq ($(and $(BTF_LLC_PROBE),$(BTF_PAHOLE_PROBE),$(BTF_OBJCOPY_PROBE)),)
+	EXTRA_CFLAGS += -g
+	LLC_FLAGS += -mattr=dwarfris
+	DWARF2BTF = y
+endif
+endif
+
+$(LIBBPF): FORCE
+# Fix up variables inherited from Kbuild that tools/ build system won't like
+	$(MAKE) -C $(dir $@) RM='rm -rf' LDFLAGS= srctree=$(XDP_FLOW_PATH)/../../ O=
+
+# Verify LLVM compiler tools are available and bpf target is supported by llc
+.PHONY: verify_cmds verify_target_bpf $(CLANG) $(LLC)
+
+verify_cmds: $(CLANG) $(LLC)
+	@for TOOL in $^ ; do \
+		if ! (which -- "$${TOOL}" > /dev/null 2>&1); then \
+			echo "*** ERROR: Cannot find LLVM tool $${TOOL}" ;\
+			exit 1; \
+		else true; fi; \
+	done
+
+verify_target_bpf: verify_cmds
+	@if ! (${LLC} -march=bpf -mattr=help > /dev/null 2>&1); then \
+		echo "*** ERROR: LLVM (${LLC}) does not support 'bpf' target" ;\
+		echo "   NOTICE: LLVM version >= 3.7.1 required" ;\
+		exit 2; \
+	else true; fi
+
+$(src)/xdp_flow_kern_bpf.c: verify_target_bpf
+
+$(obj)/xdp_flow_kern_bpf.o: $(src)/xdp_flow_kern_bpf.c FORCE
+	@echo "  CLANG-bpf " $@
+	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(EXTRA_CFLAGS) -I$(obj) \
+		-I$(srctree)/tools/testing/selftests/bpf/ \
+		-D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
+		-D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
+		-Wno-gnu-variable-sized-type-not-at-end \
+		-Wno-address-of-packed-member -Wno-tautological-compare \
+		-Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
+		-I$(srctree)/samples/bpf/ -include asm_goto_workaround.h \
+		-O2 -emit-llvm -c $< -o -| $(LLC) -march=bpf $(LLC_FLAGS) -filetype=obj -o $@
+ifeq ($(DWARF2BTF),y)
+	$(BTF_PAHOLE) -J $@
+endif
+
 ifeq ($(CONFIG_XDP_FLOW_UMH), y)
 # builtin xdp_flow_umh should be compiled with -static
 # since rootfs isn't mounted at the time of __init
 # function is called and do_execv won't find elf interpreter
 STATIC := -static
+STATICLDLIBS := -lz
 endif
 
+quiet_cmd_as_user = AS      $@
+      cmd_as_user = $(AS) -c -o $@ $<
+
 quiet_cmd_cc_user = CC      $@
       cmd_cc_user = $(CC) -Wall -Wmissing-prototypes -O2 -std=gnu89 \
-		    -I$(srctree)/tools/include/ \
+		    -I$(srctree)/tools/lib/ -I$(srctree)/tools/include/ \
 		    -c -o $@ $<
 
 quiet_cmd_ld_user = LD      $@
-      cmd_ld_user = $(CC) $(STATIC) -o $@ $^
+      cmd_ld_user = $(CC) $(STATIC) -o $@ $^ $(LIBBPF) -lelf $(STATICLDLIBS)
+
+$(obj)/xdp_flow_kern_bpf_blob.o: $(src)/xdp_flow_kern_bpf_blob.S \
+				 $(obj)/xdp_flow_kern_bpf.o
+	$(call if_changed,as_user)
 
 $(obj)/xdp_flow_umh.o: $(src)/xdp_flow_umh.c FORCE
 	$(call if_changed,cc_user)
 
-$(obj)/xdp_flow_umh: $(obj)/xdp_flow_umh.o
+$(obj)/xdp_flow_umh: $(obj)/xdp_flow_umh.o $(LIBBPF) \
+		     $(obj)/xdp_flow_kern_bpf_blob.o
 	$(call if_changed,ld_user)
 
 clean-files := xdp_flow_umh
diff --git a/net/xdp_flow/xdp_flow_kern_bpf.c b/net/xdp_flow/xdp_flow_kern_bpf.c
new file mode 100644
index 0000000..74cdb1d
--- /dev/null
+++ b/net/xdp_flow/xdp_flow_kern_bpf.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+#define KBUILD_MODNAME "foo"
+#include <uapi/linux/bpf.h>
+#include <bpf_helpers.h>
+
+SEC("xdp_flow")
+int xdp_flow_prog(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/net/xdp_flow/xdp_flow_kern_bpf_blob.S b/net/xdp_flow/xdp_flow_kern_bpf_blob.S
new file mode 100644
index 0000000..d180c1b
--- /dev/null
+++ b/net/xdp_flow/xdp_flow_kern_bpf_blob.S
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+	.section .rodata, "a"
+	.global xdp_flow_bpf_start
+xdp_flow_bpf_start:
+	.incbin "net/xdp_flow/xdp_flow_kern_bpf.o"
+	.global xdp_flow_bpf_end
+xdp_flow_bpf_end:
diff --git a/net/xdp_flow/xdp_flow_umh.c b/net/xdp_flow/xdp_flow_umh.c
index 6729bdf..734db00 100644
--- a/net/xdp_flow/xdp_flow_umh.c
+++ b/net/xdp_flow/xdp_flow_umh.c
@@ -6,9 +6,19 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <syslog.h>
+#include <bpf/libbpf.h>
+#include <bpf/bpf.h>
+#include <sys/mman.h>
 #include <sys/types.h>
+#include <sys/resource.h>
+#include <linux/hashtable.h>
+#include <linux/err.h>
 #include "msgfmt.h"
 
+extern char xdp_flow_bpf_start;
+extern char xdp_flow_bpf_end;
+int progfile_fd;
+
 /* FIXME: syslog is used for easy debugging. As writing /dev/log can be stuck
  * due to reader side, should use another log mechanism like kmsg.
  */
@@ -17,15 +27,241 @@
 #define pr_warn(fmt, ...) syslog(LOG_DAEMON | LOG_WARNING, fmt, ##__VA_ARGS__)
 #define pr_err(fmt, ...) syslog(LOG_DAEMON | LOG_ERR, fmt, ##__VA_ARGS__)
 
+#define ERRBUF_SIZE 64
+
+/* This key represents a net device */
+struct netdev_info_key {
+	int ifindex;
+};
+
+struct netdev_info {
+	struct netdev_info_key key;
+	struct hlist_node node;
+	struct bpf_object *obj;
+};
+
+DEFINE_HASHTABLE(netdev_info_table, 16);
+
+static int libbpf_err(int err, char *errbuf)
+{
+	libbpf_strerror(err, errbuf, ERRBUF_SIZE);
+
+	if (-err < __LIBBPF_ERRNO__START)
+		return err;
+
+	return -EINVAL;
+}
+
+static int setup(void)
+{
+	size_t size = &xdp_flow_bpf_end - &xdp_flow_bpf_start;
+	struct rlimit r = { RLIM_INFINITY, RLIM_INFINITY };
+	ssize_t len;
+	int err;
+
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		err = -errno;
+		pr_err("setrlimit MEMLOCK failed: %s\n", strerror(errno));
+		return err;
+	}
+
+	progfile_fd = memfd_create("xdp_flow_kern_bpf.o", 0);
+	if (progfile_fd < 0) {
+		err = -errno;
+		pr_err("memfd_create failed: %s\n", strerror(errno));
+		return err;
+	}
+
+	len = write(progfile_fd, &xdp_flow_bpf_start, size);
+	if (len < 0) {
+		err = -errno;
+		pr_err("Failed to write bpf prog: %s\n", strerror(errno));
+		goto err;
+	}
+
+	if (len < size) {
+		pr_err("bpf prog written too short: expected %ld, actual %ld\n",
+		       size, len);
+		err = -EIO;
+		goto err;
+	}
+
+	return 0;
+err:
+	close(progfile_fd);
+
+	return err;
+}
+
+static int load_bpf(int ifindex, struct bpf_object **objp)
+{
+	struct bpf_object_open_attr attr = {};
+	char path[256], errbuf[ERRBUF_SIZE];
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	int prog_fd, err;
+	ssize_t len;
+
+	len = snprintf(path, 256, "/proc/self/fd/%d", progfile_fd);
+	if (len < 0) {
+		err = -errno;
+		pr_err("Failed to setup prog fd path string: %s\n",
+		       strerror(errno));
+		return err;
+	}
+
+	attr.file = path;
+	attr.prog_type = BPF_PROG_TYPE_XDP;
+	obj = bpf_object__open_xattr(&attr);
+	if (IS_ERR_OR_NULL(obj)) {
+		if (IS_ERR(obj)) {
+			err = libbpf_err((int)PTR_ERR(obj), errbuf);
+		} else {
+			err = -ENOENT;
+			strerror_r(-err, errbuf, sizeof(errbuf));
+		}
+		pr_err("Cannot open bpf prog: %s\n", errbuf);
+		return err;
+	}
+
+	bpf_object__for_each_program(prog, obj)
+		bpf_program__set_type(prog, attr.prog_type);
+
+	err = bpf_object__load(obj);
+	if (err) {
+		err = libbpf_err(err, errbuf);
+		pr_err("Failed to load bpf prog: %s\n", errbuf);
+		goto err;
+	}
+
+	prog = bpf_object__find_program_by_title(obj, "xdp_flow");
+	if (!prog) {
+		pr_err("Cannot find xdp_flow program\n");
+		err = -ENOENT;
+		goto err;
+	}
+
+	prog_fd = bpf_program__fd(prog);
+	if (prog_fd < 0) {
+		err = libbpf_err(prog_fd, errbuf);
+		pr_err("Invalid program fd: %s\n", errbuf);
+		goto err;
+	}
+
+	*objp = obj;
+
+	return prog_fd;
+err:
+	bpf_object__close(obj);
+	return err;
+}
+
+static int get_netdev_info_keyval(const struct netdev_info_key *key)
+{
+	return key->ifindex;
+}
+
+static struct netdev_info *find_netdev_info(const struct netdev_info_key *key)
+{
+	int keyval = get_netdev_info_keyval(key);
+	struct netdev_info *netdev_info;
+
+	hash_for_each_possible(netdev_info_table, netdev_info, node, keyval) {
+		if (netdev_info->key.ifindex == key->ifindex)
+			return netdev_info;
+	}
+
+	return NULL;
+}
+
+static int get_netdev_info_key(const struct mbox_request *req,
+			       struct netdev_info_key *key)
+{
+	key->ifindex = req->ifindex;
+
+	return 0;
+}
+
+static struct netdev_info *get_netdev_info(const struct mbox_request *req)
+{
+	struct netdev_info *netdev_info;
+	struct netdev_info_key key;
+	int err;
+
+	err = get_netdev_info_key(req, &key);
+	if (err)
+		return ERR_PTR(err);
+
+	netdev_info = find_netdev_info(&key);
+	if (!netdev_info) {
+		pr_err("BUG: netdev_info for if %d not found.\n",
+		       key.ifindex);
+		return ERR_PTR(-ENOENT);
+	}
+
+	return netdev_info;
+}
+
 static int handle_load(const struct mbox_request *req, __u32 *prog_id)
 {
-	*prog_id = 0;
+	struct netdev_info *netdev_info;
+	struct bpf_prog_info info = {};
+	struct netdev_info_key key;
+	__u32 len = sizeof(info);
+	int err, prog_fd;
+
+	err = get_netdev_info_key(req, &key);
+	if (err)
+		return err;
+
+	netdev_info = find_netdev_info(&key);
+	if (netdev_info)
+		return 0;
+
+	netdev_info = malloc(sizeof(*netdev_info));
+	if (!netdev_info) {
+		pr_err("malloc for netdev_info failed.\n");
+		return -ENOMEM;
+	}
+	netdev_info->key.ifindex = key.ifindex;
+
+	prog_fd = load_bpf(req->ifindex, &netdev_info->obj);
+	if (prog_fd < 0) {
+		err = prog_fd;
+		goto err_netdev_info;
+	}
+
+	err = bpf_obj_get_info_by_fd(prog_fd, &info, &len);
+	if (err)
+		goto err_obj;
+
+	*prog_id = info.id;
+	hash_add(netdev_info_table, &netdev_info->node,
+		 get_netdev_info_keyval(&netdev_info->key));
+	pr_debug("XDP program for if %d was loaded\n", req->ifindex);
 
 	return 0;
+err_obj:
+	bpf_object__close(netdev_info->obj);
+err_netdev_info:
+	free(netdev_info);
+
+	return err;
 }
 
 static int handle_unload(const struct mbox_request *req)
 {
+	struct netdev_info *netdev_info;
+
+	netdev_info = get_netdev_info(req);
+	if (IS_ERR(netdev_info))
+		return PTR_ERR(netdev_info);
+
+	hash_del(&netdev_info->node);
+	bpf_object__close(netdev_info->obj);
+	free(netdev_info);
+	pr_debug("XDP program for if %d was closed\n", req->ifindex);
+
 	return 0;
 }
 
@@ -103,7 +339,10 @@ static void loop(void)
 int main(void)
 {
 	pr_info("Started xdp_flow\n");
+	if (setup())
+		return -1;
 	loop();
+	close(progfile_fd);
 
 	return 0;
 }
-- 
1.8.3.1

