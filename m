Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0C96E76F
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 16:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbfGSOeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 10:34:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729578AbfGSOeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 10:34:23 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.35.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7596C2173B;
        Fri, 19 Jul 2019 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563546863;
        bh=oSFLKwsD4skurcFW4Mx1WOH1gBPJfSUipC/beA4xWu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1BzWMfsxjkLF9WEigY3E9sgL5Sf/Q4Hnl2RHCK5ZRmcxPddME1llBMtmT4UFYhR3
         SSthSn342g/Wdp+I/lirjQNRoFrwhJmckErAYSS86CDRDztzBDKMw6V3BIlKmJ1be5
         HmBLImQ0Zxq9+eJgP/RHXR6yLSbLuJXTPxzclzF4=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Clark Williams <williams@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 1/2] libbpf: Fix endianness macro usage for some compilers
Date:   Fri, 19 Jul 2019 11:34:06 -0300
Message-Id: <20190719143407.20847-2-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719143407.20847-1-acme@kernel.org>
References: <20190719143407.20847-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using endian.h and its endianness macros makes this code build in a
wider range of compilers, as some don't have those macros
(__BYTE_ORDER__, __ORDER_LITTLE_ENDIAN__, __ORDER_BIG_ENDIAN__),
so use instead endian.h's macros (__BYTE_ORDER, __LITTLE_ENDIAN,
__BIG_ENDIAN) which makes this code even shorter :-)

Acked-by: Andrii Nakryiko <andriin@fb.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Fixes: 12ef5634a855 ("libbpf: simplify endianness check")
Fixes: e6c64855fd7a ("libbpf: add btf__parse_elf API to load .BTF and .BTF.ext")
Link: https://lkml.kernel.org/n/tip-eep5n8vgwcdphw3uc058k03u@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/bpf/btf.c    | 5 +++--
 tools/lib/bpf/libbpf.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 467224feb43b..d821107f55f9 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
 /* Copyright (c) 2018 Facebook */
 
+#include <endian.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -419,9 +420,9 @@ struct btf *btf__new(__u8 *data, __u32 size)
 
 static bool btf_check_endianness(const GElf_Ehdr *ehdr)
 {
-#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#if __BYTE_ORDER == __LITTLE_ENDIAN
 	return ehdr->e_ident[EI_DATA] == ELFDATA2LSB;
-#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+#elif __BYTE_ORDER == __BIG_ENDIAN
 	return ehdr->e_ident[EI_DATA] == ELFDATA2MSB;
 #else
 # error "Unrecognized __BYTE_ORDER__"
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 794dd5064ae8..b1dec5b1de54 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -20,6 +20,7 @@
 #include <inttypes.h>
 #include <string.h>
 #include <unistd.h>
+#include <endian.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <asm/unistd.h>
@@ -612,10 +613,10 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 
 static int bpf_object__check_endianness(struct bpf_object *obj)
 {
-#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#if __BYTE_ORDER == __LITTLE_ENDIAN
 	if (obj->efile.ehdr.e_ident[EI_DATA] == ELFDATA2LSB)
 		return 0;
-#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+#elif __BYTE_ORDER == __BIG_ENDIAN
 	if (obj->efile.ehdr.e_ident[EI_DATA] == ELFDATA2MSB)
 		return 0;
 #else
-- 
2.21.0

