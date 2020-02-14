Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BECB15F6F2
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 20:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388011AbgBNTgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 14:36:44 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56112 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729320AbgBNTgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 14:36:44 -0500
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2gkz-0005t7-M5; Fri, 14 Feb 2020 20:36:09 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 29DE9101304; Fri, 14 Feb 2020 20:36:09 +0100 (CET)
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
Subject: Re: [RFC patch 07/19] bpf: Provide BPF_PROG_RUN_PIN_ON_CPU() macro
In-Reply-To: <20200214185027.nx6enxvmghucai2d@localhost>
References: <20200214133917.304937432@linutronix.de> <20200214161503.595780887@linutronix.de> <20200214185027.nx6enxvmghucai2d@localhost>
Date:   Fri, 14 Feb 2020 20:36:09 +0100
Message-ID: <87lfp5t106.fsf@nanos.tec.linutronix.de>
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

> On 14-Feb-2020 02:39:24 PM, Thomas Gleixner wrote:
> [...]
>> +#define BPF_PROG_RUN_PIN_ON_CPU(prog, ctx) ({				\
>> +	u32 ret;							\
>> +	migrate_disable();						\
>> +	ret = __BPF_PROG_RUN(prog, ctx, bpf_dispatcher_nopfunc);	\
>> +	migrate_enable();						\
>> +	ret; })
>
> Does it really have to be a statement expression with a local variable ?
>
> If so, we should consider renaming "ret" to "__ret" to minimize the
> chances of a caller issuing BPF_PROG_RUN_PIN_ON_CPU with "ret" as
> prog or ctx argument, which would lead to unexpected results.

Indeed. That really can be an inline.

Thanks,

        tglx
