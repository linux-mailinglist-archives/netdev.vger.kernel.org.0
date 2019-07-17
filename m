Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F04E6C2D0
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 23:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbfGQVwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 17:52:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55426 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfGQVwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 17:52:43 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hnrqo-0005p3-Lz; Wed, 17 Jul 2019 23:52:38 +0200
Date:   Wed, 17 Jul 2019 23:52:37 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
cc:     "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression with napi/softirq ?
In-Reply-To: <CADVatmO_m-NYotb9Htd7gS0d2-o0DeEWeDJ1uYKE+oj_HjoN0Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1907172345360.1778@nanos.tec.linutronix.de>
References: <20190717201925.fur57qfs2x3ha6aq@debian> <alpine.DEB.2.21.1907172238490.1778@nanos.tec.linutronix.de> <CADVatmO_m-NYotb9Htd7gS0d2-o0DeEWeDJ1uYKE+oj_HjoN0Q@mail.gmail.com>
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

Sudip,

On Wed, 17 Jul 2019, Sudip Mukherjee wrote:
> On Wed, Jul 17, 2019 at 9:53 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> > You can hack ksoftirq_running() to return always false to avoid this, but
> > that might cause application starvation and a huge packet buffer backlog
> > when the amount of incoming packets makes the CPU do nothing else than
> > softirq processing.
> 
> I tried that now, it is better but still not as good as v3.8
> Now I am getting 375.9usec as the maximum time between raising the softirq
> and it starting to execute and packet drops still there.
>
> And just a thought, do you think there should be a CONFIG_ option for
> this feature of ksoftirqd_running() so that it can be disabled if needed
> by users like us?

If at all then a sysctl to allow runtime control.
 
> Can you please think of anything else that might have changed which I still need
> to change to make the time comparable to v3.8..

Something with in that small range of:

 63592 files changed, 13783320 insertions(+), 5155492 deletions(-)

:)

Seriously, that can be anything.

Can you please test with Linus' head of tree and add some more
instrumentation, so we can see what holds off softirqs from being
processed. If the ksoftirqd enforcement is disabled, then the only reason
can be a long lasting softirq disabled region. Tracing should tell.

Thanks,

	tglx
