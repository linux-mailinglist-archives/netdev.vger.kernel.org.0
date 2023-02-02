Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01912687E80
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbjBBNWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 08:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbjBBNWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 08:22:12 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708D88D409;
        Thu,  2 Feb 2023 05:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2J2GN+eHfYnJJb4luanL3FzdOaKZ0fJUF8VlKIVXn5U=; b=bb1ZE6Sgp02KlHwfuoPQ6GrHRf
        UWYyBZttb0ZwiE/lKnLhlyw5CPgi53sAGsQ/yA6ABTTsnMLh/EalusT1ViKGaYi9EN1oUD8al5MIh
        HeH95gvuESjcRNk8RZ0om/PFxzY4PF4CF1JJbpfwZ+odhCcjKtkuINr7BXdIy22CgCGo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNZWn-003tfq-LO; Thu, 02 Feb 2023 14:21:25 +0100
Date:   Thu, 2 Feb 2023 14:21:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Bernhard Walle <bernhard@bwalle.de>, Wei Fang <wei.fang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] net: fec: do not double-parse
 'phy-reset-active-high' property
Message-ID: <Y9u41VrbFeqjg+3n@lunn.ch>
References: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
 <20230201215320.528319-2-dmitry.torokhov@gmail.com>
 <Y9rtil2/y3ykeQoF@lunn.ch>
 <Y9r0EWOZbiBvkxj0@google.com>
 <Y9sM9ZMkvjlaFPdt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9sM9ZMkvjlaFPdt@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 05:08:05PM -0800, Dmitry Torokhov wrote:
> On Wed, Feb 01, 2023 at 03:21:53PM -0800, Dmitry Torokhov wrote:
> > On Wed, Feb 01, 2023 at 11:54:02PM +0100, Andrew Lunn wrote:
> > > On Wed, Feb 01, 2023 at 01:53:20PM -0800, Dmitry Torokhov wrote:
> > > > Conversion to gpiod API done in commit 468ba54bd616 ("fec: convert
> > > > to gpio descriptor") clashed with gpiolib applying the same quirk to the
> > > > reset GPIO polarity (introduced in commit b02c85c9458c). This results in
> > > > the reset line being left active/device being left in reset state when
> > > > reset line is "active low".
> > > > 
> > > > Remove handling of 'phy-reset-active-high' property from the driver and
> > > > rely on gpiolib to apply needed adjustments to avoid ending up with the
> > > > double inversion/flipped logic.
> > > 
> > > I searched the in tree DT files from 4.7 to 6.0. None use
> > > phy-reset-active-high. I'm don't think it has ever had an in tree
> > > user.
> 
> FTR I believe this was added in 4.6-rc1 (as 'phy-reset-active-low' in
> first iteration by Bernhard Walle (CCed), so maybe he can tell us a bit
> more about hardware and where it is still in service and whether this
> quirk is still relevant.
> 
> > > 
> > > This property was marked deprecated Jul 18 2019. So i suggest we
> > > completely drop it.
> > 
> > I'd be happy kill the quirk in gpiolibi-of.c if that is what we want to
> > do, although DT people sometimes are pretty touchy about keeping
> > backward compatibility.

Generally, that is for in kernel users. When a new feature is added,
you are also supposed to add an in kernel user. I could of missed it
in my search, but i didn't find an in-kernel user. If there is one,
then we should keep it. Otherwise, i would remove it.

> > I believe this should not stop us from merging this patch though, as the
> > code is currently broken when this deprecated property is not present.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
