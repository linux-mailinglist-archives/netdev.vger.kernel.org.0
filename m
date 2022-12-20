Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7996652160
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbiLTNWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiLTNV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:21:56 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D91B16496;
        Tue, 20 Dec 2022 05:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yG9JT2qsJ2n+skS1+0XzJ/VYZa3AXEt7ITVQuCUV1C0=; b=aT1aKF06u3GCpyS2nN5Mip9dok
        7cSBZ4usFrAq3Yov6E7gOReOYM8xYez4xHpA1TM4NAuF8rJRxO9Oecfjkld/zx9V0q/yDNGViyN76
        SC3ywvArxUg2Z20BmlXsd+vGOkgWYdNY2YFOoQ+i7scdGE6Kde4jnaTg4YMVLJESGNPU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7cYk-0005b6-06; Tue, 20 Dec 2022 14:21:30 +0100
Date:   Tue, 20 Dec 2022 14:21:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>, Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
Message-ID: <Y6G22e06gQ2+kM+G@lunn.ch>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-4-michael@walle.cc>
 <20221205212924.GA2638223-robh@kernel.org>
 <99d4f476d4e0ce5945fa7e1823d9824a@walle.cc>
 <9c0506a6f654f72ea62fed864c1b2a26@walle.cc>
 <2597b9e5-7c61-e91c-741c-3fe18247e27c@linaro.org>
 <6c82b403962aaf1450eb5014c9908328@walle.cc>
 <796a528b23aded95c1a647317c277b1f@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <796a528b23aded95c1a647317c277b1f@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  (2) Krzysztof pointed out that there is still the issue raised by
>      Rob, that the schemas haven't any compatible and cannot be
>      validated. I think that applies to all the network PHY bindings
>      in the tree right now. I don't know how to fix them.

i've been offline for a while, i sabotaged my own mail server...

You can always add an unneeded compatible, using the PHY devices ID:

      - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
        description:
          If the PHY reports an incorrect ID (or none at all) then the
          compatible list may contain an entry with the correct PHY ID
          in the above form.
          The first group of digits is the 16 bit Phy Identifier 1
          register, this is the chip vendor OUI bits 3:18. The
          second group of digits is the Phy Identifier 2 register,
          this is the chip vendor OUI bits 19:24, followed by 10
          bits of a vendor specific ID.

It would be fine to do this in the example in the binding, but i would
add a comment something like:

"Compatible generally only needed to make DT lint tools work. Mostly
not needed for real DT descriptions"

Examples often get cut/paste without thinking, and we don't really
want the compatible used unless it is really needed.

This is however a bigger problem than just PHYs. It applies to any
device which can be enumerated on a bus, e.g. USB, PCI. So maybe this
limitation of the DT linting tools should be fixed once at a higher
level?

>  (3) The main problem with the broken interrupt handling of the PHY
>      is that it will disturb other devices on that interrupt line.
>      IOW if the interrupt line is shared the PHY should fall back
>      to polling mode. I haven't found anything in the interrupt
>      subsys to query if a line is shared and I guess it's also
>      conceptually impossible to do such a thing, because there
>      might be any driver probed at a later time which also uses
>      that line.
>      Rob had the idea to walk the device tree and determine if
>      a particular interrupt is used by other devices, too. If
>      feasable, this sounds like a good enough heuristic for our
>      problem. Although there might be some edge cases, like
>      DT overlays loaded at linux runtime (?!).

My humble opinion is that it is not worth the complexity for just one
PHY which should work in polling mode without problems. I think the
boolean property you propose is KISS and does what is needed.

	Andrew

