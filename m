Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDF33B084F
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhFVPMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:12:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49998 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhFVPMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 11:12:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/cGKfwVs1AmkgHe9Fl88oQ/GeDYG3RYVpN22bq5U/V8=; b=Iix64bOHSz0g0jbtXcJ4tAlTgt
        hf95fWoFBX3iETYrtYVMPzWxY38SiGQLaxtP5WSD5wfc/CY27h+waXwR/Kv6pR55H6E08wDZ+6kq8
        qkToSlqW3q0dVyXfucViU1vGIbt0lge222EblY1b+DdsJlGJrxa4rT4UgiFLkkVNRtCo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lvi2k-00AicR-Hu; Tue, 22 Jun 2021 17:10:26 +0200
Date:   Tue, 22 Jun 2021 17:10:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] net: imx: Adjust fec_main.c to provide support for L2
 switch
Message-ID: <YNH9YvjqbcHMaUFw@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
 <20210622144111.19647-4-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622144111.19647-4-lukma@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> index 0602d5d5d2ee..dc2d31321cbd 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -29,6 +29,10 @@
>   */
>  #define FEC_IEVENT		0x004 /* Interrupt event reg */
>  #define FEC_IMASK		0x008 /* Interrupt mask reg */
> +#ifdef CONFIG_FEC_MTIP_L2SW
> +#define FEC_MTIP_R_DES_ACTIVE_0	0x018 /* L2 switch Receive descriptor reg */
> +#define FEC_MTIP_X_DES_ACTIVE_0	0x01C /* L2 switch Transmit descriptor reg */
> +#endif

Please don't scatter #ifdef everywhere.

In this case, the register exists, even if the switch it not being
used, so there is no need to have it conditional.

>  #include <asm/cacheflush.h>
>  
>  #include "fec.h"
> +#ifdef CONFIG_FEC_MTIP_L2SW
> +#include "./mtipsw/fec_mtip.h"
> +#endif

Why not just include it all the time?

    Andrew
