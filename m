Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5132764C1E4
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 02:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbiLNBfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 20:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236790AbiLNBfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 20:35:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2042ADA;
        Tue, 13 Dec 2022 17:35:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1686E617BC;
        Wed, 14 Dec 2022 01:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F97C433EF;
        Wed, 14 Dec 2022 01:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670981714;
        bh=InZ0Yk/rNc1Gi7tVUXOaAYsQddfKxjS2U9stB0Jg02w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O7t02eoj6huI37qEVBZ+w9JV0ZAAYdbvSd6cBMhS5FrtDtmaHqtBCGpss8V9slFM4
         +lBH+cr1CqsQUKRMj9t2iM6ApULGbqgLNNpkoYq8myOhnxxGZ0U0zlsrIpRU7N8Qqh
         Fo5UFz3Jj3sM1yPjrSkv16CzuMJDHz1kHFhUlWegzHCwsafeaiHwj6X4PzuUqXK5aP
         jK1tC2aejiIccqJHpQGw77c1BzTQ4SX7pQ+v0Aw+87fFWmGDl9A9aDuz5BUP6+gnDg
         2GT7SU2h/UfNwWy8X872oB6AzHLGiFMk8qfssJZJHqGraTbLgPg9Op/DbI1v26zxg9
         AmW6v643M4/QQ==
Date:   Tue, 13 Dec 2022 17:35:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pranavi Somisetty <pranavi.somisetty@amd.com>
Cc:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <git@amd.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: Re: [LINUX RFC PATCH] net: macb: Add support for partial store and
 forward
Message-ID: <20221213173512.7902e7df@kernel.org>
In-Reply-To: <20221213121245.13981-1-pranavi.somisetty@amd.com>
References: <20221213121245.13981-1-pranavi.somisetty@amd.com>
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

On Tue, 13 Dec 2022 05:12:45 -0700 Pranavi Somisetty wrote:
> From: Maulik Jodhani <maulik.jodhani@xilinx.com>
> 
> - Validate FCS in receive interrupt handler if Rx checksum offloading
>   is disabled
> - Get rx-watermark value from DT

Sounds like two separate changes, please split into two patches

> @@ -1375,6 +1385,16 @@ static int gem_rx(struct macb_queue *queue, struct napi_struct *napi,
>  				 bp->rx_buffer_size, DMA_FROM_DEVICE);
>  
>  		skb->protocol = eth_type_trans(skb, bp->dev);
> +
> +		/* Validate MAC fcs if RX checsum offload disabled */
> +		if (!(bp->dev->features & NETIF_F_RXCSUM)) {

RXCSUM is for L4 (TCP/UDP) checksums, FCS is simply assumed 
to be validated by HW.

> +			if (macb_validate_hw_csum(skb)) {
> +				netdev_err(bp->dev, "incorrect FCS\n");

This can flood logs, and is likely unnecessary since we have a
dedicated statistics for crc errors (rx_crc_errors).

> +				bp->dev->stats.rx_dropped++;

CRC errors are errors not drops see the comment above struct
rtnl_link_stats64 for more info.

> +				break;
> +			}
> +		}

> @@ -3812,10 +3862,29 @@ static void macb_configure_caps(struct macb *bp,
>  				const struct macb_config *dt_conf)
>  {
>  	u32 dcfg;
> +	int retval;
>  
>  	if (dt_conf)
>  		bp->caps = dt_conf->caps;
>  
> +	/* By default we set to partial store and forward mode for zynqmp.
> +	 * Disable if not set in devicetree.
> +	 */
> +	if (bp->caps & MACB_CAPS_PARTIAL_STORE_FORWARD) {
> +		retval = of_property_read_u16(bp->pdev->dev.of_node,
> +					      "rx-watermark",
> +					      &bp->rx_watermark);

is this property documented in the bindings?
