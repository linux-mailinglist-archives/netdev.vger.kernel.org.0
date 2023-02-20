Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB93D69C3E8
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 02:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjBTBJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 20:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBTBJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 20:09:33 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1666CAD1E;
        Sun, 19 Feb 2023 17:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xQmkyMf+RcZg1rAVudpX2gGMTuBygVj0PxUR7lE++VI=; b=bu1ki1kFEatjlgfD3nfhzGARwW
        EQ3LSsgRONoIFYhd32sbouDUFvxkYTwp/8eMzlCDi2o8dEq8BppS7Vr9t2ZCNZ+ENnO9vbUI5eVOh
        n6N3ybfgIs9+qFNT6Y1SmjTxQ/mg6J5vdr9InoSGGMGdj06RcEgC53QUIzJEAhAacXvI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pTugN-005T0K-2E; Mon, 20 Feb 2023 02:09:31 +0100
Date:   Mon, 20 Feb 2023 02:09:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Weinberger <richard@nod.at>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, linux-imx@nxp.com, xiaoning.wang@nxp.com,
        shenwei.wang@nxp.com, wei.fang@nxp.com
Subject: Re: [PATCH] [RFC] net: fec: Allow turning off IRQ coalescing
Message-ID: <Y/LIS3xd1iZRyVGe@lunn.ch>
References: <20230218214037.16977-1-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230218214037.16977-1-richard@nod.at>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  /* Set threshold for interrupt coalescing */
> -static void fec_enet_itr_coal_set(struct net_device *ndev)
> +static int fec_enet_itr_coal_set(struct net_device *ndev)
>  {
> +	bool disable_rx_itr = false, disable_tx_itr = false;
>  	struct fec_enet_private *fep = netdev_priv(ndev);
> -	int rx_itr, tx_itr;
> +	struct device *dev = &fep->pdev->dev;
> +	int rx_itr = 0, tx_itr = 0;
>  
> -	/* Must be greater than zero to avoid unpredictable behavior */
> -	if (!fep->rx_time_itr || !fep->rx_pkts_itr ||
> -	    !fep->tx_time_itr || !fep->tx_pkts_itr)
> -		return;
> +	if (!fep->rx_time_itr || !fep->rx_pkts_itr) {
> +		if (fep->rx_time_itr || fep->rx_pkts_itr) {
> +			dev_warn(dev, "Rx coalesced frames and usec have to be "
> +				      "both positive or both zero to disable Rx "
> +				      "coalescence completely\n");
> +			return -EINVAL;
> +		}

Hi Richard

Why do this validation here, and not in fec_enet_set_coalesce() where
there are already checks? fec_enet_set_coalesce() also has extack, so
you can return useful messages to user space, not just the kernel log.

    Andrew
