Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C6E638D5D
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiKYPSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiKYPSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:18:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4CF201B4
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jGt7aDpH7VeQLn0sa4Vj1A041Daz/T4Q3Jqb56p4L/c=; b=ub+kvE4AfHjMcZTFpacR5De3e3
        TQT4FO3cW5R18encH3YYCmDUe4Aek9wlyIvXH5lp7GkAwX7QUFS7gJS7Sc869UWABjkU0IizyfuAI
        NLfxT6jg6FxIh1cVO2ZVF2DeOSau+hjZorjE+iBBNeWBFDksEAfs97ryChB5KfDJbJEA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oyaSf-003RXv-4z; Fri, 25 Nov 2022 16:17:53 +0100
Date:   Fri, 25 Nov 2022 16:17:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Xu Liang <lxu@maxlinear.com>
Subject: Re: GPY215 PHY interrupt issue
Message-ID: <Y4DcoTmU3nWqMHIp@lunn.ch>
References: <fd1352e543c9d815a7a327653baacda7@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd1352e543c9d815a7a327653baacda7@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 03:44:08PM +0100, Michael Walle wrote:
> Hi,
> 
> I've been debugging an issue with spurious interrupts and it turns out
> the GYP215 (possibly also other MaxLinear PHYs) has a problem with the
> link down interrupt. Although the datasheet mentions (and which common
> sense) a read of the interrupt status register will deassert the
> interrupt line, the PHY doesn't deassert it right away. There is a
> variable delay between reading the status register and the deassertion
> of the interrupt line. This only happens on a link down event. The
> actual delay depends on the firmware revision and is also somehow
> random. With FW 7.71 (on a GPY215B) I've meassured around 40us with
> FW 7.118 (GPY215B) it's about 2ms.

So you get 2ms of interrupt storm? Does the interrupt status bit clear
immediately, or does that clear only once the interrupt line itself
has cleared? I'm assuming it clears immediately, otherwise you would
add a polling loop.

> It also varies from link down to
> link down. The issue is also present in the new GPY215C revision.
> MaxLinear confirmed the issue and is currently working on a firmware
> fix. But it seems that the issue cannot really be resolved. At best,
> the delay can be minimized. If there will be a fix, this is then
> only for a GPY215C and a new firmware version.
> 
> Does anyone have an idea of a viable software workaround?

Looking at the datasheet for the GPY215, the interrupt line is also
GPIO 14. Could you flip it into a GPIO, force it inactive, and sleep
to 2ms? Or even turn it into an input and see if you can read its
state and poll it until it clears?

   Andrew
