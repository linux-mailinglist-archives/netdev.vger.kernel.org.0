Return-Path: <netdev+bounces-6543-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BE41716DE4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A1A2281279
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C23F2D272;
	Tue, 30 May 2023 19:46:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE043200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:46:38 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF2EC9;
	Tue, 30 May 2023 12:46:37 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1685475995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0lqf16k56ICJR3f6afGNeInQg8eM22KZlAGnGhYDryg=;
	b=o6vZpXSfbD9F9sDMrCjUtZkQHJEhNpIRrQCrBSW6Iq8s4kwZS4LB+IMH34MON/awYWSJ75
	rCNYEIhS8kMeB4cwK4YIdVcCzFWjWLROOsqxvuxzt4T7LuIasgW6UYg8IZpgKR4IWWSnkI
	cfaeFzvQ5DyTL+P77UgzfLrLaylkJ4pX9B6655stTFkCD+ZTlYf06soGLEn06X4P00KxmN
	22ZiLuI/hWHoMIAk+CdWCKXf9rHuUmoJIgswkus2zWQZUP8VU9baKSymZLRdWEMpbAbUKC
	t7xcWC6UN0ANqlpeFMjLelUMGt4KLqm1uV/6z6WrPO0Z7CO+adyLcevcj1kQ7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1685475995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0lqf16k56ICJR3f6afGNeInQg8eM22KZlAGnGhYDryg=;
	b=1ZLGV/9rlBhLnHdhKrGpeHGlteJDyZ0T1HJ2kfH59OnroTZzRc3FLQKliCW2RLbTxBkvvx
	xqFkAmEwC5LDrpAA==
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Saeed
 Mahameed <saeedm@nvidia.com>, linux-rdma <linux-rdma@vger.kernel.org>, "open
 list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
In-Reply-To: <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
 <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com> <875y8altrq.ffs@tglx>
 <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com>
Date: Tue, 30 May 2023 21:46:34 +0200
Message-ID: <87o7m1iov9.ffs@tglx>
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

Chuck!

On Tue, May 30 2023 at 13:09, Chuck Lever III wrote:
>> On May 29, 2023, at 5:20 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> But if you look at the address: 0xffffffffb9ef3f80
>> 
>> That one is bogus:
>> 
>>     managed_map=ffff9a36efcf0f80
>>     managed_map=ffff9a36efd30f80
>>     managed_map=ffff9a3aefc30f80
>>     managed_map=ffff9a3aefc70f80
>>     managed_map=ffff9a3aefd30f80
>>     managed_map=ffff9a3aefd70f80
>>     managed_map=ffffffffb9ef3f80
>> 
>> Can you spot the fail?
>> 
>> The first six are in the direct map and the last one is in module map,
>> which makes no sense at all.
>
> Indeed. The reason for that is that the affinity mask has bits
> set for CPU IDs that are not present on my system.

Which I don't buy, but even if so then this should not make
for_each_cpu() go south. See below.

> After bbac70c74183 ("net/mlx5: Use newer affinity descriptor")
> that mask is set up like this:
>
>  struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
>  {
>         struct mlx5_irq_pool *pool = ctrl_irq_pool_get(dev);
> -       cpumask_var_t req_mask;
> +       struct irq_affinity_desc af_desc;

That's daft. With NR_CPUS=8192 this is a whopping 1KB on stack...

>         struct mlx5_irq *irq;
> -       if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
> -               return ERR_PTR(-ENOMEM);
> -       cpumask_copy(req_mask, cpu_online_mask);
> +       cpumask_copy(&af_desc.mask, cpu_online_mask);
> +       af_desc.is_managed = false;
>
> Which normally works as you would expect. But for some historical
> reason, I have CONFIG_NR_CPUS=32 on my system, and the
> cpumask_copy() misbehaves.
>
> If I correct mlx5_ctrl_irq_request() to clear @af_desc before the
> copy, this crash goes away. But mlx5_core crashes during a later
> part of its init, in cpu_rmap_update(). cpu_rmap_update() does
> exactly the same thing (for_each_cpu() on an affinity mask created
> by copying), and crashes in a very similar fashion.
>
> If I set CONFIG_NR_CPUS to a larger value, like 512, the problem
> vanishes entirely, and "modprobe mlx5_core" works as expected.
>
> Thus I think the problem is with cpumask_copy() or for_each_cpu()
> when NR_CPUS is a small value (the default is 8192).

I don't buy any of this. Here is why:

cpumask_copy(d, s)
   bitmap_copy(d, s, nbits = 32)
     len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);

So it copies as many longs as required to cover nbits, i.e. it copies
any clobbered bits beyond nbits too. While that looks odd at the first
glance, that's just an optimization which is harmless.

for_each_cpu() finds the next set bit in a mask and breaks the loop once
bitnr >= small_cpumask_bits, which is nr_cpu_ids and should be 32 too.

I just booted a kernel with NR_CPUS=32:

[    0.152988] smpboot: 56 Processors exceeds NR_CPUS limit of 32
[    0.153606] smpboot: Allowing 32 CPUs, 0 hotplug CPUs
...
[    0.173854] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:32 nr_node_ids:1

and added a function which does:

    struct cpumask ma, mb;
    int cpu;

    memset(&ma, 0xaa, sizeof(ma);
    cpumask_copy(&mb, &ma);
    pr_info("MASKBITS: %016lx\n", mb.bits[0]);
    pr_info("CPUs:");
    for_each_cpu(cpu, &mb)
         pr_cont(" %d", cpu);
    pr_cont("\n");

[    2.165606] smp: MASKBITS: 0xaaaaaaaaaaaaaaaa
[    2.166574] smp: CPUs: 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31

and the same exercise with a 0x55 filled source bitmap.

[    2.167595] smp: MASKBITS: 0x5555555555555555
[    2.168568] smp: CPUs: 0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30

So while cpumask_copy copied beyond NR_CPUs bits, for_each_cpu() does
the right thing simple because of this:

nr_cpu_ids is 32, right?

for_each_cpu(cpu, mask)
   for_each_set_bit(bit = cpu, addr = &mask, size = nr_cpu_ids)
	for ((bit) = 0; (bit) = find_next_bit((addr), (size), (bit)), (bit) < (size); (bit)++)

So if find_next_bit() returns a bit after bit 31 the condition (bit) <
(size) will terminate the loop, right?

Also in the case of that driver the copy is _NOT_ copying set bits
beyond bit 31 simply because the source mask is cpu_online_mask which
definitely does not have a bit set which is greater than 31. As the copy
copies longs the resulting mask in af_desc.mask cannot have any bit set
past bit 31 either.

If the above is not correct, then there is a bigger problem than that
MLX5 driver crashing.

So this:

> If I correct mlx5_ctrl_irq_request() to clear @af_desc before the
> copy, this crash goes away.

does not make any sense to me.

Can you please add after the cpumask_copy() in that mlx5 code:

    pr_info("ONLINEBITS: %016lx\n", cpu_online_mask->bits[0]);
    pr_info("MASKBITS:   %016lx\n", af_desc.mask.bits[0]);

Please print also in irq_matrix_reserve_managed():

  - @mask->bits[0]
  - nr_cpu_ids
  - the CPU numbers inside the for_each_cpu() loop

Thanks,

        tglx

