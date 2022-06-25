Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860AD55A7B3
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 09:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbiFYHRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 03:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiFYHRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 03:17:37 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FBC31DE3;
        Sat, 25 Jun 2022 00:17:35 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 2BA4B100D9407;
        Sat, 25 Jun 2022 09:17:32 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 05825132D7A; Sat, 25 Jun 2022 09:17:32 +0200 (CEST)
Date:   Sat, 25 Jun 2022 09:17:31 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: ax88772a: fix lost pause
 advertisement configuration
Message-ID: <20220625071731.GA3462@wunner.de>
References: <20220624075558.3141464-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624075558.3141464-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 09:55:58AM +0200, Oleksij Rempel wrote:
> In case of asix_ax88772a_link_change_notify() workaround, we run soft
> reset which will automatically clear MII_ADVERTISE configuration. The
> PHYlib framework do not know about changed configuration state of the
> PHY, so we need to save and restore all needed configuration registers.
[...]
>  static void asix_ax88772a_link_change_notify(struct phy_device *phydev)
>  {
>  	/* Reset PHY, otherwise MII_LPA will provide outdated information.
>  	 * This issue is reproducible only with some link partner PHYs
>  	 */
> -	if (phydev->state == PHY_NOLINK && phydev->drv->soft_reset)
> +	if (phydev->state == PHY_NOLINK && phydev->drv->soft_reset) {
> +		struct asix_context context;
> +
> +		asix_context_save(phydev, &context);
> +
>  		phydev->drv->soft_reset(phydev);
> +
> +		asix_context_restore(phydev, &context);
> +	}
>  }

Hm, how about just calling phy_init_hw()?  That will perform a
->soft_reset() and also restore the configuration, including
interrupts (which the above does not, but I guess that's
irrelevant as long as the driver uses polling).

Does phy_init_hw() do too much or too little compared to the above
and is hence not a viable solution?

Thanks,

Lukas
