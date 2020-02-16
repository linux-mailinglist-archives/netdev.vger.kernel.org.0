Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3D21605DC
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 20:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgBPTa1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 16 Feb 2020 14:30:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44795 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725989AbgBPTa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 14:30:27 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-in3Fuqo5OCqjY21H6HH3DA-1; Sun, 16 Feb 2020 14:30:20 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E2EE8014D2;
        Sun, 16 Feb 2020 19:30:18 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-28.brq.redhat.com [10.40.204.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF7FD8574E;
        Sun, 16 Feb 2020 19:30:13 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/18] x86/mm: Rename is_kernel_text to __is_kernel_text
Date:   Sun, 16 Feb 2020 20:29:48 +0100
Message-Id: <20200216193005.144157-2-jolsa@kernel.org>
In-Reply-To: <20200216193005.144157-1-jolsa@kernel.org>
References: <20200216193005.144157-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: in3Fuqo5OCqjY21H6HH3DA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kbuild test robot reported compile issue on x86 in one of
the following patches that adds <linux/kallsyms.h> include into
<linux/bpf.h>, which is picked up by init_32.c object.

The problem is that <linux/kallsyms.h> defines global function
is_kernel_text which colides with the static function of the
same name defined in init_32.c:

  $ make ARCH=i386
  ...
  >> arch/x86/mm/init_32.c:241:19: error: redefinition of 'is_kernel_text'
    static inline int is_kernel_text(unsigned long addr)
                      ^~~~~~~~~~~~~~
   In file included from include/linux/bpf.h:21:0,
                    from include/linux/bpf-cgroup.h:5,
                    from include/linux/cgroup-defs.h:22,
                    from include/linux/cgroup.h:28,
                    from include/linux/hugetlb.h:9,
                    from arch/x86/mm/init_32.c:18:
   include/linux/kallsyms.h:31:19: note: previous definition of 'is_kernel_text' was here
    static inline int is_kernel_text(unsigned long addr)

Renaming the init_32.c is_kernel_text function to __is_kernel_text.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/mm/init_32.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 23df4885bbed..eb6ede2c3d43 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -238,7 +238,11 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 	}
 }
 
-static inline int is_kernel_text(unsigned long addr)
+/*
+ * The <linux/kallsyms.h> already defines is_kernel_text,
+ * using '__' prefix not to get in conflict.
+ */
+static inline int __is_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_text && addr <= (unsigned long)__init_end)
 		return 1;
@@ -328,8 +332,8 @@ kernel_physical_mapping_init(unsigned long start,
 				addr2 = (pfn + PTRS_PER_PTE-1) * PAGE_SIZE +
 					PAGE_OFFSET + PAGE_SIZE-1;
 
-				if (is_kernel_text(addr) ||
-				    is_kernel_text(addr2))
+				if (__is_kernel_text(addr) ||
+				    __is_kernel_text(addr2))
 					prot = PAGE_KERNEL_LARGE_EXEC;
 
 				pages_2m++;
@@ -354,7 +358,7 @@ kernel_physical_mapping_init(unsigned long start,
 				 */
 				pgprot_t init_prot = __pgprot(PTE_IDENT_ATTR);
 
-				if (is_kernel_text(addr))
+				if (__is_kernel_text(addr))
 					prot = PAGE_KERNEL_EXEC;
 
 				pages_4k++;
@@ -881,7 +885,7 @@ static void mark_nxdata_nx(void)
 	 */
 	unsigned long start = PFN_ALIGN(_etext);
 	/*
-	 * This comes from is_kernel_text upper limit. Also HPAGE where used:
+	 * This comes from __is_kernel_text upper limit. Also HPAGE where used:
 	 */
 	unsigned long size = (((unsigned long)__init_end + HPAGE_SIZE) & HPAGE_MASK) - start;
 
-- 
2.24.1

