Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684E5381237
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhENVBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbhENVBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:33 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4376CC06174A;
        Fri, 14 May 2021 14:00:21 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i13so41703edb.9;
        Fri, 14 May 2021 14:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lOhZtmXqoRB7AbKYw3B3ViWwWTWCEQNKhNHuzYiWBKQ=;
        b=gn1Fk6GAZI2dZjUr7amKHW+bXij3b7eOuuWz42TQBkeYdc8xpsyp6G4tjDMBrv95y2
         n08Ski1YIDjIMDR+rBSAN9UNSEMFKNfjuikOTQVTj0xkgXRAJ8l65r4doeLEuVUywlq1
         s48soMtHd2it67FFe141D77KgNjhx564Ejo3moJdU/PNuJJ74tueadqrg5W6gXmgffTC
         1S+DCY7rHAUgcjBLCnZfKXDMa9NU/VlIU+Cp43IkDoBARYz8j0SIWX1JSEEW1By5ozzA
         6QMNnFnzpUmwwH0e9mSRCSmDkUBAiHtRZuf2JQGaeacpWqlti0xqE8jGQn26NYVBJIXz
         FneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lOhZtmXqoRB7AbKYw3B3ViWwWTWCEQNKhNHuzYiWBKQ=;
        b=OWsIluz1P9OQKTOII6SeQQ/rQs+TvYaXO3cpgtuPnZZbie6lj6YAlHrZ4fZlgBb/3z
         kLKXP+rwH05n59fOKvvdJ6gojypfgE4BMuz3EpAFgyxalu0OEyAB7FiGQyhh1xfQvn1Z
         +/dJu29madLaTpCk6ywfy/5YeB/zzXoNETARWpZGZqzj/F2H/0n9wTYxKySnrXycy2DK
         ZYkOyeLMuqo6kbYnJoddMHurWFCZAWVQZU0eQvKBKpKM/8s0hYYJjyCWMkMtey/y0lYJ
         nqUanbvAjFNLMW2kyX99NDNcIl3REb/2tingr1hMYSCU3KMBeonHtKwJI8DdZlImQ3fC
         GNoQ==
X-Gm-Message-State: AOAM53270v0daRDPVw7sYDg+jLM8VKQMKn7hOTyf1iWLPNtyEcr/lFuy
        kaBsx+46q+94UpoS3FW0JuA=
X-Google-Smtp-Source: ABdhPJz1lMpFTkr8PZNrnOLcke2FrdLxP3xvxhobm148fIIdOVqVIdX8j992F1GapsFBzVi4l636Kw==
X-Received: by 2002:aa7:cc11:: with SMTP id q17mr25675362edt.240.1621026019971;
        Fri, 14 May 2021 14:00:19 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:19 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 04/25] net: dsa: qca8k: handle qca8k_set_page errors
Date:   Fri, 14 May 2021 22:59:54 +0200
Message-Id: <20210514210015.18142-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a remote possibility, the set_page function can fail. Since this is
a critical part of the write/read qca8k regs, propagate the error and
terminate any read/write operation.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 3c882d325fdf..c9830286fd6d 100644
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

