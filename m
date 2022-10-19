Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27090604749
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiJSNgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiJSNgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:36:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41601633B7;
        Wed, 19 Oct 2022 06:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 657CFB822EB;
        Wed, 19 Oct 2022 10:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6880AC433D7;
        Wed, 19 Oct 2022 10:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666176524;
        bh=tMTTTJ9UTpEIUqvDoKhUxrAxXFfoEapiMptwFaudCf0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MVbm+HXBTe9ZEm+Nqo/87qIY4BKuYC9+wfL8Oy8wcHSL8koe0iSmo+F1PhdbtVTVU
         nv5920Ow7FG8eR+pYlN46c4Gn5j1m+3Tw1dIAt/qiLHy48Ys6b2Bnui0KluWDjES4V
         bzsHeZ6o7CQ3hrH4iSpi2hmKhTbwSQ8ROvO8vDdwLJPxgAbOl4Ml/c0uuZE6b0547E
         4phB+IrkxyaHOJyy9cucFWJEUM9f4pgQjyITvGKYYDFgRYRbuyvINh5ftLoQpe13SC
         /Mf7QD5WIs6ow8PO+Dh0UY9rFlXAkNNS3eIrIU3PaVBSISU349Q/fYG0m7vkd56W+2
         x7pxmhB69Vd3Q==
Date:   Wed, 19 Oct 2022 12:48:39 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH RFC 2/3] net: phy: marvell10g: Add host interface speed
 configuration
Message-ID: <20221019124839.33ad3458@dellmb>
In-Reply-To: <20221019085052.933385-3-yoshihiro.shimoda.uh@renesas.com>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
        <20221019085052.933385-3-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 17:50:51 +0900
Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:

> Add support for selecting host speed mode. For now, only support
> 1000M bps.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/net/phy/marvell10g.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index 383a9c9f36e5..daf3242c6078 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -101,6 +101,10 @@ enum {
>  	MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS	= BIT(13),
>  	MV_AN_21X0_SERDES_CTRL2_RUN_INIT	= BIT(15),
>  
> +	MV_MOD_CONF		= 0xf000,
> +	MV_MOD_CONF_SPEED_MASK	= 0x00c0,
> +	MV_MOD_CONF_SPEED_1000	= BIT(7),
> +

Where did you get these values from? My documentation says:
  Mode Configuration
  Device 31, Register 0xF000
  Bits
  7:6   Reserved  R/W  0x3  This must always be 11.


>  	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
>  	 * registers appear to set themselves to the 0x800X when AN is
>  	 * restarted, but status registers appear readable from either.
> @@ -147,6 +151,7 @@ struct mv3310_chip {
>  	int (*get_mactype)(struct phy_device *phydev);
>  	int (*set_mactype)(struct phy_device *phydev, int mactype);
>  	int (*select_mactype)(unsigned long *interfaces);
> +	int (*set_macspeed)(struct phy_device *phydev, int macspeed);
>  	int (*init_interface)(struct phy_device *phydev, int mactype);
>  
>  #ifdef CONFIG_HWMON
> @@ -644,6 +649,16 @@ static int mv2110_select_mactype(unsigned long *interfaces)
>  		return -1;
>  }
>  
> +static int mv2110_set_macspeed(struct phy_device *phydev, int macspeed)
> +{
> +	if (macspeed != SPEED_1000)
> +		return -EOPNOTSUPP;
> +
> +	return phy_modify_mmd(phydev, MDIO_MMD_VEND2, MV_MOD_CONF,
> +			      MV_MOD_CONF_SPEED_MASK,
> +			      MV_MOD_CONF_SPEED_1000);
> +}

Why not also support other speeds, if we are doing this already?

Marek
