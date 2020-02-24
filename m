Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D714716B613
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgBXX4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:56:40 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35152 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXX4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:56:40 -0500
Received: by mail-wm1-f67.google.com with SMTP id m3so1053139wmi.0;
        Mon, 24 Feb 2020 15:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CqieUl+jBlAbwvJufoMKdaWiCvMyZZmPHn8pxLLM7h8=;
        b=H4QmnGRqnIsqApz0w95u5syLy4ZXEp7B6h+/NcX774qJfNa338N4qQ1XN6glS90Ltl
         s8yf9WcShB47P+eEGXTUPaPVHPKWhhADeb4MnIkXO3xN5S8ETcxiFSsxKWEPZ9smy6ne
         qXzkhn6EnqqT/d9CCZafOmRvrJB5jKjRloJfNt4NsY4GAhaOVj0KsUbluiKlHZUYuTss
         N7XFUu1NN7WzBCm5DUaNhZ7H8DKvfsLSw9Vp+JzXc07+EJeGFegHtysQB8sgZ7e199S/
         UEqRuhXykIJ6z2qH9B0WUf9Zh0grv7cbwT4T5884KTo/EuA88IAidAjwYwRJOpW0nJVk
         v4Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CqieUl+jBlAbwvJufoMKdaWiCvMyZZmPHn8pxLLM7h8=;
        b=CsMP4dLfFcPdh/hEKnMjx7nm0kcac8/2A4msej8b0YCB3IZ3HOPb2pO5kF3RM9WeNL
         b4MUBUWjdsx8VAMwLgFnhJiqCu0kIIldMOlaHYcvw5Wg/ZNVnZCHUhsYi4KPlgggfZzD
         3vitMDzumQp4hHt6SLtd0Y2lhkiUk63yfIxEmPK64I1e3E9IGpuNX98tDgFNi5egKEE2
         3QBdsNBRSanauoaDlw2ntxWa38y2G6yd01Awx3Xz1ZGBr3Jy0T4RZ3Y7582BnCs8fkOe
         V2AJ3pXhMjfIwh0B0iCDyIIhb84N3L1u9/EqIjvwqjnPzTiN3OKJijSZSd9Ha+Tdr2S0
         0y6w==
X-Gm-Message-State: APjAAAVOFx2agrlg02jia8nvgTclbOJ1DTSq++uQi7y1DpP0jpmXmcSV
        UykFd3AZqv6pvS9XiU/hJYh7M3oR
X-Google-Smtp-Source: APXvYqyB703UxFv3cQK5R0yMqnHpiLTlcrDKONLVyyjb8dqcZ1vBqdBHbXTyuhEvv5yHuhdTQ68W0g==
X-Received: by 2002:a05:600c:1007:: with SMTP id c7mr1419958wmc.158.1582588597682;
        Mon, 24 Feb 2020 15:56:37 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9sm21424459wrx.94.2020.02.24.15.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 15:56:37 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: bcm_sf2: Forcibly configure IMP port for 1Gb/sec
Date:   Mon, 24 Feb 2020 15:56:32 -0800
Message-Id: <20200224235632.5163-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are still experiencing some packet loss with the existing advanced
congestion buffering (ACB) settings with the IMP port configured for
2Gb/sec, so revert to conservative link speeds that do not produce
packet loss until this is resolved.

Fixes: 8f1880cbe8d0 ("net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec")
Fixes: de34d7084edd ("net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index d1955543acd1..b0f5280a83cb 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -69,8 +69,7 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 		/* Force link status for IMP port */
 		reg = core_readl(priv, offset);
 		reg |= (MII_SW_OR | LINK_STS);
-		if (priv->type == BCM7278_DEVICE_ID)
-			reg |= GMII_SPEED_UP_2G;
+		reg &= ~GMII_SPEED_UP_2G;
 		core_writel(priv, reg, offset);
 
 		/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */
-- 
2.17.1

