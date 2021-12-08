Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C9B46CBA9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244056AbhLHDoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244014AbhLHDo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:44:29 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27986C0617A1;
        Tue,  7 Dec 2021 19:40:58 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id n33-20020a05600c502100b0032fb900951eso3206128wmr.4;
        Tue, 07 Dec 2021 19:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5p3JSCDmSQwA01X2xabGRAhwCYyaHTODwNc6SWiiXvs=;
        b=M26a9foyPlU9pSANLKcDRL6FAT7doTiK6UQs7ILLO2LYkyH7neeYBgEqjAlwHKUHUH
         POgnQKsOtcsVJRXLynB954CfhN9jbj9pdWpdoKOKsf2lDEJ62+xUU+3XU2LRp4cW4s/4
         i1SJgXyegDUqAvoLZUlV5NxGiSuIfun8SZ+IZD+e/2Y+oZqINc2ysHoZMELGpfonR9m2
         LqPEwt5nSkv51OjWT/YEvTaOUZAJzbT9sYLGoEDBTytklFIusMcBzWlAf7r8y56Wxb9U
         xxTS/av8NLYYVHBe1hWmptUxRv1HVIZJdFoCOMZOkiMCx3iXmrRVVb+PLM+Dr+VEViCE
         aHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5p3JSCDmSQwA01X2xabGRAhwCYyaHTODwNc6SWiiXvs=;
        b=RPrPPgjv0F32gA0Mwo/Pp7enWAthp/LUy3CxiSaaXGqPB9XyN5mNIYyhdMirFazsjM
         r9WdmgTuqSan/VySb0dxx1er48s5eDRfaVAnc4dK4MXjudzo5CIFXDevSof3PJ5tJvg/
         bVr0up4r+PKyQ3LF8l1fJh12sPdAFc7p9EO+zXhPnUuPiha3luIkH7qvA78LsNHqYE7m
         XB6DZ9wPSxX0xvehIGd5ZzGALYVD4R+LyIe9W+DZrkJtuYQjA8JxQ3OSRPe5zj7S5Qzl
         QA6rMR2wogJpp+9stQoX+uFuUYzNPivOA8+6t8Qw3dGLw22Eyk4Ocl6e/WQtNK291amS
         ekWA==
X-Gm-Message-State: AOAM530V3vkPnk99VO6thXf/TPGsW6eFTJjks6PQ4Za23XRmApfpQA1E
        0Xdn96xqLRQXKw4we0l5XdE=
X-Google-Smtp-Source: ABdhPJzDs+oPVn1rDjhcDiZaGxFL1bJAqP+lkCQ7jBJSlJTdnVUM8ti4UA8ZgFbqmyp5nsV0g2dK6g==
X-Received: by 2002:a05:600c:4e53:: with SMTP id e19mr11838162wmq.63.1638934856626;
        Tue, 07 Dec 2021 19:40:56 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v6sm4488944wmh.8.2021.12.07.19.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 19:40:56 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v2 8/8] net: dsa: qca8k: cache lo and hi for mdio write
Date:   Wed,  8 Dec 2021 04:40:40 +0100
Message-Id: <20211208034040.14457-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211208034040.14457-1-ansuelsmth@gmail.com>
References: <20211208034040.14457-1-ansuelsmth@gmail.com>
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
index 5b7508a6e4ba..6f4a99032cdd 100644
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

