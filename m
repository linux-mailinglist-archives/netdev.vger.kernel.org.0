Return-Path: <netdev+bounces-10985-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA70730ECE
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC45C1C20E30
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 05:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E90814;
	Thu, 15 Jun 2023 05:50:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3F780E
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8350C433C9;
	Thu, 15 Jun 2023 05:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686808219;
	bh=SedMeHwmLBxn/cujm0GopUWPCqwoBUUROOmiaRnfzo8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hrSVLMQ2i4k1KAYrNtLklibzNj6hQ9zmt5+sPlD2+35pF41AO3WIFezpqfPOR0VY6
	 5x+hB1QiE5vBc1+3vXysfUUjd/MfTEMTbASBbIzwXRkonAHBtCcPSA8WA+buy//QQA
	 4FoJSldet6Cgq/k0SC8kZOeAC+VTdNG+eegN0Kn3RAv1Sbwes/UCTU6jWtAGXWnpQ4
	 t71C3YF+oj2nWKPgv0zanKcJjhbJSQGWtX3wYv15SXY+z9V3H2gfElJk3CPFSJJL61
	 Jl6zmNzymg4ASJ0AliGIbWVHtCUVzr3vImuCzvO6Z6MP/ObgxCVZ39ebBhPsuJsxzK
	 Scaq6P65kCr4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C422BE21EEA;
	Thu, 15 Jun 2023 05:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] net/handshake: remove fput() that causes use-after-free
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168680821979.19671.5148979786262319669.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 05:50:19 +0000
References: <20230614015249.987448-1-linma@zju.edu.cn>
In-Reply-To: <20230614015249.987448-1-linma@zju.edu.cn>
To: Lin Ma <linma@zju.edu.cn>
Cc: kuba@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Jun 2023 09:52:49 +0800 you wrote:
> A reference underflow is found in TLS handshake subsystem that causes a
> direct use-after-free. Part of the crash log is like below:
> 
> [    2.022114] ------------[ cut here ]------------
> [    2.022193] refcount_t: underflow; use-after-free.
> [    2.022288] WARNING: CPU: 0 PID: 60 at lib/refcount.c:28 refcount_warn_saturate+0xbe/0x110
> [    2.022432] Modules linked in:
> [    2.022848] RIP: 0010:refcount_warn_saturate+0xbe/0x110
> [    2.023231] RSP: 0018:ffffc900001bfe18 EFLAGS: 00000286
> [    2.023325] RAX: 0000000000000000 RBX: 0000000000000007 RCX: 00000000ffffdfff
> [    2.023438] RDX: 0000000000000000 RSI: 00000000ffffffea RDI: 0000000000000001
> [    2.023555] RBP: ffff888004c20098 R08: ffffffff82b392c8 R09: 00000000ffffdfff
> [    2.023693] R10: ffffffff82a592e0 R11: ffffffff82b092e0 R12: ffff888004c200d8
> [    2.023813] R13: 0000000000000000 R14: ffff888004c20000 R15: ffffc90000013ca8
> [    2.023930] FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> [    2.024062] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.024161] CR2: ffff888003601000 CR3: 0000000002a2e000 CR4: 00000000000006f0
> [    2.024275] Call Trace:
> [    2.024322]  <TASK>
> [    2.024367]  ? __warn+0x7f/0x130
> [    2.024430]  ? refcount_warn_saturate+0xbe/0x110
> [    2.024513]  ? report_bug+0x199/0x1b0
> [    2.024585]  ? handle_bug+0x3c/0x70
> [    2.024676]  ? exc_invalid_op+0x18/0x70
> [    2.024750]  ? asm_exc_invalid_op+0x1a/0x20
> [    2.024830]  ? refcount_warn_saturate+0xbe/0x110
> [    2.024916]  ? refcount_warn_saturate+0xbe/0x110
> [    2.024998]  __tcp_close+0x2f4/0x3d0
> [    2.025065]  ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
> [    2.025168]  tcp_close+0x1f/0x70
> [    2.025231]  inet_release+0x33/0x60
> [    2.025297]  sock_release+0x1f/0x80
> [    2.025361]  handshake_req_cancel_test2+0x100/0x2d0
> [    2.025457]  kunit_try_run_case+0x4c/0xa0
> [    2.025532]  kunit_generic_run_threadfn_adapter+0x15/0x20
> [    2.025644]  kthread+0xe1/0x110
> [    2.025708]  ? __pfx_kthread+0x10/0x10
> [    2.025780]  ret_from_fork+0x2c/0x50
> 
> [...]

Here is the summary with links:
  - [v1] net/handshake: remove fput() that causes use-after-free
    https://git.kernel.org/netdev/net/c/361b6889ae63

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



