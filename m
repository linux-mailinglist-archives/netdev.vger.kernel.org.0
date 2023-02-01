Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EFA685CA1
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 02:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjBABbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 20:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjBABbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 20:31:35 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C001252A6;
        Tue, 31 Jan 2023 17:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FlYnn6qs526jMlhhZYL7BegsSLZDJAUAJkOUYSBLIwE=; b=y2NpP05JUu+EK8RJZAwoaLEgAf
        fRfQkdl5H/aAOy01GGN9QZmblyTBL70UZWIDryExo+onFTVkB5VaVWak2krtzaEVhJ5j9HFqeV8QX
        Vd+tNfOWF3UnD9IhY3clVL5qRgjQjrf+Mc8PZtgsQK8XN1QU/+p/DQVvi/7AfdDnoJEA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pN1xw-003k5R-Lt; Wed, 01 Feb 2023 02:31:12 +0100
Date:   Wed, 1 Feb 2023 02:31:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Wei Fang <wei.fang@nxp.com>, Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: fix conversion to gpiod API
Message-ID: <Y9nA4Mmi5hv5OzBh@lunn.ch>
References: <Y9mar1COtT5z4mvT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9mar1COtT5z4mvT@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 02:48:15PM -0800, Dmitry Torokhov wrote:
> The reset line is optional, so we should be using
> devm_gpiod_get_optional() and not abort probing if it is not available.

> Also, gpiolib already handles phy-reset-active-high, continuing handling
> it directly in the driver when using gpiod API results in flipped logic.

Please could you split this part into a separate patch. There is some
history here, but i cannot remember which driver it actually applies
to. It might be the FEC, it could be some other Ethernet driver.

For whatever driver it was, the initial support for GPIOs totally
ignored the polarity value in DT. The API at the time meant you needed
to take extra steps to get the polarity, and that was skipped. So it
was hard coded. But developers copy/pasted DT statement from other DT
files, putting in the opposite polarity to the hard coded
value. Nobody noticed until somebody needed the opposite polarity to
the hard coded implementation to make their board work. And then the
problem was noticed. The simple solution to actually use the polarity
in DT would break all the boards which had the wrong value. So a new
property was added.

So i would like this change in a separate patch, so if it causes
regressions, it can be reverted.

> While at this convert phy properties parsing from OF to generic device
> properties to avoid #ifdef-ery.

We also need to be careful here. If you read fsl,fec.yaml, there are a
number of deprecated properties. These need to keep working for OF,
but we clearly don't want them exposed to ACPI or anything else. So if
you use generic device properties, please ensure they are only for OF.

    Andrew
