Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCA56BEE7B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjCQQhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjCQQhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:37:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231A026BA;
        Fri, 17 Mar 2023 09:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=h4pd0B3t8UZGiB3L/aATA1bhMC7CY8voihS+BYBphpk=; b=AY
        ZZ2E51URU6DzJuLs4Exrtw8D3XjCXTJKXy1pPe18JxDlT3VC9VjVxiajIQfd1Uoyk3w4PBdUzLovW
        xbk+nPyQi5jtOcRvPre31KyKjg9nVLyS85P+R/Bm4F46k+23vNlPoIQs08lqmYiQIvW6Vc0icTTDa
        nRmNEHfbE1WpVy8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdD5B-007dEt-6W; Fri, 17 Mar 2023 17:37:33 +0100
Date:   Fri, 17 Mar 2023 17:37:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        f.fainelli@gmail.com, jonas.gorski@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
Message-ID: <721af394-9ed7-477a-8b05-f8109a0d4b48@lunn.ch>
References: <20230317113427.302162-1-noltari@gmail.com>
 <20230317113427.302162-3-noltari@gmail.com>
 <20230317115115.s32r52rz3svuj4ed@skbuf>
 <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
 <20230317130434.7cbzk5gxx5guarcz@skbuf>
 <CAKR-sGeFZLnuqH=4Gok1URJEvrQKxbk203Q8zdMd9830G_XD7A@mail.gmail.com>
 <1ed6d7d9-4d3e-4bcb-8023-75bb52c2f272@lunn.ch>
 <CAKR-sGfMF+UtL4kY2hJ9gw4=jQu1JAqqF3N0obeUE=vGj8R-yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKR-sGfMF+UtL4kY2hJ9gw4=jQu1JAqqF3N0obeUE=vGj8R-yA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 05:30:38PM +0100, Álvaro Fernández Rojas wrote:
> El vie, 17 mar 2023 a las 17:27, Andrew Lunn (<andrew@lunn.ch>) escribió:
> >
> > > > The proposed solution is too radical for a problem that was not properly
> > > > characterized yet, so this patch set has my temporary NACK.
> > >
> > > Forgive me, but why do you consider this solution too radical?
> >
> > I have to agree with Vladimir here. The problem is not the driver, but
> > when the driver is instantiated. It seems radical to remove a driver
> > just because it loads at the wrong time. Ideally you want the driver
> > to figure out now is not a good time and return -EPROBE_DEFER, because
> > a resource it requires it not available.
> 
> Ok, I'm open to suggestions.
> Any ideas on how exactly to figure out when it's a good time to probe
> or return -EPROBE_DEFER instead?

Vladimir already said:

> > > We need to know what resource belonging to the switch is it that the
> > > MDIO mux needs.

Please answer that question. Once we know what the resource is, we can
look at how to export it to the mux in a way that is safe.

       Andrew
