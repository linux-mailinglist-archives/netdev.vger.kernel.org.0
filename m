Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A5CF60FA
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 20:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfKITCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 14:02:22 -0500
Received: from mout.gmx.net ([212.227.15.19]:55507 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbfKITCR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 14:02:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573326036;
        bh=S/R9p3LmiPOl5VPxL/0bK9gmYYJNvarGPi4G/WRv2Fs=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=euMdlycNSdccdoR6BP41fiv1qFnEVYpM/cLAcRJ0svhxPXEk5hUowUq1C6TehqLBF
         3B5VVdznfIwaQXIu7Ntj2uDzru3aPudX3uxsqdx58Z4LhMb7IEaeY9TBV4IpeH5gxm
         wWWMeaw0vQKIAliaw8u0dl9QEVdgFluy91/XJZcM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MYvcA-1iPEdY25Ue-00UqCt; Sat, 09 Nov 2019 20:00:36 +0100
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
Subject: [PATCH V3 net-next 1/7] net: bcmgenet: Avoid touching non-existent interrupt
Date:   Sat,  9 Nov 2019 20:00:03 +0100
Message-Id: <1573326009-2275-2-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
References: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:RfJf8GCWw43wRxr3ZjXLWaFnAobGeS7MvOIMsPqJcymWF5y56Ct
 GkM+/XB+uoC1UnNZQYNKleRyXQCUl+yYDr4B4CmJbCAh2AHwj8JTZkdMS1uHjS24ILo3nIi
 HrM1Sjlj6eKfSFlEHlPEP/q/h5uBpL7iSdtmK+tziZKpn+4KPW1s3e4t+Ng/fZ5/K9Pf2gs
 9wsc9TPtgJWElyJIJffiQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3BhtR1v8Axo=:WuUOqDDc0bc4mYAB3R6Ncl
 haS3Z87RgtQZPdmrhPeMkuwbE6EH297UqE5r9JQt98B5Dem4M/kXdevqpCNzyVfu6ftv0ONsB
 QpZ1f0iMVuui05bG2JShy7h89fvoIQuUMG5HNMXw98Aq9Madh9CFPa7d1ew2KBB3Pg7tlVOCb
 mQFSvqspHwySjGf4JJQX7UrwAQiy6Ui6dXYiYAZuPWvx1NA1oqlH2ahcND8xsgX7T67JC3cQL
 mUcxyeJWz1Fg/n2Him8C4jTkpSnkDyip+71GSY4pGgcpUBAmCspmrlxeTNHh6C80MBMK8H548
 20iigaF8wnEg3QK4rfLdysYR8JVeDB0qjuEMKiFPrS58n5YotYQXrtYgz5CmTxZHiHNmVxVJF
 /gWRbc+7xuT0FL2x29UiwJSXHn5XQ+FTmUYgIr7sxwhSKBguzzfdR3O+MSr9calEjrDdAd0+M
 5pee/n1oN50qNzLXqJH8ovJcjoeb0eLWIvdGZK4mwv2batXbqIRsFOaMje0bNVdKc5dz64FBX
 kHZa50mIWNHhXpAOVvv3mG0GKKuqWVZnkwy50Vjn1oxPdmSV5vvi8jSdOkKCsQqqR9kuAagiW
 V4aGrACt7POFmqvf2asLGIgvh1X5eFDZS3mm78U0zbO3CRwyQ2lb+PRgjb0KI9nL/MycSMcyL
 VKv6jcWqS5H61KSqU4dphyvisifIOaUOP7aczrWz3LlAU3Eel7QKSBF/Bg1ZJtNJPpvcEUL09
 hBkCP5/wL8QlRF38XwJp89UOLvt1UIycHskmtdu36Rqe3J3R4lHny8EdlRbfvJDu9pc57D5Io
 0Nazzft0wTTe+AWYK8in4cmPjBD2V7UQwuA5eoHUpKTPf5yBt+4FQMX+IMrEEOqPbzG4bTTkc
 TTcQ3r104ocoO+dchHviR5O9d8UAcJWOyZkQ5GcjFKaj3ACElwG8bdbgvJ4Z8z9gJNFwfveMl
 ZRx5gT/rLdKN6jj+beHss1LuD+aYjNoklxxvfeTM4EPVESsj2kMJEnCkuHqEPTrsOnZHwXmUJ
 hVU2NqR9+lgDwtO21fbUsLhNzdrWSxaETki+4AF0gx5iavSXinBZiv70rv3t9zs1vQFlyIN6p
 61M3FCK8dwcoKLXSR6bt1BUT3hxlmnR6YcbrXTTfnCu9RuhoqxDWy1wQBPWYL9MHJ8Tvq9H2P
 K/ThOCvoRbBmXBAsEuD8GLmbRkxR+xQT9YtZ5W31cvoULQOwyedLqUukJoxNCKu2FUovy2yFk
 WkCYWgVMypqteZXh+LqcIIiUt65cNV21hyZBNTQ==
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

Fixes: 7723f4c5ecdb8d83 ("driver core: platform: Add an error message to p=
latform_get_irq*()")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/=
ethernet/broadcom/genet/bcmgenet.c
index 4f689fb..9f68ee1 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3465,7 +3465,7 @@ static int bcmgenet_probe(struct platform_device *pd=
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

