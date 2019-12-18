Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F98123F1A
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 06:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfLRF0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 00:26:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63618 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726652AbfLRF0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 00:26:03 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBI5MDWd009639
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 21:26:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=KQAum3qnX/g7ZffQbfN4LzvrAhA4J2OvFYsk46YUf3Y=;
 b=bP80PuV5MFF0sKZOUd7ycs/6oIkViyzv747ikfnoF/LFM9tlDeuBUkBuqKDQjfiolzXN
 yDjId5qK/3/Im4/yyPyCzCNa3NWXF1HOQu2VluiaHnlYv7cD1I6pW99PPvCBX2i8tLOE
 lgPLo+S5bK1++HaRE3JDmoaFlm3Gh6aUMso= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxuptn25n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 21:26:02 -0800
Received: from intmgw005.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 17 Dec 2019 21:26:01 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A6CB02EC17A4; Tue, 17 Dec 2019 21:26:00 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 3/3] bpftool: add gen subcommand manpage
Date:   Tue, 17 Dec 2019 21:25:52 -0800
Message-ID: <20191218052552.2915188-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218052552.2915188-1-andriin@fb.com>
References: <20191218052552.2915188-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_05:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=25 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpftool-gen.rst describing skeleton on the high level. Also include
a small, but complete, example BPF app (BPF side, userspace side, generated
skeleton) in example section to demonstrate skeleton API and its usage.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/bpftool/Documentation/bpftool-gen.rst | 304 ++++++++++++++++++
 tools/bpf/bpftool/Documentation/bpftool.rst   |   3 +-
 2 files changed, 306 insertions(+), 1 deletion(-)
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-gen.rst

diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
new file mode 100644
index 000000000000..b6a114bf908d
--- /dev/null
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -0,0 +1,304 @@
+================
+bpftool-gen
+================
+-------------------------------------------------------------------------------
+tool for BPF code-generation
+-------------------------------------------------------------------------------
+
+:Manual section: 8
+
+SYNOPSIS
+========
+
+	**bpftool** [*OPTIONS*] **gen** *COMMAND*
+
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] }
+
+	*COMMAND* := { **skeleton | **help** }
+
+GEN COMMANDS
+=============
+
+|	**bpftool** **gen skeleton** *FILE*
+|	**bpftool** **gen help**
+
+DESCRIPTION
+===========
+	**bpftool gen skeleton** *FILE*
+		  Generate BPF skeleton C header file for a given *FILE*.
+
+		  BPF skeleton is an alternative interface to existing libbpf
+		  APIs for working with BPF objects. Skeleton code is intended
+		  to significantly shorten and simplify code to load and work
+		  with BPF programs from userspace side. Generated code is
+		  tailored to specific input BPF object *FILE*, reflecting its
+		  structure by listing out available maps, program, variables,
+		  etc. Skeleton eliminates the need to lookup mentioned
+		  components by name. Instead, if skeleton instantiation
+		  succeeds, they are populated in skeleton structure as valid
+		  libbpf types (e.g., struct bpf_map pointer) and can be
+		  passed to existing generic libbpf APIs.
+
+		  In addition to simple and reliable access to maps and
+		  programs, skeleton provides a storage for BPF links (struct
+		  bpf_link) for each BPF program within BPF object. When
+		  requested, supported BPF programs will be automatically
+		  attached and resulting BPF links stored for further use by
+		  user in pre-allocated fields in skeleton struct. For BPF
+		  programs that can't be automatically attached by libbpf,
+		  user can attach them manually, but store resulting BPF link
+		  in per-program link field. All such set up links will be
+		  automatically destroyed on BPF skeleton destruction. This
+		  eliminates the need for users to manage links manually and
+		  rely on libbpf support to detach programs and free up
+		  resources.
+
+		  Another facility provided by BPF skeleton is an interface to
+		  global variables of all supported kinds: mutable, read-only,
+		  as well as extern ones. This interface allows to pre-setup
+		  initial values of variables before BPF object is loaded and
+		  verified by kernel. For non-read-only variables, the same
+		  interface can be used to fetch values of global variables on
+		  userspace side, even if they are modified by BPF code.
+
+		  During skeleton generation, contents of source BPF object
+		  *FILE* is embedded within generated code and is thus not
+		  necessary to keep around. This ensures skeleton and BPF
+		  object file are matching 1-to-1 and always stay in sync.
+		  Generated code is dual-licensed under LGPL-2.1 and
+		  BSD-2-Clause licenses.
+
+		  It is a design goal and guarantee that skeleton interfaces
+		  are interoperable with generic libbpf APIs. User should
+		  always be able to use skeleton API to create and load BPF
+		  object, and later use libbpf APIs to keep working with
+		  specific maps, programs, etc.
+
+		  As part of skeleton, few custom functions are generated.
+		  Each of them is prefixed with object name, derived from
+		  object file name. I.e., if BPF object file name is
+		  **example.o**, BPF object name will be **example**. The
+		  following custom functions are provided in such case:
+
+		  - **example__open** and **example__open_opts**.
+		    These functions are used to instantiate skeleton. It
+		    corresponds to libbpf's **bpf_object__open()** API.
+		    **_opts** variants accepts extra **bpf_object_open_opts**
+		    options.
+
+		  - **example__load**.
+		    This function creates maps, loads and verifies BPF
+		    programs, initializes global data maps. It corresponds to
+		    libppf's **bpf_object__load** API.
+
+		  - **example__open_and_load** combines **example__open** and
+		    **example__load** invocations in one commonly used
+		    operation.
+
+		  - **example__attach** and **example__detach**
+		    This pair of functions allow to attach and detach,
+		    correspondingly, already loaded BPF object. Only BPF
+		    programs of types supported by libbpf for auto-attachment
+		    will be auto-attached and their corresponding BPF links
+		    instantiated. For other BPF programs, user can manually
+		    create a BPF link and assign it to corresponding fields in
+		    skeleton struct. **example__detach** will detach both
+		    links created automatically, as well as those populated by
+		    user manually.
+
+		  - **example__destroy**
+		    Detach and unload BPF programs, free up all the resources
+		    used by skeleton and BPF object.
+
+		  If BPF object has global variables, corresponding structs
+		  with memory layout corresponding to global data data section
+		  layout will be created. Currently supported ones are: .data,
+		  .bss, .rodata, and .extern structs/data sections. These
+		  data sections/structs can be used to set up initial values of
+		  variables, if set before **example__load**. Afterwards, if
+		  target kernel supports memory-mapped BPF arrays, same
+		  structs can be used to fetch and update (non-read-only)
+		  data from userspace, with same simplicity as for BPF side.
+
+	**bpftool gen help**
+		  Print short help message.
+
+OPTIONS
+=======
+	-h, --help
+		  Print short generic help message (similar to **bpftool help**).
+
+	-V, --version
+		  Print version number (similar to **bpftool version**).
+
+	-j, --json
+		  Generate JSON output. For commands that cannot produce JSON,
+		  this option has no effect.
+
+	-p, --pretty
+		  Generate human-readable JSON output. Implies **-j**.
+
+	-d, --debug
+		  Print all logs available from libbpf, including debug-level
+		  information.
+
+EXAMPLES
+========
+**$ cat example.c**
+::
+
+  #include <stdbool.h>
+  #include <linux/ptrace.h>
+  #include <linux/bpf.h>
+  #include "bpf_helpers.h"
+
+  const volatile int param1 = 42;
+  bool global_flag = true;
+  struct { int x; } data = {};
+
+  struct {
+  	__uint(type, BPF_MAP_TYPE_HASH);
+  	__uint(max_entries, 128);
+  	__type(key, int);
+  	__type(value, long);
+  } my_map SEC(".maps");
+
+  SEC("raw_tp/sys_enter")
+  int handle_sys_enter(struct pt_regs *ctx)
+  {
+  	static long my_static_var;
+  	if (global_flag)
+  		my_static_var++;
+  	else
+  		data.x += param1;
+  	return 0;
+  }
+
+  SEC("raw_tp/sys_exit")
+  int handle_sys_exit(struct pt_regs *ctx)
+  {
+  	int zero = 0;
+  	bpf_map_lookup_elem(&my_map, &zero);
+  	return 0;
+  }
+
+This is example BPF application with two BPF programs and a mix of BPF maps
+and global variables.
+
+**$ bpftool gen skeleton example.o**
+::
+
+  /* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+
+  /* THIS FILE IS AUTOGENERATED! */
+  #ifndef __EXAMPLE_SKEL_H__
+  #define __EXAMPLE_SKEL_H__
+
+  #include <stdlib.h>
+  #include <libbpf.h>
+
+  struct example {
+  	struct bpf_object_skeleton *skeleton;
+  	struct bpf_object *obj;
+  	struct {
+  		struct bpf_map *rodata;
+  		struct bpf_map *data;
+  		struct bpf_map *bss;
+  		struct bpf_map *my_map;
+  	} maps;
+  	struct {
+  		struct bpf_program *handle_sys_enter;
+  		struct bpf_program *handle_sys_exit;
+  	} progs;
+  	struct {
+  		struct bpf_link *handle_sys_enter;
+  		struct bpf_link *handle_sys_exit;
+  	} links;
+  	struct example__bss {
+  		struct {
+  			int x;
+  		} data;
+  	} *bss;
+  	struct example__data {
+  		_Bool global_flag;
+  		long int handle_sys_enter_my_static_var;
+  	} *data;
+  	struct example__rodata {
+  		int param1;
+  	} *rodata;
+  };
+
+  static void example__destroy(struct example *obj);
+  static inline struct example *example__open_opts(
+                const struct bpf_object_open_opts *opts);
+  static inline struct example *example__open();
+  static inline int example__load(struct example *obj);
+  static inline struct example *example__open_and_load();
+  static inline int example__attach(struct example *obj);
+  static inline void example__detach(struct example *obj);
+
+  #endif /* __EXAMPLE_SKEL_H__ */
+
+**$ cat example_user.c**
+::
+
+  #include "example.skel.h"
+
+  int main()
+  {
+  	struct example *skel;
+  	int err = 0;
+
+  	skel = example__open();
+  	if (!skel)
+  		goto cleanup;
+
+  	skel->rodata->param1 = 128;
+
+  	err = example__load(skel);
+  	if (err)
+  		goto cleanup;
+
+  	err = example__attach(skel);
+  	if (err)
+  		goto cleanup;
+
+  	/* all libbpf APIs are usable */
+  	printf("my_map name: %s\n", bpf_map__name(skel->maps.my_map));
+  	printf("sys_enter prog FD: %d\n",
+  	       bpf_program__fd(skel->progs.handle_sys_enter));
+
+  	/* detach and re-attach sys_exit program */
+  	bpf_link__destroy(skel->links.handle_sys_exit);
+  	skel->links.handle_sys_exit =
+  		bpf_program__attach(skel->progs.handle_sys_exit);
+
+  	printf("my_static_var: %ld\n",
+  	       skel->bss->handle_sys_enter_my_static_var);
+
+  cleanup:
+  	example__destroy(skel);
+  	return err;
+  }
+
+**# ./example_user**
+::
+
+  my_map name: my_map
+  sys_enter prog FD: 8
+  my_static_var: 7
+
+This is a stripped-out version of skeleton generated for above example code.
+
+SEE ALSO
+========
+	**bpf**\ (2),
+	**bpf-helpers**\ (7),
+	**bpftool**\ (8),
+	**bpftool-map**\ (8),
+	**bpftool-prog**\ (8),
+	**bpftool-cgroup**\ (8),
+	**bpftool-feature**\ (8),
+	**bpftool-net**\ (8),
+	**bpftool-perf**\ (8),
+	**bpftool-btf**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index 6a9c52ef84a9..34239fda69ed 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -81,4 +81,5 @@ SEE ALSO
 	**bpftool-feature**\ (8),
 	**bpftool-net**\ (8),
 	**bpftool-perf**\ (8),
-	**bpftool-btf**\ (8)
+	**bpftool-btf**\ (8),
+	**bpftool-gen**\ (8),
-- 
2.17.1

