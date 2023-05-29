Return-Path: <netdev+bounces-6180-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6889A7150E7
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 23:20:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23625280F84
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 21:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938E210964;
	Mon, 29 May 2023 21:20:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE087C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 21:20:14 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58872C7;
	Mon, 29 May 2023 14:20:11 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1685395209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vZhBQR9q3SUgg9iCc2i3JVyzYRPAGeV4tGL2QQEIHxY=;
	b=DfekSqJwFtryBc4U81a/ZMaRxU/dd0Q0WqYqonNTIqUnongfhsRvLEVeK5Y4pRy//d+shy
	CRwZpQki2MEKgOeZfKTKRoEiGfevOCcsLXcXwDM0YwPuPgYSrg/6aA9r948R2oHMZ/1DSz
	UCRnJrrBuelJdpFnnJlO3QQ0iVRp1e4dBiKRO/P74bZnJSoxbaI1xAR3HxXiV53A1k0Jqf
	VaLpudER9rlyYOSziMfZ5rAR5WbeHatW6ENiI0o5Z5ZFp3REHm7DAcjEX0QZtDENWeceDH
	53om/U+BqVPdXq1o1nPFxQjrnH/TWZJ5YOUAX8mYoXmY4VG66h7CZn/lMz6RXw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1685395209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vZhBQR9q3SUgg9iCc2i3JVyzYRPAGeV4tGL2QQEIHxY=;
	b=nDMrrKXgx86380d3HBnm5A7se+PRD4eT7Ab7LXrJmfLK2S9p+pTBJYA78fichvfJCwl3R6
	lUrPpgOWwune1aBw==
To: Chuck Lever III <chuck.lever@oracle.com>, Eli Cohen <elic@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 linux-rdma <linux-rdma@vger.kernel.org>, "open list:NETWORKING [GENERAL]"
 <netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
In-Reply-To: <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
 <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com>
Date: Mon, 29 May 2023 23:20:09 +0200
Message-ID: <875y8altrq.ffs@tglx>
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

On Sat, May 27 2023 at 20:16, Chuck Lever, III wrote:
>> On May 7, 2023, at 1:31 AM, Eli Cohen <elic@nvidia.com> wrote:
> I can boot the system with mlx5_core deny-listed. I log in, remove
> mlx5_core from the deny list, and then "modprobe mlx5_core" to
> reproduce the issue while the system is running.
>
> May 27 15:47:45 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: firmware version: 16.35.2000
> May 27 15:47:45 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
> May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc: pool=ffff9a3718e56180 i=0 af_desc=ffffb6c88493fc90
> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a3aefcf0f80 m->system_map=ffff9a33801990d0 end=236
> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a3aefcf0f60 end=236
> May 27 15:47:46 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: Port module event: module 0, Cable plugged
> May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc: pool=ffff9a3718e56180 i=1 af_desc=ffffb6c88493fc60
> May 27 15:47:46 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: mlx5_pcie_event:301:(pid 10): PCIe slot advertised sufficient power (27W).
> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a36efcf0f80 m->system_map=ffff9a33801990d0 end=236
> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a36efcf0f60 end=236
> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a36efd30f80 m->system_map=ffff9a33801990d0 end=236
> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a36efd30f60 end=236
> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a3aefc30f80 m->system_map=ffff9a33801990d0 end=236
> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a3aefc30f60 end=236
> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a3aefc70f80 m->system_map=ffff9a33801990d0 end=236
> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a3aefc70f60 end=236
> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a3aefd30f80 m->system_map=ffff9a33801990d0 end=236
> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a3aefd30f60 end=236
> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a3aefd70f80 m->system_map=ffff9a33801990d0 end=236
> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a3aefd70f60 end=236
> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch_map=ffff9a33801990b0 cm->managed_map=ffffffffb9ef3f80 m->system_map=ffff9a33801990d0 end=236
> May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handle page fault for address: ffffffffb9ef3f80
>
> ###
>
> The fault address is the cm->managed_map for one of the CPUs.

That does not make any sense at all. The irq matrix is initialized via:

irq_alloc_matrix()
  m = kzalloc(sizeof(matric);
  m->maps = alloc_percpu(*m->maps);

So how is any per CPU map which got allocated there supposed to be
invalid (not mapped):

> May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handle page fault for address: ffffffffb9ef3f80
> May 27 15:47:47 manet.1015granger.net kernel: #PF: supervisor read access in kernel mode
> May 27 15:47:47 manet.1015granger.net kernel: #PF: error_code(0x0000) - not-present page
> May 27 15:47:47 manet.1015granger.net kernel: PGD 54ec19067 P4D 54ec19067 PUD 54ec1a063 PMD 482b83063 PTE 800ffffab110c062

But if you look at the address: 0xffffffffb9ef3f80

That one is bogus:

     managed_map=ffff9a36efcf0f80
     managed_map=ffff9a36efd30f80
     managed_map=ffff9a3aefc30f80
     managed_map=ffff9a3aefc70f80
     managed_map=ffff9a3aefd30f80
     managed_map=ffff9a3aefd70f80
     managed_map=ffffffffb9ef3f80

Can you spot the fail?

The first six are in the direct map and the last one is in module map,
which makes no sense at all.

Can you please apply the debug patch below and provide the output?

Thanks,

        tglx
---
--- a/kernel/irq/matrix.c
+++ b/kernel/irq/matrix.c
@@ -51,6 +51,7 @@ struct irq_matrix {
 					   unsigned int alloc_end)
 {
 	struct irq_matrix *m;
+	unsigned int cpu;
 
 	if (matrix_bits > IRQ_MATRIX_BITS)
 		return NULL;
@@ -68,6 +69,8 @@ struct irq_matrix {
 		kfree(m);
 		return NULL;
 	}
+	for_each_possible_cpu(cpu)
+		pr_info("ALLOC: CPU%03u: %016lx\n", cpu, (unsigned long)per_cpu_ptr(m->maps, cpu));
 	return m;
 }
 
@@ -215,6 +218,8 @@ int irq_matrix_reserve_managed(struct ir
 		struct cpumap *cm = per_cpu_ptr(m->maps, cpu);
 		unsigned int bit;
 
+		pr_info("RESERVE MANAGED: CPU%03u: %016lx\n", cpu, (unsigned long)cm);
+
 		bit = matrix_alloc_area(m, cm, 1, true);
 		if (bit >= m->alloc_end)
 			goto cleanup;

