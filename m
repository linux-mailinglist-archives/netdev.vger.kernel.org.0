Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C648A42091B
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 12:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhJDKNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 06:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhJDKNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 06:13:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 181846128A;
        Mon,  4 Oct 2021 10:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633342288;
        bh=1FSxfpr/+AzmR56G+WHMLcUMmcad+HJ+4J+awlrJc74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y59mMT+RPi9DqLc0Wka7wXw2M2M21GlY/CeMGz8rg8M9pqDaIDFlGZ91Xpd3GgLuI
         syQGEASbts46K9fNVmHs/WuNNQ98A+RVkYfl6mUYBWleNkBj+BV4TTMFvbwDIHp8Zf
         GwI0cVaQ2qM+akXGUBRqlbW+Qs/Bd1TrpFfv7fd8=
Date:   Mon, 4 Oct 2021 12:11:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Leon Yu <leoyu@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Fabien Parent <fparent@baylibre.com>,
        Macpaul Lin <macpaul@gmail.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: don't attach interface until resume finishes
Message-ID: <YVrTSLuCJaqKqmb0@kroah.com>
References: <YVLJGT7JAVc7rnBx@kroah.com>
 <20210928083620.29090-1-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928083620.29090-1-macpaul.lin@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 04:36:20PM +0800, Macpaul Lin wrote:
> From: Leon Yu <leoyu@nvidia.com>
> 
> commit 31096c3e8b1163c6e966bf4d1f36d8b699008f84 upstream.
> 
> Commit 14b41a2959fb ("net: stmmac: Delete txtimer in suspend()") was the
> first attempt to fix a race between mod_timer() and setup_timer()
> during stmmac_resume(). However the issue still exists as the commit
> only addressed half of the issue.
> 
> Same race can still happen as stmmac_resume() re-attaches interface
> way too early - even before hardware is fully initialized.  Worse,
> doing so allows network traffic to restart and stmmac_tx_timer_arm()
> being called in the middle of stmmac_resume(), which re-init tx timers
> in stmmac_init_coalesce().  timer_list will be corrupted and system
> crashes as a result of race between mod_timer() and setup_timer().
> 
>   systemd--1995    2.... 552950018us : stmmac_suspend: 4994
>   ksoftirq-9       0..s2 553123133us : stmmac_tx_timer_arm: 2276
>   systemd--1995    0.... 553127896us : stmmac_resume: 5101
>   systemd--320     7...2 553132752us : stmmac_tx_timer_arm: 2276
>   (sd-exec-1999    5...2 553135204us : stmmac_tx_timer_arm: 2276
>   ---------------------------------
>   pc : run_timer_softirq+0x468/0x5e0
>   lr : run_timer_softirq+0x570/0x5e0
>   Call trace:
>    run_timer_softirq+0x468/0x5e0
>    __do_softirq+0x124/0x398
>    irq_exit+0xd8/0xe0
>    __handle_domain_irq+0x6c/0xc0
>    gic_handle_irq+0x60/0xb0
>    el1_irq+0xb8/0x180
>    arch_cpu_idle+0x38/0x230
>    default_idle_call+0x24/0x3c
>    do_idle+0x1e0/0x2b8
>    cpu_startup_entry+0x28/0x48
>    secondary_start_kernel+0x1b4/0x208
> 
> Fix this by deferring netif_device_attach() to the end of
> stmmac_resume().
> 
> Signed-off-by: Leon Yu <leoyu@nvidia.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Whenever you forward on a patch, you should add yourself to the
signed-off-by chain.

I'll just add you to the cc: to let us know who asked for this patch.

thanks,

greg k-h
