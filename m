Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A58AF8091
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfKKTvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 14:51:49 -0500
Received: from mout.gmx.net ([212.227.15.18]:55455 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbfKKTvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 14:51:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573501790;
        bh=taWXA58DvTrq62BOOg57Z2EuKGOOTGhqKhyK1g3A/ds=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=A/KBgjd1cp+GvJFSlgecj+stsDiZqZb0fqtukpXswiuTZyjGziEGdvACPHvUrkJoz
         NgzQnfxBmq5XUIk+E4K8HlbPyH2Jgv7vqwD7IldAzeDDyEEze8w0Wnv1OrH4tQxs1v
         qsOX3XBOHXTSa+H3hmVW9Vwc4SSlYqt/t35+DQSs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MzyuS-1hjQCG32zW-00x0eO; Mon, 11 Nov 2019 20:49:50 +0100
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
Subject: [PATCH V5 net-next 1/7] net: bcmgenet: Avoid touching non-existent interrupt
Date:   Mon, 11 Nov 2019 20:49:20 +0100
Message-Id: <1573501766-21154-2-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
References: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:Vn23tgDCDcdTg1xYnHdkw2UX8yHSxhCJJqMtechmWWjMUjg8tzL
 3k8eiqfqsYa5eQWFLLN+tG95x64undUG+VcacSddSHVC3s3CzzS6zDGsiGo0X5ES+4RbCrR
 eA6/vgROl4A1iv6FA2i+19mzwq6jDYzuKFarmMLE+66SFW8rUw8vZYOhxf0Jewphbi3auVw
 eIngeFYtyoi61dFpWrfAw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ko8Y9vRapm4=:P7iuRZplRHa5+9NnbcC6V1
 YCWl7UfqaEjTqF3M5JbtOQXI0i09hwW0hvv+qurfCyWCnEgRjs2NXM/INqLLpnwFXRceY9kIx
 Yk8y9FDwP+JMu0thxOgw/3XD5fDBaEAnMx4oWhXapAuGCAn1IsoXSCCNqgQWxMMVW0IHebN10
 JMwKCOKuDI1TL+jwGrUcftw32hKLGSUxmY4PKb19H1Mm9MAmARKLdqNIbBkfJgJS1xsSyvmsO
 5xh36By4G5uaZJXaKYQCe6N1nr07UDlelIR++/hjg+/aloHNzzRtvx8gwC/7gQuBEL6l9l3pg
 5ZEod4QYvsr2ps29/JkClzCHPe1Mp70lqKNBOxCPyhmtPBXv/IXstvAC2pbaLlXLajHVzsYpP
 S81TPOrKnSleosii2nPYJ3+YaLcscDUgPogZS/1zZom8nzd1n3GwFQ/cMwhaCqHvO81il63E2
 KZaEEXjuNmE45QLWLTLCMc7WGsGjU0mHdQASc8EH14/KI29ogOacVXeNhSPeEYAfDJKiYwn55
 /YtnHstMoyG9uDRU8D1fa0nsHVAWDYJtpLTOhiB4/43PVyhS6ieO2LVGy2yUXi41AZtz/J+pc
 qEqYbTCZ1Vg3p3IuOa7on6cYMA3YedinV3wBNGF2pLJ2Ni267K1jDTkJP9LB+J7imgypl/u9w
 9AlCFAjZ+jpUBVEsCMGYYNy8Au7GMRqtKMDrR09WgonrpJMOQ+AlYiSGgHoRFN3bmo77A65SI
 jpl8y3h19tphwzU7Nh4l+vAVaBdaChUIp8YIZbemzmPFo5cFBrStOhAyAFnXn22kbOKyML/oj
 AoBprc7NdD56xQ5nW5/46xMEXHicVhl4ONtPVqNRXnRzxbEiNH4Y4W275jTBk5Bwba2kadKyg
 tan0zmPi9FR0F0bLZ/I8az5xSR715DAq0Q4SPuCo3esxolaXq063uIRiTNqhRnVebMYzL2zCg
 TYXPqs7dSOcFri8Of6OCjov6Mb7+MaoOvDDBwEaW7mTlfF3gjmxtCBmIgAqRuTNuAWOj48ByV
 k9xWct2Nm1vXTIGDYtFRgZRwKV8eRAfFSmbGb2/CooKnbDkBkodSL9rJuJyVCuCReGe7ysNU/
 GKfqstmzyD6Z1StZs7CCa/wlljw/Z7roneIkh6nxr6hNqhfUpGkyCNe0ljUuB3i2NGLtgj+Dm
 rVZFbVJHcXDvrKFWhd6LFAb2wtZS4xrQhFy52skfokmnXIQjfqKi+i4TA2vVgXYQ+7cw0SbUl
 2Q4nDCSXo5zy6aZVVKtWk5uUM7qTnMvQcsJCuww==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As platform_get_irq() now prints an error when the interrupt does not
exist, we are getting a confusing error message in case the optional
WOL IRQ is not defined:

  bcmgenet fd58000.ethernet: IRQ index 2 not found

Fix this by using the platform_get_irq_optional().

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
=2D--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/=
ethernet/broadcom/genet/bcmgenet.c
index 3504f77..575f162 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3459,7 +3459,7 @@ static int bcmgenet_probe(struct platform_device *pd=
ev)
 	priv =3D netdev_priv(dev);
 	priv->irq0 =3D platform_get_irq(pdev, 0);
 	priv->irq1 =3D platform_get_irq(pdev, 1);
-	priv->wol_irq =3D platform_get_irq(pdev, 2);
+	priv->wol_irq =3D platform_get_irq_optional(pdev, 2);
 	if (!priv->irq0 || !priv->irq1) {
 		dev_err(&pdev->dev, "can't find IRQs\n");
 		err =3D -EINVAL;
=2D-
2.7.4

