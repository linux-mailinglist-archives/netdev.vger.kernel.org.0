Return-Path: <netdev+bounces-7535-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B480720924
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F7E1281A28
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AD471DDDC;
	Fri,  2 Jun 2023 18:28:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703071D2DF
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:28:26 +0000 (UTC)
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1B8E73;
	Fri,  2 Jun 2023 11:28:17 -0700 (PDT)
Received: from [213.219.167.32] (helo=deadeye)
	by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ben@decadent.org.uk>)
	id 1q59VX-0004v2-LU; Fri, 02 Jun 2023 20:28:15 +0200
Received: from ben by deadeye with local (Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1q59VX-001CYV-09;
	Fri, 02 Jun 2023 20:28:15 +0200
Date: Fri, 2 Jun 2023 20:28:15 +0200
From: Ben Hutchings <ben@decadent.org.uk>
To: netdev@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Eli Cohen <elic@nvidia.com>
Subject: [PATCH net] lib: cpu_rmap: Fix potential use-after-free in
 irq_cpu_rmap_release()
Message-ID: <ZHo0vwquhOy3FaXc@decadent.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="m0Nv01qLvHn7PZAp"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 213.219.167.32
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--m0Nv01qLvHn7PZAp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

irq_cpu_rmap_release() calls cpu_rmap_put(), which may free the rmap.
So we need to clear the pointer to our glue structure in rmap before
doing that, not after.

Fixes: 4e0473f1060a ("lib: cpu_rmap: Avoid use after free on rmap->obj ...")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
I noticed this issue when reviewing stable changes.  I haven't tested
the change.

Ben.

 lib/cpu_rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
index 73c1636b927b..4c348670da31 100644
--- a/lib/cpu_rmap.c
+++ b/lib/cpu_rmap.c
@@ -280,8 +280,8 @@ static void irq_cpu_rmap_release(struct kref *ref)
 	struct irq_glue *glue =3D
 		container_of(ref, struct irq_glue, notify.kref);
=20
-	cpu_rmap_put(glue->rmap);
 	glue->rmap->obj[glue->index] =3D NULL;
+	cpu_rmap_put(glue->rmap);
 	kfree(glue);
 }
=20

--m0Nv01qLvHn7PZAp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmR6NLkACgkQ57/I7JWG
EQm8BQ/+IhHzfoOBpkoqD8Ru0N4tPO9nVB2TgpPcCMJvAMAUM/p9NsiaDcjqs2m5
aqLw0cdgT8zwqQomfsZQFoYlrZ3bzxWQkTPq6p7c0pDdQ7SFdTZDnBjAd/P7MNzd
zWn17BjNDCsnn2F65nkX//4oyRdM7mTJssyOW1nfmycGWPh7Rhm8o2Ha7vYD9NTC
9Q1daRjZDkA6asoW2oZo5v71ojX2TG1JiMh5M3VfdEH2/zy5GHyIbSv2p/PpzoPn
qIN+ZlIrT8tLT1tSGHVhuumf3ASWDEZaNnrVPY4VZ5jtSk2tQrlrUYNzMwqwL8ab
e99zorg3m4tIwnX+ReL3AcvVKEaq1cJGtpSAzGCizp4gs2mULLdacVCGXCg+iBvt
o8c+7MiF8hiSY4wqtJPismxg5m+kD1nwJ8to1L6Kjqvjya/Nk3/qJZ65lMr+TCH1
vlTvLt+6MDcIi29SxNSwKNR1++f8p8MXWKUmADTXPpU8hn68oMpYQJS48ib5gNjs
CPWolExGVot3ydtXgXbppUfaMBmowPDurxR/nRjbg8TzterCXpPmu+3tnQ7lVa/5
HJtflKq1kVJZVandFP8r5yBFGr9utOCBouyXcS830O0XA/x3GqVuqD5/dT196wdY
dicpAOMIuu5OtgC7LCleVJXeV8TpJcbnCJvO5mBXQa9ddSXejyc=
=BRu5
-----END PGP SIGNATURE-----

--m0Nv01qLvHn7PZAp--

