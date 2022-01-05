Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBDB485161
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 11:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbiAEKsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 05:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239490AbiAEKsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 05:48:42 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954ECC061792
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 02:48:42 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so5982541pjw.2
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 02:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iFDvxD83TYIzEY7lI5jhrZerzUW1s3pvdqYzsQGaYx0=;
        b=pZRPiUX7F/Idi5v07tMkDGXwjakSPKk4G75g4gnC9hLmdbRi+7obmmVyfS9phKCOJG
         UvtNzLoABvliYVUg+Kv5doEfkCwHsRtd+wr2GAE9Zaf2Ks2mNhBn8x2iUC3wK5d5XeYQ
         4WiRjloOsQZjb5N+qWMgUJbl0mNSIkR/qIh40pqi5srTsn4mYNk10dUd8bZ+rNqeUz2g
         4+TcX16Zkf2DclSCDN3/blMxz3HT7vG2XwMWKUIvYKqbEYc2hBrFiw2dEJ32fHQul0iM
         a2pGs+FLV0S9O9uw2XNuww4iP2ZnUU3BeJFaUu9nk/0VSyY6jTA1kA83N4UB4WFQ8joP
         bB6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iFDvxD83TYIzEY7lI5jhrZerzUW1s3pvdqYzsQGaYx0=;
        b=a+BQ5LqKwktN1McEOINtk8QeSMUUc/opM4ZR7xPDQyrY/ov9tKf9oqoBIEJ+bmOMVN
         o/8qN0p1usXZZrMTl+NK8l1GR0cCoggU1XejlFJmWRMET3YWOC/NoImMiAXzYnIWTAto
         Q9hrL+I/ggbwb/+mFu5LVq2z4N/mhCTw0zwK68k6QGXXSvOK7MT1Rs31Ax/D9n96U+E4
         Tw8+63ZOoZoCkc5TNrjIbQ1ybyGCbiViXpLW7hLX5OH5qtaQCQoZKp2BRGa3wzMf0GyN
         vfkI3nBb+3oZojK/RIEpO+kOhe6g9okZu2IXKByvVOjSlYVc7AdjVnYaFri2PqQisbY3
         MTzQ==
X-Gm-Message-State: AOAM533l+D6aAn+kQylpa/7gzJ6i9J/731J3lO9aRrRFbxaTAo4vOjgx
        EYPl4raOHKe9wenPSlY+xGg=
X-Google-Smtp-Source: ABdhPJzEi6ZNDg/K3RGSjTLGcTmk4GxDF7jaS1HJDWsOk6DlPgvyBARw8bmOdqCGLCywplVy/6i/TQ==
X-Received: by 2002:a17:902:6b03:b0:149:7cf7:a17f with SMTP id o3-20020a1709026b0300b001497cf7a17fmr41376565plk.173.1641379722100;
        Wed, 05 Jan 2022 02:48:42 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:af04:a4cf:7c72:9c40])
        by smtp.gmail.com with ESMTPSA id p16sm39175930pfh.88.2022.01.05.02.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 02:48:41 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Coco Li <lixiaoyan@google.com>
Subject: [PATCH net-next] gro: add ability to control gro max packet size
Date:   Wed,  5 Jan 2022 02:48:38 -0800
Message-Id: <20220105104838.2246803-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coco Li <lixiaoyan@google.com>

Eric Dumazet suggested to allow users to modify max GRO packet size.

We have seen GRO being disabled by users of appliances (such as
wifi access points) because of claimed bufferbloat issues,
or some work arounds in sch_cake, to split GRO/GSO packets.

Instead of disabling GRO completely, one can chose to limit
the maximum packet size of GRO packets, depending on their
latency constraints.

This patch adds a per device gro_max_size attribute
that can be changed with ip link command.

ip link set dev eth0 gro_max_size 16000

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h          | 11 +++++++++++
 include/uapi/linux/if_link.h       |  1 +
 net/core/dev.c                     |  1 +
 net/core/gro.c                     |  6 +++++-
 net/core/rtnetlink.c               | 22 ++++++++++++++++++++++
 tools/include/uapi/linux/if_link.h |  1 +
 6 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6f99c8f51b60a9c76f5bea8cc0b62ad24c97cd78..3213c7227b59bd4f18a57d90c848e415fcd3b253 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1942,6 +1942,8 @@ enum netdev_ml_priv_type {
  *			dev->addr_list_lock.
  *	@unlink_list:	As netif_addr_lock() can be called recursively,
  *			keep a list of interfaces to be deleted.
+ *	@gro_max_size:	Maximum size of aggregated packet in generic
+ *			receive offload (GRO)
  *
  *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
  *	@linkwatch_dev_tracker:	refcount tracker used by linkwatch.
@@ -2131,6 +2133,8 @@ struct net_device {
 	struct bpf_prog __rcu	*xdp_prog;
 	unsigned long		gro_flush_timeout;
 	int			napi_defer_hard_irqs;
+#define GRO_MAX_SIZE		65536
+	unsigned int		gro_max_size;
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
 
@@ -4806,6 +4810,13 @@ static inline void netif_set_gso_max_segs(struct net_device *dev,
 	WRITE_ONCE(dev->gso_max_segs, segs);
 }
 
+static inline void netif_set_gro_max_size(struct net_device *dev,
+					  unsigned int size)
+{
+	/* This pairs with the READ_ONCE() in skb_gro_receive() */
+	WRITE_ONCE(dev->gro_max_size, size);
+}
+
 static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
 					int pulled_hlen, u16 mac_offset,
 					int mac_len)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 4ac53b30b6dc93c31a6a738b3d5a537bc8eb13c3..6218f93f5c1a92b5765bc19dfb9d7583c3b9369b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -347,6 +347,7 @@ enum {
 	 */
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
+	IFLA_GRO_MAX_SIZE,
 
 	__IFLA_MAX
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index 6c8b226b5f2f09e66c665f5dd8fa2fda6c0e6808..83a4089990a0af65364d4e244f60a83c7767cf8b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10180,6 +10180,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 
 	dev->gso_max_size = GSO_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
+	dev->gro_max_size = GRO_MAX_SIZE;
 	dev->upper_level = 1;
 	dev->lower_level = 1;
 #ifdef CONFIG_LOCKDEP
diff --git a/net/core/gro.c b/net/core/gro.c
index 8ec8b44596da9c12adf7b4875e3e1a119ff8e72f..a11b286d149593827f1990fb8d06b0295fa72189 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -132,10 +132,14 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	unsigned int headlen = skb_headlen(skb);
 	unsigned int len = skb_gro_len(skb);
 	unsigned int delta_truesize;
+	unsigned int gro_max_size;
 	unsigned int new_truesize;
 	struct sk_buff *lp;
 
-	if (unlikely(p->len + len >= 65536 || NAPI_GRO_CB(skb)->flush))
+	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
+	gro_max_size = READ_ONCE(p->dev->gro_max_size);
+
+	if (unlikely(p->len + len >= gro_max_size || NAPI_GRO_CB(skb)->flush))
 		return -E2BIG;
 
 	lp = NAPI_GRO_CB(p)->last;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d6eba554b13781ce25769539b91c0ef6282a42f2..e476403231f00053e1a261f31a8760325c75c941 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1026,6 +1026,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_NUM_RX_QUEUES */
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SEGS */
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_GRO_MAX_SIZE */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
 	       + nla_total_size(1) /* IFLA_LINKMODE */
 	       + nla_total_size(4) /* IFLA_CARRIER_CHANGES */
@@ -1728,6 +1729,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_NUM_TX_QUEUES, dev->num_tx_queues) ||
 	    nla_put_u32(skb, IFLA_GSO_MAX_SEGS, dev->gso_max_segs) ||
 	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
+	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
@@ -1880,6 +1882,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
+	[IFLA_GRO_MAX_SIZE]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2299,6 +2302,14 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[],
 		}
 	}
 
+	if (tb[IFLA_GRO_MAX_SIZE]) {
+		u32 gro_max_size = nla_get_u32(tb[IFLA_GRO_MAX_SIZE]);
+
+		if (gro_max_size > GRO_MAX_SIZE) {
+			NL_SET_ERR_MSG(extack, "too big gro_max_size");
+			return -EINVAL;
+		}
+	}
 	return 0;
 }
 
@@ -2772,6 +2783,15 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 	}
 
+	if (tb[IFLA_GRO_MAX_SIZE]) {
+		u32 gro_max_size = nla_get_u32(tb[IFLA_GRO_MAX_SIZE]);
+
+		if (dev->gro_max_size ^ gro_max_size) {
+			netif_set_gro_max_size(dev, gro_max_size);
+			status |= DO_SETLINK_MODIFIED;
+		}
+	}
+
 	if (tb[IFLA_OPERSTATE])
 		set_operstate(dev, nla_get_u8(tb[IFLA_OPERSTATE]));
 
@@ -3222,6 +3242,8 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 		netif_set_gso_max_size(dev, nla_get_u32(tb[IFLA_GSO_MAX_SIZE]));
 	if (tb[IFLA_GSO_MAX_SEGS])
 		netif_set_gso_max_segs(dev, nla_get_u32(tb[IFLA_GSO_MAX_SEGS]));
+	if (tb[IFLA_GRO_MAX_SIZE])
+		netif_set_gro_max_size(dev, nla_get_u32(tb[IFLA_GRO_MAX_SIZE]));
 
 	return dev;
 }
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 4ac53b30b6dc93c31a6a738b3d5a537bc8eb13c3..6218f93f5c1a92b5765bc19dfb9d7583c3b9369b 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -347,6 +347,7 @@ enum {
 	 */
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
+	IFLA_GRO_MAX_SIZE,
 
 	__IFLA_MAX
 };
-- 
2.34.1.448.ga2b2bfdf31-goog

