Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6193D0D9C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbhGUKrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:47:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46302 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238737AbhGUJ55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 05:57:57 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626863897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FMaixVWN7k1mcBqMwhbMDYdVjZjNxl+7TjQRjO4RKek=;
        b=J5sgD/Tn+SHRpsmvxsYyRvA4D4yOYW3FNcnlRb9e3ZTSSChAeGJf/ImINVB961zMH2O+qj
        5z+1/loMkCdqz1PiVTBIEOuyrGSWXQXXQfS3Y+g7AhjiySkpClh0DIvWME9oJAh4SS0sV1
        kgapOSzLm1F6mdSGRgN7D2V/iWkRV2HA5OMJ9OkemNzY22JtDGpUqUl5tvDZbjY1uzvjMU
        9AOKMy/NGjc6WC2wP2cdf8MLowAnFZ8chvA+soRf9QTMfxw5MkXa17XWjqSdfUodJF+S58
        REBq5JMZcIUqF0P1BvsEdFvN1GlAOLPrQ68Ew/McHPktCIzK0xo2rcZ4sJGPRA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626863897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FMaixVWN7k1mcBqMwhbMDYdVjZjNxl+7TjQRjO4RKek=;
        b=1GjrqviOlBxv2qbqMM7hEC6brqEBpCl8oEU6zbQK8Kg5SqdEurVythOqC4aO8yvvB1H1+O
        oqbLq21z72Mq+SAw==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 10/11] net: dsa: tag_8021q: manage RX VLANs
 dynamically at bridge join/leave time
In-Reply-To: <20210721094155.aoikj4ghf2d3a4ap@skbuf>
References: <20210719171452.463775-1-vladimir.oltean@nxp.com>
 <20210719171452.463775-11-vladimir.oltean@nxp.com> <87lf60vxvx.fsf@kurt>
 <20210721094155.aoikj4ghf2d3a4ap@skbuf>
Date:   Wed, 21 Jul 2021 12:38:16 +0200
Message-ID: <87fsw8vtnr.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Jul 21 2021, Vladimir Oltean wrote:
> Hi Kurt,
>
> On Wed, Jul 21, 2021 at 11:06:58AM +0200, Kurt Kanzenbach wrote:
>> Hi Vladimir,
>>=20
>> On Mon Jul 19 2021, Vladimir Oltean wrote:
>> > This is not to say that the reason for the change in this patch is to
>> > satisfy the hellcreek and similar use cases, that is merely a nice side
>> > effect.
>>=20
>> Is it possible to use tag_8021q for port separation use cases now? I'd
>> be interested in it if that results in a simplified hellcreek
>> implementation :).
>
> Yes, but I still don't think it is worth it.
>
> At the moment, if I'm not mistaken, hellcreek reserves 3 VLANs or so,
> from 4093 to 4095. Whereas tag_8021q will reserve the entire range from
> 1024 to 3071. The VLAN IDs used by tag_8021q have a bitwise meaning of
> their own, so that range cannot be simply shifted (at least not easily).
>
> If you only want to use tag_8021q for port separation in standalone
> mode, and not really as a tagging protocol (tag_hellcreek.c will not see
> the tag_8021q VLANs), I suppose that restriction can be lifted somewhat:
> (a) tag_8021q can only reserve RX VLANs but not TX VLANs (that would
>     reduce the reserved range from 1024-3071 to 1024-2047)
> (b) tag_8021q can only reserve RX VLANs for the actual ds->num_ports and
>     ds->index values in use (which would further reduce the range to
>     1024-1026 in your case)
>
> In terms of driver implementation, not a lot would go away. The current
> places where you handle events, like hellcreek_setup_vlan_membership(),
> will still remain the way they are, but they will just set up a VLAN
> provided by tag_8021q instead of one provided by hellcreek_private_vid().
>
> Six of one, half a dozen of the other.

OK. Seems like it's not worth it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmD3+RkTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpj+3EACwCcEgng+X5nnTm4L/SjyQ9ukR1fHp
02eUxhgP86ty/0sZPVBvks+Jfsj2qZCIyIJV39e0Og4ZQ5jJVb/l48PlwfpmiGjl
kZDMxzX2rwP0/gUUSXlUpVSeNO22w7jr0hpvrZBMZ/hc+1/nBxtjlC+W33+ovNad
IXowfWYmLo//CiNSQYfZ7n+4IXcN4ZeWTCHu8aD59C/TsTHQps0aKM/m8b5q9BGB
gtahahVATqZVOJTLh6Gv9by8tTFE6nfsjz02XYouSr3vjcusvob/5sQnCY5avNXD
yO8uzjNZG/0d4UrOa4nmNv+mEZBf4Y+GaMcssF4dtnx94exgNdk/fAFHKn8wgDyX
n9zIClzEh2h4bK8tAcZGeSSIIT9EAAFHqKHpEn6wDWj0RnP+yLfVKnuCZy/gxHhx
tO1ctAeYbUSYDVaQFiopymJJlsPgxAmnrEkf20DLIsNVR85QLgfRrn+OwbwAbTJb
AO3GMXieeb5LSJoIzNInmJlEpN3RC3TkNLdWVkjxzb/IgoxfIWokmFO5wM4kSQzQ
3JL6LPtL+ymcAiaWfG9IoHdcgY6rOYA+wt4pQ4FTCxlsIrRi+dNZrlyPyDz5BU5e
zTFhnG5bSzFoqAxwLGerwcUTuUcoRVbrL0QJDLywGhcxnLEh80RaPzsZ73urQhFX
7EL4bK4fZvwxvg==
=LFix
-----END PGP SIGNATURE-----
--=-=-=--
