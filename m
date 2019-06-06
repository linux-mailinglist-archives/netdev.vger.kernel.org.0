Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D77637462
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbfFFMkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:40:43 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40412 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFFMkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 08:40:43 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so2381211qtn.7
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 05:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Q7o8MEHM0E/dQmy1KlRXJNwDZmw22mKO7FhUymWTDSU=;
        b=VBGDl16ly8z3TJFhrn+sOUW46y+zmGkRW7nUqOb/7bVXn4EC8VlTTFj4YPyXygaPmk
         G+ZTImXCoFf5qbWNww0KAe6RP0id4UX+qS1rGQAj1iBo+FJL1kLf4YgnO6lmjwBq4w/C
         1BEcDG6es13qJ1ceRS5Zs0uKhOk/dl8d/wgTrETwZa8Yqky8R44Cyv+G4LstxGRFY7yl
         BDcQBbsAxRTCiN1ZZ8ZaRDkFRZKQsmyrb0riHhrYcqa6cPo92IV0koiQeUoAxD4cMkWy
         wYDuwtqrNica+4WxJz3pK0Rdko6wJWLNgPq9PaBkqkfuT6cDNQgktzt5DEpAB76j0nHO
         UAMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Q7o8MEHM0E/dQmy1KlRXJNwDZmw22mKO7FhUymWTDSU=;
        b=sVcwrnsEyAak4oCeQFApQnnYGL+D9Wv/HzhiEOUdWkDzO+Xva8i1FrlC9A0vNcXVwy
         Z9MzULF2hnytDGkhlAKIyouYJ7fzRxDg0Yxo1MQcGHpq2FE3MRUY8dPiEAZ/Zvu13wgN
         /AN7Tg2XvIJrJySEViS4d8+vGsLyJdD9ig1qxV9SJ4chhxwKsrtI22khDNmlUJ5Ucqtv
         JzfTBegci+4LO7/KSFENYfvESBUJzj8h+stKFl3VYnYTBhGIYxj+X1Z4aCc7u/er6/M8
         yZulPLJVM27GoLjbd2V9s1qyn8rsMFNarmUJAK2LrwIwDBqvb8/1myrTJZm+plCrj4VI
         nBMw==
X-Gm-Message-State: APjAAAUPqYnvnhvcLA7mhdWqV7y/wLtKoFNAkvlU8eb8WvlqeyVewaeJ
        rZC3cPO1UCSDIqzfFDjQKK8smyKX
X-Google-Smtp-Source: APXvYqxOFpC38ldsYhwe2YQW2VM4DDi+lHlb3G0+j4SJ/bAFubcXSwi1O9/ctIVZrujnWPGCQI/7YQ==
X-Received: by 2002:a0c:89a5:: with SMTP id 34mr17319499qvr.110.1559824842354;
        Thu, 06 Jun 2019 05:40:42 -0700 (PDT)
Received: from fabio-Latitude-E5450.am.freescale.net ([177.221.114.206])
        by smtp.gmail.com with ESMTPSA id m4sm780014qka.70.2019.06.06.05.40.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:40:41 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     davem@davemloft.net
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        otavio@ossystems.com.br, Fabio Estevam <festevam@gmail.com>
Subject: [PATCH net-next] net: fec: Do not use netdev messages too early
Date:   Thu,  6 Jun 2019 09:40:33 -0300
Message-Id: <20190606124033.14264-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a valid MAC address is not found the current messages
are shown:

fec 2188000.ethernet (unnamed net_device) (uninitialized): Invalid MAC address: 00:00:00:00:00:00
fec 2188000.ethernet (unnamed net_device) (uninitialized): Using random MAC address: aa:9f:25:eb:7e:aa

Since the network device has not been registered at this point, it is better
to use dev_err()/dev_info() instead, which will provide cleaner log
messages like these:

fec 2188000.ethernet: Invalid MAC address: 00:00:00:00:00:00
fec 2188000.ethernet: Using random MAC address: aa:9f:25:eb:7e:aa

Tested on a imx6dl-pico-pi board.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 848defa33d3a..2ee72452ca76 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1689,10 +1689,10 @@ static void fec_get_mac(struct net_device *ndev)
 	 */
 	if (!is_valid_ether_addr(iap)) {
 		/* Report it and use a random ethernet address instead */
-		netdev_err(ndev, "Invalid MAC address: %pM\n", iap);
+		dev_err(&fep->pdev->dev, "Invalid MAC address: %pM\n", iap);
 		eth_hw_addr_random(ndev);
-		netdev_info(ndev, "Using random MAC address: %pM\n",
-			    ndev->dev_addr);
+		dev_info(&fep->pdev->dev, "Using random MAC address: %pM\n",
+			 ndev->dev_addr);
 		return;
 	}
 
-- 
2.17.1

