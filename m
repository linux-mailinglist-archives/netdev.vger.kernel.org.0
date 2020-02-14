Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E726215F737
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 20:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388980AbgBNT4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 14:56:35 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56146 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387881AbgBNT4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 14:56:34 -0500
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2h4P-00065q-EI; Fri, 14 Feb 2020 20:56:13 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 9BCA7101304; Fri, 14 Feb 2020 20:56:12 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC patch 14/19] bpf: Use migrate_disable() in hashtab code
In-Reply-To: <20200214191126.lbiusetaxecdl3of@localhost>
References: <20200214133917.304937432@linutronix.de> <20200214161504.325142160@linutronix.de> <20200214191126.lbiusetaxecdl3of@localhost>
Date:   Fri, 14 Feb 2020 20:56:12 +0100
Message-ID: <87imk9t02r.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> On 14-Feb-2020 02:39:31 PM, Thomas Gleixner wrote:
>> Replace the preempt_disable/enable() pairs with migrate_disable/enable()
>> pairs to prepare BPF to work on PREEMPT_RT enabled kernels. On a non-RT
>> kernel this maps to preempt_disable/enable(), i.e. no functional change.

...

> Having all those events randomly and silently discarded might be quite
> unexpected from a user standpoint. This turns the deadlock prevention
> mechanism into a random tracepoint-dropping facility, which is
> unsettling.

Well, it randomly drops events which might be unrelated to the syscall
target today already, this will just drop some more. Shrug.

> One alternative approach we could consider to solve this is to make
> this deadlock prevention nesting counter per-thread rather than
> per-cpu.

That should work both on !RT and RT.

> Also, I don't think using __this_cpu_inc() without preempt-disable or
> irq off is safe. You'll probably want to move to this_cpu_inc/dec
> instead, which can be heavier on some architectures.

Good catch.

Thanks,

        tglx

      
