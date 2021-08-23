Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539D03F5373
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 00:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhHWWlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 18:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229760AbhHWWlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 18:41:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C508361374;
        Mon, 23 Aug 2021 22:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629758423;
        bh=+KspiuTfkt01eUbFcfRUJcQ8AXvpC5trfmoOL3nD/U0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CZFQjlMJvwFrgEPNR2uyRW2whoTCHhtbFTIbX/XtiSYlnz+A2FcQs9ce8hVJ6c8M/
         copCSlFSE2hrpFr6V30ic6wfLlLDEiPq6+atm5WFUlsoQFIiUHAfWQBKQrJFfaQWoI
         oy6fyXfakI/LOlkq2WfDQtZ8WJ+E/OU+0A7UC3Dm3TInaAjS94wpfpQmG+fkZjaiZk
         ZpXBwyHkKbqCrYwoUPFg3vQ4i+tuYgxkDRm8FLb0qO4M0cLttt/EqgD90TuVYcFLb0
         cYcwb7p0OhoAGrgFI6s14ixQpH5WqzNROOm9kDxJJrh/bZZ1fd8sZzB+dY7zLF41Nm
         mMJINKpom61SA==
Date:   Mon, 23 Aug 2021 15:40:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     John Efstathiades <john.efstathiades@pebblebay.com>,
        linux-usb@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 05/10] lan78xx: Disable USB3 link power state
 transitions
Message-ID: <20210823154022.490688a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210823135229.36581-6-john.efstathiades@pebblebay.com>
References: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
        <20210823135229.36581-6-john.efstathiades@pebblebay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Aug 2021 14:52:24 +0100 John Efstathiades wrote:
> Disable USB3 link power state transitions from U0 (Fully Powered) to
> U1 (Standby with Fast Recovery) or U2 (Standby with Slow Recovery).
> 
> The device can initiate U1 and U2 state transitions when there is no
> activity on the bus which can save power. However, testing with some
> USB3 hosts and hubs showed erratic ping response time due to the time
> required to transition back to U0 state.
> 
> In the following example the outgoing packets were delayed until the
> device transitioned from U2 back to U0 giving the misleading
> response time.
> 
> console:/data/local # ping 192.168.73.1
> PING 192.168.73.1 (192.168.73.1) 56(84) bytes of data.
> 64 bytes from 192.168.73.1: icmp_seq=1 ttl=64 time=466 ms
> 64 bytes from 192.168.73.1: icmp_seq=2 ttl=64 time=225 ms
> 64 bytes from 192.168.73.1: icmp_seq=3 ttl=64 time=155 ms
> 64 bytes from 192.168.73.1: icmp_seq=4 ttl=64 time=7.07 ms
> 64 bytes from 192.168.73.1: icmp_seq=5 ttl=64 time=141 ms
> 64 bytes from 192.168.73.1: icmp_seq=6 ttl=64 time=152 ms
> 64 bytes from 192.168.73.1: icmp_seq=7 ttl=64 time=51.9 ms
> 64 bytes from 192.168.73.1: icmp_seq=8 ttl=64 time=136 ms
> 
> The following shows the behaviour when the U1 and U2 transitions
> were disabled.
> 
> console:/data/local # ping 192.168.73.1
> PING 192.168.73.1 (192.168.73.1) 56(84) bytes of data.
> 64 bytes from 192.168.73.1: icmp_seq=1 ttl=64 time=6.66 ms
> 64 bytes from 192.168.73.1: icmp_seq=2 ttl=64 time=2.97 ms
> 64 bytes from 192.168.73.1: icmp_seq=3 ttl=64 time=2.02 ms
> 64 bytes from 192.168.73.1: icmp_seq=4 ttl=64 time=2.42 ms
> 64 bytes from 192.168.73.1: icmp_seq=5 ttl=64 time=2.47 ms
> 64 bytes from 192.168.73.1: icmp_seq=6 ttl=64 time=2.55 ms
> 64 bytes from 192.168.73.1: icmp_seq=7 ttl=64 time=2.43 ms
> 64 bytes from 192.168.73.1: icmp_seq=8 ttl=64 time=2.13 ms
> 
> Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
> ---
>  drivers/net/usb/lan78xx.c | 44 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> index 746aeeaa9d6e..3181753b1621 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -430,6 +430,12 @@ struct lan78xx_net {
>  #define	PHY_LAN8835			(0x0007C130)
>  #define	PHY_KSZ9031RNX			(0x00221620)
>  
> +/* Enabling link power state transitions will reduce power consumption
> + * when the link is idle. However, this can cause problems with some
> + * USB3 hubs resulting in erratic packet flow.
> + */
> +static bool enable_link_power_states;

How is the user supposed to control this? Are similar issues not
addressed at the USB layer? There used to be a "no autosuspend"
flag that all netdev drivers set.. 

Was linux-usb consulted? Adding the list to Cc.

>  /* use ethtool to change the level for any given device */
>  static int msg_level = -1;
>  module_param(msg_level, int, 0);
> @@ -1173,7 +1179,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
>  	/* clear LAN78xx interrupt status */
>  	ret = lan78xx_write_reg(dev, INT_STS, INT_STS_PHY_INT_);
>  	if (unlikely(ret < 0))
> -		return -EIO;
> +		return ret;
>  
>  	mutex_lock(&phydev->lock);
>  	phy_read_status(phydev);
> @@ -1186,11 +1192,11 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
>  		/* reset MAC */
>  		ret = lan78xx_read_reg(dev, MAC_CR, &buf);
>  		if (unlikely(ret < 0))
> -			return -EIO;
> +			return ret;
>  		buf |= MAC_CR_RST_;
>  		ret = lan78xx_write_reg(dev, MAC_CR, buf);
>  		if (unlikely(ret < 0))
> -			return -EIO;
> +			return ret;

Please split the ret code changes to a separate, earlier patch.

>  		del_timer(&dev->stat_monitor);
>  	} else if (link && !dev->link_on) {
