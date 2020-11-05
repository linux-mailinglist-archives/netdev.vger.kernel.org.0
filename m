Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C013D2A747F
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388110AbgKEBHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:07:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgKEBHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 20:07:00 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC7CF20BED;
        Thu,  5 Nov 2020 01:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604538419;
        bh=xrNNbuSiVgRenrPPmM3aEUhBPnU96ggJX5c8ysDtjx0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V+2TqU+dPu3+Ii5F98IC8vCXfkk0ZC8fS32kF06hoYTLrlAPvKKJmg3JSLQjGZU5c
         ib4YfgV6WFxr2dNEutwqHWYP/RnnCvHYcs0yLpWUIeyiLddSaD4p2uR/MdK4GgHYtA
         6AVKV1dlGNclhJYl2gXyfT9SGlAQQJbKiQevT5Nc=
Date:   Wed, 4 Nov 2020 17:06:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alexaundru.ardelean@analog.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <ardeleanalex@gmail.com>
Subject: Re: [PATCH net-next v2 1/2][RESEND] net: phy: adin: disable diag
 clock & disable standby mode in config_aneg
Message-ID: <20201104170657.06696417@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103074436.93790-1-alexandru.ardelean@analog.com>
References: <20201103074436.93790-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 09:44:35 +0200 Alexandru Ardelean wrote:
> When the PHY powers up, the diagnostics clock isn't enabled (bit 2 in
> register PHY_CTRL_1 (0x0012)).
> Also, the PHY is not in standby mode, so bit 13 in PHY_CTRL_3 (0x0017) is
> always set at power up.
> 
> The standby mode and the diagnostics clock are both meant to be for the
> cable diagnostics feature of the PHY (in phylib this would be equivalent to
> the cable-test support), and for the frame-generator feature of the PHY.
> 
> In standby mode, the PHY doesn't negotiate links or manage links.
> 
> To use the cable diagnostics/test (or frame-generator), the PHY must be
> first set in standby mode, so that the link operation doesn't interfere.
> Then, the diagnostics clock must be enabled.
> 
> For the cable-test feature, when the operation finishes, the PHY goes into
> PHY_UP state, and the config_aneg hook is called.
> 
> For the ADIN PHY, we need to make sure that during autonegotiation
> configuration/setup the PHY is removed from standby mode and the
> diagnostics clock is disabled, so that normal operation is resumed.
> 
> This change does that by moving the set of the ADIN1300_LINKING_EN bit (2)
> in the config_aneg (to disable standby mode).
> Previously, this was set in the downshift setup, because the downshift
> retry value and the ADIN1300_LINKING_EN are in the same register.
> 
> And the ADIN1300_DIAG_CLK_EN bit (13) is cleared, to disable the
> diagnostics clock.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Applied both, thanks.
