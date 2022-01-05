Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EE1484B8F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 01:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiAEAO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 19:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbiAEAO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 19:14:57 -0500
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E485FC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 16:14:56 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1641341693; bh=62pljZmRd6NMnpHMPwgl99yyovGJnGDhsktjlFBjqOo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=bL2V2p5xSb2BkXNp2vGERr9Zmb2mYnlK3t0vX17WrhVubBgdZgzsrbuaUs3b2D0Kq
         G0ZHJaorPz892dwOGzESeUD6A6Tjy6PSPZv5Phv/9D8sHuLBUntn8zzZkRMkXR4huy
         QheUsbayMK4kimQSf+hPOp2bMnKdA3zXGxfQhYBEQoGvApWxt2NMswJMf9ehhRrzSA
         YzkORZe8Yply5PxzgLJfzWgMjfm48/GSHlbpbj8UzZzxmjZ0yGwDHI2yIoZ5ncgXSI
         FmoKiwxe0atd3rylu+z4TEpg2papMaojEtrplctom4w4GHKOXwiEHrqW2Lo/ZyTkA1
         w6GmNY43wVapw==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] wiregard RX packet processing.
In-Reply-To: <CAHmME9rzEjKg41eq5jBtsLXF+vZSEnvdomZJ-rTzx8Q=ac1ayg@mail.gmail.com>
References: <20211208173205.zajfvg6zvi4g5kln@linutronix.de>
 <CAHmME9rzEjKg41eq5jBtsLXF+vZSEnvdomZJ-rTzx8Q=ac1ayg@mail.gmail.com>
Date:   Wed, 05 Jan 2022 01:14:47 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87mtkbavig.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Hi Sebastian,
>
> Seems like you've identified two things, the use of need_resched, and
> potentially surrounding napi_schedule in local_bh_{disable,enable}.
>
> Regarding need_resched, I pulled that out of other code that seemed to
> have the "same requirements", as vaguely conceived. It indeed might
> not be right. The intent is to have that worker running at maximum
> throughput for extended periods of time, but not preventing other
> threads from running elsewhere, so that, e.g., a user's machine
> doesn't have a jenky mouse when downloading a file.
>
> What are the effects of unconditionally calling cond_resched() without
> checking for if (need_resched())? Sounds like you're saying none at
> all?

I believe so: AFAIU, you use need_resched() if you need to do some kind
of teardown before the schedule point, like this example I was recently
looking at:

https://elixir.bootlin.com/linux/latest/source/net/bpf/test_run.c#L73

If you just need to maybe reschedule, you can just call cond_resched()
and it'll do what it says on the tin: do a schedule if needed, and
return immediately otherwise.

> Regarding napi_schedule, I actually wasn't aware that it's requirement
> to _only_ ever run from softirq was a strict one. When I switched to
> using napi_schedule in this way, throughput really jumped up
> significantly. Part of this indeed is from the batching, so that the
> napi callback can then handle more packets in one go later. But I
> assumed it was something inside of NAPI that was batching and
> scheduling it, rather than a mistake on my part to call this from a wq
> and not from a softirq.
>
> What, then, are the effects of surrounding that in
> local_bh_{disable,enable} as you've done in the patch? You mentioned
> one aspect is that it will "invoke wg_packet_rx_poll() where you see
> only one skb." It sounds like that'd be bad for performance, though,
> given that the design of napi is really geared toward batching.

Heh, I wrote a whole long explanation he about variable batch sizes
because you don't control when the NAPI is scheduled, etc... And then I
noticed the while loop is calling ptr_ring_consume_bh(), which means
that there's already a local_bh_disable/enable pair on every loop
invocation. So you already have this :)

Which of course raises the question of whether there's anything to gain
from *adding* batching to the worker? Something like:

#define BATCH_SIZE 8
void wg_packet_decrypt_worker(struct work_struct *work)
{
	struct crypt_queue *queue = container_of(work, struct multicore_worker,
						 work)->ptr;
	void *skbs[BATCH_SIZE];
	bool again;
	int i;

restart:
	local_bh_disable();
	ptr_ring_consume_batched(&queue->ring, skbs, BATCH_SIZE);

	for (i = 0; i < BATCH_SIZE; i++) {
		struct sk_buff *skb = skbs[i];
		enum packet_state state;

		if (!skb)
			break;

		state = likely(decrypt_packet(skb, PACKET_CB(skb)->keypair)) ?
				PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
		wg_queue_enqueue_per_peer_rx(skb, state);
	}
        
	again = !ptr_ring_empty(&queue->ring);
	local_bh_enable();

	if (again) {
		cond_resched();
		goto restart;
	}
}


Another thing that might be worth looking into is whether it makes sense
to enable threaded NAPI for Wireguard. See:
https://lore.kernel.org/r/20210208193410.3859094-1-weiwan@google.com

-Toke
