Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBB62E987A
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 16:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbhADP1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 10:27:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42506 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbhADP1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 10:27:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104FEpvL114263;
        Mon, 4 Jan 2021 15:26:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=JdklI/p5vryj31jff16hPVUbbJ8xCtRAW579tZKTmiA=;
 b=gevogI3GAq9pwTyFZl34K6C1fdtTm+9Mdb7aG25M8nFCgkuw7wJLG/AcXKRQauIlKKe3
 ZHDB5mxJfJ81mZj8ffBAecMitD3S+W85/9b84RLaqqv+9l/E1lUofiMOm4TJg130djYJ
 uHBgfqpEphv6ztFQfQITm53n59acRhnhHKws07EJ/zMoRMZBnjE7e3G4vV3Vg72wy5nM
 EGpXdIneIxGXvvmErJIy4XbYQIMUFokE37Y0gMHSWnq+9LZJHPO996ihcFKEpOTUgdjT
 2tUrPwh9GmKrqvtP+Tn0hY1Jer6gvjcmSMSOKdnUuextkSrwHBgZ8R1hmnJQu0QkJgwh Vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35tgskmrt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 04 Jan 2021 15:26:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104FFOvn064560;
        Mon, 4 Jan 2021 15:26:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35v2axahj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Jan 2021 15:26:42 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 104FQeJZ009859;
        Mon, 4 Jan 2021 15:26:41 GMT
Received: from localhost.localdomain (/95.45.14.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Jan 2021 15:26:39 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com, toke@redhat.com,
        jean-philippe@linaro.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH bpf-next] ksnoop: kernel argument/return value tracing/display using BTF
Date:   Mon,  4 Jan 2021 15:26:31 +0000
Message-Id: <1609773991-10509-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9853 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF Type Format (BTF) provides a description of kernel data structures
and of the types kernel functions utilize as arguments and return values.

A helper was recently added - bpf_snprintf_btf() - that uses that
description to create a string representation of the data provided,
using the BTF id of its type.  For example to create a string
representation of a "struct sk_buff", the pointer to the skb
is provided along with the type id of "struct sk_buff".

Here that functionality is utilized to support tracing kernel
function entry and return using k[ret]probes.  The "struct pt_regs"
context can be used to derive arguments and return values, and
when the user supplies a function name we

- look it up in /proc/kallsyms to find its address/module
- look it up in the BTF kernel data to get types of arguments
  and return value
- store a map representation of the trace information, keyed by
  instruction pointer
- on function entry/return we look up the map to retrieve the BTF
  ids of the arguments/return values and can call bpf_snprintf_btf()
  with these argument/return values along with the type ids to store
  a string representation in the map.
- this is then sent via perf event to userspace where it can be
  displayed.

ksnoop can be used to show function signatures; for example:

$ ksnoop info ip_send_skb
int  ip_send_skb(struct net  * net, struct sk_buff  * skb);

Then we can trace the function, for example:

$ ksnoop trace ip_send_skb
                TASK    PID CPU#     TIMESTAMP FUNCTION

                ping   3833    1 251523.616148 ip_send_skb(
                                                net = *(struct net){
                                                 .passive = (refcount_t){
                                                  .refs = (atomic_t){
                                                   .counter = (int)2,
                                                  },
                                                 },

etc.  Truncated data is suffixed by "..." (2048 bytes of
string value are provided for each argument).  Up to
five arguments are displayed.

The arguments are referred to via name (e.g. skb, net), and
the return value is referred to as "return" (using the keyword
ensures we can never clash with an argument name), i.e.

                ping   3833    1 251523.617250 ip_send_skb(
                                                return = (int)0

                                               );

ksnoop can select specific arguments/return value rather
than tracing everything; for example:

$ ksnoop "ip_send_skb(skb)"

...will only trace the skb argument.  A single level of
reference is supported also, for example:

$ ksnoop "ip_send_skb(skb->sk)"

..for a pointer member or

$ ksnoop "ip_send_skb(skb->len)"

...for a non-pointer member.

Multiple functions can be specified also, for example:

$ ksnoop ip_send_skb ip_rcv

ksnoop will work for in-kernel and module-specific functions,
but in the latter case only base types or core kernel types
will be displayed; bpf_snprintf_btf() does not currently
support module-specific type display.

If invalid memory (such as a userspace pointers or invalid
NULL pointers) is encountered in function arguments, return
values or references, ksnoop will report it like this:

          irqbalance   1043    3 282167.478364 getname(
                                                filename = 0x7ffd5a0cca10
                                                /* Cannot show 'filename' as 'char  *'.
                                                 * Userspace/invalid ptr? */

                                               );

ksnoop can handle simple predicate evaluations;
"==", "!=", ">", "<", ">=", "<=" are supported and the
the assumption is that for a trace to be recorded, all
predicates have to evaluate to true.  For example:

$ ksnoop "ip_send_skb(skb->len == 84, skb)"
                ping  19009    1  19671.328156 ip_send_skb(
                                                skb->len = (unsigned int)84
                                                ,

                                                skb = *(struct sk_buff){
                                                 (union){
                                                  .sk = (struct sock *)0xffff930a01095c00,
                                                  .ip_defrag_offset = (int)17390592,
                                                 },
                                                 (union){
                                                  (struct){
                                                   ._skb_refdst = (long unsigned int)18446624275917552448,
                                                   .destructor = ( *)0xffffffffa5bfaf00,
                                                  },
                                                  .tcp_tsorted_anchor = (struct list_head){
                                                   .next = (struct list_head *)0xffff930b6729bb40,
                                                   .prev = (struct list_head *)0xffffffffa5bfaf00,
                                                  },
                                                 },
                                                 .len = (unsigned int)84,
                                                 .ignore_df = (__u8)0x1,
                                                 (union){
                                                  .csum = (__wsum)2619910871,
                                                  (struct){
                                                   .csum_start = (__u16)43735,
                                                   .csum_offset = (__u16)39976,
                                                  },
                                                 },
                                                 .transport_header = (__u16)36,
                                                 .network_header = (__u16)16,
                                                 .mac_header = (__u16)65535,
                                                 .tail = (sk_buff_data_t)100,
                                                 .end = (sk_buff_data_t)192,
                                                 .head = (unsigned char *)0xffff930b9d3cf800,
                                                 .data = (unsigned char *)0xffff930b9d3cf810,
                                                 .truesize = (unsigned int)768,
                                                 .users = (refcount_t){
                                                  .refs = (atomic_t){
                                                   .counter = (int)1,
                                                  },
                                                 },
                                                }

                                               );

It is possible to combine a request for entry arguments with a
predicate on return value; for example we might want to see
skbs on entry for cases where ip_send_skb eventually returned
an error value.  To do this, a predicate such as

$ ksnoop "ip_send_skb(skb, return!=0)"

...could be used.  On entry, rather than sending perf events
the skb argument string representation is "stashed", and
on return if the predicate is satisfied, the stashed data
along with return-value-related data is sent as a perf
event.  This allows us to satisfy requests such as
"show me entry argument X when the function fails, returning
a negative errno".

A note about overhead: it is very high.  The overhead costs are
a combination of known kprobe overhead costs and the cost of
assembling string representations of kernel data.

Use of predicates can mitigate overhead, as collection of trace
data will only occur when the predicate is satisfied; in such
cases it is best to lead with the predicate, e.g.

ksnoop "ip_send_skb(skb->dev == 0, skb)"

...as this will be evaluated before the skb is stringified,
and we potentially avoid that operation if the predicate fails.
The same is _not_ true however in the stash case; for

ksnoop "ip_send_skb(skb, return!=0)"

...we must collect the skb representation on entry as we do not
yet know if the function will fail or not.  If it does, the
data is discarded rather than sent as a perf event.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/bpf/Makefile            |  16 +-
 tools/bpf/ksnoop/Makefile     | 102 +++++
 tools/bpf/ksnoop/ksnoop.bpf.c | 336 +++++++++++++++
 tools/bpf/ksnoop/ksnoop.c     | 981 ++++++++++++++++++++++++++++++++++++++++++
 tools/bpf/ksnoop/ksnoop.h     | 110 +++++
 5 files changed, 1542 insertions(+), 3 deletions(-)
 create mode 100644 tools/bpf/ksnoop/Makefile
 create mode 100644 tools/bpf/ksnoop/ksnoop.bpf.c
 create mode 100644 tools/bpf/ksnoop/ksnoop.c
 create mode 100644 tools/bpf/ksnoop/ksnoop.h

diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
index 39bb322..8b2b6c9 100644
--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -73,7 +73,7 @@ $(OUTPUT)%.lex.o: $(OUTPUT)%.lex.c
 
 PROGS = $(OUTPUT)bpf_jit_disasm $(OUTPUT)bpf_dbg $(OUTPUT)bpf_asm
 
-all: $(PROGS) bpftool runqslower
+all: $(PROGS) bpftool runqslower ksnoop
 
 $(OUTPUT)bpf_jit_disasm: CFLAGS += -DPACKAGE='bpf_jit_disasm'
 $(OUTPUT)bpf_jit_disasm: $(OUTPUT)bpf_jit_disasm.o
@@ -89,7 +89,7 @@ $(OUTPUT)bpf_exp.lex.c: $(OUTPUT)bpf_exp.yacc.c
 $(OUTPUT)bpf_exp.yacc.o: $(OUTPUT)bpf_exp.yacc.c
 $(OUTPUT)bpf_exp.lex.o: $(OUTPUT)bpf_exp.lex.c
 
-clean: bpftool_clean runqslower_clean resolve_btfids_clean
+clean: bpftool_clean runqslower_clean resolve_btfids_clean ksnoop_clean
 	$(call QUIET_CLEAN, bpf-progs)
 	$(Q)$(RM) -r -- $(OUTPUT)*.o $(OUTPUT)bpf_jit_disasm $(OUTPUT)bpf_dbg \
 	       $(OUTPUT)bpf_asm $(OUTPUT)bpf_exp.yacc.* $(OUTPUT)bpf_exp.lex.*
@@ -97,7 +97,7 @@ clean: bpftool_clean runqslower_clean resolve_btfids_clean
 	$(Q)$(RM) -- $(OUTPUT)FEATURE-DUMP.bpf
 	$(Q)$(RM) -r -- $(OUTPUT)feature
 
-install: $(PROGS) bpftool_install runqslower_install
+install: $(PROGS) bpftool_install runqslower_install ksnoop_install
 	$(call QUIET_INSTALL, bpf_jit_disasm)
 	$(Q)$(INSTALL) -m 0755 -d $(DESTDIR)$(prefix)/bin
 	$(Q)$(INSTALL) $(OUTPUT)bpf_jit_disasm $(DESTDIR)$(prefix)/bin/bpf_jit_disasm
@@ -124,6 +124,15 @@ runqslower_install:
 runqslower_clean:
 	$(call descend,runqslower,clean)
 
+ksnoop:
+	$(call descend,ksnoop)
+
+ksnoop_install:
+	$(call descend,ksnoop,install)
+
+ksnoop_clean:
+	$(call descend,ksnoop,clean)
+
 resolve_btfids:
 	$(call descend,resolve_btfids)
 
@@ -132,4 +141,5 @@ resolve_btfids_clean:
 
 .PHONY: all install clean bpftool bpftool_install bpftool_clean \
 	runqslower runqslower_install runqslower_clean \
+	ksnoop ksnoop_install ksnoop_clean \
 	resolve_btfids resolve_btfids_clean
diff --git a/tools/bpf/ksnoop/Makefile b/tools/bpf/ksnoop/Makefile
new file mode 100644
index 0000000..c57ffec
--- /dev/null
+++ b/tools/bpf/ksnoop/Makefile
@@ -0,0 +1,102 @@
+# SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+include ../../scripts/Makefile.include
+include ../../scripts/Makefile.arch
+
+OUTPUT ?= $(abspath .output)/
+
+INSTALL ?= install
+
+CLANG ?= clang
+LLC ?= llc
+LLVM_STRIP ?= llvm-strip
+BPFTOOL_OUTPUT := $(OUTPUT)bpftool/
+DEFAULT_BPFTOOL := $(BPFTOOL_OUTPUT)bpftool
+BPFTOOL ?= $(DEFAULT_BPFTOOL)
+LIBBPF_SRC := $(abspath ../../lib/bpf)
+BPFOBJ_OUTPUT := $(OUTPUT)libbpf/
+BPFOBJ := $(BPFOBJ_OUTPUT)libbpf.a
+BPF_INCLUDE := $(BPFOBJ_OUTPUT)
+INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../lib)        \
+       -I$(abspath ../../include/uapi)
+
+ifeq ($(KSNOOP_VERSION),)
+KSNOOP_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
+endif
+
+CFLAGS := -g -Wall
+CFLAGS += -DKSNOOP_VERSION='"$(KSNOOP_VERSION)"'
+
+# Try to detect best kernel BTF source
+KERNEL_REL := $(shell uname -r)
+VMLINUX_BTF_PATHS := /sys/kernel/btf/vmlinux /boot/vmlinux-$(KERNEL_REL)
+VMLINUX_BTF_PATH := $(or $(VMLINUX_BTF),$(firstword			       \
+					  $(wildcard $(VMLINUX_BTF_PATHS))))
+
+ifeq ($(V),1)
+Q =
+else
+Q = @
+MAKEFLAGS += --no-print-directory
+submake_extras := feature_display=0
+endif
+
+.DELETE_ON_ERROR:
+
+.PHONY: all clean ksnoop
+all: ksnoop
+
+ksnoop: $(OUTPUT)/ksnoop
+
+clean:
+	$(call QUIET_CLEAN, ksnoop)
+	$(Q)$(RM) -r $(BPFOBJ_OUTPUT) $(BPFTOOL_OUTPUT)
+	$(Q)$(RM) $(OUTPUT)*.o $(OUTPUT)*.d
+	$(Q)$(RM) $(OUTPUT)*.skel.h $(OUTPUT)vmlinux.h
+	$(Q)$(RM) $(OUTPUT)ksnoop
+	$(Q)$(RM) -r .output
+
+install: $(OUTPUT)/ksnoop
+	$(call QUIET_INSTALL, ksnoop)
+	$(Q)$(INSTALL) -m 0755 -d $(DESTDIR)$(prefix)/sbin
+	$(Q)$(INSTALL) $(OUTPUT)ksnoop $(DESTDIR)$(prefix)/sbin/ksnoop
+
+uninstall:
+	$(call QUIET_UNINST, ksnoop)
+	$(Q)$(RM) -- $(DESTDIR)$(prefix)/sbin/ksnoop
+
+$(OUTPUT)/ksnoop: $(OUTPUT)/ksnoop.o $(BPFOBJ)
+	$(QUIET_LINK)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
+
+$(OUTPUT)/ksnoop.o: ksnoop.h $(OUTPUT)/ksnoop.skel.h	      \
+			$(OUTPUT)/ksnoop.bpf.o
+
+$(OUTPUT)/ksnoop.bpf.o: $(OUTPUT)/vmlinux.h ksnoop.h
+
+$(OUTPUT)/%.skel.h: $(OUTPUT)/%.bpf.o | $(BPFTOOL)
+	$(QUIET_GEN)$(BPFTOOL) gen skeleton $< > $@
+
+$(OUTPUT)/%.bpf.o: %.bpf.c $(BPFOBJ) | $(OUTPUT)
+	$(QUIET_GEN)$(CLANG) -g -D__TARGET_ARCH_$(SRCARCH) -O2 -target bpf \
+		$(INCLUDES) -c $(filter %.c,$^) -o $@ &&		   \
+	$(LLVM_STRIP) -g $@
+
+$(OUTPUT)/%.o: %.c | $(OUTPUT)
+	$(QUIET_CC)$(CC) $(CFLAGS) $(INCLUDES) -c $(filter %.c,$^) -o $@
+
+$(OUTPUT) $(BPFOBJ_OUTPUT) $(BPFTOOL_OUTPUT):
+	$(QUIET_MKDIR)mkdir -p $@
+
+$(OUTPUT)/vmlinux.h: $(VMLINUX_BTF_PATH) | $(OUTPUT) $(BPFTOOL)
+	$(Q)if [ ! -e "$(VMLINUX_BTF_PATH)" ] ; then \
+		echo "Couldn't find kernel BTF; set VMLINUX_BTF to"	       \
+			"specify its location." >&2;			       \
+		exit 1;\
+	fi
+	$(QUIET_GEN)$(BPFTOOL) btf dump file $(VMLINUX_BTF_PATH) format c > $@
+
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(BPFOBJ_OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC) OUTPUT=$(BPFOBJ_OUTPUT) $@
+
+$(DEFAULT_BPFTOOL): | $(BPFTOOL_OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C ../bpftool OUTPUT=$(BPFTOOL_OUTPUT)   \
+		    CC=$(HOSTCC) LD=$(HOSTLD)
diff --git a/tools/bpf/ksnoop/ksnoop.bpf.c b/tools/bpf/ksnoop/ksnoop.bpf.c
new file mode 100644
index 0000000..98ab830
--- /dev/null
+++ b/tools/bpf/ksnoop/ksnoop.bpf.c
@@ -0,0 +1,336 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+
+#include <asm/errno.h>
+#include "ksnoop.h"
+
+/* For kretprobes, the instruction pointer in the struct pt_regs context
+ * is the kretprobe_trampoline, so to derive the instruction pointer
+ * we need to push it onto a stack on entry and pop it on return.
+ */
+#define FUNC_MAX_STACK_DEPTH	(2 * MAX_FUNC_TRACES)
+
+#define FUNC_MAX_PROCS		256
+
+#ifndef NULL
+#define NULL			0
+#endif
+
+struct func_stack {
+	__u64 ips[FUNC_MAX_STACK_DEPTH];
+	__u8 stack_depth;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, FUNC_MAX_PROCS);
+	__type(key, __u64);
+	__type(value, struct func_stack);
+} ksnoop_func_stack SEC(".maps");
+
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(max_entries, 8);
+	__type(key, __u64);
+	__type(value, struct trace);
+} ksnoop_func_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(value_size, sizeof(int));
+	__uint(key_size, sizeof(int));
+} ksnoop_perf_map SEC(".maps");
+
+/* function stacks are keyed on pid/tgid. Inlined to avoid verifier
+ * complaint about global function not returing a scalar.
+ */
+static inline struct trace *get_trace(struct pt_regs *ctx, __u64 key,
+				      bool entry)
+{
+	struct func_stack *func_stack, new = { 0 };
+	struct trace *trace;
+	__u64 ip;
+
+	func_stack = bpf_map_lookup_elem(&ksnoop_func_stack, &key);
+	if (!func_stack) {
+		bpf_map_update_elem(&ksnoop_func_stack, &key, &new, 0);
+		func_stack = bpf_map_lookup_elem(&ksnoop_func_stack, &key);
+	}
+	if (!func_stack) {
+		bpf_printk("cannot retrieve func stack for tgid/pid %llx\n",
+			   key);
+		return NULL;
+	}
+
+	if (entry) {
+		ip = KSNOOP_IP_FIX(PT_REGS_IP_CORE(ctx));
+		/* push ip onto stack. return will pop it. */
+		if (func_stack->stack_depth > FUNC_MAX_STACK_DEPTH) {
+			bpf_printk("stackdepth %d exceeded for tgid/pid %llx\n",
+				   func_stack->stack_depth, key);
+			return NULL;
+		}
+		func_stack->ips[func_stack->stack_depth++] = ip;
+	} else {
+		/* retrieve ip from stack as IP in pt_regs is
+		 * bpf kretprobe trampoline address.
+		 */
+		if (func_stack->stack_depth == 0 ||
+		    func_stack->stack_depth > FUNC_MAX_STACK_DEPTH) {
+			if (func_stack->stack_depth == 0)
+				bpf_printk("no entry for tgid/pid %lld\n",
+					   key);
+			if (func_stack->stack_depth > FUNC_MAX_STACK_DEPTH)
+				bpf_printk("stackdepth %d exceeded for tgid/pid %llx\n",
+					   func_stack->stack_depth, key);
+			return NULL;
+		}
+		ip = func_stack->ips[--func_stack->stack_depth];
+	}
+
+	return bpf_map_lookup_elem(&ksnoop_func_map, &ip);
+}
+
+static inline __u64 get_arg(struct pt_regs *ctx, enum arg argnum)
+{
+	switch (argnum) {
+	case KSNOOP_ARG1:
+		return PT_REGS_PARM1_CORE(ctx);
+	case KSNOOP_ARG2:
+		return PT_REGS_PARM2_CORE(ctx);
+	case KSNOOP_ARG3:
+		return PT_REGS_PARM3_CORE(ctx);
+	case KSNOOP_ARG4:
+		return PT_REGS_PARM4_CORE(ctx);
+	case KSNOOP_ARG5:
+		return PT_REGS_PARM5_CORE(ctx);
+	case KSNOOP_RETURN:
+		return PT_REGS_RC_CORE(ctx);
+	default:
+		return 0;
+	}
+}
+
+static inline int ksnoop(struct pt_regs *ctx, bool entry)
+{
+	struct btf_ptr btf_ptr = { };
+	struct trace *trace;
+	struct func *func;
+	__u16 trace_len;
+	__u64 pid_tgid;
+	__u64 data;
+	int ret;
+	__u8 i;
+
+	pid_tgid = bpf_get_current_pid_tgid();
+	trace = get_trace(ctx, pid_tgid, entry);
+	if (!trace)
+		return 0;
+
+	trace->time = bpf_ktime_get_ns();
+	trace->cpu = bpf_get_smp_processor_id();
+
+	func = &trace->func;
+
+	/* we may be tracing return and have already collected entry
+	 * traces; such cases occur when we have a predicate on the
+	 * return value _and_ we trace entry values.  In such cases
+	 * we need to collect entry values but only report them if the
+	 * predicate matches entry _and_ return predicates.  In such
+	 * cases do not reset buf_len as we need to continue recording
+	 * return values into the buffer along with the already-recorded
+	 * entry values.
+	 */
+	if (!entry && (trace->flags & KSNOOP_F_STASH)) {
+		if (trace->data_flags & KSNOOP_F_STASHED) {
+			trace->data_flags &= ~KSNOOP_F_STASHED;
+		} else {
+			/* expected stashed data, predicate failed? */
+			goto skiptrace;
+		}
+	} else {
+		/* clear trace data before starting. */
+		__builtin_memset(&trace->trace_data, 0,
+				 sizeof(trace->trace_data));
+		trace->data_flags = 0;
+		trace->buf_len = 0;
+		trace->buf[0] = '\0';
+	}
+
+	if (entry)
+		trace->data_flags |= KSNOOP_F_ENTRY;
+	else
+		trace->data_flags |= KSNOOP_F_RETURN;
+
+
+	for (i = 0; i < MAX_TRACES; i++) {
+		struct trace_data *currdata;
+		struct value *currtrace;
+		char *buf_offset = NULL;
+		void *dataptr;
+
+		currdata = &trace->trace_data[i];
+		currtrace = &trace->traces[i];
+
+		/* skip irrelevant info (return value for entry etc) */
+		if ((entry && !base_arg_is_entry(currtrace->base_arg)) ||
+		    (!entry && base_arg_is_entry(currtrace->base_arg)))
+			continue;
+
+		/* skip void (unused) trace arguments, ensuring not to
+		 * skip "void *".
+		 */
+		if (currtrace->type_id == 0 && currtrace->flags == 0)
+			continue;
+
+		data = get_arg(ctx, currtrace->base_arg);
+
+		dataptr = (void *)data;
+
+		if (currtrace->offset)
+			dataptr += currtrace->offset;
+
+		/* look up member value and read into data field, provided
+		 * it <= size of a __u64; when it is, it can be used in
+		 * predicate evaluation.
+		 */
+		if (currtrace->flags & KSNOOP_F_MEMBER) {
+			ret = -EINVAL;
+			data = 0;
+			if (currtrace->size <= sizeof(__u64))
+				ret = bpf_probe_read_kernel(&data,
+							    currtrace->size,
+							    dataptr);
+			else
+				bpf_printk("size was %d cant trace",
+					   currtrace->size);
+			if (ret) {
+				currdata->err_type_id =
+					currtrace->type_id;
+				currdata->err = ret;
+				continue;
+			}
+			if (currtrace->flags & KSNOOP_F_PTR)
+				dataptr = (void *)data;
+		}
+
+		/* simple predicate evaluation: if any predicate fails,
+		 * skip all tracing for this function.
+		 */
+		if (currtrace->flags & KSNOOP_F_PREDICATE_MASK) {
+			bool ok = false;
+
+			if (currtrace->flags & KSNOOP_F_PREDICATE_EQ &&
+			    data == currtrace->predicate_value)
+				ok = true;
+
+			if (currtrace->flags & KSNOOP_F_PREDICATE_NOTEQ &&
+			    data != currtrace->predicate_value)
+				ok = true;
+
+			if (currtrace->flags & KSNOOP_F_PREDICATE_GT &&
+			    data > currtrace->predicate_value)
+				ok = true;
+			if (currtrace->flags & KSNOOP_F_PREDICATE_LT &&
+			    data < currtrace->predicate_value)
+				ok = true;
+
+			if (!ok)
+				goto skiptrace;
+		}
+
+		currdata->raw_value = data;
+
+		if (currtrace->flags & (KSNOOP_F_PTR | KSNOOP_F_MEMBER))
+			btf_ptr.ptr = dataptr;
+		else
+			btf_ptr.ptr = &data;
+
+		btf_ptr.type_id = currtrace->type_id;
+
+		if (trace->buf_len + MAX_TRACE_DATA >= MAX_TRACE_BUF)
+			break;
+
+		buf_offset = &trace->buf[trace->buf_len];
+		if (buf_offset > &trace->buf[MAX_TRACE_BUF]) {
+			currdata->err_type_id = currtrace->type_id;
+			currdata->err = -ENOSPC;
+			continue;
+		}
+		currdata->buf_offset = trace->buf_len;
+
+		ret = bpf_snprintf_btf(buf_offset,
+				       MAX_TRACE_DATA,
+				       &btf_ptr, sizeof(btf_ptr),
+				       BTF_F_PTR_RAW);
+		if (ret < 0) {
+			currdata->err_type_id = currtrace->type_id;
+			currdata->err = ret;
+			continue;
+		} else if (ret < MAX_TRACE_DATA) {
+			currdata->buf_len = ret + 1;
+			trace->buf_len += ret + 1;
+		} else {
+			currdata->buf_len = MAX_TRACE_DATA;
+			trace->buf_len += MAX_TRACE_DATA;
+		}
+	}
+
+	/* we may be simply stashing values, and will report them
+	 * on return; if so simply return without sending perf event.
+	 * return will use remaining buffer space to fill in its values.
+	 */
+	if (entry && (trace->flags & KSNOOP_F_STASH)) {
+		trace->data_flags |= KSNOOP_F_STASHED;
+		return 0;
+	}
+	/* if a custom trace stores no trace info, no need to
+	 * report perf event.  For default tracing case however
+	 * we want to record function entry/return with no arguments
+	 * or return values; in those cases trace data length is
+	 * 0 but we want the entry/return events to be sent
+	 * regardless.
+	 */
+	if ((trace->flags & KSNOOP_F_CUSTOM) && trace->buf_len == 0)
+		goto skiptrace;
+
+	trace->comm[0] = '\0';
+	bpf_get_current_comm(trace->comm, sizeof(trace->comm));
+	trace->pid = pid_tgid & 0xffffffff;
+	/* trim perf event size to only contain data we've recorded. */
+	trace_len = sizeof(*trace) + trace->buf_len - MAX_TRACE_BUF;
+	if (trace_len > sizeof(*trace))
+		goto skiptrace;
+	ret = bpf_perf_event_output(ctx, &ksnoop_perf_map,
+				    BPF_F_CURRENT_CPU,
+				    trace, trace_len);
+	if (ret < 0) {
+		bpf_printk("could not send event for %s\n",
+			   (const char *)func->name);
+	}
+skiptrace:
+	trace->buf_len = 0;
+
+	return 0;
+}
+
+SEC("kprobe/foo")
+int kprobe_entry(struct pt_regs *ctx)
+{
+	return ksnoop(ctx, true);
+}
+
+SEC("kretprobe/foo")
+int kprobe_return(struct pt_regs *ctx)
+{
+	return ksnoop(ctx, false);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/bpf/ksnoop/ksnoop.c b/tools/bpf/ksnoop/ksnoop.c
new file mode 100644
index 0000000..1b2f64d
--- /dev/null
+++ b/tools/bpf/ksnoop/ksnoop.c
@@ -0,0 +1,981 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#include <ctype.h>
+#include <errno.h>
+#include <getopt.h>
+#include <linux/bpf.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+
+#include "ksnoop.h"
+#include "ksnoop.skel.h"
+
+struct btf *vmlinux_btf;
+const char *bin_name;
+int pages = PAGES_DEFAULT;
+
+enum log_level {
+	DEBUG,
+	WARN,
+	ERROR,
+};
+
+enum log_level log_level = WARN;
+
+void __p(enum log_level level, char *level_str, char *fmt, ...)
+{
+	va_list ap;
+
+	if (level < log_level)
+		return;
+	va_start(ap, fmt);
+	fprintf(stderr, "%s: ", level_str);
+	vfprintf(stderr, fmt, ap);
+	fprintf(stderr, "\n");
+	va_end(ap);
+}
+
+#define p_err(fmt, ...)		__p(ERROR, "Error", fmt, __VA_ARGS__)
+#define p_warn(fmt, ...)	__p(WARNING, "Warn", fmt, __VA_ARGS__)
+#define	p_debug(fmt, ...)	__p(DEBUG, "Debug", fmt, __VA_ARGS__)
+
+int do_version(int argc, char **argv)
+{
+	printf("%s v%s\n", bin_name, KSNOOP_VERSION);
+	return 0;
+}
+
+int cmd_help(int argc, char **argv)
+{
+	fprintf(stderr,
+		"Usage: %s [OPTIONS] [COMMAND | help] FUNC\n"
+		"	OPTIONS := { {-d|--debug} | {-V|--version} |\n"
+		"		     {-p|--pages} }\n"
+		"	COMMAND	:= { info | trace  }\n"
+		"	FUNC	:= { name | name(ARG[,ARG]*) }\n"
+		"	ARG	:= { arg | arg->member }\n",
+		bin_name);
+	fprintf(stderr,
+		"Examples:\n"
+		"	%s info ip_send_skb\n"
+		"	%s trace ip_send_skb\n"
+		"	%s trace \"ip_send_skb(skb, return)\"\n"
+		"	%s trace \"ip_send_skb(skb->sk, return))\"\n",
+		bin_name, bin_name, bin_name, bin_name);
+	return 0;
+}
+
+void usage(void)
+{
+	cmd_help(0, NULL);
+	exit(1);
+}
+
+void type_to_value(struct btf *btf, char *name, __u32 type_id,
+		   struct value *val)
+{
+	const struct btf_type *type;
+	__s32 id = type_id;
+
+	if (strlen(val->name) == 0) {
+		if (name)
+			strncpy(val->name, name,
+				sizeof(val->name));
+		else
+			val->name[0] = '\0';
+	}
+
+	/* handle "void" type */
+	if (type_id == 0) {
+		val->type_id = type_id;
+		val->size = 0;
+		return;
+	}
+
+	val->type_id = KSNOOP_ID_UNKNOWN;
+
+	do {
+		type = btf__type_by_id(btf, id);
+
+		switch (BTF_INFO_KIND(type->info)) {
+		case BTF_KIND_CONST:
+		case BTF_KIND_VOLATILE:
+		case BTF_KIND_RESTRICT:
+			id = type->type;
+			break;
+		case BTF_KIND_PTR:
+			val->flags |= KSNOOP_F_PTR;
+			val->size = sizeof(void *);
+			id = type->type;
+			break;
+		case BTF_KIND_TYPEDEF:
+			/* retain typedef type id, get size from target
+			 * type.
+			 */
+			if (val->type_id == KSNOOP_ID_UNKNOWN)
+				val->type_id = id;
+			id = type->type;
+			break;
+		case BTF_KIND_ARRAY:
+		case BTF_KIND_INT:
+		case BTF_KIND_ENUM:
+		case BTF_KIND_STRUCT:
+		case BTF_KIND_UNION:
+			/* size will be 0 for array; that's fine since
+			 * we do not support predicates for arrays.
+			 */
+			if (!val->size)
+				val->size = type->size;
+			if (val->type_id == KSNOOP_ID_UNKNOWN)
+				val->type_id = id;
+			return;
+		default:
+			goto out;
+		}
+	} while (id >= 0);
+out:
+	val->type_id = KSNOOP_ID_UNKNOWN;
+}
+
+int member_to_value(struct btf *btf, const char *name, __u32 type_id,
+		     struct value *val)
+
+{
+	const struct btf_member *member;
+	const struct btf_type *type;
+	const char *pname;
+	__s32 id = type_id;
+	int i, nmembers;
+	__u8 kind;
+
+	/* type_to_value has already stripped qualifiers, so
+	 * we either have a base type, a struct, union, etc.
+	 * Only struct/unions have named members so anything
+	 * else is invalid.
+	 */
+
+	p_debug("Looking for member '%s' in type id %d", name, type_id);
+	type = btf__type_by_id(btf, id);
+	pname = btf__str_by_offset(btf, type->name_off);
+	if (strlen(pname) == 0)
+		pname = "<anon>";
+
+	kind = BTF_INFO_KIND(type->info);
+	switch (kind) {
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		nmembers = BTF_INFO_VLEN(type->info);
+		p_debug("Checking %d members...", nmembers);
+		for (member = (struct btf_member *)(type + 1), i = 0;
+		     i < nmembers;
+		     member++, i++) {
+			const char *mname;
+			__u16 offset;
+
+			type = btf__type_by_id(btf, member->type);
+			mname = btf__str_by_offset(btf, member->name_off);
+			offset = member->offset / 8;
+
+			p_debug("Checking member '%s' type %d offset %d",
+				mname, member->type, offset);
+
+			/* anonymous struct member? */
+			kind = BTF_INFO_KIND(type->info);
+			if (strlen(mname) == 0 &&
+			    (kind == BTF_KIND_STRUCT ||
+			     kind == BTF_KIND_UNION)) {
+				p_debug("Checking anon struct/union %d",
+					member->type);
+				val->offset += offset;
+				if (!member_to_value(btf, name, member->type,
+						     val))
+					return 0;
+				val->offset -= offset;
+				continue;
+			}
+
+			if (strcmp(mname, name) == 0) {
+				val->offset += offset;
+				val->flags = KSNOOP_F_MEMBER;
+				type_to_value(btf, NULL, member->type, val);
+				p_debug("Member '%s', offset %d, flags %x",
+					mname, val->offset, val->flags);
+				return 0;
+			}
+		}
+		p_err("No member '%s' found in %s [%d], offset %d", name, pname,
+		      id, val->offset);
+		break;
+	default:
+		p_err("'%s' is not a struct/union", pname);
+		break;
+	}
+	return -ENOENT;
+}
+
+int get_func_btf(struct btf *btf, struct func *func)
+{
+	const struct btf_param *param;
+	const struct btf_type *type;
+	__s32 id;
+	__u8 i;
+
+	id = btf__find_by_name_kind(btf, func->name, BTF_KIND_FUNC);
+	if (id <= 0) {
+		p_err("Cannot find function '%s' in BTF",
+		       func->name);
+		return -ENOENT;
+	}
+	type = btf__type_by_id(btf, id);
+	if (libbpf_get_error(type) ||
+	    BTF_INFO_KIND(type->info) != BTF_KIND_FUNC) {
+		p_err("Error looking up function type via id '%d'", id);
+		return -EINVAL;
+	}
+	type = btf__type_by_id(btf, type->type);
+	if (libbpf_get_error(type) ||
+	    BTF_INFO_KIND(type->info) != BTF_KIND_FUNC_PROTO) {
+		p_err("Error looking up function proto type via id '%d'", id);
+		return -EINVAL;
+	}
+	for (param = (struct btf_param *)(type + 1), i = 0;
+	     i < BTF_INFO_VLEN(type->info) && i < MAX_ARGS;
+	     param++, i++) {
+		type_to_value(btf,
+			      (char *)btf__str_by_offset(btf, param->name_off),
+			      param->type, &func->args[i]);
+		p_debug("arg #%d: <name '%s', type id '%u', size %d>",
+			i + 1, func->args[i].name, func->args[i].type_id,
+			func->args[i].size);
+	}
+
+	/* real number of args, even if it is > number we recorded. */
+	func->nr_args = BTF_INFO_VLEN(type->info);
+
+	type_to_value(btf, KSNOOP_RETURN_NAME, type->type,
+		      &func->args[KSNOOP_RETURN]);
+	p_debug("return value: type id '%u'>",
+		func->args[KSNOOP_RETURN].type_id);
+	return 0;
+}
+
+int predicate_to_value(char *predicate, struct value *val)
+{
+	char pred[MAX_STR], num[MAX_STR];
+	char *endptr;
+
+	if (!predicate)
+		return 0;
+
+	p_debug("checking predicate '%s' for '%s'", predicate, val->name);
+
+	if (sscanf(predicate, "%[!=><]%[0-9]", pred, num) != 2) {
+		p_err("Invalid specification; expected predicate, not '%s'",
+		      predicate);
+		return -EINVAL;
+	}
+	if (val->size == 0 || val->size > sizeof(__u64)) {
+		p_err("'%s' (size %d) does not support predicate comparison",
+		      val->name, val->size);
+		return -EINVAL;
+	}
+	val->predicate_value = strtoull(num, &endptr, 0);
+
+	if (strcmp(pred, "==") == 0) {
+		val->flags |= KSNOOP_F_PREDICATE_EQ;
+		goto out;
+	} else if (strcmp(pred, "!=") == 0) {
+		val->flags |= KSNOOP_F_PREDICATE_NOTEQ;
+		goto out;
+	}
+	if (pred[0] == '>')
+		val->flags |= KSNOOP_F_PREDICATE_GT;
+	else if (pred[0] == '<')
+		val->flags |= KSNOOP_F_PREDICATE_LT;
+
+	if (strlen(pred) == 1)
+		goto out;
+
+	if (pred[1] != '=') {
+		p_err("Invalid predicate specification '%s'", predicate);
+		return -EINVAL;
+	}
+	val->flags |= KSNOOP_F_PREDICATE_EQ;
+
+out:
+	p_debug("predicate '%s', flags 0x%x value %x",
+		predicate, val->flags, val->predicate_value);
+
+	return 0;
+}
+
+int trace_to_value(struct btf *btf, struct func *func, char *argname,
+		   char *membername, char *predicate, struct value *val)
+{
+	__u8 i;
+
+	strncpy(val->name, argname, sizeof(val->name));
+	if (strlen(membername) > 0) {
+		strncat(val->name, "->", sizeof(val->name));
+		strncat(val->name, membername, sizeof(val->name));
+	}
+
+	for (i = 0; i < MAX_TRACES; i++) {
+		if (!func->args[i].name)
+			continue;
+		if (strcmp(argname, func->args[i].name) != 0)
+			continue;
+		p_debug("setting base arg for val %s to %d", val->name, i);
+		val->base_arg = i;
+
+		if (strlen(membername) > 0) {
+			if (member_to_value(btf, membername,
+					    func->args[i].type_id, val))
+				return -ENOENT;
+		} else {
+			val->type_id = func->args[i].type_id;
+			val->flags |= func->args[i].flags;
+			val->size = func->args[i].size;
+		}
+		predicate_to_value(predicate, val);
+
+		return 0;
+	}
+	p_err("Could not find '%s' for '%s'", val->name, func->name);
+	return -ENOENT;
+}
+
+struct btf *get_btf(const char *name)
+{
+	char module_btf[MAX_STR];
+	struct btf *btf;
+
+	p_debug("getting BTF for %s", name ? name : "vmlinux");
+
+	if (!name || strlen(name) == 0)
+		btf = libbpf_find_kernel_btf();
+	else {
+		snprintf(module_btf, sizeof(module_btf),
+			 "/sys/kernel/btf/%s", name);
+		btf = btf__parse_split(module_btf, vmlinux_btf);
+	}
+	if (libbpf_get_error(btf)) {
+		p_err("No BTF for '%s', cannot determine type info: %s",
+		       strerror(libbpf_get_error(btf)));
+		return NULL;
+	}
+	return btf;
+}
+
+void copy_without_spaces(char *target, char *src)
+{
+	for (; *src != '\0'; src++)
+		if (!isspace(*src))
+			*(target++) = *src;
+	*target = '\0';
+}
+
+char *type_id_to_str(struct btf *btf, __s32 type_id, char *str)
+{
+	const struct btf_type *type;
+	const char *name = "";
+	char *suffix = " ";
+	char *prefix = "";
+	char *ptr = "";
+
+	str[0] = '\0';
+
+	switch (type_id) {
+	case 0:
+		name = "void";
+		break;
+	case KSNOOP_ID_UNKNOWN:
+		name = "?";
+		break;
+	default:
+		do {
+			type = btf__type_by_id(btf, type_id);
+
+			if (libbpf_get_error(type)) {
+				name = "?";
+				break;
+			}
+			switch (BTF_INFO_KIND(type->info)) {
+			case BTF_KIND_CONST:
+			case BTF_KIND_VOLATILE:
+			case BTF_KIND_RESTRICT:
+				type_id = type->type;
+				break;
+			case BTF_KIND_PTR:
+				ptr = "* ";
+				type_id = type->type;
+				break;
+			case BTF_KIND_ARRAY:
+				suffix = "[]";
+				type_id = type->type;
+				break;
+			case BTF_KIND_STRUCT:
+				prefix = "struct ";
+				name = btf__str_by_offset(btf, type->name_off);
+				break;
+			case BTF_KIND_UNION:
+				prefix = "union";
+				name = btf__str_by_offset(btf, type->name_off);
+				break;
+			case BTF_KIND_ENUM:
+				prefix = "enum ";
+				break;
+			case BTF_KIND_TYPEDEF:
+				name = btf__str_by_offset(btf, type->name_off);
+				break;
+			default:
+				name = btf__str_by_offset(btf, type->name_off);
+				break;
+			}
+		} while (type_id >= 0 && strlen(name) == 0);
+
+		break;
+	}
+	snprintf(str, MAX_STR, "%s%s%s%s", prefix, name, suffix, ptr);
+
+	return str;
+}
+
+char *value_to_str(struct btf *btf, struct value *val, char *str)
+{
+
+	str = type_id_to_str(btf, val->type_id, str);
+	if (val->flags & KSNOOP_F_PTR)
+		strncat(str, " * ", MAX_STR);
+	if (strlen(val->name) > 0 &&
+	    strcmp(val->name, KSNOOP_RETURN_NAME) != 0)
+		strncat(str, val->name, MAX_STR);
+
+	return str;
+}
+
+/* based heavily on bpf_object__read_kallsyms_file() in libbpf.c */
+int get_func_ip_mod(struct func *func)
+{
+	char sym_type, sym_name[MAX_STR], mod_info[MAX_STR];
+	unsigned long long sym_addr;
+	int ret, err = 0;
+	FILE *f;
+
+	f = fopen("/proc/kallsyms", "r");
+	if (!f) {
+		err = errno;
+		p_err("failed to open /proc/kallsyms: %d\n", strerror(err));
+		return err;
+	}
+
+	while (true) {
+		ret = fscanf(f, "%llx %c %128s%[^\n]\n",
+			     &sym_addr, &sym_type, sym_name, mod_info);
+		if (ret == EOF && feof(f))
+			break;
+		if (ret < 3) {
+			p_err("failed to read kallsyms entry: %d\n", ret);
+			err = -EINVAL;
+			break;
+		}
+		if (strcmp(func->name, sym_name) != 0)
+			continue;
+		func->ip = sym_addr;
+		func->mod[0] = '\0';
+		/* get module name from [modname] */
+		if (ret == 4 &&
+		    sscanf(mod_info, "%*[\t ]\[%[^]]", func->mod) == 1)
+			p_debug("Module symbol '%llx' from %s'",
+				func->ip, func->mod);
+		p_debug("%s =  <ip %llx, mod %s>", func->name, func->ip,
+			strlen(func->mod) > 0 ? func->mod : "vmlinux");
+		break;
+	}
+	fclose(f);
+	return err;
+}
+
+#define VALID_NAME	"%[A-Za-z0-9\\-_]"
+#define ARGDATA		"%[^)]"
+
+int parse_trace(char *str, struct trace *trace)
+{
+	struct func *func = &trace->func;
+	char tracestr[MAX_STR], argdata[MAX_STR];
+	char argname[MAX_STR], membername[MAX_STR];
+	__u8 i, nr_predicates = 0, nr_entry = 0, nr_return = 0;
+	char *arg, *saveptr;
+	int ret;
+
+	copy_without_spaces(tracestr, str);
+
+	p_debug("Parsing trace '%s'", tracestr);
+
+	ret = sscanf(tracestr, VALID_NAME "(" ARGDATA ")", func->name, argdata);
+	switch (ret) {
+	case 1:
+		if (strlen(tracestr) > strlen(func->name) + 2) {
+			p_err("Invalid function specification '%s'", tracestr);
+			usage();
+		}
+		argdata[0] = '\0';
+		p_debug("got func '%s'", func->name);
+		break;
+	case 2:
+		if (strlen(tracestr) >
+		    strlen(func->name) + strlen(argdata) + 2) {
+			p_err("Invalid function specification '%s'", tracestr);
+			usage();
+		}
+		p_debug("got func '%s', args '%s'", func->name, argdata);
+		trace->flags |= KSNOOP_F_CUSTOM;
+		break;
+	default:
+		usage();
+	}
+
+	/* get address of function and - if it is in a module - module name */
+	ret = get_func_ip_mod(func);
+	if (ret) {
+		p_err("could not get address of '%s'", func->name);
+		return ret;
+	}
+
+	/* get BTF associated with core kernel/module, then get info about
+	 * function from that BTF.
+	 */
+	trace->btf = get_btf(func->mod);
+	if (!trace->btf)
+		return -ENOENT;
+	ret = get_func_btf(trace->btf, func);
+	if (ret) {
+		p_debug("unexpected return value '%d' getting function", ret);
+		return ret;
+	}
+
+	for (arg = strtok_r(argdata, ",", &saveptr), i = 0;
+	     arg;
+	     arg = strtok_r(NULL, ",", &saveptr), i++) {
+		char *predicate = NULL;
+
+		ret = sscanf(arg, VALID_NAME "->" VALID_NAME,
+			     argname, membername);
+		if (ret == 2) {
+			if (strlen(arg) >
+			    strlen(argname) + strlen(membername) + 2) {
+				predicate = arg + strlen(argname) +
+					    strlen(membername) + 2;
+			}
+			p_debug("'%s' dereferences '%s', predicate '%s'",
+				argname, membername, predicate);
+		} else {
+			if (strlen(arg) > strlen(argname))
+				predicate = arg + strlen(argname);
+			p_debug("'%s' arg, predicate '%s'", argname, predicate);
+			membername[0] = '\0';
+		}
+
+		if (i >= MAX_TRACES) {
+			p_err("Too many arguments; up to %d are supported",
+			      MAX_TRACES);
+			return -EINVAL;
+		}
+		if (trace_to_value(trace->btf, func, argname, membername,
+				   predicate, &trace->traces[i]))
+			return -EINVAL;
+
+		if (predicate)
+			nr_predicates++;
+		if (trace->traces[i].base_arg == KSNOOP_RETURN)
+			nr_return++;
+		else
+			nr_entry++;
+
+		trace->nr_traces++;
+	}
+
+	if (trace->nr_traces > 0) {
+		trace->flags |= KSNOOP_F_CUSTOM;
+		/* If we have one or more predicates _and_ references to
+		 * entry and return values, we need to activate "stash"
+		 * mode where arg traces are stored on entry and not
+		 * sent until return to ensure predicates are satisfied.
+		 */
+		if (nr_predicates > 0 && nr_entry > 0 && nr_return > 0)
+			trace->flags |= KSNOOP_F_STASH;
+		p_debug("custom trace with %d args, flags 0x%x",
+			trace->nr_traces, trace->flags);
+	} else {
+		p_debug("Standard trace, function with %d arguments",
+			func->nr_args);
+		/* copy function arg/return value to trace specification. */
+		memcpy(trace->traces, func->args, sizeof(trace->traces));
+		for (i = 0; i < MAX_TRACES; i++)
+			trace->traces[i].base_arg = i;
+		trace->nr_traces = MAX_TRACES;
+	}
+
+	return 0;
+}
+
+int parse_traces(int argc, char **argv, struct trace **traces)
+{
+	__u8 i;
+
+	if (argc == 0)
+		usage();
+
+	if (argc > MAX_FUNC_TRACES) {
+		p_err("A maximum of %d traces are supported", MAX_FUNC_TRACES);
+		return -EINVAL;
+	}
+	*traces = calloc(argc, sizeof(struct trace));
+	if (!*traces) {
+		p_err("Could not allocate %d traces", argc);
+		return -ENOMEM;
+	}
+	for (i = 0; i < argc; i++) {
+		if (parse_trace(argv[i], &((*traces)[i])))
+			return -EINVAL;
+	}
+	return i;
+}
+
+int cmd_info(int argc, char **argv)
+{
+	struct trace *traces;
+	char str[MAX_STR];
+	int nr_traces;
+	__u8 i, j;
+
+	nr_traces = parse_traces(argc, argv, &traces);
+	if (nr_traces < 0)
+		return nr_traces;
+
+	for (i = 0; i < nr_traces; i++) {
+		struct func *func = &traces[i].func;
+
+		printf("%s %s(",
+		       value_to_str(traces[i].btf, &func->args[KSNOOP_RETURN],
+				    str),
+		       func->name);
+		for (j = 0; j < func->nr_args; j++) {
+			if (j > 0)
+				printf(", ");
+			printf("%s", value_to_str(traces[i].btf, &func->args[j],
+						  str));
+		}
+		if (func->nr_args > MAX_ARGS)
+			printf(" /* and %d more args that are not traceable */",
+			       func->nr_args - MAX_ARGS);
+		printf(");\n");
+	}
+	return 0;
+}
+
+char __indent[] = "                                                  ";
+
+#define indent(level)	(&__indent[strlen(__indent)-level])
+
+void print_indented(int level, char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	printf("%s", indent(level));
+	vprintf(fmt, ap);
+	va_end(ap);
+}
+
+void print_indented_str(int level, char *str)
+{
+	char *curr = str, *newline;
+	char line[MAX_STR];
+	bool first = true;
+
+	while ((newline = strchr(curr, '\n')) != NULL) {
+		strncpy(line, curr, newline - curr + 1);
+		line[newline-curr] = '\0';
+		if (first) {
+			printf("%s\n", line);
+			first = false;
+		} else
+			print_indented(level, "%s\n", line);
+		curr = newline + 1;
+	}
+}
+
+#define NANOSEC		1000000000
+
+#define BASE_INDENT	48
+
+void trace_handler(void *ctx, int cpu, void *data, __u32 size)
+{
+	struct trace *trace = data;
+	int i, shown, level;
+
+	if (size < (sizeof(*trace) - MAX_TRACE_BUF)) {
+		fprintf(stderr, "\t/* trace buffer size '%u' < min %ld */\n",
+			size, sizeof(trace) - MAX_TRACE_BUF);
+		return;
+	}
+	/* timestamps reported in seconds/milliseconds since boot */
+	printf("%20s %6u %4d %6llu.%6llu %s(\n", trace->comm, trace->pid,
+	       trace->cpu, trace->time / NANOSEC,
+	       (trace->time % NANOSEC)/1000, trace->func.name);
+	level = BASE_INDENT;
+
+	/* special cases; function with (void) argument or void return value. */
+	for (i = 0, shown = 0; i < trace->nr_traces; i++) {
+		bool entry = trace->data_flags & KSNOOP_F_ENTRY;
+		bool stash = trace->flags & KSNOOP_F_STASH;
+
+		if (!stash &&
+		    ((entry && !base_arg_is_entry(trace->traces[i].base_arg)) ||
+		     (!entry && base_arg_is_entry(trace->traces[i].base_arg))))
+			continue;
+
+		if (trace->traces[i].type_id == 0)
+			continue;
+
+		if (shown > 0)
+			print_indented(level, ",\n\n");
+		print_indented(level, "%s = ",
+			       trace->traces[i].name);
+
+		if (trace->trace_data[i].err_type_id != 0) {
+			char typestr[MAX_STR];
+
+			printf("0x%llx\n", trace->trace_data[i].raw_value);
+			print_indented(level,
+				       "/* Cannot show '%s' as '%s%s'.\n",
+				       trace->traces[i].name,
+				       type_id_to_str(trace->btf,
+						      trace->traces[i].type_id,
+						      typestr),
+				       trace->traces[i].flags & KSNOOP_F_PTR ?
+				       " *" : "");
+			print_indented(level, " * Userspace/invalid ptr? */\n",
+				       trace->traces[i].name);
+		} else {
+			if (trace->traces[i].flags & KSNOOP_F_PTR)
+				printf("*");
+			print_indented_str(level, trace->buf +
+					   trace->trace_data[i].buf_offset);
+			/* truncated? */
+			if (trace->trace_data[i].buf_len == MAX_TRACE_DATA)
+				print_indented(level, " ...\n");
+		}
+		shown++;
+	}
+	if (shown == 0)
+		print_indented(level, "%s",
+			       trace->data_flags & KSNOOP_F_ENTRY ?
+			       "void" : "return;");
+	printf("\n");
+	print_indented(level-1, ");\n\n");
+}
+
+void lost_handler(void *ctx, int cpu, __u64 cnt)
+{
+	fprintf(stderr, "\t/* lost %llu events */\n", cnt);
+}
+
+int add_traces(struct bpf_map *func_map, struct trace *traces, int nr_traces)
+{
+	int i, j, ret, nr_cpus = libbpf_num_possible_cpus();
+	struct trace *map_traces;
+
+	map_traces = calloc(nr_cpus, sizeof(struct trace));
+	if (!map_traces) {
+		p_err("Could not allocate memory for %d traces", nr_traces);
+		return -ENOMEM;
+	}
+	for (i = 0; i < nr_traces; i++) {
+		for (j = 0; j < nr_cpus; j++)
+			memcpy(&map_traces[j], &traces[i],
+			       sizeof(map_traces[j]));
+
+		ret = bpf_map_update_elem(bpf_map__fd(func_map),
+					  &traces[i].func.ip,
+					  map_traces,
+					  BPF_NOEXIST);
+		if (ret) {
+			p_err("Could not add map entry for '%s': %s",
+			      traces[i].func.name, strerror(-ret));
+			return ret;
+		}
+	}
+	return 0;
+}
+
+int attach_traces(struct ksnoop_bpf *skel, struct trace *traces, int nr_traces)
+{
+	struct bpf_object *obj = skel->obj;
+	struct bpf_program *prog;
+	struct bpf_link *link;
+	int i, ret;
+
+	for (i = 0; i < nr_traces; i++) {
+		bpf_object__for_each_program(prog, obj) {
+			const char *sec_name = bpf_program__section_name(prog);
+			bool kretprobe = strstr(sec_name, "kretprobe/") != NULL;
+
+			link = bpf_program__attach_kprobe(prog, kretprobe,
+							  traces[i].func.name);
+			ret = libbpf_get_error(link);
+			if (ret) {
+				p_err("Could not attach %s to '%s': %s",
+				      kretprobe ? "kretprobe" : "kprobe",
+				      traces[i].func.name,
+				      strerror(-ret));
+				return ret;
+			}
+			p_debug("Attached %s for '%s'",
+				kretprobe ? "kretprobe" : "kprobe",
+				traces[i].func.name);
+		}
+	}
+	return 0;
+}
+
+int cmd_trace(int argc, char **argv)
+{
+	struct perf_buffer_opts pb_opts = {};
+	struct bpf_map *perf_map, *func_map;
+	struct perf_buffer *pb;
+	struct ksnoop_bpf *skel;
+	struct trace *traces;
+	int nr_traces, ret;
+
+	nr_traces = parse_traces(argc, argv, &traces);
+	if (nr_traces < 0)
+		return nr_traces;
+
+	skel = ksnoop_bpf__open_and_load();
+	if (!skel)
+		return 1;
+
+	perf_map = bpf_object__find_map_by_name(skel->obj, "ksnoop_perf_map");
+	if (!perf_map) {
+		p_err("Could not find '%s'", "ksnoop_perf_map");
+		return 1;
+	}
+	func_map = bpf_object__find_map_by_name(skel->obj, "ksnoop_func_map");
+	if (!func_map) {
+		p_err("Could not find '%s'", "ksnoop_func_map");
+		return 1;
+	}
+
+	if (add_traces(func_map, traces, nr_traces)) {
+		p_err("Could not add traces to '%s'", "ksnoop_func_map");
+		return 1;
+	}
+
+	if (attach_traces(skel, traces, nr_traces)) {
+		p_err("Could not attach %d traces", nr_traces);
+		return 1;
+	}
+
+	pb_opts.sample_cb = trace_handler;
+	pb_opts.lost_cb = lost_handler;
+	pb = perf_buffer__new(bpf_map__fd(perf_map), 8, &pb_opts);
+	if (libbpf_get_error(pb)) {
+		p_err("Could not create perf buffer: %s",
+		      strerror(-libbpf_get_error(pb)));
+		return 1;
+	}
+
+	printf("%20s %6s %4s %13s %s\n",
+	       "TASK", "PID", "CPU#", "TIMESTAMP", "FUNCTION");
+
+	while (1) {
+		ret = perf_buffer__poll(pb, 1);
+		if (ret < 0 && ret != -EINTR) {
+			p_err("Polling failed: %s", strerror(ret));
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+struct cmd {
+	const char *cmd;
+	int (*func)(int argc, char **argv);
+};
+
+struct cmd cmds[] = {
+	{ "info",	cmd_info },
+	{ "trace",	cmd_trace },
+	{ "help",	cmd_help },
+	{ NULL,		NULL }
+};
+
+int cmd_select(int argc, char **argv)
+{
+	int i;
+
+	for (i = 0; cmds[i].cmd; i++) {
+		if (strncmp(*argv, cmds[i].cmd, strlen(*argv)) == 0)
+			return cmds[i].func(argc - 1, argv + 1);
+	}
+	return cmd_trace(argc, argv);
+}
+
+int print_all_levels(enum libbpf_print_level level,
+		 const char *format, va_list args)
+{
+	return vfprintf(stderr, format, args);
+}
+
+int main(int argc, char *argv[])
+{
+	static const struct option options[] = {
+		{ "debug",	no_argument,	NULL,	'd' },
+		{ "version",	no_argument,	NULL,	'V' },
+		{ "pages",	required_argument, NULL, 'p' },
+		{ 0 }
+	};
+	int opt;
+
+	bin_name = argv[0];
+
+	vmlinux_btf = get_btf(NULL);
+	if (libbpf_get_error(vmlinux_btf))
+		return 1;
+
+	while ((opt = getopt_long(argc, argv, "dpV", options, NULL)) >= 0) {
+		switch (opt) {
+		case 'd':
+			libbpf_set_print(print_all_levels);
+			log_level = DEBUG;
+			break;
+		case 'p':
+			pages = atoi(optarg);
+			break;
+		case 'V':
+			return do_version(argc, argv);
+		default:
+			p_err("unrecognized option '%s'", argv[optind - 1]);
+			usage();
+		}
+	}
+	if (argc == 1)
+		usage();
+	argc -= optind;
+	argv += optind;
+	if (argc < 0)
+		usage();
+
+	return cmd_select(argc, argv);
+
+	return 0;
+}
diff --git a/tools/bpf/ksnoop/ksnoop.h b/tools/bpf/ksnoop/ksnoop.h
new file mode 100644
index 0000000..e415a85
--- /dev/null
+++ b/tools/bpf/ksnoop/ksnoop.h
@@ -0,0 +1,110 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#define MAX_FUNC_TRACES			8
+
+enum arg {
+	KSNOOP_ARG1,
+	KSNOOP_ARG2,
+	KSNOOP_ARG3,
+	KSNOOP_ARG4,
+	KSNOOP_ARG5,
+	KSNOOP_RETURN
+};
+
+/* we choose "return" as the name for the returned value because as
+ * a C keyword it can't clash with a function entry parameter.
+ */
+#define KSNOOP_RETURN_NAME		"return"
+
+/* if we can't get a type id for a type (such as module-specific type)
+ * mark it as KSNOOP_ID_UNKNOWN since BTF lookup in bpf_snprintf_btf()
+ * will fail and the data will be simply displayed as a __u64.
+ */
+#define KSNOOP_ID_UNKNOWN		0xffffffff
+
+#define MAX_STR				256
+#define MAX_VALUES			6
+#define MAX_ARGS			(MAX_VALUES - 1)
+#define KSNOOP_F_PTR			0x1	/* value is a pointer */
+#define KSNOOP_F_MEMBER			0x2	/* member reference */
+#define KSNOOP_F_ENTRY			0x4
+#define KSNOOP_F_RETURN			0x8
+#define KSNOOP_F_CUSTOM			0x10	/* custom trace */
+
+#define KSNOOP_F_STASH			0x20	/* store values on entry, don't
+						 * send perf event
+						 */
+#define KSNOOP_F_STASHED		0x40	/* values stored on entry */
+
+#define KSNOOP_F_PREDICATE_EQ		0x100
+#define KSNOOP_F_PREDICATE_NOTEQ	0x200
+#define KSNOOP_F_PREDICATE_GT		0x400
+#define KSNOOP_F_PREDICATE_LT		0x800
+
+#define KSNOOP_F_PREDICATE_MASK		(KSNOOP_F_PREDICATE_EQ | \
+					 KSNOOP_F_PREDICATE_NOTEQ | \
+					 KSNOOP_F_PREDICATE_GT | \
+					 KSNOOP_F_PREDICATE_LT)
+
+/* for kprobes, entry is function IP + 1, subtract 1 in BPF prog context */
+#define KSNOOP_IP_FIX(ip)		(ip - 1)
+
+struct value {
+	char name[MAX_STR];
+	enum arg base_arg;
+	__u32 size;
+	__u32 offset;
+	__u64 type_id;
+	__u64 flags;
+	__u64 predicate_value;
+};
+
+struct func {
+	char name[MAX_STR];
+	char mod[MAX_STR];
+	__u8 nr_args;
+	__u64 ip;
+	struct value args[MAX_VALUES];
+};
+
+#define MAX_TRACES MAX_VALUES
+
+#define MAX_TRACE_DATA	2048
+
+struct trace_data {
+	__u64 raw_value;
+	__u32 err_type_id;	/* type id we can't dereference */
+	int err;
+	__u32 buf_offset;
+	__u16 buf_len;
+};
+
+#define MAX_TRACE_BUF	(MAX_TRACES * MAX_TRACE_DATA)
+
+struct trace {
+	/* initial values are readonly in tracing context */
+	struct btf *btf;
+	struct func func;
+	__u8 nr_traces;
+	struct value traces[MAX_TRACES];
+	__u64 flags;
+	/* ...whereas values below this point are set or modified
+	 * in tracing context
+	 */
+	__u64 time;
+	__u32 cpu;
+	__u32 pid;
+	char comm[MAX_STR];
+	__u64 data_flags;
+	struct trace_data trace_data[MAX_TRACES];
+	__u16 buf_len;
+	char buf[MAX_TRACE_BUF];
+};
+
+#define PAGES_DEFAULT	8
+
+static inline int base_arg_is_entry(enum arg base_arg)
+{
+	return base_arg != KSNOOP_RETURN;
+}
-- 
1.8.3.1

