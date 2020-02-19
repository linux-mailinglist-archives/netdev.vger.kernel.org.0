Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D270A1638B8
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 01:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgBSAuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 19:50:52 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:37156 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgBSAuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 19:50:52 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4DYs-00020a-9D; Wed, 19 Feb 2020 01:49:58 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id A7363100F56; Wed, 19 Feb 2020 01:49:57 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <20200218233641.i7fyf36zxocgucap@ast-mbp>
References: <20200214133917.304937432@linutronix.de> <20200214161504.325142160@linutronix.de> <20200214191126.lbiusetaxecdl3of@localhost> <87imk9t02r.fsf@nanos.tec.linutronix.de> <20200218233641.i7fyf36zxocgucap@ast-mbp>
Date:   Wed, 19 Feb 2020 01:49:57 +0100
Message-ID: <87blpvqu2y.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei,

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> Overall looks great.
> Thank you for taking time to write commit logs and detailed cover letter.
> I think s/__this_cpu_inc/this_cpu_inc/ is the only bit that needs to be
> addressed for it to be merged.
> There were few other suggestions from Mathieu and Jakub.
> Could you address them and resend?

I have them fixed up already, but I was waiting for further
comments. I'll send it out tomorrow morning as I'm dead tired by now.

> I saw patch 1 landing in tip tree, but it needs to be in bpf-next as well
> along with the rest of the series. Does it really need to be in the tip?
> I would prefer to take the whole thing and avoid conflicts around
> migrate_disable() especially if nothing in tip is going to use it in this
> development cycle. So just drop patch 1 from the tip?

I'll add patch 2 to a tip branch as well and I'll give you a tag to pull
into BPF (which has only those two commits). That allows us to further
tweak the relevant files without creating conflicts in next.

> Regarding
> union {
>    raw_spinlock_t  raw_lock;
>    spinlock_t      lock;
> };
> yeah. it's not pretty, but I also don't have better ideas.

Yeah. I really tried hard to avoid it, but the alternative solution was
code duplication which was even more horrible.

> Regarding migrate_disable()... can you enable it without the rest of RT?
> I haven't seen its implementation. I suspect it's scheduler only change?
> If I can use migrate_disable() without RT it will help my work on sleepable
> BPF programs. I would only have to worry about rcu_read_lock() since
> preempt_disable() is nicely addressed.

You have to talk to Peter Zijlstra about this as this is really
scheduler relevant stuff. FYI, he undamentaly hates migrate_disable()
from a schedulabilty POV, but as with the above lock construct the
amount of better solutions is also close to zero.

Thanks,

        tglx
