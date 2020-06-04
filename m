Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B634C1EED6D
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 23:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgFDVl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 17:41:59 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33572 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgFDVl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 17:41:59 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 119331C0BD2; Thu,  4 Jun 2020 23:41:58 +0200 (CEST)
Date:   Thu, 4 Jun 2020 23:41:57 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] net/80211: simplify mesh code
Message-ID: <20200604214157.GA9737@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Doing mod_timer() conditionaly is easier than conditionally unlocking
and jumping around...

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index aa5150929996..02cde0fd08fe 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1105,11 +1105,8 @@ void mesh_path_start_discovery(struct ieee80211_sub_=
if_data *sdata)
 			       ttl, lifetime, 0, ifmsh->preq_id++, sdata);
=20
 	spin_lock_bh(&mpath->state_lock);
-	if (mpath->flags & MESH_PATH_DELETED) {
-		spin_unlock_bh(&mpath->state_lock);
-		goto enddiscovery;
-	}
-	mod_timer(&mpath->timer, jiffies + mpath->discovery_timeout);
+	if (!(mpath->flags & MESH_PATH_DELETED))
+		mod_timer(&mpath->timer, jiffies + mpath->discovery_timeout);
 	spin_unlock_bh(&mpath->state_lock);
=20
 enddiscovery:

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7ZaqUACgkQMOfwapXb+vKyqwCdHd1ip1n/N1xi3CytHvd/tfr8
JYMAoJW3Y/uAFJlNHOVs8U5w9fTIgfyi
=g+rG
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
