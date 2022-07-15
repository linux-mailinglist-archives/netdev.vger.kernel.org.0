Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E888575A84
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 06:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiGOEjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 00:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiGOEjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 00:39:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD6D13F7A;
        Thu, 14 Jul 2022 21:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9459F621EF;
        Fri, 15 Jul 2022 04:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B65C34115;
        Fri, 15 Jul 2022 04:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657859939;
        bh=kTCrye5xmojVbbr2t21tN/FPZOGfqlgbAysxl8evOjI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WiTVatg/6C+crDlSj0yKc6Yca9nPBUBFCS0QOsKPV43442y0oeEXssoNpDiTcfCsl
         FdYl810fXGwE/C653PhcNMRAjAZ4Hd5PExIxQ2iAvMM47HUi6A75ur+dG3r1x6hN5y
         wx0zXSGAeDBNxm7F8Y2JVxIiYjvGP+ElZJYGl3J6Lq5eJwh6gdpHRVjNSOFWq9G8Ly
         g3O4pZeJTWXPdt9szQ5QoaRGonf2edhKgu5fKKA3Kj6EUooXs0eWPCJeCGBvqaj4fM
         lpgtxfwkjUllz14u5gN05qL6IOQazlNlwpwZLxIo3D2HgUy2Ros3s/UOlfgqXoD0HZ
         6fKA1xhh2sjHw==
Date:   Thu, 14 Jul 2022 21:38:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sieng-Piaw Liew <liew.s.piaw@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atl1c: use netif_tx_napi_add() for Tx NAPI
Message-ID: <20220714213857.45d4bf3e@kernel.org>
In-Reply-To: <20220715042131.1237-1-liew.s.piaw@gmail.com>
References: <20220715042131.1237-1-liew.s.piaw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 12:21:31 +0800 Sieng-Piaw Liew wrote:
> Use netif_tx_napi_add() for NAPI in Tx direction instead of the regular
> netif_napi_add() function.
> 
> Signed-off-by: Sieng-Piaw Liew <liew.s.piaw@gmail.com>

Please use netif_napi_add_tx(), since you use the default weight 
anyway there's no need to specify it.

> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 948584761e66..bf293a3ed4c9 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -2734,8 +2734,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		netif_napi_add(netdev, &adapter->rrd_ring[i].napi,
>  			       atl1c_clean_rx, 64);
>  	for (i = 0; i < adapter->tx_queue_count; ++i)
> -		netif_napi_add(netdev, &adapter->tpd_ring[i].napi,
> -			       atl1c_clean_tx, 64);
> +		netif_napi_add_tx_weight(netdev, &adapter->tpd_ring[i].napi,
> +					 atl1c_clean_tx, 64);
>  	timer_setup(&adapter->phy_config_timer, atl1c_phy_config, 0);
>  	/* setup the private structure */
>  	err = atl1c_sw_init(adapter);

