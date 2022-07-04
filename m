Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37EAD565915
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 16:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbiGDO4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 10:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbiGDO4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 10:56:21 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD73411176;
        Mon,  4 Jul 2022 07:56:10 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAAFB150C;
        Mon,  4 Jul 2022 07:56:10 -0700 (PDT)
Received: from e124483.cambridge.arm.com (e124483.cambridge.arm.com [10.1.29.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9972A3F792;
        Mon,  4 Jul 2022 07:56:07 -0700 (PDT)
From:   Andrew Kilroy <andrew.kilroy@arm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     Andrew Kilroy <andrew.kilroy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tom Rix <trix@redhat.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH 6/8] perf libunwind: arm64 pointer authentication
Date:   Mon,  4 Jul 2022 15:53:30 +0100
Message-Id: <20220704145333.22557-7-andrew.kilroy@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220704145333.22557-1-andrew.kilroy@arm.com>
References: <20220704145333.22557-1-andrew.kilroy@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of new changes in libunwind to decode a pointer which has a
pointer authentication code (PAC) in it.

Before this patch, perf is not able to produce stack traces where the
instruction addresses had PACs in them.

This commit has a dependency on a libunwind pull request:

  https://github.com/libunwind/libunwind/pull/360

Signed-off-by: Andrew Kilroy <andrew.kilroy@arm.com>
---
 tools/perf/util/unwind-libunwind-local.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/util/unwind-libunwind-local.c b/tools/perf/util/unwind-libunwind-local.c
index 6e5b8cce47bf..6983a3e76a71 100644
--- a/tools/perf/util/unwind-libunwind-local.c
+++ b/tools/perf/util/unwind-libunwind-local.c
@@ -652,6 +652,15 @@ static void display_error(int err)
 	}
 }
 
+#ifndef NO_LIBUNWIND_ARM64_PTRAUTH
+static unw_word_t get_insn_mask(unw_addr_space_t addr_space __maybe_unused, void *unwind_info_ptr)
+{
+	struct unwind_info *ui = unwind_info_ptr;
+	unw_word_t mask = ui->sample->ptrauth.insn_mask;
+	return mask;
+}
+#endif
+
 static unw_accessors_t accessors = {
 	.find_proc_info		= find_proc_info,
 	.put_unwind_info	= put_unwind_info,
@@ -661,6 +670,9 @@ static unw_accessors_t accessors = {
 	.access_fpreg		= access_fpreg,
 	.resume			= resume,
 	.get_proc_name		= get_proc_name,
+#ifndef NO_LIBUNWIND_ARM64_PTRAUTH
+	.ptrauth_insn_mask	= get_insn_mask,
+#endif
 };
 
 static int _unwind__prepare_access(struct maps *maps)
-- 
2.17.1

