Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0042366B0B3
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 12:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjAOLiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 06:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjAOLiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 06:38:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0BAB760;
        Sun, 15 Jan 2023 03:38:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0CD560C85;
        Sun, 15 Jan 2023 11:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AACDC433D2;
        Sun, 15 Jan 2023 11:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673782732;
        bh=Ig/08zW8bA7+m9pSq9nUzVfZvApqY/Uma484gnmFryg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GM8PQeU3jxLf0KcmiH7g1dqxujx2VxAdGDhvGmiFF5NBMAzqKuAtJ8IfUAROTuf7o
         2AetJRLe4TlWgZ7C+O+R7UIWVrq4W/eh4wKPYMrfgQCk8CySJ5NtM7c7w1OEHNfqu+
         ZFIcziwM6Lv2Imj+lpQWxkQ65Ff046olMaR1CvsY1er4bAAFNukf0bYVBo9OLeBQX/
         ZUW22TpljIj5DJ3l8AwzEYFi15b2xyaZ7RLJCgJ0hZvaWUaGj276kZXZqtBRT0HFIF
         stN3jZgVqS8VHyDIIYyaw0WZOBvoTlgI+qIqSjF3YF7pbr7z6S+HX+kIrGf5tH8p+u
         mSaYAJz2d8Myw==
Date:   Sun, 15 Jan 2023 13:38:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, sbhatta@marvell.com, hkelam@marvell.com,
        sgoutham@marvell.com
Subject: Re: [net PATCH v2] octeontx2-pf: Avoid use of GFP_KERNEL in atomic
 context
Message-ID: <Y8Plx2tH4N3aRMTc@unreal>
References: <20230113061902.6061-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113061902.6061-1-gakula@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 11:49:02AM +0530, Geetha sowjanya wrote:
> Using GFP_KERNEL in preemption disable context, causing below warning
> when CONFIG_DEBUG_ATOMIC_SLEEP is enabled.
> 
> [   32.542271] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
> [   32.550883] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
> [   32.558707] preempt_count: 1, expected: 0
> [   32.562710] RCU nest depth: 0, expected: 0
> [   32.566800] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G        W          6.2.0-rc2-00269-gae9dcb91c606 #7
> [   32.576188] Hardware name: Marvell CN106XX board (DT)
> [   32.581232] Call trace:
> [   32.583670]  dump_backtrace.part.0+0xe0/0xf0
> [   32.587937]  show_stack+0x18/0x30
> [   32.591245]  dump_stack_lvl+0x68/0x84
> [   32.594900]  dump_stack+0x18/0x34
> [   32.598206]  __might_resched+0x12c/0x160
> [   32.602122]  __might_sleep+0x48/0xa0
> [   32.605689]  __kmem_cache_alloc_node+0x2b8/0x2e0
> [   32.610301]  __kmalloc+0x58/0x190
> [   32.613610]  otx2_sq_aura_pool_init+0x1a8/0x314
> [   32.618134]  otx2_open+0x1d4/0x9d0
> 
> To avoid use of GFP_ATOMIC for memory allocation, disable preemption 
> after all memory allocation is done.
> 
> Fixes: 4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura free")
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
> v1-v2:
> - Moved get_cpu to avolid use of GFP_ATOMIC. 
> - reworked commit message.
> 
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
