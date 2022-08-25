Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6350A5A1C51
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244427AbiHYW2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241475AbiHYW2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:28:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15831C650A;
        Thu, 25 Aug 2022 15:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TzSF9Nx97qC9blU02IXnLbQBZ40ShDBnKmwNr3Z6Bk4=; b=fSTUbUh/o3ffVnDRNXg3t1783U
        9E2qTDsmLQgIxPpL+1L8OPE98MuEEAz15OokSVS08/izSEfHJtHgEBYPSuEFRhXatkI8c6Zr0DN+S
        Pc9er+3sNBzt8X6VPpz4XtuviOOuiEKKGWPAznhY3+qmDLiTbm+Bvu24wU4xyNY7LOb8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRLKJ-00Ec76-Qv; Fri, 26 Aug 2022 00:27:51 +0200
Date:   Fri, 26 Aug 2022 00:27:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 1/7] dt-bindings: net: pse-dt: add bindings
 for generic PSE controller
Message-ID: <Ywf3Z+1VFy/2+P78@lunn.ch>
References: <20220825130211.3730461-1-o.rempel@pengutronix.de>
 <20220825130211.3730461-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825130211.3730461-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  ieee802.3-pairs:
> +    $ref: /schemas/types.yaml#/definitions/int8-array
> +    description: Array of number of twisted-pairs capable to deliver power.
> +      Since not all circuits are able to support all pair variants, the array of
> +      supported variants should be specified.
> +      Note - single twisted-pair PSE is formally know as PoDL PSE.
> +    items:
> +      enum: [1, 2, 4]

It is not clear to me what you are describing here. It looks like the
number of pairs? That does not seem like a hardware property. The
controller itself should be able to tell you how many pairs it can
feed.

A hardware property would be which pairs of the socket are connected
to a PSE and so can be used to deliver power. But i'm not sure how
that would be useful to know. I suppose a controller capable of
powering 4 pair, but connected to a socket only wired to supply 2, can
then disable 2 pairs?

> +
> +  ieee802.3-pse-type:
> +    $ref: /schemas/types.yaml#/definitions/uint8
> +    minimum: 1
> +    maximum: 2
> +    description: PSE Type. Describes classification- and class-capabilities.
> +      Not compatible with PoDL PSE Type.
> +      Type 1 - provides a Class 0, 1, 2, or 3 signature during Physical Layer
> +      classification.
> +      Type 2 - provides a Class 4 signature during Physical Layer
> +      classification, understands 2-Event classification, and is capable of
> +      Data Link Layer classification.

Again, the controller should know what class it can support. Why do we
need to specify it?  What could make sense is we want to limit the
controller to a specific type? 

> +  ieee802.3-podl-pse-class:
> +    $ref: /schemas/types.yaml#/definitions/int8-array
> +    items:
> +      enum: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
> +    description: PoDL PSE Class. Array of supported classes by the
> +      single twisted-pair PoDL PSE.

Why? I could understand we might want to limit the higher classes,
because the board is not designed for them, but the controller on the
board can actually offer them. But if it tries to use them, the board
will melt/blow a fuse.

So i'm wondering if it should actually be something like:

> +  ieee802.3-podl-limit-pse-classes:
> +    $ref: /schemas/types.yaml#/definitions/int8-array
> +    items:
> +      enum: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
> +    description: PoDL PSE Class. Limit the PoDL PSE to only these classes,
         due to hardware design limitations. If not specified, the PoDL PSE
	 will offer all classes its supports.

Remember, DT describes the hardware, not software configuration of the
hardware.

	Andrew
