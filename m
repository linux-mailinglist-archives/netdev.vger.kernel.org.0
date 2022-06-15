Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F336854C745
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 13:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242385AbiFOLV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 07:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237849AbiFOLVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 07:21:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07D540A3A;
        Wed, 15 Jun 2022 04:21:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44FAB61741;
        Wed, 15 Jun 2022 11:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5B4C34115;
        Wed, 15 Jun 2022 11:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655292083;
        bh=mE91W8ykidgzmvi1F5FvWB1lNXQC2IpXsjKVATPFFrM=;
        h=From:To:Cc:Subject:Date:From;
        b=gDmarE+L80mZUSN6GWvdw9JK89uQH0OZYL/lUP66osooPAel4hZ/5oB5xEsWOG8ku
         ap1pUDCTD2SQlRpqwW9AjYPuh5kZxnWjVBA4snNnwmqs/hqM/GhVLfaXwmKzI/Jdtb
         8tLwG2jL9oLdGQcuKSFeixekq25AwwudiKONkooKix4+95eFLcL27h5zkaU+DyNpfV
         cuIGsgib1pDMQ9RkI8cB4o/sPiRqEiJtYY8SzxqFUT5v9zwcFOHdYMC3noWq99rrmh
         iLUa6HcF1HsSgEViJBlZVKjxZfgSgefE2bpqpzlnUMKZKTi3LnZTUCasKJI57nuKVc
         AkLWT+xvFOs5Q==
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
Subject: [PATCHv3 bpf 0/4] bpf: Fix cookie values for kprobe multi
Date:   Wed, 15 Jun 2022 13:21:14 +0200
Message-Id: <20220615112118.497303-1-jolsa@kernel.org>
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

v3 changes:
  - fixed kprobe_multi bench test to filter out invalid entries
    from available_filter_functions

v2 changes:
  - rebased on top of bpf/master
  - checking if cookies are defined later in swap function [Andrii]
  - added acks

thanks,
jirka


---
Jiri Olsa (4):
      selftests/bpf: Shuffle cookies symbols in kprobe multi test
      ftrace: Keep address offset in ftrace_lookup_symbols
      bpf: Force cookies array to follow symbols sorting
      selftest/bpf: Fix kprobe_multi bench test

 kernel/trace/bpf_trace.c                                   | 60 +++++++++++++++++++++++++++++++++++++++++++++---------------
 kernel/trace/ftrace.c                                      | 13 +++++++++++--
 tools/testing/selftests/bpf/prog_tests/bpf_cookie.c        | 78 +++++++++++++++++++++++++++++++++++++++---------------------------------------
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c |  3 +++
 tools/testing/selftests/bpf/progs/kprobe_multi.c           | 24 ++++++++++++------------
 5 files changed, 110 insertions(+), 68 deletions(-)
