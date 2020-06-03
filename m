Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414681ED10B
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 15:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgFCNl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 09:41:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34952 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgFCNl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 09:41:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CyFG2ru7bk1mj/fhXW2oMAxCVTuoHvvxgw+JJUxkA58=; b=p0AlNxI8ltu2LoKOPfJIcRx66u
        XgYz2RIKrNkdlAQ63W7em0FJIEhS88woZHuRJhCxfwfoZfE2f0NSs1M5TtcfAoTN+oSTv0UpfdUhz
        QA86WONXgj7Wt5FrBW4CRnXAwvSiX0zdC3pank2nedQ7lWk8qWuUchiUuGjDpF3oYOF8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jgTdx-0043cL-Io; Wed, 03 Jun 2020 15:41:21 +0200
Date:   Wed, 3 Jun 2020 15:41:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: qca8k: Fix "Unexpected gfp" kernel
 exception
Message-ID: <20200603134121.GX869823@lunn.ch>
References: <1591183899-24987-1-git-send-email-michal.vokac@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1591183899-24987-1-git-send-email-michal.vokac@ysoft.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 01:31:39PM +0200, Michal Vokáč wrote:
> Commit 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
> replaced the dsa_switch_alloc helper by devm_kzalloc in all DSA
> drivers. Unfortunately it introduced a typo in qca8k.c driver and
> wrong argument is passed to the devm_kzalloc function.
> 
> This fix mitigates the following kernel exception:
> 
>   Unexpected gfp: 0x6 (__GFP_HIGHMEM|GFP_DMA32). Fixing up to gfp: 0x101 (GFP_DMA|__GFP_ZERO). Fix your code!
>   CPU: 1 PID: 44 Comm: kworker/1:1 Not tainted 5.5.9-yocto-ua #1
>   Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
>   Workqueue: events deferred_probe_work_func
>   [<c0014924>] (unwind_backtrace) from [<c00123bc>] (show_stack+0x10/0x14)
>   [<c00123bc>] (show_stack) from [<c04c8fb4>] (dump_stack+0x90/0xa4)
>   [<c04c8fb4>] (dump_stack) from [<c00e1b10>] (new_slab+0x20c/0x214)
>   [<c00e1b10>] (new_slab) from [<c00e1cd0>] (___slab_alloc.constprop.0+0x1b8/0x540)
>   [<c00e1cd0>] (___slab_alloc.constprop.0) from [<c00e2074>] (__slab_alloc.constprop.0+0x1c/0x24)
>   [<c00e2074>] (__slab_alloc.constprop.0) from [<c00e4538>] (__kmalloc_track_caller+0x1b0/0x298)
>   [<c00e4538>] (__kmalloc_track_caller) from [<c02cccac>] (devm_kmalloc+0x24/0x70)
>   [<c02cccac>] (devm_kmalloc) from [<c030d888>] (qca8k_sw_probe+0x94/0x1ac)
>   [<c030d888>] (qca8k_sw_probe) from [<c0304788>] (mdio_probe+0x30/0x54)
>   [<c0304788>] (mdio_probe) from [<c02c93bc>] (really_probe+0x1e0/0x348)
>   [<c02c93bc>] (really_probe) from [<c02c9884>] (driver_probe_device+0x60/0x16c)
>   [<c02c9884>] (driver_probe_device) from [<c02c7fb0>] (bus_for_each_drv+0x70/0x94)
>   [<c02c7fb0>] (bus_for_each_drv) from [<c02c9708>] (__device_attach+0xb4/0x11c)
>   [<c02c9708>] (__device_attach) from [<c02c8148>] (bus_probe_device+0x84/0x8c)
>   [<c02c8148>] (bus_probe_device) from [<c02c8cec>] (deferred_probe_work_func+0x64/0x90)
>   [<c02c8cec>] (deferred_probe_work_func) from [<c0033c14>] (process_one_work+0x1d4/0x41c)
>   [<c0033c14>] (process_one_work) from [<c00340a4>] (worker_thread+0x248/0x528)
>   [<c00340a4>] (worker_thread) from [<c0039148>] (kthread+0x124/0x150)
>   [<c0039148>] (kthread) from [<c00090d8>] (ret_from_fork+0x14/0x3c)
>   Exception stack(0xee1b5fb0 to 0xee1b5ff8)
>   5fa0:                                     00000000 00000000 00000000 00000000
>   5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>   5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
>   qca8k 2188000.ethernet-1:0a: Using legacy PHYLIB callbacks. Please migrate to PHYLINK!
>   qca8k 2188000.ethernet-1:0a eth2 (uninitialized): PHY [2188000.ethernet-1:01] driver [Generic PHY]
>   qca8k 2188000.ethernet-1:0a eth1 (uninitialized): PHY [2188000.ethernet-1:02] driver [Generic PHY]
> 
> Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>

Signed-off-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
