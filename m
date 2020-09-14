Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9022698F2
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 00:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgINWe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 18:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgINWeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 18:34:20 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E027C208DB;
        Mon, 14 Sep 2020 22:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600122860;
        bh=VUhtghnsr7sxEh6kYrc2+nG7h0VCsXrYJzf4W/n23ms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kkXsHGPubvAizafHEa7CYeF3kjykbcLNySMjzlvTp2vGQFZ3c3CYwkZD518XTEhJf
         Wx89Jt1JZEFS3cL4NuNGxL01+pQe/eW9dmZVIDnrDjTAO+tq0v9p/Chl/0P53cV54T
         np9QcdzxPGCGHpzYyjr8IIaDsXHAD9CnHzcS0Xps=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id E158140D3D; Mon, 14 Sep 2020 19:34:17 -0300 (-03)
Date:   Mon, 14 Sep 2020 19:34:17 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v3 3/4] perf record: Don't clear event's period if set by
 a term
Message-ID: <20200914223417.GI166601@kernel.org>
References: <20200912025655.1337192-1-irogers@google.com>
 <20200912025655.1337192-4-irogers@google.com>
 <20200914214655.GE166601@kernel.org>
 <20200914215106.GF166601@kernel.org>
 <CAP-5=fUO_HFd2-z53u6GdRV=o7HsB4ThzWYJDGQG8OwGDeV+VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fUO_HFd2-z53u6GdRV=o7HsB4ThzWYJDGQG8OwGDeV+VA@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Sep 14, 2020 at 02:52:57PM -0700, Ian Rogers escreveu:
> On Mon, Sep 14, 2020 at 2:51 PM Arnaldo Carvalho de Melo
> <acme@kernel.org> wrote:
> >
> > Em Mon, Sep 14, 2020 at 06:46:55PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > Em Fri, Sep 11, 2020 at 07:56:54PM -0700, Ian Rogers escreveu:
> > > > If events in a group explicitly set a frequency or period with leader
> > > > sampling, don't disable the samples on those events.
> > > >
> > > > Prior to 5.8:
> > > > perf record -e '{cycles/period=12345000/,instructions/period=6789000/}:S'
> > > > would clear the attributes then apply the config terms. In commit
> > > > 5f34278867b7 leader sampling configuration was moved to after applying the
> > > > config terms, in the example, making the instructions' event have its period
> > > > cleared.
> > > > This change makes it so that sampling is only disabled if configuration
> > > > terms aren't present.
> > >
> > > Adrian, Jiri, can you please take a look a this and provide Reviewed-by
> > > or Acked-by tags?
> >
> > Without this patch we have:
> >
> > # perf record -e '{cycles/period=1/,instructions/period=2/}:S' sleep 1
> > [ perf record: Woken up 1 times to write data ]
> > [ perf record: Captured and wrote 0.051 MB perf.data (6 samples) ]
> > #
> > # perf evlist -v
> > cycles/period=1/: size: 120, { sample_period, sample_freq }: 1, sample_type: IP|TID|TIME|READ|ID, read_format: ID|GROUP, disabled: 1, mmap: 1, comm: 1, enable_on_exec: 1, task: 1, sample_id_all: 1, exclude_guest: 1, mmap2: 1, comm_exec: 1, ksymbol: 1, bpf_event: 1
> > instructions/period=2/: size: 120, config: 0x1, sample_type: IP|TID|TIME|READ|ID, read_format: ID|GROUP, sample_id_all: 1, exclude_guest: 1
> > #
> >
> > So indeed the period=2 is being cleared for the second event in that
> > group.
> >
> > - Arnaldo
> 
> Thanks Arnaldo and Adrian! Adrian's acked-by is here:
> https://lore.kernel.org/lkml/77df85d3-a50c-d6aa-1d60-4fc9ea90dc44@intel.com/
> Let me know if anything is missing.

Thanks, applied.

- Arnaldo
