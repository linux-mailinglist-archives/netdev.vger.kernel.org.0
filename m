Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFE145268E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 03:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244922AbhKPCHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 21:07:15 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:48956 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359221AbhKPCFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 21:05:05 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637028124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZMg9fmCqWKgDZlhQO/4xgIOO/cxGdUEDsgEbELE2koQ=;
        b=PtGsSqdS8ZFYHVR2YNOxGNnN/l/ScW3r6zS+JRsqXtGURSw1/d++9cng0m8QsxTPec6PMB
        1CtzNH0eqcqkJuvd3MOAtIFVRVggGjrxIMJk8u4xYq/CU+Ac8DKHhzLQwdOYaKGumXr3ah
        l284rMDtcn1T1v6Nh8roCJIGKm/knCIctjxRf5DHCVpqvhAK87/rHs6zq1LFmpLMtbn+aU
        UvtujUb+Qu7r0i26TMqEi8NC9bSbFbx+MygM/SziKFOnmVpJjz8dC+awYcSTk7H8USirVa
        mdebv+ZN1CgSMDrZWrhqW2Sg0CvfyP+O1gMoQYx+xfiNAZvAqYFjckUloWZ+kQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637028124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZMg9fmCqWKgDZlhQO/4xgIOO/cxGdUEDsgEbELE2koQ=;
        b=gkvX//yqjD7yr+ZB45nM18+mQVrYM6MVMWx6PQlYrcVQ2R+ZD4QQpDFL2xXuMNLBMFoX1B
        LPbpJcRVhexAt3Aw==
To:     Dmitrii Banshchikov <me@ubique.spb.ru>, bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, rdna@fb.com,
        syzbot+43fd005b5a1b4d10781e@syzkaller.appspotmail.com
Subject: Re: [PATCH bpf v2 1/2] bpf: Forbid bpf_ktime_get_coarse_ns and
 bpf_timer_* in tracing progs
In-Reply-To: <20211113142227.566439-2-me@ubique.spb.ru>
References: <20211113142227.566439-1-me@ubique.spb.ru>
 <20211113142227.566439-2-me@ubique.spb.ru>
Date:   Tue, 16 Nov 2021 03:02:03 +0100
Message-ID: <87o86k6ep0.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitrii.

On Sat, Nov 13 2021 at 18:22, Dmitrii Banshchikov wrote:
> Use of bpf_ktime_get_coarse_ns() and bpf_timer_* helpers in tracing
> progs may result in locking issues.

"may result in locking issues"? There is no 'may'. This is simply a matter
of fact that this can and will result in deadlocks. Please spell it out.

It's a bug, so what. Why do you need to whitewash it?
.
> @@ -4632,6 +4632,9 @@ union bpf_attr {
>   * 		system boot, in nanoseconds. Does not include time the system
>   * 		was suspended.
>   *
> + *		Tracing programs cannot use **bpf_ktime_get_coarse_ns**\() (but
> + *		this may change in the future).

Sorry no. This is a bug fix and there is no place for 'may change in the
future' nonsense. It's simply not possible right now and unless you have
a plan to make this work backed up by actual patches this comment is
worse than wishful thinking.

> + *
>   * 		See: **clock_gettime**\ (**CLOCK_MONOTONIC_COARSE**)
>   * 	Return
>   * 		Current *ktime*.
> @@ -4804,6 +4807,9 @@ union bpf_attr {
>   *		All other bits of *flags* are reserved.
>   *		The verifier will reject the program if *timer* is not from
>   *		the same *map*.
> + *
> + *		Tracing programs cannot use **bpf_timer_init**\() (but this may
> + *		change in the future).

This is even worse than the above because it cannot happen ever. Please
stop this nonsensical wishful thinking crap. It does not add any value,
it just adds confusion.

Timers will have to take spinlocks no matter what even if the kernel has
been reimplemented in BPF someday. Tracing happens at any arbitrary
place which includes places inisde locked sections. So what are you
hallucinating about?

I completely understand that you are all enthused about the "unlimited"
power of BPF, but please take a step back and understand that BPF has
very well defined limitations as any other instrumentation facility has.

That said, I agree with the code changes but I vehemently NAK comments
which are built on wishful thinking or worse.

Thanks,

        tglx
