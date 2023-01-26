Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEEF67C49F
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjAZHEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjAZHEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:04:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977575EF8A
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:04:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49FE5B81CFD
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF827C433EF;
        Thu, 26 Jan 2023 07:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674716652;
        bh=0VE6TpyK52DM9DamFA+tvTGTXdZHMgT1bcTBWgraL+0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eT8YgUdEcfxkT7t/FpmBFSWOl3GftuTxtoBkNZQqUbQag05n30PpoclMhsz241pKk
         VJ1IPSj6j1Q9JiUhWvp8XSNJBfvfdkZM/KSdvRl/CQRz1gJiLzncxIDoaUEbMN+qjP
         dO7sgV8jnsSiDWnEPBurl0Nt9N0I0288HTVYJFUP/5FVS5moWxRx4g8IshLnrxolgU
         n6VQPCjAKAUov8vT4Ty91WviGxyPOTMLNY0BGhDUYOl8pWX/Jh5Th6wq0hnmP/jBdN
         u939SEnjZmkXKaHGB/BkkWvW2KEjUArLkhjK9nHZ+/Gv1MOZBtJqwqvkrg46uUrCEP
         rDV7J7XpY6KIw==
Date:   Wed, 25 Jan 2023 23:04:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <Shyam-sundar.S-k@amd.com>
Subject: Re: [PATCH net-next 2/2] amd-xgbe: add support for rx-adaptation
Message-ID: <20230125230410.79342e6a@kernel.org>
In-Reply-To: <20230125072529.2222420-3-Raju.Rangoju@amd.com>
References: <20230125072529.2222420-1-Raju.Rangoju@amd.com>
        <20230125072529.2222420-3-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Jan 2023 12:55:29 +0530 Raju Rangoju wrote:
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -387,7 +387,13 @@ struct xgbe_phy_data {
>  /* I2C, MDIO and GPIO lines are muxed, so only one device at a time */
>  static DEFINE_MUTEX(xgbe_phy_comm_lock);
>  
> +static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
> +					unsigned int cmd, unsigned int sub_cmd);
>  static enum xgbe_an_mode xgbe_phy_an_mode(struct xgbe_prv_data *pdata);
> +static void xgbe_phy_rrc(struct xgbe_prv_data *pdata);
> +static void xgbe_phy_set_mode(struct xgbe_prv_data *pdata, enum xgbe_mode mode);
> +static void xgbe_phy_kr_mode(struct xgbe_prv_data *pdata);
> +static void xgbe_phy_sfi_mode(struct xgbe_prv_data *pdata);

Why the forward declarations? It's against the kernel coding style.

>  static int xgbe_phy_i2c_xfer(struct xgbe_prv_data *pdata,
>  			     struct xgbe_i2c_op *i2c_op)
> @@ -2038,6 +2044,87 @@ static void xgbe_phy_set_redrv_mode(struct xgbe_prv_data *pdata)
>  	xgbe_phy_put_comm_ownership(pdata);
>  }
>  
> +#define MAX_RX_ADAPT_RETRIES	1
> +#define XGBE_PMA_RX_VAL_SIG_MASK	(XGBE_PMA_RX_SIG_DET_0_MASK | XGBE_PMA_RX_VALID_0_MASK)
> +
> +static inline void xgbe_set_rx_adap_mode(struct xgbe_prv_data *pdata, enum xgbe_mode mode)

Don't pointlessly use inline, please. The compiler will know when 
to inline, and this is not the datapath.
