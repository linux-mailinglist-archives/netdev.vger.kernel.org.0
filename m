Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9550E1D0A55
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 09:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbgEMH7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 03:59:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:54138 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729026AbgEMH7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 03:59:05 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYmIA-0008Rv-1S; Wed, 13 May 2020 09:59:02 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     quentin@isovalent.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next] bpf, bpftool: Allow probing for CONFIG_HZ from kernel config
Date:   Wed, 13 May 2020 09:58:49 +0200
Message-Id: <20200513075849.20868-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25810/Tue May 12 14:14:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In Cilium we've recently switched to make use of bpf_jiffies64() for
parts of our tc and XDP datapath since bpf_ktime_get_ns() is more
expensive and high-precision is not needed for our timeouts we have
anyway. Our agent has a probe manager which picks up the json of
bpftool's feature probe and we also use the macro output in our C
programs e.g. to have workarounds when helpers are not available on
older kernels.

Extend the kernel config info dump to also include the kernel's
CONFIG_HZ, and rework the probe_kernel_image_config() for allowing a
macro dump such that CONFIG_HZ can be propagated to BPF C code as a
simple define if available via config. Latter allows to have _compile-
time_ resolution of jiffies <-> sec conversion in our code since all
are propagated as known constants.

Given we cannot generally assume availability of kconfig everywhere,
we also have a kernel hz probe [0] as a fallback. Potentially, bpftool
could have an integrated probe fallback as well, although to derive it,
we might need to place it under 'bpftool feature probe full' or similar
given it would slow down the probing process overall. Yet 'full' doesn't
fit either for us since we don't want to pollute the kernel log with
warning messages from bpf_probe_write_user() and bpf_trace_printk() on
agent startup; I've left it out for the time being.

  [0] https://github.com/cilium/cilium/blob/master/bpf/cilium-probe-kernel-hz.c

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
---
 tools/bpf/bpftool/feature.c | 120 ++++++++++++++++++++----------------
 1 file changed, 67 insertions(+), 53 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index f54347f55ee0..1b73e63274b5 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -80,13 +80,12 @@ print_bool_feature(const char *feat_name, const char *plain_name,
 		printf("%s is %savailable\n", plain_name, res ? "" : "NOT ");
 }
 
-static void print_kernel_option(const char *name, const char *value)
+static void print_kernel_option(const char *name, const char *value,
+				const char *define_prefix)
 {
 	char *endptr;
 	int res;
 
-	/* No support for C-style ouptut */
-
 	if (json_output) {
 		if (!value) {
 			jsonw_null_field(json_wtr, name);
@@ -98,6 +97,12 @@ static void print_kernel_option(const char *name, const char *value)
 			jsonw_int_field(json_wtr, name, res);
 		else
 			jsonw_string_field(json_wtr, name, value);
+	} else if (define_prefix) {
+		if (value)
+			printf("#define %s%s %s\n", define_prefix,
+			       name, value);
+		else
+			printf("/* %s%s is not set */\n", define_prefix, name);
 	} else {
 		if (value)
 			printf("%s is set to %s\n", name, value);
@@ -315,77 +320,84 @@ static bool read_next_kernel_config_option(gzFile file, char *buf, size_t n,
 	return false;
 }
 
-static void probe_kernel_image_config(void)
+static void probe_kernel_image_config(const char *define_prefix)
 {
-	static const char * const options[] = {
+	static const struct {
+		const char * const name;
+		bool macro_dump;
+	} options[] = {
 		/* Enable BPF */
-		"CONFIG_BPF",
+		{ "CONFIG_BPF", },
 		/* Enable bpf() syscall */
-		"CONFIG_BPF_SYSCALL",
+		{ "CONFIG_BPF_SYSCALL", },
 		/* Does selected architecture support eBPF JIT compiler */
-		"CONFIG_HAVE_EBPF_JIT",
+		{ "CONFIG_HAVE_EBPF_JIT", },
 		/* Compile eBPF JIT compiler */
-		"CONFIG_BPF_JIT",
+		{ "CONFIG_BPF_JIT", },
 		/* Avoid compiling eBPF interpreter (use JIT only) */
-		"CONFIG_BPF_JIT_ALWAYS_ON",
+		{ "CONFIG_BPF_JIT_ALWAYS_ON", },
 
 		/* cgroups */
-		"CONFIG_CGROUPS",
+		{ "CONFIG_CGROUPS", },
 		/* BPF programs attached to cgroups */
-		"CONFIG_CGROUP_BPF",
+		{ "CONFIG_CGROUP_BPF", },
 		/* bpf_get_cgroup_classid() helper */
-		"CONFIG_CGROUP_NET_CLASSID",
+		{ "CONFIG_CGROUP_NET_CLASSID", },
 		/* bpf_skb_{,ancestor_}cgroup_id() helpers */
-		"CONFIG_SOCK_CGROUP_DATA",
+		{ "CONFIG_SOCK_CGROUP_DATA", },
 
 		/* Tracing: attach BPF to kprobes, tracepoints, etc. */
-		"CONFIG_BPF_EVENTS",
+		{ "CONFIG_BPF_EVENTS", },
 		/* Kprobes */
-		"CONFIG_KPROBE_EVENTS",
+		{ "CONFIG_KPROBE_EVENTS", },
 		/* Uprobes */
-		"CONFIG_UPROBE_EVENTS",
+		{ "CONFIG_UPROBE_EVENTS", },
 		/* Tracepoints */
-		"CONFIG_TRACING",
+		{ "CONFIG_TRACING", },
 		/* Syscall tracepoints */
-		"CONFIG_FTRACE_SYSCALLS",
+		{ "CONFIG_FTRACE_SYSCALLS", },
 		/* bpf_override_return() helper support for selected arch */
-		"CONFIG_FUNCTION_ERROR_INJECTION",
+		{ "CONFIG_FUNCTION_ERROR_INJECTION", },
 		/* bpf_override_return() helper */
-		"CONFIG_BPF_KPROBE_OVERRIDE",
+		{ "CONFIG_BPF_KPROBE_OVERRIDE", },
 
 		/* Network */
-		"CONFIG_NET",
+		{ "CONFIG_NET", },
 		/* AF_XDP sockets */
-		"CONFIG_XDP_SOCKETS",
+		{ "CONFIG_XDP_SOCKETS", },
 		/* BPF_PROG_TYPE_LWT_* and related helpers */
-		"CONFIG_LWTUNNEL_BPF",
+		{ "CONFIG_LWTUNNEL_BPF", },
 		/* BPF_PROG_TYPE_SCHED_ACT, TC (traffic control) actions */
-		"CONFIG_NET_ACT_BPF",
+		{ "CONFIG_NET_ACT_BPF", },
 		/* BPF_PROG_TYPE_SCHED_CLS, TC filters */
-		"CONFIG_NET_CLS_BPF",
+		{ "CONFIG_NET_CLS_BPF", },
 		/* TC clsact qdisc */
-		"CONFIG_NET_CLS_ACT",
+		{ "CONFIG_NET_CLS_ACT", },
 		/* Ingress filtering with TC */
-		"CONFIG_NET_SCH_INGRESS",
+		{ "CONFIG_NET_SCH_INGRESS", },
 		/* bpf_skb_get_xfrm_state() helper */
-		"CONFIG_XFRM",
+		{ "CONFIG_XFRM", },
 		/* bpf_get_route_realm() helper */
-		"CONFIG_IP_ROUTE_CLASSID",
+		{ "CONFIG_IP_ROUTE_CLASSID", },
 		/* BPF_PROG_TYPE_LWT_SEG6_LOCAL and related helpers */
-		"CONFIG_IPV6_SEG6_BPF",
+		{ "CONFIG_IPV6_SEG6_BPF", },
 		/* BPF_PROG_TYPE_LIRC_MODE2 and related helpers */
-		"CONFIG_BPF_LIRC_MODE2",
+		{ "CONFIG_BPF_LIRC_MODE2", },
 		/* BPF stream parser and BPF socket maps */
-		"CONFIG_BPF_STREAM_PARSER",
+		{ "CONFIG_BPF_STREAM_PARSER", },
 		/* xt_bpf module for passing BPF programs to netfilter  */
-		"CONFIG_NETFILTER_XT_MATCH_BPF",
+		{ "CONFIG_NETFILTER_XT_MATCH_BPF", },
 		/* bpfilter back-end for iptables */
-		"CONFIG_BPFILTER",
+		{ "CONFIG_BPFILTER", },
 		/* bpftilter module with "user mode helper" */
-		"CONFIG_BPFILTER_UMH",
+		{ "CONFIG_BPFILTER_UMH", },
 
 		/* test_bpf module for BPF tests */
-		"CONFIG_TEST_BPF",
+		{ "CONFIG_TEST_BPF", },
+
+		/* Misc configs useful in BPF C programs */
+		/* jiffies <-> sec conversion for bpf_jiffies64() helper */
+		{ "CONFIG_HZ", true, }
 	};
 	char *values[ARRAY_SIZE(options)] = { };
 	struct utsname utsn;
@@ -427,7 +439,8 @@ static void probe_kernel_image_config(void)
 
 	while (read_next_kernel_config_option(file, buf, sizeof(buf), &value)) {
 		for (i = 0; i < ARRAY_SIZE(options); i++) {
-			if (values[i] || strcmp(buf, options[i]))
+			if ((define_prefix && !options[i].macro_dump) ||
+			    values[i] || strcmp(buf, options[i].name))
 				continue;
 
 			values[i] = strdup(value);
@@ -439,7 +452,9 @@ static void probe_kernel_image_config(void)
 		gzclose(file);
 
 	for (i = 0; i < ARRAY_SIZE(options); i++) {
-		print_kernel_option(options[i], values[i]);
+		if (define_prefix && !options[i].macro_dump)
+			continue;
+		print_kernel_option(options[i].name, values[i], define_prefix);
 		free(values[i]);
 	}
 }
@@ -632,23 +647,22 @@ section_system_config(enum probe_component target, const char *define_prefix)
 	switch (target) {
 	case COMPONENT_KERNEL:
 	case COMPONENT_UNSPEC:
-		if (define_prefix)
-			break;
-
 		print_start_section("system_config",
 				    "Scanning system configuration...",
-				    NULL, /* define_comment never used here */
-				    NULL); /* define_prefix always NULL here */
-		if (check_procfs()) {
-			probe_unprivileged_disabled();
-			probe_jit_enable();
-			probe_jit_harden();
-			probe_jit_kallsyms();
-			probe_jit_limit();
-		} else {
-			p_info("/* procfs not mounted, skipping related probes */");
+				    "/*** Misc kernel config items ***/",
+				    define_prefix);
+		if (!define_prefix) {
+			if (check_procfs()) {
+				probe_unprivileged_disabled();
+				probe_jit_enable();
+				probe_jit_harden();
+				probe_jit_kallsyms();
+				probe_jit_limit();
+			} else {
+				p_info("/* procfs not mounted, skipping related probes */");
+			}
 		}
-		probe_kernel_image_config();
+		probe_kernel_image_config(define_prefix);
 		print_end_section();
 		break;
 	default:
-- 
2.17.1

