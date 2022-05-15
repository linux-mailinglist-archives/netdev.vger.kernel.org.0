Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7195279F0
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 22:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238667AbiEOUh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 16:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238665AbiEOUhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 16:37:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4673B12600;
        Sun, 15 May 2022 13:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEE1FB80DDB;
        Sun, 15 May 2022 20:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6354EC385B8;
        Sun, 15 May 2022 20:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652647030;
        bh=RcJBgCp3hjncPUbVdOsuPx3xKTW8fhv7TADAmDBK+xI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxBo9+mUw16uIlgNo88CdSL25AKVNnpiSvqHVaNCOliKw93XjS8R/iCJJTONvmvqx
         G02kCfjC9uVx+u0REvA2u6zSD6BiZCpgtgrOABPVufcegvqAUXwgL8DaeK2PKs7Gr0
         CSgLbbq2e7tvbwbvOblmxX8a+E52tBf3u+QBx6udVV45MmgVOu0JRa3iV+uw+tVBs2
         TmKDBnpcK90B4c6EZQoFrzQwf3oQ9NzkcEBCE7TnuCgq2C0aQICWCj7e/1d8PR3Fus
         F4ChvoAjFU+vjK+YL5aShXrQoBtdRzgV2GuAyEz0cEEudd3I2wl1nb68jHbUFeEek6
         4zCIpt9s2uJQg==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH bpf-next 2/2] selftests/bpf: Remove filter for unsafe functions in kprobe_multi test
Date:   Sun, 15 May 2022 22:36:53 +0200
Message-Id: <20220515203653.4039075-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220515203653.4039075-1-jolsa@kernel.org>
References: <20220515203653.4039075-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removing filter for arch_cpu_idle and rcu_* functions.

Attaching to them was causing RCU warnings [1]:

  [    3.017540] WARNING: suspicious RCU usage
  ...
  [    3.018363]  kprobe_multi_link_handler+0x68/0x1c0
  [    3.018364]  ? kprobe_multi_link_handler+0x3e/0x1c0
  [    3.018366]  ? arch_cpu_idle_dead+0x10/0x10
  [    3.018367]  ? arch_cpu_idle_dead+0x10/0x10
  [    3.018371]  fprobe_handler.part.0+0xab/0x150
  [    3.018374]  0xffffffffa00080c8
  [    3.018393]  ? arch_cpu_idle+0x5/0x10
  [    3.018398]  arch_cpu_idle+0x5/0x10
  [    3.018399]  default_idle_call+0x59/0x90
  [    3.018401]  do_idle+0x1c3/0x1d0

With previous fix the functions causing that are no longer attachable.

[1] https://lore.kernel.org/bpf/CAEf4BzYtXWvBWzmadhLGqwf8_e2sruK6999th6c=b=O0WLkHOA@mail.gmail.com/
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/kprobe_multi_test.c       | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index 586dc52d6fb9..8bb974c263c3 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -354,16 +354,6 @@ static int get_syms(char ***symsp, size_t *cntp)
 			continue;
 		if (sscanf(buf, "%ms$*[^\n]\n", &name) != 1)
 			continue;
-		/*
-		 * We attach to almost all kernel functions and some of them
-		 * will cause 'suspicious RCU usage' when fprobe is attached
-		 * to them. Filter out the current culprits - arch_cpu_idle
-		 * and rcu_* functions.
-		 */
-		if (!strcmp(name, "arch_cpu_idle"))
-			continue;
-		if (!strncmp(name, "rcu_", 4))
-			continue;
 		err = hashmap__add(map, name, NULL);
 		if (err) {
 			free(name);
-- 
2.35.3

