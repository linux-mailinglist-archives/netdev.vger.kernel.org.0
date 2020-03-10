Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFBE7180997
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 21:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgCJUzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 16:55:08 -0400
Received: from mail.mbosch.me ([188.68.58.50]:39544 "EHLO mail.mbosch.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgCJUzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 16:55:08 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2020 16:55:06 EDT
Date:   Tue, 10 Mar 2020 21:47:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mbosch.me; s=mail;
        t=1583873241; bh=q3j55UFkykK4Dzhnj+SBqHozf0ZbgNnK6g4do8dVKOs=;
        h=Date:From:To:Subject:References:In-Reply-To;
        b=hP1zM23XwEOdj5alpwqdqfl787jRifX1XE80PCB+xIQ3tTxh4hwjP0u4Iy41mnRbL
         CQy1UhBu+LWqrS/fcjivntpVxMtRvBEZEKZMs6XFjBFU/Kk8mOMLgerIh5d8pCi/Gw
         KVByuPdpeUUzNp4LohV0DhHMvGPfLMH3KPKcMHAQ=
From:   Maximilian Bosch <maximilian@mbosch.me>
To:     netdev@vger.kernel.org
Subject: Re: VRF Issue Since kernel 5
Message-ID: <20200310204721.7jo23zgb7pjf5j33@topsnens>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
 <CWLP265MB1554B902B7F3B43E6E75FD0DFDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
 <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>
 <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7p6r2yxdtux4if3b"
Content-Disposition: inline
In-Reply-To: <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7p6r2yxdtux4if3b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I suspect I hit the same issue which is why I decided to respond to this
thread (if that's wrong please let me know).

> sudo sysctl -a | grep l3mdev
>=20
> If not,
> sudo sysctl net.ipv4.raw_l3mdev_accept=3D1
> sudo sysctl net.ipv4.udp_l3mdev_accept=3D1
> sudo sysctl net.ipv4.tcp_l3mdev_accept=3D1

On my system (NixOS 20.03, Linux 5.5.8) those values are set to `1`, but
I experience the same issue.

> Since Kernel 5 though I am no longer able to update =E2=80=93 but the iss=
ue is quite a curious one as some traffic appears to be fine (DNS lookups u=
se VRF correctly) but others don=E2=80=99t (updating/upgrading the packages)

I can reproduce this on 5.4.x and 5.5.x. To be more precise, I suspect
that only TCP traffic hangs in the VRF. When I try to `ssh` through the
VRF, I get a timeout, but UDP traffic e.g. from WireGuard works just fine.

However, TCP traffic through a VRF works fine as well on 4.x (just tested t=
his on
4.19.108 and 4.14.172).

I use VRFs to enslave my physical uplink interfaces (enp0s31f6, wlp2s0).
My main routing table has a default route via my WireGuard Gateway and I
only route my WireGuard uplink through the VRF. With this approach I can
make sure that all of my traffic goes through the VPN and only the
UDP packets of WireGuard will be routed through the uplink network.

My routing table (with `wg0` being the WireGuard interface and `uplink`
being the VRF-interface) looks like this:

```
$ ip route show
default via 10.94.0.1 dev wg0 proto static
10.94.0.0/16 dev wg0 proto kernel scope link src 10.94.0.2
<vpn-uplink> dev uplink proto static metric 100
```

The VRF-interface is associated with the routing-table `1`. This routing
table contains all routes configured on `enp0s31f6` or `wlp2s0`.

As mentioned above, the WireGuard traffic works perfectly fine, but I
can't access `<vpn-uplink>` via SSH:

```
$ ssh root@<vpn-uplink> -vvvv
OpenSSH_8.2p1, OpenSSL 1.1.1d  10 Sep 2019
debug1: Reading configuration data /home/ma27/.ssh/config
debug1: /home/ma27/.ssh/config line 5: Applying options for *
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 5: Applying options for *
debug2: resolve_canonicalize: hostname <vpn-uplink> is address
debug1: Control socket "/home/ma27/.ssh/master-root@<vpn-uplink>:22" does n=
ot exist
debug2: ssh_connect_direct
debug1: Connecting to <vpn-uplink> [<vpn-uplink>] port 22.
# Hangs here for a while
```

I get the following output when debugging this with `tcpdump`:

```
$ tcpdump -ni uplink tcp
20:06:40.409006 IP 10.214.40.237.58928 > <vpn-uplink>.22: Flags [S], seq 41=
23706560, win 65495, options [mss 65495,sackOK,TS val 3798273519 ecr 0,nop,=
wscale 7], length 0
20:06:40.439699 IP <vpn-uplink>.22 > 10.214.40.237.58928: Flags [S.], seq 3=
289740891, ack 4123706561, win 65160, options [mss 1460,sackOK,TS val 11002=
35016 ecr 3798273519,nop,wscale 7], length 0
20:06:40.439751 IP 10.214.40.237.58928 > <vpn-uplink>.22: Flags [R], seq 41=
23706561, win 0, length 0
20:06:41.451871 IP 10.214.40.237.58928 > <vpn-uplink>.22: Flags [S], seq 41=
23706560, win 65495, options [mss 65495,sackOK,TS val 3798274562 ecr 0,nop,=
wscale 7], length 0
20:06:41.484498 IP <vpn-uplink>.22 > 10.214.40.237.58928: Flags [S.], seq 3=
306036877, ack 4123706561, win 65160, options [mss 1460,sackOK,TS val 11002=
36059 ecr 3798274562,nop,wscale 7], length 0
20:06:41.484528 IP 10.214.40.237.58928 > <vpn-uplink>.22: Flags [R], seq 41=
23706561, win 0, length 0
```

AFAICS every SYN will be terminated with an RST which is the reason why
the connection hangs.

I can work around the issue by using `ip vrf exec`. However I get the
following error (unless I run `ulimit -l 2048`):

```
Failed to load BPF prog: 'Operation not permitted'
```

In case you need more information about my setup or if I can help e.g.
with testing patches, please let me know.

Note: I'm not a subscriber of this ML, so I'd appreciate it if you could
CC me.

Thanks!

  Maximilian

On Wed, Sep 11, 2019 at 01:15:54PM +0100, Mike Manning wrote:
> Hi Gareth,
> Could you please also check that all the following are set to 1, I
> appreciate you've confirmed that the one for tcp is set to 1, and by
> default the one for raw is also set to 1:
>=20
> sudo sysctl -a | grep l3mdev
>=20
> If not,
> sudo sysctl net.ipv4.raw_l3mdev_accept=3D1
> sudo sysctl net.ipv4.udp_l3mdev_accept=3D1
> sudo sysctl net.ipv4.tcp_l3mdev_accept=3D1
>=20
>=20
> Thanks
> Mike
>=20
>=20
>=20

--7p6r2yxdtux4if3b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEPg3TILK+tBEQDaTVCR2/TR/Ea44FAl5n/NkACgkQCR2/TR/E
a472/Qf7Bt1yHJ+htE+7rur31tWybDsTr9QmAS/a6a53UT/jvq1PC2IysSt9m2kH
8LhbovlAY2JK6hWGGN6zdJ8E+zp+y3vflvjvSHkiCQL6XpwVp5lBKwU1L/i3xVYL
v5sbZUPjDKLrSJnQVpsAVcVej4ucf25cNxt04LeBZX1PB11T3AiA1hhkev2t77Gq
W1G0O4Dt26f135UkG28N5Xx8ai1ScE8sfgd7IvduOlSHPYAJ4KJn3PxrRgZsyMkr
jdeCEZ8Wr+q1vEADPpikQkpDeJNRSCePsd38LbQ30Jn0IIGPPabindtgURKQA2pR
d5s+prUBa39xKbzttB8IrXRG8hF5Qg==
=3qVI
-----END PGP SIGNATURE-----

--7p6r2yxdtux4if3b--
