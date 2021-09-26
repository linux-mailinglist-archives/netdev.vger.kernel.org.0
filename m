Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB834185EA
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 05:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhIZDXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 23:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbhIZDXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 23:23:04 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363FAC061570;
        Sat, 25 Sep 2021 20:21:29 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so905292pjb.1;
        Sat, 25 Sep 2021 20:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dpRrnSPbQlkQDUq6GjhJCeuuF152rh7juMuC8piy7Ow=;
        b=Cqh5Te9/5LaqOM4esVQbaf+f20PGsrirj6vVaxAlR9fA+RZU6i04s/SmyyclLVFT0Y
         L3cb2e2Ws5VCPaN0+c6hBZKoe03Sv3Kf10909zj06GA2nmVKriPhIfGtV/K16J9K3Jfs
         YFxdpgujWd7s1YD8jTJGptYt4W89MgKFFHPJT5FdEuDbaMjhs2qGSH4KdSngqsRmK52g
         3mGKHl0c/YsE+EfkaZQRATrp7PDYRD/m38SL6tfn3ovMJLU7fRssBRhSPT7drXmdYLKY
         WVI8G1oPdkeo8wHrxE2HxTbYcmHEvwTu9Q0jpfLns2asiCzVPk6aDZsODeW8hcmKE8nx
         v2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dpRrnSPbQlkQDUq6GjhJCeuuF152rh7juMuC8piy7Ow=;
        b=kc5b0X3L05FtU4LYeDomjsMJXy0zgtyXUpiSOeuG5WDI3uGIS7MK8H2XaNTmFa3qeW
         iYX4CUGEEHSFys9WeKq8svYEVRXZGtmQA5tdloD7/reCQw8fxRepEs/7W9rz9ZaI/kqZ
         LQoQ/Gnh+JJ4r0pLTtxevOZpXOO+cbeMSLUlGD6ArKtAYlTW2cntrZ95vl0Jto5ZeqiV
         mtUF63gJOkjAI7EXk1VOuO5u//euJL0gyBi/FOf03erLQcRysZM2pmwTC8x7eA3ip364
         /uj04QdgNJ7jmdYCnfyvqGNzdKsFse2TEcIF6RsnpC14wBj4v8Qo1aqitaKBotUgiO1+
         eRvw==
X-Gm-Message-State: AOAM530lByIHikiZXwGxoJVVe0uuzSY6DX7O1umrIa8v8jH7w/Ww+lB7
        rG5Z9mHVx88EILVonSqQZCSjS9v0+oo=
X-Google-Smtp-Source: ABdhPJzbWfx6yybUgoubx+Fdu/ccdf6oo2jqKOyYxZunZjWZHfU3ZN7DN7qc0BejxAHnysfU0Kljbg==
X-Received: by 2002:a17:902:9882:b0:13e:1749:daae with SMTP id s2-20020a170902988200b0013e1749daaemr2240334plp.60.1632626488408;
        Sat, 25 Sep 2021 20:21:28 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r13sm14205312pgl.90.2021.09.25.20.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 20:21:27 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/4] net: bcmgenet: remove netif_carrier_off from adjust_link
Date:   Sat, 25 Sep 2021 20:21:11 -0700
Message-Id: <20210926032114.1785872-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210926032114.1785872-1-f.fainelli@gmail.com>
References: <20210926032114.1785872-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

The bcmgenet_mii_setup() function is registered as the adjust_link
callback from the phylib for the GENET driver.

The phylib always sets the netif_carrier according to phydev->link
prior to invoking the adjust_link callback, so there is no need to
repeat that in the link down case within the network driver.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index ff1efd52ce16..8a9d8ceaa5bf 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -106,9 +106,6 @@ void bcmgenet_mii_setup(struct net_device *dev)
 		/* done if nothing has changed */
 		if (!status_changed)
 			return;
-
-		/* needed for MoCA fixed PHY to reflect correct link status */
-		netif_carrier_off(dev);
 	}
 
 	phy_print_status(phydev);
-- 
2.25.1

