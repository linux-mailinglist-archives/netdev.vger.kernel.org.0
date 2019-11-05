Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C427F05A8
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 20:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390919AbfKETIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 14:08:15 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51902 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390895AbfKETIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 14:08:14 -0500
Received: by mail-wm1-f65.google.com with SMTP id q70so564678wme.1;
        Tue, 05 Nov 2019 11:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LT/gPd8R3zs4YJ1bxN7AkJw+pc+MKjRBqxF5/M8jyg4=;
        b=AsDw99/NbUsAKlwFNGBfAst46PxLpIEP/cSfrXwFY18SV+YdoURZ/Q6KBUZRb8P4Uv
         Z3FTkqcNkbhBNIEmeheW1KA2TIAmjWjlh8P+F43qJNDLHsI5zCTUzwKozEFc8C6nJwtg
         qgkdiodP4/YMprsGrPdLkXRzmjsjbEjWGNhLLANyn226odlfcgTQ9en41p2BljzCQmD1
         FxnVnNLHCXSTt9Q9YflUTiyqYpAUhJY5zkcsjWILHb6uxwFH4WJlnwuUa0jyotEoWXCN
         UxLWfxKhMJbv7bLeFjs+GG+BLSM0S+EUJ13PgoQVZnCtxpGQeQbXUMVNa/bCflx/aZXR
         3qNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LT/gPd8R3zs4YJ1bxN7AkJw+pc+MKjRBqxF5/M8jyg4=;
        b=cW0RK5AI/lnfbn11K8vYlwtXW0CEhBZo2DKt7DqQWGbL9HVVJrHS5SvsBcSgQddpeG
         LdngK7DKqqmW4dzcuAgoAuxff64I6mVzBfwOqq72vCLsNZPlDvjjjy8PJtQPcizb2oZu
         hCWKzgo2EQedLKXJnhwZsOKkfB3NdvmXcy7dGnKp9IkcA7xuCaUgjM+3Xymt1PD6cWLQ
         y8g1VFWDXcah2sy2MV/DW3ly9WjbVFoAak619QLI2W5ckyLFETu9sTvlYcwqhwGiTiDK
         3ap+JdnUOSPS9qrYHj2FO9K4jGA6SpJqiJpJQNKaiNx82EKMY+HkFZCnzDP9ZFy13/b9
         MPtQ==
X-Gm-Message-State: APjAAAW5kp6DOHazE5GTZIJQKwDNlU1b4NzNHT8VGPbpVHZRn3AhcGH+
        sd3yJa+pKiNq2SZwiuNDDPg=
X-Google-Smtp-Source: APXvYqzjlHMddsm/UPyn+7gwMHgnfy8SUVntJtZv3P98omIKXL9GDG0dm0Mx0NjOvptFS3vZHaHcfA==
X-Received: by 2002:a05:600c:23d1:: with SMTP id p17mr482538wmb.7.1572980892334;
        Tue, 05 Nov 2019 11:08:12 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11sm25974703wrf.80.2019.11.05.11.08.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 05 Nov 2019 11:08:11 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 3/3] net: bcmgenet: reapply manual settings to the PHY
Date:   Tue,  5 Nov 2019 11:07:26 -0800
Message-Id: <1572980846-37707-4-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572980846-37707-1-git-send-email-opendmb@gmail.com>
References: <1572980846-37707-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy_init_hw() function may reset the PHY to a configuration
that does not match manual network settings stored in the phydev
structure. If the phy state machine is polled rather than event
driven this can create a timing hazard where the phy state machine
might alter the settings stored in the phydev structure from the
value read from the BMCR.

This commit follows invocations of phy_init_hw() by the bcmgenet
driver with invocations of the genphy_config_aneg() function to
ensure that the BMCR is written to match the settings held in the
phydev structure. This prevents the risk of manual settings being
accidentally altered.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index b5255dd08265..1de51811fcb4 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2612,8 +2612,10 @@ static void bcmgenet_irq_task(struct work_struct *work)
 	spin_unlock_irq(&priv->lock);
 
 	if (status & UMAC_IRQ_PHY_DET_R &&
-	    priv->dev->phydev->autoneg != AUTONEG_ENABLE)
+	    priv->dev->phydev->autoneg != AUTONEG_ENABLE) {
 		phy_init_hw(priv->dev->phydev);
+		genphy_config_aneg(priv->dev->phydev);
+	}
 
 	/* Link UP/DOWN event */
 	if (status & UMAC_IRQ_LINK_EVENT)
@@ -3634,6 +3636,7 @@ static int bcmgenet_resume(struct device *d)
 	phy_init_hw(dev->phydev);
 
 	/* Speed settings must be restored */
+	genphy_config_aneg(dev->phydev);
 	bcmgenet_mii_config(priv->dev, false);
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
-- 
2.7.4

