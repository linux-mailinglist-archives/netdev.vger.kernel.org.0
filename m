Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3242620A1D0
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405802AbgFYPXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405394AbgFYPXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:23:45 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D0DC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:23:45 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o18so1904103eje.7
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ya6MDcC8RS7KztKqBU+U3BhP3PAjLn6YQX31nYlwXic=;
        b=D8UHSAqOyX5uMXCxj1zeajjol4jW+OXcdwGF1KQuv39O7Mt6TuFWTZ3uUmma/1a/Pf
         /IvLHQh50KHkbMZcCCUFytQefvUfGEhXmzzsNoGOgtoTOzPJ66gDgdBJ4XGFza+Z0SBn
         im+lfBJDV3nLWV84+cKFWl23fjCZE13/9EnkcHkKJMqeHN5x+5RlK3Zhnj1mS/kpmsfK
         feFFFil84GwG6s2/8tqUwLXTewvzuLN3xaxhJtqyYjk4d6/MPu8JrOiImByCh+VMcIPG
         KK/dLHgAb3cMBhgGjpXo0pGsE+U3GMRIGmw8moMh/J5qrN0AFDXZyTCD7l2kHv0fUkx6
         0ndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ya6MDcC8RS7KztKqBU+U3BhP3PAjLn6YQX31nYlwXic=;
        b=laUfrzKpREIRFQIGww/LrtP+8/4gpH7mlw21+iBaHsxgto4nIZzGkj1CUKb4BDEdCx
         jIgWpLwjNmYALEgxfqKaVx0Qws4f10zVRMbMvyU/GE+4zZyb0YcDAmY2KhToRGZcvoIz
         IRemFY34u34m02X5nuB9qacro7Ds4qa12MhRVRG2Wp8oe8sb/9fCxz3QX7P4Mp6FRRvW
         4K8LB2KhU1Rpuy9ohgcoLFJkr1/iHVCWBfjBV2leNPxcfF2XL+PLwJgUVhzLcrS82ZAf
         iELUq0NqexevnEfUGdcNYD85vJ/ycRijSshk1BMJM02pVBSpi9uo/tY/AqBrHNz5lJfi
         vGHw==
X-Gm-Message-State: AOAM531PnAkLjcxDwEWPkiU74SxGShPVRMmkKXQ0g5dzh9SOqDY1KCD3
        JFB2s27QlaTwSpVTqK3yv9t3E3Dy
X-Google-Smtp-Source: ABdhPJynPCsFknYPwbVHnRdce5dy4EBSvVkLECrFwp2L/JpaUOUa62Es5wNs7YyoWW7vSJX8TF7HXQ==
X-Received: by 2002:a17:906:ef2:: with SMTP id x18mr6433313eji.547.1593098624149;
        Thu, 25 Jun 2020 08:23:44 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o17sm9102898ejb.105.2020.06.25.08.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:23:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH net-next 1/7] net: dsa: felix: stop writing to read-only fields in MII_BMCR
Date:   Thu, 25 Jun 2020 18:23:25 +0300
Message-Id: <20200625152331.3784018-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625152331.3784018-1-olteanv@gmail.com>
References: <20200625152331.3784018-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It looks like BMCR_SPEED and BMCR_DUPLEX are read-only, since they are
actually configured through the vendor-specific IF_MODE (0x14) register.
So, don't perform bogus writes to these fields, giving the impression
that those writes do something.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2067776773f7..3269c76b59ff 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -845,10 +845,7 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 			  ENETC_PCS_IF_MODE_SGMII_EN |
 			  ENETC_PCS_IF_MODE_SGMII_SPEED(speed));
 
-		/* Yes, not a mistake: speed is given by IF_MODE. */
-		phy_write(pcs, MII_BMCR, BMCR_RESET |
-					 BMCR_SPEED1000 |
-					 BMCR_FULLDPLX);
+		phy_write(pcs, MII_BMCR, BMCR_RESET);
 	}
 }
 
@@ -882,9 +879,7 @@ static void vsc9959_pcs_init_2500basex(struct phy_device *pcs,
 		  ENETC_PCS_IF_MODE_SGMII_EN |
 		  ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500));
 
-	phy_write(pcs, MII_BMCR, BMCR_SPEED1000 |
-				 BMCR_FULLDPLX |
-				 BMCR_RESET);
+	phy_write(pcs, MII_BMCR, BMCR_RESET);
 }
 
 static void vsc9959_pcs_init_usxgmii(struct phy_device *pcs,
-- 
2.25.1

