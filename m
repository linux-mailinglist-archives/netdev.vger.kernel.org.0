Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC301FAD6E
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgFPKFv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Jun 2020 06:05:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24096 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728264AbgFPKFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:05:51 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-DMGxkoffOPON-Fih67QkUw-1; Tue, 16 Jun 2020 06:05:42 -0400
X-MC-Unique: DMGxkoffOPON-Fih67QkUw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99EE618A2671;
        Tue, 16 Jun 2020 10:05:40 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFBC65D994;
        Tue, 16 Jun 2020 10:05:35 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 04/11] bpf: Resolve BTF IDs in vmlinux image
Date:   Tue, 16 Jun 2020 12:05:05 +0200
Message-Id: <20200616100512.2168860-5-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-1-jolsa@kernel.org>
References: <20200616100512.2168860-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Run btfid on vmlinux object during linking, so the
.BTF_ids section is processed and IDs are resolved.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Makefile                 |  3 ++-
 include/linux/bpf.h      |  5 +++++
 kernel/bpf/btf_ids.c     | 12 ++++++++++++
 kernel/trace/bpf_trace.c |  2 --
 net/core/filter.c        |  2 --
 scripts/link-vmlinux.sh  |  6 ++++++
 6 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index b190d502d7d7..889d909fd71a 100644
--- a/Makefile
+++ b/Makefile
@@ -448,6 +448,7 @@ OBJSIZE		= $(CROSS_COMPILE)size
 STRIP		= $(CROSS_COMPILE)strip
 endif
 PAHOLE		= pahole
+BTFID		= $(srctree)/tools/bpf/btfid/btfid
 LEX		= flex
 YACC		= bison
 AWK		= awk
@@ -524,7 +525,7 @@ GCC_PLUGINS_CFLAGS :=
 CLANG_FLAGS :=
 
 export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC
-export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE LEX YACC AWK INSTALLKERNEL
+export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE BTFID LEX YACC AWK INSTALLKERNEL
 export PERL PYTHON PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
 export _GZIP _BZIP2 _LZOP LZMA LZ4 XZ
 export KBUILD_HOSTCXXFLAGS KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS LDFLAGS_MODULE
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 07052d44bca1..f18c23dcc858 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1743,4 +1743,9 @@ enum bpf_text_poke_type {
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *addr1, void *addr2);
 
+extern int bpf_skb_output_btf_ids[];
+extern int bpf_seq_printf_btf_ids[];
+extern int bpf_seq_write_btf_ids[];
+extern int bpf_xdp_output_btf_ids[];
+
 #endif /* _LINUX_BPF_H */
diff --git a/kernel/bpf/btf_ids.c b/kernel/bpf/btf_ids.c
index e7f9d94ad293..d8d0df162f04 100644
--- a/kernel/bpf/btf_ids.c
+++ b/kernel/bpf/btf_ids.c
@@ -1,3 +1,15 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include "btf_ids.h"
+
+BTF_ID_LIST(bpf_skb_output_btf_ids)
+BTF_ID(struct, sk_buff)
+
+BTF_ID_LIST(bpf_seq_printf_btf_ids)
+BTF_ID(struct, seq_file)
+
+BTF_ID_LIST(bpf_seq_write_btf_ids)
+BTF_ID(struct, seq_file)
+
+BTF_ID_LIST(bpf_xdp_output_btf_ids)
+BTF_ID(struct, xdp_buff)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 3744372a24e2..c1866d76041f 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -667,7 +667,6 @@ BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
 	return err;
 }
 
-static int bpf_seq_printf_btf_ids[5];
 static const struct bpf_func_proto bpf_seq_printf_proto = {
 	.func		= bpf_seq_printf,
 	.gpl_only	= true,
@@ -685,7 +684,6 @@ BPF_CALL_3(bpf_seq_write, struct seq_file *, m, const void *, data, u32, len)
 	return seq_write(m, data, len) ? -EOVERFLOW : 0;
 }
 
-static int bpf_seq_write_btf_ids[5];
 static const struct bpf_func_proto bpf_seq_write_proto = {
 	.func		= bpf_seq_write,
 	.gpl_only	= true,
diff --git a/net/core/filter.c b/net/core/filter.c
index 209482a4eaa2..440e52061be8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3775,7 +3775,6 @@ static const struct bpf_func_proto bpf_skb_event_output_proto = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
-static int bpf_skb_output_btf_ids[5];
 const struct bpf_func_proto bpf_skb_output_proto = {
 	.func		= bpf_skb_event_output,
 	.gpl_only	= true,
@@ -4169,7 +4168,6 @@ static const struct bpf_func_proto bpf_xdp_event_output_proto = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
-static int bpf_xdp_output_btf_ids[5];
 const struct bpf_func_proto bpf_xdp_output_proto = {
 	.func		= bpf_xdp_event_output,
 	.gpl_only	= true,
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 57cb14bd8925..99a3f8c65e84 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -336,6 +336,12 @@ fi
 
 vmlinux_link vmlinux "${kallsymso}" ${btf_vmlinux_bin_o}
 
+# fill in BTF IDs
+if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
+info BTFID vmlinux
+${BTFID} vmlinux
+fi
+
 if [ -n "${CONFIG_BUILDTIME_TABLE_SORT}" ]; then
 	info SORTTAB vmlinux
 	if ! sorttable vmlinux; then
-- 
2.25.4

