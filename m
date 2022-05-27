Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B92535743
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 03:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbiE0BQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 21:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbiE0BQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 21:16:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9696F271;
        Thu, 26 May 2022 18:16:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2020761CB5;
        Fri, 27 May 2022 01:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDA9C34116;
        Fri, 27 May 2022 01:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653614174;
        bh=3OBYAY/ttRUgYAlC1eiThaGMaCz44RoEL561Vc+b8wM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WWLaLjekoR9RLT01/AGKfzkLzbX0ZqQnEgHD7m9xpIKFnE8QW1c/m2eJuLfs6m5qr
         b/+AWQFoz82mq4om+LUaPNpMWgWJUBdwHpxciwJaefeKaFXRkfO/dF6A5YpvS42wU/
         K3ZwnWjdTtjRHou0Ijo9WQwaHZqQUVzQOAYg9TbNQmswucS/p5kJr/6CbFcj/MRmk3
         9+qq/PEzpecNvNPDjqfHyP2ZengmijD6HBePI9OG4ulEm+xajDDjPViEJXyNbj29X3
         LQZ2D8XlZx3xACwR0VQlye7m9g1xdWD4+dooD44dbDHAy8dpyP+4VeudkhhnTlQ1cT
         +AaYdckUbFcMg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 0FD7E4036D; Thu, 26 May 2022 22:16:11 -0300 (-03)
Date:   Thu, 26 May 2022 22:16:11 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
Message-ID: <YpAmW/BDq4346OaI@kernel.org>
References: <20220510074659.2557731-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510074659.2557731-1-jolsa@kernel.org>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, May 10, 2022 at 09:46:56AM +0200, Jiri Olsa escreveu:
> hi,
> sending change we discussed some time ago [1] to get rid of
> some deprecated functions we use in perf prologue code.
> 
> Despite the gloomy discussion I think the final code does
> not look that bad ;-)
> 
> This patchset removes following libbpf functions from perf:
>   bpf_program__set_prep
>   bpf_program__nth_fd
>   struct bpf_prog_prep_result

So, the first patch is already in torvalds/master, I tried applying the
other two patches to my local perf/core, that already is merged with
torvalds/master and:

[root@quaco ~]# perf test 42
 42: BPF filter                                                      :
 42.1: Basic BPF filtering                                           : FAILED!
 42.2: BPF pinning                                                   : FAILED!
 42.3: BPF prologue generation                                       : FAILED!
[root@quaco ~]#

I'll push my local perf/core to tmp.perf/core and continue tomorrow.

Its failing around here:

Open Debuginfo file: /root/.cache/debuginfod_client/e1c3de4b4c5db158f2098e80f2bf9140e8cfbdb6/debuginfo
Try to find probe point from debuginfo.
Matched function: do_epoll_wait [3806bb5]
Probe point found: do_epoll_wait+0
Found 1 probe_trace_events.
Looking at the vmlinux_path (8 entries long)
symsrc__init: build id mismatch for vmlinux.
symsrc__init: cannot get elf header.
Using /proc/kcore for kernel data
Using /proc/kallsyms for symbols
do_epoll_wait is out of .text, skip it.
Post processing failed or all events are skipped. (1)
Probe point 'do_epoll_wait' not found.
bpf_probe: failed to convert perf probe events
Failed to add events selected by BPF
test child finished with -1
---- end ----
BPF filter subtest 1: FAILED

But:

[root@quaco ~]# grep do_epoll_wait /proc/kallsyms
ffffffff973c2a30 t do_epoll_wait
[root@quaco ~]#

- Arnaldo
 
> v2 changes:
>   - use fallback section prog handler, so we don't need to
>     use section prefix [Andrii]
>   - realloc prog->insns array in bpf_program__set_insns [Andrii]
>   - squash patch 1 from previous version with
>     bpf_program__set_insns change [Daniel]
>   - patch 3 already merged [Arnaldo]
>   - added more comments
> 
>   meanwhile.. perf/core and bpf-next diverged, so:
>     - libbpf bpf_program__set_insns change is based on bpf-next/master
>     - perf changes do not apply on bpf-next/master so they are based on
>       perf/core ... however they can be merged only after we release
>       libbpf 0.8.0 with bpf_program__set_insns change, so we don't break
>       the dynamic linking
>       I'm sending perf changes now just for review, I'll resend them
>       once libbpf 0.8.0 is released
> 
> thanks,
> jirka
> 
> 
> [1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
> ---
> Jiri Olsa (1):
>       libbpf: Add bpf_program__set_insns function
> 
>  tools/lib/bpf/libbpf.c   | 22 ++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   | 18 ++++++++++++++++++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 41 insertions(+)
> 
> Jiri Olsa (2):
>       perf tools: Register fallback libbpf section handler
>       perf tools: Rework prologue generation code
> 
>  tools/perf/util/bpf-loader.c | 175 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 157 insertions(+), 18 deletions(-)

-- 

- Arnaldo
