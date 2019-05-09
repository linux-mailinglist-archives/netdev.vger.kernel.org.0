Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70E018C43
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 16:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfEIOst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 10:48:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59375 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbfEIOss (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 10:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g9oKO9v8KtJ8ZHNRk4PT2s6fzf1hENBxP0zZUoSVNiA=; b=Zpjy033qq1PtL60QmFeHCsSlTA
        Vkgmp+qTEuFftFi8muaqUQ6mfRkF6h4NLlq+Mm550WiVU5YfODJLobSpE4BTdWpNsSXieKG+T//EU
        gKGfL70T2b3Tk3BWF7Wd+3JMJXsnigTaiU0Y5CDKRtNKL/0GYrFu+OalBKvKuKg5hVM4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hOkLk-0002Pi-OC; Thu, 09 May 2019 16:48:44 +0200
Date:   Thu, 9 May 2019 16:48:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     Tristram.Ha@microchip.com, kernel@pengutronix.de,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [RFC 2/3] ksz: Add Microchip KSZ8873 SMI-DSA driver
Message-ID: <20190509144844.GM25013@lunn.ch>
References: <20190508211330.19328-1-m.grzeschik@pengutronix.de>
 <20190508211330.19328-3-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508211330.19328-3-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 11:13:29PM +0200, Michael Grzeschik wrote:
> Cc: Tristram.Ha@microchip.com
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/Kconfig       |   16 +
>  drivers/net/dsa/microchip/Makefile      |    2 +
>  drivers/net/dsa/microchip/ksz8863.c     | 1026 +++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz8863_reg.h |  605 +++++++++++++
>  drivers/net/dsa/microchip/ksz8863_smi.c |  105 +++
>  drivers/net/dsa/microchip/ksz_priv.h    |    3 +
>  include/net/dsa.h                       |    2 +
>  net/dsa/Kconfig                         |    7 +
>  net/dsa/tag_ksz.c                       |   45 +
>  9 files changed, 1811 insertions(+)
>  create mode 100644 drivers/net/dsa/microchip/ksz8863.c
>  create mode 100644 drivers/net/dsa/microchip/ksz8863_reg.h
>  create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c
> 
> diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
> index bea29fde9f3d1..a6fa6ae972951 100644
> --- a/drivers/net/dsa/microchip/Kconfig
> +++ b/drivers/net/dsa/microchip/Kconfig
> @@ -14,3 +14,19 @@ config NET_DSA_MICROCHIP_KSZ9477_SPI
>  	depends on NET_DSA_MICROCHIP_KSZ9477 && SPI
>  	help
>  	  Select to enable support for registering switches configured through SPI.
> +
> +menuconfig NET_DSA_MICROCHIP_KSZ8863
> +	tristate "Microchip KSZ8863 series switch support"
> +	depends on NET_DSA
> +	select NET_DSA_TAG_KSZ8863
> +	select NET_DSA_MICROCHIP_KSZ_COMMON
> +	help
> +	  This driver adds support for Microchip KSZ8863 switch chips.
> +
> +config NET_DSA_MICROCHIP_KSZ8863_SMI

> +	tristate "KSZ series SMI connected switch driver"
> +	depends on NET_DSA_MICROCHIP_KSZ8863
> +	default y
> +	help
> +	  Select to enable support for registering switches configured through SMI.

SMI is a synonym for MDIO. So we should make it clear, this is a
proprietary version. "... through Microchip SMI".

You might also want to either depend on or select mdio-bitbang, since
that is the other driver which supports Microchip SMI.

> +static int ksz_spi_read(struct ksz_device *dev, u32 reg, u8 *data,
> +			unsigned int len)
> +{
> +	int i = 0;
> +
> +	for (i = 0; i < len; i++)
> +		data[i] = (u8)mdiobus_read(dev->bus, 0,
> +					    (reg + i) | MII_ADDR_SMI0);

mdiobus_read() and mdiobus_write() can return an error, which is why
is returns an int. Please check for the error and return it.

> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 6aaaadd6a413c..57fbf3e722362 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -44,6 +44,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_TRAILER_VALUE		11
>  #define DSA_TAG_PROTO_8021Q_VALUE		12
>  #define DSA_TAG_PROTO_SJA1105_VALUE		13
> +#define DSA_TAG_PROTO_KSZ8863_VALUE		14
>  
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
> @@ -60,6 +61,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_TRAILER		= DSA_TAG_PROTO_TRAILER_VALUE,
>  	DSA_TAG_PROTO_8021Q		= DSA_TAG_PROTO_8021Q_VALUE,
>  	DSA_TAG_PROTO_SJA1105		= DSA_TAG_PROTO_SJA1105_VALUE,
> +	DSA_TAG_PROTO_KSZ8863		= DSA_TAG_PROTO_KSZ8863_VALUE,
>  };

Please put all the tag driver changes into a separate patch.

> +static struct sk_buff *ksz8863_rcv(struct sk_buff *skb, struct net_device *dev,
> +				   struct packet_type *pt)
> +{
> +	/* Tag decoding */
> +	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
> +	unsigned int port = tag[0] & 1;

Does this device only have 2 ports, 0 and 1?

> +	unsigned int len = KSZ_EGRESS_TAG_LEN;
> +
> +	return ksz_common_rcv(skb, dev, port, len);
> +}

  Andrew
