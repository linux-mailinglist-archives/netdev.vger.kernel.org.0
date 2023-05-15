Return-Path: <netdev+bounces-2537-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3AD702667
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55FC728113C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE8FA8479;
	Mon, 15 May 2023 07:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A36847C
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3357C4339E;
	Mon, 15 May 2023 07:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684137020;
	bh=5nFP/gRI7MYFr5AgB0izOMI4wzaxd2IcfY3U4gMQWQk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=k6xkuqbKim0VKeTGhcSNDCnFDy/iShcB5W43qTwdKfHl+ppnSxF3QsLGEJSNOBzbz
	 2WubyCgO+wA9cQoLv+NkmLqEPUwzhOaCOQzZj8GJvEB4yONudogKVheIY7rJ8Tumpa
	 mEGY0eQWM2Iefs6SlEZcD3Jmex5IsgELbs/E8Jmu8oVLR69cdtewlWB/VirtTBBaI5
	 3YC6XOOG7jDMF16p+ljjTEk+sQ31vkNGoLUm0iKtFL2A6WgknabXEExFJRaboZo/oN
	 E7iwP0Kx2TQp+GG/b87xcboTYsbZjqZg8Twqso7K0lenJzwDdiqWfcv2I+8+gWR6z3
	 oxyGCrJ+k/vGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9B10E49FAB;
	Mon, 15 May 2023 07:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net,
 v4] net: nsh: Use correct mac_offset to unwind gso skb in nsh_gso_segment()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168413701982.26935.1923610991191473208.git-patchwork-notify@kernel.org>
Date: Mon, 15 May 2023 07:50:19 +0000
References: <20230511125440.1177848-1-dongchenchen2@huawei.com>
In-Reply-To: <20230511125440.1177848-1-dongchenchen2@huawei.com>
To: Dong Chenchen <dongchenchen2@huawei.com>
Cc: edumazet@google.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, simon.horman@corigine.com, jbenc@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, yuehaibing@huawei.com,
 weiyongjun1@huawei.com, syzbot+632b5d9964208bfef8c0@syzkaller.appspotmail.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 20:54:40 +0800 you wrote:
> As the call trace shows, skb_panic was caused by wrong skb->mac_header
> in nsh_gso_segment():
> 
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
> CPU: 3 PID: 2737 Comm: syz Not tainted 6.3.0-next-20230505 #1
> RIP: 0010:skb_panic+0xda/0xe0
> call Trace:
>  skb_push+0x91/0xa0
>  nsh_gso_segment+0x4f3/0x570
>  skb_mac_gso_segment+0x19e/0x270
>  __skb_gso_segment+0x1e8/0x3c0
>  validate_xmit_skb+0x452/0x890
>  validate_xmit_skb_list+0x99/0xd0
>  sch_direct_xmit+0x294/0x7c0
>  __dev_queue_xmit+0x16f0/0x1d70
>  packet_xmit+0x185/0x210
>  packet_snd+0xc15/0x1170
>  packet_sendmsg+0x7b/0xa0
>  sock_sendmsg+0x14f/0x160
> 
> [...]

Here is the summary with links:
  - [net,v4] net: nsh: Use correct mac_offset to unwind gso skb in nsh_gso_segment()
    https://git.kernel.org/netdev/net/c/c83b49383b59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



