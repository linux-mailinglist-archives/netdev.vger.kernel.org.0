Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F454530CC1
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbiEWKb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbiEWKbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:31:22 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BB9D2C1;
        Mon, 23 May 2022 03:31:21 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECA6511FB;
        Mon, 23 May 2022 03:31:20 -0700 (PDT)
Received: from e126130.arm.com (unknown [10.57.81.119])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 51E7B3F73D;
        Mon, 23 May 2022 03:31:17 -0700 (PDT)
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
Subject: [PATCH v2] libbpf: Fix determine_ptr_size() guessing
Date:   Mon, 23 May 2022 11:29:55 +0100
Message-Id: <20220523102955.43844-1-douglas.raillard@arm.com>
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
gcc and clang do not use the same name in debug info.

Lookup all the names for such a type so that libbpf can hope to find the
information it wants.

Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>
---
 tools/lib/bpf/btf.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

 CHANGELOG
	v2:
		* Added missing case for "long"

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 1383e26c5d1f..ab92b3bc2724 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -489,8 +489,19 @@ static int determine_ptr_size(const struct btf *btf)
 		if (!name)
 			continue;
 
-		if (strcmp(name, "long int") == 0 ||
-		    strcmp(name, "long unsigned int") == 0) {
+		if (
+			strcmp(name, "long") == 0 ||
+			strcmp(name, "long int") == 0 ||
+			strcmp(name, "int long") == 0 ||
+			strcmp(name, "unsigned long") == 0 ||
+			strcmp(name, "long unsigned") == 0 ||
+			strcmp(name, "unsigned long int") == 0 ||
+			strcmp(name, "unsigned int long") == 0 ||
+			strcmp(name, "long unsigned int") == 0 ||
+			strcmp(name, "long int unsigned") == 0 ||
+			strcmp(name, "int unsigned long") == 0 ||
+			strcmp(name, "int long unsigned") == 0
+		) {
 			if (t->size != 4 && t->size != 8)
 				continue;
 			return t->size;
-- 
2.25.1

