Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B56381231
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhENVBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhENVBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:31 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD8FC061574;
        Fri, 14 May 2021 14:00:19 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s6so36186edu.10;
        Fri, 14 May 2021 14:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sK60gaKU0JJ3ab7RUURP4mNP0+dSnJ2h4FVnp3sZLXc=;
        b=um/3IbsKe/Wrgc71UoyDsMMwPbxcbsFuu+p+UhgvB3myJD1cTFnxCRdDUtVwio10YE
         ppmjb724xcLScRW2+TayZ4pEcIZo1CH6B37wYGTc3ZnGxL9NcKMVwRP6dXugL7ZFLwU4
         R3FrBJmz0zVEidiLnxIEXE6JvlmqSqz2eZL7IJkdB9xGzWxUVjfVQM4mEBCBzXipETg7
         QVhvkKa1IqRFkrt9yrwg/cshk7psAFoI/QGOeGXZcb3BbhTb6iqki4TieVXcJlkKLbYH
         OBOyaY2ClidIe+vHeN2BWMpR2szPf/nT/eoMGCsDK/0bDHusQ+IHxLLZ0OKu0vznECsK
         8YGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sK60gaKU0JJ3ab7RUURP4mNP0+dSnJ2h4FVnp3sZLXc=;
        b=ZvVr3/2uVHeDf95AZl1deGhTqEsbxzox6VkMkkSA1poQgAKhjJUE7bJ/ZhDtQbXQMx
         BdHa63BNi5qFwB8wp7iqDA2li7Gb1PwRScJJIzxmE4Nq1A769esXGYcu8M1l8iM91yUq
         V1IjHgUZNciXKUqNSbnC25XEArFJCcQ6grzVgD6T3CK/0uIg8f44qa5eNznk8bZZL+4y
         TcG6xd5MuNMeNAj6Ks07Gbz57Grnmxn8lmza94Ra0Ejc94cL214V8+LlUTosrK9ysCMf
         oEKLTs1527GBHDjy8mAvWeIu65pPmbdB9WDKa/LmJGiLRw2XjRywmFSUXXccxfyr3lLw
         NSsQ==
X-Gm-Message-State: AOAM530RPmDqO2emN8vhkqzHFt10UFsXs+25xOzFoqKm57PpsuEW+U3y
        b/FqaDTik/mXtj9wxvmEw4g=
X-Google-Smtp-Source: ABdhPJz9Z2H/GXFT4OFM33cEFRJP/5nB6FDaETomUF2NTZheHoEUMNLbJ5LL98eqTOo2+1KVqUc/Jw==
X-Received: by 2002:a05:6402:48f:: with SMTP id k15mr57502548edv.262.1621026017860;
        Fri, 14 May 2021 14:00:17 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:17 -0700 (PDT)
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
Subject: [PATCH net-next v6 02/25] net: dsa: qca8k: use iopoll macro for qca8k_busy_wait
Date:   Fri, 14 May 2021 22:59:52 +0200
Message-Id: <20210514210015.18142-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use iopoll macro instead of while loop.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 23 +++++++++++------------
 drivers/net/dsa/qca8k.h |  2 ++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 0b295da6c356..25fa7084e820 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -262,21 +262,20 @@ static struct regmap_config qca8k_regmap_config = {
 static int
 qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 {
-	unsigned long timeout;
-
-	timeout = jiffies + msecs_to_jiffies(20);
+	u32 val;
+	int ret;
 
-	/* loop until the busy flag has cleared */
-	do {
-		u32 val = qca8k_read(priv, reg);
-		int busy = val & mask;
+	ret = read_poll_timeout(qca8k_read, val, !(val & mask),
+				0, QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
+				priv, reg);
 
-		if (!busy)
-			break;
-		cond_resched();
-	} while (!time_after_eq(jiffies, timeout));
+	/* Check if qca8k_read has failed for a different reason
+	 * before returning -ETIMEDOUT
+	 */
+	if (ret < 0 && val < 0)
+		return val;
 
-	return time_after_eq(jiffies, timeout);
+	return ret;
 }
 
 static void
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 7ca4b93e0bb5..86c585b7ec4a 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -18,6 +18,8 @@
 #define PHY_ID_QCA8337					0x004dd036
 #define QCA8K_ID_QCA8337				0x13
 
+#define QCA8K_BUSY_WAIT_TIMEOUT				20
+
 #define QCA8K_NUM_FDB_RECORDS				2048
 
 #define QCA8K_CPU_PORT					0
-- 
2.30.2

