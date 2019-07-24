Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D080729CA
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 10:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfGXIT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 04:19:26 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42504 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfGXITY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 04:19:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Jo7UbG3i4qL+YRK/gb/6Wocl7C+80PS6O1UQW7r85Dg=; b=inscm0LLKuqV/2tuQ8tW3SCpk
        ETpHQEqrn5h3Bmw7XwFab9ef1o7aBTC7Qq9NGjbbdW3mcDlMXZfq39swvFFtntbUcRQJclyajQYSg
        i+6ydQVa5Id0ASGtqTApGmy4g9NJpXynauURUW8REse4S2QegbzgnbJXRBO2uJ67NZRchhAmUn+4t
        DLbCtwUHeuj6kJ0Pi39Oy0PLm/wOtqKmbuJUNMKrbdGB8Ydbb0GMPIfAA3BsSvtQ8/Uj4NCHOSox+
        Oj/GiLMOm7aZDcwGf0PyMJf4zV2fuHZ33dxALZRgyRiK1/fT6fieREhseZ8CERwRP8jDjdTikgest
        E4yYiJAYA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:36984)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hqCUX-0000g7-RV; Wed, 24 Jul 2019 09:19:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hqCUV-0004hc-J6; Wed, 24 Jul 2019 09:19:15 +0100
Date:   Wed, 24 Jul 2019 09:19:15 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Arseny Solokha <asolokha@kb.kras.ru>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] gianfar: convert to phylink
Message-ID: <20190724081915.GF1330@shell.armlinux.org.uk>
References: <20190723151702.14430-1-asolokha@kb.kras.ru>
 <20190723151702.14430-2-asolokha@kb.kras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723151702.14430-2-asolokha@kb.kras.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 10:17:01PM +0700, Arseny Solokha wrote:
> -static noinline void gfar_update_link_state(struct gfar_private *priv)
> +static void gfar_mac_config(struct phylink_config *config, unsigned int mode,
> +			    const struct phylink_link_state *state)
>  {
> +	struct gfar_private *priv = netdev_priv(to_net_dev(config->dev));
>  	struct gfar __iomem *regs = priv->gfargrp[0].regs;
> -	struct net_device *ndev = priv->ndev;
> -	struct phy_device *phydev = ndev->phydev;
> -	struct gfar_priv_rx_q *rx_queue = NULL;
> -	int i;
> +	u32 maccfg1, new_maccfg1;
> +	u32 maccfg2, new_maccfg2;
> +	u32 ecntrl, new_ecntrl;
> +	u32 tx_flow, new_tx_flow;
>  
>  	if (unlikely(test_bit(GFAR_RESETTING, &priv->state)))
>  		return;
>  
> -	if (phydev->link) {
> -		u32 tempval1 = gfar_read(&regs->maccfg1);
> -		u32 tempval = gfar_read(&regs->maccfg2);
> -		u32 ecntrl = gfar_read(&regs->ecntrl);
> -		u32 tx_flow_oldval = (tempval1 & MACCFG1_TX_FLOW);
> +	if (unlikely(phylink_autoneg_inband(mode)))
> +		return;

Given that SFPs can be either SGMII or 1000BASE-X (which require
different configuration) and that the intention here is to support
SFPs, I don't see how this works with the above.

How is the difference between SGMII and 1000BASE-X handled?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
