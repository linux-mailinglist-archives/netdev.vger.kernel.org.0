Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823274A7D8F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348895AbiBCBwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348894AbiBCBwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:52:05 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30370C06173B
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:52:05 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k17so921224plk.0
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SZhGDor8mFHJu+S5dB9PhXYmyk0M0buur4ZjoUX8rio=;
        b=EPqFbcXK7zwp1vCQd00wnv/3q3xPqHekyXMMfM3G3DRSI2zyUkoA6FFv51tNebQ1Cl
         tINJJtyNOopNlRwa0crY9XSRx5B797/Vz8xV3HV77V5kx36KEeo6p+WJwmag8MTBi0VB
         SwQhJTqhwXRC4ajDPsUV7v+Pgi1xZ+wpnCCqoRtZp22WiKUYys9r2W3wg84bQ1PaV9XA
         lE4UmIzbnPRVywrkXcpQcrKgtL1mbV6kPFoWpLZ0ePKdEpoVrHyu0YOIplZ+96RgMr5X
         ck/eywRfkQk4u80StcJ+FZxQVaZo6t1UJc7hJSYDJBRQ8vuDf3RhhsrB/nI8SYVl4+kI
         chOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SZhGDor8mFHJu+S5dB9PhXYmyk0M0buur4ZjoUX8rio=;
        b=E6EQlhcRE5rkMLcDxIJMayPM38IKEVSfYUSBcspY95gqyJQfKWTWgCgoRR7H0ENo2h
         r0Fd1+23bk273y+KcNps0ENlwMxvwrpIa8P0wrgYQT0g+tS9JkqPrXBvw/B8TMIilIlF
         x0cPkzyujthnkRoG2OwbE02etHrARLtiF2ua1Rby8G4vumaVzQnaWwjNQ7aa9AfU9R9H
         iNlLgblcOBAS9GPj/RL0dGteRVbUY7Sjp/dGipIV1KuqeAFOZWFvl9kwldjL210uFHJo
         SwGKMyxriPU7VXlYZicEfA6J0/ctT/e7GwREf+IRdqjlzQa00RjFfxsxMwOI50dkXzwv
         MiSg==
X-Gm-Message-State: AOAM532eF8V6WfjoeETZI5jpqnDGcNzVBOsywIWZeyXoyC1Xr99dR4Cg
        IhcCj5poCijnRcIvcrS4DUxcQPrGHvc=
X-Google-Smtp-Source: ABdhPJwXwmr6BbdO0ZmDDwLY4mahIP2biKAkIcn4kv5xcBwTXhx0iRvg6SL4ufUrCbHQj/vFkbX4gg==
X-Received: by 2002:a17:902:e885:: with SMTP id w5mr33611617plg.155.1643853124684;
        Wed, 02 Feb 2022 17:52:04 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:52:04 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 07/15] ipv6: add GRO_IPV6_MAX_SIZE
Date:   Wed,  2 Feb 2022 17:51:32 -0800
Message-Id: <20220203015140.3022854-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Signed-off-by: Coco Li" <lixiaoyan@google.com>

Enable GRO to have IPv6 specific limit for max packet size.

This patch introduces new dev->gro_ipv6_max_size
that is modifiable through ip link.

ip link set dev eth0 gro_ipv6_max_size 185000

Note that this value is only considered if bigger than
gro_max_size, and for non encapsulated TCP/ipv6 packets.

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h          | 10 ++++++++++
 include/uapi/linux/if_link.h       |  1 +
 net/core/dev.c                     |  1 +
 net/core/gro.c                     | 20 ++++++++++++++++++--
 net/core/rtnetlink.c               | 15 +++++++++++++++
 tools/include/uapi/linux/if_link.h |  1 +
 6 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2a563869ba44f7d48095d36b1395e3fbd8cfff87..a3a61cffd953add6f272a53f551a49a47d200c68 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1944,6 +1944,8 @@ enum netdev_ml_priv_type {
  *			keep a list of interfaces to be deleted.
  *	@gro_max_size:	Maximum size of aggregated packet in generic
  *			receive offload (GRO)
+ *	@gro_ipv6_max_size:	Maximum size of aggregated packet in generic
+ *				receive offload (GRO), for IPv6
  *
  *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
  *	@linkwatch_dev_tracker:	refcount tracker used by linkwatch.
@@ -2137,6 +2139,7 @@ struct net_device {
 	int			napi_defer_hard_irqs;
 #define GRO_MAX_SIZE		65536
 	unsigned int		gro_max_size;
+	unsigned int		gro_ipv6_max_size;
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
 
@@ -4840,6 +4843,13 @@ static inline void netif_set_gso_ipv6_max_size(struct net_device *dev,
 	WRITE_ONCE(dev->gso_ipv6_max_size, size);
 }
 
+static inline void netif_set_gro_ipv6_max_size(struct net_device *dev,
+					       unsigned int size)
+{
+	/* This pairs with the READ_ONCE() in skb_gro_receive() */
+	WRITE_ONCE(dev->gro_ipv6_max_size, size);
+}
+
 static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
 					int pulled_hlen, u16 mac_offset,
 					int mac_len)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 024b3bd0467e1360917001dba6bcfd1f30391894..48fe85bed4a629df0dd7cc0ee3a5139370e2c94d 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -350,6 +350,7 @@ enum {
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_IPV6_MAX_SIZE,
 	IFLA_GSO_IPV6_MAX_SIZE,
+	IFLA_GRO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index 53c947e6fdb7c47e6cc92fd4e38b71e9b90d921c..e7df5c3f53d6e96d01ff06d081cef77d0c6d9d29 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10190,6 +10190,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gro_max_size = GRO_MAX_SIZE;
 	dev->tso_ipv6_max_size = GSO_MAX_SIZE;
 	dev->gso_ipv6_max_size = GSO_MAX_SIZE;
+	dev->gro_ipv6_max_size = GRO_MAX_SIZE;
 
 	dev->upper_level = 1;
 	dev->lower_level = 1;
diff --git a/net/core/gro.c b/net/core/gro.c
index a11b286d149593827f1990fb8d06b0295fa72189..005a05468418f0373264e8019384e2daa13176eb 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -136,11 +136,27 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	unsigned int new_truesize;
 	struct sk_buff *lp;
 
+	if (unlikely(NAPI_GRO_CB(skb)->flush))
+		return -E2BIG;
+
 	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
 	gro_max_size = READ_ONCE(p->dev->gro_max_size);
 
-	if (unlikely(p->len + len >= gro_max_size || NAPI_GRO_CB(skb)->flush))
-		return -E2BIG;
+	if (unlikely(p->len + len >= gro_max_size)) {
+		/* pairs with WRITE_ONCE() in netif_set_gro_ipv6_max_size() */
+		unsigned int gro6_max_size = READ_ONCE(p->dev->gro_ipv6_max_size);
+
+		if (gro6_max_size > gro_max_size &&
+		    p->protocol == htons(ETH_P_IPV6) &&
+		    skb_headroom(p) >= sizeof(struct hop_jumbo_hdr) &&
+		    ipv6_hdr(p)->nexthdr == IPPROTO_TCP &&
+		    !p->encapsulation)
+			gro_max_size = gro6_max_size;
+
+		if (p->len + len >= gro_max_size)
+			return -E2BIG;
+	}
+
 
 	lp = NAPI_GRO_CB(p)->last;
 	pinfo = skb_shinfo(lp);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 0a0b26261f6d9e4e40bf9cfbda31a29c1f2e3aaa..cb552d99682ab8498613f79df9bd6fbaad8c2d59 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1029,6 +1029,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_GRO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_TSO_IPV6_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_GSO_IPV6_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_GRO_IPV6_MAX_SIZE */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
 	       + nla_total_size(1) /* IFLA_LINKMODE */
 	       + nla_total_size(4) /* IFLA_CARRIER_CHANGES */
@@ -1734,6 +1735,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
 	    nla_put_u32(skb, IFLA_TSO_IPV6_MAX_SIZE, dev->tso_ipv6_max_size) ||
 	    nla_put_u32(skb, IFLA_GSO_IPV6_MAX_SIZE, dev->gso_ipv6_max_size) ||
+	    nla_put_u32(skb, IFLA_GRO_IPV6_MAX_SIZE, dev->gro_ipv6_max_size) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
@@ -1889,6 +1891,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_GRO_MAX_SIZE]	= { .type = NLA_U32 },
 	[IFLA_TSO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
 	[IFLA_GSO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_GRO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2784,6 +2787,15 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 	}
 
+	if (tb[IFLA_GRO_IPV6_MAX_SIZE]) {
+		u32 max_size = nla_get_u32(tb[IFLA_GRO_IPV6_MAX_SIZE]);
+
+		if (dev->gro_ipv6_max_size ^ max_size) {
+			netif_set_gro_ipv6_max_size(dev, max_size);
+			status |= DO_SETLINK_MODIFIED;
+		}
+	}
+
 	if (tb[IFLA_GSO_MAX_SEGS]) {
 		u32 max_segs = nla_get_u32(tb[IFLA_GSO_MAX_SEGS]);
 
@@ -3262,6 +3274,9 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 	if (tb[IFLA_GSO_IPV6_MAX_SIZE])
 		netif_set_gso_ipv6_max_size(dev,
 			nla_get_u32(tb[IFLA_GSO_IPV6_MAX_SIZE]));
+	if (tb[IFLA_GRO_IPV6_MAX_SIZE])
+		netif_set_gro_ipv6_max_size(dev,
+			nla_get_u32(tb[IFLA_GRO_IPV6_MAX_SIZE]));
 
 	return dev;
 }
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 024b3bd0467e1360917001dba6bcfd1f30391894..48fe85bed4a629df0dd7cc0ee3a5139370e2c94d 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -350,6 +350,7 @@ enum {
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_IPV6_MAX_SIZE,
 	IFLA_GSO_IPV6_MAX_SIZE,
+	IFLA_GRO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
-- 
2.35.0.rc2.247.g8bbb082509-goog

