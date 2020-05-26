Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857461E33D7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 01:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgEZXn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 19:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbgEZXn1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 19:43:27 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33ED82084C;
        Tue, 26 May 2020 23:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590536606;
        bh=cvOwXjGSU2/G2e6uljmMz07eQk0/zzAYQKqHeJemQRw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OWsxs2DdGD5vvcY1qM4hOF5jfXpSl6vgh3bLkKTe+TwdmIZpInVU/eCEikg4Et/Hq
         ugvl74sJHMNLGQUjoirdHe1iw3DSb2IyMEVImhwbJfLQ3jAq26FNGE3gKjBAO43PKo
         4MOkg2N/NHdKSW4kzL4XsMvm8get1dIeNs+01eQc=
Date:   Tue, 26 May 2020 16:43:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/14] mlxsw: Various trap changes - part 2
Message-ID: <20200526164323.565c8309@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200526231905.GA1507270@splinter>
References: <20200525230556.1455927-1-idosch@idosch.org>
        <20200526151437.6fc3fb67@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20200526231905.GA1507270@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 02:19:05 +0300 Ido Schimmel wrote:
> On Tue, May 26, 2020 at 03:14:37PM -0700, Jakub Kicinski wrote:
> > On Tue, 26 May 2020 02:05:42 +0300 Ido Schimmel wrote: =20
> > > From: Ido Schimmel <idosch@mellanox.com>
> > >=20
> > > This patch set contains another set of small changes in mlxsw trap
> > > configuration. It is the last set before exposing control traps (e.g.,
> > > IGMP query, ARP request) via devlink-trap. =20
> >=20
> > When traps were introduced my understanding was that they are for
> > reporting frames which hit an expectation on the datapath. IOW the
> > primary use for them was troubleshooting.
> >=20
> > Now, if I'm following things correctly we have explicit DHCP, IGMP,
> > ARP, ND, BFD etc. traps. Are we still in the troubleshooting realm? =20
>=20
> First of all, we always had them. This patch set mainly performs some
> cleanups in mlxsw.
>=20
> Second, I don't understand how you got the impression that the primary
> use of devlink-trap is troubleshooting. I was very clear and transparent
> about the scope of the work from the very beginning and I don't wish to
> be portrayed as if I wasn't.
>=20
> The first two paragraphs from the kernel documentation [1] explicitly
> mention the ability to trap control packets to the CPU:
>=20
> "Devices capable of offloading the kernel=E2=80=99s datapath and perform
> functions such as bridging and routing must also be able to send
> specific packets to the kernel (i.e., the CPU) for processing.
>=20
> For example, a device acting as a multicast-aware bridge must be able to
> send IGMP membership reports to the kernel for processing by the bridge
> module. Without processing such packets, the bridge module could never
> populate its MDB."
>=20
> In my reply to you from almost a year ago I outlined the entire plan for
> devlink-trap [2]:
>=20
> "Switch ASICs have dedicated traps for specific packets. Usually, these
> packets are control packets (e.g., ARP, BGP) which are required for the
> correct functioning of the control plane. You can see this in the SAI
> interface, which is an abstraction layer over vendors' SDKs:
>=20
> https://github.com/opencomputeproject/SAI/blob/master/inc/saihostif.h#L157
>=20
> We need to be able to configure the hardware policers of these traps and
> read their statistics to understand how many packets they dropped. We
> currently do not have a way to do any of that and we rely on hardcoded
> defaults in the driver which do not fit every use case (from
> experience):
>=20
> https://elixir.bootlin.com/linux/v5.2/source/drivers/net/ethernet/mellano=
x/mlxsw/spectrum.c#L4103
>=20
> We plan to extend devlink-trap mechanism to cover all these use cases. I
> hope you agree that this functionality belongs in devlink given it is a
> device-specific configuration and not a netdev-specific one.
>=20
> That being said, in its current form, this mechanism is focused on traps
> that correlate to packets the device decided to drop as this is very
> useful for debugging."
>=20
> In the last cycle, when I added the ability to configure trap policers
> [3] I again mentioned under "Future plans" that I plan to "Add more
> packet traps.  For example, for control packets (e.g., IGMP)".
>=20
> If you worry that packets received via control traps will be somehow
> tunneled to user space via drop_monitor, then I can assure you this is
> not the case. You can refer to this commit [4] from the next submission.

Perhaps the troubleshooting is how I justified the necessity of having
devlink traps to myself. It's much harder to get visibility into what
HW is doing and therefore we need this special interface.

But we should be able to configure a DHCP daemon without any special
sauce. What purpose does the DHCP trap serve?

What's the packet flow for BFD? How does the HW case differ from a SW
router?
