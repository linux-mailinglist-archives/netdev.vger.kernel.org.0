Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5233E412AC8
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbhIUB6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236291AbhIUBuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:50:02 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B459BC06AB05;
        Mon, 20 Sep 2021 14:54:30 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id p12-20020a17090adf8c00b0019c959bc795so1013397pjv.1;
        Mon, 20 Sep 2021 14:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bgYSRw/Vbtc/aybke5MCpFQvX34FKlB31rJwrenaP7Y=;
        b=b0j81DsihnJMfVi2zHg09br87QjGXthiyQh64RI/4gtGim/7bR9Se7hUKHQMHCy5nn
         Yu41LkUtECeTDkb83SkDKxvabElHPnkOZ6s4hEDD1VzmbCyXNbFOLFShFPkkHD2a3HRA
         Mbg0neS79fK8nsrb0FoH8kLAaJQQrEH4OnowFWSD0fCkK8oRtjO5BRfQTnGJdEwnR65O
         dUGAdTQJ9bdK8B8qsLq8r+IGyikhl+ZHfedOrFbah0Ed8jrLbuCLwpibdPn3KXNc2612
         ym1F2M2WomeschkDXlHGqOoDE3nVrkHCm0ZU9dPuMkxVPVTnO3PyPHgoy9FjkOjtQmoa
         UNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bgYSRw/Vbtc/aybke5MCpFQvX34FKlB31rJwrenaP7Y=;
        b=uczhkYqoMi1uXCNTDg2FHFuNxri1FTyfSssSdh+G9dponhkRtCkx4mZ1NGv4G7sKvu
         3f4YUAUo0WcL1BhTmnU68p2IFLqMoEvY0acKseTR7s56EN3tTRDZw/Mj0LyAJa4NLp1v
         gnafdqwt6qXAgyBLbczKgYO2qDcIIU/bqi8gULkmQYDU5wOZu5qL0ue1KclZvXGj6wbW
         uF35HOkByKmU4K4zMcAoTmdyRsWut9bURC7sgF8/JdQXaedi4FGEc81eOss5ARFh6/4q
         hID/ROWVnUTLImYPDTqXaKe6SwzO3Fx61Xo0JkpO7cKWqj+j0Jl0isNfGjP66rYjtCf8
         VTlA==
X-Gm-Message-State: AOAM532vAjXUJc9wk8Ht+O5IR2ukafWJ2I+0fvgG6TysDtsPgFdPIghe
        6zlZshUQdmKYF96vkDQWm213jW5zY+c=
X-Google-Smtp-Source: ABdhPJy9InWR+BuiSP1O3oVTNJbydcBVFhoa+0BWQpjb2B8SBvBhkc1jFzq92K2Uf36pejsUsTmG/w==
X-Received: by 2002:a17:90b:4d05:: with SMTP id mw5mr1232218pjb.175.1632174869968;
        Mon, 20 Sep 2021 14:54:29 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m28sm16224297pgl.9.2021.09.20.14.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 14:54:29 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 4/5] net: bcmgenet: Request APD, DLL disable and IDDQ-SR
Date:   Mon, 20 Sep 2021 14:54:17 -0700
Message-Id: <20210920215418.3247054-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210920215418.3247054-1-f.fainelli@gmail.com>
References: <20210920215418.3247054-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When interfacing with a Broadcom PHY, request the auto-power down, DLL
disable and IDDQ-SR modes to be enabled.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 2d29de9a33e3..ff1efd52ce16 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -288,7 +288,9 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	struct device_node *dn = kdev->of_node;
 	phy_interface_t phy_iface = priv->phy_interface;
 	struct phy_device *phydev;
-	u32 phy_flags = 0;
+	u32 phy_flags = PHY_BRCM_AUTO_PWRDWN_ENABLE |
+			PHY_BRCM_DIS_TXCRXC_NOENRGY |
+			PHY_BRCM_IDDQ_SUSPEND;
 	int ret;
 
 	/* Communicate the integrated PHY revision */
-- 
2.25.1

