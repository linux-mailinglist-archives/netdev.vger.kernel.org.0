Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A2A6DBFB3
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 13:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDILvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 07:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDILvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 07:51:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290DD1FF5
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 04:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B70DD60B06
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 11:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582DEC433EF;
        Sun,  9 Apr 2023 11:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681041075;
        bh=7ZHrHz7oN0e4GDIYSgkYWtw4YYZowdng05V2Z9Tk0Ww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TeQcK8623uUaCP963zs4G6ZSyI1XwcSM9Bly7V1bhyR3tirS/Abp0+AW4JSzLo8MB
         zV5xU0RYjp4IcHybKd6ncvTYh/K6k54EwDN1A1iGu24y4/4IkPAOdxMFvGyPUroG/6
         36AUbG+S9LtQU4iTVTN4Dc7uljKe114A7b0TSksed6nfCdWeeqIuLzhBAEmIuHS4J0
         Ob5oIResqtN8lhiLJ/roNN4qR48WH8jnYisCYVTNOsTaC7j83XwPB5s3iGJs4EwNhD
         gJiDA0lTV+2y5mBitDK0k/gLky2VPO2DPc4cVuJ9MIbIO3fjz79NNkbkNbNbakazCQ
         87FIsj0X5TZtg==
Date:   Sun, 9 Apr 2023 14:51:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 03/14] pds_core: health timer and workqueue
Message-ID: <20230409115110.GB182481@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-4-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406234143.11318-4-shannon.nelson@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:41:32PM -0700, Shannon Nelson wrote:
> Add in the periodic health check and the related workqueue,
> as well as the handlers for when a FW reset is seen.
> 
> The firmware is polled every 5 seconds to be sure that it is
> still alive and that the FW generation didn't change.
> 
> The alive check looks to see that the PCI bus is still readable
> and the fw_status still has the RUNNING bit on.  If not alive,
> the driver stops activity and tears things down.  When the FW
> recovers and the alive check again succeeds, the driver sets
> back up for activity.
> 
> The generation check looks at the fw_generation to see if it
> has changed, which can happen if the FW crashed and recovered
> or was updated in between health checks.  If changed, the
> driver counts that as though the alive test failed and forces
> the fw_down/fw_up cycle.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/amd/pds_core/core.c | 61 ++++++++++++++++++++++++
>  drivers/net/ethernet/amd/pds_core/core.h |  8 ++++
>  drivers/net/ethernet/amd/pds_core/dev.c  |  3 ++
>  drivers/net/ethernet/amd/pds_core/main.c | 37 ++++++++++++++
>  4 files changed, 109 insertions(+)

<...>

>  
>  err_out_unmap_bars:
>  	mutex_unlock(&pdsc->config_lock);
> +	del_timer_sync(&pdsc->wdtimer);
> +	if (pdsc->wq) {
> +		flush_workqueue(pdsc->wq);
> +		destroy_workqueue(pdsc->wq);

There is no need to call to flush_workqueue() as destroy_workqueue()
will do it.

> +		pdsc->wq = NULL;
> +	}
>  	mutex_destroy(&pdsc->config_lock);
>  	mutex_destroy(&pdsc->devcmd_lock);
>  	pci_free_irq_vectors(pdsc->pdev);
> @@ -270,6 +300,13 @@ static void pdsc_remove(struct pci_dev *pdev)
>  	devl_unlock(dl);
>  
>  	if (!pdev->is_virtfn) {
> +		del_timer_sync(&pdsc->wdtimer);
> +		if (pdsc->wq) {
> +			flush_workqueue(pdsc->wq);
> +			destroy_workqueue(pdsc->wq);

Same

> +			pdsc->wq = NULL;

Not really needed, pdsc is released.

> +		}
> +
>  		mutex_lock(&pdsc->config_lock);
>  		set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
>  
> -- 
> 2.17.1
> 
