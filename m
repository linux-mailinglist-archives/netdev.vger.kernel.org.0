Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F9266E028
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjAQOSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjAQOSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:18:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49B232525;
        Tue, 17 Jan 2023 06:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=CuPv93sa7yWnhCr7phi4YYBcFmYzOL9AGESZb0EF/hg=; b=xM
        kD7ilRG02s9MXrk3pVr/vC7cP7JdgHf3M8jyj2xvRTWDbdhHDVbfuMitFSooiAcfDi8i3BtvAO7l/
        2xBXAByUa0Mx8EoJKzo30ef5Ojdr060AeZpR+2sUyTSkdvhoBHvP7QAibK9CitCOpYa55EZPNuoJc
        gT9erI8B6DyT4I0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHmmg-002KWT-78; Tue, 17 Jan 2023 15:17:54 +0100
Date:   Tue, 17 Jan 2023 15:17:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     Pierluigi Passaro <pierluigi.p@variscite.com>,
        Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eran.m@variscite.com" <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH v2] net: fec: manage corner deferred probe condition
Message-ID: <Y8auEsy7j2LBFmzE@lunn.ch>
References: <20230115213804.26650-1-pierluigi.p@variscite.com>
 <Y8R2kQMwgdgE6Qlp@lunn.ch>
 <CAJ=UCjXvcpV9gAfXv8An-pp=CK8J=sGE_adAoKeNFG1C-sMgJA@mail.gmail.com>
 <Y8STz5eOoSPfkMbU@lunn.ch>
 <AM6PR08MB43761CFA825A9B4A2E68D29EFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <Y8VuBbINetkFwQzY@lunn.ch>
 <AM6PR08MB437621FD8AE1B6BEDF192958FFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <DB9PR04MB810698A50D6B7FD205E69B1B88C69@DB9PR04MB8106.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB9PR04MB810698A50D6B7FD205E69B1B88C69@DB9PR04MB8106.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 05:54:21AM +0000, Wei Fang wrote:
> > -----Original Message-----
> > From: Pierluigi Passaro <pierluigi.p@variscite.com>
> > Sent: 2023年1月17日 4:23
> > To: Andrew Lunn <andrew@lunn.ch>
> > Cc: Pierluigi Passaro <pierluigi.passaro@gmail.com>; Wei Fang
> > <wei.fang@nxp.com>; Shenwei Wang <shenwei.wang@nxp.com>; Clark Wang
> > <xiaoning.wang@nxp.com>; dl-linux-imx <linux-imx@nxp.com>;
> > davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> > pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> > eran.m@variscite.com; Nate Drude <Nate.D@variscite.com>; Francesco
> > Ferraro <francesco.f@variscite.com>
> > Subject: Re: [PATCH v2] net: fec: manage corner deferred probe condition
> > 
> > On Mon, Jan 16, 2023 at 4:32 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > > This is the setup of the corner case:
> > > > - FEC0 is the owner of MDIO bus, but its own PHY rely on a "delayed"
> > > > GPIO
> > > > - FEC1 rely on FEC0 for MDIO communications The sequence is
> > > > something like this
> > > > - FEC0 probe start, but being the reset GPIO "delayed" it return
> > > > EPROBE_DEFERRED
> > > > - FEC1 is successfully probed: being the MDIO bus still not owned,
> > > > the driver assume
> > > >   that the ownership must be assigned to the 1st one successfully
> > > > probed, but no
> > > >   MDIO node is actually present and no communication takes place.
> > >
> > > So semantics of a phandle is that you expect what it points to, to
> > > exists. So if phy-handle points to a PHY, when you follow that pointer
> > > and find it missing, you should defer the probe. So this step should
> > > not succeed.
> > >
> > I agree with you: the check is present, but the current logic is not consistent.
> > Whenever the node owning the MDIO fails the probe due to
> > EPROBE_DEFERRED, also the second node must defer the probe, otherwise no
> > MDIO communication is possible.
> > That's why the patch set the static variable wait_for_mdio_bus to track the
> > status.
> > > > - FEC0 is successfully probed, but MDIO bus is now assigned to FEC1
> > > >   and cannot  and no communication takes place
> > >
> 
> Have you tested that this issue also exists on the net tree? According to your
> description, I simulated your situation on the net tree and tested it with imx6ul,
> but the problem you mentioned does not exist. Below is is my test patch.

Hi Wei

Reading the emails from Pierluigi, i don't get the feeling he really
understands the problem and has got to the root cause. I've not seen a
really good, detailed explanation of what is going wrong.

       Andrew
