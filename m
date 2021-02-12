Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19ECF31A749
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhBLWFZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 12 Feb 2021 17:05:25 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:20718 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhBLWFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 17:05:24 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-PrnkyHyEOf2VmvzDyCpnUw-1; Fri, 12 Feb 2021 17:04:27 -0500
X-MC-Unique: PrnkyHyEOf2VmvzDyCpnUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7ADFC801965;
        Fri, 12 Feb 2021 22:04:24 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.193.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49D8C5C23D;
        Fri, 12 Feb 2021 22:04:21 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     dwarves@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] btf_encoder: Match ftrace addresses within elf functions
Date:   Fri, 12 Feb 2021 23:04:20 +0100
Message-Id: <20210212220420.1289014-1-jolsa@kernel.org>
In-Reply-To: <20210212135427.1250224-1-jolsa@redhat.com>
References: <20210212135427.1250224-1-jolsa@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when processing DWARF function, we check its entrypoint
against ftrace addresses, assuming that the ftrace address matches
with function's entrypoint.

This is not the case on some architectures as reported by Nathan
when building kernel on arm [1].

Fixing the check to take into account the whole function not
just the entrypoint.

Most of the is_ftrace_func code was contributed by Andrii.

[1] https://lore.kernel.org/bpf/20210209034416.GA1669105@ubuntu-m3-large-x86/
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 btf_encoder.c | 55 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 10 deletions(-)

diff --git a/btf_encoder.c b/btf_encoder.c
index b124ec20a689..03242f04c55d 100644
--- a/btf_encoder.c
+++ b/btf_encoder.c
@@ -36,6 +36,7 @@ struct funcs_layout {
 struct elf_function {
 	const char	*name;
 	unsigned long	 addr;
+	unsigned long	 size;
 	unsigned long	 sh_addr;
 	bool		 generated;
 };
@@ -98,6 +99,7 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
 
 	functions[functions_cnt].name = name;
 	functions[functions_cnt].addr = elf_sym__value(sym);
+	functions[functions_cnt].size = elf_sym__size(sym);
 	functions[functions_cnt].sh_addr = sh.sh_addr;
 	functions[functions_cnt].generated = false;
 	functions_cnt++;
@@ -236,6 +238,48 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
 	return 0;
 }
 
+static int is_ftrace_func(struct elf_function *func, __u64 *addrs,
+			  __u64 count, bool kmod)
+{
+	/*
+	 * For vmlinux image both addrs[x] and functions[x]::addr
+	 * values are final address and are comparable.
+	 *
+	 * For kernel module addrs[x] is final address, but
+	 * functions[x]::addr is relative address within section
+	 * and needs to be relocated by adding sh_addr.
+	 */
+	__u64 start = kmod ? func->addr + func->sh_addr : func->addr;
+	__u64 addr, end = func->addr + func->size;
+
+	/*
+	 * The invariant here is addr[r] that is the smallest address
+	 * that is >= than function start addr. Except the corner case
+	 * where there is no such r, but for that we have a final check
+	 * in the return.
+	 */
+	size_t l = 0, r = count - 1, m;
+
+	/* make sure we don't use invalid r */
+	if (count == 0)
+		return false;
+
+	while (l < r) {
+		m = l + (r - l) / 2;
+		addr = addrs[m];
+
+		if (addr >= start) {
+			/* we satisfy invariant, so tighten r */
+			r = m;
+		} else {
+			/* m is not good enough as l, maybe m + 1 will be */
+			l = m + 1;
+		}
+	}
+
+	return start <= addrs[r] && addrs[r] < end;
+}
+
 static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
 {
 	__u64 *addrs, count, i;
@@ -275,18 +319,9 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
 	 */
 	for (i = 0; i < functions_cnt; i++) {
 		struct elf_function *func = &functions[i];
-		/*
-		 * For vmlinux image both addrs[x] and functions[x]::addr
-		 * values are final address and are comparable.
-		 *
-		 * For kernel module addrs[x] is final address, but
-		 * functions[x]::addr is relative address within section
-		 * and needs to be relocated by adding sh_addr.
-		 */
-		__u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
 
 		/* Make sure function is within ftrace addresses. */
-		if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
+		if (is_ftrace_func(func, addrs, count, kmod)) {
 			/*
 			 * We iterate over sorted array, so we can easily skip
 			 * not valid item and move following valid field into
-- 
2.29.2

