Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DB2327F93
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 14:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbhCANdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235814AbhCANd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 08:33:29 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C12AC061788
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 05:32:49 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id e7so25535873lft.2
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 05:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cYZerRT2x1qlGnIcE8x6N2LpmT6kXCgWE2D5TP/WfCs=;
        b=wKzXFcDLjNyyRoslx3XcGuzfeszZwxSUcGtgTwhw+Y3Hp51/yhR3A4MGHWVgreAN1x
         hqUmNnCKT0MzuDnHrMC2sqDuere+4CpfTK30Zh9q3+YBF4hbk8WRE6AfH+ulCqd+/ozb
         IyIruRdLbFzaSSbSdHLXUvLm3RZfSdFWdRt3MwBk8GUsSX/YsN/vOJac3U5nBkkbcmWF
         PU6Ut6S+XWdx80tyfDhbi32War2XktED/mAnE/SQC0oAwLI9ey/c87+JWcaOu+MBDF1P
         os2EfNbn1k8m2rEyM8mxtZ9I9Z+xilAWMTg6dPcbiiHg5bA9yVaWIDMW3YEwOrIcXZan
         pTxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cYZerRT2x1qlGnIcE8x6N2LpmT6kXCgWE2D5TP/WfCs=;
        b=QiOZ6AC8x3BGarY7QKEAz8QuMGQ7c3Y1RV6feSRUiNK6LATIdJRV5Rc875rl8Hq/XM
         O5b/eqFcnlSqoNPY3ggPFlOqQCd1uYrUQ7Efcc9i9EH7BZSfMnfgic2SvueVNVXqjie3
         KUu20KhTmmDmckU2Ur8bzxwPrIKyCkoGrB3qTERp8VwrHKU9MnTIFrSKH2+sIBULjHg4
         dZ6Whc1z+MhnTreniXjMvQAgHm8PU3HMIEna3ClpcQub/W2ShERIF5csR/F+BD3i/UO/
         QOgMvNq4bzhS6wiXjUmgjHsKLgXHPRP5Me8GDRy82I8O6TaqxL552Ccmchn7rkvYBcQg
         riBA==
X-Gm-Message-State: AOAM5320+pwStEPr84/OhFPg9wG4SHktfO/+8P1kFv6x0vb9Sg7s9yL2
        LzE9zwyBsyBrAW9aLRLNafbC2Q==
X-Google-Smtp-Source: ABdhPJzMORv9w8mlPRk+LNWq8NeIXXQP2/52SsAyKTL6Wqrcjlnlu0ez3dLFrZtpnyQTDyvo9KSG3w==
X-Received: by 2002:a19:7d06:: with SMTP id y6mr9808950lfc.644.1614605567969;
        Mon, 01 Mar 2021 05:32:47 -0800 (PST)
Received: from localhost.localdomain (c-d7cb225c.014-348-6c756e10.bbcust.telenor.se. [92.34.203.215])
        by smtp.gmail.com with ESMTPSA id c9sm2310066lft.144.2021.03.01.05.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 05:32:47 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [PATCH net 2/3] net: dsa: rtl4_a: Drop skb_cow_head()
Date:   Mon,  1 Mar 2021 14:32:40 +0100
Message-Id: <20210301133241.1277164-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301133241.1277164-1-linus.walleij@linaro.org>
References: <20210301133241.1277164-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA core already provides the tag headroom, drop this.

Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Reported-by: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 net/dsa/tag_rtl4_a.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 804d756dd80a..8098d81f660b 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -42,8 +42,6 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 	/* Pad out to at least 60 bytes */
 	if (__skb_put_padto(skb, ETH_ZLEN, false))
 		return NULL;
-	if (skb_cow_head(skb, RTL4_A_HDR_LEN) < 0)
-		return NULL;
 
 	netdev_dbg(dev, "add realtek tag to package to port %d\n",
 		   dp->index);
-- 
2.29.2

