Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876C4653164
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 14:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbiLUNLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 08:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbiLUNLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 08:11:04 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8C01B7A3;
        Wed, 21 Dec 2022 05:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PXDiz8etW8L2ji2hcEQoJ88xul8rwm/VoesMK8+SDfg=; b=TfJjO0+tpFtwcOs6UkH88bLbIU
        ZL7FUyrVpsr5bi0POlWH2hdLUkGukjKrlJrqe7lsond+d0LtQyfPI8wv9ei1pGh3PTX8njjrjKzjk
        khzepp2Kj1+CCg/f+JMXeikFM19oGZJZz24kXJJKhJT6HeImNXF42kpEg3Wq1i53mpLo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7yrt-000BC5-Az; Wed, 21 Dec 2022 14:10:45 +0100
Date:   Wed, 21 Dec 2022 14:10:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 06/11] leds: trigger: netdev: add hardware control
 support
Message-ID: <Y6MF1US2b42xY2sf@lunn.ch>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-7-ansuelsmth@gmail.com>
 <Y5tUU5zA/lkYJza+@shell.armlinux.org.uk>
 <639ca665.1c0a0220.ae24f.9d06@mx.google.com>
 <Y6JMe9oJDCyLkq7P@lunn.ch>
 <Y6LX43poXJ4k/7mv@shell.armlinux.org.uk>
 <63a3038b.050a0220.d41c3.6f48@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63a3038b.050a0220.d41c3.6f48@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > I agree we need to make compromises. We cannot support every LED
> > > feature of every PHY, they are simply too diverse. Hopefully we can
> > > support some features of every PHY. In the worst case, a PHY simply
> > > cannot be controlled via this method, which is the current state
> > > today. So it is not worse off.
> > 
> > ... and that compromise is that it's not going to be possible to enable
> > activity mode on 88e151x with how the code stands and with the
> > independent nature of "rx" and "tx" activity control currently in the
> > netdev trigger... making this whole approach somewhat useless for
> > Marvell PHYs.
> 
> Again we can consider adding an activity mode. It seems logical that
> some switch may only support global traffic instead of independend tx or
> rx... The feature are not mutually exclusive. One include the other 2.

Looking at the software trigger, adding NETDEV_LED_RXTX looks simple
to do. I also suspect it will be used by more than Marvell.

> > We really need to see a working implementation for this code for more
> > than just one PHY to prove that it is actually possible for it to
> > support other PHYs. If not, it isn't actually solving the problem,
> > and we're going to continue getting custom implementations to configure
> > the LED settings.
> > 
> 
> Agree that we need other user for this to catch some problem in the
> implementation of this generic API.

We need a PHY driver implementation. The phylib core needs to be
involved, the cled code needs to call generic phylib functions which
take the phydev->lock before calling into the PHY driver. Probably the
phylib core can do all the memory allocation, and registration of the
LED to the LED core. If it is not too ugly, i would also do the DT
binding parsing in the core, so we don't end up with subtle
differences.

	Andrew
