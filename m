Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7B3686D99
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjBASEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjBASEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:04:44 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255CF5356C;
        Wed,  1 Feb 2023 10:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OH6U4yR0+G89QSEnVcr38KhJN3Zf5DdwI7KCj4KlqMs=; b=0f4n4TmoRbXPn6e1c7WoA+60LF
        0NTVfL5ycrTrbA57ptyKusE5K/lB7Nppzd6Nc2iYTdBU5NqFCXBqfn5AnXbhO1Fj9icxwsWqQ6TOa
        tE8bkQy4EabSGsfK4Rmy6xO97Vt+TwgI+drCqI6roTPbeawiD1DXlL/CQwEI8nb67eOw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNHTB-003p7i-OB; Wed, 01 Feb 2023 19:04:29 +0100
Date:   Wed, 1 Feb 2023 19:04:29 +0100
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
Subject: Re: [PATCH v2] net: fec: fix conversion to gpiod API
Message-ID: <Y9qprbyr/0sa3sBN@lunn.ch>
References: <Y9nbJJP/2gvJmpnO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9nbJJP/2gvJmpnO@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 07:23:16PM -0800, Dmitry Torokhov wrote:
> The reset line is optional, so we should be using devm_gpiod_get_optional()
> and not abort probing if it is not available. Also, there is a quirk in
> gpiolib (introduced in b02c85c9458cdd15e2c43413d7d2541a468cde57) that
> transparently handles "phy-reset-active-high" property. Remove handling
> from the driver to avoid ending up with the double inversion/flipped
> logic.
> 
> Fixes: 468ba54bd616 ("fec: convert to gpio descriptor")
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Please split this into two:

1) Fix for it being optional
2) Removing support for phy-reset-active-high

The breakage is in net-next, so we are not in a rush, and we don't
need a minimum of patches. So since this is two logical changes, it
should be two patches.

Please also update the binding document to indicate that
'phy-reset-active-high' is no longer deprecated, it has actually been
removed. So we want the DT checking tools to error out if such a
property is found.

Thanks
	Andrew
