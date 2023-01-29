Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD3C67FDD8
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 10:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjA2J15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 04:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjA2J14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 04:27:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C415676B6;
        Sun, 29 Jan 2023 01:27:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52E8A60C9F;
        Sun, 29 Jan 2023 09:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B611C433D2;
        Sun, 29 Jan 2023 09:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674984473;
        bh=yFcpmg/UMFJpOCwDQBswVxXNSnNSR/heY/Zgyoa5AD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EP7HAKXMlcs3QvSJFRgkgNhmVvqYB6XWpcO14XOrN4/DQJkbapRoHQaym1NxZh3HO
         3EfKZJLhtdy6Ru09KbMaZWb00DBjV8O/g3pbxWoP6ky1qWlwOY+aFDnozWsNYndigE
         RX6Tnh+sQKNDDQopqhvk4+pc2iKbbVx3wRum+kGHKiaFHtfs/EL+mzc0mDhyJCJ/xI
         CW/f5c7qfaLb33WEc3Cb5tmqwC+Hpcm8IIlo11yjkdTBOuEoZ4ZTdMIhAtcA3oUBuG
         j+WYDL8V/qjUOrZEaZqf+c3iYrlINScmGPyp8HbFkK1dQ7Zj2j5ZZDniJo1zbnwq7l
         yBszYdQIUOumQ==
Date:   Sun, 29 Jan 2023 11:27:49 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net, 1/2] net: mana: Fix hint value before free irq
Message-ID: <Y9Y8FSlYNyNDf6AD@unreal>
References: <1674767085-18583-1-git-send-email-haiyangz@microsoft.com>
 <1674767085-18583-2-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1674767085-18583-2-git-send-email-haiyangz@microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 01:04:44PM -0800, Haiyang Zhang wrote:
> Need to clear affinity_hint before free_irq(), otherwise there is a
> one-time warning and stack trace during module unloading.

Please add this warning and stack trace to the commit message.

Thanks

> 
> To fix this bug, set affinity_hint to NULL before free as required.
> 
> Cc: stable@vger.kernel.org
> Fixes: 71fa6887eeca ("net: mana: Assign interrupts to CPUs based on NUMA nodes")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/gdma_main.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index b144f2237748..3bae9d4c1f08 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1297,6 +1297,8 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
>  	for (j = i - 1; j >= 0; j--) {
>  		irq = pci_irq_vector(pdev, j);
>  		gic = &gc->irq_contexts[j];
> +
> +		irq_update_affinity_hint(irq, NULL);
>  		free_irq(irq, gic);
>  	}
>  
> @@ -1324,6 +1326,9 @@ static void mana_gd_remove_irqs(struct pci_dev *pdev)
>  			continue;
>  
>  		gic = &gc->irq_contexts[i];
> +
> +		/* Need to clear the hint before free_irq */
> +		irq_update_affinity_hint(irq, NULL);
>  		free_irq(irq, gic);
>  	}
>  
> -- 
> 2.25.1
> 
