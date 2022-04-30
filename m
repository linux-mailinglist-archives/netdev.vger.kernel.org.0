Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D00515E78
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 16:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382907AbiD3O7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 10:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242575AbiD3O7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 10:59:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2992727FD8
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 07:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Hn0pzLJ8JK5gxsWh516AnRtjpe0kTCzj15XeRFDa6ys=; b=jAZOwA1plNNy/PsNqdqinQbMvj
        rgqQXJxjep5hOp64DcEx17VF5ii1ySq7ntD0DBuNeNaeDdDa+ZIPoxfA8gQnWuYSr3QMNYu+cR2q7
        zNKHI68tzgr0RviPzE3kvky5dXTYvUUCnT9aG4eoQQYcNg71F3XDDJFlgjuixH+NuJBE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkoVG-000e22-Ds; Sat, 30 Apr 2022 16:55:22 +0200
Date:   Sat, 30 Apr 2022 16:55:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        hkallweit1@gmail.com, richardcochran@gmail.com, lasse@timebeat.app,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v2 1/3] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <Ym1N2sINE0A6WchK@lunn.ch>
References: <20220430025723.1037573-1-jonathan.lemon@gmail.com>
 <20220430025723.1037573-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220430025723.1037573-2-jonathan.lemon@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev)
> +{
> +	struct bcm_ptp_private *priv;
> +	struct ptp_clock *clock;
> +
> +	switch (BRCM_PHY_MODEL(phydev)) {
> +	case PHY_ID_BCM54210E:
> +		break;
> +	default:
> +		return NULL;
> +	}
> +
> +	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return ERR_PTR(-ENOMEM);
> +
> +	priv->ptp_info = bcm_ptp_clock_info;
> +
> +	clock = ptp_clock_register(&priv->ptp_info, &phydev->mdio.dev);
> +	if (IS_ERR(clock))
> +		return (void *)clock;

nit-pick:

You could use ERR_CAST() here.

    Andrew
