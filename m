Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487C41239AE
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfLQWTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:19:53 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38519 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfLQWTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:19:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so145135wrh.5
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xjEOsUxpMjOsdyA8xVjrgDc+q4UvfiRDhK3w9Ehx1cA=;
        b=ZcgcdUltam59rZGTzL6P2i7PCRPeO/azfzSmPWxILesluULHbMIhCvLfUMHbTey290
         /TiNaJBL4ojxrqYwmSkgQyxlf0hesgtpuFBxPbUS2RpbFKtglRVnV1DQkwQRMgd87SKt
         WfxzkZGf1u/HVXtg0OD5Jam8sgurwYN/k6Gq4PG+Rna0jLaud4WFQQef+f4R3jeijo5s
         NVdND+eA803/9yAcqcVn5qL9JnL9bfe1piOvure6qTKYAbXE51y06V2KQt6BSKyX9vaK
         KA8s8hwwX0PIyAkr/QAoClfMpsYgx01w7R36cDNulMIi/KqU+LJMcLVJIyd4Y1Dsez8Y
         UoXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xjEOsUxpMjOsdyA8xVjrgDc+q4UvfiRDhK3w9Ehx1cA=;
        b=OFdSooMAoZ8W7x6SB2sKKftxn4rssRkwSYopxwjhtIAzKeKRqlhDxiryFGZy0E9kIw
         BFPsRXCu3TG1+zDw5Mb6P80K5QolPt9xuKxKkTnDOjh7np4xWXAf4vE8liSl3kIF4f61
         gWjgiy6ufkbINBFnn1y7Uq3J9jxZr4v0ThvWFOwVUdRm0zgtXlckBIGRqEXdDWbt6tXA
         1OghICpZm7iBDKUGhpqpB3Y9CrhjjFGz1g+QHZYednA06w1uBwjhqZIKONvEobE0YvIZ
         Sgk/b3nNYqZW3TtsbNAW4s2y0R7j0iQ+DhhadSvyhcE9EdYGiXhGrpwnfQMQf7s5SQLw
         EEnQ==
X-Gm-Message-State: APjAAAX3ygha5Y6zZF2kh4K6itp7jJRzd51I2WPNnr2I6jzknlYohlM1
        /p7aPA2YVmBlpt3uOn6h8WM=
X-Google-Smtp-Source: APXvYqwR5EckgTNSFxFRWVdSz24UdHGg5kVFRMSohxXCvs1Cj5X9km9o90LhwJo8ZLD5an4CxHUP1A==
X-Received: by 2002:adf:fe50:: with SMTP id m16mr37874015wrs.217.1576621181571;
        Tue, 17 Dec 2019 14:19:41 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id e6sm196808wru.44.2019.12.17.14.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:19:41 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 2/8] net: phylink: make QSGMII a valid PHY mode for in-band AN
Date:   Wed, 18 Dec 2019 00:18:25 +0200
Message-Id: <20191217221831.10923-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191217221831.10923-1-olteanv@gmail.com>
References: <20191217221831.10923-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

QSGMII is a SerDes protocol clocked at 5 Gbaud (4 times higher than
SGMII which is clocked at 1.25 Gbaud), with the same 8b/10b encoding and
some extra symbols for synchronization. Logically it offers 4 SGMII
interfaces multiplexed onto the same physical lanes. Each MAC PCS has
its own in-band AN process with the system side of the QSGMII PHY, which
is identical to the regular SGMII AN process.

So allow QSGMII as a valid in-band AN mode, since it is no different
from software perspective from regular SGMII.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1e0e32c466ee..f9ad794cfee1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -281,6 +281,7 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 
 		switch (pl->link_config.interface) {
 		case PHY_INTERFACE_MODE_SGMII:
+		case PHY_INTERFACE_MODE_QSGMII:
 			phylink_set(pl->supported, 10baseT_Half);
 			phylink_set(pl->supported, 10baseT_Full);
 			phylink_set(pl->supported, 100baseT_Half);
-- 
2.7.4

