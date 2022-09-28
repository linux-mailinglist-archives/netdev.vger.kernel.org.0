Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0319C5EE25F
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiI1Q4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 12:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiI1Q4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:56:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F386C13D1D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:56:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4494361F26
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 16:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA8BC433C1;
        Wed, 28 Sep 2022 16:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664384180;
        bh=qyG3KrU5/BOf/jkM+WR4aIYGEy1Z3apHxT+ImXIiPPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pGrgoJITV+Fk+noiuQYgVjzJPxvwMRhQodTJkhcbMWi9VjBpI71pO3jIK6s1gt+MG
         D3t28KBhzNWgNnttGgxz+aAEZYmhVlIKcs4W73FbWqbMBougcGYno19OJGjO8BA1+1
         TIE7oK3OZlUVb+eyuj08mxQj9WIFBIJSDOZmmPvWcpt743lrVBVCjXiCVPkrSV6MNs
         qYBC7QsgNApde6jMQ1LEtiixIFk8gN2bXxYh/7IScgucRdD5fmGTNV5/H6azCAQsrn
         VDslTeeEuc9um81XwL77YHKFtPHoJjP5n8ZLZmjvoHMBf8SbV0MtpkMHUpnVTq6apH
         f1NR5wqPVrSCA==
Date:   Wed, 28 Sep 2022 19:56:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Chunhao Lin <hau@realtek.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [PATCH net-next v2] r8169: add rtl_disable_rxdvgate()
Message-ID: <YzR8sHxXsHoenMA7@unreal>
References: <20220928130317.3522-1-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928130317.3522-1-hau@realtek.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 09:03:17PM +0800, Chunhao Lin wrote:
> rtl_disable_rxdvgate() is used for disable RXDV_GATE. It is opposite function
> of rtl_enable_rxdvgate().
> 
> Disable RXDV_GATE does not have to delay. So in this patch, also remove the
> delay after disale RXDV_GATE.
> 
> v2:
> - update commit message.


Please put changelog after --- trailing.

Thanks

> 
> Signed-off-by: Chunhao Lin <hau@realtek.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 9c21894d0518..956562797496 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2443,6 +2443,11 @@ static void rtl_wait_txrx_fifo_empty(struct rtl8169_private *tp)
>  	}
>  }
>  
> +static void rtl_disable_rxdvgate(struct rtl8169_private *tp)
> +{
> +	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
> +}
> +
>  static void rtl_enable_rxdvgate(struct rtl8169_private *tp)
>  {
>  	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | RXDV_GATED_EN);
> @@ -2960,7 +2965,7 @@ static void rtl_hw_start_8168g(struct rtl8169_private *tp)
>  	rtl_reset_packet_filter(tp);
>  	rtl_eri_write(tp, 0x2f8, ERIAR_MASK_0011, 0x1d8f);
>  
> -	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
> +	rtl_disable_rxdvgate(tp);
>  
>  	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
>  	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
> @@ -3198,7 +3203,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
>  
>  	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
>  
> -	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
> +	rtl_disable_rxdvgate(tp);
>  
>  	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
>  	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
> @@ -3249,7 +3254,7 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
>  
>  	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
>  
> -	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
> +	rtl_disable_rxdvgate(tp);
>  
>  	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
>  	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
> @@ -3313,7 +3318,7 @@ static void rtl_hw_start_8117(struct rtl8169_private *tp)
>  
>  	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
>  
> -	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
> +	rtl_disable_rxdvgate(tp);
>  
>  	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
>  	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
> @@ -3557,8 +3562,7 @@ static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
>  	else
>  		rtl8125a_config_eee_mac(tp);
>  
> -	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
> -	udelay(10);
> +	rtl_disable_rxdvgate(tp);
>  }
>  
>  static void rtl_hw_start_8125a_2(struct rtl8169_private *tp)
> -- 
> 2.25.1
> 
