Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FB76D0013
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjC3Jqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjC3JqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:46:15 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121AB8699;
        Thu, 30 Mar 2023 02:45:52 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6F1121C000D;
        Thu, 30 Mar 2023 09:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680169551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8DcFbRjA6OLnfowxommhv/QB/ro2DTlI/VFsp0ilEL0=;
        b=i4an1KmiqVszoBaZHSPjH6Lw8y1yP2g1Wur7RHMV8u8ljZJW2DmrAUt9O26Xm95eFMr/Pv
        S+wefPljVBNzWm5/0pdC61aIDmJFyU1aKjSNZsHrsa3EdGhxrLnAFlc4bFmSTUgoc8XV21
        fkZON+6eKxut4rKl3Dy9tmhtGKQIkde0iGrL/JrzHqIepqot8eftODrQSaeCTRpZcFxiE/
        ezhSvnZbu4JOtLOJnCYvCozTHZJPwIhpsrcNmUQ1LELqsvSLoXJhI03pH6gznSUzqT0YxS
        jRICZftmpRy32uWFmow9iU9xIrBYL2DasxCQF88sZRyjnTAZvBV+/4EJYq+Vgg==
Date:   Thu, 30 Mar 2023 11:45:46 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rafael@kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [RFC 2/7] regmap: check for alignment on translated register
 addresses
Message-ID: <20230330114546.13472135@pc-7.home>
In-Reply-To: <ZB3xJ4/FTEwHyVyY@sirena.org.uk>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
        <20230324093644.464704-3-maxime.chevallier@bootlin.com>
        <ZB3xJ4/FTEwHyVyY@sirena.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Mark,

On Fri, 24 Mar 2023 18:51:19 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Fri, Mar 24, 2023 at 10:36:39AM +0100, Maxime Chevallier wrote:
> > With regmap->reg_base and regmap->reg_downshift, the actual register
> > address that is going to be used for the next operation might not
> > be the same as the one we have as an input. Addresses can be offset
> > with reg_base and shifted, which will affect alignment.
> > 
> > Check for alignment on the real register address.  
> 
> It is not at all clear to me that the combination of stride and
> downshift particularly makes sense, and especially not that the
> stride should be applied after downshifting rather than to what
> the user is passing in.

I agree on the part where the ordering of "adding and offset, then
down/upshifting" isn't natural. This is the order in which operations
are done today, and from what I could gather, only the ocelot-spi MFD
driver uses both of these operations.

It would indeed make sense to first shift the register to have the
proper spacing between register addresses, then adding the offset.

So maybe we should address that in ocelot-spi in the next iteration,
Colin, would you agree ?

Thanks,

Maxime
