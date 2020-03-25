Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0FD2192EC3
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgCYQ4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:56:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:47590 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgCYQ4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 12:56:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4CA98AB76;
        Wed, 25 Mar 2020 16:56:43 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 04E12E0FD3; Wed, 25 Mar 2020 17:56:41 +0100 (CET)
Date:   Wed, 25 Mar 2020 17:56:41 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V2 08/14] net: ks8851: Use 16-bit writes to program MAC
 address
Message-ID: <20200325165640.GA31519@unicorn.suse.cz>
References: <20200325150543.78569-1-marex@denx.de>
 <20200325150543.78569-9-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325150543.78569-9-marex@denx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 04:05:37PM +0100, Marek Vasut wrote:
> On the SPI variant of KS8851, the MAC address can be programmed with
> either 8/16/32-bit writes. To make it easier to support the 16-bit
> parallel option of KS8851 too, switch both the MAC address programming
> and readout to 16-bit operations.
> 
> Remove ks8851_wrreg8() as it is not used anywhere anymore.
> 
> There should be no functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>
> ---
> V2: Get rid of the KS_MAR(i + 1) by adjusting KS_MAR(x) macro
> ---
[...]
> @@ -358,8 +329,12 @@ static int ks8851_write_mac_addr(struct net_device *dev)
>  	 * the first write to the MAC address does not take effect.
>  	 */
>  	ks8851_set_powermode(ks, PMECR_PM_NORMAL);
> -	for (i = 0; i < ETH_ALEN; i++)
> -		ks8851_wrreg8(ks, KS_MAR(i), dev->dev_addr[i]);
> +
> +	for (i = 0; i < ETH_ALEN; i += 2) {
> +		val = (dev->dev_addr[i] << 8) | dev->dev_addr[i + 1];
> +		ks8851_wrreg16(ks, KS_MAR(i), val);
> +	}
> +
>  	if (!netif_running(dev))
>  		ks8851_set_powermode(ks, PMECR_PM_SOFTDOWN);
>  
> @@ -377,12 +352,16 @@ static int ks8851_write_mac_addr(struct net_device *dev)
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
> +		reg = ks8851_rdreg16(ks, KS_MAR(i));
> +		dev->dev_addr[i] = reg & 0xff;
> +		dev->dev_addr[i + 1] = reg >> 8;
> +	}
>  
>  	mutex_unlock(&ks->lock);
>  }

It seems my question from v1 went unnoticed and the inconsistency still
seems to be there so let me ask again: when writing, you put addr[i]
into upper part of the 16-bit value and addr[i+1] into lower but when 
reading, you do the opposite. Is it correct?

Michal Kubecek
