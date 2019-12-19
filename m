Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E501260DF
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfLSLcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:32:24 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59682 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfLSLcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:32:23 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1ihu2U-0003H9-70; Thu, 19 Dec 2019 12:32:18 +0100
Date:   Thu, 19 Dec 2019 12:32:13 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     David Miller <davem@davemloft.net>
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [RFC v1 PATCH 0/7] bpf: Make RT friendly.
In-Reply-To: <20191210.172821.1406974012095303846.davem@davemloft.net>
Message-ID: <alpine.DEB.2.21.1912191157270.22388@nanos.tec.linutronix.de>
References: <20191207.160357.828344895192682546.davem@davemloft.net> <20191210.172821.1406974012095303846.davem@davemloft.net>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David,

On Tue, 10 Dec 2019, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sat, 07 Dec 2019 16:03:57 -0800 (PST)
> 
> > 
> > The goal of this patch set is to make the BPF code friendly in RT
> > configurations.
> > 
> > The first step is eliminating preemption disable/enable and replacing
> > it with local lock usage when full RT is enabled.
> > 
> > Likewise we also need to elide usage of up_read_non_owner() in the
> > stackmap code when full RT is turned on.
> > 
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Thomas can you please take a look at this patch series?
> 
> It eliminates all of the RT problems we were made aware of, and these
> patches have been through the bpf test suite as well as gotten 0-day
> testing.
> 
> The only major thing we needs ACK'd is the locallock stubs.

Sorry for the late reply. I had to take myself out for a while and I just
saw this by chance while looking for something else. I was not planning
to look at any kernel stuff before Jan 7th.

Thanks for looking into that!

This is going into the direction I had in mind, but from a quick look, I
think this is missing a few details.

The invocation and locking needs to be context aware. local_locks are
'sleeping' locks on RT, so you can't take them from truly atomic contexts.

The reason why RT works at all is that the kernel is pretty strict about
execution context and most things have context aware entry points. Aa far
as I understand BPF has a single entry point (please correct me if I'm
wrong).

I assume that you know in which context a BPF program will run at verifier
time, as you need to prevent certain calls from e.g. perf context, right?

For RT we really need context sensitive entry points

   - atomic entry. Called from (even on RT) atomic contexts like tracing,
     perf, kprobes ....

     These entry points do not need preempt_disable() at all, because those
     contexts have preemption already disabled.

     None of these BPF programs should invoke memory allocation functions
     or stuff like that.

   - BH disabled context entry.

     On non RT preempt disable is not required because preemption is
     already disabled.

     On RT BH context is non-reentrant, but can be preempted. The question is
     whether the BH non-reentrance guarantee is enough or not.

     If you need to protect that against other BPF stuff then we'd need a
     local lock there.

   - Regular thread context. This needs preempt disable on non RT and a
     local lock on RT.

If we treat BH disabled and thread context the same, then two entry points
are enough.

So if you could provide context sensitive entry points, then adding RT
support into it should be just a pretty trivial patch.

Thanks,

	Thomas
