Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2639328D61
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 20:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbhCATJY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Mar 2021 14:09:24 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:23989 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240859AbhCATF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 14:05:28 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-edM5UA9NMeiIOf2CMADLcw-1; Mon, 01 Mar 2021 14:04:25 -0500
X-MC-Unique: edM5UA9NMeiIOf2CMADLcw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0C67100A8EB;
        Mon,  1 Mar 2021 19:04:23 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11C4D10013C1;
        Mon,  1 Mar 2021 19:04:16 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>
Subject: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for powerpc uprobes
Date:   Mon,  1 Mar 2021 20:04:16 +0100
Message-Id: <20210301190416.90694-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
for powerpc arch.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index a0ee87c8e1ea..c3cfb48d3ed0 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -2,6 +2,22 @@
 #include <test_progs.h>
 #include "test_attach_probe.skel.h"
 
+#if defined(__powerpc64__)
+/*
+ * We get the GEP (Global Entry Point) address from kallsyms,
+ * but then the function is called locally, so we need to adjust
+ * the address to get LEP (Local Entry Point).
+ */
+#define LEP_OFFSET 8
+
+static ssize_t get_offset(ssize_t offset)
+{
+	return offset + LEP_OFFSET;
+}
+#else
+#define get_offset(offset) (offset)
+#endif
+
 ssize_t get_base_addr() {
 	size_t start, offset;
 	char buf[256];
@@ -36,7 +52,7 @@ void test_attach_probe(void)
 	if (CHECK(base_addr < 0, "get_base_addr",
 		  "failed to find base addr: %zd", base_addr))
 		return;
-	uprobe_offset = (size_t)&get_base_addr - base_addr;
+	uprobe_offset = get_offset((size_t)&get_base_addr - base_addr);
 
 	skel = test_attach_probe__open_and_load();
 	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
-- 
2.29.2

