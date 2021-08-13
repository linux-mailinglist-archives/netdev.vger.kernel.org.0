Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6D03EBEAF
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbhHMXZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235330AbhHMXZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 19:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79A3E60230;
        Fri, 13 Aug 2021 23:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628897080;
        bh=VNBCMbuXdLAiF1wcrCYDIMMMtxoYtb8j99FAxFhqMQc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YKD3pasHdkXskbpxrooVBA++dVkrO08X/WTciCt+/ztWye3aYNTqzUUOSj/nhCjZU
         6uKznyZ0iSkB/mhRMU5wLuEIHLrGi/CdKNMKX5NEE6QwWzlLl2j14+8YRUMn+1ME+7
         wAXsa+sYE+yBXjYXQCmWoh33Mador0oeQuQmOYcg9+zrARrJld5RUxse5TK8nzpxv6
         6D7LIg2aHNdjrD+v5pC+ulg3WTtwNepHTB6v9JKh+el3UMkMTDc/S7Eqa9uu3+JzUT
         2erRfQq+Sr9NjyL8cLJbe4ZcPdcUYLsgvj/7Ag7D648E5nMQzCuf47c3hD2KDy5baY
         cpynXsZOQhR/A==
Date:   Fri, 13 Aug 2021 16:24:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     netdev@vger.kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net: usb: pegasus: ignore the return value from
 set_registers();
Message-ID: <20210813162439.1779bf63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210812082351.37966-1-petko.manolov@konsulko.com>
References: <20210812082351.37966-1-petko.manolov@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 11:23:51 +0300 Petko Manolov wrote:
> The return value need to be either ignored or acted upon, otherwise 'deadstore'
> clang check would yell at us.  I think it's better to just ignore what this
> particular call of set_registers() returns.  The adapter defaults are sane and
> it would be operational even if the register write fail.
> 
> Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
> ---
>  drivers/net/usb/pegasus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index 652e9fcf0b77..49cfc720d78f 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -433,7 +433,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
>  	data[2] = loopback ? 0x09 : 0x01;
>  
>  	memcpy(pegasus->eth_regs, data, sizeof(data));
> -	ret = set_registers(pegasus, EthCtrl0, 3, data);
> +	set_registers(pegasus, EthCtrl0, 3, data);
>  
>  	if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS ||
>  	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||

This one is not added by the recent changes as I initially thought, 
the driver has always checked this return value. The recent changes 
did this:

        ret = set_registers(pegasus, EthCtrl0, 3, data);
 
        if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS ||
            usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
            usb_dev_id[pegasus->dev_index].vendor == VENDOR_DLINK) {
                u16 auxmode;
-               read_mii_word(pegasus, 0, 0x1b, &auxmode);
+               ret = read_mii_word(pegasus, 0, 0x1b, &auxmode);
+               if (ret < 0)
+                       goto fail;
                auxmode |= 4;
                write_mii_word(pegasus, 0, 0x1b, &auxmode);
        }
 
+       return 0;
+fail:
+       netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
        return ret;
}

now the return value of set_registeres() is ignored. 

Seems like  a better fix would be to bring back the error checking, 
why not?

Please remember to add a fixes tag.
