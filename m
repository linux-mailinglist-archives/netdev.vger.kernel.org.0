Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299DE48265D
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 03:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiAACuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 21:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiAACuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 21:50:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4886C061574
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 18:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2BDAFCE1DB5
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 02:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CC30C36AED;
        Sat,  1 Jan 2022 02:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641005409;
        bh=BF3w8QrN+yAoALmvvwhI1q///yR1UffKHfdwThlch6E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eWLStHHwP4/bMaHIxZ4E6VDklYzRk/y+sHVMGJ1vERg01TsTOue64mSImwZV2zYQE
         E1Eu6P4cSIv0ALgtQdKwe1vw2ADzVBenM43BISW+D1lZS/8faJvPO7HwS2FpJVp4mZ
         XI/zcmvuVlD3Ep4Mup3+ZHviMIrNBgG3UuqtA2u0f3KdY62eGj8aI9O7Ycbzl8WHwD
         WuQ1Fl3xsxwlQQh1rJGrqMuhNqJim2ivYTZ4MHBS+/3jk/PeCQFrkPEBETp1rdZe9S
         I8N/gdkUdcBbXggNZLDwuKCyQzWkBf97l4KI0cxTk3jdJJuBSaojh6OuPZVW0iVboj
         nuPTvaQQx8oHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39F61C40C57;
        Sat,  1 Jan 2022 02:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net ticp:fix a kernel-infoleak in __tipc_sendmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164100540923.540.12070021072088953465.git-patchwork-notify@kernel.org>
Date:   Sat, 01 Jan 2022 02:50:09 +0000
References: <1640918123-14547-1-git-send-email-tcs.kernel@gmail.com>
In-Reply-To: <1640918123-14547-1-git-send-email-tcs.kernel@gmail.com>
To:     Haimin Zhang <tcs.kernel@gmail.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, tcs_kernel@tencent.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 31 Dec 2021 10:35:23 +0800 you wrote:
> From: Haimin Zhang <tcs_kernel@tencent.com>
> 
> struct tipc_socket_addr.ref has a 4-byte hole,and __tipc_getname() currently
> copying it to user space,causing kernel-infoleak.
> 
> BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline]
> BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline] lib/usercopy.c:33
> BUG: KMSAN: kernel-infoleak in _copy_to_user+0x1c9/0x270 lib/usercopy.c:33 lib/usercopy.c:33
>  instrument_copy_to_user include/linux/instrumented.h:121 [inline]
>  instrument_copy_to_user include/linux/instrumented.h:121 [inline] lib/usercopy.c:33
>  _copy_to_user+0x1c9/0x270 lib/usercopy.c:33 lib/usercopy.c:33
>  copy_to_user include/linux/uaccess.h:209 [inline]
>  copy_to_user include/linux/uaccess.h:209 [inline] net/socket.c:287
>  move_addr_to_user+0x3f6/0x600 net/socket.c:287 net/socket.c:287
>  __sys_getpeername+0x470/0x6b0 net/socket.c:1987 net/socket.c:1987
>  __do_sys_getpeername net/socket.c:1997 [inline]
>  __se_sys_getpeername net/socket.c:1994 [inline]
>  __do_sys_getpeername net/socket.c:1997 [inline] net/socket.c:1994
>  __se_sys_getpeername net/socket.c:1994 [inline] net/socket.c:1994
>  __x64_sys_getpeername+0xda/0x120 net/socket.c:1994 net/socket.c:1994
>  do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>  do_syscall_x64 arch/x86/entry/common.c:51 [inline] arch/x86/entry/common.c:82
>  do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82 arch/x86/entry/common.c:82
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> [...]

Here is the summary with links:
  - [v2] net ticp:fix a kernel-infoleak in __tipc_sendmsg()
    https://git.kernel.org/netdev/net/c/d6d86830705f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


