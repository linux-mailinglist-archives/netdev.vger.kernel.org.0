Return-Path: <netdev+bounces-8491-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 323E57244AB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81A6B1C20E29
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551AA2A9DB;
	Tue,  6 Jun 2023 13:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4086637B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B08B7C4339E;
	Tue,  6 Jun 2023 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686058820;
	bh=wnnA1QHWvwAupiFi9VKUAs/CynLtbpi6eWCqWxTo0KE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=aGf9Sq1ZS5SXYEUPEU6mmt8XOVXODXVSvGbgd3yvx5u8OfCbrwVUuY9XjwsONiceD
	 T4wzFcpXIDkFang4+c+2Yqm5FRjo4XB3ttie0tOtgHtyIn5i19d4hUrrwsoUjFgpVj
	 WeLQPcaOvDid8BGrtb5NAggbRJ2HjPadN1TgtsG6vm2fEQpcpU+yPReQQ8BpOL2AKl
	 s736TVKCtR6FgoSaSac0DPLKl6jk2FzVpCRGSaV5ItqM69BgMZg5OsEUs6eZn6GrDp
	 SlqPHwWjoWmugwlxqxhy2RB+QRtWtSmju6N7g9txEcIt625qtutF+5NdqcgFzs/ZpK
	 /1dHsQvvdYEaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97079E29F3A;
	Tue,  6 Jun 2023 13:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 net] qed/qede: Fix scheduling while atomic
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168605882061.23540.16614616728230510394.git-patchwork-notify@kernel.org>
Date: Tue, 06 Jun 2023 13:40:20 +0000
References: <20230605112600.48238-1-manishc@marvell.com>
In-Reply-To: <20230605112600.48238-1-manishc@marvell.com>
To: Manish Chopra <manishc@marvell.com>
Cc: kuba@kernel.org, netdev@vger.kernel.org, aelior@marvell.com,
 palok@marvell.com, jiri@resnulli.us, skalluru@marvell.com,
 davem@davemloft.net

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 5 Jun 2023 16:56:00 +0530 you wrote:
> Statistics read through bond interface via sysfs causes
> below bug and traces as it triggers the bonding module to
> collect the slave device statistics while holding the spinlock,
> beneath that qede->qed driver statistics flow gets scheduled out
> due to usleep_range() used in PTT acquire logic
> 
> [ 3673.988874] Hardware name: HPE ProLiant DL365 Gen10 Plus/ProLiant DL365 Gen10 Plus, BIOS A42 10/29/2021
> [ 3673.988878] Call Trace:
> [ 3673.988891]  dump_stack_lvl+0x34/0x44
> [ 3673.988908]  __schedule_bug.cold+0x47/0x53
> [ 3673.988918]  __schedule+0x3fb/0x560
> [ 3673.988929]  schedule+0x43/0xb0
> [ 3673.988932]  schedule_hrtimeout_range_clock+0xbf/0x1b0
> [ 3673.988937]  ? __hrtimer_init+0xc0/0xc0
> [ 3673.988950]  usleep_range+0x5e/0x80
> [ 3673.988955]  qed_ptt_acquire+0x2b/0xd0 [qed]
> [ 3673.988981]  _qed_get_vport_stats+0x141/0x240 [qed]
> [ 3673.989001]  qed_get_vport_stats+0x18/0x80 [qed]
> [ 3673.989016]  qede_fill_by_demand_stats+0x37/0x400 [qede]
> [ 3673.989028]  qede_get_stats64+0x19/0xe0 [qede]
> [ 3673.989034]  dev_get_stats+0x5c/0xc0
> [ 3673.989045]  netstat_show.constprop.0+0x52/0xb0
> [ 3673.989055]  dev_attr_show+0x19/0x40
> [ 3673.989065]  sysfs_kf_seq_show+0x9b/0xf0
> [ 3673.989076]  seq_read_iter+0x120/0x4b0
> [ 3673.989087]  new_sync_read+0x118/0x1a0
> [ 3673.989095]  vfs_read+0xf3/0x180
> [ 3673.989099]  ksys_read+0x5f/0xe0
> [ 3673.989102]  do_syscall_64+0x3b/0x90
> [ 3673.989109]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 3673.989115] RIP: 0033:0x7f8467d0b082
> [ 3673.989119] Code: c0 e9 b2 fe ff ff 50 48 8d 3d ca 05 08 00 e8 35 e7 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
> [ 3673.989121] RSP: 002b:00007ffffb21fd08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [ 3673.989127] RAX: ffffffffffffffda RBX: 000000000100eca0 RCX: 00007f8467d0b082
> [ 3673.989128] RDX: 00000000000003ff RSI: 00007ffffb21fdc0 RDI: 0000000000000003
> [ 3673.989130] RBP: 00007f8467b96028 R08: 0000000000000010 R09: 00007ffffb21ec00
> [ 3673.989132] R10: 00007ffffb27b170 R11: 0000000000000246 R12: 00000000000000f0
> [ 3673.989134] R13: 0000000000000003 R14: 00007f8467b92000 R15: 0000000000045a05
> [ 3673.989139] CPU: 30 PID: 285188 Comm: read_all Kdump: loaded Tainted: G        W  OE
> 
> [...]

Here is the summary with links:
  - [v6,net] qed/qede: Fix scheduling while atomic
    https://git.kernel.org/netdev/net/c/42510dffd0e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



