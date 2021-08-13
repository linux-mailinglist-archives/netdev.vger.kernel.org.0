Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D007F3EB73F
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241069AbhHMPAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241060AbhHMPAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:00:44 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C996C061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:17 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id w5so18819883ejq.2
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ylXTkKnP8F765h1iV6deSBEGxEMvHyfG/yoaLoV5+ec=;
        b=QbNvZc5kYjk7xyUSgO4WUdkGPWtaOV18CuuE8/GlL2Pmakr+f4u7N8ShZGdrI9ieks
         LZIWgVjFVwLhtAHVR2oAgl9wWNdyxHhOhBRu2jiMgJVdJTgYS+lIPIsIxBMAKfALjNqg
         Ax68bOfjx3fQnKiaz43HoaR8yMmVR8WzceAJsI8YgzhQzOZ84yjW4j/76y2OLAPI22Qs
         uSn/lGHXeXaQN7LEcJz/R741CLARI7vK8M6oDl7ngOWXrRRIoNegRx8vzFvBh1bcjQSn
         YqazStUsLcliEAHgIw10P7bZFnRnTVhmM6c4DYHal5UrbIUfSb36mbUSugEOLvl7i5R9
         EGDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ylXTkKnP8F765h1iV6deSBEGxEMvHyfG/yoaLoV5+ec=;
        b=dnx4AeN4fASnK8WfAYuHkgA7PTQktzXuivJc9J0EJRuCUBZzPqE7xuXRMZmNTZ7Ola
         RzD1RqLD+b9pr5DSgzT9ao+JsVuwdMokm4gaY8Ddu03uFOoR/hVDs47ga4hPbyyXkUB5
         oXj0iP5cWzOQ7u0B0/ChctTjBvKGTvPjrYPESUSP5KIlg4bhqmaUQ8TatwEDLIS3u0Ib
         xUAEDS/BRH4UAd/hbvxIN6TUHkGTb/1SIame14Pyo6ZVqJXOtQJLpK5QcPBHMrRwG78l
         ze9yVzNxRpOEl4mcXokCJOSaagwffNSSpY7R5Lft5WFXKGvG2tew5eegBUNfu/GlpBUi
         fwWw==
X-Gm-Message-State: AOAM533cAjISpJW+KFhoLanbixvdFrEG7p+92zbalJeV79ZL2uDdeoVk
        Vgl4ggD+yw10F56O3Nj48yMqLQ9jo2dw1KKn
X-Google-Smtp-Source: ABdhPJytOmrQdQmVDY/IBScENfnM77up5IuGZN4Mpz4M0PlN2y/GyF8ZmGGyh9JKm2F6A9+2PVO42Q==
X-Received: by 2002:a17:906:72c8:: with SMTP id m8mr2832131ejl.508.1628866813260;
        Fri, 13 Aug 2021 08:00:13 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d26sm1015711edp.90.2021.08.13.08.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 08:00:12 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 5/6] net: bridge: mcast: dump ipv6 querier state
Date:   Fri, 13 Aug 2021 18:00:01 +0300
Message-Id: <20210813150002.673579-6-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813150002.673579-1-razor@blackwall.org>
References: <20210813150002.673579-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for dumping global IPv6 querier state, we dump the state
only if our own querier is enabled or there has been another external
querier which has won the election. For the bridge global state we use
a new attribute IFLA_BR_MCAST_QUERIER_STATE and embed the state inside.
The structure is:
  [IFLA_BR_MCAST_QUERIER_STATE]
   `[BRIDGE_QUERIER_IPV6_ADDRESS] - ip address of the querier
   `[BRIDGE_QUERIER_IPV6_PORT]    - bridge port ifindex where the querier
                                    was seen (set only if external querier)
   `[BRIDGE_QUERIER_IPV6_OTHER_TIMER]   -  other querier timeout

IPv4 and IPv6 attributes are embedded at the same level of
IFLA_BR_MCAST_QUERIER_STATE. If we didn't dump anything we cancel the nest
and return.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  3 +++
 net/bridge/br_multicast.c      | 36 ++++++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index e0fff67fcd88..eceaad200bf6 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -777,6 +777,9 @@ enum {
 	BRIDGE_QUERIER_IP_PORT,
 	BRIDGE_QUERIER_IP_OTHER_TIMER,
 	BRIDGE_QUERIER_PAD,
+	BRIDGE_QUERIER_IPV6_ADDRESS,
+	BRIDGE_QUERIER_IPV6_PORT,
+	BRIDGE_QUERIER_IPV6_OTHER_TIMER,
 	__BRIDGE_QUERIER_MAX
 };
 #define BRIDGE_QUERIER_MAX (__BRIDGE_QUERIER_MAX - 1)
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 4513bc13b6d3..0e5d6ba03457 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2943,15 +2943,15 @@ int br_multicast_dump_querier_state(struct sk_buff *skb,
 	struct net_bridge_port *p;
 	struct nlattr *nest;
 
-	if (!brmctx->multicast_querier &&
-	    !timer_pending(&brmctx->ip4_other_query.timer))
-		return 0;
-
 	nest = nla_nest_start(skb, nest_attr);
 	if (!nest)
 		return -EMSGSIZE;
 
 	rcu_read_lock();
+	if (!brmctx->multicast_querier &&
+	    !timer_pending(&brmctx->ip4_other_query.timer))
+		goto out_v6;
+
 	br_multicast_read_querier(&brmctx->ip4_querier, &querier);
 	if (nla_put_in_addr(skb, BRIDGE_QUERIER_IP_ADDRESS,
 			    querier.addr.src.ip4)) {
@@ -2968,8 +2968,36 @@ int br_multicast_dump_querier_state(struct sk_buff *skb,
 		rcu_read_unlock();
 		goto out_err;
 	}
+
+out_v6:
+#if IS_ENABLED(CONFIG_IPV6)
+	if (!brmctx->multicast_querier &&
+	    !timer_pending(&brmctx->ip6_other_query.timer))
+		goto out;
+
+	br_multicast_read_querier(&brmctx->ip6_querier, &querier);
+	if (nla_put_in6_addr(skb, BRIDGE_QUERIER_IPV6_ADDRESS,
+			     &querier.addr.src.ip6)) {
+		rcu_read_unlock();
+		goto out_err;
+	}
+
+	p = __br_multicast_get_querier_port(brmctx->br, &querier);
+	if (timer_pending(&brmctx->ip6_other_query.timer) &&
+	    (nla_put_u64_64bit(skb, BRIDGE_QUERIER_IPV6_OTHER_TIMER,
+			       br_timer_value(&brmctx->ip6_other_query.timer),
+			       BRIDGE_QUERIER_PAD) ||
+	     (p && nla_put_u32(skb, BRIDGE_QUERIER_IPV6_PORT,
+			       p->dev->ifindex)))) {
+		rcu_read_unlock();
+		goto out_err;
+	}
+out:
+#endif
 	rcu_read_unlock();
 	nla_nest_end(skb, nest);
+	if (!nla_len(nest))
+		nla_nest_cancel(skb, nest);
 
 	return 0;
 
-- 
2.31.1

