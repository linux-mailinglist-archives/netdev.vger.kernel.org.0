Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CAE5900BE
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbiHKPq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbiHKPpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:45:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356158C46E;
        Thu, 11 Aug 2022 08:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA0D6B82151;
        Thu, 11 Aug 2022 15:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE73FC433D6;
        Thu, 11 Aug 2022 15:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232369;
        bh=unky3ptO3FDMumLgteG75EQI1lgFJwkv56YH0pqh2BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZIXKIMivxQxH6dAbtol5a5PPdJVaqyT4nrDSbb8KPJ0aXVoqDFDGffJ3JdZcj/W1
         cmbWW69h4x9wSc5SwzjNTfZLSbLboWAJWcNiJuq1rmNWudouqGlSJM7I5jKf/OasyM
         Ue3K/TT77odDeAy96MdIYsgGU4sAxDsLCVPW2gZZKAUOJIf/LYf05bl8t9E5BDBivj
         iSdHFl7L08/w84K6DY/Jdqyjcvzxne/V2yDJHm2cEE/M9V546tMmFO9e32itfZhrwo
         eo491eznnDTNdFCe2s7nDHjV9e1OKYs33Wuc5PZpE0KT+GQFRTyNtV9yL8goS1wudf
         uesQA13KhElSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        daniel@iogearbox.net, shuah@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 071/105] selftests/bpf: Do not attach kprobe_multi bench to bpf_dispatcher_xdp_func
Date:   Thu, 11 Aug 2022 11:27:55 -0400
Message-Id: <20220811152851.1520029-71-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 7fb27a56b9ebd8a77d9dd188e8a42bff99bc3443 ]

Alexei reported crash by running test_progs -j on system
with 32 cpus.

It turned out the kprobe_multi bench test that attaches all
ftrace-able functions will race with bpf_dispatcher_update,
that calls bpf_arch_text_poke on bpf_dispatcher_xdp_func,
which is ftrace-able function.

Ftrace is not aware of this update so this will cause
ftrace_bug with:

  WARNING: CPU: 6 PID: 1985 at
  arch/x86/kernel/ftrace.c:94 ftrace_verify_code+0x27/0x50
  ...
  ftrace_replace_code+0xa3/0x170
  ftrace_modify_all_code+0xbd/0x150
  ftrace_startup_enable+0x3f/0x50
  ftrace_startup+0x98/0xf0
  register_ftrace_function+0x20/0x60
  register_fprobe_ips+0xbb/0xd0
  bpf_kprobe_multi_link_attach+0x179/0x430
  __sys_bpf+0x18a1/0x2440
  ...
  ------------[ ftrace bug ]------------
  ftrace failed to modify
  [<ffffffff818d9380>] bpf_dispatcher_xdp_func+0x0/0x10
   actual:   ffffffe9:7b:ffffff9c:77:1e
  Setting ftrace call site to call ftrace function

It looks like we need some way to hide some functions
from ftrace, but meanwhile we workaround this by skipping
bpf_dispatcher_xdp_func from kprobe_multi bench test.

Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20220714082316.479181-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index 5b93d5d0bd93..48681bf73e0b 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -364,6 +364,8 @@ static int get_syms(char ***symsp, size_t *cntp)
 			continue;
 		if (!strncmp(name, "rcu_", 4))
 			continue;
+		if (!strcmp(name, "bpf_dispatcher_xdp_func"))
+			continue;
 		if (!strncmp(name, "__ftrace_invalid_address__",
 			     sizeof("__ftrace_invalid_address__") - 1))
 			continue;
-- 
2.35.1

