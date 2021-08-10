Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEED3E593A
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbhHJLkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:40:04 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42768 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240148AbhHJLkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 07:40:03 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628595577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ai1xUUohOrACSIkJA4EAUYNYo7YzS+l8J/LQLw8S0xI=;
        b=Lxv4uKlVYeytE4o605Z43tP2XGLvFa4Eoe7YuxzW7q9IWLLVB7foN7UyTFOXhpagsDnHFN
        O3i6IS1oIJOrmTqsrPw7hkKqOgSu6VNKQsbIL+iLCS52owXoEYZdGMX2mrEn0cDhPeCUl1
        wVfT08lbEu2K0v3/23f7dkVeEVi6s8xeY49+tfU4ejA6dyRiGBnflP8015+021a/8UHTz1
        7F/Abx31fC+bhe4hj3LNaGvUwX/jv1PheJDqzIQW7ZUU3+7KCyPyi/u1tTn7/78Qjfq2pl
        cLZtjFyOZq4/EkUFmtf1GaP10bxvTYDv6Xg+GUsrWCuWP5rpxHQPLs1/tZlrBg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628595577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ai1xUUohOrACSIkJA4EAUYNYo7YzS+l8J/LQLw8S0xI=;
        b=y7v1CvBCMDbWH2ExHC5hAmJX1isNQ2YVOPkOMBBewm9TEmwtzdZAZMGnIypqlz2DKADLk4
        wyD0jRx5ZKQpMJCw==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>
Subject: Re: [PATCH net 1/4] net: dsa: hellcreek: fix broken backpressure in
 .port_fdb_dump
In-Reply-To: <20210810111956.1609499-2-vladimir.oltean@nxp.com>
References: <20210810111956.1609499-1-vladimir.oltean@nxp.com>
 <20210810111956.1609499-2-vladimir.oltean@nxp.com>
Date:   Tue, 10 Aug 2021 13:39:36 +0200
Message-ID: <87wnotle9z.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Aug 10 2021, Vladimir Oltean wrote:
> rtnl_fdb_dump() has logic to split a dump of PF_BRIDGE neighbors into
> multiple netlink skbs if the buffer provided by user space is too small
> (one buffer will typically handle a few hundred FDB entries).
>
> When the current buffer becomes full, nlmsg_put() in
> dsa_slave_port_fdb_do_dump() returns -EMSGSIZE and DSA saves the index
> of the last dumped FDB entry, returns to rtnl_fdb_dump() up to that
> point, and then the dump resumes on the same port with a new skb, and
> FDB entries up to the saved index are simply skipped.
>
> Since dsa_slave_port_fdb_do_dump() is pointed to by the "cb" passed to
> drivers, then drivers must check for the -EMSGSIZE error code returned
> by it. Otherwise, when a netlink skb becomes full, DSA will no longer
> save newly dumped FDB entries to it, but the driver will continue
> dumping. So FDB entries will be missing from the dump.
>
> Fix the broken backpressure by propagating the "cb" return code and
> allow rtnl_fdb_dump() to restart the FDB dump with a new skb.
>
> Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmESZXgTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpofHD/9l2h1VIocpbLfrW5LBlLYsrwC09LKz
EN4xd8r3tPaGB/yQbmaepC6VJfVvX7Uv7PK16UzV7+kcUaB/pGkmQdKxIdcpVyn3
PP8ZZ7KayXcacoBvXQQUoTcEcwgws0+Bdz2jCu5jd+HZ2Ny6J/gl6Wnz3sP3xkXg
BlkCWEJH67DXmJA3G9CAIIwfjYwxD1HZ2/23wgGTUTHgpOvV7ILx/JheX9EbOBus
USiOIltjkzyypELScfkbFK1AiUXdpi+7K+gLdho6t+GxoPp6D6eEq0qliRo4Hk3L
F1OPfvJFzw8q4c+SLoCr250elzth1IdF7t77oUFBrFPYne4z6EQqTpnn/yv7vvjD
uApU5NuuVZbnI+gRMZGNgrd1ApMadMI4VGzmi+NftgQvB5uRzY6eBnMWKt1i+MyE
OOowfrTHb4UwaIVvhpzptUAsPIImWdhGxSMFfrolHKqlqD4SAoHsJUArV6/BIt5t
o230xUQF2n1FCYcex5o2Ul/tsKQBV8sYbxzXoQ5MYKo4u89XUztFvG0KWbuRqUSh
QxxW+K3JTVrw5FvKnQIf0DgQrLOHBn9ohTQKVie3Hu9193fUFe0dJNqaUX7kbafd
Yoq9u/qkadTKNALcKyEbvY30Lunsmw7mwMRKuz+tZxuRrAiE6Tca+bNMQ7nK53al
XpZrMp4hVt53uQ==
=w8A1
-----END PGP SIGNATURE-----
--=-=-=--
