Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F728376DAF
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhEHAaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhEHAaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:24 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39827C061761;
        Fri,  7 May 2021 17:29:24 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id o127so6101775wmo.4;
        Fri, 07 May 2021 17:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2QCVXYSj9SYA6gAv2qNpAxSSXr1KuYSPUFWzE5IhrRM=;
        b=B/ZWVHYw5pZcAbi1RwkJgtU7cz+XXiVgcjOGEfJ1Ey3QmI1NI+Zq+yiHUNspTeKWFG
         PmcW60YIPe8sRjrC9gponmLw6jDwdXvbkaHvM144skr58JV1YQL1WTFm85Q841tRttcf
         zvH5QXLh+HNcjWajj34vHLCyVU1wk6IS2ioCoap9m65YfjCs6K5GoCKUBgkd9mfRSErL
         uVwgV+ysLeeJuyy+j9grlGjtUYzUrFJ5+PdrFYr5mT323SJ8rLmuixbSJWFXKJbSuztz
         DPG+nO3o1MzBxucjJbNO43LbGjQYRDgFGqPv4LaTP9S1DBK2cYdMePVS/tfVZh3zXd5b
         i5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2QCVXYSj9SYA6gAv2qNpAxSSXr1KuYSPUFWzE5IhrRM=;
        b=rmxvkdzzgcxKBkBlA1/dQdpfwq3wu1dmoStG+Hz+95g3lvWWahVU4jlfrQBBW7icY9
         BS8yeEOmenNHO6PAgnFwOctDEDmPl3xpB+db99FyFytBjUL558ZVlTjY5/iuI/C3TWTP
         Ud0fVR4C2RnKF959hrh8aJdTgtmGPO8x+K7vBC9CySaivPMRp0//Cw/SQCbr36xe72Il
         vM7IpZ7eSBTS7K7YkcsCDgaHhUUoGiY1ZlSHB1R3Q26OAjf9jY4cQMtC4COrtF9ZTyTN
         56fk6n0LcjvEW+Wy97Xah/Be6c8wpwjzo/NAI6ULLETBUUIom4sWVi7/YMLWZmYts9RJ
         Oe9w==
X-Gm-Message-State: AOAM533pcCX8dkMwtfPJj63pTvQ5+36s+xfKsDyWCqbph4nYqbeD5mAq
        jThrqw7Hl+CLPV1J7R5peAR+oM7/s30wCQ==
X-Google-Smtp-Source: ABdhPJzrxkYUUuAIg33RbQF0Q8mQt4FtY97J1yWc8I1Q17ChZqVVYGZWIpYzjCzjz6IjFQJytHzq8g==
X-Received: by 2002:a1c:f705:: with SMTP id v5mr22465708wmh.69.1620433762899;
        Fri, 07 May 2021 17:29:22 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:22 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 05/28] net: dsa: qca8k: use iopoll macro for qca8k_busy_wait
Date:   Sat,  8 May 2021 02:28:55 +0200
Message-Id: <20210508002920.19945-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use iopoll macro instead of while loop.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 23 +++++++++++------------
 drivers/net/dsa/qca8k.h |  2 ++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 0b295da6c356..0bfb7ae4c128 100644
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
+	 * before returnting -ETIMEDOUT
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

