Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C64F53EE0C
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 20:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbiFFSrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 14:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiFFSrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 14:47:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D62FEBEAC;
        Mon,  6 Jun 2022 11:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ED46B81821;
        Mon,  6 Jun 2022 18:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90D6C385A9;
        Mon,  6 Jun 2022 18:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654541257;
        bh=IsApZ6zYzRY50Wc6SfBfLjWAnjCwNGx9boMJlq2gXIg=;
        h=From:To:Cc:Subject:Date:From;
        b=qJx4AbhjIlATpvcSuVodvw9HfRzsKG6H3bj3UK7bnHTHPmhfIJHDGwk0EfacNOI+Q
         cK2hxwhi+iz/QOLrYuBHw/9MD6PPbuid4JLEt+46jb5LPJNniDmOo8/8Dkk9e9dh0y
         zciaNUYYt2Pa4S2wwWfPlYu7oXf/2p/DpVqwuFJMgKdlmpOgtkfhv3tU0QFVwU3MW2
         HrA9zHnwTq76Cy04KyYl+g+MqPUizQXn6+/sYLKfgHH0BJD0XGy4rrJc8cOjPQqef2
         rajRXXhTsBvvaekUuWOyxwXpWjG3Zr1YjddUZH1bKCiZ21xspGQgMXu1EB5QAhO19k
         AEm7JwzgPeE3g==
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
Subject: [PATCHv2 bpf 0/3] bpf: Fix cookie values for kprobe multi
Date:   Mon,  6 Jun 2022 20:47:28 +0200
Message-Id: <20220606184731.437300-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

v2 changes:
  - rebased on top of bpf/master
  - checking if cookies are defined later in swap function [Andrii]
  - added acks

thanks,
jirka


---
Jiri Olsa (3):
      selftests/bpf: Shuffle cookies symbols in kprobe multi test
      ftrace: Keep address offset in ftrace_lookup_symbols
      bpf: Force cookies array to follow symbols sorting

 kernel/trace/bpf_trace.c                            | 60 +++++++++++++++++++++++++++++++++++++++++++++---------------
 kernel/trace/ftrace.c                               | 13 +++++++++++--
 tools/testing/selftests/bpf/prog_tests/bpf_cookie.c | 78 +++++++++++++++++++++++++++++++++++++++---------------------------------------
 tools/testing/selftests/bpf/progs/kprobe_multi.c    | 24 ++++++++++++------------
 4 files changed, 107 insertions(+), 68 deletions(-)
