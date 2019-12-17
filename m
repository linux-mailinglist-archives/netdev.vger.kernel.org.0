Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C064E123835
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfLQVDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:03:31 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40818 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728299AbfLQVDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:03:30 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so4706607wmi.5;
        Tue, 17 Dec 2019 13:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r9MEyJQ7xvqRtu/cx7pnw1DLhc2cZ7pjuqsZn/yC3vQ=;
        b=o1uu9pMUtQnkBpSFKw7Z/v9QCY0tsk8SbusLF3JzbkPczLMv+pBwaFGTqEQCoVV4Lo
         B1GQofHHOq8A/7WDtrpFe9jsVjyHtXeWX5MjeJkK5cjHH5B7a6rvaoUFOCyvharjFT3i
         oSBrgUla5c8bAkM51DOchpxTR10KklD7ES9BDX6PY2jkIaqvm7Rp3o/S4/zXIz3dw7fq
         O7OmNiOxhtn+2MeYRFARh/8BCB20kVeJFN2NHftAMxsi1NamcF9KTlx5wsomxH0ttKoB
         FwVGTTMS5ZAQiibOyNOrjKqvy29LPuBh6rRYTkWwgNBkqDKlNy701d+sHOun+VU4/XK4
         Kjsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r9MEyJQ7xvqRtu/cx7pnw1DLhc2cZ7pjuqsZn/yC3vQ=;
        b=BhG6tOpP6S1RrlCVv+L0bWJO6XW16N/iPtasMQAmFuOzJp0kg5UiE6Vs5z67vZXY48
         Ml3rXtdRjGj8uDsaYy3xyrLdZ5Mogq8rXMTvQB7oI+v1T+qgUxUp4oq6rYYtINBPbLnR
         QvQn+2vh/mCERAHgFXlYAW8T3xOnbLVyvTmQHsrkBJSCuwXjy0E+2QazHNLLDKB9bxLg
         IBCmzED0BgkUSudNVHwhcBFlz3vZtOLCRlfXHIdPmtXA+6E0cv+u/iaTo7ZKhiqCE52b
         54z4Ja8gGgsWSCweyb8DxJIS9T8dY/wweg0hmUzGp4DlS4D8Zhqg/lX5uSZMUDUJ9KKk
         8VXw==
X-Gm-Message-State: APjAAAWv2rGWKuPglrUUJkDE+pPdEElSbhFaZS4g3ivRg4mKz9w686gE
        WD28CdxHbq7XJ9UJVQ4LBTI=
X-Google-Smtp-Source: APXvYqx2rRwNzXbZWKDlAuQ19ISsVoZB11/RJNO8lRwUIoSWsBxkeJI/HRjX3hQLa/QcTL1ULm0UIg==
X-Received: by 2002:a1c:41c4:: with SMTP id o187mr7743727wma.24.1576616608908;
        Tue, 17 Dec 2019 13:03:28 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5sm37856wml.31.2019.12.17.13.03.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:03:28 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 6/8] net: bcmgenet: Turn on offloads by default
Date:   Tue, 17 Dec 2019 13:02:27 -0800
Message-Id: <1576616549-39097-7-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
References: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can turn on the RX/TX checksum offloads and the scatter/gather
features by default and make sure that those are properly reflected
back to e.g: stacked devices such as VLAN.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 0df44c7076f1..b751fa76d0b0 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3532,9 +3532,11 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	priv->msg_enable = netif_msg_init(-1, GENET_MSG_DEFAULT);
 
-	/* Set hardware features */
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
-		NETIF_F_RXCSUM;
+	/* Set default features */
+	dev->features |= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
+			 NETIF_F_RXCSUM;
+	dev->hw_features |= dev->features;
+	dev->vlan_features |= dev->features;
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = true;
-- 
2.7.4

