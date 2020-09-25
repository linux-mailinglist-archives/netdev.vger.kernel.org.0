Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C127279223
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgIYUdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:33:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgIYUZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:25:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71B4A21D7A;
        Fri, 25 Sep 2020 19:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601060814;
        bh=ByEl/atmqPjM0xo8PM58ivXS5lqwmPuLd3moFyUQA08=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IW+b0MeitugJLEoqZZp1YKe5uAcWE/xjC/7d3l4fTuzZiQTJLYIhKMkF8uCdc+PcY
         BvtdodvetOVL+A+AU61EKnVUHSTvcb1/G5+hAUMkwJjC1UOg3W1JSMl0Xxq5XS9jgC
         AnyeLccqawXgMPqzC50ySEJmexKLMPShS152Os8I=
Date:   Fri, 25 Sep 2020 12:06:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
Message-ID: <20200925120652.10b8d7c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJ8uoz30afXpbn+RXwN5BNMwrLAcW0Cn8tqP502oCLaKH0+kZg@mail.gmail.com>
References: <20200914172453.1833883-1-weiwan@google.com>
        <CAJ8uoz30afXpbn+RXwN5BNMwrLAcW0Cn8tqP502oCLaKH0+kZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 15:48:35 +0200 Magnus Karlsson wrote:
> I really like this RFC and would encourage you to submit it as a
> patch. Would love to see it make it into the kernel.
> 
> I see the same positive effects as you when trying it out with AF_XDP
> sockets. Made some simple experiments where I sent 64-byte packets to
> a single AF_XDP socket. Have not managed to figure out how to do
> percentiles on my load generator, so this is going to be min, avg and
> max only. The application using the AF_XDP socket just performs a mac
> swap on the packet and sends it back to the load generator that then
> measures the round trip latency. The kthread is taskset to the same
> core as ksoftirqd would run on. So in each experiment, they always run
> on the same core id (which is not the same as the application).
> 
> Rate 12 Mpps with 0% loss.
>               Latencies (us)         Delay Variation between packets
>           min    avg    max      avg   max
> sofirq  11.0  17.1   78.4      0.116  63.0
> kthread 11.2  17.1   35.0     0.116  20.9
> 
> Rate ~58 Mpps (Line rate at 40 Gbit/s) with substantial loss
>               Latencies (us)         Delay Variation between packets
>           min    avg    max      avg   max
> softirq  87.6  194.9  282.6    0.062  25.9
> kthread  86.5  185.2  271.8    0.061  22.5
> 
> For the last experiment, I also get 1.5% to 2% higher throughput with
> your kthread approach. Moreover, just from the per-second throughput
> printouts from my application, I can see that the kthread numbers are
> more stable. The softirq numbers can vary quite a lot between each
> second, around +-3%. But for the kthread approach, they are nice and
> stable. Have not examined why.

Sure, it's better than status quo for AF_XDP but it's going to be far
inferior to well implemented busy polling.

We already discussed the potential scheme with Bjorn, since you prompted
me again, let me shoot some code from the hip at ya:

diff --git a/net/core/dev.c b/net/core/dev.c
index 74ce8b253ed6..8dbdfaeb0183 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6668,6 +6668,7 @@ static struct napi_struct *napi_by_id(unsigned int napi_id)
 
 static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
 {
+       unsigned long to;
        int rc;
 
        /* Busy polling means there is a high chance device driver hard irq
@@ -6682,6 +6683,13 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
        clear_bit(NAPI_STATE_MISSED, &napi->state);
        clear_bit(NAPI_STATE_IN_BUSY_POLL, &napi->state);
 
+       if (READ_ONCE(napi->dev->napi_defer_hard_irqs)) {
+               netpoll_poll_unlock(have_poll_lock);
+               to = ns_to_ktime(READ_ONCE(napi->dev->gro_flush_timeout));
+               hrtimer_start(&n->timer, to, HRTIMER_MODE_REL_PINNED);
+               return;
+       }
+
        local_bh_disable();
 
        /* All we really want here is to re-enable device interrupts.


With basic busy polling implemented for AF_XDP this is all** you need
to make busy polling work very well.

** once bugs are fixed :D I haven't even compiled this

Eric & co. already implemented hard IRQ deferral. All we need to do is
push the timer away when application picks up frames. I think.

Please, no loose threads for AF_XDP apps (or other busy polling apps).
Let the application burn 100% of the core :(
