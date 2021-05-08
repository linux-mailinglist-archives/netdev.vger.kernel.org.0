Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727E0376DB4
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhEHAag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhEHAaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:30 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510E5C06138C;
        Fri,  7 May 2021 17:29:26 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id y124-20020a1c32820000b029010c93864955so8034674wmy.5;
        Fri, 07 May 2021 17:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y5shnGFIJisQx9OU+texi5mIGK85UxW/wCfTWYT9YTs=;
        b=STdXTwvOO0hJjk15uM2C+ek+wKTi80FjtAUDbI1Mu9rPIjFOzucVSCZJXam6DKzYSH
         S+UyoU9QUNYk6wTrJMaU49ckGg3sMlevXUOjw6g8uaEgy10kydZgrxLL36/1oYobbLeU
         I6dyWPCBh2eBFjbahViKEemIBnhMsflikkFxFYBqi+gG3TyWQPgxJDox9SGpTOXtCV2J
         oj8l37iMLVP8xv48mIXp91RziSErzQ1GKlmXa9zVCDSaYxYbmU4P5L779+gTvp5/rVw2
         yiXKhzGilfZLsVJKpovFEoJE3tAxUvbO73Iy9ilx+pLBeM1HONNOqVtv4Whabp+BBTrQ
         e3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y5shnGFIJisQx9OU+texi5mIGK85UxW/wCfTWYT9YTs=;
        b=YKIuEjBUR9SYuquKteUNYq/fQHrM3VTFM7QsWsAuEtK47Kx+T6J5nTO7EM3XnjS/0M
         eYYrPL4DOTBOVQ3jJPwBptoK6tkPHasBF5p1T/PLkXcrGmbXS3sq0WJzj8EojfOoyDgM
         Xd006ysGePRP+SMyOh5zw+CHgAUjz6/hRE/NBZgPsDvUQ7Iz64qpflXT+usv4oTKXN6L
         DuMqItXDVfXY60tXmqeErunRpRAbHhhXTxSGhMOjxCndBfZIEPbrRqilPdqvvtpAIOHA
         GQH5ezAGxXggF6/zJhn4Na4DnzejErJFORgAYusbataF5VAAc2aErLj60T60/tbsKrBo
         jdYQ==
X-Gm-Message-State: AOAM531163rpTYglXVtSdwi272fivEerZ7Ujzidb1ipQI6MLrmaF2MGy
        a8211ubWnZcf+NnksOQPKYM=
X-Google-Smtp-Source: ABdhPJzJhWh+tnGcSIJsKp9Qcvl57TlxYk0vLzhG0g02zwxaqZQt5CQAvGTxmeIGopW3xEhYmdF44Q==
X-Received: by 2002:a1c:35c6:: with SMTP id c189mr23697734wma.127.1620433765103;
        Fri, 07 May 2021 17:29:25 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:24 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 07/28] net: dsa: qca8k: handle qca8k_set_page errors
Date:   Sat,  8 May 2021 02:28:57 +0200
Message-Id: <20210508002920.19945-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index f58d4543ef1e..1c52d1b262f1 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -127,16 +127,23 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 				    "failed to write qca8k 32bit register\n");
 }
 
-static void
+static int
 qca8k_set_page(struct mii_bus *bus, u16 page)
 {
+	int ret;
+
 	if (page == qca8k_current_page)
-		return;
+		return 0;
 
-	if (bus->write(bus, 0x18, 0, page) < 0)
+	ret = bus->write(bus, 0x18, 0, page);
+	if (ret < 0) {
 		dev_err_ratelimited(&bus->dev,
 				    "failed to set qca8k page\n");
+		return ret;
+	}
+
 	qca8k_current_page = page;
+	return 0;
 }
 
 static u32
@@ -150,11 +157,14 @@ qca8k_read(struct qca8k_priv *priv, u32 reg)
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(bus, page);
+	val = qca8k_set_page(bus, page);
+	if (val < 0)
+		goto exit;
+
 	val = qca8k_mii_read32(bus, 0x10 | r2, r1);
 
+exit:
 	mutex_unlock(&bus->mdio_lock);
-
 	return val;
 }
 
@@ -163,14 +173,19 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 {
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
+	int ret;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page);
+	if (ret < 0)
+		goto exit;
+
 	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
+exit:
 	mutex_unlock(&bus->mdio_lock);
 }
 
@@ -185,12 +200,16 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page);
+	if (ret < 0)
+		goto exit;
+
 	ret = qca8k_mii_read32(bus, 0x10 | r2, r1);
 	ret &= ~mask;
 	ret |= val;
 	qca8k_mii_write32(bus, 0x10 | r2, r1, ret);
 
+exit:
 	mutex_unlock(&bus->mdio_lock);
 
 	return ret;
-- 
2.30.2

