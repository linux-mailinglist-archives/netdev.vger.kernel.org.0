Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8C5F8087
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfKKTvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 14:51:40 -0500
Received: from mout.gmx.net ([212.227.15.15]:58943 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727458AbfKKTvh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 14:51:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573501791;
        bh=PDcMlsTNCVoRx2qfDTLufTFxlXCLrYMeLsjNAqTRG/Q=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=e6VDnkqN/GjWfXRN+3RPAetHrQKaByV8xvtUpUs6fCMz+5mi1DrODshBgX9aJnI7F
         DLG2l5bEcSgrxrsNOUDVYYbMuZiEhPBndkjZ746PFt9O61k5THZXuLh1Z5BbzZtR1G
         N70bfmX//GMAWCGHNkhcAoX72wFBkq+6zYAo8iYM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1Mk0JW-1i1TSZ0meu-00kRZO; Mon, 11 Nov 2019 20:49:51 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V5 net-next 2/7] net: bcmgenet: Fix error handling on IRQ retrieval
Date:   Mon, 11 Nov 2019 20:49:21 +0100
Message-Id: <1573501766-21154-3-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
References: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:dM7skxclhbRUMKWP3MbL6zRTCYfjFKuM73YgvozwoH1DWTlJBlu
 illYPB9DIL8Lla6T4g/TzHImP8HKEcJXDniUnPbeDmg8C/0PZgi+UmNAsLYdGFkYhr1Tm43
 EWgG4ZVTea1IWnJbo6nLBNNk/O72Cn+KG23UAocPBabWpSdv7BmOUlWzCV0LgWHHZQHZ591
 sl8TxybCfnR5+RgkRqYQg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ao/Namynt30=:74ucEwRxe5+EmU0eXIzQjF
 DjWYmZZ7+x2ExYuwzQEBUad6d/p00KSqazR0d2H8yLy/0/z7mWgN6bgJ3Jv7aK0grD+gL2wfM
 ynYFNK1361/q4t3S2s7sYopp5/GJ4ob8LlO6lnn5wIIjJTt1MqMnwbo7RRlIpGYy2ydLBEH5G
 CQ6G5btVXh1rRBSgOnQDElFR1OEUmzNfYMQxYFHAjSQysbQGExWQspWCNrk6cErV1kQUNsZl0
 WA1Dr2E2xXccYgQKRgJxIffhTj8AWIBkh9s52ddLPhfo29Z+67ih1PtYp0+LLKjRWN+dfAy9Y
 eTPSeIaQWLbX3BeC79lH7VhWL58l+2VP9dJlgXT7TbxTKXxyRkH8PUkSPoDBhqcS9abAgXmM6
 1JcLysRtNbYmkF2hKS2a2ThpKIiD26JBKaIS2MJgHhTIYXRkamVxmDNpVCLVmGn4wFpkco+Kn
 p1AbiiiEHCHYdeMkD/R1RE0cIos6N4MnNQty9WkOct3K7arhiLqCfHufDnXvgEXhvHkig4Vr4
 Ntpg+iy3OCDFng1TdyVuuGDnUxieW6y6bHMeZSI+yEp798wfFfDZUIJyHkx4W9rGuil+sHX7w
 Ldn0Ly7HJdyTRiEa2flgNZKkbfO0lJNUMfcpGGKQCrIkMU9WyFp1NJIFDid6fhEIL8/L6OGgp
 sQhJPTQTfnC2hnu1hxUSX1JONdyciCvTXCb3BS75L0pFwk2TwK18pAvvJEwjkuHBm7W0rQ8RZ
 6KKxxP3+Cfv0JDt2lZLuwKE3lOnSIRRK+qtrxiZBulmfORp29SShtiLweyoP2W5FbhLBT/e9K
 iBehdjYKTkq3JF04ebQZvGByLPldQ4hPCf9CM3i8kNfs9fpbDYz5IhCEytsMCsFJTHcGVEysE
 wFb7ct2PIgsYBmfOeUhfoYZRu1detYW2HHaivR2ZEP1RIQd9Fj8ra4B4j4zvIFQGW1RhkWXXT
 jhmNVWG/epi7ueQ4SU40sL1l3wcf9xZE8/hapUuaIOrzGdWvIjJ6dwLEqfroFnuK1xtO5XLZL
 8B8GOYteByW7ZoqXWkUSSJc7v+qTYLQwyxFHL5DvDaCn0yjPs06MBcz9fG7fbIri6yqgDL/5j
 MtL9t3A4c5NaXGJBEcKtRB2oszjPGr2sUoAohpGe4/5qKsjCsHD3g0y9cE2HN8i/43bq0FHW8
 IfB45zNxhcBKGovHRYoYaL3c/Qg4Y4c5FyuJ1I+cEVmC7y+27F9Dh5NgRpGvdu4XybzLcPPwZ
 cbcDh9bTp8/QbdWVPOdWYzT3UyniAqsofJgkrQA==
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

