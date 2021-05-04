Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CB5373270
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhEDWbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbhEDWaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:46 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C0DC06174A;
        Tue,  4 May 2021 15:29:49 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id b25so15588003eju.5;
        Tue, 04 May 2021 15:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lxVgYY/ynXCAEKAsuKTSHi68DPLsSQLz31l13nMArY4=;
        b=RftIqtnKyj1zeXOQzz94oDymxoT2D67j52QHkvENbI59SbXQdvZqgXYMuxC7MLcZi3
         f60z3mAZgekwZFQGY1D8Ag2ZO7a2gWl3CtOmxIcmsRPTt1UNYj6OcIE3LW2vF2j/XdPS
         fn2y2tLW9Bt3w69ksgNvLwCI0k1sQ1mOUvtVxcV51dQp7eSUKL/aqyHnqCmd6itA0jja
         0VjkTOxya6/asVe908+RGuTR3PvYX1hZchPHAiGpr2pQYOfdcf9Xr035XLcO6fGn9M9I
         WCzVtfS+E8Vqt3+5U2vWK/D9+FkTExx2wfsZ++CpYCdKp96PWw/6aavIsZjS19hCax4Z
         V2/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lxVgYY/ynXCAEKAsuKTSHi68DPLsSQLz31l13nMArY4=;
        b=lZL0SusEnSyvT4pTgvI+ajas1uU/Ulyy2l2osPqpQ/PNv3wzM6dNmNvCq1UVUqWsAv
         GDVw6v5ceaPC5UY6wubQlL1z1X997I0HHlPoXsvHRYnkbdRSOWzXwXsYJEc7W/n1J2Sw
         XltDHBTLUaccL80f0KAw0gAAIPHPQ0+romGuLIZ/CAFc1hZekw+McdmaQNi8jqkkM56n
         5c/6tsNpKKXvk2nYtlQCFqJelS6EjnMdvTqGxW0TzHNy1yifi6dNg9RYoe3nBDwTt6sg
         y+8zmSjNnZlzptwlpusRmOZjqGsOFpwn8qXUK8kL40BpnneQDcu1pshAKd58JgBi12tM
         NzYA==
X-Gm-Message-State: AOAM531kIOJP/XuZijTtDCeVZxrR2kLEXZn3ifBJcsqvXp39MBuGhG6R
        6/vnGhfZAoJlmaAoCgknvGw=
X-Google-Smtp-Source: ABdhPJzkz4TxC9K99xCe1dxHaz8/cJdSLxPynx6ys5RKHZt8sxfP4Aj8lIeIjivusO3SHhqUZ0Tr9w==
X-Received: by 2002:a17:906:4d11:: with SMTP id r17mr24134842eju.217.1620167388511;
        Tue, 04 May 2021 15:29:48 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:48 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 14/20] net: dsa: qca8k: clear MASTER_EN after phy read/write
Date:   Wed,  5 May 2021 00:29:08 +0200
Message-Id: <20210504222915.17206-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear MDIO_MASTER_EN bit from MDIO_MASTER_CTRL after read/write
operation. The MDIO_MASTER_EN bit is not reset after read/write
operation and the next operation can be wrongly interpreted by the
switch as a mdio operation. This cause a production of wrong/garbage
data from the switch and underfined bheavior. (random port drop,
unplugged port flagged with link up, wrong port speed)
Also on driver remove the MASTER_CTRL can be left set and cause the
malfunction of any next driver using the mdio device.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index cb9b44769e92..b21835d719b5 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -655,8 +655,14 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 	if (ret)
 		return ret;
 
-	return qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-		QCA8K_MDIO_MASTER_BUSY);
+	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+			      QCA8K_MDIO_MASTER_BUSY);
+
+	/* even if the busy_wait timeouts try to clear the MASTER_EN */
+	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+			QCA8K_MDIO_MASTER_EN);
+
+	return ret;
 }
 
 static int
@@ -690,6 +696,10 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 
 	val &= QCA8K_MDIO_MASTER_DATA_MASK;
 
+	/* even if the busy_wait timeouts try to clear the MASTER_EN */
+	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+			QCA8K_MDIO_MASTER_EN);
+
 	return val;
 }
 
-- 
2.30.2

