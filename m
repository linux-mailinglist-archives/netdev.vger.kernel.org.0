Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5214F249954
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgHSJ2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:28:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727098AbgHSJ2Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 05:28:16 -0400
Received: from localhost (unknown [151.48.139.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9EE20786;
        Wed, 19 Aug 2020 09:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597829296;
        bh=uCS77yLkqSqHmXUtzwGVl98ooeyqgf/ZLwCgUzgk/xo=;
        h=Date:From:To:Cc:Subject:From;
        b=b06NkbAjLDXEVHnTv1mMSQKNIJNOR4IR0jYDMXWvE3CPYR3CrM8zQ4Tls6NZkrBGg
         S+lKphZxDtYXqQDS/0A/HSB0nMKXVl9AoSHI/Nw0OsRkOw9UvNrgFe5JhDnSwXWFKy
         Le3P2HqZ7adeuT/p4lxms1PlmVGCXedXIV3CIiTo=
Date:   Wed, 19 Aug 2020 11:28:11 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     andriin@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, ast@kernel.org
Subject: xdp generic default option
Message-ID: <20200819092811.GA2420@lore-desk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrii,

working on xdp multi-buff I figured out now xdp generic is the default choi=
ce
if not specified by userspace. In particular after commit 7f0a838254bd
("bpf, xdp: Maintain info on attached XDP BPF programs in net_device"), run=
ning
the command below, XDP will run in generic mode even if the underlay driver
support XDP in native mode:

$ip link set dev eth0 xdp obj prog.o
$ip link show dev eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric qdisc mq sta=
te UP mode DEFAULT
   group default qlen 1024
   link/ether f0:ad:4e:09:6b:57 brd ff:ff:ff:ff:ff:ff
   prog/xdp id 1 tag 3b185187f1855c4c jited=20

Is it better to use xdpdrv as default choice if not specified by userspace?
doing something like:

diff --git a/net/core/dev.c b/net/core/dev.c
index a00aa737ce29..1f85880ee412 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8747,9 +8747,9 @@ static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
 {
 	if (flags & XDP_FLAGS_HW_MODE)
 		return XDP_MODE_HW;
-	if (flags & XDP_FLAGS_DRV_MODE)
-		return XDP_MODE_DRV;
-	return XDP_MODE_SKB;
+	if (flags & XDP_FLAGS_SKB_MODE)
+		return XDP_MODE_SKB;
+	return XDP_MODE_DRV;
 }
=20
 static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode m=
ode)

Regards,
Lorenzo

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXzzwpwAKCRA6cBh0uS2t
rJakAP9oK/7ojB74ukfFUa67FPpE4FN+Y7HUSlamOIgdLP92WwD/ae+Iksu4We9+
c1Kvbz+hRLhsAzrcX75+zppCSJ5LugI=
=nP1f
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
