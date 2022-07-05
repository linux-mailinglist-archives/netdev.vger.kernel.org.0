Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7A6567729
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiGETEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiGETEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:04:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEAD13D02;
        Tue,  5 Jul 2022 12:04:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 893DDB8191A;
        Tue,  5 Jul 2022 19:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99ADC341CB;
        Tue,  5 Jul 2022 19:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657047846;
        bh=W3eA1geUi+YV4d0T8w/+tOwQe0Ftku7vR7YDIhjsfSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvVuE5bIQZGv3r56mXfWlKh5zOdx/BQ9qPfUxbrnS7nVhdwN/E4vNXKc+C8eR+AHr
         fUeLSKAjuwX1G951b34nxgTi8y83FwGl4uY8y13JHhKjc2Kn3wYtJfiNvSix4SegRF
         Q75/6qe9X2KcNnQqSrTVyNbo7/7g168XDU3kJ7SvlIi/97vIFrIMj9WSE16mO7W16w
         hNRqOxo8uOt+jAN6PyY8w93/HCCTc8WYc0lELaDxE8rgae8yPKgsXBtLGW7AFrznua
         hXyC9myf+4JHKiZgBdADHYNVR+Au16EH/qpcQhHCxkG3uwZzUkONGF2VGf+785BmJn
         PvL9MEdUi4ZJQ==
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
Subject: [PATCH RFC bpf-next 4/4] selftests/bpf: Fix kprobe get_func_ip tests for CONFIG_X86_KERNEL_IBT
Date:   Tue,  5 Jul 2022 21:03:08 +0200
Message-Id: <20220705190308.1063813-5-jolsa@kernel.org>
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

The kprobe can be placed anywhere and user must be aware
of the underlying instructions. Therefore fixing just
the bpf program to 'fix' the address to match the actual
function address when CONFIG_X86_KERNEL_IBT is enabled.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/progs/get_func_ip_test.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
index a587aeca5ae0..220d56b7c1dc 100644
--- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
+++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
@@ -2,6 +2,7 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
+#include <stdbool.h>
 
 char _license[] SEC("license") = "GPL";
 
@@ -13,6 +14,8 @@ extern const void bpf_modify_return_test __ksym;
 extern const void bpf_fentry_test6 __ksym;
 extern const void bpf_fentry_test7 __ksym;
 
+extern bool CONFIG_X86_KERNEL_IBT __kconfig __weak;
+
 __u64 test1_result = 0;
 SEC("fentry/bpf_fentry_test1")
 int BPF_PROG(test1, int a)
@@ -37,7 +40,7 @@ __u64 test3_result = 0;
 SEC("kprobe/bpf_fentry_test3")
 int test3(struct pt_regs *ctx)
 {
-	__u64 addr = bpf_get_func_ip(ctx);
+	__u64 addr = bpf_get_func_ip(ctx) - (CONFIG_X86_KERNEL_IBT ? 4 : 0);
 
 	test3_result = (const void *) addr == &bpf_fentry_test3;
 	return 0;
@@ -47,7 +50,7 @@ __u64 test4_result = 0;
 SEC("kretprobe/bpf_fentry_test4")
 int BPF_KRETPROBE(test4)
 {
-	__u64 addr = bpf_get_func_ip(ctx);
+	__u64 addr = bpf_get_func_ip(ctx) - (CONFIG_X86_KERNEL_IBT ? 4 : 0);
 
 	test4_result = (const void *) addr == &bpf_fentry_test4;
 	return 0;
-- 
2.35.3

