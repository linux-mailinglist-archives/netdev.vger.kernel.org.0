Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D478F38045B
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 09:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbhENHfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 03:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhENHff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 03:35:35 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234C9C061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 00:34:23 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id s6so33603367edu.10
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 00:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7vPAdxndme2/s5OOEhfN75pCl24gxP4zeElGcgMNmVs=;
        b=mPoTD5Mm4OQxvrutiYs4jCRI13j1tFjourNXfAW2SrhcfOZNnNziCOwA3/yIu8yOTD
         JtWhHChVdZaZyglzF1O2dC60RDsgp2lrzKkLaK5OKTojyCOJLFj3jDM9hKbTdZksRLx+
         nvFTF4cZt0qBmWM/mWL/1VFHwpK3wsFDme3X+HNilLclFvLVSbOknP1/zhMVbsNbAGhQ
         NF1qKTtArTQl+3UNOivUUzyAWEaANWqdlHMiNWumU8JlQDcfKosxI3X342FMJ6tV5hyu
         8pIwvYaH3eHXLwVH2N/0qYhRPwkHrmHSLLWg1Tc9mZj+2owdsn4ewhGyZDk0QZPI3OLx
         kXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7vPAdxndme2/s5OOEhfN75pCl24gxP4zeElGcgMNmVs=;
        b=ezkmgdDxyrPvi61qJ5Axn+/ilQwZ9V+IsajD6Fcz4UCB4LLNWnf4+dKB6Ey5XPjl6D
         SMaz3fXd20S5a7PKhID1WHqIq6hdWae4atSm/8ktGNf1VkFfSClTK3NpDNC1TaRb0kXA
         XU9ulwm7WIf+UcTWTVfprkdeYkBgW4YOWPko1h3bMhs0+GLG93DiSsYtQzkEV0/Mcyhj
         yVFYCSBrgZaQOPC2kErJ3hp87cg75yNrsbsc8/Hur8R5Gh6fBl4KtE76nKUl0+vJiSLC
         ue6DCCndRRh9cW5cEg7+8cWLJrH5UYm/eY3gGyHciqkIsgaTA29munAps8rQoRnpG8GR
         ff3w==
X-Gm-Message-State: AOAM531KgC0KZv/YnH3HfRonK/e/fe6FitSqGsGIcE66Ua+b7J/zZ+9l
        ZqydJiM8n7xGkc8hIEJz6iAG1SVTykWjaKcs
X-Google-Smtp-Source: ABdhPJx8dZ4GqxKnUE88nBCiDZyrtZGxT/QsY79SJ2YPXatozUc+UFjuyHZNAE29U1dVpA889p2auA==
X-Received: by 2002:aa7:cd90:: with SMTP id x16mr54395410edv.182.1620977661493;
        Fri, 14 May 2021 00:34:21 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id k26sm3177363eje.67.2021.05.14.00.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 00:34:21 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net, linus.luessing@c0d3.blue,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next] net: bridge: fix br_multicast_is_router stub when igmp is disabled
Date:   Fri, 14 May 2021 10:32:33 +0300
Message-Id: <20210514073233.2564187-1-razor@blackwall.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

br_multicast_is_router takes two arguments when bridge IGMP is enabled
and just one when it's disabled, fix the stub to take two as well.

Fixes: 1a3065a26807 ("net: bridge: mcast: prepare is-router function for mcast router split")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_private.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 53cace4d9487..28f91b111085 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1081,7 +1081,8 @@ static inline void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 {
 }
 
-static inline bool br_multicast_is_router(struct net_bridge *br)
+static inline bool br_multicast_is_router(struct net_bridge *br,
+					  struct sk_buff *skb)
 {
 	return false;
 }
-- 
2.30.2

