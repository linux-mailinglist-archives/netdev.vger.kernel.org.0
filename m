Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423F3D48C5
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 21:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbfJKTym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 15:54:42 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42822 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728783AbfJKTyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 15:54:41 -0400
Received: by mail-pl1-f196.google.com with SMTP id e5so4920138pls.9;
        Fri, 11 Oct 2019 12:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wR9gk7f7LQI8N0A6dgx60ziHzjDwckLFFEMs2dKM4BM=;
        b=UsziRYCy9h9ocWBlAxA5rbHCkgGu/F3u/vq+Ismt0llvtRlNiUqYtUuxqw8zJxce81
         HBQTnX/OevmAqjn9ik7PpugKZTobiaBa7LJnEfxIuboni7nSO3ayl2y5ogGlLuL7R17S
         bEOxbSoEHapKG8Nmbbxg843BiNimJzfeNQMtxyvpR0ILWrm8FDrUhKEpO4GuGK2uQMRb
         99OxJ7XZ2va4++MM3/qdHU9oudT7+E8C2ySrfSy4nZpqvATx80L1dk4FBFTCcSwiLzp5
         qW+8WVWNk04xYiHhMhYGv/B7uk0dUE/EpZ9I7uvlgfLema1eEi/98Q2waG0AJUIGRCGj
         x1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wR9gk7f7LQI8N0A6dgx60ziHzjDwckLFFEMs2dKM4BM=;
        b=k04VIzavVdJ2BlwwFWb7ldYiipbK0M5Kx1/hz3/fAr9MdV5OwhYZr2ApLytqDlYbPz
         Em0DTUQ9Lizq9cS7EXSYBYWeP2VTzOBfVOaJvctU5+WpKZ3KzdHPhj9MCRRlOg+HnabN
         lRUBjsl4OSl0TM2qQptvGaA9c621NCYY79Q7KMUzzGKfIJ9Oo7aFZhqDwn3fIX9mqIHu
         HHzjGIrPhDDcQFXWgJFGtk2A7WzHnZG8GxPyXG23EC7ko8hnsih/djPRkJVAaDG0NSk2
         i1K7l7t2+EtCajS59EXyQ4im0kXrwSlPVyueJDyTj13MAYYLm3E4nWzu2nvO2FJtCITj
         45FQ==
X-Gm-Message-State: APjAAAUIegTW6vn/qv3TzwwPrtWASrQxLBoFDEYJeFQjDXqgScQRDrDc
        wiTQDjOzKvgo8oB0pmKyPalJV6op
X-Google-Smtp-Source: APXvYqxyZfJzwF2oft1YUUxDysnpuKRZhmXyQphoP0wQ0zPsDYT9S2e55nGUUSoSoV5JTxMyqf3Mrw==
X-Received: by 2002:a17:902:9305:: with SMTP id bc5mr2192737plb.238.1570823681005;
        Fri, 11 Oct 2019 12:54:41 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a8sm9880213pff.5.2019.10.11.12.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 12:54:40 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     phil@raspberrypi.org, jonathan@raspberrypi.org,
        matthias.bgg@kernel.org, linux-rpi-kernel@lists.infradead.org,
        wahrenst@gmx.net, nsaenzjulienne@suse.de,
        Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: bcmgenet: Set phydev->dev_flags only for internal PHYs
Date:   Fri, 11 Oct 2019 12:53:49 -0700
Message-Id: <20191011195349.9661-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phydev->dev_flags is entirely dependent on the PHY device driver which
is going to be used, setting the internal GENET PHY revision in those
bits only makes sense when drivers/net/phy/bcm7xxx.c is the PHY driver
being used.

Fixes: 487320c54143 ("net: bcmgenet: communicate integrated PHY revision to PHY driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 970e478a9017..94d1dd5d56bf 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -273,11 +273,12 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct device_node *dn = priv->pdev->dev.of_node;
 	struct phy_device *phydev;
-	u32 phy_flags;
+	u32 phy_flags = 0;
 	int ret;
 
 	/* Communicate the integrated PHY revision */
-	phy_flags = priv->gphy_rev;
+	if (priv->internal_phy)
+		phy_flags = priv->gphy_rev;
 
 	/* Initialize link state variables that bcmgenet_mii_setup() uses */
 	priv->old_link = -1;
-- 
2.17.1

