Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BEA31D330
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 01:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhBPX4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 18:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhBPX4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 18:56:31 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ABCC061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 15:55:50 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id m22so18742749lfg.5
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 15:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bcr+x1VYiyXQXUMLbA7sP56ZbmQSWDencNP9CkrSaao=;
        b=odYfQRZI6Xu842YV+3GA7yKf4c2sZmorncRrMJ0ifENacnZyVbpo2VJ9mi/5FGvCOj
         1/wNeTlnl1p4mo+8/+vSpSCSgsFL1lFg8Ts5mfTh0AS3WeotfsycMuzkkKKxmoURoaC6
         L5VT51PVyOovlHzVb/dCkRiQfuDD3sSetLXhkKRvDuQNKlDkKxpXfy2Bzqg1LHfOQx7v
         Lpggd85bjPx9Bi69tHQL+NfW7YPbBjW/fqfoATaW/Lt9y7Uh8MSjP+vFo7tnECyuDEbL
         HhG/sk6j8O6HmOCaeohWXIwAhWWc/+mcmGEA4KRd0/bcjmfVTjBEr53e35j6Y4TkDXp2
         2Zxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bcr+x1VYiyXQXUMLbA7sP56ZbmQSWDencNP9CkrSaao=;
        b=rO4xbpLm06AIrU1Zv9HarEYgCnf52spXhk0ET2g1tX5ijDIRU06gsfscyCGXcdocoA
         2VokYczRYLNoGVeiKalRaFJcIf6qqPaQvX7qXZCmKECVs2pguxME8A65VMMVsKaB4nFD
         aAqVBUnZ6/Y5RdJaYdsdN5vNgPbWibDckh/6/lhecCcfINy8mF9xONTOuSQBZVPjCOPi
         ZvP7EzIm9AcJST9h8tlxq5i70o2bpI0p9cMJIqoGQL1RmzRfXOstRQ2Bov/uiVIfpWLZ
         G5LafNVqgi7mvlKRRyqm0ztYWL4XQY/uFLbODhpF5hQO5ICdamc+n4/mxspiy16VU48i
         S/vQ==
X-Gm-Message-State: AOAM532Y30BGEH/JGJr5a63C5orEEUXUbjcdoPYtR20gb6y0NH2SLNMq
        K7QJ8bMB8WVaiucJ9CsIzpRsnw==
X-Google-Smtp-Source: ABdhPJwhOeQZzVWDDBsIrO2zpJMWIFlbQ9UnEXSXqkaX9k/KAxPPcb6enWj/qsFH5JUPapzRf34ZiQ==
X-Received: by 2002:a05:6512:22c2:: with SMTP id g2mr13575203lfu.634.1613519749382;
        Tue, 16 Feb 2021 15:55:49 -0800 (PST)
Received: from localhost.localdomain (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id g6sm56203lfc.40.2021.02.16.15.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 15:55:49 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH] net: dsa: tag_rtl4_a: Support also egress tags
Date:   Wed, 17 Feb 2021 00:55:42 +0100
Message-Id: <20210216235542.2718128-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support also transmitting frames using the custom "8899 A"
4 byte tag.

Qingfang came up with the solution: we need to pad the
ethernet frame to 60 bytes using eth_skb_pad(), then the
switch will happily accept frames with custom tags.

Cc: Mauri Sandberg <sandberg@mailfence.com>
Reported-by: DENG Qingfang <dqfext@gmail.com>
Fixes: efd7fe68f0c6 ("net: dsa: tag_rtl4_a: Implement Realtek 4 byte A tag")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 net/dsa/tag_rtl4_a.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 2646abe5a69e..c17d39b4a1a0 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -12,9 +12,7 @@
  *
  * The 2 bytes tag form a 16 bit big endian word. The exact
  * meaning has been guessed from packet dumps from ingress
- * frames, as no working egress traffic has been available
- * we do not know the format of the egress tags or if they
- * are even supported.
+ * frames.
  */
 
 #include <linux/etherdevice.h>
@@ -36,17 +34,34 @@
 static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
-	/*
-	 * Just let it pass thru, we don't know if it is possible
-	 * to tag a frame with the 0x8899 ethertype and direct it
-	 * to a specific port, all attempts at reverse-engineering have
-	 * ended up with the frames getting dropped.
-	 *
-	 * The VLAN set-up needs to restrict the frames to the right port.
-	 *
-	 * If you have documentation on the tagging format for RTL8366RB
-	 * (tag type A) then please contribute.
-	 */
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u8 *tag;
+	u16 *p;
+	u16 out;
+
+	/* Pad out to at least 60 bytes */
+	if (unlikely(eth_skb_pad(skb)))
+		return NULL;
+	if (skb_cow_head(skb, RTL4_A_HDR_LEN) < 0)
+		return NULL;
+
+	netdev_dbg(dev, "add realtek tag to package to port %d\n",
+		   dp->index);
+	skb_push(skb, RTL4_A_HDR_LEN);
+
+	memmove(skb->data, skb->data + RTL4_A_HDR_LEN, 2 * ETH_ALEN);
+	tag = skb->data + 2 * ETH_ALEN;
+
+	/* Set Ethertype */
+	p = (u16 *)tag;
+	*p = htons(RTL4_A_ETHERTYPE);
+
+	out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
+	/* The lower bits is the port numer */
+	out |= (u8)dp->index;
+	p = (u16 *)(tag + 2);
+	*p = htons(out);
+
 	return skb;
 }
 
-- 
2.29.2

