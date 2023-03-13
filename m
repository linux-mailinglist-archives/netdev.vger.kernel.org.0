Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0D76B7B7E
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjCMPHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 11:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCMPH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:07:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B445F6BC1B
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 08:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=P68Yw/7o5nyZ6F3mUdfLXWuPmaRAer+1EQMCSFRtuho=; b=Ub
        s3sEGmCwqwgoT6UNHJIEerFM4Pp7MdQwL+QgYGPXsAHn/rNCXLxQx40MBg1J2YSKBZbus6Nm38Z9P
        nqyT9529tbrMiz2VfLxbs1qSVFPxEZbuIBVyQSby1VS+D+Kd40GS8bh8F8W+ZM2WKhCuIteUrlydK
        mhxdVbt69FfESoc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pbjlY-007C8K-Cz; Mon, 13 Mar 2023 16:07:12 +0100
Date:   Mon, 13 Mar 2023 16:07:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH net-next 2/9] net: fec: Don't return early on error in
 .remove()
Message-ID: <e84585f2-e3d9-4a87-bfd4-a9ba458553b9@lunn.ch>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
 <20230313103653.2753139-3-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230313103653.2753139-3-u.kleine-koenig@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:36:46AM +0100, Uwe Kleine-König wrote:
> If waking up the device in .remove() fails, exiting early results in
> strange state: The platform device will be unbound but not all resources
> are freed. E.g. the network device continues to exist without an parent.
> 
> Instead of an early error return, only skip the cleanup that was already
> done by suspend and release the remaining resources.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index c73e25f8995e..31d1dc5e9196 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -4465,15 +4465,13 @@ fec_drv_remove(struct platform_device *pdev)
>  	struct device_node *np = pdev->dev.of_node;
>  	int ret;
>  
> -	ret = pm_runtime_resume_and_get(&pdev->dev);
> -	if (ret < 0)
> -		return ret;
> +	ret = pm_runtime_get_sync(&pdev->dev);
>  
>  	cancel_work_sync(&fep->tx_timeout_work);
>  	fec_ptp_stop(pdev);
>  	unregister_netdev(ndev);
>  	fec_enet_mii_remove(fep);
> -	if (fep->reg_phy)
> +	if (ret >= 0 && fep->reg_phy)
>  		regulator_disable(fep->reg_phy);
>  
>  	if (of_phy_is_fixed_link(np))

I'm not sure this is correct. My experience with the FEC is that if
the device is run time suspended, access to the hardware does not
work. In the case i was debugging, MDIO bus reads/writes time out. I
think IO reads and writes turn into NOPs, but i don't actually know.

So if pm_runtime_resume_and_get() fails, fec_ptp_stop() probably does
not work if it touches the hardware. I guess fec_enet_mii_remove()
unregisters any PHYs, which could cause MDIO bus access to shut down
the PHYs, so i expect that also does not work. regulator_disable()
probably does actually work because that is a different hardware block
unaffected by the suspend.

So i think you need to decide:

exit immediately if resume fails, leaving dangling PHYs, netdev,
regulator etc

Keep going, but maybe everything is going to grind to a halt soon
afterwards when accessing the hardware.

You seem to prefer keep going, so i would also suggest you disable the
regulator.

	   Andrew
