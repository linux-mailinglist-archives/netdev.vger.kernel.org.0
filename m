Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 586EC123832
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbfLQVD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:03:29 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42027 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbfLQVD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:03:28 -0500
Received: by mail-wr1-f68.google.com with SMTP id q6so12797325wro.9;
        Tue, 17 Dec 2019 13:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=joygie8AOg1VwSePGBgwAjx5b22RYtoOV9m0DO00iVM=;
        b=LtUP2bpMcXNRxEoOJADHtWotil2wo4uFauu/+XATqLPmxfdoYG1wGfcsfNNG9wZmc4
         4nhNQPUfJqZPtb+tKxLZ17U9Va3Yiy1P+09+T4EgWMEdYNPDYIYyrVg8EiVMUjADWQHR
         1T2Q89YeK0CpTSFd6sx1/OKwtLi/GETpwEAEnQipIoMNfOr2jrzh/r+w7OpMk4LElp3W
         sB/e2Zr+A0y2tVJzoa0XiJIwRDJtwpvGqfEi5wTxYXvhaavxmanTJ8Zmqmkneq4ZxhGa
         X/7CSFOQRvYce9dEeM+jTAvoTi3BqeefznnQp2U0r64mJh8XjsiSNB1tPp4ugE/Fn4HQ
         BPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=joygie8AOg1VwSePGBgwAjx5b22RYtoOV9m0DO00iVM=;
        b=damgaqKJ0kmb8VRQ3gp1/SYMsw+DiLmrr8DkQk4vBAqqzDlC+Wj/xa+QQtLnMj4OHS
         0frP61SFBqkduaWkUudpLD8ggu6kDC4K/R88NTMPN9tVjBQFcAOdFG0NHw+i/uELcumV
         hnKY/6gwwp3T/bWnU2XVRGTmzo3Df/3M0TYlsD3zNGz3Jvro9J6O5FPKmTaOqbtyOQFv
         N8Nsh1UlngG9dNzUweCJbjqbNH223CjJEQwENBMzp9O/Of78VXEyiHJIQzG532wOvemB
         x+Y4PyZ8HUrucw2NpOWQ8JxO6NHZpl5xGnbbSCn/ufTL1yCzVLvM/OGZyt/h3P/OX8qU
         NVow==
X-Gm-Message-State: APjAAAUFAbc2q6URc8O0Gp0LGlnxhX0qa1R4dfEJ5TZ2cyiTvt/iIVNO
        UZwMFOpqQDzUBD4om2xL88Y=
X-Google-Smtp-Source: APXvYqwAB68s0IUOu/AQPyUT/45WKYLwcO4HKGA+VJRRlNLABdHq/Dx12TkBLzpmfXfeezeKQudFUA==
X-Received: by 2002:a05:6000:50:: with SMTP id k16mr38837675wrx.145.1576616606846;
        Tue, 17 Dec 2019 13:03:26 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5sm37856wml.31.2019.12.17.13.03.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:03:26 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 5/8] net: bcmgenet: Utilize bcmgenet_set_features() during resume/open
Date:   Tue, 17 Dec 2019 13:02:26 -0800
Message-Id: <1576616549-39097-6-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
References: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During driver resume and open, the HW may have lost its context/state,
utilize bcmgenet_set_features() to make sure we do restore the correct
set of features that were previously configured.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 8afa675b45da..0df44c7076f1 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2882,6 +2882,11 @@ static int bcmgenet_open(struct net_device *dev)
 
 	init_umac(priv);
 
+	/* Apply features again in case we changed them while interface was
+	 * down
+	 */
+	bcmgenet_set_features(dev, dev->features);
+
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
 	if (priv->internal_phy) {
@@ -3689,6 +3694,9 @@ static int bcmgenet_resume(struct device *d)
 	genphy_config_aneg(dev->phydev);
 	bcmgenet_mii_config(priv->dev, false);
 
+	/* Restore enabled features */
+	bcmgenet_set_features(dev, dev->features);
+
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
 	if (priv->internal_phy) {
-- 
2.7.4

