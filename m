Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAED3373255
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhEDWag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbhEDWa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:26 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00C2C061574;
        Tue,  4 May 2021 15:29:30 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gx5so15572789ejb.11;
        Tue, 04 May 2021 15:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gmw0fx5Yr4KnURC9m6ih0i5MP36F1kmbtOHyUv029Gw=;
        b=DWM2sDWAJVWYQYX+o94qDEQTjDUCXe9bGsfyOOzdgMT3+CS8JVT8n+kkhlwwOXf/7h
         Cg8Opm9GuvuVdT8mVDp/kExr4eF+LscjnirR/YgF9rqFstcixVkk8nqpeyCC0M00LJ+x
         LDIOkIuoz66kGNUhEL6UcgMWePDAqd5i0DVbyuDl4TiVO3TDtNEob+EBGLJ11dmvqb8V
         bkrwMD/t+GyvTsZRZ6FIldqCPN+79A347MlsztLv+1KyzWC75rOdwinP+2Pn4EoOlRjD
         q0D7I7vV2gxWpaeGEQ84ZoH7qkn6JhsPNLc29k64w4zBtHKK72dEtdR0ujUP7PC2i2ET
         zMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gmw0fx5Yr4KnURC9m6ih0i5MP36F1kmbtOHyUv029Gw=;
        b=U0+LG/B+5wYu0WFYUD+E3jtfMLUUqI+ICtWWFp8IfpBB6V9/xsrEiOg59pZFu16LOr
         SLcYDuWNntHN10g4MgQnWJDwy7GAspp7NbyRgq2xTvtUX8YTCgvUh71MOj+hBZhsBgJP
         Z9z8AWwIjtE+hGtEgJYtC5ivj9xBSSPzDZFRzLcMg29ZQke1IF3Hy3mbEa1woiNjXN5C
         boic03DFvjWVpYLM3dosfVadXAf/CPTBnuN4gza5db258qi8N+Qb3fdfsGPFOxV2OjhB
         xkWvR+bQ3ypnr00H+ZFSssiSnGuyp5C2QdcUJ/p8NFVsanPVtQcGMi/vdDZty7wl306k
         faZg==
X-Gm-Message-State: AOAM533v3mqTXNAbddF3p5eZ3jn3v4yjIpf6sMiZlL0k/k5p5XCm9C8d
        PGohPggZrx6QH4SkE0z2goE95gxasAiyAQ==
X-Google-Smtp-Source: ABdhPJw2eRiTaItOcr+XmvFu3dF31xSH5hwXmEMLa7tyYgEUUatHq4xDRtNSnCHVw3y6SIH2Qp0iQA==
X-Received: by 2002:a17:906:d969:: with SMTP id rp9mr14302301ejb.516.1620167369644;
        Tue, 04 May 2021 15:29:29 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:29 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 04/20] net: dsa: qca8k: handle qca8k_set_page errors
Date:   Wed,  5 May 2021 00:28:58 +0200
Message-Id: <20210504222915.17206-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a remote possibility, the set_page function can fail. Since this is
a critical part of the write/read qca8k regs, propagate the error and
terminate any read/write operation.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index cdaf9f85a2cb..411b42d38819 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -127,16 +127,20 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 				    "failed to write qca8k 32bit register\n");
 }
 
-static void
+static int
 qca8k_set_page(struct mii_bus *bus, u16 page)
 {
 	if (page == qca8k_current_page)
-		return;
+		return 0;
 
-	if (bus->write(bus, 0x18, 0, page) < 0)
+	if (bus->write(bus, 0x18, 0, page) < 0) {
 		dev_err_ratelimited(&bus->dev,
 				    "failed to set qca8k page\n");
+		return -EBUSY;
+	}
+
 	qca8k_current_page = page;
+	return 0;
 }
 
 static u32
@@ -149,9 +153,13 @@ qca8k_read(struct qca8k_priv *priv, u32 reg)
 
 	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(priv->bus, page);
+	val = qca8k_set_page(priv->bus, page);
+	if (val < 0)
+		goto exit;
+
 	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
 
+exit:
 	mutex_unlock(&priv->bus->mdio_lock);
 
 	return val;
@@ -161,14 +169,19 @@ static void
 qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 {
 	u16 r1, r2, page;
+	int ret;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(priv->bus, page);
+	ret = qca8k_set_page(priv->bus, page);
+	if (ret < 0)
+		goto exit;
+
 	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
 
+exit:
 	mutex_unlock(&priv->bus->mdio_lock);
 }
 
@@ -182,12 +195,16 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 
 	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(priv->bus, page);
+	ret = qca8k_set_page(priv->bus, page);
+	if (ret < 0)
+		goto exit;
+
 	ret = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
 	ret &= ~mask;
 	ret |= val;
 	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, ret);
 
+exit:
 	mutex_unlock(&priv->bus->mdio_lock);
 
 	return ret;
-- 
2.30.2

