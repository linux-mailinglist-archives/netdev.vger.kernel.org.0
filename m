Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9D319B53F
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 20:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732839AbgDASQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 14:16:54 -0400
Received: from mail.mbosch.me ([188.68.58.50]:51082 "EHLO mail.mbosch.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730420AbgDASQy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 14:16:54 -0400
Date:   Wed, 1 Apr 2020 20:16:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mbosch.me; s=mail;
        t=1585765011; bh=KSfGsM9/e6WsYyVaE2xiL5ueZyg6eIXFDtgmMeJcFeE=;
        h=Date:From:To:Subject:References:In-Reply-To;
        b=NKax66d+OvkBaiHVttbTAiT1DIj58yIU8NuQbKehc1/ezNBufI0ax5VtoG3QZf7sp
         ICLxwcGpSVc1568yKivNGsbMn9mEq8u4eSPLK/OlT7hXozMpxREDHee7T7Egcwx3HO
         6kiaAZUYDXW1pdTTE0P3JRTTG2hrZvBhaP0PbtgQ=
From:   Maximilian Bosch <maximilian@mbosch.me>
To:     netdev@vger.kernel.org
Subject: Re: VRF Issue Since kernel 5
Message-ID: <20200401181650.flnxssoyih7c5s5y@topsnens>
References: <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
 <CWLP265MB1554B902B7F3B43E6E75FD0DFDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
 <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>
 <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
 <20200310204721.7jo23zgb7pjf5j33@topsnens>
 <2583bdb7-f9ea-3b7b-1c09-a273d3229b45@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o53d2g6m3uwl6zsc"
Content-Disposition: inline
In-Reply-To: <2583bdb7-f9ea-3b7b-1c09-a273d3229b45@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--o53d2g6m3uwl6zsc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

First of all, sorry for my delayed response!

> functional test script under tools/testing/selftests/net covers VRF
> tests and it ran clean for 5.4 last time I checked. There were a few
> changes that went into 4.20 or 5.0 that might be tripping up this use
> case, but I need a lot more information.

I recently started an attempt to get those tests running on my machine
(and a Fedora VM after that), however I had several issues with
timeouts (when running `sudo -E make -C tools/testing/selftests TARGETS=3D"=
net"
run_tests`).

May I ask if there are further things I need to take care of to get
those tests successfully running?

> are you saying wireguard worked with VRF in the past but is not now?

No. WireGuard traffic is still working fine. The only issue is
TCP-traffic through a VRF (which worked with 4.19, but doesn't anymore
with 5.4 and 5.5).

> 'ip vrf exec' loads a bpf program and that requires locked memory, so
> yes, you need to increase it.

Thanks a lot for the explanation!

> Let's start with lookups:
>=20
> perf record -e fib:* -a -g
> <run test that fails, ctrl-c>
> perf script

For the record, please note that I'm now on Linux 5.5.13.

I ran the following command:

```
sudo perf record -e fib:* -a -g -- ssh root@92.60.36.231 -o ConnectTimeout=
=3D10s
```

The full output can be found here:

https://gist.githubusercontent.com/Ma27/a6f83e05f6ffede21c2e27d5c7d27098/ra=
w/4852d97ee4860f7887e16f94a8ede4b4406f07bc/perf-report.txt

Thanks!

  Maximilian

On Wed, Mar 11, 2020 at 07:06:54PM -0600, David Ahern wrote:
> On 3/10/20 2:47 PM, Maximilian Bosch wrote:
> > Hi!
> >=20
> > I suspect I hit the same issue which is why I decided to respond to this
> > thread (if that's wrong please let me know).
> >=20
> >> sudo sysctl -a | grep l3mdev
> >>
> >> If not,
> >> sudo sysctl net.ipv4.raw_l3mdev_accept=3D1
> >> sudo sysctl net.ipv4.udp_l3mdev_accept=3D1
> >> sudo sysctl net.ipv4.tcp_l3mdev_accept=3D1
> >=20
> > On my system (NixOS 20.03, Linux 5.5.8) those values are set to `1`, but
> > I experience the same issue.
> >=20
> >> Since Kernel 5 though I am no longer able to update =E2=80=93 but the =
issue is quite a curious one as some traffic appears to be fine (DNS lookup=
s use VRF correctly) but others don=E2=80=99t (updating/upgrading the packa=
ges)
> >=20
> > I can reproduce this on 5.4.x and 5.5.x. To be more precise, I suspect
> > that only TCP traffic hangs in the VRF. When I try to `ssh` through the
> > VRF, I get a timeout, but UDP traffic e.g. from WireGuard works just fi=
ne.
> >=20
> > However, TCP traffic through a VRF works fine as well on 4.x (just test=
ed this on
> > 4.19.108 and 4.14.172).
>=20
> functional test script under tools/testing/selftests/net covers VRF
> tests and it ran clean for 5.4 last time I checked. There were a few
> changes that went into 4.20 or 5.0 that might be tripping up this use
> case, but I need a lot more information.
>=20
> >=20
> > I use VRFs to enslave my physical uplink interfaces (enp0s31f6, wlp2s0).
> > My main routing table has a default route via my WireGuard Gateway and I
> > only route my WireGuard uplink through the VRF. With this approach I can
> > make sure that all of my traffic goes through the VPN and only the
> > UDP packets of WireGuard will be routed through the uplink network.
>=20
> are you saying wireguard worked with VRF in the past but is not now?
>=20
>=20
> >=20
> > As mentioned above, the WireGuard traffic works perfectly fine, but I
> > can't access `<vpn-uplink>` via SSH:
> >=20
> > ```
> > $ ssh root@<vpn-uplink> -vvvv
> > OpenSSH_8.2p1, OpenSSL 1.1.1d  10 Sep 2019
> > debug1: Reading configuration data /home/ma27/.ssh/config
> > debug1: /home/ma27/.ssh/config line 5: Applying options for *
> > debug1: Reading configuration data /etc/ssh/ssh_config
> > debug1: /etc/ssh/ssh_config line 5: Applying options for *
> > debug2: resolve_canonicalize: hostname <vpn-uplink> is address
> > debug1: Control socket "/home/ma27/.ssh/master-root@<vpn-uplink>:22" do=
es not exist
> > debug2: ssh_connect_direct
> > debug1: Connecting to <vpn-uplink> [<vpn-uplink>] port 22.
> > # Hangs here for a while
> > ```
> >=20
> > I get the following output when debugging this with `tcpdump`:
> >=20
> > ```
> > $ tcpdump -ni uplink tcp
> > 20:06:40.409006 IP 10.214.40.237.58928 > <vpn-uplink>.22: Flags [S], se=
q 4123706560, win 65495, options [mss 65495,sackOK,TS val 3798273519 ecr 0,=
nop,wscale 7], length 0
> > 20:06:40.439699 IP <vpn-uplink>.22 > 10.214.40.237.58928: Flags [S.], s=
eq 3289740891, ack 4123706561, win 65160, options [mss 1460,sackOK,TS val 1=
100235016 ecr 3798273519,nop,wscale 7], length 0
> > 20:06:40.439751 IP 10.214.40.237.58928 > <vpn-uplink>.22: Flags [R], se=
q 4123706561, win 0, length 0
>=20
> that suggests not finding a matching socket, so sending a reset.
>=20
> > 20:06:41.451871 IP 10.214.40.237.58928 > <vpn-uplink>.22: Flags [S], se=
q 4123706560, win 65495, options [mss 65495,sackOK,TS val 3798274562 ecr 0,=
nop,wscale 7], length 0
> > 20:06:41.484498 IP <vpn-uplink>.22 > 10.214.40.237.58928: Flags [S.], s=
eq 3306036877, ack 4123706561, win 65160, options [mss 1460,sackOK,TS val 1=
100236059 ecr 3798274562,nop,wscale 7], length 0
> > 20:06:41.484528 IP 10.214.40.237.58928 > <vpn-uplink>.22: Flags [R], se=
q 4123706561, win 0, length 0
> > ```
> >=20
> > AFAICS every SYN will be terminated with an RST which is the reason why
> > the connection hangs.
> >=20
> > I can work around the issue by using `ip vrf exec`. However I get the
> > following error (unless I run `ulimit -l 2048`):
> >=20
> > ```
> > Failed to load BPF prog: 'Operation not permitted'
> > ```
>=20
> 'ip vrf exec' loads a bpf program and that requires locked memory, so
> yes, you need to increase it.
>=20
> Let's start with lookups:
>=20
> perf record -e fib:* -a -g
> <run test that fails, ctrl-c>
> perf script
>=20
> That shows the lookups (inputs, table id, result) and context (stack
> trace). That might give some context.

--o53d2g6m3uwl6zsc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEPg3TILK+tBEQDaTVCR2/TR/Ea44FAl6E2pIACgkQCR2/TR/E
a47Tugf+LCQuqxb0wuWRRSvYPmSZbue7otdcGwjIrDvn8eRdCyorgL/kkAxJoeqd
tIU8eQ5gjRXN//7Svn9HO0aVYjx6159QkE/mOHiYx4H1q1ewcCx0WqFQuqnFrGr1
kSpNvkGBZ0c4A+zzUuydpXcxLgfc3eKEms97RuBHZwPbVZqVHsbKJx+XNq4ygAAQ
lRGDNEPzGxt1qGgUMrTpnVvtY7Gw5qLFemBgzTWy0zi23n3Lt18syGr/muTg80zl
ZpEIdHF3DwBdy58EBx9C86IrtzOvu5LaC2t+aKWPAx3H5FeqHLy4cXwwX5m6msCG
M5POp7Ci81m8Ebico77AEWpS3ZirUg==
=JF2K
-----END PGP SIGNATURE-----

--o53d2g6m3uwl6zsc--
