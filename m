Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42AEA187543
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 23:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732739AbgCPWBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 18:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732709AbgCPWBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 18:01:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3471920674;
        Mon, 16 Mar 2020 22:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584396078;
        bh=WOYEbIKJduAOqdRCLw9h/VGF5Ekb2XM8iv++w5tWCEw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tj5GGZKfeNYHClhqr3TfBjeDRYHvTl3Eog4U4W/SSQ9/YpC7B2yuK7mTEOGSOVZvN
         t2wvxXHrMBLuZwoQFSEuxmPOC8wM5Ok8m3XUBT4OD/JXvH/6nrfm6xStDHKNEQs/Hz
         xI/Nzrgigq+qwwQt+WhZmsbLt5mEytWsjemyFHUY=
Date:   Mon, 16 Mar 2020 15:01:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v2 net-next 4/5] ionic: return error for unknown xcvr
 type
Message-ID: <20200316150116.330e4d94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200316193134.56820-5-snelson@pensando.io>
References: <20200316193134.56820-1-snelson@pensando.io>
        <20200316193134.56820-5-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 12:31:33 -0700 Shannon Nelson wrote:
> If we don't recognize the transceiver type, return an error
> so that ethtool doesn't try dumping bogus eeprom contents.
> 
> Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> index a233716eac29..3f92f301a020 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> @@ -694,7 +694,7 @@ static int ionic_get_module_info(struct net_device *netdev,
>  	default:
>  		netdev_info(netdev, "unknown xcvr type 0x%02x\n",
>  			    xcvr->sprom[0]);
> -		break;
> +		return -EINVAL;
>  	}
>  
>  	return 0;
> @@ -714,7 +714,19 @@ static int ionic_get_module_eeprom(struct net_device *netdev,
>  	/* The NIC keeps the module prom up-to-date in the DMA space
>  	 * so we can simply copy the module bytes into the data buffer.
>  	 */
> +
>  	xcvr = &idev->port_info->status.xcvr;
> +	switch (xcvr->sprom[0]) {
> +	case 0x03: /* SFP */
> +	case 0x0D: /* QSFP */
> +	case 0x11: /* QSFP28 */

Please use defines from sfp.h

> +		break;
> +	default:
> +		netdev_info(netdev, "unknown xcvr type 0x%02x\n",
> +			    xcvr->sprom[0]);
> +		return -EINVAL;

Isn't there _some_ amount of eeprom that we could always return?

> +	}
> +
>  	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
>  
>  	do {

The pluggable module eeprom stuff really calls for some common infra :(
