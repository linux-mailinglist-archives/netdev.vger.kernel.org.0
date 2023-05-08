Return-Path: <netdev+bounces-973-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A97B6FB973
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 23:22:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 835C7281154
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C3F411CAB;
	Mon,  8 May 2023 21:22:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F918837
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 21:22:33 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5429E18F;
	Mon,  8 May 2023 14:22:02 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1683580875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=UlKnzlV2CBsOhxdrRm8APS819yryW8jqfoG5zjjpDKw=;
	b=MH1v+zK9fHG2vxTocUbW0jzaC8HBnzijeq1HyjaYs2bwEFisXOOKdFjPT3FGqrMer6qwfe
	vHMAiYCFb079mFGpNI3s9VqMjchBERtFJ1+dPV9+MlahssywhPrlXpbqoQ4oHclFZmbVbQ
	p3cT8BmcdNjBws7fQGqjcK+HeVEJ9o0rd+I7mFAaO1B6tMdbcPhNSr/AvtUDO6eKZcZMxo
	NzUigo/jsmx25dYon6e2hgKwhXUldI6UrMv/LD3HW7nq+0O/TyEChWfkIT6EEG4j33WTG0
	G7DOtaObis7u1ZaVsLXP+SVYU58Z+uZ28ugkdhV3zTZmDtd1hHXfXCOf59C8YQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1683580875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=UlKnzlV2CBsOhxdrRm8APS819yryW8jqfoG5zjjpDKw=;
	b=kIy+UGDQ/cYzR2AME/HgouG+qcCwymugSew+T5cMHVAj2EOksG/Sf1IDTOJqUqIWV6WSW2
	sjpXR2m9/MsAVdDQ==
To: Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@kernel.org>, peterz@infradead.org,
 netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, Jason Xing
 <kerneljasonxing@gmail.com>, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] revert: "softirq: Let ksoftirqd do its job"
In-Reply-To: <57e66b364f1b6f09c9bc0316742c3b14f4ce83bd.1683526542.git.pabeni@redhat.com>
Date: Mon, 08 May 2023 23:21:14 +0200
Message-ID: <87bkiu34fp.ffs@tglx>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Paolo!

On Mon, May 08 2023 at 08:17, Paolo Abeni wrote:
> Due to the mentioned commit, when the ksoftirqd processes take charge
> of softirq processing, the system can experience high latencies.
>
> In the past a few workarounds have been implemented for specific
> side-effects of the above:
>
> commit 1ff688209e2e ("watchdog: core: make sure the watchdog_worker is not deferred")
> commit 8d5755b3f77b ("watchdog: softdog: fire watchdog even if softirqs do not get to run")
> commit 217f69743681 ("net: busy-poll: allow preemption in sk_busy_loop()")
> commit 3c53776e29f8 ("Mark HI and TASKLET softirq synchronous")
>
> but the latency problem still exists in real-life workloads, see the
> link below.
>
> The reverted commit intended to solve a live-lock scenario that can now
> be addressed with the NAPI threaded mode, introduced with commit
> 29863d41bb6e ("net: implement threaded-able napi poll loop support"),
> and nowadays in a pretty stable status.
>
> While a complete solution to put softirq processing under nice resource
> control would be preferable, that has proven to be a very hard task. In
> the short term, remove the main pain point, and also simplify a bit the
> current softirq implementation.
>
> Note that this change also reverts commit 3c53776e29f8 ("Mark HI and
> TASKLET softirq synchronous") and commit 1342d8080f61 ("softirq: Don't
> skip softirq execution when softirq thread is parking"), which are
> direct follow-ups of the feature commit. A single change is preferred to
> avoid known bad intermediate states introduced by a patch series
> reverting them individually.

I'm fine with this change, but I definitely want that to be
acked/reviewed by the other stakeholders in the networking arena.

Thanks,

        tglx

