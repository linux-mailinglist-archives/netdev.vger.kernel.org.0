Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232BC373253
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhEDWae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbhEDWa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:26 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010C5C061761;
        Tue,  4 May 2021 15:29:30 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id j28so12250914edy.9;
        Tue, 04 May 2021 15:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ceZsngI1VaZJ3EMhxlXbFwwOKDKMAKywASflzR5/4cU=;
        b=DPo4UkayLtU6ac5NQSlJevvxHwDodxuswdgu/llP0DEGOs7jE9K58wVOXczjdYt+89
         71TsT+vQc/KLqrbqvqEIcw9Io9J4p2nvWHqi2J9JK+4G1jgZBL3Qgyo4BsMqJ4lA92Oe
         4ZkBwCxEJ1EqEvFqDmTTNsJNzoUE8SxVP1cn4uGHyg9+Z2YDD4UhIuDSw17bZfnANhwA
         BkH6DX5itoec4p0YXdmlv+2gRE7/UMqcDYMi2RAKgQ9fg4XFgB2OSMAL5WbDejgNhSVm
         KeSmRKgplJNdQO1ej6XTbvHvF6K7kZarMfAdfHdMN/dQhjUaVfLDiTu5bqEPU+oZlfSe
         QqUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ceZsngI1VaZJ3EMhxlXbFwwOKDKMAKywASflzR5/4cU=;
        b=KtFpob48Jz41odMU9cDzhyaZ+skPt+SD4bBEyszSQLLHD/GE1rVC8tG3JlmOh4lAlp
         j4qKWfx17TPSVuNuIIEwT6O4e7VQZQF+R0SD9ycGFTTJBSN2E/CNQMyOaFzXq9e0CqQA
         McKlCjzlpoYw8dWj27ZOWGKWN33JRHl/V8pykEoOgLC5X6aYfauJ+pDEe3OgZNUVMQ9o
         PKGSD6h+AohCSxL1iLO1KXkcC1AjJEH6xB+fz2vHsdSLY+2nZ4fWYo5cAf2ZzeOmkbf2
         nKuuKJwR9FkH7uBJVjgheFUJ0mUaOHXCLIAoki34rW3PWQDpeoKQB20BqndM/+WfPPFI
         /XJg==
X-Gm-Message-State: AOAM531div6P3j8P6C5SnGr3Iz604pNoizfygZXx4jjqGDkuxOPjDQ8B
        BV9MTRq0pNW0a1Kn4mJd5sc=
X-Google-Smtp-Source: ABdhPJwbvmGLzLxGpyiNSDjRC2EelWg5+JK8AcvoGEZm0sFhuNKrjHItdQXkpbRurauRhuXc7EtALw==
X-Received: by 2002:a05:6402:b88:: with SMTP id cf8mr28454002edb.227.1620167368569;
        Tue, 04 May 2021 15:29:28 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:28 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 03/20] net: mdio: ipq8064: enlarge sleep after read/write operation
Date:   Wed,  5 May 2021 00:28:57 +0200
Message-Id: <20210504222915.17206-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
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
index 9862745d1cee..a3f7f9de12b6 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -65,7 +65,7 @@ ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
 	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
-	usleep_range(8, 10);
+	usleep_range(10, 13);
 
 	err = ipq8064_mdio_wait_busy(priv);
 	if (err)
@@ -91,7 +91,14 @@ ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
 	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
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

