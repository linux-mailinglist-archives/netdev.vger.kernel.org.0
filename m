Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209AC52405E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 00:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348857AbiEKWka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 18:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237831AbiEKWk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 18:40:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940EB229FD4;
        Wed, 11 May 2022 15:40:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5450DB82642;
        Wed, 11 May 2022 22:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CD3C340EE;
        Wed, 11 May 2022 22:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652308826;
        bh=gkhGzljdxYOAvwVufIdD8QmPZwy/Lf+CjdQJnzKygfw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=seVlXzLKI8BYT03tHm/8AFO65IFmHfJPhouIxV/rl9rTXeGUbm7T0PGOu9TPcunkt
         5hCPKAJD6T+Ar2XMyg4/MmabKvaRDqh6dZo0Muh4qqiPvApfMaX+9rIbSmhbL63b6A
         X8Xll9qCSSM+yuy4kLGoBotDfRD3ZIuaUNjWqLjtujAcH9Ai+ygghskID2pR15JFn3
         0Ebn8CLtfsbSXZpd9eo34bl3zjfvtNVcQEe4g1UODs/Cv9WpelneUjzUZeMZJHJPA8
         mSo2003wej1hn7KE4KQjofUCbXnPFo6/9RMs/y/0S8sxxCxaSdDknhyFxcmk3GcegC
         Pq+fYy2RvVn4g==
Date:   Wed, 11 May 2022 15:40:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <dumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@xilinx.com>,
        <harinikatakamlinux@gmail.com>, <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH v2] net: macb: Disable macb pad and fcs for fragmented
 packets
Message-ID: <20220511154024.5e231704@kernel.org>
In-Reply-To: <20220510162809.5511-1-harini.katakam@xilinx.com>
References: <20220510162809.5511-1-harini.katakam@xilinx.com>
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

On Tue, 10 May 2022 21:58:09 +0530 Harini Katakam wrote:
> data_len in skbuff represents bytes resident in fragment lists or
> unmapped page buffers. For such packets, when data_len is non-zero,
> skb_put cannot be used - this will throw a kernel bug. Hence do not
> use macb_pad_and_fcs for such fragments.
> 
> Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

I'm confused. When do we *have to* compute the FCS?

This commit seems to indicate that we can't put the FCS so it's okay to
ask the HW to do it. But that's backwards. We should ask the HW to
compute the FCS whenever possible, to save the CPU cycles.

Is there an unstated HW limitation here?

> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 6434e74c04f1..0b03305ad6a0 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -1995,7 +1995,8 @@ static unsigned int macb_tx_map(struct macb *bp,
>  			ctrl |= MACB_BF(TX_LSO, lso_ctrl);
>  			ctrl |= MACB_BF(TX_TCP_SEQ_SRC, seq_ctrl);
>  			if ((bp->dev->features & NETIF_F_HW_CSUM) &&
> -			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl)
> +			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl &&
> +			    (skb->data_len == 0))

nit: unnecessary parenthesis

>  				ctrl |= MACB_BIT(TX_NOCRC);
>  		} else
>  			/* Only set MSS/MFS on payload descriptors
> @@ -2091,9 +2092,11 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
>  	struct sk_buff *nskb;
>  	u32 fcs;
>  
> +	/* Not available for GSO and fragments */
>  	if (!(ndev->features & NETIF_F_HW_CSUM) ||
>  	    !((*skb)->ip_summed != CHECKSUM_PARTIAL) ||
> -	    skb_shinfo(*skb)->gso_size)	/* Not available for GSO */
> +	    skb_shinfo(*skb)->gso_size ||
> +	    ((*skb)->data_len > 0))
>  		return 0;
>  
>  	if (padlen <= 0) {

