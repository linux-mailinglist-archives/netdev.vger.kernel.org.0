Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3855FDAC3
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 15:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiJMNYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 09:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiJMNYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 09:24:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73E9615A;
        Thu, 13 Oct 2022 06:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=amn3A9zRahU2ByJ3g1pqLOvDGc322030CzbGPu9aypQ=; b=R3i7neCCoBrZGTs6xckhJ4Gp0H
        LfCdPvByalwefMGaGaxuhR0RcgkRwbCpcP1Nix4OzMS4JaLkhjad2JRgybdFwDVdgiZnqGQQyf4HC
        E5KksyirArOmV7jp3N+U4yaf8oCpQBfvAiy06ZhayGctwWvKZzTsArX4fE8esKdacn/g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oiyCM-001tFa-Gh; Thu, 13 Oct 2022 15:24:30 +0200
Date:   Thu, 13 Oct 2022 15:24:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        harinikatakamlinux@gmail.com, michal.simek@amd.com,
        radhey.shyam.pandey@amd.com
Subject: Re: [PATCH] net: phy: dp83867: Extend RX strap quirk for SGMII mode
Message-ID: <Y0gRjoOOJQmGQ6Ao@lunn.ch>
References: <20221013072833.28558-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013072833.28558-1-harini.katakam@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 12:58:33PM +0530, Harini Katakam wrote:
> When RX strap in HW is not set to MODE 3 or 4, bit 7 and 8 in CF4
> register should be set. The former is already handled in
> dp83867_config_init; add the latter in SGMII specific initialization.
> 
> Signed-off-by: Harini Katakam <harini.katakam@amd.com>
> ---
>  drivers/net/phy/dp83867.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 6939563d3b7c..a2aac9032af6 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -853,6 +853,13 @@ static int dp83867_config_init(struct phy_device *phydev)
>  		else
>  			val &= ~DP83867_SGMII_TYPE;
>  		phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL, val);
> +		/* This is a SW workaround for link instability if RX_CTRL is
> +		 * not strapped to mode 3 or 4 in HW. This is required for SGMII
> +		 * in addition to clearing bit 7, handled above.
> +		 */

Blank line before a comment please.

Should this have a fixes tag? Are there deployed boards which are
broken because of this? Or do you have a new board, using SGMII, which
is not deployed yet?

	 Andrew
