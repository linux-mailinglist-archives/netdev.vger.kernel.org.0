Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DA44715ED
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhLKT6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbhLKT6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:31 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAD5C061370;
        Sat, 11 Dec 2021 11:58:30 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id t5so39681952edd.0;
        Sat, 11 Dec 2021 11:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RQADOX9Nm0sVY3Eh8XHvdzdj54VJkMZKeLoeWQvIR1k=;
        b=EkkYTpzgloAEYcs7DCpDjuXqHKEYO0ujx5fX27wxPrE/OyMi72W2hYhUQUesMyhsKN
         jJ3+4BDNzEjE0cAsoFzE8pxcauJwDxNYTePrvgHE4TngKdBFyBQ5cuSvUiVsJ3uuiI2P
         +NXXUo/+GU7Ng5if/UGlgKlnBJmZSKXhlPHgPDN/N0rRFRW59icQ0tk6Zq+wL93GYb+Z
         XeDvTYnKO1gE2f3eQFbD9XFmh2dFTugmQlJRenA8gn8XIx4N2j1R3tYjcW9LtUM7ORQW
         UZNNzqGwMY4cIZQuks2cma/teWwj/85Aa+ADllwWo0nd2WIjt0/TGtgQt4k7lbLe7+ee
         1LFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RQADOX9Nm0sVY3Eh8XHvdzdj54VJkMZKeLoeWQvIR1k=;
        b=L4GgnZv0D10mOKvH6HgX6eBPikPMvDV00sw8h4NMq2AEEz1g4wrmegkieMAvbyS9tn
         sCKzMWSxgrFlu8ITqDvIRGGyPasu5pHanYaYjFj2vHR++tuuTDgwiZfIlpg3Mqjc1UWE
         TaBSCFSVtvhIYtSwPSJnfRQQx4+Am5vdxryeR7GIRfVBsNZuGiXhW3dg04pVbx4Hug+n
         oa11DIpxda2zpvAw61NgE30RaUos5mq/9npqFrUSGgA6lfbyYHXDHnJxgbMSWGiKqv/v
         hFtOq+By/WSeQxsQIDZF2xChwR9vHyEKeygiWK+JbKASgS/qEgJ17WU7SElqrFcLS0Iy
         rxSg==
X-Gm-Message-State: AOAM5302B35eJQeEIyUWNWcmYPId+btNE0eg4TAdH1FTFGOFLPzxWrW8
        PryVMb6I0u3bhSmL0QcNeO9mByjQU3c8Mw==
X-Google-Smtp-Source: ABdhPJwfq2oO5shrmIrcaTJ6bGTg4oQSCX0fnxxObdOywfW95iNfXR6Sm5zfRJolsuxtll9ceWHDWA==
X-Received: by 2002:a50:c35b:: with SMTP id q27mr48868978edb.154.1639252708912;
        Sat, 11 Dec 2021 11:58:28 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:28 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v4 15/15] net: dsa: qca8k: cache lo and hi for mdio write
Date:   Sat, 11 Dec 2021 20:57:58 +0100
Message-Id: <20211211195758.28962-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From Documentation, we can cache lo and hi the same way we do with the
page. This massively reduce the mdio write as 3/4 of the time we only
require to write the lo or hi part for a mdio write.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 49 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 375a1d34e46f..b109a74031c6 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -94,6 +94,48 @@ qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
 	*page = regaddr & 0x3ff;
 }
 
+static u16 qca8k_current_lo = 0xffff;
+
+static int
+qca8k_set_lo(struct mii_bus *bus, int phy_id, u32 regnum, u16 lo)
+{
+	int ret;
+
+	if (lo == qca8k_current_lo) {
+		// pr_info("SAME LOW");
+		return 0;
+	}
+
+	ret = bus->write(bus, phy_id, regnum, lo);
+	if (ret < 0)
+		dev_err_ratelimited(&bus->dev,
+				    "failed to write qca8k 32bit lo register\n");
+
+	qca8k_current_lo = lo;
+	return 0;
+}
+
+static u16 qca8k_current_hi = 0xffff;
+
+static int
+qca8k_set_hi(struct mii_bus *bus, int phy_id, u32 regnum, u16 hi)
+{
+	int ret;
+
+	if (hi == qca8k_current_hi) {
+		// pr_info("SAME HI");
+		return 0;
+	}
+
+	ret = bus->write(bus, phy_id, regnum, hi);
+	if (ret < 0)
+		dev_err_ratelimited(&bus->dev,
+				    "failed to write qca8k 32bit hi register\n");
+
+	qca8k_current_hi = hi;
+	return 0;
+}
+
 static int
 qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
 {
@@ -125,12 +167,9 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 	lo = val & 0xffff;
 	hi = (u16)(val >> 16);
 
-	ret = bus->write(bus, phy_id, regnum, lo);
+	ret = qca8k_set_lo(bus, phy_id, regnum, lo);
 	if (ret >= 0)
-		ret = bus->write(bus, phy_id, regnum + 1, hi);
-	if (ret < 0)
-		dev_err_ratelimited(&bus->dev,
-				    "failed to write qca8k 32bit register\n");
+		ret = qca8k_set_hi(bus, phy_id, regnum + 1, hi);
 }
 
 static int
-- 
2.32.0

