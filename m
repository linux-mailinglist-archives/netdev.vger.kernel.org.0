Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD856771E
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbiGETEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbiGETD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:03:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69616CE1C;
        Tue,  5 Jul 2022 12:03:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16306B8191D;
        Tue,  5 Jul 2022 19:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8322EC341C7;
        Tue,  5 Jul 2022 19:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657047833;
        bh=y72XdUI/sjSXjaw9WSqjzwHIIFgTvSXemkRNtZGBq5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jo4nf14tx155OTzX1S9ukdTXYuPoTwaPn2rQnrBSNSsFHoheyiIdEJVZf+SDy0lhZ
         RERz0L5LkK/HkryqsgYQixqesGGnI4Gq2D+pT6Itb+dZwNJG7JyNlcgKgKWM47rlL1
         aAMoRIjM0mbMY0Sj3tFjYThcnLkAN9eOpgSxkrAL7II93kuMkaGNCqjIsTaAD9Y1Rf
         LssJK02gK2OXFCtKmPBL0ZtgCUxheDiE0t1/OXyX9/2U0YThhyhRAmHy3fKVQjODzL
         Ob3BOqAJXgyLljJaQQ72LirvZ2Hti5HGdfdIKvQe0RvsMaxXxj3chnKmqrB1fnGlRb
         jouTQaNxtrhHw==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        Yutaro Hayakawa <yutaro.hayakawa@isovalent.com>
Subject: [PATCH RFC bpf-next 3/4] selftests/bpf: Disable kprobe attach test with offset for CONFIG_X86_KERNEL_IBT
Date:   Tue,  5 Jul 2022 21:03:07 +0200
Message-Id: <20220705190308.1063813-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220705190308.1063813-1-jolsa@kernel.org>
References: <20220705190308.1063813-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attach like 'kprobe/bpf_fentry_test6+0x5' will fail to attach
when CONFIG_X86_KERNEL_IBT option is enabled because of the
endbr instruction at the function entry.

We would need to do manual attach with offset calculation based
on the CONFIG_X86_KERNEL_IBT option, which does not seem worth
the effort to me.

Disabling these test when CONFIG_X86_KERNEL_IBT is enabled.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/get_func_ip_test.c         | 25 +++++++++++++++----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c b/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
index 938dbd4d7c2f..cb0b78fb29df 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
@@ -2,6 +2,24 @@
 #include <test_progs.h>
 #include "get_func_ip_test.skel.h"
 
+/* assume IBT is enabled when kernel configs are not available */
+#ifdef HAVE_GENHDR
+# include "autoconf.h"
+#else
+#  define CONFIG_X86_KERNEL_IBT 1
+#endif
+
+/* test6 and test7 are x86_64 specific because of the instruction
+ * offset, disabling it for all other archs
+ *
+ * CONFIG_X86_KERNEL_IBT adds endbr instruction at function entry,
+ * so disabling test6 and test7, because the offset is hardcoded
+ * in program section
+ */
+#if !defined(__x86_64__) || defined(CONFIG_X86_KERNEL_IBT)
+#define DISABLE_OFFSET_ATTACH 1
+#endif
+
 void test_get_func_ip_test(void)
 {
 	struct get_func_ip_test *skel = NULL;
@@ -12,10 +30,7 @@ void test_get_func_ip_test(void)
 	if (!ASSERT_OK_PTR(skel, "get_func_ip_test__open"))
 		return;
 
-	/* test6 is x86_64 specifc because of the instruction
-	 * offset, disabling it for all other archs
-	 */
-#ifndef __x86_64__
+#if defined(DISABLE_OFFSET_ATTACH)
 	bpf_program__set_autoload(skel->progs.test6, false);
 	bpf_program__set_autoload(skel->progs.test7, false);
 #endif
@@ -43,7 +58,7 @@ void test_get_func_ip_test(void)
 	ASSERT_EQ(skel->bss->test3_result, 1, "test3_result");
 	ASSERT_EQ(skel->bss->test4_result, 1, "test4_result");
 	ASSERT_EQ(skel->bss->test5_result, 1, "test5_result");
-#ifdef __x86_64__
+#if !defined(DISABLE_OFFSET_ATTACH)
 	ASSERT_EQ(skel->bss->test6_result, 1, "test6_result");
 	ASSERT_EQ(skel->bss->test7_result, 1, "test7_result");
 #endif
-- 
2.35.3

