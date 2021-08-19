Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD64D3F20AD
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 21:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhHSTfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 15:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhHSTfH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 15:35:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69C13610CE;
        Thu, 19 Aug 2021 19:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629401670;
        bh=kCR9lxE8SwNUif9UW3AA+8EckMuvwOir57wIny57viA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i6no+QxdL3LQNOoNPYYNlkG9Dg4IFPPU6GYziQvm8ClnrArmc5glsZ8PTRXkTHUY8
         +UFAf/MmddLjbFmGtBP+EVBgQgzzrs9cEaU/cZVur3K4U61j7jMFKrk+3fhe6BrXGi
         xqo/6tYqR9sspFXxBI34RnKB6xIzf28xoaLEpJOpIt9il1TBRCAAfwaSo+zdqNqHZL
         4FsOUgCgIxyLIp6w8pe+204FTgvHDtaiEKqpKrhxg+ZTftHWcXMNhy04L9HeA3sYkc
         pMDvCN3oKpojovBxROSDDitKBtjf4wM3btsWRnpXjSR29u2qFL3ijEfQFsExqzdnaq
         T42Z9ZaVDqBBA==
Date:   Thu, 19 Aug 2021 12:34:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: fixes of set_register(s) return
 value evaluation;
Message-ID: <20210819123429.7b15f08e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210819090539.15879-1-petko.manolov@konsulko.com>
References: <20210819090539.15879-1-petko.manolov@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Aug 2021 12:05:39 +0300 Petko Manolov wrote:
>   - restore the behavior in enable_net_traffic() to avoid regressions - Jakub
>     Kicinski;
>   - hurried up and removed redundant assignment in pegasus_open() before yet
>     another checker complains;
>   - explicitly check for negative value in pegasus_set_wol(), even if
>     usb_control_msg_send() never return positive number we'd still be in sync
>     with the rest of the driver style;
> 
> Fixes: 8a160e2e9aeb net: usb: pegasus: Check the return value of get_geristers() and friends;

I guess this is fine but not exactly the preferred format, please see
Submitting patches.

> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
> ---
>  drivers/net/usb/pegasus.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index 652e9fcf0b77..1ef93082c772 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -446,7 +446,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
>  		write_mii_word(pegasus, 0, 0x1b, &auxmode);
>  	}
>  
> -	return 0;
> +	return ret;

yup

>  fail:
>  	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
>  	return ret;
> @@ -835,7 +835,7 @@ static int pegasus_open(struct net_device *net)
>  	if (!pegasus->rx_skb)
>  		goto exit;
>  
> -	res = set_registers(pegasus, EthID, 6, net->dev_addr);
> +	set_registers(pegasus, EthID, 6, net->dev_addr);

yup

>  	usb_fill_bulk_urb(pegasus->rx_urb, pegasus->usb,
>  			  usb_rcvbulkpipe(pegasus->usb, 1),
> @@ -932,7 +932,7 @@ pegasus_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
>  	pegasus->wolopts = wol->wolopts;
>  
>  	ret = set_register(pegasus, WakeupControl, reg78);
> -	if (!ret)
> +	if (ret < 0)
>  		ret = device_set_wakeup_enable(&pegasus->usb->dev,
>  						wol->wolopts);

now this looks incorrect and unrelated to recent changes (IOW the
commit under Fixes), please drop this chunk

>  	return ret;

