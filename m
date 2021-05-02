Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561C5370F8F
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhEBXIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbhEBXIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:10 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC5CC06174A;
        Sun,  2 May 2021 16:07:18 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id j28so4257353edy.9;
        Sun, 02 May 2021 16:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QeLg2DTBbdqjeh99qWORPQ1IItT1PdbwBsRU/6Bi35I=;
        b=mk/nH3bP25/jntmJMwJvwUqzXVbPugt2wX/CQO82XNNsqbXQ9DINlEkvE/hpOfI4x3
         s3bluP22h3xzClRJekwoKx31+DJPN0BJi0O0qG7Pihq/5cIAa2q0BneB69if1dwSypXh
         caQGyYMnmPRg3yw2ULGD/R1H2QnZBEGh8eg8/APaWK2IpgzeDycABAVrPL146uatpro/
         I+okJUl93ipzPFcJ34dSD/HmDRRZ0tHCae6MBVRAN82yru5O+QWknfDwos5F4tafkqmk
         NbtHEF21e1i84CPxbMA701uV+VMNgAu02CYmLC8FkfzCiRX2sHZJvq/cvvGMkBAvqW8Z
         Bh+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QeLg2DTBbdqjeh99qWORPQ1IItT1PdbwBsRU/6Bi35I=;
        b=rMROByqwXjjQuzwowqyGDbeFPx2UlQxCDf1HbHmvxEODzVJ3RGr5VacLf+G98X+53b
         3IImkKsqE5QzW7+1wWSwjnniA6qHsO2UzNsRjnvi/R1r8uIOv9eCziMT1Y5JgZ+L6ahz
         j4/tqt87eMx2EWCDkjC90Cvwe/fZDollwhGOFGmwUeqLnCLBvMKPqBHqyX/2cu9PPP50
         VYCOzTlIuNF4gNzgXIxHRFbpcV5DRveoragXjJBfREJl6nU9GYIwSpN6WsTXGCG+/1S+
         lFis0Reo7nZ7KI0wEfx4Mp3LKRvAtlmg4h+azBS5aYEtsXQIXCkmnAbLR+pYOQl7NV49
         5yMw==
X-Gm-Message-State: AOAM533WFpxNKipIQeH5J7rdiQ/VW5tFQwM1/tqHhlafihEkgzFTIlDA
        GuxsggIKApVWGnIV1G80wVA=
X-Google-Smtp-Source: ABdhPJxdaK2/A325W9NNK+KT0N9nXNP+y7xRjdoDUoFWo23S48P5D3VGsbRAqRumlv25IH+HTZ/eug==
X-Received: by 2002:aa7:d594:: with SMTP id r20mr16747796edq.242.1619996836831;
        Sun, 02 May 2021 16:07:16 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:16 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 03/17] net: mdio: ipq8064: enlarge sleep after read/write operation
Date:   Mon,  3 May 2021 01:06:55 +0200
Message-Id: <20210502230710.30676-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the use of the qca8k dsa driver, some problem arised related to
port status detection. With a load on a specific port (for example a
simple speed test), the driver starts to behave in a strange way and
garbage data is produced. To address this, enlarge the sleep delay and
address a bug for the reg offset 31 that require additional delay for
this specific reg.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/mdio/mdio-ipq8064.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index 8ae5379eda9d..bba2fb0d6af8 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -65,7 +65,7 @@ ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
 	writel(miiaddr, priv->base + MII_ADDR_REG_ADDR);
-	usleep_range(8, 10);
+	usleep_range(10, 13);
 
 	err = ipq8064_mdio_wait_busy(priv);
 	if (err)
@@ -90,7 +90,14 @@ ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
 	writel(miiaddr, priv->base + MII_ADDR_REG_ADDR);
-	usleep_range(8, 10);
+
+	/* For the specific reg 31 extra time is needed or the next
+	 * read will produce garbage data.
+	 */
+	if (reg_offset == 31)
+		usleep_range(30, 43);
+	else
+		usleep_range(10, 13);
 
 	return ipq8064_mdio_wait_busy(priv);
 }
-- 
2.30.2

