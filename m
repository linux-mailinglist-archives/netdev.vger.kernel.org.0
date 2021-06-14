Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0003A684E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbhFNNrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbhFNNrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:47:08 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4232CC061766
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:45:05 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id nd37so9058440ejc.3
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pYAlKvmW5lcfzA9vZ07hoaBCM+nPWTi/IELfi/4MJBE=;
        b=vKEz5hMoyDofoAvSZ+iODlyx2tXmi9dwVO2Y+hYq9OgZmpGzrN4KylEEc12bHdIZvo
         iqe/+hGaoS3SJ82/o/zSJNFBh+B3Yaik5zFeU4zcQ1V6pvLiTYo4Kx4APqozz5tNA30A
         +PxAYwJdafXcaDZxYWuFchKh/nYWe+V7/0s0sXHKigpNPu1QcZL71dj9HDXa3cWzP5+E
         NtiEp/+25D7CW9FqQf6vyu2BBWY00QXzzJ2XS4iCJVjM/L9sAUMQD3h6J2FXOoMzAJaY
         K8xETdJJXgFNa1WwlHuGgobZ4xkbrIUKyRKsnsgTaioTyCYKtFdHnqdnFn6r/9dlaKhx
         U1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pYAlKvmW5lcfzA9vZ07hoaBCM+nPWTi/IELfi/4MJBE=;
        b=IVHTvMTfGItt20SnFHCMjIFsmY921BU9QbMn1TK4p/TwI6bE6HkGLNovlq4SxMm4LB
         Xf+TTSWu3AdzFHTOaTsULAJCA1sHxkb8eEfDppvglVtH0KIyW01RLnKF1HTJCr/fLu9x
         B0YFR9Q9g3hMhUnMlKetoybz7qMntq7rWyzDAFK5EPDmwltlN0PaGsyx0QjSbj8QWfPw
         0CpuBkZ/nU2PXV5Y98P21bfBTnjs0K60nfYkGOct29vRyco8M32oEPGZH0lSH9b24bRq
         vOtoZ849tSiVUj1aUQZNJr9HGLW2foFXGJo2Zy6CgbCRxf4qRnhcQEfNcRh4Ecyb9Dj2
         Fn2w==
X-Gm-Message-State: AOAM530wDIjbYdeGMhHk3hy/BWAGc9txKLje0A2upm28v9UDOfsduBJG
        ilX7/rxwvBxVwteOA/S3hjU=
X-Google-Smtp-Source: ABdhPJzCVmGGx//8ctED9VVV5C2lBnzVneyBBj5CIoh5tSCr5mRLDD2qmwsjeqsudQQzQBnZTMVIuA==
X-Received: by 2002:a17:906:a18b:: with SMTP id s11mr15549942ejy.8.1623678303931;
        Mon, 14 Jun 2021 06:45:03 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id q20sm7626891ejb.71.2021.06.14.06.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 06:45:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v3 net-next 4/4] net: phy: nxp-c45-tja11xx: enable MDIO write access to the master/slave registers
Date:   Mon, 14 Jun 2021 16:44:41 +0300
Message-Id: <20210614134441.497008-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210614134441.497008-1-olteanv@gmail.com>
References: <20210614134441.497008-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1110 switch integrates TJA1103 PHYs, but in SJA1110 switch rev B
silicon, there is a bug in that the registers for selecting the 100base-T1
autoneg master/slave roles are not writable.

To enable write access to the master/slave registers, these additional
PHY writes are necessary during initialization.

The issue has been corrected in later SJA1110 silicon versions and is
not present in the standalone PHY variants, but applying the workaround
unconditionally in the driver should not do any harm.

Suggested-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
v2->v3: none
v1->v2: added a comment

 drivers/net/phy/nxp-c45-tja11xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 7eac58b78c53..91a327f67a42 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1035,6 +1035,12 @@ static int nxp_c45_config_init(struct phy_device *phydev)
 		return ret;
 	}
 
+	/* Bug workaround for SJA1110 rev B: enable write access
+	 * to MDIO_MMD_PMAPMD
+	 */
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F8, 1);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F9, 2);
+
 	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_CONFIG,
 			 PHY_CONFIG_AUTO);
 
-- 
2.25.1

