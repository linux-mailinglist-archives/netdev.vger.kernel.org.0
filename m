Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62C0547605
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 17:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238328AbiFKPQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 11:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238620AbiFKPQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 11:16:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6B749B4A;
        Sat, 11 Jun 2022 08:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vIjU1/ssx94Zh7gH5uVJhLWKzXW6h1INipednLmmvIs=; b=EzBJzmvJc9Zk3+lFwbfERBktAF
        t7rX+XcaryfaE5Blv4eDuIBtvUTfoXPgPRhSr+4e6nP5xCmRggKfa94gV/fncopzhx7pClppvzoLB
        7q7NpVZREfzwSPv4j6wiXAsUulfUtRQHXSyd2tJrdIwUjQm6OcCET86mnnR+kn23AkgA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o02qM-006WMI-Qe; Sat, 11 Jun 2022 17:16:06 +0200
Date:   Sat, 11 Jun 2022 17:16:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/3] net: phy: dp83td510: disable cable test
 support for 1Vpp PHYs
Message-ID: <YqSxtvZUEmaxmihV@lunn.ch>
References: <20220608123236.792405-1-o.rempel@pengutronix.de>
 <20220608123236.792405-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608123236.792405-4-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int dp83td510_cable_test_start(struct phy_device *phydev)
>  {
> -	int ret;
> +	struct dp83td510_priv *priv = phydev->priv;
> +	int ret, cfg = 0;
> +
> +	/* Generate 2.4Vpp pulse if HW is allowed to do so */
> +	if (priv->allow_v2_4_mode) {
> +		cfg |= DP83TD510E_TDR_TX_TYPE;
> +	} else {
> +		/* This PHY do not provide usable results with 1Vpp pulse.

s/do/does


> +		 * Potentially different dp83td510_tdr_init() values are
> +		 * needed.
> +		 */
> +		return -EOPNOTSUPP;
> +	}

I don't remember the details for v2.4. Is it possible to change up
from 1v to 2.4v for the duration of the cable test? Is there a danger
to damage the link peer? I guess not, since you need to pass EMC
testing which zaps it with 100Kv or something. So is this more a local
supply issue?

       Andrew
