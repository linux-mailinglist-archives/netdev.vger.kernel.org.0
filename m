Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B591DCF6E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgEUOUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbgEUOUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 10:20:52 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E168CC061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 07:20:51 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z72so6547872wmc.2
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 07:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VBXYUzxxqkENu4TO46SmuDNL5rdQ2BFuNi667WDOjWY=;
        b=R+ROoWiqPsVyHrFIK/SjqM6wzY91Zs5IGViltmk3Alczi/V2s1CkLhC2/sz4VpI0Eu
         eQiH0aBr/hXgvntA57k+DPD+Nk4nKRP9XYSwxeLK2Gm4vDEfBb0WSEFBaviQ61xiSoDY
         qjUEKAuNBVjvT/T4vt0fBk+kVr74kZKWMfbWnmUcL34VLxFVLLpJdgwPRQANe2ly7TFs
         wTnD5b/hxzyUdi+XIXG6r8HybkKDX1Ihzz+ZNdbiWR1/eSz3Ki2cxMKTkKWIsHBwx5zW
         TeV+lvS7imovX+3UlCwh9XRDnXbI5wH/n0tD/eCnYirFq+lZs18K5ZNF9y+fPwzizlhU
         D2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VBXYUzxxqkENu4TO46SmuDNL5rdQ2BFuNi667WDOjWY=;
        b=B96RnTylvMgsMjLsgFSVZnO8Z7qLsfaDsTz4z4BZYjhDaslDon8z93Thm8xNtsan4L
         nmnjZlalSidno/7I+BrxzjohjMNaNpxr2QNF8w+RYnpmt5dJPIw62tVrz4IGD1kfTjiX
         zmk9CfRJQAikL6qQtAah9Vows2DxMbvxB/hwdJ73PIWx6WC9Z16cQ9qIQ2BfRc4O7aFR
         jjkeoVuA7TW9R4rxnxJMvXB/wmhO6ixbXxIPg5955AD1rTpNmGLNCty0zmnk+jOAt2A3
         e9hXzveyI1GE0Q5yvODGUidiu4imZDvIHk/kpHgxprl9abg8zAvxWqrI4b89VPVel/Jm
         dmjQ==
X-Gm-Message-State: AOAM530cj2omxt333qcj1xkc7wRsxhIaxm9wDrbicj0X3b4V2OMUqW8W
        9NH0f15S+VvFZCP1NbJ7p7IxhgmeyGc=
X-Google-Smtp-Source: ABdhPJzhCykgougGUgnxnq64W96/4SpMMquK9OnNtHceaX6B70Y1Jv8ipfp2XNdsTabA1AyIx8vrCQ==
X-Received: by 2002:a7b:c40f:: with SMTP id k15mr9828875wmi.65.1590070850275;
        Thu, 21 May 2020 07:20:50 -0700 (PDT)
Received: from tool.localnet ([213.177.197.81])
        by smtp.googlemail.com with ESMTPSA id p23sm6626985wma.17.2020.05.21.07.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 07:20:49 -0700 (PDT)
From:   Daniel =?ISO-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.petazzoni@bootlin.com, andrew@lunn.ch
Subject: [PATCH] net: mvneta: only do WoL speed down if the PHY is valid
Date:   Thu, 21 May 2020 16:19:53 +0200
Message-ID: <3268996.Ej3Lftc7GC@tool>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous patch:
 "net: mvneta: speed down the PHY, if WoL used, to save energy"

was causing a NULL pointer dereference when ethernet switches are
connected to mvneta, because they aren't handled directly as PHYs.

=46ix it by restricting the mentioned patch for the PHY detected cases.

Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Daniel Gonz=C3=A1lez Cabanelas <dgcbueu@gmail.com>
=2D--
 drivers/net/ethernet/marvell/mvneta.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/m=
arvell/mvneta.c
index 41d2a0eac..f9170bc93 100644
=2D-- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3567,8 +3567,9 @@ static void mvneta_start_dev(struct mvneta_port *pp)
=20
 	phylink_start(pp->phylink);
=20
=2D	/* We may have called phy_speed_down before */
=2D	phy_speed_up(pp->dev->phydev);
+	if(pp->dev->phydev)
+		/* We may have called phy_speed_down before */
+		phy_speed_up(pp->dev->phydev);
=20
 	netif_tx_start_all_queues(pp->dev);
 }
@@ -3577,7 +3578,7 @@ static void mvneta_stop_dev(struct mvneta_port *pp)
 {
 	unsigned int cpu;
=20
=2D	if (device_may_wakeup(&pp->dev->dev))
+	if (pp->dev->phydev && device_may_wakeup(&pp->dev->dev))
 		phy_speed_down(pp->dev->phydev, false);
=20
 	phylink_stop(pp->phylink);
=2D-=20
2.26.2




