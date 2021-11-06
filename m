Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FD4446DBB
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 12:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbhKFL4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 07:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhKFL4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Nov 2021 07:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C9186120A;
        Sat,  6 Nov 2021 11:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636199599;
        bh=oOqfUkN+V01wkWHLOAfGGPh0bwOJZPTt6wQPkt/W0qQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fRWXE3CU7LRnQ7iMonBxh4PiDxUBRDWn/t9e3fNXbV1LN194uMsDAtS1f0k9uDJGE
         if6c/4wy0PALr3mX5tgd/JHMSdLrjM5rt+dY7kJtuAEIbzJ2KwOyYZVfS/6ILa0Jms
         gTmBjCpQAcimqZSwpxnkWCfQWjy4uqo/njm4PkYE=
Date:   Sat, 6 Nov 2021 12:53:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meng Li <Meng.Li@windriver.com>
Cc:     stable@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] driver: ethernet: stmmac: remove the redundant clock
 disable action
Message-ID: <YYZsprWP3vO9dtZy@kroah.com>
References: <20211106104401.10846-1-Meng.Li@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106104401.10846-1-Meng.Li@windriver.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 06, 2021 at 06:44:01PM +0800, Meng Li wrote:
> When run below command to remove ethernet driver on
> stratix10 platform, there will be warning trace as below:
> 
> $ cd /sys/class/net/etha01/device/driver
> $ echo ff800000.ethernet > unbind
> 
> WARNING: CPU: 3 PID: 386 at drivers/clk/clk.c:810 clk_core_unprepare+0x114/0x274
> Modules linked in: sch_fq_codel
> CPU: 3 PID: 386 Comm: sh Tainted: G        W         5.10.74-yocto-standard #1
> Hardware name: SoCFPGA Stratix 10 SoCDK (DT)
> pstate: 00000005 (nzcv daif -PAN -UAO -TCO BTYPE=--)
> pc : clk_core_unprepare+0x114/0x274
> lr : clk_core_unprepare+0x114/0x274
> sp : ffff800011bdbb10
> clk_core_unprepare+0x114/0x274
>  clk_unprepare+0x38/0x50
>  stmmac_remove_config_dt+0x40/0x80
>  stmmac_pltfr_remove+0x64/0x80
>  platform_drv_remove+0x38/0x60
>  ... ..
>  el0_sync_handler+0x1a4/0x1b0
>  el0_sync+0x180/0x1c0
> This issue is introduced by introducing upstream commit 8f269102baf7
> ("net: stmmac: disable clocks in stmmac_remove_config_dt()")
> Because clock has been disabled in function stmmac_dvr_remove()
> It not reasonable the remove clock disable action from function
> stmmac_remove_config_dt(), because it is mainly used in probe failed,
> and other platform drivers also use this common function. So, remove
> stmmac_remove_config_dt() from stmmac_pltfr_remove(), only other
> necessary code.
> 
> Fixes: 1af3a8e91f1a ("net: stmmac: disable clocks in stmmac_remove_config_dt()")
> Signed-off-by: Meng Li <Meng.Li@windriver.com>
> 
> ---
> 
> Some extra comments as below:
> 
> 1. This patch is only for linux-stable kernel v5.10, so the fixed commit ID is the one
>    in linux-stable kernel, not the one in mainline upsteam kernel.

Ick, why?

> 2. I created a patch only to fix the linux-stable kernel v5.10, not submit it to upstream kernel.
>    The reason as below:
>    In fact, upstream kernel doesn't have this issue any more. Because it has a patch to improve
>    the clock management and other 4 patches to fix the 1st patch. Detial patches as below:
>    5ec55823438e("net: stmmac: add clocks management for gmac driver")
>    30f347ae7cc1("net: stmmac: fix missing unlock on error in stmmac_suspend()")
>    b3dcb3127786("net: stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()")
>    4691ffb18ac9("net: stmmac: fix system hang if change mac address after interface ifdown")
>    ab00f3e051e8("net: stmmac: fix issue where clk is being unprepared twice")
> 
>    But I think it is a little complex to backport all the 5 patches. Moreover, it may be related
>    with other patches and code context mofification.
>    Therefore, I create a simple and clear patch to only this issue on linux-stable kernel, v 5.10

We almost ALWAYS want the original patches instead.  When we try to do
stable-only patches, 95% of the time it gets wrong and it makes
backporting future fixes for the same code area impossible.

So please submit the above patches as a series and I will be glad to
consider them.

thanks,

greg k-h
