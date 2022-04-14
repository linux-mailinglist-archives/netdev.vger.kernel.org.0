Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DA1501E88
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243642AbiDNWrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239245AbiDNWrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:47:15 -0400
Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8F63A70E
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 15:44:43 -0700 (PDT)
Date:   Thu, 14 Apr 2022 22:44:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1649976281;
        bh=NbUyMRXU3YGyouZhFWR+9oe5iiAhaIN84BE7CsU16Zc=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID;
        b=lE7nwooIHB/4IgEfwRdkbBZ7P0LpWSGdD9zZmqLTeCGJCVWDYrAoZljZGQSPtWUV6
         rJCe1lEnjKjBgjsPGaNVXDv7io4kZN1nziWGF8tu+vJqa0Q2A5p6mX78pU1p85tLaP
         gRicHZEM87UVPIsTECwtmhRiEDRP/PrGHKd/RmoALy738gTUed7bIpeMH7W5DuDyEv
         RkEg0ckD6yNgDX7XsSrOdPmiKaX4CTS0cfWVCTWUuhCDP8aPojWmfXVMTqlPRaGTQc
         ZM9U7wl49sykLy3ZzCyhAfu4WwftGEFkth+U4v0m4F4egi9Y4donykcb+azNwS6GEr
         i86EhtsJVfp/g==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Chenbo Feng <fengc@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH bpf-next 00/11] bpf: random unpopular userspace fixes (32 bit et al.)
Message-ID: <20220414223704.341028-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This mostly issues the cross build (1) errors for 32 bit (2)
MIPS (3) with minimal configuration (4) on Musl (5). The majority
of them aren't yesterday's, so it is a "who does need it outside
of x86_64 or ARM64?" moment again.
Trivial stuff in general, not counting the bpf_cookie build fix.

Alexander Lobakin (11):
  bpf, perf: fix bpftool compilation with !CONFIG_PERF_EVENTS
  bpf: always emit struct bpf_perf_link BTF
  tools, bpf: fix bpftool build with !CONFIG_BPF_EVENTS
  samples: bpf: add 'asm/mach-generic' include path for every MIPS
  samples: bpf: use host bpftool to generate vmlinux.h, not target
  tools, bpf: fix fcntl.h include in bpftool
  samples: bpf: fix uin64_t format literals
  samples: bpf: fix shifting unsigned long by 32 positions
  samples: bpf: fix include order for non-Glibc environments
  samples: bpf: fix -Wsequence-point
  samples: bpf: xdpsock: fix -Wmaybe-uninitialized

 include/linux/perf_event.h              |  2 ++
 kernel/bpf/syscall.c                    |  4 +++-
 samples/bpf/Makefile                    |  7 ++++---
 samples/bpf/cookie_uid_helper_example.c | 12 ++++++------
 samples/bpf/lathist_kern.c              |  2 +-
 samples/bpf/lwt_len_hist_kern.c         |  2 +-
 samples/bpf/lwt_len_hist_user.c         |  4 ++--
 samples/bpf/task_fd_query_user.c        |  2 +-
 samples/bpf/test_lru_dist.c             |  3 ++-
 samples/bpf/tracex2_kern.c              |  2 +-
 samples/bpf/xdpsock_user.c              |  5 +++--
 tools/bpf/bpftool/tracelog.c            |  2 +-
 12 files changed, 27 insertions(+), 20 deletions(-)

--
2.35.2


