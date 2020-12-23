Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535532E13AD
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgLWCdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:33:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730425AbgLWCZP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B6DF229C5;
        Wed, 23 Dec 2020 02:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690299;
        bh=V9hK6tZTtM/ji+HJVscJbz4WI8B3CTyVYiz1PbLvnXs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ai1I5FmyMwx/34XoDqbh8/B7kjykZ6stIWAIe+V3s+WYfduNPH+ih60OzfNepPfyH
         HphN8ATPwIkTxa9g8l+yZtVZzADKQ3KM50IoolkXJTtiKgNF7DXpfsUUrTCfpA1sL0
         goFFYrfRgUDBrtZn1qoG0iCM0nTE6nyoR4jTz4evcCaBFjM4DTIreKLZh98oCA5D5W
         csDV28B0BDh0BpSQdNV/VvGH2EZwEEwrNUxgvBrslU88+9zVegVl0tDS8E41ilIQlY
         MZm8ZHoUuvcVTXyeUwpYDrron12de3fo+9JGifpnb1MBW9NpB2oDSyb0HThxcxf+bh
         2epKPsv9hvfeQ==
Date:   Tue, 22 Dec 2020 18:24:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>
Cc:     Joel Stanley <joel@jms.id.au>,
        John Wang <wangzhiqiang.bj@bytedance.com>,
        xuxiaohan@bytedance.com,
        =?UTF-8?B?6YOB?= =?UTF-8?B?6Zu3?= <yulei.sh@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/ncsi: Use real net-device for response handler
Message-ID: <20201222182458.4651c564@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4a9cab3660503483fd683c89c84787a7a1b492b1.camel@mendozajonas.com>
References: <20201220123957.1694-1-wangzhiqiang.bj@bytedance.com>
        <CACPK8XexOmUOdGmHCYVXVgA0z5m99XCAbixcgODSoUSRNCY+zA@mail.gmail.com>
        <4a9cab3660503483fd683c89c84787a7a1b492b1.camel@mendozajonas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 10:38:21 -0800 Samuel Mendoza-Jonas wrote:
> On Tue, 2020-12-22 at 06:13 +0000, Joel Stanley wrote:
> > On Sun, 20 Dec 2020 at 12:40, John Wang wrote:
> > > When aggregating ncsi interfaces and dedicated interfaces to bond
> > > interfaces, the ncsi response handler will use the wrong net device
> > > to
> > > find ncsi_dev, so that the ncsi interface will not work properly.
> > > Here, we use the net device registered to packet_type to fix it.
> > >=20
> > > Fixes: 138635cc27c9 ("net/ncsi: NCSI response packet handler")
> > > Signed-off-by: John Wang <wangzhiqiang.bj@bytedance.com> =20

This sounds like exactly the case for which orig_dev was introduced.
I think you should use the orig_dev argument, rather than pt->dev.

Can you test if that works?

> > Can you show me how to reproduce this?
> >=20
> > I don't know the ncsi or net code well enough to know if this is the
> > correct fix. If you are confident it is correct then I have no
> > objections. =20
>=20
> This looks like it is probably right; pt->dev will be the original
> device from ncsi_register_dev(), if a response comes in to
> ncsi_rcv_rsp() associated with a different device then the driver will
> fail to find the correct ncsi_dev_priv. An example of the broken case
> would be good to see though.

=46rom the description sounds like the case is whenever the ncsi
interface is in a bond, the netdev from the second argument is=20
the bond not the interface from which the frame came. It should=20
be possible to repro even with only one interface on the system,
create a bond or a team and add the ncsi interface to it.

Does that make sense? I'm likely missing the subtleties here.
