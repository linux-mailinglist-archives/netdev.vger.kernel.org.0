Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479601DFBDD
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 01:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388167AbgEWXa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 19:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388010AbgEWXa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 19:30:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634F1C061A0E;
        Sat, 23 May 2020 16:30:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85ADC1286DBCB;
        Sat, 23 May 2020 16:30:56 -0700 (PDT)
Date:   Sat, 23 May 2020 16:30:55 -0700 (PDT)
Message-Id: <20200523.163055.1502317714947171444.davem@davemloft.net>
To:     leoyu@nvidia.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: don't attach interface until resume
 finishes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590161383-8141-1-git-send-email-leoyu@nvidia.com>
References: <1590161383-8141-1-git-send-email-leoyu@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 16:30:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Yu <leoyu@nvidia.com>
Date: Fri, 22 May 2020 23:29:43 +0800

> Commit 14b41a2959fb ("net: stmmac: Delete txtimer in suspend") was the
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

Applied, thank you.
