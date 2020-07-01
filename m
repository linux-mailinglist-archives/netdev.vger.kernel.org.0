Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056FA21167C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 01:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgGAXLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 19:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgGAXLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 19:11:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2D922082F;
        Wed,  1 Jul 2020 23:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593645107;
        bh=3tt5PM62I3DnC8Sbkyji3d0vN4HM+8EQkQ1oUwtxECY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zlQopfKHhVEfM+m3g0/lQGgyiWAO2t7VOkaGm358qeiDUusx9X91bh2ndQ7QjeUZZ
         49hpuINicn2U2k35CncRcb/sHrfk27eG5rhXFY0EZ80BD4gzBrUPvCdV0Jb1HCqehD
         XwszE/5IZ97BJ5pAfIX3jaRIfzgoI420+NMWQxqM=
Date:   Wed, 1 Jul 2020 16:11:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <mhabets@solarflare.com>, <linux-net-drivers@solarflare.com>
Subject: Re: [PATCH net-next] sfc: remove udp_tnl_has_port
Message-ID: <20200701161145.3f9f9a06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7b38b929-bdbb-f54f-0242-34d80a86b54d@solarflare.com>
References: <20200630225038.1190589-1-kuba@kernel.org>
        <29d3564b-6bcc-9df7-f6a9-3d3867390e15@solarflare.com>
        <20200701114336.62b57cc4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7b38b929-bdbb-f54f-0242-34d80a86b54d@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jul 2020 23:02:09 +0100 Edward Cree wrote:
> On 01/07/2020 19:43, Jakub Kicinski wrote:
> > There's a number of drivers which try to match the UDP ports. That
> > seems fragile to me. Is it actually required for HW to operate
> > correctly?  =20
> For EF10 hardware, yes, because the hardware parses the packet headers
> =C2=A0to find for itself the offsets at which to make the various TSO edi=
ts;
> =C2=A0thus its parser needs to know which UDP ports correspond to VXLAN or
> =C2=A0GENEVE.=C2=A0 If a GSO skb arrives at the driver with skb->encapsul=
ation
> =C2=A0set but on a UDP port that's not known to the hardware, the driver
> =C2=A0will have to reject it in ndo_features_check() or 'manually' fall b=
ack
> =C2=A0to software segmentation from the transmit path.

I see. I'm asking because I'm working on a rewrite of udp tunnel-
-related callbacks. I'll keep the ef10's table checking, then.

We can drop this patch if you plan to upstream the support for TX
side offloads soon.

> EF10 also makes use of encap parsing on receive, for CHECKSUM_UNNECESSARY
> =C2=A0offload (with CSUM_LEVEL) as well as RSS and filtering on inner hea=
ders
> =C2=A0(although there is currently no driver support for inner-frame RXNF=
C, as
> =C2=A0ethtool's API doesn't cover it).
> > Aren't the ports per ns in the kernel? There's no guarantee that some
> > other netns won't send a TSO skb and whatever other UDP encap. =20
> That is indeed one of the flaws with port-based tunnel offloads; in
> =C2=A0theory the UDP port's scope is only the 3-tuple of the socket used =
by
> =C2=A0the tunnel device, so never mind netns, it would be logically valid=
 to
> =C2=A0use the same port for different encap protocols on different IP
> =C2=A0addresses on the same network interface.
> AFAICT udp_tunnel_notify_add_rx_port() gets a netns from the sock and
> =C2=A0then calls the ndo for every netdev in that ns.=C2=A0 So in a setup=
 like
> =C2=A0that, the ndo would get called twice for the same port (without any=
 IP
> =C2=A0address information other than sa_family being passed to the driver=
),
> =C2=A0the driver would ignore the second one (print a netif_dbg and return
> =C2=A0EEXIST, which the caller ignores), and any TSO skbs trying to use t=
he
> =C2=A0second one would be parsed by the hardware with the wrong encap type
> =C2=A0and probably go out garbled on the wire.=C2=A0 I think at the time =
everyone
> =C2=A0took the position that "this is a really unlikely setup and if anyb=
ody
> =C2=A0really wants to do that they'll just have to turn off encap TSO".
>=20
> So ndo_udp_tunnel_add is a fundamentally broken interface that people
> =C2=A0shouldn't design new hardware to support but it's close enough that=
 it
> =C2=A0seems reasonable to use it to get _some_ encap TSO mileage out of t=
he
> =C2=A0port-based hardware that already exists.=C2=A0 Agree/disagree/other?

The port offload interface is just a hint for RX side offloads which
can't cause harm. It's the use of this hint as a hard fact for TX
offloads which is incorrect.

If NIC thinks the inner csum is invalid because the packet was in fact
not carrying encapsulated frames - it should just pass it up the stack.
We don't trust NICs to tell us checksums are wrong.

RSS is also relatively harmless if gone wrong. Most NICs actually
default to not computing RSS using inner headers, to stay on the safe
side.
