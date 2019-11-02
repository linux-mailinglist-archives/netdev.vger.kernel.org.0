Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0FDECEDB
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 14:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfKBNmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 09:42:24 -0400
Received: from mout.gmx.net ([212.227.17.20]:39781 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfKBNmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 09:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572702114;
        bh=t37Bbd37Ccjo2tsA8xcaxuE8pZbiD+UMaXKQ1I8p+k0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=RkWQLl7ajsSGAWppXkAWFfzu/FRxiVAX0iYeu6TYy18syol733oP5k79lM1zj5uqa
         muXwOjqwsOiCCByny10bR2m4w+c7MmnNzImA/dX+/wuTxxJS6F3CZfehFhdnxT2TGP
         tvETtUZhCvBxxfyh0BO+zeboivi7B+sX2/Hyrumw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MdNcG-1hrYqQ0udk-00ZNVM; Sat, 02 Nov 2019 14:41:54 +0100
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
Subject: [PATCH RFC V2 2/6] net: bcmgenet: Avoid touching non-existent interrupt
Date:   Sat,  2 Nov 2019 14:41:29 +0100
Message-Id: <1572702093-18261-3-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
References: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:m70ZrcwjQDnPhyAoISCZwujzpEcNMroE6UD6xkpYQpJr0Stf0e1
 U/xs+b03It1McpME+nIS0a1tNlbl9VYbgBwyYENB7ug+O0x/3HfWu1QwhfBymzLB/CHFpJr
 4t+I6At5JhECJ9jAPQxPral/jbWZM+y3OGAc62QzDOIMhGY66/LCZ1hXsnGFTZQvmtNXaYH
 9BvIaHuqz0PMVExPlWRMA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:a2cd4/ZezW8=:INoGZaVH+y9KSWDZV4bTvI
 ezpJhyU/brrpwp318wl44izLQT+wF481cufb4kP3o28qR2QnNX9AAii2UcZdYU290y3m5PdBD
 Ty2AAk/oqiEceKF5JuTLEmUmfGru1JxZlxLxBvDAymZmxbtNBN1vgFpU31YK2fLecyvImimNK
 KZjDP0LmkM4kGLj+3o0hbAs9E2K07pYrYy1Us+XqTgAbi+eIKrwXQSUPWG+5iGcHL8RhHT63V
 mb1UNlIu+AsGQDvyFrcy9tJCsa9OPAdsCV0XKfebxlbAfO6qgi7J6xSqZruFVULv9eEtanTxH
 Ji/JuMjFbayCQTW0QvfG1w3JhYEyWd7UWX65a2Z6mmnfFNxuc7c3dg/AbWHbHN+xQ98oaRGoD
 dYGinTYafFLS30jjvFrJK60QVLT9ZKMwRXJZgIFSEKBnrt4p2jBWJfm+iVQBMa7HvJj0oiO9D
 8VV+4Z6Sp4W2X1qcF3DFI+zCLv97C/vVMBxDZ+cxJ9QENhiWK0dukpBMDolpQEzKwVZnDf1Gu
 wcv1ieQRaHOXr5D95VF/3PILKs1wX7oRzMSMkL3h8z7xFqeChl1BC+nt6QJpxh3cRNP3xATs+
 YIvK0Xit1gA0AET9HyzakvkQK4Je/nxJ5QfaBcjvzk0nJmtX3068djY7tjnEQfaJNXosoIHWF
 3hVjoVVZ2z84z4OoyQHua46Z8703azIk2LTJMVHwxH/o6HDfMaVWUI9bYuWBn/EOnCm6j4USm
 7G4KJksgUbYmlYaPWnAesyMuodsbsmNNepfC+5jGNrWb36Va+NS407BTgCEzHGhdSM0KSaaiY
 yea7A8jTGX9T+Nl/uSfhzSr2ZIEB7/eWQsYJc/RV3rECpkwVOXTzKeXlfsL1BTcXmr7cchfRy
 K6nc2n7xoixrnNqpgaOuYrXvvOp1e7ROYLw4uBFWYVj14azuLT+8UGCe3G9iJCN1haypTPqO2
 XRKZYpBXqObCHBTdxdxBpDlC58P7kInUurBvipOla8M+XKTwPyK20E0v6kknYMPI+WTXA4yYu
 0nTcD/a4hi7pLB9mlFLRY9tJkXeogmKy0QA2SpqlL1P1LFGFXC3VslK7pY5D/eH32LRPhvc6Y
 rA0rAe75XV9XBMVcJ1GPTVx58ffn471sypWJIeVx9ds22tgC82gM3jtdQjInVD084okx0O5Mz
 +E1NHOBSEmp8AYJx8wNCnp6mmr21n6DdXaDPx0lekh4N8BSX5pdqOK2MZar/zjQeNPOKv+N4j
 OqU+Pr+QXEhooQAJwaKojNK1cdY/7DqPgtP5QMw==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As platform_get_irq() now prints an error when the interrupt does not
exist, we are getting a confusing error message in case the optional
WOL IRQ is not defined:

  bcmgenet fd58000.ethernet: IRQ index 2 not found

Fix this by using the platform_irq_count() helper to avoid touching a
non-existent interrupt.

Fixes: 7723f4c5ecdb8d83 ("driver core: platform: Add an error message to p=
latform_get_irq*()")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/=
ethernet/broadcom/genet/bcmgenet.c
index 105b3be..ac554a6 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3473,7 +3473,8 @@ static int bcmgenet_probe(struct platform_device *pd=
ev)
 		err =3D priv->irq1;
 		goto err;
 	}
-	priv->wol_irq =3D platform_get_irq(pdev, 2);
+	if (platform_irq_count(pdev) > 2)
+		priv->wol_irq =3D platform_get_irq(pdev, 2);

 	if (dn)
 		macaddr =3D of_get_mac_address(dn);
=2D-
2.7.4

