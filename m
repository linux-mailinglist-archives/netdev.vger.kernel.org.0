Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A365C547659
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 18:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbiFKQMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 12:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiFKQMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 12:12:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9117ABE;
        Sat, 11 Jun 2022 09:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bxg6oME6P+/xKVdg0UH1OZTEHoeeXwl7w9rgm0xrILk=; b=GpkQkm0IOqePVzg/8SbLkwyoki
        GUZMbFBct50MYFqT7VyTM5qR5gy3PZi8+n0X92CjYA49aDgQBck6gQniTm0Yj6ymanKOofWwJHfRj
        /T/mTvxaJo7X2vmQYlYt4WcmhaE2U3i1sYfClDA9r6KPooci80mOUSMJyKtCy5YUh5J4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o03iP-006WjH-FD; Sat, 11 Jun 2022 18:11:57 +0200
Date:   Sat, 11 Jun 2022 18:11:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: add remote fault support
Message-ID: <YqS+zYHf6eHMWJlD@lunn.ch>
References: <20220608093403.3999446-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608093403.3999446-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index c67bf3060173..6c55c7f9b680 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -205,7 +205,7 @@ static int genphy_c45_baset1_an_config_aneg(struct phy_device *phydev)
>  		break;
>  	case MASTER_SLAVE_CFG_UNKNOWN:
>  	case MASTER_SLAVE_CFG_UNSUPPORTED:
> -		return 0;
> +		break;
>  	default:
>  		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
>  		return -EOPNOTSUPP;
> @@ -223,11 +223,16 @@ static int genphy_c45_baset1_an_config_aneg(struct phy_device *phydev)
>  		break;
>  	}
>  
> +	if (phydev->remote_fault_set >= REMOTE_FAULT_CFG_ERROR)
> +		adv_l |= MDIO_AN_T1_ADV_L_REMOTE_FAULT;
> +
>  	adv_l |= linkmode_adv_to_mii_t1_adv_l_t(phydev->advertising);
>  
>  	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_L,
> -				     (MDIO_AN_T1_ADV_L_FORCE_MS | MDIO_AN_T1_ADV_L_PAUSE_CAP
> -				     | MDIO_AN_T1_ADV_L_PAUSE_ASYM), adv_l);
> +				     (MDIO_AN_T1_ADV_L_FORCE_MS |
> +				      MDIO_AN_T1_ADV_L_PAUSE_CAP |
> +				      MDIO_AN_T1_ADV_L_PAUSE_ASYM |
> +				      MDIO_AN_T1_ADV_L_REMOTE_FAULT), adv_l);

Since this is part of config_aneg, i assume you have to trigger an
renegotiation, which will put the link down for a while. Is that
actually required? Can the fault indicator be set at runtime without a
full auto-neg? I suppose for a fault indicator, it probably does not
matter, there is a fault... But i'm wondering about future extensions
which might want to send values when the link is up. I've seen some
PHYs indicate their make/model, etc. What sort of API would be needed
for that?

It might also be useful if we could send an event to userspace when
the receive state changes, so there is no need to poll. I thought
something link a linkstate message was broadcast under some
conditions? That again my suggest ksetting is maybe not the best place
for this?

I see no problem in exposing this information, but i would like to be
sure we get the API correct.

     Andrew
