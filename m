Return-Path: <netdev+bounces-6903-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1059718A03
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:19:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 938ED1C20EC9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128421C772;
	Wed, 31 May 2023 19:19:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F72805
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 19:19:22 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AA6107;
	Wed, 31 May 2023 12:19:20 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1685560758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+IEgm0Xi5dbPm2rVxANwG2MNPxO7N4aGGD2/UFmfqUg=;
	b=YB36wuSCbDW8j0s0MMi3KgToCOAfiO2tedJOEM54fdP4qiF0a3VUe4nPQu0qNlCgwcySvC
	/8Ck5wduDm3zzI1VAUmOpqNsahBT2W6FAzBK2IBHiYSq97q0qvRGqFpqUaAvMeom2nO9QD
	rH717BdrTmarrFtXKIBq9kf45gGKWkUOdBGTzayjis7x84b7WRRMTsssXRoOiSS+7ftUHU
	Q8fy0Yvv0c7lHRvVPQr/X59Vsz1XCZj6/aQ4D7cJUaMZjfryK7t3UwIqj5xzUJi/GCojmy
	XVDDB4TbRQP7o+Iq07HEzqqQhmhJmIuZB0bNEUy2p3ECYbWrbdlZED0/h5GAjw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1685560758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+IEgm0Xi5dbPm2rVxANwG2MNPxO7N4aGGD2/UFmfqUg=;
	b=yEB64TUWeh68qP3Sul1aexP71OdEUMbCLYXyyI0sVMuZ7pH+QfB9HOSQ5QdQsMCiY8Y4A1
	ADnMa7vWKYCwQQBg==
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Saeed
 Mahameed <saeedm@nvidia.com>, linux-rdma <linux-rdma@vger.kernel.org>, "open
 list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, Peter Zijlstra
 <peterz@infradead.org>
Subject: Re: system hang on start-up (mlx5?)
In-Reply-To: <7AECA9A6-1F7D-4F82-A4C1-83616D4D6566@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
 <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com> <875y8altrq.ffs@tglx>
 <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com> <87o7m1iov9.ffs@tglx>
 <C34181E7-A515-4BD1-8C38-CB8BCF2D987D@oracle.com> <87ttvsftoc.ffs@tglx>
 <48B0BC74-5F5C-4212-BC5A-552356E9FFB1@oracle.com> <87leh4fmsg.ffs@tglx>
 <7AECA9A6-1F7D-4F82-A4C1-83616D4D6566@oracle.com>
Date: Wed, 31 May 2023 21:19:17 +0200
Message-ID: <87353cfgwa.ffs@tglx>
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

On Wed, May 31 2023 at 18:52, Chuck Lever III wrote:
>> On May 31, 2023, at 1:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> This addresses the problem for me with both is_managed = 1
> and is_managed = false:
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> index db5687d9fec9..bcf5df316c8f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> @@ -570,11 +570,11 @@ int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
>         af_desc.is_managed = false;
>         for (i = 0; i < nirqs; i++) {
> +               cpumask_clear(&af_desc.mask);
>                 cpumask_set_cpu(cpus[i], &af_desc.mask);
>                 irq = mlx5_irq_request(dev, i + 1, &af_desc, rmap);
>                 if (IS_ERR(irq))
>                         break;
> -               cpumask_clear(&af_desc.mask);
>                 irqs[i] = irq;
>         }
>
> If you agree this looks reasonable, I can package it with a
> proper patch description and send it to Eli and Saeed.

It does. I clearly missed that function when going through the possible
callchains. Yes, that's definitely broken and the fix is correct.

bbac70c74183 ("net/mlx5: Use newer affinity descriptor") is the culprit.

Feel free to add:

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>





