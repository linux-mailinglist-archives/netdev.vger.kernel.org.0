Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B709D6A5B18
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 15:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjB1Ouq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 09:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjB1Oup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 09:50:45 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158E51C7CA
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 06:50:23 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 49233240006;
        Tue, 28 Feb 2023 14:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677595822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/7dErYA60coygNuAXQosuA1EsuEoxO0/al6K+1d2DzE=;
        b=LzfZZaBmsr0iEN9qguPe55C6XJoZvWEGGbobnaZWYXuUS23ZOlix/LBFySoRxftY+bzGiA
        Rs0uguJ7jLPOqwuB1JYyJ7Vkf7fW8R0LPjkY2Kvc2NKQSHXGWzco+Gaf4ml5sepFLytL3V
        AqC4BzOQ4XbE6OfHKvZfdhmSEuW/jVH/izGdqQ1eLAtfw/4IE+CnXJToTsV5C0G9zf0SMD
        DIi2hhifKOCGbSX9H+s2XDI9XTHnXEseLzuVJrKBXgsGm2r6sFJe1uJD8lJEmpHlDlK++A
        2qTrfsrnSwdaWUxv1UWhgS8Ik06RtiIzqKhW1vp6kksdrAjLX3UO6u7/B7JCzQ==
Date:   Tue, 28 Feb 2023 15:50:16 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>, andrew@lunn.ch,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230228155016.163e97a7@kmaincent-XPS-13-7390>
In-Reply-To: <Y/4DZIDm1d74MuFJ@shell.armlinux.org.uk>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
        <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
        <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
        <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
        <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
        <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
        <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
        <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
        <Y/4DZIDm1d74MuFJ@shell.armlinux.org.uk>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Feb 2023 13:36:36 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> > Also your series rise the question of which timestamping should be the
> > default, MAC or PHY, without breaking any past or future compatibilitie=
s.
> > There is question of using Kconfig or devicetree but each of them seems=
 to
> > have drawbacks:
> > https://lore.kernel.org/netdev/ad4a8d3efbeaacf241a19bfbca5976f9@walle.c=
c/=20
> >=20
> > Do you or Russell have any new thought about it? =20
>=20
> The only thought I have is that maybe a MAC driver should be able to
> override the default, then at least we have a way to deal with this
> on a case by case basis. However, that's just pulling an idea out of
> the air.
>
> I think what might be useful as a first step is to go through the
> various networking devices to work out which support PTP today, and
> tabulate the result. There shouldn't be any cases where we have both
> the MAC and PHY having PTP support (for the API reasons I've already
> stated) but if there are, that needs to be highlighted.

The only defconfig on that case present on mainline is socfpga_defconfig
(MICREL_PHY and STMMAC_ETH). In fact PHY timestamping is really not spread.
There is only one defconfig which support PTP on both MAC and PHY, therefore
setting the PTP on MAC by default seems the best choice. It won't change the
default behavior when adding new PHY PTP support. Does adding documentation
about socfpga_defconfig is sufficient or should we need to add something
specific to change the default PTP on this case.

Regards,
K=C3=B6ry
