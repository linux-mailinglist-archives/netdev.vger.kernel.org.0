Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1771C50904A
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 21:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381739AbiDTTWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 15:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381730AbiDTTWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 15:22:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB77633E
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 12:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vW3RG1su70VGbBTXUCkx774OaUga4Ryg4E4D2jIH/CQ=; b=vjlpIvcx+1IfqFvHg7UHQPM2rV
        5zb0/Y1NKWBm/l1fJ087Pv6WLNspulo0VGUBzpDohBi+LfT8kha15RlY2VNLKaJxYhuybJba1ZIWs
        +5pgRO16UNLspfB65Hg6fymsKgI1Lxs/GFmMCeZmwD1sSpKo778NrBvIgi58sjB9yDVg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhFrk-00GhMN-JG; Wed, 20 Apr 2022 21:19:52 +0200
Date:   Wed, 20 Apr 2022 21:19:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lasse Johnsen <lasse@timebeat.app>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>
Subject: Re: Support for IEEE1588 timestamping in the BCM54210PE PHY using
 the kernel mii_timestamper interface
Message-ID: <YmBc2E2eCPHMA7lR@lunn.ch>
References: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 03:03:26PM +0100, Lasse Johnsen wrote:
> Hello,
> 
> 
> The attached set of patches adds support for the IEEE1588 functionality on the BCM54210PE PHY using the Linux Kernel mii_timestamper interface. The BCM54210PE PHY can be found in the Raspberry PI Compute Module 4 and the work has been undertaken by Timebeat.app on behalf of Raspberry PI with help and support from the nice engineers at Broadcom.

Hi Lasse

There are a few process issues you should address.

Please wrap your email at about 80 characters.

Please take a read of

https://www.kernel.org/doc/html/latest/process/submitting-patches.html

and

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#netdev-faq

It is a bit of a learning curve getting patches accepted, and you have
to follow the processes defined in these documents.

>  arch/arm/configs/bcm2711_defconfig            |    1 +
>  arch/arm64/configs/bcm2711_defconfig          |    1 +

You will need to split these changes up. defconfg changes go via the
Broadcom maintainers. PHY driver changes go via netdev. You can
initially post them as a series, but in the end you might need to send
them to different people/lists.

> +obj-$(CONFIG_BCM54120PE_PHY)	+= bcm54210pe_ptp.o

How specific is this code to the bcm54210pe? Should it work for any
bcm54xxx PHY? You might want to name this file broadcom_ptp.c if it
will work with any PHY supported by broadcom.c.

> +static bool bcm54210pe_fetch_timestamp(u8 txrx, u8 message_type, u16 seq_id, struct bcm54210pe_private *private, u64 *timestamp)
> +{
> +	struct bcm54210pe_circular_buffer_item *item; 
> +	struct list_head *this, *next;
> +
> +	u8 index = (txrx * 4) + message_type;
> +
> +	if(index >= CIRCULAR_BUFFER_COUNT)
> +	{
> +		return false;
> +	}

Please run your code through ./scripts/checkpatch.pl. You will find
the code has a number of code style issues which need cleaning up.

> +#if IS_ENABLED (CONFIG_BCM54120PE_PHY)
> +{
> +	.phy_id		= PHY_ID_BCM54213PE,
> +	.phy_id_mask	= 0xffffffff,
> +        .name           = "Broadcom BCM54210PE",
> +        /* PHY_GBIT_FEATURES */
> +        .config_init    = bcm54xx_config_init,
> +        .ack_interrupt  = bcm_phy_ack_intr,
> +        .config_intr    = bcm_phy_config_intr,
> +	.probe		= bcm54210pe_probe,
> +#elif
> +{ 
>  	.phy_id		= PHY_ID_BCM54213PE,
>  	.phy_id_mask	= 0xffffffff,
>  	.name		= "Broadcom BCM54213PE",
> @@ -786,6 +804,7 @@ static struct phy_driver broadcom_drivers[] = {
>  	.config_init	= bcm54xx_config_init,
>  	.ack_interrupt	= bcm_phy_ack_intr,
>  	.config_intr	= bcm_phy_config_intr,
> +#endif

Don't replace the existing entry, extend it with your new
functionality.

	Andrew
