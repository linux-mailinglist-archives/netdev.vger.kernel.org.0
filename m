Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8747A6C259
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 22:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbfGQUxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 16:53:42 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55126 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfGQUxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 16:53:42 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hnqvd-0004DO-Lt; Wed, 17 Jul 2019 22:53:33 +0200
Date:   Wed, 17 Jul 2019 22:53:32 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
cc:     peterz@infradead.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: regression with napi/softirq ?
In-Reply-To: <20190717201925.fur57qfs2x3ha6aq@debian>
Message-ID: <alpine.DEB.2.21.1907172238490.1778@nanos.tec.linutronix.de>
References: <20190717201925.fur57qfs2x3ha6aq@debian>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jul 2019, Sudip Mukherjee wrote:
> I am using v4.14.55 on an Intel Atom based board and I am seeing network
> packet drops frequently on wireshark logs. After lots of debugging it
> seems that when this happens softirq is taking huge time to start after
> it has been raised. This is a small snippet from ftrace:
> 
>            <...>-2110  [001] dNH1   466.634916: irq_handler_entry: irq=126 name=eth0-TxRx-0
>            <...>-2110  [001] dNH1   466.634917: softirq_raise: vec=3 [action=NET_RX]
>            <...>-2110  [001] dNH1   466.634918: irq_handler_exit: irq=126 ret=handled
>      ksoftirqd/1-15    [001] ..s.   466.635826: softirq_entry: vec=3 [action=NET_RX]
>      ksoftirqd/1-15    [001] ..s.   466.635852: softirq_exit: vec=3 [action=NET_RX]
>      ksoftirqd/1-15    [001] d.H.   466.635856: irq_handler_entry: irq=126 name=eth0-TxRx-0
>      ksoftirqd/1-15    [001] d.H.   466.635857: softirq_raise: vec=3 [action=NET_RX]
>      ksoftirqd/1-15    [001] d.H.   466.635858: irq_handler_exit: irq=126 ret=handled
>      ksoftirqd/1-15    [001] ..s.   466.635860: softirq_entry: vec=3 [action=NET_RX]
>      ksoftirqd/1-15    [001] ..s.   466.635863: softirq_exit: vec=3 [action=NET_RX]
> 
> So, softirq was raised at 466.634917 but it started at 466.635826 almost
> 909 usec after it was raised.

This is a situation where the network softirq decided to delegate softirq
processing to ksoftirqd. That happens when too much work is available while
processing softirqs on return from interrupt.

That means that softirq processing happens under scheduler control. So if
there are other runnable tasks on the same CPU ksoftirqd can be delayed
until their time slice expired. As a consequence ksoftirqd might not be
able to catch up with the incoming packet flood and the NIC starts to drop.

You can hack ksoftirq_running() to return always false to avoid this, but
that might cause application starvation and a huge packet buffer backlog
when the amount of incoming packets makes the CPU do nothing else than
softirq processing.

Thanks,

	tglx



