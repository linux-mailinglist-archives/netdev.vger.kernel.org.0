Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4900928EF2
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 03:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387867AbfEXB5m convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 May 2019 21:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731617AbfEXB5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 21:57:42 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 482142177E;
        Fri, 24 May 2019 01:57:39 +0000 (UTC)
Date:   Thu, 23 May 2019 21:57:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190523215737.6601ab7c@oasis.local.home>
In-Reply-To: <20190524003148.pk7qbxn7ysievhym@ast-mbp.dhcp.thefacebook.com>
References: <20190521184137.GH2422@oracle.com>
        <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
        <20190521173618.2ebe8c1f@gandalf.local.home>
        <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
        <20190521174757.74ec8937@gandalf.local.home>
        <20190522052327.GN2422@oracle.com>
        <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
        <20190523054610.GR2422@oracle.com>
        <20190523211330.hng74yi75ixmcznc@ast-mbp.dhcp.thefacebook.com>
        <20190523190243.54221053@gandalf.local.home>
        <20190524003148.pk7qbxn7ysievhym@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 17:31:50 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:


> > Now from what I'm reading, it seams that the Dtrace layer may be
> > abstracting out fields from the kernel. This is actually something I
> > have been thinking about to solve the "tracepoint abi" issue. There's
> > usually basic ideas that happen. An interrupt goes off, there's a
> > handler, etc. We could abstract that out that we trace when an
> > interrupt goes off and the handler happens, and record the vector
> > number, and/or what device it was for. We have tracepoints in the
> > kernel that do this, but they do depend a bit on the implementation.
> > Now, if we could get a layer that abstracts this information away from
> > the implementation, then I think that's a *good* thing.  
> 
> I don't like this deferred irq idea at all.

What do you mean deferred?

> Abstracting details from the users is _never_ a good idea.

Really? Most everything we do is to abstract details from the user. The
key is to make the abstraction more meaningful than the raw data.

> A ton of people use bcc scripts and bpftrace because they want those details.
> They need to know what kernel is doing to make better decisions.
> Delaying irq record is the opposite.

I never said anything about delaying the record. Just getting the
information that is needed.

> > 
> > I wish that was totally true, but tracepoints *can* be an abi. I had
> > code reverted because powertop required one to be a specific
> > format. To this day, the wakeup event has a "success" field that
> > writes in a hardcoded "1", because there's tools that depend on it,
> > and they only work if there's a success field and the value is 1.  
> 
> I really think that you should put powertop nightmares to rest.
> That was long ago. The kernel is different now.

Is it?

> Linus made it clear several times that it is ok to change _all_
> tracepoints. Period. Some maintainers somehow still don't believe
> that they can do it.

From what I remember him saying several times, is that you can change
all tracepoints, but if it breaks a tool that is useful, then that
change will get reverted. He will allow you to go and fix that tool and
bring back the change (which was the solution to powertop).

> 
> Some tracepoints are used more than others and more people will
> complain: "ohh I need to change my script" when that tracepoint
> changes. But the kernel development is not going to be hampered by a
> tracepoint. No matter how widespread its usage in scripts.

That's because we'll treat bpf (and Dtrace) scripts like modules (no
abi), at least we better. But if there's a tool that doesn't use the
script and reads the tracepoint directly via perf, then that's a
different story.

-- Steve

> 
> Sometimes that pain of change can be mitigated a bit. Like that
> 'success' field example, but tracepoints still change.
> Meaningful value before vs hardcoded constant is still a breakage for
> some scripts.
