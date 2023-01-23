Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314DD67872A
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjAWUFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbjAWUFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:05:46 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AC3A3;
        Mon, 23 Jan 2023 12:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eSXzCNP2m7XO3Q0w7LbwozM/JBHPoSDhldEqmNy7mfU=; b=E0JYPM2fQ6rNWoUtAtkJC3kua3
        6CqKEyQMh4x1iyTEtZCgqInf0YAv8fSwBdpT3+/6HPyy6oI4KILB5y/LI3cil6amR5r/D8gWPgeoG
        lzJTzZxclfZ/iJx+1rM1tLifDotLWdGeri/O9W9i+8rpBKAHqsYMorHIV2V20c0P2KrE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pK34F-002wlY-Th; Mon, 23 Jan 2023 21:05:23 +0100
Date:   Mon, 23 Jan 2023 21:05:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Michael Walle <michael@walle.cc>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] net: phy: C45-over-C22 access
Message-ID: <Y87og1SIe1OsoLfU@lunn.ch>
References: <20230120224011.796097-1-michael@walle.cc>
 <Y87L5r8uzINALLw4@lunn.ch>
 <Y87WR/T395hKmgKm@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y87WR/T395hKmgKm@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> C45-over-C22 is a PHY thing, it isn't generic. We shouldn't go poking
> at the PHY C45-over-C22 registers unless we know for certain that the
> C22 device we are accessing is a PHY, otherwise we could be writing
> into e.g. a switch register or something else.

Humm, yes. Good point.

> The problem comes with PHYs that maybe don't expose C22 ID registers
> but do have C45-over-C22.
> 
> Given that, it seems that such a case could not be automatically
> probed, and thus must be described in firmware.

We already have the compatible:

      - const: ethernet-phy-ieee802.3-c45
        description: PHYs that implement IEEE802.3 clause 45

But it is not clear what that actually means. Does it mean it has c45
registers, or does it mean it supports C45 bus transactions?

If we have that compatible, we could probe first using C45 and if that
fails, or is not supported by the bus master, probe using C45 over
C22. That seems safe. For Michael use case, the results of
mdiobus_prevent_c45_scan(bus) needs keeping as a property of bus, so
we know not to perform the C45 scan, and go direct to C45 over C22.

   Andrew
