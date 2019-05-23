Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1BE728D8C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 01:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387997AbfEWXCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 19:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387725AbfEWXCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 19:02:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A7832175B;
        Thu, 23 May 2019 23:02:45 +0000 (UTC)
Date:   Thu, 23 May 2019 19:02:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190523190243.54221053@gandalf.local.home>
In-Reply-To: <20190523211330.hng74yi75ixmcznc@ast-mbp.dhcp.thefacebook.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
        <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
        <20190521184137.GH2422@oracle.com>
        <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
        <20190521173618.2ebe8c1f@gandalf.local.home>
        <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
        <20190521174757.74ec8937@gandalf.local.home>
        <20190522052327.GN2422@oracle.com>
        <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
        <20190523054610.GR2422@oracle.com>
        <20190523211330.hng74yi75ixmcznc@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 14:13:31 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> > In DTrace, people write scripts based on UAPI-style interfaces and they don't
> > have to concern themselves with e.g. knowing how to get the value of the 3rd
> > argument that was passed by the firing probe.  All they need to know is that
> > the probe will have a 3rd argument, and that the 3rd argument to *any* probe
> > can be accessed as 'arg2' (or args[2] for typed arguments, if the provider is
> > capable of providing that).  Different probes have different ways of passing
> > arguments, and only the provider code for each probe type needs to know how
> > to retrieve the argument values.
> > 
> > Does this help bring clarity to the reasons why an abstract (generic) probe
> > concept is part of DTrace's design?  
> 
> It actually sounds worse than I thought.
> If dtrace script reads some kernel field it's considered to be uapi?! ouch.
> It means dtrace development philosophy is incompatible with the linux kernel.
> There is no way kernel is going to bend itself to make dtrace scripts
> runnable if that means that all dtrace accessible fields become uapi.

Now from what I'm reading, it seams that the Dtrace layer may be
abstracting out fields from the kernel. This is actually something I
have been thinking about to solve the "tracepoint abi" issue. There's
usually basic ideas that happen. An interrupt goes off, there's a
handler, etc. We could abstract that out that we trace when an
interrupt goes off and the handler happens, and record the vector
number, and/or what device it was for. We have tracepoints in the
kernel that do this, but they do depend a bit on the implementation.
Now, if we could get a layer that abstracts this information away from
the implementation, then I think that's a *good* thing.


> 
> In stark contrast to dtrace all of bpf tracing scripts (bcc scripts
> and bpftrace scripts) are written for specific kernel with intimate
> knowledge of kernel details. They do break all the time when kernel changes.
> kprobe and tracepoints are NOT uapi. All of them can change.
> tracepoints are a bit more stable than kprobes, but they are not uapi.

I wish that was totally true, but tracepoints *can* be an abi. I had
code reverted because powertop required one to be a specific format. To
this day, the wakeup event has a "success" field that writes in a
hardcoded "1", because there's tools that depend on it, and they only
work if there's a success field and the value is 1.

I do definitely agree with you that the Dtrace code shall *never* keep
the kernel from changing. That is, if Dtrace depends on something that
changes (let's say we record priority of a task, but someday priority
is replaced by something else), then Dtrace must cope with it. It must
not be a blocker like user space applications can be.


-- Steve
