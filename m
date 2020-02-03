Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1F61512AF
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 00:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgBCXE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 18:04:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbgBCXE4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 18:04:56 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45CC120674;
        Mon,  3 Feb 2020 23:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580771095;
        bh=vzyez2WIfsTNn3tKO6gcRBw5UeiKLIVBY41eTtjUVsU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2FueImXvEyyZitLXHJBvvGyOWtS4YDUn5n2hYwUS03ovEeuXiU8uhlsqj97bmJb1N
         Aw4bDeZ1I3S75w0P0LlcqpMUno7HDbfCwM/pBNSjEQt9TKySfagHSIhZ1No+5sBY/f
         LMPTPgEBH9w8kRhXgNkoX7K7Ij/wUzPKbW5ysSS4=
Date:   Mon, 3 Feb 2020 15:04:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicolin Chen <nicoleotsuka@gmail.com>
Cc:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: Delete txtimer in suspend()
Message-ID: <20200203150454.2938960b@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200201020124.5989-1-nicoleotsuka@gmail.com>
References: <20200201020124.5989-1-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 18:01:24 -0800, Nicolin Chen wrote:
> When running v5.5 with a rootfs on NFS, memory abort may happen in
> the system resume stage:
>  Unable to handle kernel paging request at virtual address dead00000000012a
>  [dead00000000012a] address between user and kernel address ranges
>  pc : run_timer_softirq+0x334/0x3d8
>  lr : run_timer_softirq+0x244/0x3d8
>  x1 : ffff800011cafe80 x0 : dead000000000122
>  Call trace:
>   run_timer_softirq+0x334/0x3d8
>   efi_header_end+0x114/0x234
>   irq_exit+0xd0/0xd8
>   __handle_domain_irq+0x60/0xb0
>   gic_handle_irq+0x58/0xa8
>   el1_irq+0xb8/0x180
>   arch_cpu_idle+0x10/0x18
>   do_idle+0x1d8/0x2b0
>   cpu_startup_entry+0x24/0x40
>   secondary_start_kernel+0x1b4/0x208
>  Code: f9000693 a9400660 f9000020 b4000040 (f9000401)
>  ---[ end trace bb83ceeb4c482071 ]---
>  Kernel panic - not syncing: Fatal exception in interrupt
>  SMP: stopping secondary CPUs
>  SMP: failed to stop secondary CPUs 2-3
>  Kernel Offset: disabled
>  CPU features: 0x00002,2300aa30
>  Memory Limit: none
>  ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
> 
> It's found that stmmac_xmit() and stmmac_resume() sometimes might
> run concurrently, possibly resulting in a race condition between
> mod_timer() and setup_timer(), being called by stmmac_xmit() and
> stmmac_resume() respectively.
> 
> Since the resume() runs setup_timer() every time, it'd be safer to
> have del_timer_sync() in the suspend() as the counterpart.
> 
> Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>

Applied, and queued for stable, thank you!
