Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B969A47DD8E
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbhLWB41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhLWB41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:56:27 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30414C061574;
        Wed, 22 Dec 2021 17:56:27 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id j13so3171853plx.4;
        Wed, 22 Dec 2021 17:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id;
        bh=6/lYC6jmgRWtJWFtROKbYosrocMx4yrCwz+Be6br3pk=;
        b=fcQTdy+XduCGYANQrmjEK9roBXQq5f9UaiNfeFWGJ9cOlX4sxnvpdNg9D+34O67uWk
         Lcndg93VgiZXCCRoXH7Wj7vvCCvqng1Xxc4qELeN2SLjDHmXU2uO7aqdxyZNoimVBH7n
         iZPeQkwi0a7NU9QZ8X8Z9pGMULu3NYS2tIOpm4X8Ksx52SX48XvR5EIklBZGgnAc+QTc
         jAjWUdFrXHAPLtHZkkRUdrOp/4tmik+bSy3MnckYkqEVjbccjIuxr3Uhvb+8iGBiolSS
         IFIjDjymdTEih2H6Rfmt3SCfH3BRGTfa29a811MTgjoSb7Iz36mTGyKsD+OY67xVIwm3
         FeXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=6/lYC6jmgRWtJWFtROKbYosrocMx4yrCwz+Be6br3pk=;
        b=au53odYopWmaUKqyJ6ALYX2Ti+oHaWGn4pP7JvGEOKq+7CVrorymsQB1dGiD8k3M1u
         f9i78WVOxjuDGuCVSMRt2GxcRBHP1TI6qnLk3MCE7HH+jWnZjIj1YoLwGvMGG0Mosy0g
         FBe6dY1/73o/tqSspUosAnr6PxtrNXC3VL+9yQ25G+qVanvAy/0H9BKTiPxH70Zo8WAf
         oztW7P+d93YX5Af3aHSkveB07mblkwLnfC8YSnmwom1hlfMPj/J5kx78EQqIMUw+F4JX
         MIQ0tDeBwpa6+TwvxamVx8w3FkgA3RWkQvpvERHfFfAlUOLXUut8KFOhkoUdGe3Hvx4A
         WYyg==
X-Gm-Message-State: AOAM531+84J5UJDche99A3JYbTSuLOEQmSdd/2piglSAzqVbTcI/qhk4
        JgmjjkiXb4mdA/Du8+QVcGw=
X-Google-Smtp-Source: ABdhPJzCyzBDOqfrZdE70A7C/VVGN+2tZCyMHZSCaFgIg0CJ/3AKAUHVnYgBf8zV0yXx0R/Q1e0idw==
X-Received: by 2002:a17:902:8689:b0:148:e8ac:cbaf with SMTP id g9-20020a170902868900b00148e8accbafmr258889plo.86.1640224586662;
        Wed, 22 Dec 2021 17:56:26 -0800 (PST)
Received: from bj03382pcu.spreadtrum.com ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id m67sm3686337pfb.36.2021.12.22.17.56.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Dec 2021 17:56:26 -0800 (PST)
From:   Huangzhaoyang <huangzhaoyang@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: remove judgement based on gfp_flags
Date:   Thu, 23 Dec 2021 09:56:07 +0800
Message-Id: <1640224567-3014-1-git-send-email-huangzhaoyang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

The parameter allocation here is used for indicating if the memory
allocation can stall or not. Since we have got the skb buffer, it
doesn't make sense to check if we can yield on the net's congested
via gfp_flags. Remove it now.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4c57532..af5b6af 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1526,7 +1526,7 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
 	consume_skb(info.skb2);
 
 	if (info.delivered) {
-		if (info.congested && gfpflags_allow_blocking(allocation))
+		if (info.congested)
 			yield();
 		return 0;
 	}
-- 
1.9.1

