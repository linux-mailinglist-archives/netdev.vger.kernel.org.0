Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3153F6ECB
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfKKG5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:57:45 -0500
Received: from mout.gmx.net ([212.227.15.18]:46729 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbfKKG5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 01:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573455361;
        bh=PDcMlsTNCVoRx2qfDTLufTFxlXCLrYMeLsjNAqTRG/Q=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=HfqxP65F6w51fsv1P0/ZPY3bCrSW2AL+n0F5dx1q4l7gDIZjQ4T0Ns3XDnoaGz/NO
         naUgKVJth9NBizgog6EjQ0XeJoQgOfdWduGBFm8fm17votdW3RLiZutcXLkrGLzdTD
         kNFOy+SaRiJClC13ROpBtDCe65JwbG4Ojav4+QSc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1Msq6M-1hbHCr2bsm-00t9N5; Mon, 11 Nov 2019 07:56:01 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V4 net-next 2/7] net: bcmgenet: Fix error handling on IRQ retrieval
Date:   Mon, 11 Nov 2019 07:55:36 +0100
Message-Id: <1573455341-22813-3-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573455341-22813-1-git-send-email-wahrenst@gmx.net>
References: <1573455341-22813-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:tJhOetkiIh6PrprbPRKXYAtx+HAC2RlHNL5fKAuiJHmf6KO+I1W
 oSUkUc9Nkatbi8GZBpGN8EGQVwe7w7gZ985Jb+aitMGtQRsNv8nmqsvXtoOCHpysVwO/Om1
 6WRcpq3o5DKu7CvfaWRIgshkKH2S+SyuG85Fvao8LNMiSwJbr/80vwz8M0qtGl83CTSU0yB
 FKHR9K91Dfy4lOUWL1PmA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sIyxer6VW/8=:yhQZQcwXDUhs03Hp9PyJWh
 XMR8AWaOIrqiuvOZBtw53P9WCljXhJXQO3TPkUyqp39jWdG0Jg40rfN6JEeyYEdkPjXy2PQrU
 3mV4WyOdFkK6euLtDQejeqH3BCfn3h9157M4KUs9E+mp6KWUXJ9BDtzf3QP69TyY6rILiJZDt
 eTLBFs/1/FYow8wts1QFNYExKpFSeu4xNRz3g6cgRnqpHScjFKRTzS2RzcjjX/WLnfOxgtLS+
 CYsAKCNKOpae+QVxpiJs5VX8OiH7UvGxTD/J3NoKVJJydg9v5C5A+z7gtWMN0Shz3b7iOyovd
 k5xcbiEcEDTfGMhf4jGRaJP+Req3jx7dszZ0+w75FXqtKA8rZf4g1N2bWpXbnaXyq2ODu/Is2
 Y+DbnQlFgLNyU0ltzi4HKuoueRODAWzP320OYyjDU/Rm2lcTJN+5s9JeiY03avuxM471RR1Tj
 ynJtptPluIDhYLCCfeRC4/y5ibezsLHBy0ltMEI2VFEkRepcpj+LdnpsHbj24hVVn/uIRRXVy
 R5uGrWEOZKFiaOlKm16EBa+8o/q8GTD3hReTyPgi03C+X64yuQZBQDl9Y5I1nx5k+F/0BznQF
 gqrgzrXSq6q0ftfnZS02ejp2XkxJK2xS3X3sMpDemTRsoQnJ6RoW6XFT5Z7t5/81ubDTaBdta
 xsmbPcTnOuqK0DapfopqZMDQ6/XyQSxmiHJQEYKNdcJ48JRpFgo0ctTa+ZE3mCrIyrDVoTO6z
 dWHLRFFl7G50kiqFc7s2qB9VUCOt9H2nA5dMu4r4bWyVbSJGR2fYxOeNGYDocPP854J+7pYu/
 IAzUbtmSBrFE4Awpgnu9ePeGML46Hs6uIwx1DFtAFfQw/p1gUFYSE8znyexoFeWynuPVz2O5Z
 AsJ2L3QXxwKxVoYp6NMQqIzif9hZTTdDlFh/2xeU9hhvZchb+4WFR+dgHLg3L16ceNd4ueZ2H
 dr1MCrktx64umgx8NaDw4tPv35hJBetSq085R9P9xT8OMU6nL9TWMZN2SCfSQeuaBa+QwLdRw
 HZjX0TWwDJVgD0MOsM6+jF4NhI79mDGTeND4c0GYsok5xZtrp2eQN89syOzGub5VfogE4C3vC
 eP/TFHJ5Q4nc/cEkBaNIU5WUyludnAio5SIq+S7UFD8T2K9DTPVNmH/yMK4W3c2yOhE048CYT
 5HuwSCrWi21+Qp/k5IlHvMoxjpwLMVHqDdnAC3JvbEFogA4LViEWXvvLbuav1Fu/Gh7mx/O5J
 XXpgpCn6R6/GMJpvJSCTfi3wn9XiBUQXgd5Re2w==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the error handling for the mandatory IRQs. There is no need
for the error message anymore, this is now handled by platform_get_irq.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
=2D--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/=
ethernet/broadcom/genet/bcmgenet.c
index 575f162..ee4d8ef 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3458,13 +3458,16 @@ static int bcmgenet_probe(struct platform_device *=
pdev)

 	priv =3D netdev_priv(dev);
 	priv->irq0 =3D platform_get_irq(pdev, 0);
+	if (priv->irq0 < 0) {
+		err =3D priv->irq0;
+		goto err;
+	}
 	priv->irq1 =3D platform_get_irq(pdev, 1);
-	priv->wol_irq =3D platform_get_irq_optional(pdev, 2);
-	if (!priv->irq0 || !priv->irq1) {
-		dev_err(&pdev->dev, "can't find IRQs\n");
-		err =3D -EINVAL;
+	if (priv->irq1 < 0) {
+		err =3D priv->irq1;
 		goto err;
 	}
+	priv->wol_irq =3D platform_get_irq_optional(pdev, 2);

 	if (dn)
 		macaddr =3D of_get_mac_address(dn);
=2D-
2.7.4

