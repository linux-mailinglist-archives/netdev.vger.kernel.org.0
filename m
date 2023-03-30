Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A348C6CFC39
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjC3HGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 03:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjC3HGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 03:06:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C5E5B8A;
        Thu, 30 Mar 2023 00:06:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A83FB81CA6;
        Thu, 30 Mar 2023 07:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E71C433D2;
        Thu, 30 Mar 2023 07:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680160006;
        bh=zjhKg0mImlRVQGrHm8jIv/or6uciiXfahvf7xmSjkeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dYJlQfuxV1gLhJsEK/HVF732sSBGbzBJLBfZCoE3/wpkI8NBlI2oHifBWryRTzwWd
         LfcCoi0evrxoEJu04zneadyjGWgOtwWLEkVzJYlLGy3RPNbBJRcGbYitl8ivZ4AdNt
         uM0MliXHmv9Oyg4PU0b/xOWjkrCDEHXdmVM42WBX8ta8qtY2xghnMtbZPZPReXZD9T
         PGOwnRx1P+uJeva600FPimKsP25kAb2eC13mLiYDnqlhR71lz+JjN/DwRXSTlwegoj
         IIa7uFdXxYTsOAfEZjYrzz/k8e/HSdwzVCgkK3fnBxt00YVTVk66oAkeIok9Zv/7m7
         SaZSgNzovEhwQ==
Date:   Thu, 30 Mar 2023 10:06:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        richardcochran@gmail.com, claudiu.beznea@microchip.com,
        andrei.pistirica@microchip.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@amd.com,
        harinikatakamlinux@gmail.com
Subject: Re: [PATCH net-next v4 1/3] net: macb: Update gem PTP support check
Message-ID: <20230330070642.GR831478@unreal>
References: <20230330050809.19180-1-harini.katakam@amd.com>
 <20230330050809.19180-2-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330050809.19180-2-harini.katakam@amd.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 10:38:07AM +0530, Harini Katakam wrote:
> There are currently two checks for PTP functionality - one on GEM
> capability and another on the kernel config option. Combine them
> into a single function as there's no use case where gem_has_ptp is
> TRUE and MACB_USE_HWSTAMP is false.
> 
> Signed-off-by: Harini Katakam <harini.katakam@amd.com>
> ---
> v4:
> Fixed error introduced in 1/3 in v3:
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202303280600.LarprmhI-lkp@intel.com/
> v3:
> New patch
> 
>  drivers/net/ethernet/cadence/macb.h      | 2 +-
>  drivers/net/ethernet/cadence/macb_main.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index c1fc91c97cee..b6c5ecbd572c 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -1363,7 +1363,7 @@ static inline bool macb_is_gem(struct macb *bp)
>  
>  static inline bool gem_has_ptp(struct macb *bp)
>  {
> -	return !!(bp->caps & MACB_CAPS_GEM_HAS_PTP);
> +	return (IS_ENABLED(CONFIG_MACB_USE_HWSTAMP) && (!!(bp->caps & MACB_CAPS_GEM_HAS_PTP)));

Brackets and double !! are not needed.

return IS_ENABLED(CONFIG_MACB_USE_HWSTAMP) && (bp->caps & MACB_CAPS_GEM_HAS_PTP);

>  }
>  
>  /**
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index f77bd1223c8f..eab2d41fa571 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -3889,17 +3889,17 @@ static void macb_configure_caps(struct macb *bp,
>  		dcfg = gem_readl(bp, DCFG2);
>  		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
>  			bp->caps |= MACB_CAPS_FIFO_MODE;
> -#ifdef CONFIG_MACB_USE_HWSTAMP
>  		if (gem_has_ptp(bp)) {
>  			if (!GEM_BFEXT(TSU, gem_readl(bp, DCFG5)))
>  				dev_err(&bp->pdev->dev,
>  					"GEM doesn't support hardware ptp.\n");
>  			else {
> +#ifdef CONFIG_MACB_USE_HWSTAMP
>  				bp->hw_dma_cap |= HW_DMA_CAP_PTP;
>  				bp->ptp_info = &gem_ptp_info;
> +#endif
>  			}
>  		}
> -#endif
>  	}
>  
>  	dev_dbg(&bp->pdev->dev, "Cadence caps 0x%08x\n", bp->caps);
> -- 
> 2.17.1
> 
