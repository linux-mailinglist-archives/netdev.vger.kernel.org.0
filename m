Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9673E48C2DD
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 12:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352757AbiALLIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 06:08:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41442 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237651AbiALLIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 06:08:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 416AF61744;
        Wed, 12 Jan 2022 11:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2423C36AE9;
        Wed, 12 Jan 2022 11:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641985727;
        bh=g4TvSOUEifbHDFsfuXP1XTIJ9SHq2ApknF9J8gPzf1w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NT9pKrhc7d9PNADi6t1tdi/jU0XXRogTOhGVezq27DEkxXmBJQkYdIpb/CyVbpdRh
         9DVNj8MIjdNkzb04r5CzjqArJBLq1WKRDVYnFWmD7zno52jR5sQIiBzR/dQJN1jjUX
         F92BrQZwI0y7yaZDuS32qEjiULQ39YdL47xKTOOpYRKMgW9AAm11ZQ1grY7rrgmwF5
         yxy50LD28I92l/TXa9KQTwwBhkbVr6BncE5SVt0408gFnjUhUELE6WBUFalbhBGyck
         LEOzt0voGuBVRoerR5M4CXl8a3CUNewUUUP3XTg3tjLNP94D3zh1DmvzbBMCHUWDT0
         P9AZxeuNiAgog==
Date:   Wed, 12 Jan 2022 20:08:40 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH 0/6] fprobe: Introduce fprobe function entry/exit
 probe
Message-Id: <20220112200840.a035b3b001d2e207e6a2d885@kernel.org>
In-Reply-To: <20220112163353.4da6a6b9c6eef69dbda50324@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
        <164191321766.806991.7930388561276940676.stgit@devnote2>
        <20220111223944.jbi3mxedwifxwyz5@ast-mbp.lan>
        <20220112163353.4da6a6b9c6eef69dbda50324@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 16:33:53 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Hi Alexei,
> 
> On Tue, 11 Jan 2022 14:39:44 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > On Wed, Jan 12, 2022 at 12:00:17AM +0900, Masami Hiramatsu wrote:
> > > Hi Jiri,
> > > 
> > > Here is a short series of patches, which shows what I replied
> > > to your series.
> > > 
> > > This introduces the fprobe, the function entry/exit probe with
> > > multiple probe point support. This also introduces the rethook
> > > for hooking function return, which I cloned from kretprobe.
> > > 
> > > I also rewrite your [08/13] bpf patch to use this fprobe instead
> > > of kprobes. I didn't tested that one, but the sample module seems
> > > to work. Please test bpf part with your libbpf updates.
> > > 
> > > BTW, while implementing the fprobe, I introduced the per-probe
> > > point private data, but I'm not sure why you need it. It seems
> > > that data is not used from bpf...
> > > 
> > > If this is good for you, I would like to proceed this with
> > > the rethook and rewrite the kretprobe to use the rethook to
> > > hook the functions. That should be much cleaner (and easy to
> > > prepare for the fgraph tracer integration)
> > 
> > What is the speed of attach/detach of thousands fprobes?
> 
> I've treaked my example module and it shows below result;
> 
> /lib/modules/5.16.0-rc4+/kernel/samples/fprobe # time insmod ./fprobe_example.ko
>  symbol='btrfs_*'
> [  187.095925] fprobe_init: 1028 symbols found
> [  188.521694] fprobe_init: Planted fprobe at btrfs_*
> real	0m 1.47s
> user	0m 0.00s
> sys	0m 1.36s
> 
> I think using ftrace_set_filter_ips() can make it faster.
> (maybe it needs to drop per-probe point private data, that
> prevents fprobe to use that interface)

OK, I've updated fprobes to use the ftrace_set_filter_ips()
and got below result.

/lib/modules/5.16.0-rc4+/kernel/samples/fprobe # time insmod fprobe_example.ko s
ymbol='btrfs_*' 
[   36.130947] fprobe_init: 1028 symbols found
[   36.177901] fprobe_init: Planted fprobe at btrfs_*
real	0m 0.08s
user	0m 0.00s
sys	0m 0.07s

Let me update the series :)

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
