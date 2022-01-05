Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F3C48542C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240601AbiAEOPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237013AbiAEOPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:15:49 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4CEC061761
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:15:49 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1n574n-0001Kb-1G; Wed, 05 Jan 2022 15:15:41 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1n574h-0007uo-SA; Wed, 05 Jan 2022 15:15:35 +0100
Date:   Wed, 5 Jan 2022 15:15:35 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, oneukum@suse.com, robert.foss@collabora.com,
        freddy@asix.com.tw, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
Subject: Re: [PATCH RFT] net: asix: add proper error handling of usb read
 errors
Message-ID: <20220105141535.GI303@pengutronix.de>
References: <20220105131952.15693-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220105131952.15693-1-paskripkin@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:15:04 up 25 days, 23:00, 79 users,  load average: 1.10, 1.15,
 1.20
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 04:19:52PM +0300, Pavel Skripkin wrote:
> Syzbot once again hit uninit value in asix driver. The problem still the
> same -- asix_read_cmd() reads less bytes, than was requested by caller.
> 
> Since all read requests are performed via asix_read_cmd() let's catch
> usb related error there and add __must_check notation to be sure all
> callers actually check return value.
> 
> So, this patch adds sanity check inside asix_read_cmd(), that simply
> checks if bytes read are not less, than was requested and adds missing
> error handling of asix_read_cmd() all across the driver code.
> 
> Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
> Reported-and-tested-by: syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
>  drivers/net/usb/asix.h         |  4 ++--
>  drivers/net/usb/asix_common.c  | 19 +++++++++++++------
>  drivers/net/usb/asix_devices.c | 21 ++++++++++++++++++---
>  3 files changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
> index 2a1e31defe71..4334aafab59a 100644
> --- a/drivers/net/usb/asix.h
> +++ b/drivers/net/usb/asix.h
> @@ -192,8 +192,8 @@ extern const struct driver_info ax88172a_info;
>  /* ASIX specific flags */
>  #define FLAG_EEPROM_MAC		(1UL << 0)  /* init device MAC from eeprom */
>  
> -int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> -		  u16 size, void *data, int in_pm);
> +int __must_check asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> +			       u16 size, void *data, int in_pm);
>  
>  int asix_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
>  		   u16 size, void *data, int in_pm);
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index 71682970be58..524805285019 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -11,8 +11,8 @@
>  
>  #define AX_HOST_EN_RETRIES	30
>  
> -int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> -		  u16 size, void *data, int in_pm)
> +int __must_check asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> +			       u16 size, void *data, int in_pm)
>  {
>  	int ret;
>  	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
> @@ -27,9 +27,12 @@ int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
>  	ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>  		 value, index, data, size);
>  
> -	if (unlikely(ret < 0))
> +	if (unlikely(ret < size)) {
> +		ret = ret < 0 ? ret : -ENODATA;
> +
>  		netdev_warn(dev->net, "Failed to read reg index 0x%04x: %d\n",
>  			    index, ret);
> +	}
>  
>  	return ret;
>  }
> @@ -79,7 +82,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
>  				    0, 0, 1, &smsr, in_pm);
>  		if (ret == -ENODEV)
>  			break;
> -		else if (ret < sizeof(smsr))
> +		else if (ret < 0)
>  			continue;
>  		else if (smsr & AX_HOST_EN)
>  			break;
> @@ -579,8 +582,12 @@ int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc)
>  		return ret;
>  	}
>  
> -	asix_read_cmd(dev, AX_CMD_READ_MII_REG, phy_id,
> -		      (__u16)loc, 2, &res, 1);
> +	ret = asix_read_cmd(dev, AX_CMD_READ_MII_REG, phy_id,
> +			    (__u16)loc, 2, &res, 1);
> +	if (ret < 0) {
> +		mutex_unlock(&dev->phy_mutex);
> +		return ret;
> +	}
>  	asix_set_hw_mii(dev, 1);
>  	mutex_unlock(&dev->phy_mutex);
>  
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 4514d35ef4c4..6b2fbdf4e0fd 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -755,7 +755,12 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
>  	priv->phy_addr = ret;
>  	priv->embd_phy = ((priv->phy_addr & 0x1f) == 0x10);
>  
> -	asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode, 0);
> +	ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode, 0);
> +	if (ret < 0) {
> +		netdev_dbg(dev->net, "Failed to read STATMNGSTS_REG: %d\n", ret);
> +		return ret;
> +	}
> +
>  	chipcode &= AX_CHIPCODE_MASK;
>  
>  	ret = (chipcode == AX_AX88772_CHIPCODE) ? ax88772_hw_reset(dev, 0) :
> @@ -920,11 +925,21 @@ static int ax88178_reset(struct usbnet *dev)
>  	int gpio0 = 0;
>  	u32 phyid;
>  
> -	asix_read_cmd(dev, AX_CMD_READ_GPIOS, 0, 0, 1, &status, 0);
> +	ret = asix_read_cmd(dev, AX_CMD_READ_GPIOS, 0, 0, 1, &status, 0);
> +	if (ret < 0) {
> +		netdev_dbg(dev->net, "Failed to read GPIOS: %d\n", ret);
> +		return ret;
> +	}
> +
>  	netdev_dbg(dev->net, "GPIO Status: 0x%04x\n", status);
>  
>  	asix_write_cmd(dev, AX_CMD_WRITE_ENABLE, 0, 0, 0, NULL, 0);
> -	asix_read_cmd(dev, AX_CMD_READ_EEPROM, 0x0017, 0, 2, &eeprom, 0);
> +	ret = asix_read_cmd(dev, AX_CMD_READ_EEPROM, 0x0017, 0, 2, &eeprom, 0);
> +	if (ret < 0) {
> +		netdev_dbg(dev->net, "Failed to read EEPROM: %d\n", ret);
> +		return ret;
> +	}
> +
>  	asix_write_cmd(dev, AX_CMD_WRITE_DISABLE, 0, 0, 0, NULL, 0);
>  
>  	netdev_dbg(dev->net, "EEPROM index 0x17 is 0x%04x\n", eeprom);
> -- 
> 2.34.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
