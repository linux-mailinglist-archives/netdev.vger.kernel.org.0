Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674B6297964
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 00:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757785AbgJWWni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 18:43:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757743AbgJWWni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 18:43:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kW5ma-003BbF-RQ; Sat, 24 Oct 2020 00:43:36 +0200
Date:   Sat, 24 Oct 2020 00:43:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, ardeleanalex@gmail.com
Subject: Re: [PATCH v2 1/2] net: phy: adin: disable diag clock & disable
 standby mode in config_aneg
Message-ID: <20201023224336.GF745568@lunn.ch>
References: <20201022074551.11520-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022074551.11520-1-alexandru.ardelean@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 10:45:50AM +0300, Alexandru Ardelean wrote:
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
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
