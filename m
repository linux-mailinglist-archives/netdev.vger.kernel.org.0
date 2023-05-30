Return-Path: <netdev+bounces-6586-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC3F717095
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 452541C20BFB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C138B31F1F;
	Tue, 30 May 2023 22:18:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C9B200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:18:05 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04C6E5;
	Tue, 30 May 2023 15:18:03 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1685485080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wHZUUj1tNSUyzp9PSZIaBjvkp+dLnVq2t4l4ybLo6TI=;
	b=HJVvamV4MCcrVXGflg0x1onaFEmqTHuV1e9FSzN/CQl8nzmxL6kx01M7WhLUVx3DkkZLje
	+9A8kP51WntmS9/cm2qIl7xYoF6naQofz9H2hh5HasGOu1FyttbGa/I3AS+hBVP/7N5r4i
	/5H7uwexAlXnKe34X75cUS+BFfhQdrTLPoNPpRq+I34NhkmdBgj/OdTHsznMaH3IrsHFQP
	GCF6mh4qqQlJ8WVHvKe34CBoauq1IBQuMhlz8fvXC+jAsHq9+UG6yjpMepHvcYIqH/nugI
	cgc9EBkcjwdbpiwSEd6Mae6SMv1xfCqNNOf7Lx0gfAFQgMp9Mk2aZHPzrvgwQg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1685485080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wHZUUj1tNSUyzp9PSZIaBjvkp+dLnVq2t4l4ybLo6TI=;
	b=3mRwzGB+yh3VbfQowWBV6P/JTxyEamVtA7QgFxF40GTGVWnNJMo2tEOv2KgVcqNGw0cbfh
	lpxVVKhObtk4p3Cg==
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Saeed
 Mahameed <saeedm@nvidia.com>, linux-rdma <linux-rdma@vger.kernel.org>, "open
 list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
In-Reply-To: <C34181E7-A515-4BD1-8C38-CB8BCF2D987D@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
 <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com> <875y8altrq.ffs@tglx>
 <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com> <87o7m1iov9.ffs@tglx>
 <C34181E7-A515-4BD1-8C38-CB8BCF2D987D@oracle.com>
Date: Wed, 31 May 2023 00:17:59 +0200
Message-ID: <87sfbdh3ag.ffs@tglx>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30 2023 at 21:48, Chuck Lever III wrote:
>> On May 30, 2023, at 3:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> cpumask_copy(d, s)
>>   bitmap_copy(d, s, nbits = 32)
>>     len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
>> 
>> So it copies as many longs as required to cover nbits, i.e. it copies
>> any clobbered bits beyond nbits too. While that looks odd at the first
>> glance, that's just an optimization which is harmless.
>> 
>> for_each_cpu() finds the next set bit in a mask and breaks the loop once
>> bitnr >= small_cpumask_bits, which is nr_cpu_ids and should be 32 too.
>> 
>> I just booted a kernel with NR_CPUS=32:
>
> My system has only 12 CPUs. So every bit in your mask represents
> a present CPU, but on my system, only 0x00000fff are ever present.
>
> Therefore, on my system, any bit higher than bit 11 in a CPU mask
> will reference a CPU that is not present.

Correct....

Sorry, I missed the part that your machine has only 12 CPUs....

Now I can reproduce the wreckage even with that trivial test I did:

[    0.210089] setup_percpu: NR_CPUS:32 nr_cpumask_bits:12 nr_cpu_ids:12 nr_node_ids:1
...
[    0.606591] smp: MASKBITS: 5555555555555555
[    0.607026] smp: CPUs: 0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30

I'm way too tired to make sense of that right now. Will have a look at
it tomorrow with brain awake unless you beat me to it.

That's one mystery but the other one is this:

[   71.273798][ T1185] irq_matrix_reserve_managed: MASKBITS:   ffffb1a74686bcd8

That's clearly a kernel address within the direct map. How does that end
up as content of a cpumask?

Thanks,

        tglx

