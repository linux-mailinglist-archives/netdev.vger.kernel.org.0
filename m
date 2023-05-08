Return-Path: <netdev+bounces-921-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 194256FB61B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:51:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77FCD28106C
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D75679DB;
	Mon,  8 May 2023 17:51:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578306110
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 17:51:46 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ED744A0;
	Mon,  8 May 2023 10:51:44 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1683568301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xBM5m6wDNW8LeDu3c/o/2yvJ8k64BJF0JoE591jbLbA=;
	b=sMXXfFh+31ZYLnj/Q/317zJ8ZSNPWFhoFiud2U76+34ZcjDHzfH94OqL5J7Cq08AktHEob
	jScu3BBU+qL6S/lcL3VxvFTcbres7JXXNwc90R7lK1wlwr2ZmAigc0dIvG5AV6JAzorBaq
	DIpcER3iASDOuzirPArCyeojNdahXrhqv4d/Uweihy+eMCslrpiZjVjkedRt1mJY4raFyK
	YgUIvPPYtt7wKOkz2+m2PZtlqlM8wnC8SGGOKlzyhUWXe5PLhj9G2a/vKTQIm9Ki6XKPrl
	ry4fY2g0q5I7fMBhPRATR4Kgl2/343VnWymkfbnsQx7N+fW0pldcN8wNrV6oMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1683568301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xBM5m6wDNW8LeDu3c/o/2yvJ8k64BJF0JoE591jbLbA=;
	b=FKKYbkze0DTjbg51KVCUWSLfNiUsicv5XAC0hJm2+JvwoRzcsJXs/xUt9yUiE5d6ajXhX2
	oLbHvKULh49aPoDw==
To: Jason Xing <kerneljasonxing@gmail.com>, Liu Jian <liujian56@huawei.com>
Cc: corbet@lwn.net, paulmck@kernel.org, frederic@kernel.org,
 quic_neeraju@quicinc.com, joel@joelfernandes.org, josh@joshtriplett.org,
 boqun.feng@gmail.com, rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
 jiangshanlai@gmail.com, qiang1.zhang@intel.com, jstultz@google.com,
 sboyd@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, peterz@infradead.org,
 frankwoo@google.com, Rhinewuwu@google.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/9] softirq: Use sched_clock() based timeout
In-Reply-To: <CAL+tcoDY11sSO8_h1DKCWgAXOjQwM1JR5cx7cpmotWVj28m_fg@mail.gmail.com>
References: <20230505113315.3307723-1-liujian56@huawei.com>
 <20230505113315.3307723-3-liujian56@huawei.com>
 <CAL+tcoDY11sSO8_h1DKCWgAXOjQwM1JR5cx7cpmotWVj28m_fg@mail.gmail.com>
Date: Mon, 08 May 2023 19:51:41 +0200
Message-ID: <87cz3a3e4y.ffs@tglx>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08 2023 at 12:08, Jason Xing wrote:
> On Fri, May 5, 2023 at 7:25=E2=80=AFPM Liu Jian <liujian56@huawei.com> wr=
ote:
>> @@ -489,7 +490,7 @@ asmlinkage __visible void do_softirq(void)
>>   * we want to handle softirqs as soon as possible, but they
>>   * should not be able to lock up the box.
>>   */
>> -#define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
>> +#define MAX_SOFTIRQ_TIME       (2 * NSEC_PER_MSEC)
>
> I wonder if it affects those servers that set HZ to some different
> values rather than 1000 as default.

The result of msecs_to_jiffies(2) for different HZ values:

HZ=3D100     1
HZ=3D250     1
HZ=3D1000    2

So depending on when the softirq processing starts, this gives the
following ranges in which the timeout ends:

HZ=3D100    0 - 10ms
HZ=3D250    0 -  4ms
HZ=3D1000   1 -  2ms

But as the various softirq handlers have their own notion of timeouts,
loop limits etc. and the timeout is only checked after _all_ pending
bits of each iteration have been processed, the outcome of this is all
lottery.

Due to that the sched_clock() change per se won't have too much impact,
but if the overall changes to consolidate the break conditions are in
place, I think it will have observable effects.

Making this consistent is definitely a good thing, but it won't solve
the underlying problem of soft interrupt processing at all.

We definitely need to spend more thoughts on pulling things out of soft
interrupt context so that these functionalities get under proper
resource control by the scheduler.

Thanks,

        tglx

