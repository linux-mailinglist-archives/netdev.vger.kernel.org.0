Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F1C39B98F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 15:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhFDNKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 09:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230110AbhFDNKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 09:10:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1C0161242;
        Fri,  4 Jun 2021 13:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622812144;
        bh=KHO+U0aZOMLH2SG9CS45ops/zg0OYk/Q1F2Jdo4MHDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OoAsBZNFMBALH8HjHbOqLEVqWSkhW363ubgORcFWrczTo1D17qKyVFPUFlMX+BRfE
         G2U1ePuqGfqDS0DAktsvLrCWMqGsumbw5DHWN82OaUSyI1GYzliQyVed49QQoEwqq4
         qWsaiIVd1fE9w7a1XZMOO7zjlArX1xvB9YKjH9mPUDlqvnZzCT4Yu5g49JlUELkD/B
         qGSAKYO72+ypnbhepuhBMD1G4pYY8tdlCwVWECDEqs9FzEq+SEc7FpHjYlLnQ7mbXd
         10GXeQmyqREwFI7OjooZ0fHpK7feEbNp47PG2HWJCkyQOmS1hRsgDB2X+JJdx+AIBB
         RsnSG8uVErupg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 5E10940EFC; Fri,  4 Jun 2021 10:09:01 -0300 (-03)
Date:   Fri, 4 Jun 2021 10:09:01 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Riccardo Mancini <rickyman7@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] perf env: fix memory leak: free bpf_prog_info_linear
Message-ID: <YLol7QC7xFSEsw8x@kernel.org>
References: <20210602224024.300485-1-rickyman7@gmail.com>
 <CAP-5=fW5btkb9izxcUy+XgAQPCTRZAUMa4uQMUR_+N_d=17Mfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fW5btkb9izxcUy+XgAQPCTRZAUMa4uQMUR_+N_d=17Mfg@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jun 03, 2021 at 09:15:32PM -0700, Ian Rogers escreveu:
> On Wed, Jun 2, 2021 at 3:41 PM Riccardo Mancini <rickyman7@gmail.com> wrote:
> >
> > ASan reported a memory leak caused by info_linear not being
> > deallocated. The info_linear was allocated during
> > perf_event__synthesize_one_bpf_prog.
> > This patch adds the corresponding free() when bpf_prog_info_node
> > is freed in perf_env__purge_bpf.
> >
> > $ sudo ./perf record -- sleep 5
> > [ perf record: Woken up 1 times to write data ]
> > [ perf record: Captured and wrote 0.025 MB perf.data (8 samples) ]
> >
> > =================================================================
> > ==297735==ERROR: LeakSanitizer: detected memory leaks
> >
> > Direct leak of 7688 byte(s) in 19 object(s) allocated from:
> >     #0 0x4f420f in malloc (/home/user/linux/tools/perf/perf+0x4f420f)
> >     #1 0xc06a74 in bpf_program__get_prog_info_linear /home/user/linux/tools/lib/bpf/libbpf.c:11113:16
> >     #2 0xb426fe in perf_event__synthesize_one_bpf_prog /home/user/linux/tools/perf/util/bpf-event.c:191:16
> >     #3 0xb42008 in perf_event__synthesize_bpf_events /home/user/linux/tools/perf/util/bpf-event.c:410:9
> >     #4 0x594596 in record__synthesize /home/user/linux/tools/perf/builtin-record.c:1490:8
> >     #5 0x58c9ac in __cmd_record /home/user/linux/tools/perf/builtin-record.c:1798:8
> >     #6 0x58990b in cmd_record /home/user/linux/tools/perf/builtin-record.c:2901:8
> >     #7 0x7b2a20 in run_builtin /home/user/linux/tools/perf/perf.c:313:11
> >     #8 0x7b12ff in handle_internal_command /home/user/linux/tools/perf/perf.c:365:8
> >     #9 0x7b2583 in run_argv /home/user/linux/tools/perf/perf.c:409:2
> >     #10 0x7b0d79 in main /home/user/linux/tools/perf/perf.c:539:3
> >     #11 0x7fa357ef6b74 in __libc_start_main /usr/src/debug/glibc-2.33-8.fc34.x86_64/csu/../csu/libc-start.c:332:16
> >
> > Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
> 
> Acked-by: Ian Rogers <irogers@google.com>

Thanks, applied.

- Arnaldo

