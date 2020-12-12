Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3252D88AD
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 18:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439255AbgLLRen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 12:34:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392965AbgLLRem (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 12:34:42 -0500
Date:   Sat, 12 Dec 2020 09:34:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607794442;
        bh=s22lqFRbBa65jJaAjvTu8tN3w73WuV7MZDeePGuYqro=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=JEORhnkXeDnyqaStPv3PEXlIdkWzEH4gDXJPpfRAZM+adf7cbXaUeZz8n9Zyxc5ml
         5VSns66qRzDv4H4aRgsLlLTUHosjnpD0kGEJHQyV906vMVtnfVvcgb+W7TOTG4LRrv
         NN5Szc6zzo8LZeEpdujYE+k0Hb++ohiPikOUA5JjQwlgLNq6Q6cQFKzTpFC/MmZIIL
         AFQJrFBgBHEP7Iu/IOrTcnEC7GqDp7pSD/KjZtdYv8b2uW/tXcE97srJAY+iD966zz
         q6smDDwH5MRUYubFUFlbPr+waApJwsg28/27cQcqZeyA90+PdGCaZLlzwNl2vjvYV1
         /YNLhsj2fVaHw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v5 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201212093401.07b0e528@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211105322.7818-3-o.rempel@pengutronix.de>
References: <20201211105322.7818-1-o.rempel@pengutronix.de>
        <20201211105322.7818-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 11:53:22 +0100 Oleksij Rempel wrote:
> Add stats support for the ar9331 switch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/qca/ar9331.c | 256 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 255 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> index 4d49c5f2b790..5baef0ec6410 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -101,6 +101,9 @@
>  	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
>  	 AR9331_SW_PORT_STATUS_SPEED_M)
>  
> +/* MIB registers */
> +#define AR9331_MIB_COUNTER(x)			(0x20000 + ((x) * 0x100))
> +
>  /* Phy bypass mode
>   * ------------------------------------------------------------------------
>   * Bit:   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |13 |14 |15 |
> @@ -154,6 +157,111 @@
>  #define AR9331_SW_MDIO_POLL_SLEEP_US		1
>  #define AR9331_SW_MDIO_POLL_TIMEOUT_US		20
>  
> +/* The interval should be small enough to avoid overflow of 32bit MIBs */
> +/*
> + * FIXME: as long as we can't read MIBs from stats64 call directly, we should
> + * poll stats more frequently then it is actually needed. In normal case
> + * 100 sec interval should be OK.

This comment is a little confusing, if you don't mind.

Should it says something like:

 FIXME: until we can read MIBs from stats64 call directly (i.e. sleep
 there), we have to poll stats more frequently then it is actually needed.
 For overflow protection, normally, 100 sec interval should have been OK.

