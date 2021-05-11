Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC0437B01A
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 22:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhEKUgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 16:36:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:42884 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhEKUgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 16:36:45 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lgZ6P-000422-ES; Tue, 11 May 2021 22:35:37 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     andrii@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 1/2] bpf, kconfig: Add consolidated menu entry for bpf with core options
Date:   Tue, 11 May 2021 22:35:16 +0200
Message-Id: <f23f58765a4d59244ebd8037da7b6a6b2fb58446.1620765074.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26167/Tue May 11 13:12:12 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, all core BPF related options are scattered in different Kconfig
locations mainly due to historic reasons. Moving forward, lets add a proper
subsystem entry under ...

  General setup  --->
    BPF subsystem  --->

... in order to have all knobs in a single location and thus ease BPF related
configuration. Networking related bits such as sockmap are out of scope for
the general setup and therefore better suited to remain in net/Kconfig.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 init/Kconfig       | 41 +-----------------------
 kernel/bpf/Kconfig | 78 ++++++++++++++++++++++++++++++++++++++++++++++
 net/Kconfig        | 27 ----------------
 3 files changed, 79 insertions(+), 67 deletions(-)
 create mode 100644 kernel/bpf/Kconfig

diff --git a/init/Kconfig b/init/Kconfig
index ca559ccdaa32..2282a6842dc6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -439,6 +439,7 @@ config AUDITSYSCALL
 
 source "kernel/irq/Kconfig"
 source "kernel/time/Kconfig"
+source "kernel/bpf/Kconfig"
 source "kernel/Kconfig.preempt"
 
 menu "CPU/Task time and stats accounting"
@@ -1705,46 +1706,6 @@ config KALLSYMS_BASE_RELATIVE
 
 # syscall, maps, verifier
 
-config BPF_LSM
-	bool "LSM Instrumentation with BPF"
-	depends on BPF_EVENTS
-	depends on BPF_SYSCALL
-	depends on SECURITY
-	depends on BPF_JIT
-	help
-	  Enables instrumentation of the security hooks with eBPF programs for
-	  implementing dynamic MAC and Audit Policies.
-
-	  If you are unsure how to answer this question, answer N.
-
-config BPF_SYSCALL
-	bool "Enable bpf() system call"
-	select BPF
-	select IRQ_WORK
-	select TASKS_TRACE_RCU
-	select BINARY_PRINTF
-	select NET_SOCK_MSG if INET
-	default n
-	help
-	  Enable the bpf() system call that allows to manipulate eBPF
-	  programs and maps via file descriptors.
-
-config ARCH_WANT_DEFAULT_BPF_JIT
-	bool
-
-config BPF_JIT_ALWAYS_ON
-	bool "Permanently enable BPF JIT and remove BPF interpreter"
-	depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
-	help
-	  Enables BPF JIT and removes BPF interpreter to avoid
-	  speculative execution of BPF instructions by the interpreter
-
-config BPF_JIT_DEFAULT_ON
-	def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
-	depends on HAVE_EBPF_JIT && BPF_JIT
-
-source "kernel/bpf/preload/Kconfig"
-
 config USERFAULTFD
 	bool "Enable userfaultfd() system call"
 	depends on MMU
diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
new file mode 100644
index 000000000000..b4edaefc6255
--- /dev/null
+++ b/kernel/bpf/Kconfig
@@ -0,0 +1,78 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+# BPF interpreter that, for example, classic socket filters depend on.
+config BPF
+	bool
+
+# Used by archs to tell that they support BPF JIT compiler plus which
+# flavour. Only one of the two can be selected for a specific arch since
+# eBPF JIT supersedes the cBPF JIT.
+
+# Classic BPF JIT (cBPF)
+config HAVE_CBPF_JIT
+	bool
+
+# Extended BPF JIT (eBPF)
+config HAVE_EBPF_JIT
+	bool
+
+# Used by archs to tell that they want the BPF JIT compiler enabled by
+# default for kernels that were compiled with BPF JIT support.
+config ARCH_WANT_DEFAULT_BPF_JIT
+	bool
+
+menu "BPF subsystem"
+
+config BPF_SYSCALL
+	bool "Enable bpf() system call"
+	select BPF
+	select IRQ_WORK
+	select TASKS_TRACE_RCU
+	select BINARY_PRINTF
+	select NET_SOCK_MSG if INET
+	default n
+	help
+	  Enable the bpf() system call that allows to manipulate BPF programs
+	  and maps via file descriptors.
+
+config BPF_JIT
+	bool "Enable BPF Just In Time compiler"
+	depends on HAVE_CBPF_JIT || HAVE_EBPF_JIT
+	depends on MODULES
+	help
+	  BPF programs are normally handled by a BPF interpreter. This option
+	  allows the kernel to generate native code when a program is loaded
+	  into the kernel. This will significantly speed-up processing of BPF
+	  programs.
+
+	  Note, an admin should enable this feature changing:
+	  /proc/sys/net/core/bpf_jit_enable
+	  /proc/sys/net/core/bpf_jit_harden   (optional)
+	  /proc/sys/net/core/bpf_jit_kallsyms (optional)
+
+config BPF_JIT_ALWAYS_ON
+	bool "Permanently enable BPF JIT and remove BPF interpreter"
+	depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
+	help
+	  Enables BPF JIT and removes BPF interpreter to avoid speculative
+	  execution of BPF instructions by the interpreter.
+
+config BPF_JIT_DEFAULT_ON
+	def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
+	depends on HAVE_EBPF_JIT && BPF_JIT
+
+source "kernel/bpf/preload/Kconfig"
+
+config BPF_LSM
+	bool "Enable BPF LSM Instrumentation"
+	depends on BPF_EVENTS
+	depends on BPF_SYSCALL
+	depends on SECURITY
+	depends on BPF_JIT
+	help
+	  Enables instrumentation of the security hooks with BPF programs for
+	  implementing dynamic MAC and Audit Policies.
+
+	  If you are unsure how to answer this question, answer N.
+
+endmenu # "BPF subsystem"
diff --git a/net/Kconfig b/net/Kconfig
index f5ee7c65e6b4..c7392c449b25 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -302,21 +302,6 @@ config BQL
 	select DQL
 	default y
 
-config BPF_JIT
-	bool "enable BPF Just In Time compiler"
-	depends on HAVE_CBPF_JIT || HAVE_EBPF_JIT
-	depends on MODULES
-	help
-	  Berkeley Packet Filter filtering capabilities are normally handled
-	  by an interpreter. This option allows kernel to generate a native
-	  code when filter is loaded in memory. This should speedup
-	  packet sniffing (libpcap/tcpdump).
-
-	  Note, admin should enable this feature changing:
-	  /proc/sys/net/core/bpf_jit_enable
-	  /proc/sys/net/core/bpf_jit_harden   (optional)
-	  /proc/sys/net/core/bpf_jit_kallsyms (optional)
-
 config BPF_STREAM_PARSER
 	bool "enable BPF STREAM_PARSER"
 	depends on INET
@@ -470,15 +455,3 @@ config ETHTOOL_NETLINK
 	  e.g. notification messages.
 
 endif   # if NET
-
-# Used by archs to tell that they support BPF JIT compiler plus which flavour.
-# Only one of the two can be selected for a specific arch since eBPF JIT supersedes
-# the cBPF JIT.
-
-# Classic BPF JIT (cBPF)
-config HAVE_CBPF_JIT
-	bool
-
-# Extended BPF JIT (eBPF)
-config HAVE_EBPF_JIT
-	bool
-- 
2.21.0

