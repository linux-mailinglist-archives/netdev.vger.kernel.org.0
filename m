Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6092FD5EF
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 17:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbhATQn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 11:43:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391623AbhATQlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 11:41:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70E9723358;
        Wed, 20 Jan 2021 16:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611160844;
        bh=Ki1XiT99uj8FxLVxLdFo85q4w6WuQJ4ig2bXZEnWi28=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dpAtkas0WbwFDzWwouCMn+8gGhSWXPS5sA2IlgSYVb9f6Qh1oh9JrMCFgvUfKSMo4
         b6W06In2ERQdicug8rRdYuAm5YKPi6R7Nq3o32t+8iZ0YHzT64gQMJhobOmQBbsASm
         OrJfVLoR4lwetRX+INR5VaIOox4aHpgH6IdGVtSnbQeqyAqYvKY1IUrvKI27WUyNae
         tisbwnCYnnhdV2tK98fd3kiUQeRxcaZ+zdNWiwCtF24++WoQDdo3pzyqavbwy14q6q
         gfYJxIgvZ8vQjhLtHhcKLN1wT36NR0HleFZs76R9uqgoG2v94PwrujTotiZzYHOZxB
         AFx0Ei5nwUuUg==
Date:   Wed, 20 Jan 2021 08:40:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 15/16] net: dsa: felix: setup MMIO filtering
 rules for PTP when using tag_8021q
Message-ID: <20210120084042.4d37dadb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119230749.1178874-16-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
        <20210119230749.1178874-16-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 01:07:48 +0200 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Since the tag_8021q tagger is software-defined, it has no means by
> itself for retrieving hardware timestamps of PTP event messages.
>=20
> Because we do want to support PTP on ocelot even with tag_8021q, we need
> to use the CPU port module for that. The RX timestamp is present in the
> Extraction Frame Header. And because we can't use NPI mode which redirects
> the CPU queues to an "external CPU" (meaning the ARM CPU running Linux),
> then we need to poll the CPU port module through the MMIO registers to
> retrieve TX and RX timestamps.
>=20
> Sadly, on NXP LS1028A, the Felix switch was integrated into the SoC
> without wiring the extraction IRQ line to the ARM GIC. So, if we want to
> be notified of any PTP packets received on the CPU port module, we have
> a problem.
>=20
> There is a possible workaround, which is to use the Ethernet CPU port as
> a notification channel that packets are available on the CPU port module
> as well. When a PTP packet is received by the DSA tagger (without timesta=
mp,
> of course), we go to the CPU extraction queues, poll for it there, then
> we drop the original Ethernet packet and masquerade the packet retrieved
> over MMIO (plus the timestamp) as the original when we inject it up the
> stack.
>=20
> Create a quirk in struct felix is selected by the Felix driver (but not
> by Seville, since that doesn't support PTP at all). We want to do this
> such that the workaround is minimally invasive for future switches that
> don't require this workaround.
>=20
> The only traffic for which we need timestamps is PTP traffic, so add a
> redirection rule to the CPU port module for this. Currently we only have
> the need for PTP over L2, so redirection rules for UDP ports 319 and 320
> are TBD for now.
>=20
> Note that for the workaround of matching of PTP-over-Ethernet-port with
> PTP-over-MMIO queues to work properly, both channels need to be
> absolutely lossless. There are two parts to achieving that:
> - We keep flow control enabled on the tag_8021q CPU port
> - We put the DSA master interface in promiscuous mode, so it will never
>   drop a PTP frame (for the profiles we are interested in, these are
>   sent to the multicast MAC addresses of 01-80-c2-00-00-0e and
>   01-1b-19-00-00-00).
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>


drivers/net/dsa/ocelot/felix.c:464:12: warning: variable =E2=80=98err=E2=80=
=99 set but not used [-Wunused-but-set-variable]
  464 |  int port, err;
      |            ^~~
drivers/net/dsa/ocelot/felix.c:265:53: warning: incorrect type in assignmen=
t (different base types)
drivers/net/dsa/ocelot/felix.c:265:53:    expected unsigned short [usertype]
drivers/net/dsa/ocelot/felix.c:265:53:    got restricted __be16 [usertype]


Please build test the patches locally, the patchwork testing thing is
not keeping up with the volume, and it's running on the largest VM
available thru the provider already :/

I need to add this "don't post your patches to get them build tested=20
or you'll make Kuba very angry" to the netdev FAQ.
