Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F9628DFE5
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 13:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387992AbgJNLhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 07:37:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57896 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387867AbgJNLhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 07:37:51 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602675469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fgQVMv6QFJMTaseF5aPPZGWUnwUKlJlJ27Irewy1FdI=;
        b=14ZGnGcnpWvkGYSiiAbRoXiY6OZARP9jjRty74t4nUi4e2P6ZIpePsci7LE6hXwnD87ND/
        ja7UJ/DiFotNZavJE/h0cpS1TC2Qlh9kj0ctNE7+3FXmQXS3/7YKCNtV5Tx2YIJT18k5aJ
        RnFDBTcN07JpDPMLlVLEwca4wugmGYw0z1H9+IFtjoHJgoenPH4Mc7e4ti13QaUyAP0wQb
        +WRP3c/DZjN/JCqfFWM7af5Jk3YVqW8120eJHcKL1bxU6aAwrE/ASiJ3QjiP+o82GRIadF
        h7Jz7V6nRryTnzNxcYW4raN2AVOiF3Y+nq1vDGVainswwx81KwO9Ba1S9H+qkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602675469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fgQVMv6QFJMTaseF5aPPZGWUnwUKlJlJ27Irewy1FdI=;
        b=yzl/hEDh/R9P0pJa6SqIQ+/FpwJPr5TTzRCavXIkLp+cVOVlvYvNHl45lFrt53QGgzdsRc
        k8rIin985AKDJvCw==
To:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for hardware timestamping
In-Reply-To: <20201014110113.GA1646@hoboy>
References: <87lfgiqpze.fsf@kurt> <20201007105458.gdbrwyzfjfaygjke@skbuf> <87362pjev0.fsf@kurt> <20201008094440.oede2fucgpgcfx6a@skbuf> <87lfghhw9u.fsf@kurt> <f040ba36070dd1e07b05cc63a392d8267ce4efe2.camel@hs-offenburg.de> <20201008150951.elxob2yaw2tirkig@skbuf> <65ecb62de9940991971b965cbd5b902ae5daa09b.camel@hs-offenburg.de> <20201012214254.GA1310@hoboy> <20201014095747.xlt3xodch7tlhrhr@skbuf> <20201014110113.GA1646@hoboy>
Date:   Wed, 14 Oct 2020 13:37:47 +0200
Message-ID: <87eem111is.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Oct 14 2020, Richard Cochran wrote:
> On Wed, Oct 14, 2020 at 12:57:47PM +0300, Vladimir Oltean wrote:
>> So the discussion is about how to have the cake and eat it at the same
>> time.
>
> And I wish for a pony.  With sparkles.  And a unicorn.  And a rainbow.
>
>> Silicon vendors eager to follow the latest trends in standards are
>> implementing hybrid PTP clocks, where an unsynchronizable version of the
>> clock delivers MAC timestamps to the application stack, and a
>> synchronizable wrapper over that same clock is what gets fed into the
>> offloading engines, like the ones behind the tc-taprio and tc-gate
>> offload. Some of these vendors perform cross-timestamping (they deliver
>> a timestamp from the MAC with 2, or 3, or 4, timestamps, depending on
>> how many PHCs that MAC has wired to it), some don't, and just deliver a
>> single timestamp from a configurable source.
>
> Sounds like it will be nearly impossible to make a single tc-taprio
> framework that fits all the hardware variants.

Why? All the gate operations work on the synchronized clock. I assume
all Qbv capable switches have a synchronized clock?

It's just that some switches have multiple PHCs instead of a single
one. It seems to be quite common to have a free-running as well as a
synchronized clock. In order for a better(?) or more accurate(?) ptp
implementation they expose not a single but rather multiple timestamps
from all PHCs (-> cross-timestamping) to user space for the ptp event
messages. That's at least my very limited understanding.

>
>> The operating system is supposed to ??? in order to synchronize the
>> synchronizable clock to the virtual time retrieved via TIME_STATUS_NP
>> that you're talking about. The question is what to replace that ???
>> with, of course.
>
> You have a choice.  Either you synchronize the local PHC to the global
> TAI time base or not.  If you do synchronize the PHC, then everything
> (like the globally scheduled time slots) just works.  If you decide to
> follow the nonsensical idea (following 802.1-AS) and leave the PHC
> free running, then you will have a difficult time scheduling those
> time windows.
>
> So it is all up to you.
>
>> I'm not an expert in kernel implementation either, but perhaps in the
>> light of this, you can revisit the idea that kernel changes will not be
>> needed (or explain more, if you still think they aren't).
>
> I am not opposed to kernel changes, but there must be:
>
> - A clear statement of the background context, and
> - an explanation of the issue to solved, and
> - a realistic solution that will support the wide variety of HW.=20

Agreed.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+G4wsACgkQeSpbgcuY
8KbF0BAAtk9IZ6ejCsNNkQIznvS9WeH31TGltyeHfmNzjnjVX0MtMtIucKYWlAM3
cRUPL/zt2b9PSKOXcaj+7H+pIeu+aCZ3e+YOuAWMEvxV64rXR34PFptF+jxFgWnP
OAhJUSAqWGkgX0Hj9awD0nf6uxpKiHEpZjtHsu4a74/TOKwfh+bOqJma0S2iCSco
RSXHbP0HNzQeW2mt8wljZfW+xG9YXT/wJePhH83U8sPAiwfnmcEHXb4RDGnaiaaQ
tpwMZ9kz2Sd7EnNataIt/81YcrNZOZEkx9de0IQR37iktBP7WYQEZK/T3LSlIpH5
/k1UzR72SJ+i+BqdswwkAWRXgIXW3it+aFOa+nkWWsMYiA/+i6DuWAkp3kkMAVWW
xTZgXO+PQktzWvr7xBfOvV/1FH+OEmvyUm+j0RbLy3BV3+S4W+dKYb9Poqb9FCnh
vWIMw64sph2UQuUtO2gF3lwKtkBQo8kmFhJUBOpIg+7PKaDCWot/1aTrof++vgDJ
AiZa2d3cJHCbkuMrbkb5f/zwJbKRDfGq3RR2ljX/8tjnECLkJPje/Tf48YfIY85A
BgjYp+AGw+I7n3E2QT0GAp5yjO2CEQu1P1y3ePXyOdvks46cbsVUfrCxxgiCuXhb
4/fP6kv3U+VVxgxH3IrWHMrHjRMoIP0kULx8PLpSCt5paPr411o=
=OCg2
-----END PGP SIGNATURE-----
--=-=-=--
