Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4CB567716
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbiGETD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiGETDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:03:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A5612AC9;
        Tue,  5 Jul 2022 12:03:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57695B81964;
        Tue,  5 Jul 2022 19:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA37C341CB;
        Tue,  5 Jul 2022 19:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657047795;
        bh=Chd/hn5c9l9LjiOyPasbS8Z43j0ED1ZBO8JNGbHGbo0=;
        h=From:To:Cc:Subject:Date:From;
        b=ZrzUydmCI33s1H4r/nX91mYToT4o0+7Xsve6O70QGw2hMrJIbprQfXpaEJ3chKn1a
         HVNd0lT4a+MAb9MLZ2ThVCGi4HmLL6V3ZmgS5ciRSk2FDOQYdGl7adFsTegwQDzZ2l
         CBziborylrwQSTHzjdMxW0MBjAszqUIAZWyuCxasle1N/khD8/cKRgD4xdnt9bLfns
         RJvwZD0ClKY9U4yRczaYOmQQrG537rOfcyAK1tfONVwwaRX8wMQU2J+1XVAnXZ2To3
         utDQELhNTegWvFPw1kejRSUHFzKYT1qkEbQZhgPMgq+gv9jD/lN+i1vdGyzfObmTpc
         f1OhIjnks64iA==
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
Subject: [PATCH RFC bpf-next 0/4] bpf: Fixes for CONFIG_X86_KERNEL_IBT 
Date:   Tue,  5 Jul 2022 21:03:04 +0200
Message-Id: <20220705190308.1063813-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
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

hi,
Martynas reported bpf_get_func_ip returning +4 address when
CONFIG_X86_KERNEL_IBT option is enabled and I found there are
some failing bpf tests when this option is enabled.

The CONFIG_X86_KERNEL_IBT option adds endbr instruction at the
function entry, so the idea is to 'fix' entry ip for kprobe_multi
and trampoline probes, because they are placed on the function
entry.

For kprobes I only fixed the bpf test program to adjust ip based
on CONFIG_X86_KERNEL_IBT option. I'm not sure what the right fix
should be in here, because I think user should be aware where the
kprobe is placed, on the other hand we move the kprobe address if
its placed on top of endbr instruction.

thanks,
jirka

---
Jiri Olsa (4):
      bpf: Adjust kprobe_multi entry_ip for CONFIG_X86_KERNEL_IBT
      bpf: Use given function address for trampoline ip arg
      selftests/bpf: Disable kprobe attach test with offset for CONFIG_X86_KERNEL_IBT
      selftests/bpf: Fix kprobe get_func_ip tests for kprobes

 arch/x86/net/bpf_jit_comp.c                               |  9 ++++-----
 kernel/trace/bpf_trace.c                                  |  3 +++
 kernel/trace/ftrace.c                                     |  3 +--
 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c | 25 ++++++++++++++++++++-----
 tools/testing/selftests/bpf/progs/get_func_ip_test.c      |  7 +++++--
 tools/testing/selftests/bpf/progs/kprobe_multi.c          |  2 +-
 6 files changed, 34 insertions(+), 15 deletions(-)
