Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54FE3C25DA
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 16:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhGIO1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 10:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbhGIO1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 10:27:11 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA1DC0613DD;
        Fri,  9 Jul 2021 07:24:27 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id b40so8272427ljf.12;
        Fri, 09 Jul 2021 07:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rgwGXqa2G/aj+hvJiAbmrHbV8jLgv2L8wBWa5rfPFBA=;
        b=ZLS496oLc5cKkeetafUzqCoiPt2x1QJvC/qVzEjUY48U4HHj/UWTs2d26oFxbiOfzJ
         YwC0DmABvl35O7cpi6Lxkl7pzmaTv7g+07lCf6w50gwIC6Nj+ujXiq8ehZvvJBBVizN4
         mVdbbaXuJZgpYaJ13y/pMQNZ2FlRiBPcDEw9dhho6ceN0ybMtKOuFHI8nap2lfqsN9QH
         i9iEEZW+cGGKprvQENMdWG31IBfj20CEr95zdYNVHg5Ky8GrmqaPhKyd4RO6q8ICIVnm
         5n2MTazjIvvMZKsbdp/ZpjzTGGk4aQaf8p5n4xRPDTpJAKo2YeWvuXBwpV8+FbrekuWV
         hMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rgwGXqa2G/aj+hvJiAbmrHbV8jLgv2L8wBWa5rfPFBA=;
        b=S1ewbGBgG53IdJOJ7WlIuluip1yyl+4uzrwdCA2MqntEZNG72KCzBR132yJSATtX1Y
         tyr3p12JoI57/N0oaTRdmmD4S2VSjXBkOCovKMvoPuAo3/KrLCk+hzkzJbqW++dxGQ6t
         64A3DztIsbjowSm2YDOi6cbEyPzE3wBtqZx3qRHy8vu5YsgTpiXv8rb2BuuyqQMuoh2A
         /2XTAb8GlZWwt8wGTsuDAvi+xcBEWfWTP5T7dHI3wKJ/X+e1Masrdk4gjF4hu6bp/4El
         TGFHLZqnEfr6t766x0Etej6lDDpQSe+jCCTadYiPsTsnxxpgZ++rWF7l1zzqy6+l2vTC
         VBDg==
X-Gm-Message-State: AOAM532653AjdaAas05G3ZCHLzOpoUp9xKrGvIE8C7/rcjV1kPU1+vgU
        1Hz1UECteOF2y8PVKxMufJA2lZ543MqHY3WW
X-Google-Smtp-Source: ABdhPJxS81b9tGzNNIzlfUtIXBvq7xECJRFH5QHr6rXKngwCwI1b1EDHxP+OoGOEZyArWVYdgsTNHg==
X-Received: by 2002:a2e:6111:: with SMTP id v17mr19084755ljb.27.1625840666259;
        Fri, 09 Jul 2021 07:24:26 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id r7sm477810lfr.242.2021.07.09.07.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 07:24:25 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     timur@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: qcom/emac: fix UAF in emac_remove
Date:   Fri,  9 Jul 2021 17:24:18 +0300
Message-Id: <20210709142418.453-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

adpt is netdev private data and it cannot be
used after free_netdev() call. Using adpt after free_netdev()
can cause UAF bug. Fix it by moving free_netdev() at the end of the
function.

Fixes: 54e19bc74f33 ("net: qcom/emac: do not use devm on internal phy pdev")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/qualcomm/emac/emac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 8543bf3c3484..ad655f0a4965 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -735,12 +735,13 @@ static int emac_remove(struct platform_device *pdev)
 
 	put_device(&adpt->phydev->mdio.dev);
 	mdiobus_unregister(adpt->mii_bus);
-	free_netdev(netdev);
 
 	if (adpt->phy.digital)
 		iounmap(adpt->phy.digital);
 	iounmap(adpt->phy.base);
 
+	free_netdev(netdev);
+
 	return 0;
 }
 
-- 
2.32.0

