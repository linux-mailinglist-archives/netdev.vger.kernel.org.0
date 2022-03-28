Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7ED34E904C
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 10:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239437AbiC1Iiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 04:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiC1Iiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 04:38:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FC93C497;
        Mon, 28 Mar 2022 01:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 472F7B80EFF;
        Mon, 28 Mar 2022 08:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FD2C004DD;
        Mon, 28 Mar 2022 08:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648456629;
        bh=2FBmeLW7AhMRYwb0H5oB+VudLAfARIHjF7aGtQtAxao=;
        h=From:To:Cc:Subject:Date:From;
        b=tBCQhVUq24aySaOpMWxwq5o/79akHRDBwLZrlMYRcu+MVOUDSIqZwFtJ1OpI1uMLc
         ppDwDEtekoJY/GJmVutHfZPgF/iTcjrfxo4LEdVZWJEZ4fzJqKzGAtDv2KNXIOoZdr
         bjlcQD2zqN2Lou7E7BHwPVkFoiZArgFHjwOaVZzTff3yqjWQq6OBLpnYZ9nidfAPYS
         zl6tE2e93rc2crZq1X2G8iQHwYLSEs6kgJHj84I4BPgbJ62g0LtiOEs0xnWZHvZdhR
         iRvLTLiX/KCryl5yESfvJYFZ7Iza8dwoq+YtSZuDM0fBRsbtO2iUPSWIwSSdQ9O4bx
         2ii3zJ8r5n1bA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Delyan Kratunov <delyank@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH] bpftool: Fix generated code in codegen_asserts
Date:   Mon, 28 Mar 2022 10:37:03 +0200
Message-Id: <20220328083703.2880079-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnaldo reported perf compilation fail with:

  $ make -k BUILD_BPF_SKEL=1 CORESIGHT=1 PYTHON=python3
  ...
  In file included from util/bpf_counter.c:28:
  /tmp/build/perf//util/bpf_skel/bperf_leader.skel.h: In function ‘bperf_leader_bpf__assert’:
  /tmp/build/perf//util/bpf_skel/bperf_leader.skel.h:351:51: error: unused parameter ‘s’ [-Werror=unused-parameter]
    351 | bperf_leader_bpf__assert(struct bperf_leader_bpf *s)
        |                          ~~~~~~~~~~~~~~~~~~~~~~~~~^
  cc1: all warnings being treated as errors

If there's nothing to generate in the new assert function,
we will get unused 's' warn/error, adding 'unused' attribute to it.

Cc: Delyan Kratunov <delyank@fb.com>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Fixes: 08d4dba6ae77 ("bpftool: Bpf skeletons assert type sizes")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/bpftool/gen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 7ba7ff55d2ea..91af2850b505 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -477,7 +477,7 @@ static void codegen_asserts(struct bpf_object *obj, const char *obj_name)
 	codegen("\
 		\n\
 		__attribute__((unused)) static void			    \n\
-		%1$s__assert(struct %1$s *s)				    \n\
+		%1$s__assert(struct %1$s *s __attribute__((unused)))	    \n\
 		{							    \n\
 		#ifdef __cplusplus					    \n\
 		#define _Static_assert static_assert			    \n\
-- 
2.35.1

