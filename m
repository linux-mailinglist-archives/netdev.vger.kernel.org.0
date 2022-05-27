Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84E536846
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 22:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351447AbiE0U4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 16:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237744AbiE0U4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 16:56:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FA115FC0;
        Fri, 27 May 2022 13:56:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8CEEB82522;
        Fri, 27 May 2022 20:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F714C385A9;
        Fri, 27 May 2022 20:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653684979;
        bh=ouLxdfpPr93wSzVLMEJWXsalJLxfF1Dpqw0Ygd5TG3U=;
        h=From:To:Cc:Subject:Date:From;
        b=eLtrHsjt76J6u2ihrMzg64T6VTrtgYFZ7JyOqOBXFuLeXlkWIPtO+Uu8utoGSXkN9
         HAIhIOcB/8tgxaHVLoTQS8TLbSbeAfpdiWgHRg35b8sgeBRMDMiiQDwRUgAiSb7Fv2
         g2eIj40wujY2zKxDTY3Kq5rRz31aRjbuWgWLzsBoUWlsK3yHFEzO/0fUk/LtOL20UE
         mQ4iTKknT+6s3fraTmGwZBoAzEbYUXfwlF9jyQq5wdp27vMTjNn+yr64ssq2kkii3B
         2LDO3s7+YR/vo7KgoPejDWg2EOEFXMoXwwGzUNV5RZjaQ7ouVJrJYk3WTGgp8Bh0kf
         wEcFg5MK6Rm/g==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH bpf-next 0/3] bpf: Fix cookie values for kprobe multi
Date:   Fri, 27 May 2022 22:56:08 +0200
Message-Id: <20220527205611.655282-1-jolsa@kernel.org>
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
there's bug in kprobe_multi link that makes cookies misplaced when
using symbols to attach. The reason is that we sort symbols by name
but not adjacent cookie values. Current test did not find it because
bpf_fentry_test* are already sorted by name.

thanks,
jirka


---
Jiri Olsa (3):
      selftests/bpf: Shuffle cookies symbols in kprobe multi test
      ftrace: Keep address offset in ftrace_lookup_symbols
      bpf: Force cookies array to follow symbols sorting

 kernel/trace/bpf_trace.c                            | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 kernel/trace/ftrace.c                               | 13 +++++++++++--
 tools/testing/selftests/bpf/prog_tests/bpf_cookie.c | 78 +++++++++++++++++++++++++++++++++++++++---------------------------------------
 tools/testing/selftests/bpf/progs/kprobe_multi.c    | 24 ++++++++++++------------
 4 files changed, 112 insertions(+), 68 deletions(-)
