Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C2D42A5D6
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236973AbhJLNkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236607AbhJLNk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:40:28 -0400
X-Greylist: delayed 574 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Oct 2021 06:38:25 PDT
Received: from dehost.average.org (dehost.average.org [IPv6:2a01:4f8:130:53eb::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D3EC061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 06:38:25 -0700 (PDT)
Received: from [IPv6:2a02:8106:1:6800:3c3d:74ed:97e1:5268] (unknown [IPv6:2a02:8106:1:6800:3c3d:74ed:97e1:5268])
        by dehost.average.org (Postfix) with ESMTPSA id A061B38F1797;
        Tue, 12 Oct 2021 15:28:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1634045328; bh=KAtKZFGLYisrPiYiXfawBAz9baSB7K+NW/KPhAdMeHw=;
        h=To:Cc:From:Subject:Date:From;
        b=FgpSVUPhQaLconHidvc5CwyTa/+bmIXmvwHUr7s2xlXrC9DD8BVkWaUOm/fNegs0o
         53TF+2paIsuJ8ScJPwwTHohYC36+MArhkxwjK6SOFjxDguLluaxodsThJCWh1a1u1d
         m4CPPFTV/g47jeJfE3v1RSN8Epq605EdZhM2D9dk=
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@kernel.org>
From:   Eugene Crosser <crosser@average.org>
Subject: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
 conntrack connection on VRF rcv" breaks expected netfilter behaviour
Message-ID: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
Date:   Tue, 12 Oct 2021 15:28:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kRZUnkb0z0ifTaN9ZEdv2mCsL3m9cMvuV"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kRZUnkb0z0ifTaN9ZEdv2mCsL3m9cMvuV
Content-Type: multipart/mixed; boundary="ErHPi2e14wjnJp1dEBNYFABWNBEQImb6i";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org,
 Lahav Schlesinger <lschlesinger@drivenets.com>,
 David Ahern <dsahern@kernel.org>
Message-ID: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
Subject: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
 conntrack connection on VRF rcv" breaks expected netfilter behaviour

--ErHPi2e14wjnJp1dEBNYFABWNBEQImb6i
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hello all,


Commit mentioned in the subject was intended to avoid creation of stray
conntrack entries when input interface is enslaved in a VRF, and thus
prerouting conntrack hook is called twice: once in the context of the
original input interface, and once in the context of the VRF interface.
Solution was to nuke conntrack related data associated with the skb when
it enters VRF context.



However this breaks netfilter operation. Imagine a use case when
conntrack zone must be assigned based on the (original, "real") input
interface, rather than VRF interface (that can enslave multiple "real"
interfaces, that would become indistinguishable). One could create
netfilter rules similar to these:



        chain rawprerouting {

                type filter hook prerouting priority raw;

                iif realiface1 ct zone set 1 return

                iif realiface2 ct zone set 2 return

        }



This works before the mentioned commit, but not after: zone assignment
is "forgotten", and any subsequent NAT or filtering that is dependent on
the conntrack zone does not work.



There is a reproducer script at the bottom of this message that
demonstrates the difference in behaviour.



Maybe a better solution for stray conntrack entries would be to
introduce finer control in netfilter? One possible idea would be to
implement both "track" and "notrack" targets; then a working
configuration would look like this:



        chain rawprerouting {

                type filter hook prerouting priority raw;

                iif realiface1 ct zone set 1 notrack

                iif realiface2 ct zone set 2 notrack

                iif vrfmaster track

        }



so in the original input interface context, zone is assigned, but
conntrack processing itself is shortcircuited. When the packet enters
VRF context, conntracking is reenabled, so one entry is created, in the
zone assigned at an earlier stage.



This is just an idea, I don't have enough knowledge to judge how
workable is it.



For reference, this is a thread about the issue in netfilter-devel:
https://marc.info/?t=3D163310182600001&r=3D1&w=3D2



Thank you,



Eugene



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#!/bin/sh



# This script demonstrates unexpected change of nftables behaviour

# caused by commit 09e856d54bda5f28 ""vrf: Reset skb conntrack

# connection on VRF rcv"

#
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D09e856d54bda5f288ef8437a90ab2b9b3eab83d1

#

# Before the commit, it was possible to assign conntrack zone to a

# packet (or mark it for `notracking`) in the prerouting chanin, raw

# priority, based on the `iif` (interface from which the packet

# arrived).

# After the change, # if the interface is enslaved in a VRF, such

# assignment is lost. Instead, assignment based on the `iif` matching

# the VRF master interface is honored. Thus it is impossible to

# distinguish packets based on the original interface.

#

# This script demonstrates this change of behaviour: conntrack zone 1

# or 2 is assigned depending on the match with the original interface

# or the vrf master interface. It can be observed that conntrack entry

# appears in different zone in the kernel versions before and after

# the commit. Additionaly, the script produces netfilter trace files

# that can be used for debugging the issue.



IPIN=3D172.30.30.1

IPOUT=3D172.30.30.2

PFXL=3D30



ip li sh vein >/dev/null 2>&1 && ip li del vein

ip li sh tvrf >/dev/null 2>&1 && ip li del tvrf

nft list table testct >/dev/null 2>&1 && nft delete table testct



ip li add vein type veth peer veout

ip li add tvrf type vrf table 9876

ip li set veout master tvrf

ip li set vein up

ip li set veout up

ip li set tvrf up

/sbin/sysctl -w net.ipv4.conf.veout.accept_local=3D1

/sbin/sysctl -w net.ipv4.conf.veout.rp_filter=3D0

ip addr add $IPIN/$PFXL dev vein

ip addr add $IPOUT/$PFXL dev veout



nft -f - <<__END__

table testct {

	chain rawpre {

		type filter hook prerouting priority raw;

		iif { veout, tvrf } meta nftrace set 1

		iif veout ct zone set 1 return

		iif tvrf ct zone set 2 return

		notrack

	}

	chain rawout {

		type filter hook output priority raw;

		notrack

	}

}

__END__



uname -rv

conntrack -F

stdbuf -o0 nft monitor trace >nftrace.`uname -r`.txt &

monpid=3D$!

ping -W 1 -c 1 -I vein $IPOUT

conntrack -L

sleep 1

kill -15 $monpid

wait


--ErHPi2e14wjnJp1dEBNYFABWNBEQImb6i--

--kRZUnkb0z0ifTaN9ZEdv2mCsL3m9cMvuV
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmFljYcACgkQfKQHw5Gd
RYy7nAgAhIKG3NuXBFHFSuNtS7vhUmx9Nv0vt7K5HRH2D3OO+aT3rNeXABBBWe8q
xlzhdI6P6WErghrIWSBeCo8ShGg4oCJX2OLRRvaIVnQon12ppXV9KlKRu+eiiU74
UoID7Am/2cDk96XE01l+ICFyJKztDo+Mi+aU/slZ7z8t42PCIdjVUcFtol1May+I
hzw78hOPVNoL0c/KEFQzq9hWAXGRgpwG4yE7/buGxzKSbdscCZm9RTy61x0CZsg6
nsZBClKQXHGb5RRdsuj3GaVL52L5Q9y8WINcXUiHeHgr21twiSXZuvla0GDJDY4I
qrPDfFgRXw4aPG9Q+kCTkABOq7Hvaw==
=JnhI
-----END PGP SIGNATURE-----

--kRZUnkb0z0ifTaN9ZEdv2mCsL3m9cMvuV--
