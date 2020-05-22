Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9241DDC31
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgEVAee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgEVAee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:34:34 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ECDD2072C;
        Fri, 22 May 2020 00:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590107673;
        bh=wWqEQTXoDY230SRdVgPhwmMxy16C3iksXHhgyjDUrZc=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=DtTTYKbzwDblceEzvaPuD0pUlGRpiWlY35WxqqI6E8Iut/1ERdpZqSuRLaCXTNLOk
         ilB/DfRbwRIkUgdIl2loANfkvf3BQpiwGXk8/05cV3pPWTn0DK9Ggdd+wje/UFAjx0
         84vMP158IwVT5Q+DhLPC4CzTPW5KgXZGPdvaLp6Y=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 5EC283522FEB; Thu, 21 May 2020 17:34:33 -0700 (PDT)
Date:   Thu, 21 May 2020 17:34:33 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/7] tools/memory-model: add BPF ringbuf MPSC
 litmus tests
Message-ID: <20200522003433.GG2869@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200517195727.279322-1-andriin@fb.com>
 <20200517195727.279322-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517195727.279322-3-andriin@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 12:57:22PM -0700, Andrii Nakryiko wrote:
> Add 4 litmus tests for BPF ringbuf implementation, divided into two different
> use cases.
> 
> First, two unbounded case, one with 1 producer and another with
> 2 producers, single consumer. All reservations are supposed to succeed.
> 
> Second, bounded case with only 1 record allowed in ring buffer at any given
> time. Here failures to reserve space are expected. Again, 1- and 2- producer
> cases, single consumer, are validated.
> 
> Just for the fun of it, I also wrote a 3-producer cases, it took *16 hours* to
> validate, but came back successful as well. I'm not including it in this
> patch, because it's not practical to run it. See output for all included
> 4 cases and one 3-producer one with bounded use case.
> 
> Each litmust test implements producer/consumer protocol for BPF ring buffer
> implementation found in kernel/bpf/ringbuf.c. Due to limitations, all records
> are assumed equal-sized and producer/consumer counters are incremented by 1.
> This doesn't change the correctness of the algorithm, though.

Very cool!!!

However, these should go into Documentation/litmus-tests/bpf-rb or similar.
Please take a look at Documentation/litmus-tests/ in -rcu, -tip, and
-next, including the README file.

The tools/memory-model/litmus-tests directory is for basic examples,
not for the more complex real-world ones like these guys.  ;-)

								Thanx, Paul

> Verification results:
> /* 1p1c bounded case */
> $ herd7 -unroll 0 -conf linux-kernel.cfg litmus-tests/mpsc-rb+1p1c+bounded.litmus
> Test mpsc-rb+1p1c+bounded Allowed
> States 2
> 0:rFail=0; 1:rFail=0; cx=0; dropped=0; len1=1; px=1;
> 0:rFail=0; 1:rFail=0; cx=1; dropped=0; len1=1; px=1;
> Ok
> Witnesses
> Positive: 3 Negative: 0
> Condition exists (0:rFail=0 /\ 1:rFail=0 /\ dropped=0 /\ px=1 /\ len1=1 /\ (cx=0 \/ cx=1))
> Observation mpsc-rb+1p1c+bounded Always 3 0
> Time mpsc-rb+1p1c+bounded 0.03
> Hash=5bdad0f41557a641370e7fa6b8eb2f43
> 
> /* 2p1c bounded case */
> $ herd7 -unroll 0 -conf linux-kernel.cfg litmus-tests/mpsc-rb+2p1c+bounded.litmus
> Test mpsc-rb+2p1c+bounded Allowed
> States 4
> 0:rFail=0; 1:rFail=0; 2:rFail=0; cx=0; dropped=1; len1=1; px=1;
> 0:rFail=0; 1:rFail=0; 2:rFail=0; cx=1; dropped=0; len1=1; px=2;
> 0:rFail=0; 1:rFail=0; 2:rFail=0; cx=1; dropped=1; len1=1; px=1;
> 0:rFail=0; 1:rFail=0; 2:rFail=0; cx=2; dropped=0; len1=1; px=2;
> Ok
> Witnesses
> Positive: 22 Negative: 0
> Condition exists (0:rFail=0 /\ 1:rFail=0 /\ 2:rFail=0 /\ len1=1 /\ (dropped=0 /\ px=2 /\ (cx=1 \/ cx=2) \/ dropped=1 /\ px=1 /\ (cx=0 \/ cx=1)))
> Observation mpsc-rb+2p1c+bounded Always 22 0
> Time mpsc-rb+2p1c+bounded 119.38
> Hash=e2f8f442a02bf7d8c2988ba82cf002d2
> 
> /* 1p1c unbounded case */
> $ herd7 -unroll 0 -conf linux-kernel.cfg litmus-tests/mpsc-rb+1p1c+unbound.litmus
> Test mpsc-rb+1p1c+unbound Allowed
> States 2
> 0:rFail=0; 1:rFail=0; cx=0; len1=1; px=1;
> 0:rFail=0; 1:rFail=0; cx=1; len1=1; px=1;
> Ok
> Witnesses
> Positive: 3 Negative: 0
> Condition exists (0:rFail=0 /\ 1:rFail=0 /\ px=1 /\ len1=1 /\ (cx=0 \/ cx=1))
> Observation mpsc-rb+1p1c+unbound Always 3 0
> Time mpsc-rb+1p1c+unbound 0.02
> Hash=be9de6487d8e27c3d37802d122e4a87c
> 
> /* 2p1c unbounded case */
> $ herd7 -unroll 0 -conf linux-kernel.cfg litmus-tests/mpsc-rb+2p1c+unbound.litmus
> Test mpsc-rb+2p1c+unbound Allowed
> States 3
> 0:rFail=0; 1:rFail=0; 2:rFail=0; cx=0; len1=1; len2=1; px=2;
> 0:rFail=0; 1:rFail=0; 2:rFail=0; cx=1; len1=1; len2=1; px=2;
> 0:rFail=0; 1:rFail=0; 2:rFail=0; cx=2; len1=1; len2=1; px=2;
> Ok
> Witnesses
> Positive: 42 Negative: 0
> Condition exists (0:rFail=0 /\ 1:rFail=0 /\ 2:rFail=0 /\ px=2 /\ len1=1 /\ len2=1 /\ (cx=0 \/ cx=1 \/ cx=2))
> Observation mpsc-rb+2p1c+unbound Always 42 0
> Time mpsc-rb+2p1c+unbound 39.19
> Hash=f0352aba9bdc03dd0b1def7d0c4956fa
> 
> /* 3p1c bounded case */
> $ herd7 -unroll 0 -conf linux-kernel.cfg mpsc-rb+3p1c+bounded.litmus
> Test mpsc+ringbuf-spinlock Allowed
> States 5
> 0:rFail=0; 1:rFail=0; 2:rFail=0; 3:rFail=0; cx=0; len1=1; len2=1; px=2;
> 0:rFail=0; 1:rFail=0; 2:rFail=0; 3:rFail=0; cx=1; len1=1; len2=1; px=2;
> 0:rFail=0; 1:rFail=0; 2:rFail=0; 3:rFail=0; cx=1; len1=1; len2=1; px=3;
> 0:rFail=0; 1:rFail=0; 2:rFail=0; 3:rFail=0; cx=2; len1=1; len2=1; px=2;
> 0:rFail=0; 1:rFail=0; 2:rFail=0; 3:rFail=0; cx=2; len1=1; len2=1; px=3;
> Ok
> Witnesses
> Positive: 558 Negative: 0
> Condition exists (0:rFail=0 /\ 1:rFail=0 /\ 2:rFail=0 /\ 3:rFail=0 /\ len1=1 /\ len2=1 /\ (px=2 /\ (cx=0 \/ cx=1 \/ cx=2) \/ px=3 /\ (cx=1 \/ cx=2)))
> Observation mpsc+ringbuf-spinlock Always 558 0
> Time mpsc+ringbuf-spinlock 57487.24
> Hash=133977dba930d167b4e1b4a6923d5687
> 
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../litmus-tests/mpsc-rb+1p1c+bounded.litmus  |  92 +++++++++++
>  .../litmus-tests/mpsc-rb+1p1c+unbound.litmus  |  83 ++++++++++
>  .../litmus-tests/mpsc-rb+2p1c+bounded.litmus  | 152 ++++++++++++++++++
>  .../litmus-tests/mpsc-rb+2p1c+unbound.litmus  | 137 ++++++++++++++++
>  4 files changed, 464 insertions(+)
>  create mode 100644 tools/memory-model/litmus-tests/mpsc-rb+1p1c+bounded.litmus
>  create mode 100644 tools/memory-model/litmus-tests/mpsc-rb+1p1c+unbound.litmus
>  create mode 100644 tools/memory-model/litmus-tests/mpsc-rb+2p1c+bounded.litmus
>  create mode 100644 tools/memory-model/litmus-tests/mpsc-rb+2p1c+unbound.litmus
> 
> diff --git a/tools/memory-model/litmus-tests/mpsc-rb+1p1c+bounded.litmus b/tools/memory-model/litmus-tests/mpsc-rb+1p1c+bounded.litmus
> new file mode 100644
> index 000000000000..cafd17afe11e
> --- /dev/null
> +++ b/tools/memory-model/litmus-tests/mpsc-rb+1p1c+bounded.litmus
> @@ -0,0 +1,92 @@
> +C mpsc-rb+1p1c+bounded
> +
> +(*
> + * Result: Always
> + *
> + * This litmus test validates BPF ring buffer implementation under the
> + * following assumptions:
> + * - 1 producer;
> + * - 1 consumer;
> + * - ring buffer has capacity for only 1 record.
> + *
> + * Expectations:
> + * - 1 record pushed into ring buffer;
> + * - 0 or 1 element is consumed.
> + * - no failures.
> + *)
> +
> +{
> +	max_len = 1;
> +	len1 = 0;
> +	px = 0;
> +	cx = 0;
> +	dropped = 0;
> +}
> +
> +P0(int *len1, int *cx, int *px)
> +{
> +	int *rLenPtr;
> +	int rLen;
> +	int rPx;
> +	int rCx;
> +	int rFail;
> +
> +	rFail = 0;
> +	rCx = smp_load_acquire(cx);
> +
> +	rPx = smp_load_acquire(px);
> +	if (rCx < rPx) {
> +		if (rCx == 0)
> +			rLenPtr = len1;
> +		else
> +			rFail = 1;
> +
> +		rLen = smp_load_acquire(rLenPtr);
> +		if (rLen == 0) {
> +			rFail = 1;
> +		} else if (rLen == 1) {
> +			rCx = rCx + 1;
> +			smp_store_release(cx, rCx);
> +		}
> +	}
> +}
> +
> +P1(int *len1, spinlock_t *rb_lock, int *px, int *cx, int *dropped, int *max_len)
> +{
> +	int rPx;
> +	int rCx;
> +	int rFail;
> +	int *rLenPtr;
> +
> +	rFail = 0;
> +	rCx = smp_load_acquire(cx);
> +
> +	spin_lock(rb_lock);
> +
> +	rPx = *px;
> +	if (rPx - rCx >= *max_len) {
> +		atomic_inc(dropped);
> +		spin_unlock(rb_lock);
> +	} else {
> +		if (rPx == 0)
> +			rLenPtr = len1;
> +		else
> +			rFail = 1;
> +
> +		*rLenPtr = -1;
> +		smp_wmb();
> +		smp_store_release(px, rPx + 1);
> +
> +		spin_unlock(rb_lock);
> +
> +		smp_store_release(rLenPtr, 1);
> +	}
> +}
> +
> +exists (
> +	0:rFail=0 /\ 1:rFail=0
> +	/\
> +	(
> +		(dropped=0 /\ px=1 /\ len1=1 /\ (cx=0 \/ cx=1))
> +	)
> +)
> diff --git a/tools/memory-model/litmus-tests/mpsc-rb+1p1c+unbound.litmus b/tools/memory-model/litmus-tests/mpsc-rb+1p1c+unbound.litmus
> new file mode 100644
> index 000000000000..84f660598015
> --- /dev/null
> +++ b/tools/memory-model/litmus-tests/mpsc-rb+1p1c+unbound.litmus
> @@ -0,0 +1,83 @@
> +C mpsc-rb+1p1c+unbound
> +
> +(*
> + * Result: Always
> + *
> + * This litmus test validates BPF ring buffer implementation under the
> + * following assumptions:
> + * - 1 producer;
> + * - 1 consumer;
> + * - ring buffer capacity is unbounded.
> + *
> + * Expectations:
> + * - 1 record pushed into ring buffer;
> + * - 0 or 1 element is consumed.
> + * - no failures.
> + *)
> +
> +{
> +	len1 = 0;
> +	px = 0;
> +	cx = 0;
> +}
> +
> +P0(int *len1, int *cx, int *px)
> +{
> +	int *rLenPtr;
> +	int rLen;
> +	int rPx;
> +	int rCx;
> +	int rFail;
> +
> +	rFail = 0;
> +	rCx = smp_load_acquire(cx);
> +
> +	rPx = smp_load_acquire(px);
> +	if (rCx < rPx) {
> +		if (rCx == 0)
> +			rLenPtr = len1;
> +		else
> +			rFail = 1;
> +
> +		rLen = smp_load_acquire(rLenPtr);
> +		if (rLen == 0) {
> +			rFail = 1;
> +		} else if (rLen == 1) {
> +			rCx = rCx + 1;
> +			smp_store_release(cx, rCx);
> +		}
> +	}
> +}
> +
> +P1(int *len1, spinlock_t *rb_lock, int *px, int *cx)
> +{
> +	int rPx;
> +	int rCx;
> +	int rFail;
> +	int *rLenPtr;
> +
> +	rFail = 0;
> +	rCx = smp_load_acquire(cx);
> +
> +	spin_lock(rb_lock);
> +
> +	rPx = *px;
> +	if (rPx == 0)
> +		rLenPtr = len1;
> +	else
> +		rFail = 1;
> +
> +	*rLenPtr = -1;
> +	smp_wmb();
> +	smp_store_release(px, rPx + 1);
> +
> +	spin_unlock(rb_lock);
> +
> +	smp_store_release(rLenPtr, 1);
> +}
> +
> +exists (
> +	0:rFail=0 /\ 1:rFail=0
> +	/\ px=1 /\ len1=1
> +	/\ (cx=0 \/ cx=1)
> +)
> diff --git a/tools/memory-model/litmus-tests/mpsc-rb+2p1c+bounded.litmus b/tools/memory-model/litmus-tests/mpsc-rb+2p1c+bounded.litmus
> new file mode 100644
> index 000000000000..900104c4933b
> --- /dev/null
> +++ b/tools/memory-model/litmus-tests/mpsc-rb+2p1c+bounded.litmus
> @@ -0,0 +1,152 @@
> +C mpsc-rb+2p1c+bounded
> +
> +(*
> + * Result: Always
> + *
> + * This litmus test validates BPF ring buffer implementation under the
> + * following assumptions:
> + * - 2 identical producers;
> + * - 1 consumer;
> + * - ring buffer has capacity for only 1 record.
> + *
> + * Expectations:
> + * - either 1 or 2 records are pushed into ring buffer;
> + * - 0, 1, or 2 elements are consumed by consumer;
> + * - appropriate number of dropped records is recorded to satisfy ring buffer
> + *   size bounds;
> + * - no failures.
> + *)
> +
> +{
> +	max_len = 1;
> +	len1 = 0;
> +	px = 0;
> +	cx = 0;
> +	dropped = 0;
> +}
> +
> +P0(int *len1, int *cx, int *px)
> +{
> +	int *rLenPtr;
> +	int rLen;
> +	int rPx;
> +	int rCx;
> +	int rFail;
> +
> +	rFail = 0;
> +	rCx = smp_load_acquire(cx);
> +
> +	rPx = smp_load_acquire(px);
> +	if (rCx < rPx) {
> +		if (rCx == 0)
> +			rLenPtr = len1;
> +		else if (rCx == 1)
> +			rLenPtr = len1;
> +		else
> +			rFail = 1;
> +
> +		rLen = smp_load_acquire(rLenPtr);
> +		if (rLen == 0) {
> +			rFail = 1;
> +		} else if (rLen == 1) {
> +			rCx = rCx + 1;
> +			smp_store_release(cx, rCx);
> +		}
> +	}
> +
> +	rPx = smp_load_acquire(px);
> +	if (rCx < rPx) {
> +		if (rCx == 0)
> +			rLenPtr = len1;
> +		else if (rCx == 1)
> +			rLenPtr = len1;
> +		else
> +			rFail = 1;
> +
> +		rLen = smp_load_acquire(rLenPtr);
> +		if (rLen == 0) {
> +			rFail = 1;
> +		} else if (rLen == 1) {
> +			rCx = rCx + 1;
> +			smp_store_release(cx, rCx);
> +		}
> +	}
> +}
> +
> +P1(int *len1, spinlock_t *rb_lock, int *px, int *cx, int *dropped, int *max_len)
> +{
> +	int rPx;
> +	int rCx;
> +	int rFail;
> +	int *rLenPtr;
> +
> +	rFail = 0;
> +	rCx = smp_load_acquire(cx);
> +
> +	spin_lock(rb_lock);
> +
> +	rPx = *px;
> +	if (rPx - rCx >= *max_len) {
> +		atomic_inc(dropped);
> +		spin_unlock(rb_lock);
> +	} else {
> +		if (rPx == 0)
> +			rLenPtr = len1;
> +		else if (rPx == 1)
> +			rLenPtr = len1;
> +		else
> +			rFail = 1;
> +
> +		*rLenPtr = -1;
> +		smp_wmb();
> +		smp_store_release(px, rPx + 1);
> +
> +		spin_unlock(rb_lock);
> +
> +		smp_store_release(rLenPtr, 1);
> +	}
> +}
> +
> +P2(int *len1, spinlock_t *rb_lock, int *px, int *cx, int *dropped, int *max_len)
> +{
> +	int rPx;
> +	int rCx;
> +	int rFail;
> +	int *rLenPtr;
> +
> +	rFail = 0;
> +	rCx = smp_load_acquire(cx);
> +
> +	spin_lock(rb_lock);
> +
> +	rPx = *px;
> +	if (rPx - rCx >= *max_len) {
> +		atomic_inc(dropped);
> +		spin_unlock(rb_lock);
> +	} else {
> +		if (rPx == 0)
> +			rLenPtr = len1;
> +		else if (rPx == 1)
> +			rLenPtr = len1;
> +		else
> +			rFail = 1;
> +
> +		*rLenPtr = -1;
> +		smp_wmb();
> +		smp_store_release(px, rPx + 1);
> +
> +		spin_unlock(rb_lock);
> +
> +		smp_store_release(rLenPtr, 1);
> +	}
> +}
> +
> +exists (
> +	0:rFail=0 /\ 1:rFail=0 /\ 2:rFail=0 /\ len1=1
> +	/\
> +	(
> +		(dropped = 0 /\ px=2 /\ (cx=1 \/ cx=2))
> +		\/
> +		(dropped = 1 /\ px=1 /\ (cx=0 \/ cx=1))
> +	)
> +)
> diff --git a/tools/memory-model/litmus-tests/mpsc-rb+2p1c+unbound.litmus b/tools/memory-model/litmus-tests/mpsc-rb+2p1c+unbound.litmus
> new file mode 100644
> index 000000000000..83372e9eb079
> --- /dev/null
> +++ b/tools/memory-model/litmus-tests/mpsc-rb+2p1c+unbound.litmus
> @@ -0,0 +1,137 @@
> +C mpsc-rb+2p1c+unbound
> +
> +(*
> + * Result: Always
> + *
> + * This litmus test validates BPF ring buffer implementation under the
> + * following assumptions:
> + * - 2 identical producers;
> + * - 1 consumer;
> + * - ring buffer capacity is unbounded.
> + *
> + * Expectations:
> + * - 2 records pushed into ring buffer;
> + * - 0, 1, or 2 elements are consumed.
> + * - no failures.
> + *)
> +
> +{
> +	len1 = 0;
> +	len2 = 0;
> +	px = 0;
> +	cx = 0;
> +}
> +
> +P0(int *len1, int *len2, int *cx, int *px)
> +{
> +	int *rLenPtr;
> +	int rLen;
> +	int rPx;
> +	int rCx;
> +	int rFail;
> +
> +	rFail = 0;
> +	rCx = smp_load_acquire(cx);
> +
> +	rPx = smp_load_acquire(px);
> +	if (rCx < rPx) {
> +		if (rCx == 0)
> +			rLenPtr = len1;
> +		else if (rCx == 1)
> +			rLenPtr = len2;
> +		else
> +			rFail = 1;
> +
> +		rLen = smp_load_acquire(rLenPtr);
> +		if (rLen == 0) {
> +			rFail = 1;
> +		} else if (rLen == 1) {
> +			rCx = rCx + 1;
> +			smp_store_release(cx, rCx);
> +		}
> +	}
> +
> +	rPx = smp_load_acquire(px);
> +	if (rCx < rPx) {
> +		if (rCx == 0)
> +			rLenPtr = len1;
> +		else if (rCx == 1)
> +			rLenPtr = len2;
> +		else
> +			rFail = 1;
> +
> +		rLen = smp_load_acquire(rLenPtr);
> +		if (rLen == 0) {
> +			rFail = 1;
> +		} else if (rLen == 1) {
> +			rCx = rCx + 1;
> +			smp_store_release(cx, rCx);
> +		}
> +	}
> +}
> +
> +P1(int *len1, int *len2, spinlock_t *rb_lock, int *px, int *cx)
> +{
> +	int rPx;
> +	int rCx;
> +	int rFail;
> +	int *rLenPtr;
> +
> +	rFail = 0;
> +	rCx = smp_load_acquire(cx);
> +
> +	spin_lock(rb_lock);
> +
> +	rPx = *px;
> +	if (rPx == 0)
> +		rLenPtr = len1;
> +	else if (rPx == 1)
> +		rLenPtr = len2;
> +	else
> +		rFail = 1;
> +
> +	*rLenPtr = -1;
> +	smp_wmb();
> +	smp_store_release(px, rPx + 1);
> +
> +	spin_unlock(rb_lock);
> +
> +	smp_store_release(rLenPtr, 1);
> +}
> +
> +P2(int *len1, int *len2, spinlock_t *rb_lock, int *px, int *cx)
> +{
> +	int rPx;
> +	int rCx;
> +	int rFail;
> +	int *rLenPtr;
> +
> +	rFail = 0;
> +	rCx = smp_load_acquire(cx);
> +
> +	spin_lock(rb_lock);
> +
> +	rPx = *px;
> +	if (rPx == 0)
> +		rLenPtr = len1;
> +	else if (rPx == 1)
> +		rLenPtr = len2;
> +	else
> +		rFail = 1;
> +
> +	*rLenPtr = -1;
> +	smp_wmb();
> +	smp_store_release(px, rPx + 1);
> +
> +	spin_unlock(rb_lock);
> +
> +	smp_store_release(rLenPtr, 1);
> +}
> +
> +exists (
> +	0:rFail=0 /\ 1:rFail=0 /\ 2:rFail=0
> +	/\
> +	px=2 /\ len1=1 /\ len2=1
> +	/\
> +	(cx=0 \/ cx=1 \/ cx=2)
> +)
> -- 
> 2.24.1
> 
