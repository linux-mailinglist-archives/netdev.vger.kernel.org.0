Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B028D4313D9
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhJRJzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:55:16 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:59971 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhJRJzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 05:55:16 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4HXscv5WKtz9sSg;
        Mon, 18 Oct 2021 11:53:03 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LESyFixcvpD4; Mon, 18 Oct 2021 11:53:03 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4HXscv4PWYz9sSY;
        Mon, 18 Oct 2021 11:53:03 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 7C9F68B76C;
        Mon, 18 Oct 2021 11:53:03 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id u1kTA27T2vek; Mon, 18 Oct 2021 11:53:03 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 491818B763;
        Mon, 18 Oct 2021 11:53:03 +0200 (CEST)
Subject: Re: [PATCH net-next] phy: micrel: ksz8041nl: do not use power down
 mode
To:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        f.fainelli@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Stefan Agner <stefan@agner.ch>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211018094256.70096-1-francesco.dolcini@toradex.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <180289ac-4480-1e4c-d679-df4f0478ec65@csgroup.eu>
Date:   Mon, 18 Oct 2021 11:53:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211018094256.70096-1-francesco.dolcini@toradex.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 18/10/2021 à 11:42, Francesco Dolcini a écrit :
> From: Stefan Agner <stefan@agner.ch>
> 
> Some Micrel KSZ8041NL PHY chips exhibit continous RX errors after using
> the power down mode bit (0.11). If the PHY is taken out of power down
> mode in a certain temperature range, the PHY enters a weird state which
> leads to continously reporting RX errors. In that state, the MAC is not
> able to receive or send any Ethernet frames and the activity LED is
> constantly blinking. Since Linux is using the suspend callback when the
> interface is taken down, ending up in that state can easily happen
> during a normal startup.
> 
> Micrel confirmed the issue in errata DS80000700A [*], caused by abnormal
> clock recovery when using power down mode. Even the latest revision (A4,
> Revision ID 0x1513) seems to suffer that problem, and according to the
> errata is not going to be fixed.
> 
> Remove the suspend/resume callback to avoid using the power down mode
> completely.

As far as I can see in the ERRATA, KSZ8041 RNLI also has the bug.
Shoudn't you also remove the suspend/resume on that one (which follows 
in ksphy_driver[])

Christophe

> 
> [*] https://ww1.microchip.com/downloads/en/DeviceDoc/80000700A.pdf
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Acked-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> ---
> There was a previous attempt to merge a similar patch, see
> https://lore.kernel.org/all/2ee9441d-1b3b-de6d-691d-b615c04c69d0@gmail.com/.
> ---
>   drivers/net/phy/micrel.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index ff452669130a..1f28d5fae677 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1676,8 +1676,6 @@ static struct phy_driver ksphy_driver[] = {
>   	.get_sset_count = kszphy_get_sset_count,
>   	.get_strings	= kszphy_get_strings,
>   	.get_stats	= kszphy_get_stats,
> -	.suspend	= genphy_suspend,
> -	.resume		= genphy_resume,
>   }, {
>   	.phy_id		= PHY_ID_KSZ8041RNLI,
>   	.phy_id_mask	= MICREL_PHY_ID_MASK,
> 
