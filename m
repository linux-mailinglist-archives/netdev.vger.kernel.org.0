Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF5B32F66E
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 00:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhCEXKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 18:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230122AbhCEXKL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 18:10:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 240A3650A6;
        Fri,  5 Mar 2021 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614985811;
        bh=0+laHNr2nbB0iqCi/qD2IFteGxqMNkypx4ESZUG8dlA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a26deF7SQp5m6Xoa2/t98aIfRt5XjCHSyflKK3F5+Vhltc2UycXpD0rZALllkRhmi
         T1yNPrrPYizgUGT5Ig4BIjkEdO6pi94isNlB/uISoNS2vu1K1q+ooI3PhxENbP/X6T
         RxUhk004chKc8QL+HL/vVoAYtCMfrhSrvGX12A+JKArvfltGFq7RcRhTLWlLXfrjBC
         6U00sWIFOR8F2p7OrSmVMKoYBfb1rjVmtLqtYaS8vHlsJXeZOqCMN40QZ2Z4NVlg/g
         3Yyfb5mXTcDXu0YsHcVw+O5JQXQpZxRdfoqamwjUomslL8Vn2s7eUZc6RLKZgP5AFP
         MYm9wbSDIfPlw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 197FF60A22;
        Fri,  5 Mar 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethernet: alx: fix order of calls on resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161498581110.14945.17599653986246768706.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 23:10:11 +0000
References: <20210305221729.206096-1-kuba@kernel.org>
In-Reply-To: <20210305221729.206096-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        zbynek.michl@gmail.com, chris.snook@gmail.com,
        bruceshenzk@gmail.com, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  5 Mar 2021 14:17:29 -0800 you wrote:
> netif_device_attach() will unpause the queues so we can't call
> it before __alx_open(). This went undetected until
> commit b0999223f224 ("alx: add ability to allocate and free
> alx_napi structures") but now if stack tries to xmit immediately
> on resume before __alx_open() we'll crash on the NAPI being null:
> 
>  BUG: kernel NULL pointer dereference, address: 0000000000000198
>  CPU: 0 PID: 12 Comm: ksoftirqd/0 Tainted: G           OE 5.10.0-3-amd64 #1 Debian 5.10.13-1
>  Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./H77-D3H, BIOS F15 11/14/2013
>  RIP: 0010:alx_start_xmit+0x34/0x650 [alx]
>  Code: 41 56 41 55 41 54 55 53 48 83 ec 20 0f b7 57 7c 8b 8e b0
> 0b 00 00 39 ca 72 06 89 d0 31 d2 f7 f1 89 d2 48 8b 84 df
>  RSP: 0018:ffffb09240083d28 EFLAGS: 00010297
>  RAX: 0000000000000000 RBX: ffffa04d80ae7800 RCX: 0000000000000004
>  RDX: 0000000000000000 RSI: ffffa04d80afa000 RDI: ffffa04e92e92a00
>  RBP: 0000000000000042 R08: 0000000000000100 R09: ffffa04ea3146700
>  R10: 0000000000000014 R11: 0000000000000000 R12: ffffa04e92e92100
>  R13: 0000000000000001 R14: ffffa04e92e92a00 R15: ffffa04e92e92a00
>  FS:  0000000000000000(0000) GS:ffffa0508f600000(0000) knlGS:0000000000000000
>  i915 0000:00:02.0: vblank wait timed out on crtc 0
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000198 CR3: 000000004460a001 CR4: 00000000001706f0
>  Call Trace:
>   dev_hard_start_xmit+0xc7/0x1e0
>   sch_direct_xmit+0x10f/0x310
> 
> [...]

Here is the summary with links:
  - [net] ethernet: alx: fix order of calls on resume
    https://git.kernel.org/netdev/net/c/a4dcfbc4ee22

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


