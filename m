Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA3425EF5F
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 19:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgIFRlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 13:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgIFRlB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 13:41:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2768D20738;
        Sun,  6 Sep 2020 17:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599414060;
        bh=wiFSkXOZhd4fvpAjluo78Jahn8OI3hN0WKnTlqbxRLk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P9MGSpbEPvFHfiqXkIw9rjvV1JJFLxCGeZHkf35QtBuMEqpmIDccYbtd6dQEACMJh
         1IdAsGa6Y9uZiREghtCtxFdIyOQVQhhSAJ1zSh6vp3xl/8Jt8ddBAcNFVNy16nLgDZ
         0K31HYJ+7fRrLqn147jIs5ks6gnugPaLPDkhNDb4=
Date:   Sun, 6 Sep 2020 10:40:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [net-next PATCH] net: dsa: rtl8366: Properly clear member
 config
Message-ID: <20200906104058.1b0ac9bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905103233.16922-1-linus.walleij@linaro.org>
References: <20200905103233.16922-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Sep 2020 12:32:33 +0200 Linus Walleij wrote:
> When removing a port from a VLAN we are just erasing the
> member config for the VLAN, which is wrong: other ports
> can be using it.
> 
> Just mask off the port and only zero out the rest of the
> member config once ports using of the VLAN are removed
> from it.
> 
> Reported-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

I see you labeled this for net-net, but it reads like a fix, is it not?

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")

Like commit 15ab7906cc92 ("net: dsa: rtl8366: Fix VLAN semantics") had?

> diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
> index 2dcde7a91721..bd3c947976ce 100644
> --- a/drivers/net/dsa/rtl8366.c
> +++ b/drivers/net/dsa/rtl8366.c
> @@ -471,13 +471,19 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
>  				return ret;
>  
>  			if (vid == vlanmc.vid) {
> -				/* clear VLAN member configurations */
> -				vlanmc.vid = 0;
> -				vlanmc.priority = 0;
> -				vlanmc.member = 0;
> -				vlanmc.untag = 0;
> -				vlanmc.fid = 0;
> -
> +				/* Remove this port from the VLAN */
> +				vlanmc.member &= ~BIT(port);
> +				vlanmc.untag &= ~BIT(port);
> +				/*
> +				 * If no ports are members of this VLAN
> +				 * anymore then clear the whole member
> +				 * config so it can be reused.
> +				 */
> +				if (!vlanmc.member && vlanmc.untag) {
> +					vlanmc.vid = 0;
> +					vlanmc.priority = 0;
> +					vlanmc.fid = 0;
> +				}
>  				ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
>  				if (ret) {
>  					dev_err(smi->dev,

