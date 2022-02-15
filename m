Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF894B797D
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 22:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244226AbiBOU5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 15:57:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244238AbiBOU5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 15:57:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BAB19C23;
        Tue, 15 Feb 2022 12:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=keg/iMk+UdaNfyy0BZm+iDOzuvq0G4cjTusXA9Hp92k=; b=CAkseX/Qyh+FIx8oj8t3veXNKf
        UKyx6v1rPPeE7gNSMBgBfKGoC0Yi6enZ8NhlM1sTilCU+NodZ4d8ft4POAS992JSNuPDdt6ZG8am+
        w+FwWzbH0q1dp0OqCSHkFnaLXFtmo/c81EZlMzbsdwPVNZ/IfR35QWsvVNInmaVq9sSE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nK4sU-0067XH-Bw; Tue, 15 Feb 2022 21:56:50 +0100
Date:   Tue, 15 Feb 2022 21:56:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Tony Lindgren <tony@atomide.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Ray Jui <rjui@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Scott Branden <sbranden@broadcom.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 5/8] ARM: dts: exynos: fix ethernet node name for
 different odroid boards
Message-ID: <YgwTkr1UIGH6hgJ6@lunn.ch>
References: <20220215080937.2263111-1-o.rempel@pengutronix.de>
 <20220215080937.2263111-5-o.rempel@pengutronix.de>
 <20220215081240.hhie4niqnc5tuka2@pengutronix.de>
 <20220215081645.GD672@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215081645.GD672@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > -	ethernet: usbether@2 {
> > > -		compatible = "usb0424,9730";
> > > +	ethernet: ethernet@2 {
> > > +		compatible = "usb424,9730";
> > 
> > The change of the compatible is not mentioned in the patch description.
> > Is this intentional?
> 
> No, I forgot to mentione it. According to the USB schema 0 should be
> removed. So, this compatible was incorrect as well. With leading zero
> present yaml schema was not able to detect and validate this node.

Does the current code not actually care about a leading 0? It will
match with or without it? It would be good to mention that as well in
the commit message, otherwise somebody like me is going to ask if this
breaks backwards compatibility, since normally compatible is an exact
string match.

And i actually think this is the sort of change which should be as a
patch of its own. If this causes a regression, a git bisect would then
tell you if it is the change of usbether -> ethernet, or 0424 to
424. That is part of why we ask for lots of small changes.


       Andrew
