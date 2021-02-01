Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA92D30A8D1
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 14:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhBANe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 08:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbhBANev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 08:34:51 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAB9C06174A;
        Mon,  1 Feb 2021 05:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eu7VX8JvvszySJwHZVTokupuwHECVWP055L+vUMCliY=; b=kqNV/MnPMGMuePTDqne9Tb7qUx
        22kFtr3q5TR4oQmDl0ZZCik4Fj0OTwXfR7Qspzv8IOCAruTq8HYub/ibswiukXiTXYCBeDS6Bfqf0
        LfUvM3DtejdPryUgo+MSS1kt57QBIuXVFjyWM5D/zGTSzGRwfUgnbqsIpOAbTV0YRzqyow2tG1gQr
        C+AUDpwFDFDkT4WXcAruB3h76YZmIjS1uu2pLracRfrR55pvzTo4gFOpJLbxTMljKXkjW5iB6RgOJ
        naL8Mtm2Eg7pEMFnuqeZfbc3tCSJPcG6V4Npt3FNWXsSPYYYZyBUxauMeP9F+Uj4teK28TaYq8Nit
        SvfuAAig==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l6ZKv-00017P-Mk; Mon, 01 Feb 2021 13:33:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 15B943011FE;
        Mon,  1 Feb 2021 14:33:46 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BA97E2B802295; Mon,  1 Feb 2021 14:33:46 +0100 (CET)
Date:   Mon, 1 Feb 2021 14:33:46 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>, kpsingh@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: extended bpf_send_signal_thread with argument
Message-ID: <YBgDOnhrYjByjdIb@hirez.programming.kicks-ass.net>
References: <CACT4Y+a7UBQpAY4vwT8Od0JhwbwcDrbJXZ_ULpPfJZ42Ew-yCQ@mail.gmail.com>
 <YBfIUwtK+QqVlfRt@hirez.programming.kicks-ass.net>
 <CACT4Y+Yq69nvj2KZUQrYqtyu+Low+jCCcH++U_vuiHkhezQHGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Yq69nvj2KZUQrYqtyu+Low+jCCcH++U_vuiHkhezQHGw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 10:42:47AM +0100, Dmitry Vyukov wrote:
> On Mon, Feb 1, 2021 at 10:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Sun, Jan 31, 2021 at 12:14:02PM +0100, Dmitry Vyukov wrote:
> > > Hi,
> > >
> > > I would like to send a signal from a bpf program invoked from a
> > > perf_event. There is:
> >
> > You can't. Sending signals requires sighand lock, and you're not allowed
> > to take locks from perf_event context.
> 
> 
> Then we just found a vulnerability because there is
> bpf_send_signal_thread which can be attached to perf and it passes the
> verifier :)
> https://elixir.bootlin.com/linux/v5.11-rc5/source/kernel/trace/bpf_trace.c#L1145
> 
> It can defer sending the signal to the exit of irq context:
> https://elixir.bootlin.com/linux/v5.11-rc5/source/kernel/trace/bpf_trace.c#L1108
> Perhaps this is what makes it work?

Yes.
