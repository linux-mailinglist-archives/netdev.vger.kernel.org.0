Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD9F370F9E
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhEBXIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbhEBXIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:21 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18E2C061756;
        Sun,  2 May 2021 16:07:27 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l4so5163808ejc.10;
        Sun, 02 May 2021 16:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KPsZZdgMA7BtF65x6SfTv4t8+0Feb9wvJOWOkienFUs=;
        b=tT73OGngfrJQoKadgIyzQwP2q6BhkxbShBQJ6WyYwVLr3IruizoeRAJhjAZ3CR0eWt
         585grTBrCiaJuJw0BGuG6eZpynQpQYQ7FXBDmPOwEkkeja03MV7hVugw/mjkW/kgi6Bb
         QWUj8+jrBEbXPp8zHGKWxel4zjXmur2vCBJgK77IZdBA6V8Peg9IihZNVlVE93YOXK1u
         oTXx5Hp1Rvy6BCKV5YPmkoePjWsM8fiADVjflNZliq6rlTFAbI3ko8QPyXWhee8zHTTg
         50KVy0e3KmQJNOE8se7h3gNktfCLnQJxfYd3Caq/gwOmtOSwwoqYft733GWlaADOiNty
         UPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KPsZZdgMA7BtF65x6SfTv4t8+0Feb9wvJOWOkienFUs=;
        b=KyydO2dKrrSno4vfliniGIZgXudpDhFtFVQpduqL2rc2srrlS6hYbUO20pgw731UHa
         v+5cIN+MGFnS8ciZXwyJq6X2Pk9EkiRjkqtX7nx0HNe8b7IWVy0QQ9g6541TAaRU/qkD
         8/iYvfEw1rFCE+6g/S4lneBtcU0y+1bYd0OJN12pqMxPaNufjZedgn4Mm94r1vGfK6kI
         0VdRJtMmdDQ2icipjlnBX7tzNJdxpFYimZZeDv//A3D7j/i1xwEcUnxDUgp97T/fkBCH
         dQTNDOihWWNxLaRADV/J0Oq2SCCVmUBEtJ2if+7JNasUPxkuaf9SbE6riq9v1dx9jJ9+
         DOrQ==
X-Gm-Message-State: AOAM531LtAW+SLRZ7EF0OtyXJdeWrhgkoeoxSXWhFk7R6PVV5oC4CPMd
        MJY5uxFPTCrfVDplZOlJm4Q=
X-Google-Smtp-Source: ABdhPJxfS76dzh0jBCP4uOyNEM0ak4zEu4+yNAerhVXxezSMxw3trfwXHspIfzGn/TKokLOz3P+XOg==
X-Received: by 2002:a17:906:6ace:: with SMTP id q14mr14784849ejs.79.1619996846542;
        Sun, 02 May 2021 16:07:26 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:26 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 12/17] net: dsa: qca8k: dsa: qca8k: protect MASTER busy_wait with mdio mutex
Date:   Mon,  3 May 2021 01:07:04 +0200
Message-Id: <20210502230710.30676-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
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
index f64e3215a515..9a1b28bcaff0 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -617,9 +617,33 @@ qca8k_port_to_phy(int port)
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
 
@@ -635,12 +659,22 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
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
+
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
 
-	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			      QCA8K_MDIO_MASTER_BUSY);
+	if (qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+				 QCA8K_MDIO_MASTER_BUSY))
+		ret = -ETIMEDOUT;
+
+exit:
+	mutex_unlock(&priv->bus->mdio_lock);
 
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
 	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
@@ -652,6 +686,7 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 static int
 qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 {
+	u16 r1, r2, page;
 	u32 phy, val;
 	int ret;
 
@@ -666,20 +701,30 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
 
-	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
-	if (ret)
-		return ret;
+	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
 
-	if (qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			    QCA8K_MDIO_MASTER_BUSY))
-		return -ETIMEDOUT;
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL, &val);
+	ret = qca8k_set_page(priv->bus, page);
 	if (ret)
-		return ret;
+		goto exit;
+
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
+
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

