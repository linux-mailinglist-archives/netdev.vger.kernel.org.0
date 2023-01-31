Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748A26833D0
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbjAaRZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjAaRZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:25:48 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BCA1AE;
        Tue, 31 Jan 2023 09:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fDSaSa39yivQnOaZDnppDmUcfmn2i3ZzZlEgoY/i8AU=; b=YryJ11H0KUdmJbVE3KNpSwol7R
        Wy8W73Idiaf9pdaQl8qHeMWCyEM8O7eWGEkPlIzcFTkDr5y2Ikq2UVb5UcDJPF03tNaodv8C3L+eS
        1r8/XknV3UOSieVIxo6C+Pv/8KiBZU9lkW2LkTuezf2Vj0A3D8dDfksBkbeEDmWtzN9w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pMuNw-003iAv-Hr; Tue, 31 Jan 2023 18:25:32 +0100
Date:   Tue, 31 Jan 2023 18:25:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Arnd Bergmann <arnd@kernel.org>, Wei Fang <wei.fang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ore@pengutronix.de,
        kernel@pengutronix.de
Subject: Re: [PATCH] [v2] fec: convert to gpio descriptor
Message-ID: <Y9lPDGUestsjdWVX@lunn.ch>
References: <20230126210648.1668178-1-arnd@kernel.org>
 <20230131153851.ua57vy7vc2xdasup@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131153851.ua57vy7vc2xdasup@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 04:38:51PM +0100, Marc Kleine-Budde wrote:
> On 26.01.2023 22:05:59, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > The driver can be trivially converted, as it only triggers the gpio
> > pin briefly to do a reset, and it already only supports DT.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> On current net-next/main 6a8ab436831d ("Merge branch
> 'add-support-for-the-the-vsc7512-internal-copper-phys'") this causes the
> riot board (arch/arm/boot/dts/imx6dl-riotboard.dts) to not probe the
> fec:
> 
> | Jan 31 16:32:12 riot kernel: fec 2188000.ethernet: error -ENOENT: failed to get phy-reset-gpios
> | Jan 31 16:32:12 riot kernel: fec: probe of 2188000.ethernet failed with error -2

Hi Marc

Could you try swapping the devm_gpiod_get() for
devm_gpiod_get_optional().

It is kind of hidden, but:

-       else if (!gpio_is_valid(phy_reset))
-               return 0;

made the GPIO optional, since -2 is not a valid GPIO number and so it
would silently return.

The real fix will need to be a bit more complex, since we don't want
to do the sleeps etc if the GPIO is not present.

	Andrew
