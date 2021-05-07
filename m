Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838EF375DC4
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbhEGAC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232375AbhEGAC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 20:02:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98D0F61164;
        Fri,  7 May 2021 00:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620345719;
        bh=OnZ8E8ucGobRrYWP6K56v9dvJ/+sAsK5BzaPSU1d9Hw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qrq87rGu4EWRk54rAiG8OLLqbwFB/dWuNDBn62M5RZNh3UJCJI1Q59HJ3pkcVgyXD
         cDFRZ1qM3AMzx6C7gNZa8L4/eBy3KNBeTxsbZbUABpmWrelr8bK+YfdKtpE8va3Zbr
         cpdtOpVPLGHsQp3UXfts6yiYW2e1DCGSoe3cK+o800KztRvgb4X3ReGtU3+iXepEfD
         XCxKkXLFNUXYEO2+X0vhgLvgPmBSQBvWItsnmtwQal2imL5tWAEnO6dt7tdLB1bjgb
         gdOJqRCShFO9vsirw1I0nFHO8bFeXO2DhArIaCQFclNfxiV9i8LstLgk0jVdlMIYoo
         mAG1OpKJMfGnw==
Date:   Thu, 6 May 2021 17:01:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RESEND PATCH v11 0/3] AX88796C SPI Ethernet Adapter
Message-ID: <20210506170157.6deb1b6d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dleftjim3x2jhw.fsf%l.stelmach@samsung.com>
References: <20210302152250.27113-1-l.stelmach@samsung.com>
        <CGME20210505171151eucas1p15785129622c00205d1d071a2fcaa30e8@eucas1p1.samsung.com>
        <dleftjim3x2jhw.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 05 May 2021 19:11:39 +0200 =C5=81ukasz Stelmach wrote:
> It was <2021-03-02 wto 16:22>, when =C5=81ukasz Stelmach wrote:
> > This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
> > found on ARTIK5 evaluation board. The driver has been ported from a
> > v3.10.9 vendor kernel for ARTIK5 board.
> >
> > Changes in v11:
> >   - changed stat counters to 64-bit
> >   - replaced WARN_ON(!mutex_is_locked()) with lockdep_assert_held()
> >   - replaced ax88796c_free_skb_queue() with __skb_queue_purge()
> >   - added cancel_work_sync() for ax_work
> >   - removed unused fields of struct skb_data
> >   - replaced MAX() with max() from minmax.h
> >   - rebased to net-next (resend) =20
>=20
> Hi,
>=20
> What is current status? Should I rebase once more?

Unfortunately it seems so :( The patches got marked as Not Applicable
in patchwork. And now we are once again in the merge window period.
Please repost late next week, and make sure to prefix the subjects with
[PATCH net-next v12], this will hopefully prevent mis-categorization.

Looking at the code again is the use of netif_stop_queue(ndev) in
ax88796c_close() not a little racy? The work may be running in parallel=20
and immediately re-enable the queue.
