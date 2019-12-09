Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE48117293
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfLIRPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:15:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42672 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbfLIRPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 12:15:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yDkXn8c2FrkGfy+U0MRLuXrzEaNV8CpIo/QaRFz2xmk=; b=EGDMJAMzVzZqYHI5GtOsZe0vDx
        tq8tD6m0jNbrFCUTpJbj/4Q8jHLyi8GIWgNxrZFofOGSyH4vg6mJF5LvyTMJ6XF/mmlL1xiiKgPKd
        LVAHbKb2+yDoAQvdWqny4t+JS45zWGe18sLJa+z1g2gsUBblNbqfm8XM6no+X5BudnFc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieMcm-0006d0-NV; Mon, 09 Dec 2019 18:15:08 +0100
Date:   Mon, 9 Dec 2019 18:15:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1] ARM i.MX6q: make sure PHY fixup for KSZ9031 is
 applied only on one board
Message-ID: <20191209171508.GD9099@lunn.ch>
References: <20191209084430.11107-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209084430.11107-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij

> This patch changes the MICREL KSZ9031 fixup, which was introduced for
> the "Data Modul eDM-QMX6" board in following patch, to be only activated
> for this specific board.

...

>  static void __init imx6q_enet_phy_init(void)
>  {
> +	/* Warning: please do not extend this fixup list. This fixups are
> +	 * applied even on boards where related PHY is not directly connected
> +	 * to the ethernet controller. For example with switch in the middle.
> +	 */
>  	if (IS_BUILTIN(CONFIG_PHYLIB)) {
>  		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
>  				ksz9021rn_phy_fixup);
> -		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
> -				ksz9031rn_phy_fixup);
> +
> +		if (of_machine_is_compatible("dmo,imx6q-edmqmx6"))
> +			phy_register_fixup_for_uid(PHY_ID_KSZ9031,
> +						   MICREL_PHY_ID_MASK,
> +						   ksz9031rn_phy_fixup);
> +
>  		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
>  				ar8031_phy_fixup);
>  		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,

What about the other 3 fixups? Are they not also equally broken,
applied for all boards, not specific boards?

	Andrew
