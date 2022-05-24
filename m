Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CBE5326BB
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 11:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235835AbiEXJox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 05:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiEXJow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 05:44:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6239752E5F;
        Tue, 24 May 2022 02:44:51 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDF9D1FB;
        Tue, 24 May 2022 02:44:50 -0700 (PDT)
Received: from e126130.arm.com (unknown [10.57.82.248])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4C7313F73D;
        Tue, 24 May 2022 02:44:44 -0700 (PDT)
From:   Douglas RAILLARD <douglas.raillard@arm.com>
To:     bpf@vger.kernel.org
Cc:     beata.michalska@arm.com,
        Douglas Raillard <douglas.raillard@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH v3] libbpf: Fix determine_ptr_size() guessing
Date:   Tue, 24 May 2022 10:44:47 +0100
Message-Id: <20220524094447.332186-1-douglas.raillard@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Douglas Raillard <douglas.raillard@arm.com>

One strategy employed by libbpf to guess the pointer size is by finding
the size of "unsigned long" type. This is achieved by looking for a type
of with the expected name and checking its size.

Unfortunately, the C syntax is friendlier to humans than to computers
as there is some variety in how such a type can be named. Specifically,
gcc and clang do not use the same names for integer types in debug info:

    - clang uses "unsigned long"
    - gcc uses "long unsigned int"

Lookup all the names for such a type so that libbpf can hope to find the
information it wants.

Acked-by: Yonghong Song <yhs@fb.com> 
Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>
---
 tools/lib/bpf/btf.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

 CHANGELOG
    v2:
        * Added missing case for "long"
    v3:
        * Refactor a bit to use a table
        * Provide the type names used by gcc and clang in commit msg

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 1383e26c5d1f..65c492a6807f 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -470,12 +470,25 @@ const struct btf_type *btf__type_by_id(const struct btf *btf, __u32 type_id)
 	return btf_type_by_id((struct btf *)btf, type_id);
 }
 
+static const char * const long_aliases[] = {
+	"long",
+	"long int",
+	"int long",
+	"unsigned long",
+	"long unsigned",
+	"unsigned long int",
+	"unsigned int long",
+	"long unsigned int",
+	"long int unsigned",
+	"int unsigned long",
+	"int long unsigned",
+};
+
 static int determine_ptr_size(const struct btf *btf)
 {
 	const struct btf_type *t;
 	const char *name;
-	int i, n;
-
+	int i, j, n;
 	if (btf->base_btf && btf->base_btf->ptr_sz > 0)
 		return btf->base_btf->ptr_sz;
 
@@ -489,12 +502,12 @@ static int determine_ptr_size(const struct btf *btf)
 		if (!name)
 			continue;
 
-		if (strcmp(name, "long int") == 0 ||
-		    strcmp(name, "long unsigned int") == 0) {
-			if (t->size != 4 && t->size != 8)
-				continue;
-			return t->size;
-		}
+		if (t->size != 4 && t->size != 8)
+			continue;
+
+		for (j = 0; j < ARRAY_SIZE(long_aliases); j++)
+			if (!strcmp(name, long_aliases[j]))
+				return t->size;
 	}
 
 	return -1;
-- 
2.25.1

