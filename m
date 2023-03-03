Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7BB6A982B
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 14:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCCNMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 08:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCCNMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 08:12:53 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1146D10F0
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 05:12:50 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B0F4D40008;
        Fri,  3 Mar 2023 13:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677849169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AMNOjpgLvxddvR7qOB5Du1EiUOiGDc9UQlYsmboXaHQ=;
        b=pfsBTnwpjwcM61jFyMeZD6IInl0x/+LNflQLYEMH+JDo421N3Yn9LxIJn9N88wvAsa1sWT
        mJU2fsaMyV7H7tjV9Ns0GtpE/ivaE445R1vjq8gN7iVdlRQis/SUpqrsFxTbz9iK4TSwo+
        BwToQR3toSfaWTXgTxOd5SJnPXLhWR6NsSn05uDY6ANFmvuvxDETlnUcFnyl8+p0oac18y
        zbnXeAL1/lWHyLXUdMgNMogX5CAFF2Bq4xJG3c7WWqNkosUJJ1VzkEqSovuIMNagK5QVtO
        r3zlJ3rb3D22cMRx7KkzVgzJjLkdJXZ1viF2NbQfmWazd0CwhVrkkoO7k2u+9Q==
Date:   Fri, 3 Mar 2023 14:12:47 +0100
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
Message-ID: <20230303141247.4acd6863@kmaincent-XPS-13-7390>
In-Reply-To: <20230302092320.6ee8eb6d@kernel.org>
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
        <20230302180616.7bcfc1ef@kmaincent-XPS-13-7390>
        <20230302092320.6ee8eb6d@kernel.org>
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

On Thu, 2 Mar 2023 09:23:20 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> Do you happen to have a datasheet for MACB? The time stamping
> capability is suspiciously saved in a variable called hw_dma_cap
> which may indicate it's a DMA time stamp not a true PTP stamp.
>=20
> Quite a few NICs/MACs support DMA time stamps because it's far=20
> easier to take the stamp where the descriptor writing logic is
> (DMA block) than take it at the end of the MAC and haul it all=20
> the way thru the pipeline back to the DMA block.

I don't have the datasheet but indeed you seem to have right. From the supp=
ort
commit message:=20
> Time stamps are obtained from the dma buffer descriptors

I suppose it is less precise as using true PTP stamp as it is an hardware b=
lock
further. Is that right?

Regards,
K=C3=B6ry
