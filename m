Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A5E211B1D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 06:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgGBE3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 00:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgGBE3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 00:29:53 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38437C08C5C1;
        Wed,  1 Jul 2020 21:29:53 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id f16so1567701pjt.0;
        Wed, 01 Jul 2020 21:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Od+hFGDWW+xh79eFx8APnbyBK84QUAzLz4kk0NdbRw=;
        b=FlT7PBbHdvAZXrHU90iSUnmGAGsvYJKZnXpcUdYCs7g48XlmeMu/SmtJeGSUcxMDqD
         OF4Um3I2bXCJCUTiOV7tXtWvh/4Obg619fVOmbE5/zKTC7AF+UX2h4MOzmIzQjD/t5ff
         scYxLGi97AI9S4HYjlbD3m4vETsKH3OyAqVKwploBtK5GKWY8JBvIcxaxnfM3A/t/pw0
         am3a+5/5SRQSJdRq8W64/bT7vwv7Sj6emcv1/+hkzp7bHDZpwyHrt6u2NzeZrF5hnzh2
         wbgKaH66sxDEtsgTjlBzcSZEKJwT8NaE/IT7Rs73gNoJ9BfMFrGwgJ2NrZ/o1kV0r8Ro
         IvGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Od+hFGDWW+xh79eFx8APnbyBK84QUAzLz4kk0NdbRw=;
        b=MGKmS7H4Pgz2trT3JQhhoLl443rFabW3mwKcBDozHlFT6pm5GXiAW1hLvQMlWeifdr
         kjQbk2tZ1mVopz3YHR336NF4sxzq1Sx/xNdILVDzZzt8M6l2hU0zCzVIkqDd5FW8tRh9
         82BAX3dty2SQP6ZwYa3H5sfkOcSfkmCPXFfRvamDTxs/TP91gcvdTryPupA6OSt4rQQ3
         S4ijXtga6OfopQyyDs4SDAkA/9Wu1h0ufSpv8zbsmR6ribYHE5/E6efpKBwLdkndj9nc
         KKtovIuEFhUoTvUl12xhAOHRFiCzy95+rSnhzaWDejZhctCGlbtQAiDmR2i4vQxY0K41
         jNpg==
X-Gm-Message-State: AOAM531ibPe32GeRvL69ET1LIkU09BSjLVcelUEF1wCZDyKeFSTk8pLk
        NTFsO7fweIDw1QFMVwYx9nSfskqC
X-Google-Smtp-Source: ABdhPJyLON1SbcJQiApagT4Y/5mqzmZ4NIkp2UYO+BNfXE/A4TR8kvR+2Q3GAgMn5mSDDNdfPqaCSg==
X-Received: by 2002:a17:902:162:: with SMTP id 89mr25012159plb.211.1593664192305;
        Wed, 01 Jul 2020 21:29:52 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id np5sm6806248pjb.43.2020.07.01.21.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 21:29:51 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 3/4] net: phy: Automatically set-up cable test netdev_ops
Date:   Wed,  1 Jul 2020 21:29:41 -0700
Message-Id: <20200702042942.76674-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702042942.76674-1-f.fainelli@gmail.com>
References: <20200702042942.76674-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upon attach, override the net_device operations with the PHY library
cable test operations and conversely, upon detach, revert to the
original net_device operations.

This will allows us in a subsequent patch to finally decouple the
ethtool/cabletest from the PHY library hard depenencies.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 32 ++++++++++++++++++++++++++++++++
 include/linux/phy.h          |  2 ++
 2 files changed, 34 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index eb1068a77ce1..100d85541a06 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1246,6 +1246,36 @@ phy_standalone_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(phy_standalone);
 
+static int phy_setup_netdev_ops(struct net_device *dev)
+{
+	struct phy_device *phydev = dev->phydev;
+	struct net_device_ops *ops;
+
+	ops = devm_kzalloc(&phydev->mdio.dev, sizeof(*ops), GFP_KERNEL);
+	if (!ops)
+		return -ENOMEM;
+
+	phydev->orig_ndo_ops = dev->netdev_ops;
+	if (phydev->orig_ndo_ops)
+		memcpy(ops, phydev->orig_ndo_ops, sizeof(*ops));
+
+	ops->ndo_cable_test_start = phy_start_cable_test;
+	ops->ndo_cable_test_tdr_start = phy_start_cable_test_tdr;
+
+	dev->netdev_ops = ops;
+
+	return 0;
+}
+
+static void phy_teardown_netdev_ops(struct net_device *dev)
+{
+	struct phy_device *phydev = dev->phydev;
+
+	if (phydev->orig_ndo_ops)
+		dev->netdev_ops = phydev->orig_ndo_ops;
+	phydev->orig_ndo_ops = NULL;
+}
+
 /**
  * phy_sfp_attach - attach the SFP bus to the PHY upstream network device
  * @upstream: pointer to the phy device
@@ -1380,6 +1410,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	if (dev) {
 		phydev->attached_dev = dev;
 		dev->phydev = phydev;
+		phy_setup_netdev_ops(dev);
 
 		if (phydev->sfp_bus_attached)
 			dev->sfp_bus = phydev->sfp_bus;
@@ -1676,6 +1707,7 @@ void phy_detach(struct phy_device *phydev)
 
 	phy_suspend(phydev);
 	if (dev) {
+		phy_teardown_netdev_ops(dev);
 		phydev->attached_dev->phydev = NULL;
 		phydev->attached_dev = NULL;
 	}
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 53b95c52869d..04e35afa43ae 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -544,6 +544,8 @@ struct phy_device {
 	/* MACsec management functions */
 	const struct macsec_ops *macsec_ops;
 #endif
+	/* Original attached network device netdev_ops pointer */
+	const struct net_device_ops *orig_ndo_ops;
 };
 #define to_phy_device(d) container_of(to_mdio_device(d), \
 				      struct phy_device, mdio)
-- 
2.25.1

