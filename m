Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1857D60F6DC
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbiJ0MKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbiJ0MKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:10:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBE9C770;
        Thu, 27 Oct 2022 05:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UbrorHxjgzyWbWmyo9e7FtpsOHgSgay7NTrAxgHSw9I=; b=e935+JrxMWPMNbRRtFmmNCi7Gk
        xrtVCipZvb0R4GUc7qh7uNUErCgajtfzoqYfbO0acfEa1bzhzLGAavJPare0BENmY4sIkqmVwar29
        GXhTx7QCQfeFhyS+EyaYMhlTwyEWx9xd1xqV7ElOXz8ZVRac868a1KgYqhJ+Ol8bLGSg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oo1hA-000hfO-Kf; Thu, 27 Oct 2022 14:09:12 +0200
Date:   Thu, 27 Oct 2022 14:09:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Camel Guo <camelg@axis.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Camel Guo <Camel.Guo@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, kernel <kernel@axis.com>
Subject: Re: [RFC net-next 2/2] net: dsa: Add driver for Maxlinear GSW1XX
 switch
Message-ID: <Y1p06HrFMEDP8ud/@lunn.ch>
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-3-camel.guo@axis.com>
 <d942c724-4520-4a7b-8c36-704032c68a36@linaro.org>
 <Y1f5HU9crkPGX3SB@lunn.ch>
 <128467d6-8249-9f25-21a7-777fff9854d9@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <128467d6-8249-9f25-21a7-777fff9854d9@axis.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 08:35:17AM +0200, Camel Guo wrote:
> On 10/25/22 16:56, Andrew Lunn wrote:
> > > > +EXPORT_SYMBOL(gsw1xx_shutdown);
> > > 
> > > 1. EXPORT_SYMBOL_GPL
> > > 2. Why do you do it in the first place? It's one driver, no need for
> > > building two modules. Same applies to other places.
> > 
> > At some point, there is likely to be SPI and UART support. The
> > communication with the chip and the core driver will then be in
> > separate modules. But i agree this is not needed at the moment when it
> > is all linked into one.
> 
> Do you suggest that currently we put the content of gsw1xx_core.c and
> gsw1xx_mdio.c into one file and split them later at the time when another
> management mode (e,g: spi) is added?

No, keep them separate. But you can remove the module exports, and
just link them together at compile time into one module. For forward
compatibility, call that module gsw1xx_mdio.ko. In the future,
somebody can then split it apart again, add gsw1xx_spi.ko, and module
dependencies should cause the gsw1xx_core.ko to be loaded first.

     Andrew
