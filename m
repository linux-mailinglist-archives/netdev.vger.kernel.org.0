Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB91F3240BB
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbhBXPXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbhBXO5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 09:57:47 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FA1C061574
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 06:57:07 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id 7so2189519wrz.0
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 06:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xIB+Qj4r3eqV2Do1yD4qWo7FiqhWH2F6QqhaA1dSUP8=;
        b=pHg5LvgiHuzr/DkN7Ck9s5hNKhv9Hyjm1Z/NCR82TrtgL92qXoJthJq7XqH3Tv4QRn
         475DBTNIQiv5Fw0JZG5mgwGUO9/C72en91ixm2N35wFp2pgGOsKPkB8XptgO2mxZa0wL
         mEjH/DLFTJ0NFa49BK5qjfyz4AIF4Y3fn2b8V6RjCTIK3HSI3IaKmf1UObnJBpT+YtLA
         0cQeK0q7H7EXGcS5WVxtXx8hfAFovRCPPY/JWss5Ks4h8QvAn330Oc7FnHZqkPyR2iTP
         tYU2H3hHOFMIalj69ZnIyMHKWedK7GL5qdlytMQazyZkjP4diQZmOLte1//rtOVjvHWI
         V0sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xIB+Qj4r3eqV2Do1yD4qWo7FiqhWH2F6QqhaA1dSUP8=;
        b=rkZQUcLWWZum1dwvfJJ+2ER/sgL8w1zJ3LdMrrcqXrztbmHUHHizf4ISE7PM1aFLko
         j0aBKi+DK9VqXmtNBhPOhaN62ormM2+7CxHYM+5PqavQPVWhXqmph3i8V/TSWcC1rFgg
         ywG+4fpUxdxDPzn3JMz/hKpe5cgYxPilGp2RBYNihf9Io9j5aaZw7ZLDzvoCEWquxNWr
         XrreR1nAKoFcie90YCBkat6+7Ig45BaG/1XrPHzRcg5XIWDg21dWjXeCijaeU2bOjYai
         y1ADq1TKAyfMFfMChk4CX6MVGZMhZNY0P8AYVFfKqPsAlwONaeK0izgUSgN/YgHfb4sO
         F97w==
X-Gm-Message-State: AOAM5338XGzViuXmo4b0LSSVp6zwH4z50ClR/9s75kQmC5CGlCrNNggn
        7nffOUlg1H9/H/S/IMJqgDqTMLP3m5ATLA==
X-Google-Smtp-Source: ABdhPJyJliPBakhaUS0i+ZgqSNL3hjRAOc6fqL2RD5eT7OgNdznfcMEbT6aLLqYYuNOOKqPJrYOF2A==
X-Received: by 2002:a5d:4050:: with SMTP id w16mr8851718wrp.21.1614178626108;
        Wed, 24 Feb 2021 06:57:06 -0800 (PST)
Received: from tool.localnet ([213.177.198.100])
        by smtp.gmail.com with ESMTPSA id y2sm3766953wrp.39.2021.02.24.06.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 06:57:04 -0800 (PST)
From:   Daniel =?ISO-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, noltari@gmail.com
Subject: [PATCH] bcm63xx_enet: fix internal phy IRQ assignment
Date:   Wed, 24 Feb 2021 15:56:08 +0100
Message-ID: <2270332.afWbCi5vXM@tool>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As a
result of this it works in polling mode.

=46ix it using the phy_device structure to assign the platform IRQ.

Tested under a BCM6348 board. Kernel dmesg before the patch:
   Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
              BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01, irq=3DPOL=
L)

After the patch:
   Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
              BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01, irq=3D17)

Pluging and uplugging the ethernet cable now generates interrupts and the
PHY goes up and down as expected.

Signed-off-by: Daniel Gonz=C3=A1lez Cabanelas <dgcbueu@gmail.com>
=2D--
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/eth=
ernet/broadcom/bcm63xx_enet.c
index fd876721316..0dad527abb9 100644
=2D-- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1819,7 +1819,14 @@ static int bcm_enet_probe(struct platform_device *pd=
ev)
 		bus->phy_mask =3D ~(1 << priv->phy_id);
=20
 		if (priv->has_phy_interrupt)
+			phydev =3D mdiobus_get_phy(bus, priv->phy_id);
+			if (!phydev) {
+				dev_err(&dev->dev, "no PHY found\n");
+				goto out_unregister_mdio;
+			}
+
 			bus->irq[priv->phy_id] =3D priv->phy_interrupt;
+			phydev->irq =3D priv->phy_interrupt;
=20
 		ret =3D mdiobus_register(bus);
 		if (ret) {
=2D-=20
2.30.1




