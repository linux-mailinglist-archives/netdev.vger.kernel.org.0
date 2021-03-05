Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1938232EC6B
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 14:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhCENlf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Mar 2021 08:41:35 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:40424 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229750AbhCENlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 08:41:05 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-DqrQ0yZ5PqOvooL5r5B_Mg-1; Fri, 05 Mar 2021 08:41:00 -0500
X-MC-Unique: DqrQ0yZ5PqOvooL5r5B_Mg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4463D1842144;
        Fri,  5 Mar 2021 13:40:58 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.196.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A254718AD6;
        Fri,  5 Mar 2021 13:40:51 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>
Subject: [PATCHv2 bpf-next] selftests/bpf: Fix test_attach_probe for powerpc uprobes
Date:   Fri,  5 Mar 2021 14:40:50 +0100
Message-Id: <20210305134050.139840-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When testing uprobes we the test gets GEP (Global Entry Point)
address from kallsyms, but then the function is called locally
so the uprobe is not triggered.

Fixing this by adjusting the address to LEP (Local Entry Point)
for powerpc arch plus instruction check stolen from ppc_function_entry
function pointed out and explained by Michael and Naveen.

Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/attach_probe.c   | 40 ++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index a0ee87c8e1ea..9dc4e3dfbcf3 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -2,6 +2,44 @@
 #include <test_progs.h>
 #include "test_attach_probe.skel.h"
 
+#if defined(__powerpc64__) && defined(_CALL_ELF) && _CALL_ELF == 2
+
+#define OP_RT_RA_MASK   0xffff0000UL
+#define LIS_R2          0x3c400000UL
+#define ADDIS_R2_R12    0x3c4c0000UL
+#define ADDI_R2_R2      0x38420000UL
+
+static ssize_t get_offset(ssize_t addr, ssize_t base)
+{
+	u32 *insn = (u32 *) addr;
+
+	/*
+	 * A PPC64 ABIv2 function may have a local and a global entry
+	 * point. We need to use the local entry point when patching
+	 * functions, so identify and step over the global entry point
+	 * sequence.
+	 *
+	 * The global entry point sequence is always of the form:
+	 *
+	 * addis r2,r12,XXXX
+	 * addi  r2,r2,XXXX
+	 *
+	 * A linker optimisation may convert the addis to lis:
+	 *
+	 * lis   r2,XXXX
+	 * addi  r2,r2,XXXX
+	 */
+	if ((((*insn & OP_RT_RA_MASK) == ADDIS_R2_R12) ||
+	     ((*insn & OP_RT_RA_MASK) == LIS_R2)) &&
+	    ((*(insn + 1) & OP_RT_RA_MASK) == ADDI_R2_R2))
+		return (ssize_t)(insn + 2) - base;
+	else
+		return addr - base;
+}
+#else
+#define get_offset(addr, base) (addr - base)
+#endif
+
 ssize_t get_base_addr() {
 	size_t start, offset;
 	char buf[256];
@@ -36,7 +74,7 @@ void test_attach_probe(void)
 	if (CHECK(base_addr < 0, "get_base_addr",
 		  "failed to find base addr: %zd", base_addr))
 		return;
-	uprobe_offset = (size_t)&get_base_addr - base_addr;
+	uprobe_offset = get_offset((size_t)&get_base_addr, base_addr);
 
 	skel = test_attach_probe__open_and_load();
 	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
-- 
2.27.0

