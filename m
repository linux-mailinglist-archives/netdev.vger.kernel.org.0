Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C07A59EF3D
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbiHWW1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiHWW0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:26:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71A088DE2;
        Tue, 23 Aug 2022 15:26:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B2AC616DA;
        Tue, 23 Aug 2022 22:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77486C433D6;
        Tue, 23 Aug 2022 22:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661293586;
        bh=aWG79MFk02Dxky/hrQXH1us3auS0+9GXcsSIf2YTNLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N5edXaO6NZ626HwZ0OSXLbJfoHLaBH29GodiFWqicsRi7gpCihc8jRk06wkgIMc3M
         BeE77gNYAwzIJ5odnRwhorAX7NBNr2SFgIJgwoMNWaWcSbrb8abH/zeWFDMEGCwpwJ
         WDmXRfzMT2DrBNNXOG6P6I26fEnBkkPQRcNgkjD5e6WCsck/CQlAE7XehmCxKOKNu3
         nwSFLjoPuCybaBWX2vx9zv93Y1+wT3AiYItjcT5ePhdK6QmmbMM9aqORsEJSDclBUN
         aQ2A25KFBi0BMrnrFbealdLPsET5wCR7HbF2HJTW+lWLBbETtOBK3Ej+vYxX57HOAK
         BIz6kWnpNP0DQ==
Date:   Tue, 23 Aug 2022 15:26:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qingfang DENG <dqfext@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: allow RGMII/RTBI in-band status
Message-ID: <20220823152625.7d0cbaae@kernel.org>
In-Reply-To: <20220819092607.2628716-1-dqfext@gmail.com>
References: <20220819092607.2628716-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 17:26:06 +0800 Qingfang DENG wrote:
> As per RGMII specification v2.0, section 3.4.1, RGMII/RTBI has an
> optional in-band status feature where the PHY's link status, speed and
> duplex mode can be passed to the MAC.
> Allow RGMII/RTBI to use in-band status.
> 
> Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> Signed-off-by: Qingfang DENG <dqfext@gmail.com>

Russell, PHY folks, any judgment on this one?

Qingfang is there a platform which require RGMII to be supported 
in upstream LTS branches? If there isn't you should re-target 
the patch at net-next and drop the Fixes tag. Not implementing
the entire spec is not considered a bug. Please clarify this
in the commit message.

> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 9bd69328dc4d..57186d322835 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -632,6 +632,11 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
>  		switch (pl->link_config.interface) {
>  		case PHY_INTERFACE_MODE_SGMII:
>  		case PHY_INTERFACE_MODE_QSGMII:
> +		case PHY_INTERFACE_MODE_RGMII:
> +		case PHY_INTERFACE_MODE_RGMII_ID:
> +		case PHY_INTERFACE_MODE_RGMII_RXID:
> +		case PHY_INTERFACE_MODE_RGMII_TXID:
> +		case PHY_INTERFACE_MODE_RTBI:
>  			phylink_set(pl->supported, 10baseT_Half);
>  			phylink_set(pl->supported, 10baseT_Full);
>  			phylink_set(pl->supported, 100baseT_Half);

