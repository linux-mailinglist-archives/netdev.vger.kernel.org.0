Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6686AA59C
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 00:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjCCX3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 18:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCCX3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 18:29:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154043A851
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 15:29:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C84D6B81928
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 23:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3C1C4339B;
        Fri,  3 Mar 2023 23:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677886137;
        bh=Mc/i4nO3OoOhgYlqRTsI8DqVkrOnmuiXyLo29wHohNc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AEVoUEvdxtj/yv4Ah2V/jMesawEKZxYqvJKCyJ1JvZ4K0ShtO0EXpUQVEmYj6nTA9
         GHCci278ugwI8RiMyJy2WAciI0GK+THNUPMKmILZIsjtu3Cna597BTzIC91+cCyHSM
         KzA7cSVAvAJ37pj3RfhuY8CJ5+hP6l7RU6t5XkqAY4IhroeQkWpIr5LXkP5ckoD9KG
         EfQ5aaLqjyU/z/tEVnROZX5eQbUyxF73SU3fizk71Nrjf7wrANvPTgztunEbVQU8LF
         wETriSDpJMFmq59o5KQ0on1GJi519qXPnQnnND7sX1X/7Wdk+36sayPDDvwL03U/+m
         zMWZ3knf/un/Q==
Date:   Fri, 3 Mar 2023 15:28:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>, andrew@lunn.ch,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230303152855.23588b39@kernel.org>
In-Reply-To: <20230303141247.4acd6863@kmaincent-XPS-13-7390>
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
        <20230303141247.4acd6863@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Mar 2023 14:12:47 +0100 K=C3=B6ry Maincent wrote:
> > Do you happen to have a datasheet for MACB? The time stamping
> > capability is suspiciously saved in a variable called hw_dma_cap
> > which may indicate it's a DMA time stamp not a true PTP stamp.
> >=20
> > Quite a few NICs/MACs support DMA time stamps because it's far=20
> > easier to take the stamp where the descriptor writing logic is
> > (DMA block) than take it at the end of the MAC and haul it all=20
> > the way thru the pipeline back to the DMA block. =20
>=20
> I don't have the datasheet but indeed you seem to have right. From the su=
pport
> commit message:=20
> > Time stamps are obtained from the dma buffer descriptors =20

That's just saying that the time stamp is communicated via=20
a descriptor rather than a register, so not a strong proof=20
of where it's taken.

> I suppose it is less precise as using true PTP stamp as it is an hardware=
 block
> further. Is that right?
