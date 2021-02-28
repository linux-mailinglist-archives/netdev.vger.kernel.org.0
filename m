Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8963F327384
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 18:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhB1RJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 12:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhB1RJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 12:09:14 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB527C06174A;
        Sun, 28 Feb 2021 09:08:33 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id ba1so8439361plb.1;
        Sun, 28 Feb 2021 09:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=osyQIcHVCpcYbu1W9iKZ+MzBcxRi6zP7gbMYCSLyvno=;
        b=j3xKITYB9amBpL93LI6xM0nXUn/vDzJzYoLc2NDgt8z0ttHmY3PPisHmaYSxmtcgPY
         sMTSC+9YZPmrpCMNPbpaDHO1bCP17uPLx3jq/Xte+G15pTM+g1IZcedceAIODG3h3zJH
         0X0+vZkt7109c66U9SFgvuNldUPPNi3i6Yp0REotIkov2UeCjsKCIXKyhO/yMjPz0MkI
         EWW+umpgPJ4JkG4WWYI3CKmoiPYnug2LOLtSGOs1JW0MX8ga75/sTu/vBTrzj0XJux8U
         agzhCX5b9f+gdPL1LYvpswLAWp2B9vFYNvYH25gvOmAoSl6atLOtOKO4qKZILKEtZxlN
         NhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=osyQIcHVCpcYbu1W9iKZ+MzBcxRi6zP7gbMYCSLyvno=;
        b=N1BZu8sQsXHCfRG5LDgm3Cy7KryHKtoyQoMwzNIaq+EphEmnFTpbwIW/w6hkavhHnD
         vVugWnx0A+foY6k4DNREszRXWCmnVenwiLrl6NBMxWjSDUHNC+5n5aZxYMr9hPmICNyM
         lSADDldm+IhhxpncVISoAaf7cg1aDQ7VStFFlU6yn2VpJ3dMK7Szdwuq+aZh/Qkm26Q+
         /KFia0WYx5nKp9JF00zJOquNu4BO8V7ySE7veMMW0Cd9XKkgiNdEgNaCVMlX4T00eSvL
         h6bQPFbuc5J0T3IZnKI7x6tD23KoSFFwrgDm1aGR6iVuKGy2PiaDbFJgBeLzjUbLy25+
         QBcA==
X-Gm-Message-State: AOAM532uuASYcGfMC8XcanDYWVLRTjKm6DZSIdVVoOe5hDqUeDbLSAd0
        tULlGKSzGoFC0diLzSKCgAg=
X-Google-Smtp-Source: ABdhPJyiA0UBvRnRnLo6OsrUSwl+rfkwuSURg0R8Wia+X0d+m7LC83S0MPIX5Z35a5N5tNOqgysyYQ==
X-Received: by 2002:a17:902:d202:b029:e4:55cd:dde8 with SMTP id t2-20020a170902d202b02900e455cddde8mr11801528ply.51.1614532113408;
        Sun, 28 Feb 2021 09:08:33 -0800 (PST)
Received: from container-ubuntu.lan ([171.211.28.221])
        by smtp.gmail.com with ESMTPSA id d27sm15163352pfq.40.2021.02.28.09.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 09:08:32 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net] net: dsa: tag_rtl4_a: fix egress tags
Date:   Mon,  1 Mar 2021 01:08:23 +0800
Message-Id: <20210228170823.1488-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 86dd9868b878 has several issues, but was accepted too soon
before anyone could take a look.

- Double free. dsa_slave_xmit() will free the skb if the xmit function
  returns NULL, but the skb is already freed by eth_skb_pad(). Use
  __skb_put_padto() to avoid that.
- Unnecessary allocation. It has been done by DSA core since commit
  a3b0b6479700.
- A u16 pointer points to skb data. It should be __be16 for network
  byte order.
- Typo in comments. "numer" -> "number".

Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 net/dsa/tag_rtl4_a.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index c17d39b4a1a0..e9176475bac8 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -35,14 +35,12 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	__be16 *p;
 	u8 *tag;
-	u16 *p;
 	u16 out;
 
 	/* Pad out to at least 60 bytes */
-	if (unlikely(eth_skb_pad(skb)))
-		return NULL;
-	if (skb_cow_head(skb, RTL4_A_HDR_LEN) < 0)
+	if (unlikely(__skb_put_padto(skb, ETH_ZLEN, false)))
 		return NULL;
 
 	netdev_dbg(dev, "add realtek tag to package to port %d\n",
@@ -53,13 +51,13 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 	tag = skb->data + 2 * ETH_ALEN;
 
 	/* Set Ethertype */
-	p = (u16 *)tag;
+	p = (__be16 *)tag;
 	*p = htons(RTL4_A_ETHERTYPE);
 
 	out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
-	/* The lower bits is the port numer */
+	/* The lower bits is the port number */
 	out |= (u8)dp->index;
-	p = (u16 *)(tag + 2);
+	p = (__be16 *)(tag + 2);
 	*p = htons(out);
 
 	return skb;
-- 
2.25.1

