Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1CA431F5A
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhJROV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhJROV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C4D760F25;
        Mon, 18 Oct 2021 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634566757;
        bh=Ysrj0HnwH1dWRKHIMRKUF/VK1Xz0kKbFRDS3gLhRuDI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fC40IPHe9gezq96EdPg7ht2pB4E7AP5w2QeSYZqs72sAWJXT2aF6tJ2tEoRTiFSRg
         U+NqVM3jgTDW1hfZ8nMD/DEkWoy8m6LKDdKWKz0QTKAE+kBk/82jCZCKOMOHMk7jN7
         xOcX1xQPyMhZHehtoTJFD1ta4K1PC+F9z1NPbAG7P9Q8fUDU3tXoqMxR/awW1FV10G
         5dVRVXG3GE0mC1BTzb8aZBWdgLnJZzU6f/QT3q7YPjRl9/lUQyXDh8QiSi8pmNdH0+
         KkLCe1vNofAv/yK+PYxD7rQU75XK14LzaZoGZVROEU7SqZC74/QD8EKuPG5IvccLqa
         1kt6rkej6U3Nw==
Date:   Mon, 18 Oct 2021 07:19:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, vkochan@marvell.com,
        tchornyi@marvell.com
Subject: Re: [RFC net-next 3/6] ethernet: prestera: use
 eth_hw_addr_set_port()
Message-ID: <20211018071915.2e2afdd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <186dd3ec-6bab-fe3c-cbab-a54898d51f57@pensando.io>
References: <20211015193848.779420-1-kuba@kernel.org>
        <20211015193848.779420-4-kuba@kernel.org>
        <186dd3ec-6bab-fe3c-cbab-a54898d51f57@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Oct 2021 14:19:18 -0700 Shannon Nelson wrote:
> On 10/15/21 12:38 PM, Jakub Kicinski wrote:
> > Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> > of VLANs...") introduced a rbtree for faster Ethernet address look
> > up. To maintain netdev->dev_addr in this tree we need to make all
> > the writes to it got through appropriate helpers.
> >
> > We need to make sure the last byte is zeroed.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>

> > @@ -341,8 +342,8 @@ static int prestera_port_create(struct prestera_swi=
tch *sw, u32 id)
> >   	/* firmware requires that port's MAC address consist of the first
> >   	 * 5 bytes of the base MAC address
> >   	 */
> > -	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
> > -	dev->dev_addr[dev->addr_len - 1] =3D port->fp_id;
> > +	memcpy(addr, sw->base_mac, dev->addr_len - 1);
> > +	eth_hw_addr_set_port(dev, addr, port->fp_id); =20
>=20
> Notice in this case I think the original code is setting the last byte=20
> to port->fp_id, found I think by a call to their firmware, not by adding=
=20
> fp_id to the existing byte value.

Yeah, as mentioned in the commit message and discussed with Vladimir.
Notice that the memcpy is (,, size - 1) and the initial buf is zeroed.

> This is an example of how I feel a bit queezy about this suggested=20
> helper: each driver that does something like this may need to do it=20
> slightly differently depending upon how their hardware/firmware works.=C2=
=A0=20
> We may be trying to help too much here.
>=20
> As a potential consumer of these helpers, I'd rather do my own mac=20
> address byte twiddling and then use eth_hw_addr_set() to put it into plac=
e.

This is disproved by many upstream drivers, I only converted the ones
that jumped out at me on Friday, but I'm sure there is more. If your
driver is _really_ doing something questionable^W I mean "special"
nothing is stopping you from open coding it. For others the helper will
be useful.=20

IOW I don't understand your comment.

In fact if someone is "afraid" of others refactoring their driver or
can't provide timely feedback (ekhm, prestera people) maybe the driver
doesn't belong upstream.
