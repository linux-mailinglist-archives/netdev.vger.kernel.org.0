Return-Path: <netdev+bounces-1315-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F124F6FD448
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 05:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 009D92812E6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 03:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AD7663E;
	Wed, 10 May 2023 03:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4324F63C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E530FC433D2;
	Wed, 10 May 2023 03:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683689422;
	bh=tbiIuyZVLvKrbtjltTZWP7LIBTq/eQE5bTjhZuivMcs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=P09Y8EIRu+hl20oXPJiiRctNfvpBWlescw+2lAfHidhGhRLtmkUSqBXzqN0xNt6fo
	 2ANAycA7JtBJkVO5I5M0U7gLmgczD25F6fw3uZXmMOhgC6byoPNUzrCIUUGRRrTmAW
	 TYGnUonkUYheHkAFfhOD7BX5jgks0aL9OCYryBhNnekeEiaFWst44r4Yp5Yn70sG1e
	 xGXNCZolFL22W349zCYTArsZJ8lAGz+twRSlBEftnEl8xVCD7zmcKYOatHC4IiZUIK
	 aV1iy/PJHLTS0YsjRbv9x8/KfNxcrkvFL/fy+5CarOt2TH8Co7vt1g78d0YlN3A7BG
	 O9U78DhDCeDXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BFD7AE26D23;
	Wed, 10 May 2023 03:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] net: Fix load-tearing on sk->sk_stamp in
 sock_recv_cmsgs().
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168368942178.11333.808708812633442353.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 03:30:21 +0000
References: <20230508175543.55756-1-kuniyu@amazon.com>
In-Reply-To: <20230508175543.55756-1-kuniyu@amazon.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org,
 syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 8 May 2023 10:55:43 -0700 you wrote:
> KCSAN found a data race in sock_recv_cmsgs() where the read access
> to sk->sk_stamp needs READ_ONCE().
> 
> BUG: KCSAN: data-race in packet_recvmsg / packet_recvmsg
> 
> write (marked) to 0xffff88803c81f258 of 8 bytes by task 19171 on cpu 0:
>  sock_write_timestamp include/net/sock.h:2670 [inline]
>  sock_recv_cmsgs include/net/sock.h:2722 [inline]
>  packet_recvmsg+0xb97/0xd00 net/packet/af_packet.c:3489
>  sock_recvmsg_nosec net/socket.c:1019 [inline]
>  sock_recvmsg+0x11a/0x130 net/socket.c:1040
>  sock_read_iter+0x176/0x220 net/socket.c:1118
>  call_read_iter include/linux/fs.h:1845 [inline]
>  new_sync_read fs/read_write.c:389 [inline]
>  vfs_read+0x5e0/0x630 fs/read_write.c:470
>  ksys_read+0x163/0x1a0 fs/read_write.c:613
>  __do_sys_read fs/read_write.c:623 [inline]
>  __se_sys_read fs/read_write.c:621 [inline]
>  __x64_sys_read+0x41/0x50 fs/read_write.c:621
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> 
> [...]

Here is the summary with links:
  - [v3,net] net: Fix load-tearing on sk->sk_stamp in sock_recv_cmsgs().
    https://git.kernel.org/netdev/net/c/dfd9248c071a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



