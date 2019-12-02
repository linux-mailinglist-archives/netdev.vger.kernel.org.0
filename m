Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5415E10ED1F
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 17:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbfLBQ1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 11:27:05 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:52828 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbfLBQ1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 11:27:04 -0500
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iboXD-0002vI-M1; Mon, 02 Dec 2019 17:26:51 +0100
Date:   Mon, 2 Dec 2019 17:26:51 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Paul Thomas <pthomas8589@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: xdpsock poll with 5.2.21rt kernel
Message-ID: <20191202162651.7jkyj52sny3yownr@linutronix.de>
References: <CAD56B7dwKDKnrCjpGmrnxz2P0QpNWU3CGBvOtqg3RBx3ejPh9g@mail.gmail.com>
 <20191129164842.qimcmjlz5xq7uupw@linutronix.de>
 <CAD56B7dtR4GtPUUmmPVcuc0L+7BixW9+S=CR1g4ub3_6ZgRobg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAD56B7dtR4GtPUUmmPVcuc0L+7BixW9+S=CR1g4ub3_6ZgRobg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-02 10:36:54 [-0500], Paul Thomas wrote:
> On Fri, Nov 29, 2019 at 11:48 AM Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> >
> > On 2019-11-12 17:42:42 [-0500], Paul Thomas wrote:
> > > Any thoughts would be appreciated.
> >
> > Could please enable CONFIG_DEBUG_ATOMIC_SLEEP and check if the kernel
> > complains?
> 
> Hi Sebastian,
> 
> Well, it does complain (report below), but I'm not sure it's related.
> The other thing I tried was the AF_XDP example here:
> https://github.com/xdp-project/xdp-tutorial/tree/master/advanced03-AF_XDP
> 
> With this example poll() always seems to block correctly, so I think
> maybe there is something wrong with the xdpsock_user.c example or how
> I'm using it.
> 
> [  259.591480] BUG: assuming atomic context at net/core/ptp_classifier.c:106
> [  259.591488] in_atomic(): 0, irqs_disabled(): 0, pid: 953, name: irq/22-eth%d
> [  259.591494] CPU: 0 PID: 953 Comm: irq/22-eth%d Tainted: G        WC
>        5.
> 
>                         2.21-rt13-00016-g93898e751d0e #90
> [  259.591499] Hardware name: Enclustra XU5 SOM (DT)
> [  259.591501] Call trace:
> [  259.591503] dump_backtrace (/arch/arm64/kernel/traps.c:94)
> [  259.591514] show_stack (/arch/arm64/kernel/traps.c:151)
> [  259.591520] dump_stack (/lib/dump_stack.c:115)
> [  259.591526] __cant_sleep (/kernel/sched/core.c:6386)
> [  259.591531] ptp_classify_raw (/./include/linux/compiler.h:194

Is this the only splat? Nothing more? I would expect something at boot
time, too.

So this part expects disabled preemption. Other invocations disable
preemption. The whole BPF part is currently not working on -RT.

Sebastian
