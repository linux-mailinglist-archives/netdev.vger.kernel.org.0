Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8751A162F4A
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgBRTCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:02:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:35632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgBRTCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 14:02:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7DD7BAD4F;
        Tue, 18 Feb 2020 19:02:38 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 4/6] bpftool: Update documentation of "bpftool feature" command
Date:   Tue, 18 Feb 2020 20:02:21 +0100
Message-Id: <20200218190224.22508-5-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200218190224.22508-1-mrostecki@opensuse.org>
References: <20200218190224.22508-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update documentation of "bpftool feature" command with information about
new arguments: "section", "filter_in" and "filter_out".

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 .../bpftool/Documentation/bpftool-feature.rst | 37 ++++++++++++++++---
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index 4d08f35034a2..39b4c47e3c75 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -19,19 +19,45 @@ SYNOPSIS
 FEATURE COMMANDS
 ================
 
-|	**bpftool** **feature probe** [*COMPONENT*] [**macros** [**prefix** *PREFIX*]]
+|	**bpftool** **feature probe** [*COMPONENT*] [**section** *SECTION*] [**filter_in** *PATTERN*] [**filter_out** *PATTERN*] [**macros** [**prefix** *PREFIX*]]
 |	**bpftool** **feature help**
 |
 |	*COMPONENT* := { **kernel** | **dev** *NAME* }
+|	*SECTION* := { **system_config** | **syscall_config** | **program_types** | **map_types** | **helpers** | **misc** }
 
 DESCRIPTION
 ===========
-	**bpftool feature probe** [**kernel**] [**macros** [**prefix** *PREFIX*]]
+	**bpftool feature probe** [**kernel**] [**section** *SECTION*] [**filter_in** *PATTERN*] [**filter_out** *PATTERN*] [**macros** [**prefix** *PREFIX*]]
 		  Probe the running kernel and dump a number of eBPF-related
 		  parameters, such as availability of the **bpf()** system call,
 		  JIT status, eBPF program types availability, eBPF helper
 		  functions availability, and more.
 
+		  If the **section** keyword is passed, only the specified
+		  probes section will be checked and printed. The only probe
+		  which is always going to be performed is **syscall_config**,
+		  but if the other section was provided as an argument,
+		  **syscall_config** check will perform silently without
+		  printing the result and bpftool will exit if the **bpf()**
+		  syscall is not available (because in that case performing
+		  other checks relying on the **bpf()** system call does not
+		  make sense).
+
+		  If the **filter_in** keyword is passed, only checks with
+		  names matching the given *PATTERN* are going the be printed
+		  and performed.
+
+		  If the **filter_out** keyword is passed, checks with names
+		  matching the given *PATTERN* are not going to be printed and
+		  performed.
+
+		  Please refer to the **regex**\ (7) man page for details on
+		  the syntax for *PATTERN*.
+
+		  **filter_in** is executed before **filter_out** which means
+		  that **filter_out** is always applied only on probes
+		  selected by **filter_in** if both arguments are used together.
+
 		  If the **macros** keyword (but not the **-j** option) is
 		  passed, a subset of the output is dumped as a list of
 		  **#define** macros that are ready to be included in a C
@@ -48,12 +74,13 @@ DESCRIPTION
 		  **bpf_trace_printk**\ () or **bpf_probe_write_user**\ ()) may
 		  print warnings to kernel logs.
 
-	**bpftool feature probe dev** *NAME* [**macros** [**prefix** *PREFIX*]]
+	**bpftool feature probe dev** *NAME* [**section** *SECTION*] [**filter_in** *PATTERN*] [**filter_out** *PATTERN*] [**macros** [**prefix** *PREFIX*]]
 		  Probe network device for supported eBPF features and dump
 		  results to the console.
 
-		  The two keywords **macros** and **prefix** have the same
-		  role as when probing the kernel.
+		  The keywords **section**, **filter_in**, **filter_out**,
+		  **macros** and **prefix** have the same role as when probing
+		  the kernel.
 
 	**bpftool feature help**
 		  Print short help message.
-- 
2.25.0

