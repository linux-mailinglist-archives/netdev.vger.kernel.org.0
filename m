Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298262A11D2
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgJaADy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgJaADy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:03:54 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8869208B6;
        Sat, 31 Oct 2020 00:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604102634;
        bh=PbVVoVvejXa460x/ZPQ/oOxhItOiWuGafM8frIDYoYM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=koyDXXVgUnKVNmMxqGuo13izCEG7lHoEfYB3vFtA8oirpNX4axg6U/SrvQ/bgC+VQ
         YfFmqFLRcY2n6hy8MfJxAgtxvNH1QEadHAJozou2I6DbPUtEgIzDPIGnM+kQf/1Uxg
         6NRhh4ZVw/ipIKZCHb29Z+yCNqYoaK8paosOMnd0=
Date:   Fri, 30 Oct 2020 17:03:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix for potential NULL pointer dereference with bare
 lan743x
Message-ID: <20201030165515.614637a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029002845.28984-1-sbauer@blackbox.su>
References: <20201029002845.28984-1-sbauer@blackbox.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 03:28:45 +0300 Sergej Bauer wrote:
>   This is just a minor fix which prevents a kernel NULL pointer
> dereference when using phy-less lan743x.
> 
> Signed-off-by: Sergej Bauer <sbauer@blackbox.su>

I take you mean when the device is down netdev->phydev will be NULL?

> diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
> index dcde496da7fb..354d72d550f2 100644
> --- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
> +++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
> @@ -793,6 +795,9 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
>  {
>  	struct lan743x_adapter *adapter = netdev_priv(netdev);
>  
> +	if (!netdev->phydev)
> +		return -EIO;

Does it make sense to just skip the phy_ethtool_set_wol() call instead?

Also doesn't the wol configuration of the PHY get lost across an
netdev up/down cycle in this driver? Should it be re-applied after phy
is connected back?

>  	adapter->wolopts = 0;
>  	if (wol->wolopts & WAKE_UCAST)
>  		adapter->wolopts |= WAKE_UCAST;

