Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79933376DD3
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhEHAcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbhEHAa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:58 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCDEC06134F;
        Fri,  7 May 2021 17:29:43 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id m9so10873125wrx.3;
        Fri, 07 May 2021 17:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VXJeCZ6p+84hYUeYtR84+eoPuhkPjIoXlDYRmPpn2+8=;
        b=DPeGUdJcSUo+UoxhjoUaNJfdVkwp640u3cPmrm2GUFftpL96BlYx+M9lIclfy07z9w
         IwkZz2QpxQv9scdQaXdyyzlOee6h7L0ePa6hBNW9iV/CNXK2R5AJxC1IgFf3F90Ri0gb
         3bFXEZob8kzLh5G0zZefvMcyEUezUgKCzJOCWqo6OYrqvlNZo++PgU2uM1CwECXikUVq
         kgzv46bjSDRNh1o19wqCdk6bem99KQ8XPVVo1p8phdtMz2DdC9uCAjACWUplYVTGeHff
         elckCnBZDS5QfarhjGtmEcy0OajKpi4YqzYBEij2GAiZUYjWyXf/wivqRAb3gMdm8OjV
         0M5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VXJeCZ6p+84hYUeYtR84+eoPuhkPjIoXlDYRmPpn2+8=;
        b=sYVT1AZkMly0db0FAU/9fCYuGEWwPIo8nevqhdQvVumIGYiXa/uTNZHg2sqBbud47p
         hQmnDK0W139Y95DHHhmOA9kgRNFK40C/FLijDSw/Ie3vM4kM8lK9N9nKBHs8fZ00XyuB
         EUFAyQt5Fk1RJIHp+KXU1KXEvhty8QrweLnnSLU044P0FDiVDmlDhI90bwN8TfPeHlwM
         AEEiCblvNRfWBxIU3OgLKsh3cJ+iAfw3cXmqkjH3w51XX6gsiG/HFq2BSueB68F5Xfxn
         8g/+7D9ISFhuk0G9G8oZh3gvkgWjesJYbA1t9kRvXQvTy+PziGgWicnDKqYxguiIZZdZ
         XBkw==
X-Gm-Message-State: AOAM530f6OII+aN7xMglwug14ovAdjSuUgAf+0Rb6Ty2gifElZnpwjJh
        HGHOlJerHJ1Ba5+nRuWPqu4=
X-Google-Smtp-Source: ABdhPJyH62MH2gubA6pgUluB4iCFQc8a5Y0s9n7M7Qax7f3RiG9lHrJUS9t+BPySpGJNkHEyNW1hqA==
X-Received: by 2002:a5d:6811:: with SMTP id w17mr16067723wru.348.1620433781868;
        Fri, 07 May 2021 17:29:41 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:41 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 21/28] net: dsa: qca8k: dsa: qca8k: protect MASTER busy_wait with mdio mutex
Date:   Sat,  8 May 2021 02:29:11 +0200
Message-Id: <20210508002920.19945-21-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 68 +++++++++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 2e0d2f918efe..e272ccaaa7f6 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -639,9 +639,32 @@ qca8k_port_to_phy(int port)
 	return port - 1;
 }
 
+static int
+qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
+{
+	u16 r1, r2, page;
+	u32 val;
+	int ret;
+
+	qca8k_split_addr(reg, &r1, &r2, &page);
+
+	ret = read_poll_timeout(qca8k_mii_read32, val, !(val & mask), 0,
+				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
+				priv->bus, 0x10 | r2, r1);
+
+	/* Check if qca8k_read has failed for a different reason
+	 * before returnting -ETIMEDOUT
+	 */
+	if (ret < 0 && val < 0)
+		return val;
+
+	return ret;
+}
+
 static int
 qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 {
+	u16 r1, r2, page;
 	u32 phy, val;
 	int ret;
 
@@ -657,12 +680,21 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
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
+
+	ret = qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+				   QCA8K_MDIO_MASTER_BUSY);
 
-	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			      QCA8K_MDIO_MASTER_BUSY);
+exit:
+	mutex_unlock(&priv->bus->mdio_lock);
 
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
 	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
@@ -674,6 +706,7 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 static int
 qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 {
+	u16 r1, r2, page;
 	u32 phy, val;
 	int ret;
 
@@ -688,21 +721,30 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
 
-	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
-	if (ret)
-		return ret;
+	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
+
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			      QCA8K_MDIO_MASTER_BUSY);
+	ret = qca8k_set_page(priv->bus, page);
 	if (ret)
-		return ret;
+		goto exit;
 
-	val = qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL);
-	if (val < 0)
-		return val;
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
+
+	ret = qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+				   QCA8K_MDIO_MASTER_BUSY);
+	if (ret)
+		goto exit;
 
+	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
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

