Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A27AC98E
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 23:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393348AbfIGVpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 17:45:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50262 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfIGVpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 17:45:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87LeE5L149705;
        Sat, 7 Sep 2019 21:43:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=Yg9cpxG+Ki4VfUNDGe1n8LblQVG55hD3Pb6/O7egcyk=;
 b=KfzIO/puzwhY3NozCEu/Q1uTlWUSOPEHzZre4VvjpCiQIzuPcO8a0J8mbr6vBY2u0iTU
 RuqUIQoqubkH3ikGe+QXjROlXT8LjE6uUIXqgGCpL6k5dR2AGMYu1JhSqNwePB6zos5D
 rlg3mdwYshMPHbyPjoT1W2Vcas5qUNYAfN2J0LIhfo1QcSSi9IJScDki4/+chCUoGkIA
 21dOjWQsKJqAFRRsEQQc1f/Fum+T9FMyv3zvqrIxkW7I7qMVlfhDILFMBakvonsJsoBQ
 Iav3v189roXcptvJSz2cuNp/VL5ktBE2i6mRk9CyS08E0jKl9fJi0qw/ASxOrqglk7Yn DA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uvmet812s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:43:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87LccVO035556;
        Sat, 7 Sep 2019 21:42:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2uv3wjnmxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:42:34 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x87LgVCk031143;
        Sat, 7 Sep 2019 21:42:31 GMT
Received: from dhcp-10-175-169-153.vpn.oracle.com (/10.175.169.153)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 14:42:30 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, rostedt@goodmis.org, mingo@redhat.com,
        quentin.monnet@netronome.com, rdna@fb.com, joe@wand.net.nz,
        acme@redhat.com, jolsa@kernel.org, alexey.budankov@linux.intel.com,
        gregkh@linuxfoundation.org, namhyung@kernel.org, sdf@google.com,
        f.fainelli@gmail.com, shuah@kernel.org, peter@lekensteyn.nl,
        ivan@cloudflare.com, andriin@fb.com,
        bhole_prashant_q7@lab.ntt.co.jp, david.calavera@gmail.com,
        danieltimlee@gmail.com, ctakshak@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 5/7] bpf: add pcap support to bpftool
Date:   Sat,  7 Sep 2019 22:40:42 +0100
Message-Id: <1567892444-16344-6-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
References: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=11 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070235
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=11 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070235
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpftool is enhanced to be able to both capture from existing skb/xdp
programs ("bpftool pcap prog") and to load tracing programs - including
built-in simple kprobe/raw_tracepoint programs.  The end result is
to have a way of dynamically tapping BPF programs, kernel functions
and tracepoints to capture packet data.

"bpftool pcap" support depends on libpcap library and headers presence,
hence the new feature test is used to check for these.

If present, "bpftool pcap" can be used to capture pcap perf event
data from the perf event map associated with a program.  For example,

$ bpftool pcap prog id 32 data_out /tmp/cap

...will capture perf event data from the BPF program with id 32,
storing it in the capture file /tmp/pcap.

bpftool looks for a perf event map associated with that program and
then captures packets from it in a loop until Ctrl^C is pressed.
By default stdout is used, so the following also works:

$ bpftool pcap prog id 32 | tcpdump -r -

Configuration can also be passed to pcap programs, provided they
define a single-element BPF_MAP_TYPE_ARRAY with value size
greater than "sizeof struct bpf_pcap_hdr".  Options include

 data_out FILE  packet capture file to use (stdout is default)
 proto PROTO    DLT_* type as per libpcap; by specifying a type
                BPF programs can query the map in-kernel and
                capture packets of that type.  A string
                or numeric value can be used.  It is set in the
                bpf_pcap_hdr associated with the configuration
                map as the "protocol" value.
 len MAXLEN     maximum capture length in bytes.  It is set in
                the bpf_pcap_hdr associated with the configuration
                map as the "cap_len" value.
 dev DEVICE     incoming interface.  Tracing will be restricted
                to skbs which have this incoming interface set.
                The flags associated with the bpf_pcap_hdr
                in the configuration map are adjusted to record
                the associated ifindex to limit tracing.

In addition to capturing from existing programs, it is possible
to load provided programs which trace kprobe entry and raw_tracepoints,
making the first four arguments of each available for tracing.
For example

$ bpftool pcap trace kprobe/ip_rcv proto ip | tcpdump -r -

...will load a provided kprobe program, set the configuration options
in its associated map and capture packets which the bpf_pcap()
helper identifies as of type IPv[4,6].  Similarly for tracepoints,

$ bpftool pcap trace tracepoint:net_dev_xmit:arg1 proto eth | tcpdump -r -

In this case we explicitly specify an argument (:arg1), but the
default assumption is the first argument is to be captured.

To achieve the built-in tracing capabilities, two BPF objects need
to be delivered with bpftool - bpftool_pcap_kprobe.o and
bpftool_pcap_tracepoint.o.  These are accordingly added to the
install target for bpftool.  Each contains a separate program for
extracting arg1, arg2, arg3 and arg4.  This may seem wasteful -
why not just have the arg number as a map parameter?  In practice
tracepoints fail to attach with that approach.

A question arises here.  First, if we deliver a kprobe program, won't
it only work for the specific kernel?  Just by dumb luck on my part
the program appears to dodge the kernel version check in libbpf by not
passing an explicit program type at load time.  That said, the
program does not reference any data structures outside of the context
provided (struct pt_regs *), so maybe there's something else going
on too?

Note that a user-defined tracing program can also be passed in,
and that program will be attached to the target probe in a similar
manner.  We first look for programs with "arg[1-4]" in the name
if an argnum is specified, otherwise we fall back to using the
first program.

$ bpftool pcap trace mytraceprog.o tracepoint:net_dev_xmit:arg1 \
	data_out /tmp/cap

bpftool looks for a BPF_MAP_TYPE_ARRAY containing one value of
size >= "struct bpf_pcap_hdr", and assumes that configuration
provided to the program should be set in that map.  This allows
the user to provide a maximum packet length, starting protocol
etc to tracing programs.

The idea behind providing packet capture/tracing functionality in
bpftool is to similify developer access to dynamic packet capture.
An alternative approach would be to provide libbpf interfaces, but
this would require linking libbpf with libpcap.

A possible approach would be to take the code from bpftool that
interacts with programs (to retrieve pcap-related maps and
set config) and move it to libbpf, but it may make sense to
start with the functionality in bpftool and see if other
consumers need/want it.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/bpf/bpftool/Makefile                        |  39 +-
 tools/bpf/bpftool/main.c                          |   3 +-
 tools/bpf/bpftool/main.h                          |   1 +
 tools/bpf/bpftool/pcap.c                          | 496 ++++++++++++++++++++++
 tools/bpf/bpftool/progs/bpftool_pcap_kprobe.c     |  80 ++++
 tools/bpf/bpftool/progs/bpftool_pcap_tracepoint.c |  68 +++
 tools/testing/selftests/bpf/bpf_helpers.h         |  11 +
 7 files changed, 690 insertions(+), 8 deletions(-)
 create mode 100644 tools/bpf/bpftool/pcap.c
 create mode 100644 tools/bpf/bpftool/progs/bpftool_pcap_kprobe.c
 create mode 100644 tools/bpf/bpftool/progs/bpftool_pcap_tracepoint.c

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 39bc6f0..16c4104 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 include ../../scripts/Makefile.include
+include ../../scripts/Makefile.arch
 include ../../scripts/utilities.mak
 
 ifeq ($(srctree),)
@@ -61,8 +62,8 @@ INSTALL ?= install
 RM ?= rm -f
 
 FEATURE_USER = .bpftool
-FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
-FEATURE_DISPLAY = libbfd disassembler-four-args zlib
+FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib libpcap
+FEATURE_DISPLAY = libbfd disassembler-four-args zlib libpcap
 
 check_feat := 1
 NON_CHECK_FEAT_TARGETS := clean uninstall doc doc-clean doc-install doc-uninstall
@@ -90,7 +91,14 @@ endif
 
 include $(wildcard $(OUTPUT)*.d)
 
-all: $(OUTPUT)bpftool
+ifeq ($(feature-libpcap),1)
+  LIBS += -lpcap
+  CFLAGS += -DHAVE_LIBPCAP_SUPPORT
+  BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
+  BPF_SRCS = $(wildcard progs/*.c)
+endif
+
+all: $(OUTPUT)bpftool $(OUTPUT)$(BPF_OBJ_FILES)
 
 BFD_SRCS = jit_disasm.c
 
@@ -109,6 +117,18 @@ CFLAGS += -DHAVE_LIBBFD_SUPPORT
 SRCS += $(BFD_SRCS)
 endif
 
+CLANG           ?= clang
+LLC             ?= llc
+
+CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
+
+CLANG_FLAGS = -I. -I$(srctree)/tools/include/uapi \
+	      -I$(srctree)/tools/testing/selftests/bpf \
+	      $(CLANG_SYS_INCLUDES) \
+	      -Wno-compare-distinct-pointer-types \
+	      -D__TARGET_ARCH_$(SRCARCH)
+
 OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
 
 $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
@@ -122,24 +142,29 @@ $(OUTPUT)bpftool: $(OBJS) $(LIBBPF)
 $(OUTPUT)%.o: %.c
 	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
 
+$(OUTPUT)$(BPF_OBJ_FILES): $(BPF_SRCS)
+	($(CLANG) $(CLANG_FLAGS) -O2 -target bpf -emit-llvm \
+		-c $(patsubst %.o,progs/%.c,$@) -o - || echo "clang failed") | \
+	$(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
+
 clean: $(LIBBPF)-clean
 	$(call QUIET_CLEAN, bpftool)
-	$(Q)$(RM) -- $(OUTPUT)bpftool $(OUTPUT)*.o $(OUTPUT)*.d
+	$(Q)$(RM) -- $(OUTPUT)bpftool $(OUTPUT)*.o $(OUTPUT)*.d $(OUTPUT)$(BPF_OBJ_FILES)
 	$(Q)$(RM) -r -- $(OUTPUT)libbpf/
 	$(call QUIET_CLEAN, core-gen)
 	$(Q)$(RM) -- $(OUTPUT)FEATURE-DUMP.bpftool
 	$(Q)$(RM) -r -- $(OUTPUT)feature/
 
-install: $(OUTPUT)bpftool
+install: $(OUTPUT)bpftool $(OUTPUT)$(BPF_OBJ_FILES)
 	$(call QUIET_INSTALL, bpftool)
 	$(Q)$(INSTALL) -m 0755 -d $(DESTDIR)$(prefix)/sbin
-	$(Q)$(INSTALL) $(OUTPUT)bpftool $(DESTDIR)$(prefix)/sbin/bpftool
+	$(Q)$(INSTALL) $(OUTPUT)bpftool $(OUTPUT)$(BPF_OBJ_FILES) $(DESTDIR)$(prefix)/sbin/
 	$(Q)$(INSTALL) -m 0755 -d $(DESTDIR)$(bash_compdir)
 	$(Q)$(INSTALL) -m 0644 bash-completion/bpftool $(DESTDIR)$(bash_compdir)
 
 uninstall:
 	$(call QUIET_UNINST, bpftool)
-	$(Q)$(RM) -- $(DESTDIR)$(prefix)/sbin/bpftool
+	$(Q)$(RM) -- $(DESTDIR)$(prefix)/sbin/bpftool*
 	$(Q)$(RM) -- $(DESTDIR)$(bash_compdir)/bpftool
 
 doc:
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 93d0086..e7c7969 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -58,7 +58,7 @@ static int do_help(int argc, char **argv)
 		"       %s batch file FILE\n"
 		"       %s version\n"
 		"\n"
-		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf }\n"
+		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf | pcap }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
 		bin_name, bin_name, bin_name);
@@ -227,6 +227,7 @@ static int make_args(char *line, char *n_argv[], int maxargs, int cmd_nb)
 	{ "net",	do_net },
 	{ "feature",	do_feature },
 	{ "btf",	do_btf },
+	{ "pcap",	do_pcap },
 	{ "version",	do_version },
 	{ 0 }
 };
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index af9ad56..079409c 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -155,6 +155,7 @@ int cmd_select(const struct cmd *cmds, int argc, char **argv,
 int do_tracelog(int argc, char **arg);
 int do_feature(int argc, char **argv);
 int do_btf(int argc, char **argv);
+int do_pcap(int argc, char **argv);
 
 int parse_u32_arg(int *argc, char ***argv, __u32 *val, const char *what);
 int prog_parse_fd(int *argc, char ***argv);
diff --git a/tools/bpf/bpftool/pcap.c b/tools/bpf/bpftool/pcap.c
new file mode 100644
index 0000000..ab18d1f
--- /dev/null
+++ b/tools/bpf/bpftool/pcap.c
@@ -0,0 +1,496 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved. */
+
+#include <assert.h>
+#include <bpf.h>
+#include <errno.h>
+#include <libbpf.h>
+#include <libgen.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/perf_event.h>
+#include <linux/sysinfo.h>
+#include <net/if.h>
+#include <signal.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/resource.h>
+#include <sys/sysinfo.h>
+#include <time.h>
+
+#include "json_writer.h"
+#include "main.h"
+
+#ifdef HAVE_LIBPCAP_SUPPORT
+
+/* To avoid conflicting definitions of bpf_insn */
+#define PCAP_DONT_INCLUDE_PCAP_BPF_H
+#include <pcap.h>
+
+#include <perf-sys.h>
+
+#define	PCAP_MAX_MAPS	8
+#define	PCAP_PROTOCOL_DEFAULT	BPF_PCAP_TYPE_ETH
+#define PCAP_NUM_PAGES_DEFAULT	16
+#define PCAP_NUM_PAGES_MIN	8
+#define PCAP_MAX_LEN		65536
+#define	PCAP_FILE_STDOUT	"-"
+#define	PCAP_FILE_DEFAULT	PCAP_FILE_STDOUT
+#define NANOSEC			1000000000
+
+
+pcap_dumper_t *pcap_dumper;
+static bool flush = true;
+volatile bool stop;
+
+static __u64 boottime;		/* seconds since epoch at boot time. */
+
+static unsigned int proto_from_str(const char *proto_str)
+{
+	int proto;
+
+	/* Names for DLT_ ethernet (en10mb) and IP (raw) aren't obvious. */
+	if (strcmp(proto_str, "eth") == 0)
+		proto = BPF_PCAP_TYPE_ETH;
+	else if (strcmp(proto_str, "ip") == 0)
+		proto = BPF_PCAP_TYPE_IP;
+	else {
+		proto = pcap_datalink_name_to_val(proto_str);
+		if (proto == PCAP_ERROR) {
+			proto = strtol(proto_str, NULL, 10);
+			if (errno == ERANGE)
+				proto = -1;
+		}
+	}
+	return proto;
+}
+
+static int verify_map(int map_fd, enum bpf_map_type map_type,
+		      __u32 num_entries, __u32 min_value_size)
+{
+	__u32 info_len = sizeof(struct bpf_map_info);
+	struct bpf_map_info info;
+
+	if (!bpf_obj_get_info_by_fd(map_fd, &info, &info_len) &&
+	    info.type == map_type &&
+	    (!num_entries || info.max_entries == num_entries) &&
+	    (!min_value_size || info.value_size >= min_value_size))
+		return 0;
+	return -1;
+}
+
+static void int_exit(int signo)
+{
+	stop = true;
+}
+
+static void handle_pcap_event(void *ctx, int cpu, void *data, __u32 size)
+{
+	struct bpf_pcap_hdr *conf = ctx;
+	struct bpf_pcap_hdr *hdr = data;
+	struct pcap_pkthdr caphdr;
+
+	if (hdr->magic != BPF_PCAP_MAGIC)
+		return;
+
+	/* If we are looking for a specific protocol, and this isn't a
+	 * match, ignore.
+	 */
+	if (conf->protocol != BPF_PCAP_TYPE_UNSET &&
+	    conf->protocol != hdr->protocol)
+		return;
+
+	caphdr.len = hdr->tot_len;
+	caphdr.caplen = hdr->cap_len;
+	caphdr.ts.tv_sec = boottime + (hdr->ktime_ns/NANOSEC);
+	caphdr.ts.tv_usec = (hdr->ktime_ns % NANOSEC) / 1000;
+
+	pcap_dump((u_char *)pcap_dumper, &caphdr, hdr->data);
+	if (flush)
+		pcap_dump_flush(pcap_dumper);
+}
+
+static int handle_pcap(int data_map_fd, int conf_map_fd,
+		       struct bpf_pcap_hdr *conf, const char *pcap_filename,
+		       int pages, struct bpf_link *trace_link)
+{
+	struct perf_buffer_opts pb_opts = {};
+	struct perf_buffer *pb;
+	struct sysinfo info;
+	pcap_t *pcap;
+	int err;
+
+	if (signal(SIGHUP, int_exit) ||
+	    signal(SIGTERM, int_exit)) {
+		perror("signal");
+		return 1;
+	}
+	(void) signal(SIGINT, int_exit);
+
+	/* pcap expects time since epoch and bpf_pcap() records nanoseconds
+	 * since boot; get time of boot to add to pcap time to give a (rough)
+	 * time since epoch for capture event.
+	 */
+	if (sysinfo(&info) == 0)
+		boottime = time(NULL) - info.uptime;
+
+	pcap = pcap_open_dead(conf->protocol, conf->cap_len ?
+					      conf->cap_len : PCAP_MAX_LEN);
+	if (!pcap) {
+		perror("pcap_open");
+		return -1;
+	}
+	pcap_dumper = pcap_dump_open(pcap, pcap_filename);
+	if (!pcap_dumper) {
+		perror("pcap_dumper");
+		return -1;
+	}
+
+	pb_opts.sample_cb = handle_pcap_event;
+	pb_opts.ctx = conf;
+	pb = perf_buffer__new(data_map_fd, pages, &pb_opts);
+	if (libbpf_get_error(pb)) {
+		perror("perf_buffer setup failed");
+		return -1;
+	}
+
+	while (!stop) {
+		err = perf_buffer__poll(pb, 1000);
+		if (err < 0 && err != -EINTR) {
+			p_err("perf buffer polling failed: %s (%d)",
+			      strerror(err), err);
+			break;
+		}
+	}
+
+	/* detach program if we attached one. */
+	if (trace_link)
+		bpf_link__destroy(trace_link);
+	perf_buffer__free(pb);
+	close(data_map_fd);
+	if (conf_map_fd >= 0)
+		close(conf_map_fd);
+	if (pcap_dumper) {
+		pcap_dump_flush(pcap_dumper);
+		pcap_dump_close(pcap_dumper);
+	}
+	if (pcap)
+		pcap_close(pcap);
+
+	return 0;
+}
+
+static int handle_opts(int argc, char **argv,
+		       struct bpf_pcap_hdr *conf,
+		       const char **pcap_filename, int *pages)
+{
+	int conf_used = 0;
+
+	while (argc) {
+		if (!REQ_ARGS(2))
+			return -1;
+
+		if (is_prefix(*argv, "data_out")) {
+			NEXT_ARG();
+			*pcap_filename = *argv;
+			/* no need to flush to capture file if not stdout */
+			if (strcmp(*pcap_filename, PCAP_FILE_STDOUT) != 0)
+				flush = false;
+			NEXT_ARG();
+		} else if (is_prefix(*argv, "proto")) {
+			NEXT_ARG();
+			conf->protocol = proto_from_str(*argv);
+			if (conf->protocol == -1) {
+				p_err("unrecognized protocol %s", *argv);
+				return -1;
+			}
+			conf_used = 1;
+			NEXT_ARG();
+		} else if (is_prefix(*argv, "len")) {
+			NEXT_ARG();
+			conf->cap_len = atoi(*argv);
+			conf_used = 1;
+			NEXT_ARG();
+		} else if (is_prefix(*argv, "dev")) {
+			unsigned long iifindex;
+
+			NEXT_ARG();
+			iifindex = if_nametoindex(*argv);
+			if (!iifindex) {
+				p_err("no such device %s", *argv);
+				return -1;
+			}
+			conf->flags |= (BPF_F_PCAP_ID_IIFINDEX |
+					(iifindex & BPF_F_PCAP_ID_MASK));
+			conf_used = 1;
+			NEXT_ARG();
+		} else if (is_prefix(*argv, "pages")) {
+			NEXT_ARG();
+			*pages = atoi(*argv);
+			if (*pages < PCAP_NUM_PAGES_MIN) {
+				p_err("at least %d pages are required",
+				      PCAP_NUM_PAGES_MIN);
+				return -1;
+			}
+			NEXT_ARG();
+		} else {
+			p_err("unknown arg %s", *argv);
+			return -1;
+		}
+	}
+	return conf_used;
+}
+
+static int handle_conf_map(int conf_map_fd, struct bpf_pcap_hdr *conf)
+{
+	int key = 0;
+
+	if (bpf_map_update_elem(conf_map_fd, &key, conf, BPF_ANY)) {
+		p_err("could not populate config in map");
+		return -1;
+	}
+	return 0;
+}
+
+/* For the prog specified, the conf map is optional but the data map must
+ * be present to facilitate capture.
+ */
+static int prog_info(int prog_fd, enum bpf_prog_type *type,
+		     int *data_map_fd, int *conf_map_fd)
+{
+	__u32 info_len = sizeof(struct bpf_prog_info);
+	struct bpf_prog_info prog_info;
+	__u32 map_ids[PCAP_MAX_MAPS];
+	int map_fd;
+	__u32 i;
+
+	*data_map_fd = -1;
+	*conf_map_fd = -1;
+
+	/* Find data and (optionally) conf map associated with program. */
+	memset(&prog_info, 0, sizeof(prog_info));
+	prog_info.nr_map_ids = PCAP_MAX_MAPS;
+	prog_info.map_ids =  ptr_to_u64(map_ids);
+	if (bpf_obj_get_info_by_fd(prog_fd, &prog_info, &info_len) < 0) {
+		p_err("could not retrieve info for program");
+		return -1;
+	}
+	*type = prog_info.type;
+
+	for (i = 0; i < prog_info.nr_map_ids; i++) {
+		map_fd = bpf_map_get_fd_by_id(map_ids[i]);
+
+		if (!verify_map(map_fd,
+				BPF_MAP_TYPE_PERF_EVENT_ARRAY, 0, 0)) {
+			*data_map_fd = map_fd;
+			continue;
+		}
+		if (!verify_map(map_fd,
+				BPF_MAP_TYPE_ARRAY, 1,
+				sizeof(struct bpf_pcap_hdr)))
+			*conf_map_fd = map_fd;
+	}
+
+	/* For the prog specified, the conf map is optional but the data map
+	 * must be present to facilitate capture.
+	 */
+	if (*data_map_fd == -1) {
+		p_err("no perf event map associated with program");
+		return -1;
+	}
+	return 0;
+}
+
+static struct bpf_link *trace_attach(int prog_fd, enum bpf_prog_type prog_type,
+			struct bpf_program *prog, const char *trace)
+{
+	switch (prog_type) {
+	case BPF_PROG_TYPE_KPROBE:
+		return bpf_program__attach_kprobe(prog, false, trace);
+
+	case BPF_PROG_TYPE_RAW_TRACEPOINT:
+		return bpf_program__attach_raw_tracepoint(prog, trace);
+	default:
+		p_err("unexpected type; kprobes, raw tracepoints supported");
+		return NULL;
+	}
+}
+
+static int do_pcap_common(int argc, char **argv, int prog_fd,
+			  struct bpf_program *prog, char *trace)
+{
+	struct bpf_pcap_hdr conf = { .protocol = PCAP_PROTOCOL_DEFAULT,
+				     .cap_len = 0,
+				     .flags = 0 };
+	const char *pcap_filename = PCAP_FILE_DEFAULT;
+	int data_map_fd = -1, conf_map_fd = -1;
+	int pages = PCAP_NUM_PAGES_DEFAULT;
+	struct bpf_link *trace_link = NULL;
+	enum bpf_prog_type prog_type;
+	int conf_used;
+
+	if (prog_info(prog_fd, &prog_type, &data_map_fd, &conf_map_fd) < 0)
+		return -1;
+
+	conf_used = handle_opts(argc, argv, &conf, &pcap_filename, &pages);
+	switch (conf_used) {
+	case 0:
+		break;
+	case 1:
+		if (conf_map_fd < 0) {
+			p_err("no single-element BPF array map to store configuration found");
+			return -1;
+		}
+		break;
+	default:
+		return -1;
+	}
+
+	set_max_rlimit();
+
+	if (conf_map_fd >= 0 && handle_conf_map(conf_map_fd, &conf) < 0)
+		return -1;
+
+	if (trace && !prog) {
+		p_err("to specify trace option, '%s pcap load' must be used",
+		      bin_name);
+		return -1;
+	}
+	if (trace) {
+		trace_link = trace_attach(prog_fd, prog_type, prog, trace);
+		if (IS_ERR(trace_link))
+			return -1;
+	}
+
+	return handle_pcap(data_map_fd, conf_map_fd, &conf, pcap_filename,
+			   pages, trace_link);
+}
+
+static int do_pcap_trace(int argc, char **argv)
+{
+	char trace_prog[PATH_MAX], trace[PATH_MAX], trace_type[PATH_MAX];
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	int trace_argnum = 1;
+	char argstr[8];
+	int prog_fd;
+
+	if (!REQ_ARGS(1))
+		return -1;
+
+	trace_prog[0] = '\0';
+
+	/* Optional trace program; if not specified we load a builtin program
+	 * based on probe prefix (kprobe|tracepoint).
+	 */
+	if (strcmp(*argv + strlen(*argv) - 2, ".o") == 0) {
+		strncpy(trace_prog, *argv, sizeof(trace_prog));
+		if (!REQ_ARGS(2))
+			return -1;
+		NEXT_ARG();
+	}
+
+	if (sscanf(*argv, "%[^:]:%[^:]:arg%d", trace_type, trace, &trace_argnum)
+	    != 3 &&
+	    sscanf(*argv, "%[^:]:%[^:]", trace_type, trace) != 2) {
+		p_err("expected '[kprobe|tracepoint]:PROBENAME[:arg[1-4]]'");
+		return -1;
+	}
+	if (strcmp(trace_type, "kprobe") != 0 &&
+	    strcmp(trace_type, "tracepoint") != 0) {
+		p_err("invalid trace type %s, expected '[kprobe|tracepoint]:PROBENAME[:arg[1-4]]'",
+		      trace_type);
+		return -1;
+	}
+	if (trace_argnum < 1 || trace_argnum > 4) {
+		p_err("'arg%d' invalid, expected '[kprobe|tracepoint]:PROBENAME[:arg[1-4]]'",
+		      trace_argnum);
+		return -1;
+	}
+	NEXT_ARG();
+
+	if (strlen(trace_prog) == 0) {
+		char bin_path[PATH_MAX];
+
+		/* derive path of currently-executing command; BPF programs will
+		 * be in the same directory, with suffix based on trace type.
+		 */
+		if (readlink("/proc/self/exe", bin_path, sizeof(bin_path)) <= 0)
+			return -1;
+		snprintf(trace_prog, sizeof(trace_prog), "%s_pcap_%s.o",
+			 bin_path, trace_type);
+	}
+
+	if (bpf_prog_load(trace_prog, BPF_PROG_TYPE_UNSPEC, &obj, &prog_fd) < 0)
+		return -1;
+
+	snprintf(argstr, sizeof(argstr), "arg%d", trace_argnum);
+
+	bpf_object__for_each_program(prog, obj) {
+		if (strstr(bpf_program__title(prog, false), argstr))
+			break;
+	}
+	/* No argnum-specific program, fall back to first program. */
+	if (!prog)
+		prog = bpf_program__next(NULL, obj);
+	if (!prog) {
+		p_err("could not get program");
+		return -1;
+	}
+
+	return do_pcap_common(argc, argv, prog_fd, prog, trace);
+}
+
+static int do_pcap_prog(int argc, char **argv)
+{
+	int prog_fd;
+
+	prog_fd = prog_parse_fd(&argc, &argv);
+	if (prog_fd == -1)
+		return -1;
+
+	return do_pcap_common(argc, argv, prog_fd, NULL, NULL);
+}
+
+static int do_help(int argc, char **argv)
+{
+	if (json_output) {
+		jsonw_null(json_wtr);
+		return 0;
+	}
+	fprintf(stderr,
+		"        %s %s prog {id ID | pinned PATH }\n"
+		"              [data_out FILE] [proto PROTOCOL] [len MAXLEN]\n"
+		"              [pages NUMPAGES]\n"
+		"        %s %s trace [OBJ] {kprobe|tracepoint}:probename[:arg[1-4]]]\n"
+		"              [data_out FILE] [proto PROTOCOL] [len MAXLEN]\n"
+		"              [dev DEVICE] [pages NUMPAGES]\n"
+		"        %s %s help\n",
+		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
+
+	return 0;
+}
+
+static const struct cmd cmds[] = {
+	{ "prog",		do_pcap_prog },
+	{ "trace",		do_pcap_trace },
+	{ "help",		do_help },
+	{ 0 }
+};
+
+#endif /* HAVE_LIBPCAP_SUPPORT */
+
+int do_pcap(int argc, char **argv)
+{
+#ifdef HAVE_LIBPCAP_SUPPORT
+	return cmd_select(cmds, argc, argv, do_help);
+#else
+	p_err("pcap support was not compiled into bpftool as libpcap\n"
+	      "and associated headers were not available at build time.\n");
+	return -1;
+#endif /* HAVE_LIBPCAP_SUPPORT */
+}
diff --git a/tools/bpf/bpftool/progs/bpftool_pcap_kprobe.c b/tools/bpf/bpftool/progs/bpftool_pcap_kprobe.c
new file mode 100644
index 0000000..00a945d
--- /dev/null
+++ b/tools/bpf/bpftool/progs/bpftool_pcap_kprobe.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved. */
+
+#include <stddef.h>
+#include <linux/ptrace.h>
+#include <linux/bpf.h>
+
+#include <bpf_helpers.h>
+
+#define KBUILD_MODNAME "foo"
+
+struct bpf_map_def SEC("maps") pcap_data_map = {
+	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+	.key_size = sizeof(int),
+	.value_size = sizeof(int),
+	.max_entries = 1024,
+};
+
+struct bpf_map_def SEC("maps") pcap_conf_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(int),
+	.value_size = sizeof(struct bpf_pcap_hdr),
+	.max_entries = 1,
+};
+
+static __always_inline int kprobe_pcap(struct pt_regs *ctx, int argnum)
+{
+	struct bpf_pcap_hdr *conf;
+	int key = 0;
+
+	conf = bpf_map_lookup_elem(&pcap_conf_map, &key);
+	if (!conf)
+		return 0;
+
+	switch (argnum) {
+	case 1:
+		bpf_pcap((void *)PT_REGS_PARM1(ctx), conf->cap_len,
+			 &pcap_data_map, conf->protocol, conf->flags);
+		return 0;
+	case 2:
+		bpf_pcap((void *)PT_REGS_PARM2(ctx), conf->cap_len,
+			 &pcap_data_map, conf->protocol, conf->flags);
+		return 0;
+	case 3:
+		bpf_pcap((void *)PT_REGS_PARM3(ctx), conf->cap_len,
+			 &pcap_data_map, conf->protocol, conf->flags);
+		return 0;
+	case 4:
+		bpf_pcap((void *)PT_REGS_PARM4(ctx), conf->cap_len,
+			 &pcap_data_map, conf->protocol, conf->flags);
+		return 0;
+	}
+	return 0;
+}
+
+SEC("kprobe/pcap_arg1")
+int pcap_arg1(struct pt_regs *ctx)
+{
+	return kprobe_pcap(ctx, 1);
+}
+
+SEC("kprobe/pcap_arg2")
+int pcap_arg2(struct pt_regs *ctx)
+{
+	return kprobe_pcap(ctx, 2);
+}
+
+SEC("kprobe/pcap_arg3")
+int pcap_arg3(struct pt_regs *ctx)
+{
+	return kprobe_pcap(ctx, 3);
+}
+
+SEC("kprobe/pcap_arg4")
+int pcap_arg4(struct pt_regs *ctx)
+{
+	return kprobe_pcap(ctx, 4);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/bpf/bpftool/progs/bpftool_pcap_tracepoint.c b/tools/bpf/bpftool/progs/bpftool_pcap_tracepoint.c
new file mode 100644
index 0000000..639806a
--- /dev/null
+++ b/tools/bpf/bpftool/progs/bpftool_pcap_tracepoint.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved. */
+
+#include <stddef.h>
+#include <linux/ptrace.h>
+#include <linux/bpf.h>
+
+#include <bpf_helpers.h>
+
+#define KBUILD_MODNAME "foo"
+
+struct bpf_map_def SEC("maps") pcap_data_map = {
+	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+	.key_size = sizeof(int),
+	.value_size = sizeof(int),
+	.max_entries = 1024,
+};
+
+struct bpf_map_def SEC("maps") pcap_conf_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(int),
+	.value_size = sizeof(struct bpf_pcap_hdr),
+	.max_entries = 1,
+};
+
+/* To attach to raw tracepoints, we need one program for each arg choice 1-4.
+ * Otherwise attach fails.
+ */
+static __always_inline int trace_pcap(struct bpf_raw_tracepoint_args *ctx,
+				      int argnum)
+{
+	struct bpf_pcap_hdr *conf;
+	int ret, key = 0;
+
+	conf = bpf_map_lookup_elem(&pcap_conf_map, &key);
+	if (!conf)
+		return 0;
+
+	bpf_pcap((void *)ctx->args[argnum], conf->cap_len,
+		 &pcap_data_map, conf->protocol, conf->flags);
+	return 0;
+}
+
+SEC("raw_tracepoint/pcap_arg1")
+int trace_arg1(struct bpf_raw_tracepoint_args *ctx)
+{
+	return trace_pcap(ctx, 0);
+}
+
+SEC("raw_tracepoint/pcap_arg2")
+int trace_arg2(struct bpf_raw_tracepoint_args *ctx)
+{
+	return trace_pcap(ctx, 1);
+}
+
+SEC("raw_tracepoint/pcap_arg3")
+int trace_arg3(struct bpf_raw_tracepoint_args *ctx)
+{
+	return trace_pcap(ctx, 2);
+}
+
+SEC("raw_tracepoint/pcap_arg4")
+int trace_arg4(struct bpf_raw_tracepoint_args *ctx)
+{
+	return trace_pcap(ctx, 3);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 6c4930b..2a61126 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -231,6 +231,9 @@ static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
 static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
 					  int ip_len, void *tcp, int tcp_len) =
 	(void *) BPF_FUNC_tcp_gen_syncookie;
+static int (*bpf_pcap)(void *data, __u32 size, void *map, int protocol,
+		       __u64 flags) =
+	(void *) BPF_FUNC_pcap;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
@@ -520,8 +523,16 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
  * actual field offset, based on target kernel BTF type that matches original
  * (local) BTF, used to record relocation.
  */
+#ifdef __builtin_preserve_access_index
 #define BPF_CORE_READ(dst, src)						\
 	bpf_probe_read((dst), sizeof(*(src)),				\
 		       __builtin_preserve_access_index(src))
 
+#else
+
+#define	BPF_CORE_READ(dst, src)						\
+	bpf_probe_read((dst), sizeof(*(src)), src)
+
+#endif /* __builtin_preserve_access_index */
+
 #endif
-- 
1.8.3.1

