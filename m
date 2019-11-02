Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3000ECEDA
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 14:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfKBNmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 09:42:23 -0400
Received: from mout.gmx.net ([212.227.17.20]:48529 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfKBNmW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 09:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572702114;
        bh=Gt8mtaRoWgef35XMJ2bznCxioijqTL1JeO9yIP8m0jk=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Zluhl/HQN/QJi8FpCGnsv3PiWab2FfFsaZFJYue2XZUDutAZF0s9dPtXFWBY8anxo
         cEo/GLhNmvRcqmFof0fI7tnotkXNjyd2q+8ajBh4oXjKP/IMu2ZxkLUKgM4mtNjLsZ
         bSIx3yJLWT0FF0rX+OhjTxlveNJLjkoPHdJ3zZxg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MIdeX-1iCMvk3Ent-00EbY9; Sat, 02 Nov 2019 14:41:53 +0100
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
Subject: [PATCH RFC V2 1/6] net: bcmgenet: Fix error handling on IRQ retrieval
Date:   Sat,  2 Nov 2019 14:41:28 +0100
Message-Id: <1572702093-18261-2-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
References: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:4KOkdHKpqwUQBL+sP9jFmD/wRZEjL6GMtTHhcX3nDLnL4Y5dcZd
 U7Um4XjIfonOnK7J34g2rQh/EK1hD2iUFPp4PQS+ct8tqMFN7vA1M2Ht346gAXF15OSP0LR
 0li69YNIZaGqrhekDHg7VnT+xA5LBqhh0yShLZ1WdGXn3MULzo4O8eGXoZPF13X3V/QBuxr
 6nmBp24Wg/3ZBMYm7zu6Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jUH8TvmwCkk=:rYJhhWDaD6/v9EYrP+WEkI
 2wQhuOuc+u5FT6fyBXrx5yVKOLVsTmFiTWK7rzFsnwcGJzo5Y4b5zuO55AmBM8V9nKBuyymdr
 oYPPPMegpVyEp7zcaz9fvPQIDMsw1a5a5TFHbiBTC1NVsEDoAifGJuIEjAitygwcGJJt1cFgE
 MGad+QfmPfl2OvdFtfI4+GmYUdUQNlEIEf6dzDybIqPVKEhpGacOqRq/PWgUq8ATbHrOvjbaw
 Wb5djpkbh/ui9Rb+T5Q4Ai2PMq38da0ZDrnyDiSpHTEXtXc+7Fn+Suct9XBsNTTXpTQ6M7cgl
 3+111cwcgAXJEiY5aRAWGhPJiFgUdHV1o6ozMBTN235fVZZ0Nh5AjJtpmTu8DOc45bgA8NLRy
 DDv92somX1T+n2PSgO12FR1areNNYVIMydXsa7BTnbL6ToZQZTiatVcK9CIWGu0BTi/FdK4Lr
 rkmgpBzeCV4bOJP1QzKyvoIiSXH8k/fGVtM8lfeSU3rHfeXfHbZVBzMcQGmuhPYvXYUlQOnho
 JZgT+OHImyjzpJJ8VA4kYpw1aK/mZ17gxbI9mEjS7bR5VkpeIW2WJ/5veewfo77G1DL3QMnD6
 j8by582hlVXwPBrQfphM3ZkJxdv99ETr7GcLhPFPq+1GONr+d6rnMrgmEA62s4U4jg41ZDrZA
 Q/v4XuOzIX5Yu6suSuplYg0gOY3XvOaI5FYAMYWS8rpAMOCohEL2G5aUW6Zt5a8CJBkkeL8e3
 3TC0280zjKIf5X61elDCe4l1zd5CnEf4lRdCv5Ym+oa/SEqmqEODw3MkBj0nExvHG3ST8f8rc
 7TJsAw3lnTPFAjVxZJBt5F5ejF00T5PwPDdFvFlLeiPcwG7GJmg/SzCnVjESlXHmroFcAoqnV
 anU6JGxqvLBICJ4xpAMSjcjkSVF0pdKxsj0UqLvXTseQ+q8jBEDw/OLJN7aJhQvvkZ61//AY0
 F+hEW2wjWTB4zrejq+zF0PvuN3pg413NCtUKX80CMaC5IL8BhutDzzh32/S96sNHAPiiuCMyg
 5FrucD0SWpksEI2yggz5ORYIOY2UpCNX0sE9UasftU7ay88FB4j+TFpIdOmui29YDj0N/YjNm
 JMEllR6rYUivjsP1lJTOMxlanwMDY+J5bxMMPLVsc58DgHvrOs1Brggx3S80ywWP+brHs68EI
 1cbMRZSB6ugrKAlifwY9m/EGtI3tFnn1GCBjVeshTsfpz5mZTtkFpl2huZxywOTzZ8DtqnHpx
 x4JVjrhUcbLDCf9kWDTBxov+AmwMytHWpJoTE5Q==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the error handling for the mandatory IRQs. There is no need
for the error message anymore, this is now handled by platform_get_irq.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/=
ethernet/broadcom/genet/bcmgenet.c
index 4f689fb..105b3be 100644
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
-	priv->wol_irq =3D platform_get_irq(pdev, 2);
-	if (!priv->irq0 || !priv->irq1) {
-		dev_err(&pdev->dev, "can't find IRQs\n");
-		err =3D -EINVAL;
+	if (priv->irq1 < 0) {
+		err =3D priv->irq1;
 		goto err;
 	}
+	priv->wol_irq =3D platform_get_irq(pdev, 2);

 	if (dn)
 		macaddr =3D of_get_mac_address(dn);
=2D-
2.7.4

