Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A746DB049
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjDGQKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbjDGQKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:10:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F59DBDE7
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 09:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rSnrgdNdBdgeZ9ugnG3ggs5VT76B6rx0vll8yIDdxDA=; b=RcN97FG3fzgDdKKjl6sPlPkQdJ
        SWwopxsQ1zGMvjpKYjrOdrk13RWkJ6X20gdw+xYOWNpHHBz+hejygqegJF+cc2YEREP49iC+42OzE
        lIZEdFkGgitkjB0zQLWDwWbhff+oFNsgmhhoxdHog/MESYAuIQbngiK/4OEMxu8n0EfQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pkofX-009k01-7l; Fri, 07 Apr 2023 18:10:31 +0200
Date:   Fri, 7 Apr 2023 18:10:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de,
        Russell King <rmk+kernel@armlinux.org.uk>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Message-ID: <b5e96d31-6290-44e5-b829-737e40f0ef35@lunn.ch>
References: <20230407152503.2320741-1-andrew@lunn.ch>
 <20230407152503.2320741-2-andrew@lunn.ch>
 <20230407154159.upribliycphlol5u@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407154159.upribliycphlol5u@skbuf>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 06:41:59PM +0300, Vladimir Oltean wrote:
> On Fri, Apr 07, 2023 at 05:25:01PM +0200, Andrew Lunn wrote:
> > The DSA framework has got more picky about always having a phy-mode
> > for the CPU port. The imx51 Ethernet supports MII, and RMII. Set the
> > switch phy-mode based on how the SoC Ethernet port has been
> > configured.
> > 
> > Additionally, the cpu label has never actually been used in the
> > binding, so remove it.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> 
> In theory, an MII MAC-to-MAC connection should have phy-mode = "mii" on
> one end and phy-mode = "rev-mii" on the other, right?

In theory, yes. As far as i understand, it makes a difference to where
the clock comes from. rev-mii is a clock provider i think.

But from what i understand of the code, and the silicon, this property
is going to be ignored, whatever value you give it. phy-mode is only
used and respected when the port can support 1000Base-X, SGMII, and
above, or use its built in PHY. For MII, GMII, RMII, RGMII the port
setting is determined by strapping resistors.

The DSA core however does care that there is a phy-mode, even if it is
ignored. I hope after these patches land we can turn that check into
enforce mode, and that then unlocks Russell to make phylink
improvement.

	Andrew

