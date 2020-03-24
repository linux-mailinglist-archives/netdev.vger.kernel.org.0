Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A799919073E
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 09:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgCXINO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 04:13:14 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:59075 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbgCXINN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 04:13:13 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 9557B30001EA0;
        Tue, 24 Mar 2020 09:13:11 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 668A4109E4C; Tue, 24 Mar 2020 09:13:11 +0100 (CET)
Date:   Tue, 24 Mar 2020 09:13:11 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 07/14] net: ks8851: Use 16-bit writes to program MAC
 address
Message-ID: <20200324081311.ww6p7dmijbddi5jm@wunner.de>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-8-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-8-marex@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:42:56AM +0100, Marek Vasut wrote:
> On the SPI variant of KS8851, the MAC address can be programmed with
> either 8/16/32-bit writes. To make it easier to support the 16-bit
> parallel option of KS8851 too, switch both the MAC address programming
> and readout to 16-bit operations.
[...]
>  static int ks8851_write_mac_addr(struct net_device *dev)
>  {
>  	struct ks8851_net *ks = netdev_priv(dev);
> +	u16 val;
>  	int i;
>  
>  	mutex_lock(&ks->lock);
> @@ -358,8 +329,12 @@ static int ks8851_write_mac_addr(struct net_device *dev)
>  	 * the first write to the MAC address does not take effect.
>  	 */
>  	ks8851_set_powermode(ks, PMECR_PM_NORMAL);
> -	for (i = 0; i < ETH_ALEN; i++)
> -		ks8851_wrreg8(ks, KS_MAR(i), dev->dev_addr[i]);
> +
> +	for (i = 0; i < ETH_ALEN; i += 2) {
> +		val = (dev->dev_addr[i] << 8) | dev->dev_addr[i + 1];
> +		ks8851_wrreg16(ks, KS_MAR(i + 1), val);
> +	}
> +

This looks like it won't work on little-endian machines:  The MAC bytes
are stored in dev->dev_addr as 012345, but in the EEPROM they're stored
as 543210.  The first 16-bit value that you write is 10 on big-endian
and 01 on little-endian if I'm not mistaken.

By only writing 8-bit values, the original author elegantly sidestepped
this issue.

Maybe the simplest and most readable solution is something like:

      u8 val[2];
      ...
      val[0] = dev->dev_addr[i+1];
      val[1] = dev->dev_addr;

Then cast val to a u16 when passing it to ks8851_wrreg16().

Alternatively, use cpu_to_be16().


>  static void ks8851_read_mac_addr(struct net_device *dev)
>  {
>  	struct ks8851_net *ks = netdev_priv(dev);
> +	u16 reg;
>  	int i;
>  
>  	mutex_lock(&ks->lock);
>  
> -	for (i = 0; i < ETH_ALEN; i++)
> -		dev->dev_addr[i] = ks8851_rdreg8(ks, KS_MAR(i));
> +	for (i = 0; i < ETH_ALEN; i += 2) {
> +		reg = ks8851_rdreg16(ks, KS_MAR(i + 1));
> +		dev->dev_addr[i] = reg & 0xff;
> +		dev->dev_addr[i + 1] = reg >> 8;
> +	}

Same here.

These seem to be the only two places where KS_MAR() is used.
You may want to adjust that macro so that you don't have to add 1
in each of the two places.

Thanks,

Lukas
