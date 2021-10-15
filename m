Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7724E42ED1F
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbhJOJI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbhJOJIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 05:08:55 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52850C061753
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 02:06:49 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id d3so35285698edp.3
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 02:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kAZh9fqmHigo6xRDqgFos5JwAKHqDbj5bkhVwftM1Ys=;
        b=KrAgOqV1v2KxOuW7pkfy/lKylkCadAUoPsHrJ7bpEFwfLuP2zvalxzqIFo4jfEfjc5
         iBdWZ+bk8TJhhjQqzl5lUgOwloB6XEqqxkJ6FVzvCixT1SLpn/CO0t0IBSYWT6FOhaMv
         /gKEplLZbjCdiUi2TusREYcGOkzdYQts62fGIPetDmKc0djiKFRSj95jwnUZLEMabZHO
         OdzuSOb4svHB018Ff/nQjlhq/Cc/xFw1b1p8qF8OJO6aTJY9z4faJRPBsrre/Hb8W2vI
         jVFmX8D4M7htPSCERrDiepcLTAYmSgdiLjV4EcOeRyfyTQ1q6GIZ3IDQGFsLZ1KbE3Ra
         xmyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kAZh9fqmHigo6xRDqgFos5JwAKHqDbj5bkhVwftM1Ys=;
        b=cWQhFn4c6DdfXnGHDR/BVBRVGmdnQuZygPfDz6v+b637UhbEOwrbXkUU5KRGEdjhNd
         2mwzOvYQteHkT946YqRpktyWTqiWNjWXfctlfqGrqXF2IDmUBJMz0kB4Ay8sf5uGm1Dw
         gR4GK+67z+aICHpOqhcpX9wkYyQqDZJbjO+XAJB4AeaeHVW4NTSTOTtqIXsdrCloIRu+
         1e7NN2QlXwJzaN+1PwSNofZ7cuR4u2fLxDcdiEJUApJOdNxyPZquflQsPxFmAI7pO9wU
         mC+vhFSwhMy038L4Z2b5FyZi1e6Ias5LGFxEFU71KnDKRP0PpNQHYgG6bWdCiL/ys7JI
         tsGw==
X-Gm-Message-State: AOAM531LeUVzMoR9q4i5+2k9GuJMvVufUYAU1Dd/0HNjnOzusr9UP2qe
        Zpptm06ELWU1+WoH67RX48EJm04apAQv4BNe
X-Google-Smtp-Source: ABdhPJwwzKlulbjNPJ9dhS1QtKNP/+rvGHzF6kJnLiZ/Ig2orOOXOYfLlqUjw0qeA96Ch3kZF6e4aw==
X-Received: by 2002:a17:906:a1c1:: with SMTP id bx1mr5230787ejb.447.1634288807299;
        Fri, 15 Oct 2021 02:06:47 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id v13sm4695034edl.69.2021.10.15.02.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 02:06:46 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] net: bridge: mcast: use multicast_membership_interval for IGMPv3
Date:   Fri, 15 Oct 2021 12:05:46 +0300
Message-Id: <20211015090546.19967-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <357fad9e-581e-7b71-9b32-aac77d5d13c1@nvidia.com>
References: <357fad9e-581e-7b71-9b32-aac77d5d13c1@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When I added IGMPv3 support I decided to follow the RFC for computing
the GMI dynamically:
" 8.4. Group Membership Interval

   The Group Membership Interval is the amount of time that must pass
   before a multicast router decides there are no more members of a
   group or a particular source on a network.

   This value MUST be ((the Robustness Variable) times (the Query
   Interval)) plus (one Query Response Interval)."

But that actually is inconsistent with how the bridge used to compute it
for IGMPv2, where it was user-configurable that has a correct default value
but it is up to user-space to maintain it. This would make it consistent
with the other timer values which are also maintained correct by the user
instead of being dynamically computed. It also changes back to the previous
user-expected GMI behaviour for IGMPv3 queries which were supported before
IGMPv3 was added. Note that to properly compute it dynamically we would
need to add support for "Robustness Variable" which is currently missing.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Fixes: 0436862e417e ("net: bridge: mcast: support for IGMPv3/MLDv2 ALLOW_NEW_SOURCES report")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_private.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b4cef3a97f12..5c68052466a0 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1125,9 +1125,7 @@ static inline unsigned long br_multicast_lmqt(const struct net_bridge_mcast *brm
 
 static inline unsigned long br_multicast_gmi(const struct net_bridge_mcast *brmctx)
 {
-	/* use the RFC default of 2 for QRV */
-	return 2 * brmctx->multicast_query_interval +
-	       brmctx->multicast_query_response_interval;
+	return brmctx->multicast_membership_interval;
 }
 
 static inline bool
-- 
2.31.1

