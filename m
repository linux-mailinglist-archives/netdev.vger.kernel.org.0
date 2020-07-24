Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA62E22C5B9
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgGXNHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:07:01 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57296 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgGXNHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 09:07:00 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0DE021C0BDD; Fri, 24 Jul 2020 15:06:59 +0200 (CEST)
Date:   Fri, 24 Jul 2020 15:06:58 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] slimbus: ngd: simplify error handling
Message-ID: <20200724130658.GA29458@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Simplify error handling; we already know mwq is NULL.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctr=
l.c
index 743ee7b4e63f..3def0c782c7f 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1396,17 +1396,11 @@ static int qcom_slim_ngd_probe(struct platform_devi=
ce *pdev)
 	ctrl->mwq =3D create_singlethread_workqueue("ngd_master");
 	if (!ctrl->mwq) {
 		dev_err(&pdev->dev, "Failed to start master worker\n");
-		ret =3D -ENOMEM;
-		goto wq_err;
+		qcom_slim_ngd_qmi_svc_event_deinit(&ctrl->qmi);
+		return -ENOMEM;
 	}
=20
 	return 0;
-wq_err:
-	qcom_slim_ngd_qmi_svc_event_deinit(&ctrl->qmi);
-	if (ctrl->mwq)
-		destroy_workqueue(ctrl->mwq);
-
-	return ret;
 }
=20
 static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXxrc8gAKCRAw5/Bqldv6
8t64AJ9TkLMXPTQazgz1+ieXgOtgBpnQygCggKxDeQohVmkoaZvXGkAfjTtg0hk=
=qEGF
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
