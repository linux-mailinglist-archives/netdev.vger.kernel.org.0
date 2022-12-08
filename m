Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD40646BEB
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiLHJ3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiLHJ3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:29:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C228B5FB8C;
        Thu,  8 Dec 2022 01:29:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C38161E17;
        Thu,  8 Dec 2022 09:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9EBC433C1;
        Thu,  8 Dec 2022 09:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670491748;
        bh=JTSnvjJbgzaHvbJe+ytd+IiJru5C8GekViaefPzGqjs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YRgGiT7IJv5CJgKhokEss4bEjglrQqeNSiwFnI6ShvcMt5gBD+76VhZGTqsIRhjuh
         Pzn44al0MvYfwk32ddPNEw0i1ezI1II2/1lLAqhc7yBXFb+MinvQMXPbppiufR3ebE
         sEQJB+RmgJltNq8yabqt69XmhPRb2EksnyCg42keAS1BSrLlqyhzwQ/+zRTDRLnQkz
         GQEg13MCaMNHkL8UEONxe8hnL35dE5LgbT3bzxQJpfI4AJVoRJ/TBrIRGH3Hnv3xm2
         v/qGvuLBAV/b55yeO2yprdKUPT+ipaglA+re7PU5Ba4M4GA9twBUxdTjlxBFyWDUvi
         PJb5i/YM3OyRQ==
Date:   Thu, 8 Dec 2022 11:29:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        Michal Simek <michal.simek@xilinx.com>,
        John Linn <john.linn@xilinx.com>,
        Sadanand M <sadanan@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        Ilya Yanok <yanok@emcraft.com>,
        Joerg Reuter <jreuter@yaina.de>, linux-hams@vger.kernel.org
Subject: Re: [PATCH v2 resend 0/4] net: don't call dev_kfree_skb() under
 spin_lock_irqsave()
Message-ID: <Y5GuYA/abm1UvUro@unreal>
References: <20221208032655.1024032-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208032655.1024032-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 11:26:51AM +0800, Yang Yingliang wrote:
> It is not allowed to call consume_skb() from hardware interrupt context
> or with interrupts being disabled. This patchset replace dev_kfree_skb()
> with dev_consume_skb_irq() under spin_lock_irqsave() in some drivers, or
> move dev_kfree_skb() after spin_unlock_irqrestore().

Like I said it to you already. You MUST explain why dev_consume_skb_irq()
was chosen over dev_kfree_skb_irq().

Thanks

> 
> Resend for CC all authors / reviewers of commits under "Fixes:".
> 
> v1 -> v2:
>   patch #2 Move dev_kfree_skb() after spin_unlock_irqrestore()
> 
> Yang Yingliang (4):
>   net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()
>   net: ethernet: dnet: don't call dev_kfree_skb() under
>     spin_lock_irqsave()
>   hamradio: don't call dev_kfree_skb() under spin_lock_irqsave()
>   net: amd: lance: don't call dev_kfree_skb() under spin_lock_irqsave()
> 
>  drivers/net/ethernet/amd/atarilance.c         | 2 +-
>  drivers/net/ethernet/amd/lance.c              | 2 +-
>  drivers/net/ethernet/dnet.c                   | 4 ++--
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c | 2 +-
>  drivers/net/hamradio/scc.c                    | 6 +++---
>  5 files changed, 8 insertions(+), 8 deletions(-)
> 
> -- 
> 2.25.1
> 
