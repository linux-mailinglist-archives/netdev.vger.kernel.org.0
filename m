Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60BD373272
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhEDWbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbhEDWaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:46 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA43C061761;
        Tue,  4 May 2021 15:29:50 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id y7so15566247ejj.9;
        Tue, 04 May 2021 15:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wm9XVrPu0tjWd8bcUHtN+gG/GfT4k4LNZUMGlRbD5Nw=;
        b=hDTRR12Do3zwUNgUD0uhFWWziJ7XOGBikPAmdlnXryq9ReflasgNCDVrhfKflkzFzV
         pIOZloC8XlWwLwnZiDH/HOa83HD3pW30dqAeX/2zgSx3r6s4yepGL+dLmiNOeKVP0pKb
         dmwqGD08oZYFisqHpONOMZsLWeyPEDAguiUHohkYgUZ2MIfVgxOamBazI3byekwzOGyu
         a5CNA9NU81dtQxwvpmpedCL6Rc+pcbTTWWSrd5Qi3c/4ACT6aYl5bMh4dMX48uqQ+pyB
         5NWPJFq9Aiyi1x5FUh6U2K3N/lw8ecfDrSEpQ9MmsWJmDVFab+T8p6oMldU6OmIyJtf/
         D0Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wm9XVrPu0tjWd8bcUHtN+gG/GfT4k4LNZUMGlRbD5Nw=;
        b=cD4BOPgXbIULjxggDklqBWnrOvS6gTvBbsxBux1vHmMYaSFfTdKdbStVtsApD5cU/p
         egayg5KTGJNZu11heW9WGdhG99wSTf2k1Kan1P3XPIkCAhUZR68DrOHX9xpYBAIAxJei
         ZgcFIPaUUGhrPoCKjzHdj4F2s6EL5+2q4kCLUb7PxVr6nw3apdqJVuNsPahmrGH5MrP2
         w9MuAdJY+ldLrvHX2AoT++i6Y5OLwo6lWCe05nlZgcdjyTMUuSZ03L+ncbTgJmijf9B1
         4EnpBuaNpL1Jfkmq9H06fOINa8SRzI0pJ5LuMQ8Obj2R+zdEBNDRGcFG2mP2yMbZmN6R
         yoMw==
X-Gm-Message-State: AOAM530UJt0TplkN/wqrlgmbsAp0qUGh1bYQq8qs9bSxiDBDIjXNfU+K
        XuxWtqzRArlTIh+SjV0S1sk=
X-Google-Smtp-Source: ABdhPJyQ1FaPoBdtdqj56YzOrxcA0jA0ypSC9Y6JZK6o8awqsla+pu9IDpuo4Ke/23K7RxCDlH81og==
X-Received: by 2002:a17:906:cc48:: with SMTP id mm8mr24124447ejb.344.1620167389545;
        Tue, 04 May 2021 15:29:49 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:49 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 15/20] net: dsa: qca8k: dsa: qca8k: protect MASTER busy_wait with mdio mutex
Date:   Wed,  5 May 2021 00:29:09 +0200
Message-Id: <20210504222915.17206-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO_MASTER operation have a dedicated busy wait that is not protected
by the mdio mutex. This can cause situation where the MASTER operation
is done and a normal operation is executed between the MASTER read/write
and the MASTER busy_wait. Rework the qca8k_mdio_read/write function to
address this issue by binding the lock for the whole MASTER operation
and not only the mdio read/write common operation.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 69 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index b21835d719b5..27234dd4c74a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -633,9 +633,33 @@ qca8k_port_to_phy(int port)
 	return port - 1;
 }
 
+static int
+qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
+{
+	unsigned long timeout;
+	u16 r1, r2, page;
+
+	qca8k_split_addr(reg, &r1, &r2, &page);
+
+	timeout = jiffies + msecs_to_jiffies(20);
+
+	/* loop until the busy flag has cleared */
+	do {
+		u32 val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
+		int busy = val & mask;
+
+		if (!busy)
+			break;
+		cond_resched();
+	} while (!time_after_eq(jiffies, timeout));
+
+	return time_after_eq(jiffies, timeout);
+}
+
 static int
 qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 {
+	u16 r1, r2, page;
 	u32 phy, val;
 	int ret;
 
@@ -651,12 +675,22 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum) |
 	      QCA8K_MDIO_MASTER_DATA(data);
 
-	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
+
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+
+	ret = qca8k_set_page(priv->bus, page);
 	if (ret)
-		return ret;
+		goto exit;
 
-	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			      QCA8K_MDIO_MASTER_BUSY);
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
+
+	if (qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+				 QCA8K_MDIO_MASTER_BUSY))
+		ret = -ETIMEDOUT;
+
+exit:
+	mutex_unlock(&priv->bus->mdio_lock);
 
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
 	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
@@ -668,6 +702,7 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 static int
 qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 {
+	u16 r1, r2, page;
 	u32 phy, val;
 	int ret;
 
@@ -682,20 +717,30 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
 
-	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
+
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+
+	ret = qca8k_set_page(priv->bus, page);
 	if (ret)
-		return ret;
+		goto exit;
 
-	if (qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			    QCA8K_MDIO_MASTER_BUSY))
-		return -ETIMEDOUT;
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
 
-	val = qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL);
-	if (val < 0)
-		return val;
+	if (qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+				 QCA8K_MDIO_MASTER_BUSY))
+		val = -ETIMEDOUT;
+	else
+		val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
 
 	val &= QCA8K_MDIO_MASTER_DATA_MASK;
 
+exit:
+	mutex_unlock(&priv->bus->mdio_lock);
+
+	if (val >= 0)
+		val &= QCA8K_MDIO_MASTER_DATA_MASK;
+
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
 	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
 			QCA8K_MDIO_MASTER_EN);
-- 
2.30.2

