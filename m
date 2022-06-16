Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FB254E222
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 15:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377075AbiFPNid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 09:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377131AbiFPNiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 09:38:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588012182B;
        Thu, 16 Jun 2022 06:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Hqev1JljWuIog6Qwb5pXy7KyfyFGwW/rY2rm7/myAt8=; b=gYRyhwPuqaM08BTv6ldgOHpicI
        Fk5adfzYyxY/kd+qqQQ+tRoqh4eFTzFgTLfK5mZ7bpDFPg8JWY0leiC+EhVv4Q++cXJnhXvR29suo
        0C/h8o4gQq93I4wiI31qrPaTDYaTabnglMe84fcvjdzM1VRi8GdNjxKGeEThxno1/nTA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1phP-007Bxo-UQ; Thu, 16 Jun 2022 15:38:15 +0200
Date:   Thu, 16 Jun 2022 15:38:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: at803x: fix NULL pointer
 dereference on AR9331 PHY
Message-ID: <YqsyRxNsG3AYrfnX@lunn.ch>
References: <20220616113105.890373-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616113105.890373-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 01:31:05PM +0200, Oleksij Rempel wrote:
> Latest kernel will explode on the PHY interrupt config, since it depends
> now on allocated priv. So, run probe to allocate priv to fix it.
> 
> Fixes: 3265f4218878 ("net: phy: at803x: add fiber support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/at803x.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 6a467e7817a6..b72a807f2e03 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -2072,6 +2072,8 @@ static struct phy_driver at803x_driver[] = {
>  	/* ATHEROS AR9331 */
>  	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
>  	.name			= "Qualcomm Atheros AR9331 built-in PHY",
> +	.probe			= at803x_probe,
> +	.remove			= at803x_remove,
>  	.suspend		= at803x_suspend,
>  	.resume			= at803x_resume,
>  	.flags			= PHY_POLL_CABLE_TEST,

Is the same change needed for some of the other PHYs? QCA8081?
QCA9561?

	Andrew
