Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE5110E373
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 21:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfLAU2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 15:28:05 -0500
Received: from hall.aurel32.net ([195.154.113.88]:55868 "EHLO hall.aurel32.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbfLAU2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Dec 2019 15:28:05 -0500
X-Greylist: delayed 1806 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Dec 2019 15:28:04 EST
Received: from [2a01:e35:2fdd:a4e1:fe91:fc89:bc43:b814] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <aurelien@aurel32.net>)
        id 1ibVLh-0005Nk-30; Sun, 01 Dec 2019 20:57:41 +0100
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.92.3)
        (envelope-from <aurelien@aurel32.net>)
        id 1ibVLg-00HScO-Hs; Sun, 01 Dec 2019 20:57:40 +0100
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     linux-kernel@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, debian-kernel@lists.debian.org,
        Aurelien Jarno <aurelien@aurel32.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools))
Subject: [PATCH] libbpf: fix readelf output parsing on powerpc with recent binutils
Date:   Sun,  1 Dec 2019 20:57:28 +0100
Message-Id: <20191201195728.4161537-1-aurelien@aurel32.net>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On powerpc with recent versions of binutils, readelf outputs an extra
field when dumping the symbols of an object file. For example:

    35: 0000000000000838    96 FUNC    LOCAL  DEFAULT [<localentry>: 8]     1 btf_is_struct

The extra "[<localentry>: 8]" prevents the GLOBAL_SYM_COUNT variable to
be computed correctly and causes the checkabi target to fail.

Fix that by looking for the symbol name in the last field instead of the
8th one. This way it should also cope with future extra fields.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
---
 tools/lib/bpf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 99425d0be6ff..333900cf3f4f 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -147,7 +147,7 @@ TAGS_PROG := $(if $(shell which etags 2>/dev/null),etags,ctags)
 
 GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
 			   cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
-			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}' | \
+			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
 			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf -s --wide $(OUTPUT)libbpf.so | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
@@ -216,7 +216,7 @@ check_abi: $(OUTPUT)libbpf.so
 		     "versioned in $(VERSION_SCRIPT)." >&2;		 \
 		readelf -s --wide $(OUTPUT)libbpf-in.o |		 \
 		    cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' |	 \
-		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}'|   \
+		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf -s --wide $(OUTPUT)libbpf.so |			 \
 		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
-- 
2.24.0

