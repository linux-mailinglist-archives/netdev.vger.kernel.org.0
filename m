Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DA11C260B
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 16:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgEBOTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 10:19:43 -0400
Received: from antares.kleine-koenig.org ([94.130.110.236]:41688 "EHLO
        antares.kleine-koenig.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbgEBOTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 10:19:42 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 May 2020 10:19:41 EDT
Received: by antares.kleine-koenig.org (Postfix, from userid 1000)
        id 0373E970BF0; Sat,  2 May 2020 16:14:12 +0200 (CEST)
Date:   Sat, 2 May 2020 16:14:08 +0200
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>
To:     Arnaud Ebalard <arno@natisbad.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc:     netdev@vger.kernel.org
Subject: network unreliable on ReadyNAS 104 with Debian kernel
Message-ID: <20200502141408.GA29911@taurus.defre.kleine-koenig.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Arnaud, hello Thomas,

I own a ReadyNAS 104 (CPU: Armada 370, mvneta driver) and since some
time its network driver isn't reliable any more. I see things like:

	$ rsync -a remotehost:dir /srv/dir
	ssh_dispatch_run_fatal: Connection to $remoteaddress port 22: message authentication code incorrect
	rsync: connection unexpectedly closed (11350078 bytes received so far) [receiver]
	rsync error: error in rsync protocol data stream (code 12) at io.c(235) [receiver=3.1.3]
	rsync: connection unexpectedly closed (13675 bytes received so far) [generator]
	rsync error: unexplained error (code 255) at io.c(235) [generator=3.1.3]

when ever something like this happens, I get

	mvneta d0074000.ethernet eth1: bad rx status 0e8b0000 (overrun error), size=680

(with varying numbers after size=) in the kernel log.

With

	sudo ethtool -K eth1 tso off gso off gro off

the behaviour gets better, but I still get errors. In tcpdump I saw
packets received that are a mix of (at least) two other packets sent on
the remote side.

This happens with Debian's 5.4.0-4-armmp (Version: 5.4.19-1) kernel, but
I also experienced it with the 4.19 series. On slow connections this
isn't a problem so the problem might exist already longer. In fact I
think there are two problems: The first is that the hardware doesn't get
enough buffers in time for the receive path and the other is that in the
error case corrupted packets are given to the upper layers.

Does this ring a bell for you? I didn't start to debug that yet.

Best regards
Uwe

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAl6tgCcACgkQwfwUeK3K
7AlmjQf+LKuXJKedfRkGJLeb+8mikI346ZsDI60Y52sWtnZZ+J7D/BMQ3ZHzI34e
cmO2p/LvLvkuar59jEclUf2Smijwa++IPWExMdeuuJsQRQ83sD4KcDW5lzBZR8fd
HNAh9dN/yHBcTh0ixNNaMoUwkVl/jRuJ58U565/ahxv8iIcIx0yAGQVgs0RZtVv9
6IeXNOw3dAQzXHrmLrrdniAvfO0zhE1f5+inWZ2r73/9bFyHSuDpOpW2zvlWilLD
LpONXLbdbykF6K1m9fHFt5scNxNzXRhH5/TYezvQaRqYWYMS+9zrvdK9MUVliWgG
k4QVReaLpy30DuZGBZS3bc+f7V/opg==
=uTJQ
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
