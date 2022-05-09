Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDC051FD63
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbiEIMyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiEIMyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:54:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883502983A7
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 05:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Oxf6X57lK6/2R3im6U3kNE0FezEXTqH+VoKfO00rJiA=; b=yGFHSRuNhcn1G13/IrmGUqdT/p
        80jK5F8+zv5ZwOpmUGESnd6oKynMpQzG5v2Ja8SQ0HeVuFf7XJQE8OTeFy+2zFS+hukwjznPSl1Lz
        ZaxUSKF/Q+J24tK9YLYp3SmauEa1/wv9DRxSRzb3Xh3XU4k8ADuTRlhBVnqGBs2yDYRo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1no2pr-001wYi-R6; Mon, 09 May 2022 14:49:59 +0200
Date:   Mon, 9 May 2022 14:49:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Message-ID: <YnkN954Wb7ioPkru@lunn.ch>
References: <20220509122938.14651-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509122938.14651-1-josua@solid-run.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 03:29:38PM +0300, Josua Mayer wrote:
> Dear Maintainers,
> 
> I am working on a new device based on the LX2160A platform, that exposes
> 16 sfp connectors, each with its own led controlled by gpios intended
> to show link status.

Can you define link status? It is a messy concept with SFPs. Is it
!LOS? I guess not, because you would not of used a GPIO, just hard
wired it. Does it mean the SERDES has sync? Does it reflect the netdev
carrier status?

> We have found that there is a way in sysfs to echo the name of the network
> device to the api of the led driver, and it will start showing link status.
> However this has to be done at runtime by the user.

Please take a look at the patches Ansuel Smith submitted last week,
maybe the week before last.

> On the Layerscape platform in particular these devices are created dynamically
> by the networkign coprocessor, which supports complex functions such as
> creating one network interface that spans multiple ports.

The linux model is that each MAC has a netdev, hence a name. If you
need to span multiple ports, you then add a bridge and add the MACs to
the bridge. So there should not be an issue here.

> It seems to me that the netdev trigger therefore can not properly reflect
> the relation between an LED (which is hard-wired to an sfp cage), and the
> link state reported by e.g. a phy inside an sfp module.

The netdev carrier will correctly reflect this.

> You may notice that again leds are tied to existence of a particular logical
> network interface, which may or may not exist, and may span multiple
> physical interfaces in case of layerscape.

As far as i'm aware, the in kernel code always has a netdev for each
MAC. Are you talking about the vendor stack?

	Andrew
