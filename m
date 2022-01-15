Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700B848F456
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 03:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiAOCMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 21:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiAOCMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 21:12:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730FAC061574;
        Fri, 14 Jan 2022 18:12:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9093616CE;
        Sat, 15 Jan 2022 02:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50848C36AE7;
        Sat, 15 Jan 2022 02:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642212724;
        bh=ON6lxFY7ZHjHDF16G1h64wt1kfDfDZ8oSoblW4Ggvw0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=piDLvBY/Xf5tKX3zQ4YPRP+7CzG3K4qT4XaPIOvA3SJssbVYmu1RLVyMzYvFz1PPx
         FpqSNwUk5485afjX/N9sUVZGroQH1OtgE5S/f+JH10EvERk5k6x63/R9NaNff+2aQR
         V1kPVR7b3s8a0lBxCc/Lswzq5ftHZa7i7JRvoufRlMRgHB6OlRrErWL9/6z5+RlQ3u
         fdgw6LqAGE6X8Mpg+A7JJpn+0CcJ+RVR2TN6UXUecJ+j8QavqNoH3uDwc4mqyv0xq/
         d/Bx79JHiocgezqBrMGU3w+2EGnp1BJEWQcarojPEk/wrXaId67BJdtDFhO8h/Hk9L
         5QGeJkZjNsGpQ==
Date:   Sat, 15 Jan 2022 11:11:57 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v2 0/8] fprobe: Introduce fprobe function entry/exit
 probe
Message-Id: <20220115111157.d314115c9c8d1c7b65664f7d@kernel.org>
In-Reply-To: <CAEf4Bza01kwiKPyXqDD17grVw9WAQT_MztoTsd0tMd2XuuGteQ@mail.gmail.com>
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
        <Yd77SYWgtrkhFIYz@krava>
        <YeAatqQTKsrxmUkS@krava>
        <20220114234704.41f28e8b5e63368c655d848e@kernel.org>
        <YeGSeGVnBnEHXTtj@krava>
        <CAEf4Bza01kwiKPyXqDD17grVw9WAQT_MztoTsd0tMd2XuuGteQ@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrii,

On Fri, 14 Jan 2022 17:02:31 -0800
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Fri, Jan 14, 2022 at 7:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Fri, Jan 14, 2022 at 11:47:04PM +0900, Masami Hiramatsu wrote:
> > > Hi Jiri and Alexei,
> > >
> > > On Thu, 13 Jan 2022 13:27:34 +0100
> > > Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > > On Wed, Jan 12, 2022 at 05:01:15PM +0100, Jiri Olsa wrote:
> > > > > On Wed, Jan 12, 2022 at 11:02:46PM +0900, Masami Hiramatsu wrote:
> > > > > > Hi Jiri and Alexei,
> > > > > >
> > > > > > Here is the 2nd version of fprobe. This version uses the
> > > > > > ftrace_set_filter_ips() for reducing the registering overhead.
> > > > > > Note that this also drops per-probe point private data, which
> > > > > > is not used anyway.
> > > > > >
> > > > > > This introduces the fprobe, the function entry/exit probe with
> > > > > > multiple probe point support. This also introduces the rethook
> > > > > > for hooking function return as same as kretprobe does. This
> > > > >
> > > > > nice, I was going through the multi-user-graph support
> > > > > and was wondering that this might be a better way
> > > > >
> > > > > > abstraction will help us to generalize the fgraph tracer,
> > > > > > because we can just switch it from rethook in fprobe, depending
> > > > > > on the kernel configuration.
> > > > > >
> > > > > > The patch [1/8] and [7/8] are from your series[1]. Other libbpf
> > > > > > patches will not be affected by this change.
> > > > >
> > > > > I'll try the bpf selftests on top of this
> > > >
> > > > I'm getting crash and stall when running bpf selftests,
> > > > the fprobe sample module works fine, I'll check on that
> > >
> > > I've tried to build tools/testing/selftests/bpf on my machine,
> > > but I got below errors. Would you know how I can setup to build
> > > the bpf selftests correctly? (I tried "make M=samples/bpf", but same result)
> >
> > what's your clang version? your distro might be behind,

I'm using clang 13.0.0.

$ clang -v
clang version 13.0.0 (https://github.com/llvm/llvm-project.git d7b669b3a30345cfcdb2fde2af6f48aa4b94845d)
Target: x86_64-unknown-linux-gnu

> 
> If you have very recent Clang, decently recent pahole, and qemu, try
> using vmtest.sh. That should build the kernel with all the necessary
> kernel config options and start qemu image with that latest image and
> build selftests. And even run selftests automatically.

OK, vmtest.sh works! :)

So I got the vmtest.sh runs out with some failures. Jiri, did you talked about
these failures, or real crash?

Summary: 212/1033 PASSED, 12 SKIPPED, 14 FAILED

Thanks! 

> 
> > I'm using clang 14 compiled from sources:
> >
> >         $ /opt/clang/bin/clang --version
> >         clang version 14.0.0 (https://github.com/llvm/llvm-project.git 9f8ffaaa0bddcefeec15a3df9858fd50b05fcbae)
> >         Target: x86_64-unknown-linux-gnu
> >         Thread model: posix
> >         InstalledDir: /opt/clang/bin
> >
> > and compiling bpf selftests with:
> >
> >         $ CLANG=/opt/clang/bin/clang make
> >
> > jirka
> >
> >
> > >
> 
> [...]
> 
> > >
> > > Thank you,
> > >
> > > --
> > > Masami Hiramatsu <mhiramat@kernel.org>
> > >
> >


-- 
Masami Hiramatsu <mhiramat@kernel.org>
