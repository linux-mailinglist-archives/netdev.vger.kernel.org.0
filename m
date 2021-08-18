Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81713F03B9
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbhHRMa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236690AbhHRMaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 08:30:21 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EBBC0613A3
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:29:43 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id u16so3259879wrn.5
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M5wvJU9nS0PBB383gj3PbquvMXX21vpI+F/H85bw73U=;
        b=x2aEwTrMuhsjoEDCymOGwiImM5i8Ny+fc9dfU/2HMZCqSTPjd8svCc0dXh1FYreWEf
         ywRk7OWnUIHaw5+YnzsPMT/pqjyKEWORBvX60vm+jT/aTjjOO4g4S116D89ZTaB04l+p
         46+PAkAfe0mayC9N9F0vVoX9NGEcPVlCzUio2YSCaYqQshHQ65q0qSnamhZqk394j2AZ
         SnsZragb7q9zK0yuzc/hv/ZvMfNHB1NTgwb5VAU4mg9AfsyvBqRdaeINLpXm/iduZhDK
         QjAxyf/ZtmTBUm2+32+HFmYIKOq1UtRriT9EurJ/Yk0wyCIt8aS5+iqroQSbPZmAyKyA
         1eNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M5wvJU9nS0PBB383gj3PbquvMXX21vpI+F/H85bw73U=;
        b=pbN18radS5gXsJFGacS+TUHezGCFJyHlpVQHPbvZbQfzTM/A/gmhG9myhz+B5iKnpc
         2GKPknxxZUB+h1GLKZYQKtO06Mh9OL69dMzPKOyH6ZNNjHP8NhSJBrtwA+1WZ48zP/3r
         otLeiG2lQmaKCCigmwcv2rp4f9o30xnSuDVAHOPHcBv0brYwSgJfIRcXQ77G4xux6P7A
         2pkHxYK4cTJRQ4i9/PUoURbWXWRqawdkeOJvN086bXvKySYmAo1M+KZcXT4J3bnDXIDS
         ymTmMfjKrz6Tf7PH22PHsy305jQHY9PM7yI1tB6W5/fr1gkod3cQtAsAGUmG9vtb2hvn
         YVcg==
X-Gm-Message-State: AOAM530THvvDfr+9+Jz9d8QkuUXiWpZwha46sCKvHckD+ob+wJj/h0Ye
        nvHxIN6vU8ZvAGzH6zytSBW2NQ==
X-Google-Smtp-Source: ABdhPJwx3R40DJstcMGFSXmn7/8lPUj4y/dpGByViPuuXdJRuRP+qdKmFNqCmk8xzMXi8h0OpWOsYw==
X-Received: by 2002:adf:f741:: with SMTP id z1mr10236267wrp.201.1629289782643;
        Wed, 18 Aug 2021 05:29:42 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2el0lv6sxxeorz8a81-pd01.res.v6.highway.a1.net. [2001:871:23a:b9:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id u16sm5554869wmc.41.2021.08.18.05.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 05:29:42 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 1/2] net: phy: Support set_loopback override
Date:   Wed, 18 Aug 2021 14:27:35 +0200
Message-Id: <20210818122736.4877-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210818122736.4877-1-gerhard@engleder-embedded.com>
References: <20210818122736.4877-1-gerhard@engleder-embedded.com>
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

