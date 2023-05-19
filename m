Return-Path: <netdev+bounces-3836-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A69E5709119
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B25A1C2122B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86837210B;
	Fri, 19 May 2023 08:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ABF20FE
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAAE4C4339E;
	Fri, 19 May 2023 08:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684483221;
	bh=sPRtpa2e0A1/1AI5Gdf3fcX269ohaGrXmwq0lvmMkCc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OV8c+XnXMvooXSBZzdK68WhqXtlmOrWm2QsYRg13wZxyJUrJ6ASI3Ca5GRVbuKbwN
	 kyc8QTlgITK0eH+DDI5p9HH3JZYFZEmNCYbwa45WXltdPqmY26sgwJyCopaSUwMyFw
	 W8SzoiDQDfRew4l0XXVG4AEVO3dV/qEjt6C3cjLUepBx7CpnEHC/xj0DTCaVvJHuSX
	 wK37lpi8oUUIRyMIwq7qddSzl3knBHDZsO7ucS9opL9EQlKztZy2s5cBXYryOtRU5U
	 /4CyrISWK4h/uMq0gEWQ8Ay9MYsJ34JEL1+SKZUV5dBJA1/QMp1dFgK0DyQc5eRwN8
	 NkePpPzQ82AAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C943CC73FE0;
	Fri, 19 May 2023 08:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: Reset connection when trying to use SMCRv2
 fails.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168448322080.32188.9310241476362959617.git-patchwork-notify@kernel.org>
Date: Fri, 19 May 2023 08:00:20 +0000
References: <1684386895-112162-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1684386895-112162-1-git-send-email-guwen@linux.alibaba.com>
To: Wen Gu <guwen@linux.alibaba.com>
Cc: kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, liuyacan@corp.netease.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 May 2023 13:14:55 +0800 you wrote:
> We found a crash when using SMCRv2 with 2 Mellanox ConnectX-4. It
> can be reproduced by:
> 
> - smc_run nginx
> - smc_run wrk -t 32 -c 500 -d 30 http://<ip>:<port>
> 
>  BUG: kernel NULL pointer dereference, address: 0000000000000014
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 8000000108713067 P4D 8000000108713067 PUD 151127067 PMD 0
>  Oops: 0000 [#1] PREEMPT SMP PTI
>  CPU: 4 PID: 2441 Comm: kworker/4:249 Kdump: loaded Tainted: G        W   E      6.4.0-rc1+ #42
>  Workqueue: smc_hs_wq smc_listen_work [smc]
>  RIP: 0010:smc_clc_send_confirm_accept+0x284/0x580 [smc]
>  RSP: 0018:ffffb8294b2d7c78 EFLAGS: 00010a06
>  RAX: ffff8f1873238880 RBX: ffffb8294b2d7dc8 RCX: 0000000000000000
>  RDX: 00000000000000b4 RSI: 0000000000000001 RDI: 0000000000b40c00
>  RBP: ffffb8294b2d7db8 R08: ffff8f1815c5860c R09: 0000000000000000
>  R10: 0000000000000400 R11: 0000000000000000 R12: ffff8f1846f56180
>  R13: ffff8f1815c5860c R14: 0000000000000001 R15: 0000000000000001
>  FS:  0000000000000000(0000) GS:ffff8f1aefd00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000014 CR3: 00000001027a0001 CR4: 00000000003706e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  Call Trace:
>   <TASK>
>   ? mlx5_ib_map_mr_sg+0xa1/0xd0 [mlx5_ib]
>   ? smcr_buf_map_link+0x24b/0x290 [smc]
>   ? __smc_buf_create+0x4ee/0x9b0 [smc]
>   smc_clc_send_accept+0x4c/0xb0 [smc]
>   smc_listen_work+0x346/0x650 [smc]
>   ? __schedule+0x279/0x820
>   process_one_work+0x1e5/0x3f0
>   worker_thread+0x4d/0x2f0
>   ? __pfx_worker_thread+0x10/0x10
>   kthread+0xe5/0x120
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork+0x2c/0x50
>   </TASK>
> 
> [...]

Here is the summary with links:
  - [net] net/smc: Reset connection when trying to use SMCRv2 fails.
    https://git.kernel.org/netdev/net/c/35112271672a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



