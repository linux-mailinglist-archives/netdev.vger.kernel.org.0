Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EFD588CE4
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 15:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbiHCNYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 09:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235611AbiHCNYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 09:24:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E444863E6
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 06:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=bMFu1P9fuz4TyxB+vsmfmGwW72ICb+20y6jSLI4mkVg=; b=qj
        Ca9CIGPuOlaPVBcuPDiv6G1Nh49wyfIn3C+KIfA0j+bK6J7VxCh8O4ZqQqfXTZUTr2SzgP7c+7WAk
        OHVhcmFFPbLMlMcjlhXvW8ePyeAIIW4C0lFHJfENDoLB0C9GmlloXB0s6LriAR+IvyFN3Z+GYPUGP
        rnyfiZAEjZYGg8M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oJELx-00CLIA-Av; Wed, 03 Aug 2022 15:24:01 +0200
Date:   Wed, 3 Aug 2022 15:24:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] fec: Allow changing the PPS channel
Message-ID: <Yup28SWBze9i5TWV@lunn.ch>
References: <20220803112449.37309-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220803112449.37309-1-csokas.bence@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 01:24:49PM +0200, Csókás Bence wrote:
> Makes the PPS channel configurable via the Device Tree (on startup) and sysfs (run-time)
> 
> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>

Please also Cc: the PTP Maintainer for patches which touch PTP code:

Richard Cochran <richardcochran@gmail.com>

	Andrew


> ---
>  drivers/net/ethernet/freescale/fec_main.c | 37 +++++++++++++++++++++++
>  drivers/net/ethernet/freescale/fec_ptp.c  |  3 --
>  2 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 2c3266be20e9..7482f26cd2c7 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -47,6 +47,7 @@
>  #include <linux/bitops.h>
>  #include <linux/io.h>
>  #include <linux/irq.h>
> +#include <linux/kobject.h>
>  #include <linux/clk.h>
>  #include <linux/crc32.h>
>  #include <linux/platform_device.h>
> @@ -3591,6 +3592,36 @@ static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
>  	return ret;
>  }
>  
> +static ssize_t pps_ch_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct net_device *ndev = to_net_dev(dev);
> +	struct fec_enet_private *fep = netdev_priv(ndev);
> +
> +	return sprintf(buf, "%d", fep->pps_channel);
> +}
> +
> +static ssize_t pps_ch_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct net_device *ndev = to_net_dev(dev);
> +	struct fec_enet_private *fep = netdev_priv(ndev);
> +	int enable = fep->pps_enable;
> +	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
> +
> +	if (enable)
> +		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 0);
> +
> +	kstrtoint(buf, 0, &fep->pps_channel);
> +
> +	if (enable)
> +		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);
> +
> +	return count;
> +}
> +
> +struct kobj_attribute pps_ch_attr = __ATTR(pps_channel, 0660, pps_ch_show, pps_ch_store);
> +
>  static int
>  fec_probe(struct platform_device *pdev)
>  {
> @@ -3687,6 +3718,9 @@ fec_probe(struct platform_device *pdev)
>  		fep->phy_interface = interface;
>  	}
>  
> +	if (of_property_read_u32(np, "fsl,pps-channel", &fep->pps_channel))
> +		fep->pps_channel = 0;
> +
>  	fep->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
>  	if (IS_ERR(fep->clk_ipg)) {
>  		ret = PTR_ERR(fep->clk_ipg);
> @@ -3799,6 +3833,9 @@ fec_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto failed_register;
>  
> +	if (sysfs_create_file(&ndev->dev.kobj, &pps_ch_attr.attr))
> +		pr_err("Cannot create pps_channel sysfs file\n");
> +
>  	device_init_wakeup(&ndev->dev, fep->wol_flag &
>  			   FEC_WOL_HAS_MAGIC_PACKET);
>  
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
> index 69dfed4de4ef..a5077eff305b 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -86,8 +86,6 @@
>  #define FEC_CC_MULT	(1 << 31)
>  #define FEC_COUNTER_PERIOD	(1 << 31)
>  #define PPS_OUPUT_RELOAD_PERIOD	NSEC_PER_SEC
> -#define FEC_CHANNLE_0		0
> -#define DEFAULT_PPS_CHANNEL	FEC_CHANNLE_0
>  
>  /**
>   * fec_ptp_enable_pps
> @@ -112,7 +110,6 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
>  	if (fep->pps_enable == enable)
>  		return 0;
>  
> -	fep->pps_channel = DEFAULT_PPS_CHANNEL;
>  	fep->reload_period = PPS_OUPUT_RELOAD_PERIOD;
>  
>  	spin_lock_irqsave(&fep->tmreg_lock, flags);
> -- 
> 2.25.1
> 
