Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87036A8783
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 18:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCBRGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 12:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCBRGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 12:06:21 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0F63E638
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 09:06:19 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D46354000C;
        Thu,  2 Mar 2023 17:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677776778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7OxCSAS5AYzV8pl7UsWlzTATitYRoOqLZklO4rA7x6A=;
        b=nwY7OBbcIBFNr46ZOhvGSpnqvd8/OYO52uPZ0V2dfcUqaJcYwcoNpkFAQXkU9C2gNSsl1A
        GgB1HUBq9SAeMObs+BhSxaIjYkEfdaym4fkylCbJOSHhzSGTEFtQhAQoftvme+9GDIHKMM
        6MyKfZ88maYXKGAST1mipye23M7T+WEUE5cVjoN7fcLO4iOMH/ZlihvQwtxCzFO7JCEh2i
        jFKjwTg0Cl1XyQCIWep0v/yv+lBFXYxvIMSVoQirZ7wNTFEJV5Aob5e9Hh58xtsWJIE3N3
        4ocGnBbOyOeVbjVVENoiHLryLsqPvRhjDFznqhYOGDs4DK5o695IHbMBbQHkJA==
Date:   Thu, 2 Mar 2023 18:06:16 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>, andrew@lunn.ch,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230302180616.7bcfc1ef@kmaincent-XPS-13-7390>
In-Reply-To: <20230302084932.4e242f71@kernel.org>
References: <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
        <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
        <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
        <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
        <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
        <20230228142648.408f26c4@kernel.org>
        <Y/6Cxf6EAAg22GOL@shell.armlinux.org.uk>
        <20230228145911.2df60a9f@kernel.org>
        <20230301170408.0cc0519d@kmaincent-XPS-13-7390>
        <ZAAn1deCtR0BoVAm@hoboy.vegasvil.org>
        <ZACNRjCojuK6tcnl@shell.armlinux.org.uk>
        <20230302084932.4e242f71@kernel.org>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Mar 2023 08:49:32 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 2 Mar 2023 11:49:26 +0000 Russell King (Oracle) wrote:
> > (In essence, because of all the noise when trying the Marvell PHY with
> > ptp4l, I came to the conlusion that NTP was a far better solution to
> > time synchronisation between machines than PTP would ever be due to
> > the nose induced by MDIO access. However, I should also state that I
> > basically gave up with PTP in the end because hardware support is
> > overall poor, and NTP just works - and I'd still have to run NTP for
> > the machines that have no PTP capabilities. PTP probably only makes
> > sense if one has a nice expensive grand master PTP clock on ones
> > network, and all the machines one wants to synchronise have decent
> > PTP implementations.) =20
>=20
> Don't wanna waste too much of your time with the questions since
> I haven't done much research but - wouldn't MAC timestamp be a better
> choice more often (as long as it's a real, to-spec PTP stamp)?=20
> Are we picking PHY for historical reasons?
>=20
> Not that flipping the default would address the problem of regressing
> some setups..

I have measured it with the Marvell PHY and MACB MAC but it is the contrary=
 on
my side:
https://lkml.kernel.org/netdev/20230302113752.057a3213@kmaincent-XPS-13-739=
0/
Also PHY default seems more logical as it is nearer to the physical link, b=
ut
still I am interesting by the answer as I am not a PTP expert. Is really PTP
MAC often more precise than PTP PHY?

Regards,
K=C3=B6ry
