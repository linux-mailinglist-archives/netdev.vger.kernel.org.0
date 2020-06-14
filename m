Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D451F8727
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 07:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgFNFsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 01:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgFNFsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 01:48:11 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E79C03E96F;
        Sat, 13 Jun 2020 22:48:11 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id s18so14499267ioe.2;
        Sat, 13 Jun 2020 22:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1Y5Nb8DOGpugitpmCfQchHa7yq0JSnRAL5HG43dCpt8=;
        b=hD9MB3SaPs8Z1iMxecsjY11f9X1fSEThjr9YCDOVafg2OgO5B5R6PBZ25tu5D3iGcP
         dm7oNWDqfiX94j/oNpwP+a5bvJwNsivz5/chflENZPpzz/5KZSjRXud/juv1cxrGGIf2
         wXNUpBe46L8M5toSTOgImNHtQAnP6Qj9z8ih8ZgPywOU+wJ3MIOlV/RO52QPD/JwvFLW
         EHdbwt0muQUbQD3TUmfqYyoXhc5Kl77OuR7lHZ87vh3ySEx0jGdHcJDuvMieWVxRY0Xp
         NAXhCGDcIZVO4MFB9SWJ2qJ+6/WeDhxpXMwkAE+GEtgdzV4+uYdRKsYwt+5XUKPex2P3
         KHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1Y5Nb8DOGpugitpmCfQchHa7yq0JSnRAL5HG43dCpt8=;
        b=tkCKaKF/uouUI1OHVvghYoxbnrroY1EwQSBLxtzw6Qt7HEqkiw2oQ76WcdDIgHWkqs
         8GMIGGBK2lLJe3ovZyXJu/ZGBN74Ssp0r3TYMxpKDQimGF91HpVj8sVeiU+5rPZ9T06N
         SmKwixMOBvARH9w1b+HZLYSMNsEmFTW9MYFLbWrkdSIcA7ixMsMjHPLkxtvxX2pMDfgL
         22ZLjw11zov6084pPapBnw47R8VVLHWpnIOGLZa2Fs4Xiy4AJ9lJNjhq6W1aqI7aifoY
         jrwLSzj2DfaocAf6UxfBD4FHdEPdqfNGRC52Iqxp0NQhB4cfyH1yIKfhlXFiKHlslyT1
         +qcg==
X-Gm-Message-State: AOAM532ybwYROBMzf2HskaCIFrm30bMIys8iktZzgbiwF1/7E0J2sUEO
        tXfwNoMGUV4xbJulU8I3naw=
X-Google-Smtp-Source: ABdhPJzbEANZZ2E1dFVjCHfDCJkNC2TOm3k+TQLvPnYL9NpF7j+hTxbbr99dbuq79PUf54kzsHqHVA==
X-Received: by 2002:a5d:890d:: with SMTP id b13mr15520809ion.19.1592113690198;
        Sat, 13 Jun 2020 22:48:10 -0700 (PDT)
Received: from cs-u-kase.dtc.umn.edu (cs-u-kase.cs.umn.edu. [160.94.64.2])
        by smtp.googlemail.com with ESMTPSA id t12sm5832268ilj.75.2020.06.13.22.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2020 22:48:09 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, wu000273@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH] net: macb: fix ref count leaking via pm_runtime_get_sync
Date:   Sun, 14 Jun 2020 00:48:03 -0500
Message-Id: <20200614054803.26757-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in macb_mdio_write, macb_mdio_read, and at91ether_open,
pm_runtime_get_sync is called which increments the counter even in case of
failure, leading to incorrect ref count.
In case of failure, decrement the ref count before returning.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a0e8c5bbabc0..3646ab5a1e83 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -335,7 +335,7 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 
 	status = pm_runtime_get_sync(&bp->pdev->dev);
 	if (status < 0)
-		goto mdio_pm_exit;
+		goto mdio_pm_put;
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
@@ -374,6 +374,7 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 
 mdio_read_exit:
 	pm_runtime_mark_last_busy(&bp->pdev->dev);
+mdio_pm_put:
 	pm_runtime_put_autosuspend(&bp->pdev->dev);
 mdio_pm_exit:
 	return status;
@@ -387,7 +388,7 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 
 	status = pm_runtime_get_sync(&bp->pdev->dev);
 	if (status < 0)
-		goto mdio_pm_exit;
+		goto mdio_pm_put;
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
@@ -426,6 +427,7 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 
 mdio_write_exit:
 	pm_runtime_mark_last_busy(&bp->pdev->dev);
+mdio_pm_put:
 	pm_runtime_put_autosuspend(&bp->pdev->dev);
 mdio_pm_exit:
 	return status;
@@ -3817,7 +3819,7 @@ static int at91ether_open(struct net_device *dev)
 
 	ret = pm_runtime_get_sync(&lp->pdev->dev);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	/* Clear internal statistics */
 	ctl = macb_readl(lp, NCR);
@@ -3827,7 +3829,7 @@ static int at91ether_open(struct net_device *dev)
 
 	ret = at91ether_start(dev);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Enable MAC interrupts */
 	macb_writel(lp, IER, MACB_BIT(RCOMP)	|
@@ -3840,11 +3842,14 @@ static int at91ether_open(struct net_device *dev)
 
 	ret = macb_phylink_connect(lp);
 	if (ret)
-		return ret;
+		goto out;
 
 	netif_start_queue(dev);
 
 	return 0;
+out:
+	pm_runtime_put(&lp->pdev->dev);
+	return ret;
 }
 
 /* Close the interface */
-- 
2.17.1

