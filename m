Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB12F66DFC7
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjAQOCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjAQOCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:02:02 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B9538EAB;
        Tue, 17 Jan 2023 06:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iSq1n6fp+pgT1otyTi5I8F7lSDNIWrwaaMFHeTyn+qU=; b=1zA/3Nsyc+B66S/JfzShWC0dPM
        6BYykR2G0bL45VrfcDV1kscfdJfvgFWxfLyN7eXcE6OYcNMUkF2z0DUugdVRQHEyuDAYo0mOLd4jI
        zBlm+H+W2e9gCJxoNge2ZPu1vavnmiUnpzSilCsal/AHGPEDNCrVqVhKc2ffZnphN0K0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHmX6-002KQU-Aa; Tue, 17 Jan 2023 15:01:48 +0100
Date:   Tue, 17 Jan 2023 15:01:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pierluigi Passaro <pierluigi.p@variscite.com>
Cc:     Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8aqTHyoFfzMILjl@lunn.ch>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch>
 <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <CAJ=UCjUo3t+D9S=J_yEhxCOo5OMj3d-UW6Z6HdwY+O+Q6JO0+A@mail.gmail.com>
 <Y8SWPwM7V8yj9s+v@lunn.ch>
 <AM6PR08MB437630CD49B50D66543EC3BDFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR08MB437630CD49B50D66543EC3BDFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 09:44:01AM +0000, Pierluigi Passaro wrote:
> On Mon, Jan 16, 2023 at 1:11 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > > IMHO, since the framework allows defining the reset GPIO, it does not sound
> > > reasonable to manage it only after checking if the PHY can communicate:
> > > if the reset is asserted, the PHY cannot communicate at all.
> > > This patch just ensures that, if the reset GPIO is defined, it's not asserted
> > > while checking the communication.
> >
> > The problem is, you are only solving 1/4 of the problem. What about
> > the clock the PHY needs? And the regulator, and the linux reset
> > controller? And what order to do enable these, and how long do you
> > wait between each one?
> >
> Interesting point of view: I was thinking about solving one of 4 problems ;)

Lots of small incremental 'improvements' sometimes get you into a real
mess because you loose track of the big picture. And i do think we are
now in a mess. But i also think we have a better understanding of the
problem space. We know there can be arbitrate number of resources
which need to be enabled before you can enumerate the bus. We need a
generic solution to that problem. And Linux is good at solving a
problem once and reusing it other places. So the generic solution
should be applicable to other bus types.

We also have a well understood workaround, put the IDs in DT. So as
far as i'm concerned we don't need to add more incremental
'improvements', we can wait for somebody to put in the effort to solve
this properly with generic code.

So i don't want to merge this change. Sorry.

	Andrew
