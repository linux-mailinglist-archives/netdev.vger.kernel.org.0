Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203A62C3440
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgKXWzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:55:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729123AbgKXWzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:55:01 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D58822076E;
        Tue, 24 Nov 2020 22:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606258500;
        bh=IytfiVfJkl3SGmgNvKbDzwZWlnDst5FWMGBqOJ7gclM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F5DWDk8Hw0avcrErVA2DTvBzZb2j3gkEDE0zIk+FkXJwSnQFLPRFMA0qJcaKl/2gb
         UsCGtg2oErYGyZkHB4bG0wFhAR7hSpD/lhW4+yAohrIbIPbWs0UkllMW/3G8BnBW2p
         szaqZyOlR/33imdMyhy5S8Gbn0Sx+5Cho1q66YsM=
Date:   Tue, 24 Nov 2020 14:54:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Rene van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH net-next] net: ethernet: mediatek: support setting MTU
Message-ID: <20201124145458.207d5cbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123034522.1268-1-dqfext@gmail.com>
References: <20201123034522.1268-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 11:45:22 +0800 DENG Qingfang wrote:
> MT762x HW, except for MT7628, supports frame length up to 2048
> (maximum length on GDM), so allow setting MTU up to 2030.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 6d2d60675ffd..27cae3f43972 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -353,7 +353,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
>  	/* Setup gmac */
>  	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
>  	mcr_new = mcr_cur;
> -	mcr_new |= MAC_MCR_MAX_RX_1536 | MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
> +	mcr_new |= MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |

This also changes the default MAX_RX from 1536 to 1518 (0).

I think you should at least mention this in the commit message.

>  		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
>  
>  	/* Only update control register when needed! */

> @@ -320,7 +320,12 @@
>  
>  /* Mac control registers */
>  #define MTK_MAC_MCR(x)		(0x10100 + (x * 0x100))
> -#define MAC_MCR_MAX_RX_1536	BIT(24)
> +#define MAC_MCR_MAX_RX_LEN_MASK	GENMASK(25, 24)
> +#define MAC_MCR_MAX_RX_LEN(_x)	(MAC_MCR_MAX_RX_LEN_MASK & ((_x) << 24))
> +#define MAC_MCR_MAX_RX_LEN_1518	0x0
> +#define MAC_MCR_MAX_RX_LEN_1536	0x1
> +#define MAC_MCR_MAX_RX_LEN_1552	0x2
> +#define MAC_MCR_MAX_RX_LEN_2048	0x3
>  #define MAC_MCR_IPG_CFG		(BIT(18) | BIT(16))
>  #define MAC_MCR_FORCE_MODE	BIT(15)
>  #define MAC_MCR_TX_EN		BIT(14)

