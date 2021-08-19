Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4953F1A19
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239779AbhHSNNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239655AbhHSNND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:13:03 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B98EC061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:12:27 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id z9so9017836wrh.10
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M5wvJU9nS0PBB383gj3PbquvMXX21vpI+F/H85bw73U=;
        b=nY708PVkbDn8F0pt3wBszkImYQJSAayIW0moQApvzeC/1QHnWzlKaV+fDxpQlhtN3U
         lk90ItknFP7bNOy8nxXWhS5er17Dsfe+m/2locNt3/ar746M/DUFJPoOCEmoif52JBcX
         5l6MyamVs0E3g3cotx0avwrit1yBDHKpumRA/vtD4HcwlqDJg4LtWICJgEM2/fepLx5H
         pJZGyBo3SjRTz8nBNshElBlHb6I/U0YpgL5vnHiUh1FUEbJJPZ6tN5aSh7js/Be112Y/
         xImYBIeFXQDxiL0GXmJeGIpZ0yILeFYf09fP+dW0R1669tKcuZJKlAYfANJJ2HJDaLgd
         XuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M5wvJU9nS0PBB383gj3PbquvMXX21vpI+F/H85bw73U=;
        b=MAV6rc+msNhFogTga4OY9QXidaHWKYbdwQEhhn75r1qAV/rj9cPdgkL2vUTc6rhAx+
         9jTinKb1Jitr5DOr2nPnBYqyx/sGGbU9DnjEf3RwAnQ/AJaAB9RhB03l5TeBnOku8z+K
         1S8rT5sAIrwf2WyKuSg/JuQ4MyP2tRRIP0ffHm/8fVQHXxmcSseTP0q527j0BtPbaI5x
         BYDeTl5YX9ULoXK+j4f3o9AD63e9UfQIEPFAmjdXPLeFTpC82AOgh3f8PSwVtJseeTSk
         lTj5BlTqF7yR7868Tr5PstMpsCz6ceUVZ3itoC4IXIlyJgAoMRW6cC+HviduV8WUsmqj
         Y/Xw==
X-Gm-Message-State: AOAM530fxvY3Pq/fS5pug7OdulUZO29p2LCHrl/rQyMJGjVZfYrIB1b1
        XZUw+t0w0yZgYKnJgpNRQ5etfA==
X-Google-Smtp-Source: ABdhPJyAHLVBC4VmVfk/H47m2iMI9lVeLmXc0y2wiUNxH9/Gk0GyS0VJBRQXpDiqed+L5MQnYDyDIg==
X-Received: by 2002:adf:de83:: with SMTP id w3mr3860087wrl.342.1629378745700;
        Thu, 19 Aug 2021 06:12:25 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2el0lv6sxxeorz8a81-pd01.res.v6.highway.a1.net. [2001:871:23a:b9:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id d4sm3087088wrc.34.2021.08.19.06.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:12:25 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 1/3] net: phy: Support set_loopback override
Date:   Thu, 19 Aug 2021 15:11:52 +0200
Message-Id: <20210819131154.6586-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210819131154.6586-1-gerhard@engleder-embedded.com>
References: <20210819131154.6586-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phy_read_status and various other PHY functions support PHY specific
overriding of driver functions by using a PHY specific pointer to the
PHY driver. Add support of PHY specific override to phy_loopback too.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/phy/phy_device.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 107aa6d7bc6b..ba5ad86ec826 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1821,11 +1821,10 @@ EXPORT_SYMBOL(phy_resume);
 
 int phy_loopback(struct phy_device *phydev, bool enable)
 {
-	struct phy_driver *phydrv = to_phy_driver(phydev->mdio.dev.driver);
 	int ret = 0;
 
-	if (!phydrv)
-		return -ENODEV;
+	if (!phydev->drv)
+		return -EIO;
 
 	mutex_lock(&phydev->lock);
 
@@ -1839,8 +1838,8 @@ int phy_loopback(struct phy_device *phydev, bool enable)
 		goto out;
 	}
 
-	if (phydrv->set_loopback)
-		ret = phydrv->set_loopback(phydev, enable);
+	if (phydev->drv->set_loopback)
+		ret = phydev->drv->set_loopback(phydev, enable);
 	else
 		ret = genphy_loopback(phydev, enable);
 
-- 
2.20.1

