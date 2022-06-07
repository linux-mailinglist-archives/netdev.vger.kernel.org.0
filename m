Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0940853FF69
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244204AbiFGMuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 08:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236004AbiFGMud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:50:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2D513EA2;
        Tue,  7 Jun 2022 05:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WJbMbosL31OwjK9ECJ5nWup9yekWoTUXGDqJQUOMW34=; b=vs2TcQavJOTNBzVxUMzQFO4mXa
        fS/fLhqdsiRCmNYKP2aIi41QYRWywjvTOT81c6OvnQ5E1p6LDC2MU8Iu1I231tEFtmXFFBHc8/0lD
        RoFF7NK7qfJD/SYowO/goKPovAtrNT482sdZgZ6x7eJnzl/02/REmg0CJQNLKrJH0LkY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nyYf5-005x30-3o; Tue, 07 Jun 2022 14:50:19 +0200
Date:   Tue, 7 Jun 2022 14:50:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/3] net: phy: dp83td510: add SQI support
Message-ID: <Yp9Ji2/FrbRxPayP@lunn.ch>
References: <20220607101710.2833332-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607101710.2833332-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct dp83td510_mse_sqi_range {
> +	u16 end;
> +	u16 start;
> +};
> +
> +/* Register values are converted to SNR(dB) as suggested by
> + * "Application Report - DP83TD510E Cable Diagnostics Toolkit":
> + * SNR(dB) = -10 * log10 (VAL/2^17) - 1.76 dB.
> + * SQI ranges are implemented according to "OPEN ALLIANCE - Advanced diagnostic
> + * features for 100BASE-T1 automotive Ethernet PHYs"
> + */
> +static const struct dp83td510_mse_sqi_range dp83td510_mse_sqi_map[] = {
> +	{ 0xffff, 0x0569 }, /* < 18dB */
> +	{ 0x0569, 0x044c }, /* 18dB =< SNR < 19dB */
> +	{ 0x044c, 0x0369 }, /* 19dB =< SNR < 20dB */
> +	{ 0x0369, 0x02b6 }, /* 20dB =< SNR < 21dB */
> +	{ 0x02b6, 0x0227 }, /* 21dB =< SNR < 22dB */
> +	{ 0x0227, 0x01b6 }, /* 22dB =< SNR < 23dB */
> +	{ 0x01b6, 0x015b }, /* 23dB =< SNR < 24dB */
> +	{ 0x015b, 0x0000 }, /* 24dB =< SNR */
> +};

You only really need start here, since the values always decrease.

> +	for (sqi = 0; sqi < ARRAY_SIZE(dp83td510_mse_sqi_map); sqi++) {
> +		if (mse_val >= dp83td510_mse_sqi_map[sqi].start &&
> +		    mse_val <= dp83td510_mse_sqi_map[sqi].end)

and then don't compare with end. Saves 8 words and a little bit of
code.

	Andrew
