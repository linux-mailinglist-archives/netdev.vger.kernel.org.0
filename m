Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E66637CB8
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiKXPTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiKXPTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:19:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1896D16E8EB
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669302981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NqYTNWqKXsbAI7x1/28J4Ht9r4YR+5xoo18QliLmNU=;
        b=YlZE9SmAUjAfau6ucziGVgfFzzd3EmJR53u4kEfCjMbPqjRrW/sv5Jfylkptei60INLvlI
        KNyou/YJ426tKVt0OW69S6EzN7Xu0MWd199TGxYWQGqUmCIYLE2UaH3ucn+ucgHizjMG1i
        AgKCCDiJ2B5+YOiBkF6alt/hTWNxmVk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-Q9d2T61xNyWEl_5TupuZ2g-1; Thu, 24 Nov 2022 10:16:16 -0500
X-MC-Unique: Q9d2T61xNyWEl_5TupuZ2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 820FA802C16;
        Thu, 24 Nov 2022 15:16:15 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C350F40C2066;
        Thu, 24 Nov 2022 15:16:13 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [RFC hid v1 03/10] HID: add a tool to convert a bpf source into a generic bpf loader
Date:   Thu, 24 Nov 2022 16:15:56 +0100
Message-Id: <20221124151603.807536-4-benjamin.tissoires@redhat.com>
In-Reply-To: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
References: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We first use bpftool to generate a json representation of the program,
and then use a python script to convert it into a C array element that
will be able to be generically loaded by the kernel.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 MAINTAINERS                             |   1 +
 drivers/hid/bpf/progs/Makefile          | 105 +++++++++++
 drivers/hid/bpf/progs/hid_bpf.h         |  15 ++
 drivers/hid/bpf/progs/hid_bpf_helpers.h |  22 +++
 drivers/hid/bpf/progs/hid_bpf_progs.h   |  49 +++++
 tools/hid/build_progs_list.py           | 231 ++++++++++++++++++++++++
 6 files changed, 423 insertions(+)
 create mode 100644 drivers/hid/bpf/progs/Makefile
 create mode 100644 drivers/hid/bpf/progs/hid_bpf.h
 create mode 100644 drivers/hid/bpf/progs/hid_bpf_helpers.h
 create mode 100644 drivers/hid/bpf/progs/hid_bpf_progs.h
 create mode 100755 tools/hid/build_progs_list.py

diff --git a/MAINTAINERS b/MAINTAINERS
index 752126fba795..8580895e280f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9102,6 +9102,7 @@ F:	drivers/hid/
 F:	include/linux/hid*
 F:	include/uapi/linux/hid*
 F:	samples/hid/
+F:	tools/hid
 F:	tools/testing/selftests/hid/
 
 HID LOGITECH DRIVERS
diff --git a/drivers/hid/bpf/progs/Makefile b/drivers/hid/bpf/progs/Makefile
new file mode 100644
index 000000000000..ee0203d3349a
--- /dev/null
+++ b/drivers/hid/bpf/progs/Makefile
@@ -0,0 +1,105 @@
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
+HID_BPF_CONVERTER := $(TOOLS_PATH)/hid/build_progs_list.py
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
+.PHONY: all
+
+TARGETS = $(patsubst %.bpf.c,%.hidbpf.h, $(wildcard *.bpf.c))
+TARGETS += hid_bpf_progs.h
+
+all: $(TARGETS)
+
+clean:
+	$(call msg,CLEAN)
+	$(Q)rm -rf $(OUTPUT) $(TARGETS)
+
+$(OUTPUT)/%.json: $(OUTPUT)/%.bpf.o | $(BPFTOOL)
+	$(call msg,GEN-SKEL,$@)
+	$(Q)$(BPFTOOL) gen skeleton -L -j $< > $@
+
+%.hidbpf.h: $(OUTPUT)/%.json | $(HID_BPF_CONVERTER)
+	$(call msg,GEN-HIDBPF,$@)
+	$(Q)$(HID_BPF_CONVERTER) build_prog $< -o $@
+
+hid_bpf_progs.h: $(addprefix $(OUTPUT)/,$(patsubst %.bpf.c,%.json, $(wildcard *.bpf.c))) | $(HID_BPF_CONVERTER)
+	$(call msg,GEN-HIDBPF-LIST,$@)
+	$(Q)$(HID_BPF_CONVERTER) build_list $< -o $@
+
+$(OUTPUT)/%.bpf.o: %.bpf.c $(OUTPUT)/vmlinux.h $(BPFOBJ) | $(OUTPUT)
+	$(call msg,BPF,$@)
+	$(Q)$(CLANG) -g -O2 -target bpf $(INCLUDES)				\
+		 -c $(filter %.c,$^) -o $@ &&					\
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
+	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)				\
+		    OUTPUT=$(abspath $(dir $@))/ prefix=			\
+		    DESTDIR=$(LIBBPF_DESTDIR) $(abspath $@) install_headers
+
+ifeq ($(CROSS_COMPILE),)
+$(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BPFTOOL_OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)				\
+		    OUTPUT=$(BPFTOOL_OUTPUT)/					\
+		    LIBBPF_BOOTSTRAP_OUTPUT=$(LIBBPF_OUTPUT)/			\
+		    LIBBPF_BOOTSTRAP_DESTDIR=$(LIBBPF_DESTDIR)/ bootstrap
+else
+$(DEFAULT_BPFTOOL): $(BPFTOOL_OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)				\
+		    OUTPUT=$(BPFTOOL_OUTPUT)/ bootstrap
+endif
diff --git a/drivers/hid/bpf/progs/hid_bpf.h b/drivers/hid/bpf/progs/hid_bpf.h
new file mode 100644
index 000000000000..7ee371cac2e1
--- /dev/null
+++ b/drivers/hid/bpf/progs/hid_bpf.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2022 Benjamin Tissoires
+ */
+
+#ifndef ____HID_BPF__H
+#define ____HID_BPF__H
+
+struct hid_bpf_probe_args {
+	unsigned int hid;
+	unsigned int rdesc_size;
+	unsigned char rdesc[4096];
+	int retval;
+};
+
+#endif /* ____HID_BPF__H */
diff --git a/drivers/hid/bpf/progs/hid_bpf_helpers.h b/drivers/hid/bpf/progs/hid_bpf_helpers.h
new file mode 100644
index 000000000000..4c4e63a516b3
--- /dev/null
+++ b/drivers/hid/bpf/progs/hid_bpf_helpers.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2022 Benjamin Tissoires
+ */
+
+#ifndef __HID_BPF_HELPERS_H
+#define __HID_BPF_HELPERS_H
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+extern __u8 *hid_bpf_get_data(struct hid_bpf_ctx *ctx,
+			      unsigned int offset,
+			      const size_t __sz) __ksym;
+extern struct hid_bpf_ctx *hid_bpf_allocate_context(unsigned int hid_id) __ksym;
+extern void hid_bpf_release_context(struct hid_bpf_ctx *ctx) __ksym;
+extern int hid_bpf_hw_request(struct hid_bpf_ctx *ctx,
+			      __u8 *data,
+			      size_t buf__sz,
+			      enum hid_report_type type,
+			      enum hid_class_request reqtype) __ksym;
+
+#endif /* __HID_BPF_HELPERS_H */
diff --git a/drivers/hid/bpf/progs/hid_bpf_progs.h b/drivers/hid/bpf/progs/hid_bpf_progs.h
new file mode 100644
index 000000000000..430e0fb47484
--- /dev/null
+++ b/drivers/hid/bpf/progs/hid_bpf_progs.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+/* THIS FILE IS AUTOGENERATED BY build_progs_list.py ! */
+
+#ifndef __HID_BPF_PROGS_H__
+#define __HID_BPF_PROGS_H__
+
+/**
+ * struct hid_bpf_map: custom HID representation of a map
+ */
+struct hid_bpf_map {
+	unsigned int size;
+	unsigned int mmap_sz;
+	char *data;
+};
+
+/**
+ * struct hid_bpf_prog: custom HID representation of a program
+ */
+struct hid_bpf_prog {
+};
+
+/**
+ * struct hid_bpf_object: custom HID representation of a BPF object
+ * @map_cnt: number of maps available in the BPF object
+ * @prog_cnt: number of programs available
+ * @probe: index of the probe program if any (greater than prog_cnt if none)
+ */
+struct hid_bpf_object {
+	struct hid_device_id id;
+	unsigned int map_cnt;
+	struct hid_bpf_map maps[0];
+	unsigned int prog_cnt;
+	struct hid_bpf_prog progs[0];
+	unsigned int probe;
+	unsigned int rodata;
+	unsigned int data_sz;
+	char *data;
+	unsigned int insns_sz;
+	char *insns;
+};
+
+static struct hid_bpf_object hid_objects[] = {
+
+
+	{ },
+};
+
+#endif /* __HID_BPF_PROGS_H__ */
+
diff --git a/tools/hid/build_progs_list.py b/tools/hid/build_progs_list.py
new file mode 100755
index 000000000000..8103bc2f433f
--- /dev/null
+++ b/tools/hid/build_progs_list.py
@@ -0,0 +1,231 @@
+#!/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright (c) 2022 Benjamin Tissoires
+
+import argparse
+import json
+import re
+import sys
+
+from pathlib import Path
+
+
+def create_header(fp, max_maps_cnt, max_progs_cnt):
+    print(
+        f"""/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+/* THIS FILE IS AUTOGENERATED BY build_progs_list.py ! */
+
+#ifndef __HID_BPF_PROGS_H__
+#define __HID_BPF_PROGS_H__
+
+/**
+ * struct hid_bpf_map: custom HID representation of a map
+ */
+struct hid_bpf_map {{
+	unsigned int size;
+	unsigned int mmap_sz;
+	char *data;
+}};
+
+/**
+ * struct hid_bpf_prog: custom HID representation of a program
+ */
+struct hid_bpf_prog {{
+}};
+
+/**
+ * struct hid_bpf_object: custom HID representation of a BPF object
+ * @map_cnt: number of maps available in the BPF object
+ * @prog_cnt: number of programs available
+ * @probe: index of the probe program if any (greater than prog_cnt if none)
+ */
+struct hid_bpf_object {{
+	struct hid_device_id id;
+	unsigned int map_cnt;
+	struct hid_bpf_map maps[{max_maps_cnt}];
+	unsigned int prog_cnt;
+	struct hid_bpf_prog progs[{max_progs_cnt}];
+	unsigned int probe;
+	unsigned int rodata;
+	unsigned int data_sz;
+	char *data;
+	unsigned int insns_sz;
+	char *insns;
+}};
+
+static struct hid_bpf_object hid_objects[] = {{
+""",
+        file=fp,
+    )
+
+
+def create_footer(fp):
+    print(
+        """
+	{ },
+};
+
+#endif /* __HID_BPF_PROGS_H__ */
+""",
+        file=fp,
+    )
+
+
+def get_bus_group_vid_pid(json_data):
+    path_regex = re.compile(
+        r"b([0-9a-fA-F]{4})g([0-9a-fA-F]{4})v([0-9a-fA-F]{4})p([0-9a-fA-F]{4}).*"
+    )
+    return path_regex.match(json_data["name"])
+
+
+def is_valid_bpf_json(json_data):
+    return get_bus_group_vid_pid(json_data) is not None and json_data["use_loader"]
+
+
+def build_prog_list(args):
+    input_files = [Path(p) for p in args.path]
+    output = args.output
+    max_maps_cnt = 0
+    max_progs_cnt = 0
+    valid_files = []
+
+    for prog in input_files:
+        with open(prog) as f:
+            data = json.load(f)
+        if not is_valid_bpf_json(data):
+            print(f"ignoring {prog.relative_to('.')}", file=sys.stderr)
+            continue
+        generated_name = prog.name.replace(".json", ".hidbpf.h")
+        max_maps_cnt = max(max_maps_cnt, len(data["maps"]))
+        max_progs_cnt = max(max_progs_cnt, len(data["progs"]))
+
+        valid_files.append(generated_name)
+
+    create_header(output, max_maps_cnt, max_progs_cnt)
+
+    valid_files.sort()
+
+    for file in valid_files:
+        print(f'#include "{file}"', file=output)
+
+    create_footer(output)
+
+
+def write_c_data(bytes):
+	outputs = ['"', '']
+	for b in bytes:
+		w = 2 if b == '0x00' else 4
+		if len(outputs[-1]) + w > 78:
+			outputs.append('')
+		if b != "0x00":
+			outputs[-1] += f"\\x{b[2:]}"
+		else:
+			outputs[-1] += "\\0"
+	outputs[-1] += '"'
+	return '\\\n'.join(outputs)
+
+
+def build_c_object(args):
+    input_file = Path(args.path[0])
+    output = args.output
+
+    with open(input_file) as f:
+        data = json.load(f)
+
+    if not is_valid_bpf_json(data):
+        print(f"ignoring {input_file.relative_to('.')}", file=sys.stderr)
+        return
+
+    try:
+        probe_idx = [p["name"] for p in data["progs"]].index("probe")
+    except ValueError:
+        probe_idx = len(data["progs"]) + 1
+
+    try:
+        rodata_idx = [m["ident"] for m in data["maps"]].index("rodata")
+    except ValueError:
+        rodata_idx = len(data["maps"]) + 1
+
+    header_marker = (
+        f"__{input_file.name}__".replace(".", "_")
+        .replace("-", "_")
+        .replace("json", "hidbpf_h")
+        .upper()
+    )
+    m = get_bus_group_vid_pid(data)
+    output.write(
+        f"""/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+/* THIS FILE IS AUTOGENERATED BY build_progs_list.py ! */
+
+#ifndef {header_marker}
+#define {header_marker}
+
+{{
+	.id = {{
+		.bus = 0x{m.group(1)},
+		.group = 0x{m.group(2)},
+		.vendor = 0x{m.group(3)},
+		.product = 0x{m.group(4)},
+	}},
+	.map_cnt = {len(data['maps'])},
+	.prog_cnt = {len(data['progs'])},
+	.probe = {probe_idx},
+	.rodata = {rodata_idx},
+	.maps = {{""")
+
+    for map in data['maps']:
+         output.write(f"""
+		{{
+			.size = {map['size']},
+			.mmap_sz = {map['mmap_sz']},
+			.data = {write_c_data(map['data'])},
+		}},""")
+
+    output.write(f"""
+	}},
+	.data_sz = {data['data_sz']},
+	.data = {write_c_data(data['data'])},
+	.insns_sz = {data['insns_sz']},
+	.insns = {write_c_data(data['insns'])},
+}},
+
+#endif /* {header_marker} */
+"""
+    )
+
+
+def main():
+    ap = argparse.ArgumentParser(description="custom HID BPF json converter")
+
+    def add_output(parser):
+        parser.add_argument(
+            "-o",
+            "--output",
+            nargs="?",
+            type=argparse.FileType("w"),
+            default=sys.stdout,
+            help="Output file, if not given, use stdout",
+        )
+
+    sp = ap.add_subparsers(help="sub-command help")
+
+    obj_parser = sp.add_parser(
+        "build_prog", help="Convert a JSON into a generic HID BPF header"
+    )
+    obj_parser.add_argument("path", nargs=1, help="Input file.", metavar="PATH")
+    add_output(obj_parser)
+    obj_parser.set_defaults(func=build_c_object)
+
+    list_parser = sp.add_parser(
+        "build_list", help="Convert a list of JSON into a generic HID BPF header list"
+    )
+    list_parser.add_argument("path", nargs="*", help="Input file(s).", metavar="PATH")
+    add_output(list_parser)
+    list_parser.set_defaults(func=build_prog_list)
+
+    args = ap.parse_args()
+    args.func(args)
+
+
+if __name__ == "__main__":
+    main()
-- 
2.38.1

