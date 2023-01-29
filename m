Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D903367FDE7
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 10:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbjA2Jmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 04:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjA2Jmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 04:42:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4642D199C5;
        Sun, 29 Jan 2023 01:42:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6801ACE0C75;
        Sun, 29 Jan 2023 09:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86CBC433EF;
        Sun, 29 Jan 2023 09:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674985360;
        bh=cDHRppi5bSxiQpIg+4Lg/lg/Nd1ECvFcRPyT3hHn53M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eV7xWs6gjo6hl3pgMTl8wcLZ/QxXnFqQmgNT/UEa1VP0hiEKSTAslGHBnc+YiIGpE
         +gVC5lwNS9VpuL888bydG/gJNMSUOZFHLD0God5YXIANsABp09tNVdr0kJ4CuJFJfq
         PjAXbqnBSluN74EW/kyHbdffyFRYQ7HBGyoM07iVZZT1rwUx9pb5hTiOnFHuGJqN6m
         wunbnt2YsUv//aqlaena47Qt1pvVLgNiEsHMunJ0LO61B3RGZfA96fs6JJwUlXJyVn
         ZSfS7Vd43piLMzEOEVyIjbUBjZBrjEi/GfRoJTchYwUMMgAd4+8OGQWSZzSzp8GVqA
         uMYD2KfhdOMkw==
Date:   Sun, 29 Jan 2023 11:42:36 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, maxime@cerno.tech,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: bcmgenet: Add a check for oversized packets
Message-ID: <Y9Y/jMZZbS4HNpCC@unreal>
References: <20230127000819.3934-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127000819.3934-1-f.fainelli@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 04:08:19PM -0800, Florian Fainelli wrote:
> Occasionnaly we may get oversized packets from the hardware which
> exceed the nomimal 2KiB buffer size we allocate SKBs with. Add an early
> check which drops the packet to avoid invoking skb_over_panic() and move
> on to processing the next packet.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 21973046b12b..d937daa8ee88 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -2316,6 +2316,14 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
>  			  __func__, p_index, ring->c_index,
>  			  ring->read_ptr, dma_length_status);
>  
> +		if (unlikely(len > RX_BUF_LENGTH)) {
> +			netif_err(priv, rx_status, dev, "oversized packet\n");

I don't think that it is wise move to print to dmesg something that can
be triggered by user over network.

Thanks

> +			dev->stats.rx_length_errors++;
> +			dev->stats.rx_errors++;
> +			dev_kfree_skb_any(skb);
> +			goto next;
> +		}
> +
>  		if (unlikely(!(dma_flag & DMA_EOP) || !(dma_flag & DMA_SOP))) {
>  			netif_err(priv, rx_status, dev,
>  				  "dropping fragmented packet!\n");
> -- 
> 2.25.1
> 
