Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2473147007
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAWRth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:49:37 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38830 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgAWRth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:49:37 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so1876228pfc.5;
        Thu, 23 Jan 2020 09:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pmwM/RjTjMeKJJSz0utNzRkzs2Ah1FBEm23erGfIBU0=;
        b=BeOqupiK3Vu2fFuS68nq6ecQn8Vo2jwMQdojQuLXZhZHIVNdOzs1JLjFwqn5mjWeFq
         P0G6daxp47/Uk1NgC2+xuJON8uHoMytMdafoir4L90j6LpNC9jk5CAqhHnABlSSXehVd
         XlTnfEfIOmT4IyT1r6+tDdKTW3olEq8ND+iASsSRAiDJa2HI9lTyRS1up7zQq3VC5LKI
         DZEM2NZaj0/Qe3zxBfOsULO7BlKRhDQZtNGljJo6gi+k/4m+Zj4fb4dhfkEWiYvItSCk
         1j1AiHMMyTeiL7p8U+1vpVdIIgDLBLcNDjXsbXDdR6UgpQDnkfi4XfXupxgWW5CWx+7l
         mX8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pmwM/RjTjMeKJJSz0utNzRkzs2Ah1FBEm23erGfIBU0=;
        b=CJI0vPoq1ZYU5EaAeD/PS1GTpQ92dpqdez1u7UGAcTlfbIpzckqHlNT5hjejQM7wkc
         4RYoqreyxGrHbz5x/M1u9J+mUjzXg/JJJV0+8K7v8jeM0VfX56/s5oZfMepARnMySCRo
         4jTYvjKyZKbHbXgDiV1UXiB1tr8gUv1okv/O9nmS4ajYwSr0aFBUa+HbJp5kdj3COF5q
         z5XHQ/pH3MnebnYmg0z/8G9w0CEHEc0jwovAaHO1BSWwWc3GjstC/jLnyBYWKPqdPjYb
         mU7sbsuyhk0aetZyKYYgD7B12oqlZWZ87XcRX9cUyCsjdXpRP4ZQtrF0va6yV1A9OV0f
         mnHw==
X-Gm-Message-State: APjAAAVKzLmk8/L1xA74JG7fJSeEV5OEy1wCS/czd12v2sG9kbOW1QGZ
        kJxNoKsXd2A0QBPcRbsQ77qr72zX
X-Google-Smtp-Source: APXvYqxMQYoCS89083iM0osTStyfuMoISmfSd2S1xkk/uE/h0v/Z98L086evGzQx0P68M+cQ27IljA==
X-Received: by 2002:a62:8602:: with SMTP id x2mr8420961pfd.39.1579801776631;
        Thu, 23 Jan 2020 09:49:36 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j21sm3312326pji.7.2020.01.23.09.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 09:49:36 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: bcmgenet: Use netif_tx_napi_add() for TX NAPI
Date:   Thu, 23 Jan 2020 09:49:34 -0800
Message-Id: <20200123174934.29500-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before commit 7587935cfa11 ("net: bcmgenet: move NAPI initialization to
ring initialization") moved the code, this used to be
netif_tx_napi_add(), but we lost that small semantic change in the
process, restore that.

Fixes: 7587935cfa11 ("net: bcmgenet: move NAPI initialization to ring initialization")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 120fa05a39ff..0a8624be44a9 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2164,8 +2164,8 @@ static void bcmgenet_init_tx_ring(struct bcmgenet_priv *priv,
 				  DMA_END_ADDR);
 
 	/* Initialize Tx NAPI */
-	netif_napi_add(priv->dev, &ring->napi, bcmgenet_tx_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_tx_napi_add(priv->dev, &ring->napi, bcmgenet_tx_poll,
+			  NAPI_POLL_WEIGHT);
 }
 
 /* Initialize a RDMA ring */
-- 
2.17.1

