Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58DEF60F5
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 20:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfKITCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 14:02:14 -0500
Received: from mout.gmx.net ([212.227.15.19]:41751 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbfKITCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 14:02:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573326037;
        bh=rNLogK9BckiGL3DWCHYqrkutclGgvI/HzJvgD8WpP8I=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=IWA2bLKhQDSqj1tzimAlavx1IhV9w3NxwDDwiSBSbtrjkQg5C6bZMRmJRdrmyI+UD
         BMpptQq0aiMHEidBK9SwT4LPt/1HJPvjA4dT8QdBJLghGwuopX1QAtaw4Mz3tIwViT
         cDEV1ZNDedxcqnN2jEKQ5J5l9NIDm4o7TDcM7Ijc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MGyxN-1ifwZi0JG7-00E8fU; Sat, 09 Nov 2019 20:00:37 +0100
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
Subject: [PATCH V3 net-next 2/7] net: bcmgenet: Fix error handling on IRQ retrieval
Date:   Sat,  9 Nov 2019 20:00:04 +0100
Message-Id: <1573326009-2275-3-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
References: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:4hzkVM4QKJ8d4ZSUQvqpOkMCKuVe0WVjgAfvovY0aLWWzOpe3Pn
 fzp6WmC1IYxCx+Z+LTdVn1vtn4kWxHZa8u8hf0oB0Dc+i4zbo61MOINMQKskxtSX33fmrku
 d59mDpxW0IWMf3YLVIUsCBi3zbGY4ELWT28j5YPoeg7OExmzkA9p5EBuLPe387fPwZQ+/P5
 gJ9Vfv6ZP7573QJFVBI+Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZxUtQu/2WJE=:aIe2ycJ19P2zrRHvWpOtoj
 4CKNc7ixVJbc3LW3zOyEJEXU5te+4hhGDb30yMu3q33I+jntOKMfzOa1ECLiQAavcpGP6vJF2
 2uO/BWvRHteqIP7wC2xWBozWN5K+yAhIISdLnjokGXtCwKRI9LaEMRbjmyzBkyCNxpLvJXoqd
 fL+YsrWk0IeHcEQzD92d+fpqnkADCK9zFo9kDTY7Ab770++gvobN/RV77u00O6QuvmQeJydDR
 5TeI4wYPteq74mg3s6YJOJzdfsglogvJiUaHQswS1aLFG30jdthOWxU3wIpKuyEYm0mv2sfoM
 2bPRK2cQS/Zn1VDf1iluCIuoVuR/YWhhjwJqYT+hHNtFRKPUq62ZdUGCJc6/NgeU1L/A9qit5
 0bQN8Jh8m78pV05hbRYaopMqnw0OInhSHS0TUPLS+Nw6Z31a0oYEBLD4l02TELD4Lb+Ab8/rv
 YRfcWzRRDuQ3lXz+/ry+9lusmdgF/i9OmPKOhcRvfTl9vcobSffqRBdi/MxmUYtqNRM8qOTOi
 vylOLKevEkzqPLie0nZ0xwEyR/HmhwRxnx9V5wtew+dUMbQNuHFpJXEgNonjnTikalPfzStB3
 dbogMhaIPbj8l9mDzqMEdZ7gvYlOlXWcT2QSYMQTZsBkkaUkscszuWwxkeymxddGBGcykW7Pl
 1FnloRD2IuzbTV3Z5r77kSbjNALvKcK+W4iWIOzByzjRLRgzFEU9LMYLajvv8ntKeVBMBjFD5
 W7+9TIpchnrau4dTaPFhLpolmiL4XKVvjUB5pu76F+GgYW6hPe7gN5fe/eULEVGOqDx82/17V
 xbes/3K4ot8gwjAjnBFJmWcJ7Nb7bhuPZw/DCd/WF3ythQmQUgMeLF+r/iUX+pYuo1u10iXqQ
 BzoAF/4HPhytGKJXJdr4KLZGsFGTP5XbvJ0VWbaUC/VCOYRRIXRaKh8toDNmyxVIocl1krqIe
 BjUhMm8SQi5kVTyOw1fHrhVWRAvk/MfRhwjHb2Ow+n44gPfxt+4aDQMf48aulzxQwa7fHUQ3Z
 D7OrpeNrKiUQIKMm07U5a38461r3xKUhgzYZpSkdzFUfP5SR9v7zrfBAE+qErj6pKarbLAcj6
 dQB7eq1gwEGaJgBy6IY8Vcy1GPLQRNMxpmAClsiG/MWypaBTOxz9tyrOAa8ByWEXooH4gbWiU
 PgBUfy7Hde0GxJZKyx2197c5juIPgKdvvy8LIU079BAxkl+t4m81WAtBMJCILffl+OCj0/Hr5
 OcnBrBRpQ9urF8i+C7i5/0AURtpdtqD8pWMko6w==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the error handling for the mandatory IRQs. There is no need
for the error message anymore, this is now handled by platform_get_irq.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/=
ethernet/broadcom/genet/bcmgenet.c
index 9f68ee1..1858ff7 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3464,13 +3464,16 @@ static int bcmgenet_probe(struct platform_device *=
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

