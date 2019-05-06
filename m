Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397A61506C
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfEFPjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 11:39:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55879 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbfEFPjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 11:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dID/slTm4G917Opxr/7Uw9arkAgfTKoUQuLjenV3v7c=; b=YrtgJk+9VGWmn0lSuHTbAPlzko
        voo3IWHNOhSs48I+Fl+d9yii3O82txrynTZQy9glK71ToXcYT0pjxI597TUBEc9KOblPReZPXlpIR
        C2S3klfBuNtIZCgInAGnJMRknHlKmlBGHH/BFG1d8cGdnI3i72o2B5hoNHvPTtRzDEXo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hNfhv-0006Jo-U4; Mon, 06 May 2019 17:39:11 +0200
Date:   Mon, 6 May 2019 17:39:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: Fix error cleanup path in dsa_init_module
Message-ID: <20190506153911.GD9768@lunn.ch>
References: <20190506152529.6292-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506152529.6292-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On Mon, May 06, 2019 at 11:25:29PM +0800, YueHaibing wrote:
> BUG: unable to handle kernel paging request at ffffffffa01c5430
> PGD 3270067 P4D 3270067 PUD 3271063 PMD 230bc5067 PTE 0
> Oops: 0000 [#1
> CPU: 0 PID: 6159 Comm: modprobe Not tainted 5.1.0+ #33
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
> RIP: 0010:raw_notifier_chain_register+0x16/0x40
> Code: 63 f8 66 90 e9 5d ff ff ff 90 90 90 90 90 90 90 90 90 90 90 55 48 8b 07 48 89 e5 48 85 c0 74 1c 8b 56 10 3b 50 10 7e 07 eb 12 <39> 50 10 7c 0d 48 8d 78 08 48 8b 40 08 48 85 c0 75 ee 48 89 46 08
> RSP: 0018:ffffc90001c33c08 EFLAGS: 00010282
> RAX: ffffffffa01c5420 RBX: ffffffffa01db420 RCX: 4fcef45928070a8b
> RDX: 0000000000000000 RSI: ffffffffa01db420 RDI: ffffffffa01b0068
> RBP: ffffc90001c33c08 R08: 000000003e0a33d0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000094443661 R12: ffff88822c320700
> R13: ffff88823109be80 R14: 0000000000000000 R15: ffffc90001c33e78
> FS:  00007fab8bd08540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffa01c5430 CR3: 00000002297ea000 CR4: 00000000000006f0
> Call Trace:
>  register_netdevice_notifier+0x43/0x250
>  ? 0xffffffffa01e0000
>  dsa_slave_register_notifier+0x13/0x70 [dsa_core
>  ? 0xffffffffa01e0000
>  dsa_init_module+0x2e/0x1000 [dsa_core
>  do_one_initcall+0x6c/0x3cc
>  ? do_init_module+0x22/0x1f1
>  ? rcu_read_lock_sched_held+0x97/0xb0
>  ? kmem_cache_alloc_trace+0x325/0x3b0
>  do_init_module+0x5b/0x1f1
>  load_module+0x1db1/0x2690
>  ? m_show+0x1d0/0x1d0
>  __do_sys_finit_module+0xc5/0xd0
>  __x64_sys_finit_module+0x15/0x20
>  do_syscall_64+0x6b/0x1d0
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Cleanup allocated resourses if there are errors,
> otherwise it will trgger memleak.
> 
> Fixes: c9eb3e0f8701 ("net: dsa: Add support for learning FDB through notification")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Hi Yue

Please make it clear which tree this is against. Make the subject line
[PATCH net] so it is clear this is for the net branch.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
