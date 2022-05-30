Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4C25381A9
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240885AbiE3OUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240898AbiE3OQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:16:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA0A1053FE;
        Mon, 30 May 2022 06:44:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60BC2B80DA7;
        Mon, 30 May 2022 13:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F054C385B8;
        Mon, 30 May 2022 13:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918244;
        bh=Y3ci4aj1bWHDsYuaG5QQrbA8DGau5DUCSDNwP7ULckA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lE2klOa+CQTZqzonW+57iFJqYhdVQVJvR91kW+SeOWXsTEOyXTu5n9B0YoMJlkXCA
         56vDus6PNbg7wywlbuVV7f/XjAB7RKPhrMOCN47e+pkuVbQutb3BbiGzTyNSBKE6Ep
         Ot5kBjKIGpajfAeHTg+H5V7fo1FBfVlP/jxxg7/sgFWtA5QnkUrvJCcHCG+VFRiVAB
         QBR4WkHVV3pAHFY/0MJ6hbwDK3EgxNXNLPdGbyi5J2nqi5on3hlXd7cF7+dB6LK/h2
         7SY0n/WLYUU9WeCt2Kqxnmug5nIuZLPs59Qov0BaaPQHhGYa9tiflqzJLKk0v16t+r
         z5BEcB09nlL1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, sunyucong@gmail.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 108/109] selftests/bpf: fix btf_dump/btf_dump due to recent clang change
Date:   Mon, 30 May 2022 09:38:24 -0400
Message-Id: <20220530133825.1933431-108-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 4050764cbaa25760aab40857f723393c07898474 ]

Latest llvm-project upstream had a change of behavior
related to qualifiers on function return type ([1]).
This caused selftests btf_dump/btf_dump failure.
The following example shows what changed.

  $ cat t.c
  typedef const char * const (* const (* const fn_ptr_arr2_t[5])())(char * (*)(int));
  struct t {
    int a;
    fn_ptr_arr2_t l;
  };
  int foo(struct t *arg) {
    return arg->a;
  }

Compiled with latest upstream llvm15,
  $ clang -O2 -g -target bpf -S -emit-llvm t.c
The related generated debuginfo IR looks like:
  !16 = !DIDerivedType(tag: DW_TAG_typedef, name: "fn_ptr_arr2_t", file: !1, line: 1, baseType: !17)
  !17 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 320, elements: !32)
  !18 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !19)
  !19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
  !20 = !DISubroutineType(types: !21)
  !21 = !{!22, null}
  !22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
  !23 = !DISubroutineType(types: !24)
  !24 = !{!25, !28}
  !25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
  !26 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
  !27 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
You can see two intermediate const qualifier to pointer are dropped in debuginfo IR.

With llvm14, we have following debuginfo IR:
  !16 = !DIDerivedType(tag: DW_TAG_typedef, name: "fn_ptr_arr2_t", file: !1, line: 1, baseType: !17)
  !17 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 320, elements: !34)
  !18 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !19)
  !19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
  !20 = !DISubroutineType(types: !21)
  !21 = !{!22, null}
  !22 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
  !23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
  !24 = !DISubroutineType(types: !25)
  !25 = !{!26, !30}
  !26 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
  !27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
  !28 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !29)
  !29 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
All const qualifiers are preserved.

To adapt the selftest to both old and new llvm, this patch removed
the intermediate const qualifier in const-to-ptr types, to make the
test succeed again.

  [1] https://reviews.llvm.org/D125919

Reported-by: Mykola Lysenko <mykolal@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20220523152044.3905809-1-yhs@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
index 8aaa24a00322..970598dda732 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
@@ -94,7 +94,7 @@ typedef void (* (*signal_t)(int, void (*)(int)))(int);
 
 typedef char * (*fn_ptr_arr1_t[10])(int **);
 
-typedef char * (* const (* const fn_ptr_arr2_t[5])())(char * (*)(int));
+typedef char * (* (* const fn_ptr_arr2_t[5])())(char * (*)(int));
 
 struct struct_w_typedefs {
 	int_t a;
-- 
2.35.1

