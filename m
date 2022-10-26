Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D4160E050
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbiJZMI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbiJZMIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:08:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47498DED13;
        Wed, 26 Oct 2022 05:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=B/Gu8lEakeE0xZHUuCf+CKOgyX/EB7IG70Xl2GMpx+4=; b=tVG/8D65+b6EPoGSurRmyoakPV
        k/z/kQVzFoO6BOAhXTAiYYKN12ad/IH+vJaD+fvSYYOFW81JmqxoRjYhDEiWPAK57JOK8HlPGn7wG
        qf0CYIasYqAaMpVTdPUIIRb1kYgLgpkbDzAelOz0d0KvV68XH3hIfLdsnRK65bU1BwL8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1onf9x-000cVd-SM; Wed, 26 Oct 2022 14:05:25 +0200
Date:   Wed, 26 Oct 2022 14:05:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Sean Anderson <seanga2@gmail.com>, davem@davemloft.net,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/5] net: pcs: add new PCS driver for altera
 TSE PCS
Message-ID: <Y1kihVfwglzOD2uE@lunn.ch>
References: <20220901143543.416977-1-maxime.chevallier@bootlin.com>
 <20220901143543.416977-4-maxime.chevallier@bootlin.com>
 <68b3dfbf-9bab-2554-254e-bffd280ba97e@gmail.com>
 <20221026113711.2b740c7a@pc-8.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026113711.2b740c7a@pc-8.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +	/* This PCS seems to require a soft reset to re-sync the
> > > AN logic */
> > > +	tse_pcs_reset(tse_pcs);  
> > 
> > This is kinda strange since c22 phys are supposed to reset the other
> > registers to default values when BMCR_RESET is written. Good thing
> > this is a PCS...
> 
> Indeed. This soft reset will not affect the register configuration, it
> will only reset all internal state machines.
> 
> The datasheet actually recommends performing a reset after any
> configuration change...

The Marvell PHYs work like this. Many of its registers won't take
effect until you do a soft reset. I think the thinking behind this is
that changing many registers is disruptive to the link and slow. It
takes over a second to perform auto-neg etc. So ideally you want to
make all your register changes, and then trigger them into operation.
And a soft reset is this trigger.

    Andrew
