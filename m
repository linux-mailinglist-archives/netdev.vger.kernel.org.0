Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C243D32D99C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 19:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbhCDSrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 13:47:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234959AbhCDSrg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 13:47:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D06A064EF8;
        Thu,  4 Mar 2021 18:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614883615;
        bh=t6312J1wqnq4282JmZLbBzkRGcNnKpCKJ/cG06cmVho=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ScxKKneDI0nDT2tqFtWEvznQoEaS9Y8XhzTAtOKbXKTXPb82FgnmveMY8c3dBU0FH
         kk7tNy0SVB0Ai8p1JP7fe6hfDi7yIBB2n9ISN7j3t1D26XrkCh0/0Yrg7SrPsA401f
         0pzJRcHoGiRUYVsBtGko7THK7o+RyHIXmSoav1OtPD/fwrtXMSCjBRMyZl22VOeov/
         9PIkGPOTNDDmIBjngQOywJ8b/Fry8aG/WDzyTAQwxz925U2blOrwxW0ecV3uI8tDEo
         J71aNf6SG3j4WaUBpWRKVR1tOvzQZbZIwuJI1fP2wVX1+V+LUsEidgUxkB2piaz3ow
         obkeqxs106MSw==
Date:   Thu, 4 Mar 2021 10:46:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <eric.dumazet@gmail.com>, <andrew@lunn.ch>, <mkubecek@suse.cz>,
        <f.fainelli@gmail.com>, <acardace@redhat.com>,
        <irusskikh@marvell.com>, <gustavo@embeddedor.com>,
        <magnus.karlsson@intel.com>, <ecree@solarflare.com>,
        <idosch@nvidia.com>, <jiri@nvidia.com>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net] ethtool: Add indicator field for link_mode validity
 to link_ksettings
Message-ID: <20210304104653.65d7af1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210304090933.3538255-1-danieller@nvidia.com>
References: <20210304090933.3538255-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Mar 2021 11:09:33 +0200 Danielle Ratson wrote:
> Some drivers clear the 'ethtool_link_ksettings' struct in their
> get_link_ksettings() callback, before populating it with actual values.
> Such drivers will set the new 'link_mode' field to zero, resulting in
> user space receiving wrong link mode information given that zero is a
> valid value for the field.
> 
> Fix this by introducing a new boolean field ('link_mode_valid'), which
> indicates whether the 'link_mode' field is valid or not. Set it in mlxsw
> which is currently the only driver supporting the new API.
> 
> Another problem is that some drivers (notably tun) can report random
> values in the 'link_mode' field. This can result in a general protection
> fault when the field is used as an index to the 'link_mode_params' array
> [1].
> 
> This happens because such drivers implement their set_link_ksettings()
> callback by simply overwriting their private copy of
> 'ethtool_link_ksettings' struct with the one they get from the stack,
> which is not always properly initialized.
> 
> Fix this by making sure that the new 'link_mode_valid' field is always
> initialized to 'false' before invoking the set_link_ksettings()
> callback.
> 
> [1]
> general protection fault, probably for non-canonical address 0xdffffc00f14cc32c: 0000 [#1] PREEMPT SMP KASAN
> KASAN: probably user-memory-access in range [0x000000078a661960-0x000000078a661967]
> CPU: 0 PID: 8452 Comm: syz-executor360 Not tainted 5.11.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__ethtool_get_link_ksettings+0x1a3/0x3a0 net/ethtool/ioctl.c:446
> Code: b7 3e fa 83 fd ff 0f 84 30 01 00 00 e8 16 b0 3e fa 48 8d 3c ed 60 d5 69 8a 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03
> +38 d0 7c 08 84 d2 0f 85 b9
> RSP: 0018:ffffc900019df7a0 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: ffff888026136008 RCX: 0000000000000000
> RDX: 00000000f14cc32c RSI: ffffffff873439ca RDI: 000000078a661960
> RBP: 00000000ffff8880 R08: 00000000ffffffff R09: ffff88802613606f
> R10: ffffffff873439bc R11: 0000000000000000 R12: 0000000000000000
> R13: ffff88802613606c R14: ffff888011d0c210 R15: ffff888011d0c210
> FS:  0000000000749300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004b60f0 CR3: 00000000185c2000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  linkinfo_prepare_data+0xfd/0x280 net/ethtool/linkinfo.c:37
>  ethnl_default_notify+0x1dc/0x630 net/ethtool/netlink.c:586
>  ethtool_notify+0xbd/0x1f0 net/ethtool/netlink.c:656
>  ethtool_set_link_ksettings+0x277/0x330 net/ethtool/ioctl.c:620
>  dev_ethtool+0x2b35/0x45d0 net/ethtool/ioctl.c:2842
>  dev_ioctl+0x463/0xb70 net/core/dev_ioctl.c:440
>  sock_do_ioctl+0x148/0x2d0 net/socket.c:1060
>  sock_ioctl+0x477/0x6a0 net/socket.c:1177
>  vfs_ioctl fs/ioctl.c:48 [inline]
>  __do_sys_ioctl fs/ioctl.c:753 [inline]
>  __se_sys_ioctl fs/ioctl.c:739 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fixes: c8907043c6ac9 ("ethtool: Get link mode in use instead of speed and duplex parameters")
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

BTW shouldn't __ethtool_get_link_ksettings() be moved to common.c?
