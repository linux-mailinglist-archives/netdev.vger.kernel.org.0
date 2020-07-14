Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E571A21EDE9
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 12:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgGNKZu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 Jul 2020 06:25:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33820 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725955AbgGNKZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 06:25:50 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-f3qbhDeFMLmPdKJy0VcQUw-1; Tue, 14 Jul 2020 06:25:44 -0400
X-MC-Unique: f3qbhDeFMLmPdKJy0VcQUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86C9E2CCE;
        Tue, 14 Jul 2020 10:25:42 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.193.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D8B4710AD;
        Tue, 14 Jul 2020 10:25:39 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     kernel test robot <lkp@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 2/2] bpf: Fix cross build for CONFIG_DEBUG_INFO_BTF option
Date:   Tue, 14 Jul 2020 12:25:34 +0200
Message-Id: <20200714102534.299280-2-jolsa@kernel.org>
In-Reply-To: <20200714102534.299280-1-jolsa@kernel.org>
References: <20200714102534.299280-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen and 0-DAY CI Kernel Test Service reported broken cross build
for arm (arm-linux-gnueabi-gcc (GCC) 9.3.0), with following output:

   /tmp/ccMS5uth.s: Assembler messages:
   /tmp/ccMS5uth.s:69: Error: unrecognized symbol type ""
   /tmp/ccMS5uth.s:82: Error: unrecognized symbol type ""

Having '@object' for .type  diretive is  wrong because '@' is comment
character for some architectures. Using STT_OBJECT instead that should
work everywhere.

Also using HOST* variables to build resolve_btfids so it's properly
build in crossbuilds (stolen from objtool's Makefile).

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/btf_ids.h           |  2 +-
 tools/bpf/resolve_btfids/Makefile | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index b3c73db9587c..1cdb56950ffe 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -23,7 +23,7 @@
 asm(							\
 ".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
 ".local " #symbol " ;                          \n"	\
-".type  " #symbol ", @object;                  \n"	\
+".type  " #symbol ", STT_OBJECT;               \n"	\
 ".size  " #symbol ", 4;                        \n"	\
 #symbol ":                                     \n"	\
 ".zero 4                                       \n"	\
diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index 948378ca73d4..a88cd4426398 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -16,6 +16,20 @@ else
   MAKEFLAGS=--no-print-directory
 endif
 
+# always use the host compiler
+ifneq ($(LLVM),)
+HOSTAR  ?= llvm-ar
+HOSTCC  ?= clang
+HOSTLD  ?= ld.lld
+else
+HOSTAR  ?= ar
+HOSTCC  ?= gcc
+HOSTLD  ?= ld
+endif
+AR       = $(HOSTAR)
+CC       = $(HOSTCC)
+LD       = $(HOSTLD)
+
 OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
 
 LIBBPF_SRC := $(srctree)/tools/lib/bpf/
-- 
2.25.4

