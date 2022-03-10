Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F12D4D40DE
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239629AbiCJFsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239632AbiCJFsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:13 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9199E12D925
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:12 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 132so3850037pga.5
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aZb7kcMo/qp1+g9aKTO8DmohalD7S1ZpngVnhiOiWtk=;
        b=JOjQlztX3idGGkodHMDu04IHRY2OqJTqjcWGoZouWZvUO6Zs5Cq4Yi/F3rJNioEi9J
         nMklkSCeU2HpqHg6JcltV61bOLaTCt/F62IIdDylEH0+f4Cm+Wh73AIZVjVAFCLgnW3W
         2+B/RlW0e441GjGUr0lU/LdGHRt9R1ptMLY8Qygg5HRRcI54+rT7STbFmaH6X662KL8x
         rCJXrKCLN7ICvPownXllgNhT+DncAm3ilGacLsCrPrcAQskmds9t8lL/1/mX6tVkhBD6
         YZSGvJzE9BqXXcTR3HIonJekODD5hR8dN0qdcTDwhxqCCb2IaoUx7k4dWeBxQtiXD/bB
         Rc6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aZb7kcMo/qp1+g9aKTO8DmohalD7S1ZpngVnhiOiWtk=;
        b=AkXZO2MGazij185weFlZ7P+otcPVCMHnToMwPBlhp8TnX1tX+WPYtURLRKK+thnVR9
         xuZ1eCTUmY3ckLNJJiFKLz3IpcuHZJZ0dq0waX5/CBQCljpK5F4oITc+e08jJuAWMEMj
         xYkA3o44D553P8NOPkupQGTREWwcOr+gUdyWm+dI9vgNK9Xq9upNG2Nc5ACAfsCgxwRs
         Haiwi7bLrE+xGl51gEA2xi5sYkMItXmXWwdOQBcrwMLYr6KE4hM7EKwZk6yev2TITzBM
         NLA69cGB9gvU6EkZTFrFrV1BRx86o2rDFYktX0Kjd04GSEDW+QUaXVmKcGry9joFZ5Zv
         1PIQ==
X-Gm-Message-State: AOAM531i08haOmMvf6B/CyXGb/Lvn23C1glAfnsJ7ndSiV69onYGlIHJ
        1jsUlJ83w1Wpp7LZS393MpQ=
X-Google-Smtp-Source: ABdhPJx7fhYR0jNbSBIXelC9rqIAD0zTwPtBj9GJomz4+wXFi68+DKqjDlqT9e3l3qh3tDamEolMAw==
X-Received: by 2002:a63:5024:0:b0:380:83f7:1603 with SMTP id e36-20020a635024000000b0038083f71603mr2640061pgb.289.1646891232049;
        Wed, 09 Mar 2022 21:47:12 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:11 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 02/14] ipv6: add dev->gso_ipv6_max_size
Date:   Wed,  9 Mar 2022 21:46:51 -0800
Message-Id: <20220310054703.849899-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310054703.849899-1-eric.dumazet@gmail.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coco Li <lixiaoyan@google.com>

This enable TCP stack to build TSO packets bigger than
64KB if the driver is LSOv2 compatible.

This patch introduces new variable gso_ipv6_max_size
that is modifiable through ip link.

ip link set dev eth0 gso_ipv6_max_size 185000

User input is capped by driver limit (tso_ipv6_max_size)
added in previous patch.

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h          | 12 ++++++++++++
 include/uapi/linux/if_link.h       |  1 +
 net/core/dev.c                     |  1 +
 net/core/rtnetlink.c               | 15 +++++++++++++++
 net/core/sock.c                    |  6 ++++++
 tools/include/uapi/linux/if_link.h |  1 +
 6 files changed, 36 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 61db67222c47664c179b6a5d3b6f15fdf8a02bdd..9ed348d8b6f1195514c3b5f85fbe2c45b3fa997f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1952,6 +1952,7 @@ enum netdev_ml_priv_type {
  *					registered
  *	@offload_xstats_l3:	L3 HW stats for this netdevice.
  *	@tso_ipv6_max_size:	Maximum size of IPv6 TSO packets (driver/NIC limit)
+ *	@gso_ipv6_max_size:	Maximum size of IPv6 GSO packets (user/admin limit)
  *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
@@ -2291,6 +2292,7 @@ struct net_device {
 	netdevice_tracker	dev_registered_tracker;
 	struct rtnl_hw_stats64	*offload_xstats_l3;
 	unsigned int		tso_ipv6_max_size;
+	unsigned int		gso_ipv6_max_size;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -4874,6 +4876,10 @@ static inline void netif_set_gso_max_size(struct net_device *dev,
 {
 	/* dev->gso_max_size is read locklessly from sk_setup_caps() */
 	WRITE_ONCE(dev->gso_max_size, size);
+
+	/* legacy drivers want to lower gso_max_size, regardless of family. */
+	size = min(size, dev->gso_ipv6_max_size);
+	WRITE_ONCE(dev->gso_ipv6_max_size, size);
 }
 
 static inline void netif_set_gso_max_segs(struct net_device *dev,
@@ -4897,6 +4903,12 @@ static inline void netif_set_tso_ipv6_max_size(struct net_device *dev,
 	dev->tso_ipv6_max_size = size;
 }
 
+static inline void netif_set_gso_ipv6_max_size(struct net_device *dev,
+					       unsigned int size)
+{
+	size = min(size, dev->tso_ipv6_max_size);
+	WRITE_ONCE(dev->gso_ipv6_max_size, size);
+}
 
 static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
 					int pulled_hlen, u16 mac_offset,
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index c8af031b692e52690a2760e9d79c9462185e2fc9..048a9c848a3a39596b6c3135553fdfb9a1fe37d2 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -364,6 +364,7 @@ enum {
 	IFLA_PARENT_DEV_BUS_NAME,
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_IPV6_MAX_SIZE,
+	IFLA_GSO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index de28f634c18a65d1948a96db5678d38e9c871b1f..87f8b8cb39a61c8f5a444e3b341a97ba0a4c06d9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10468,6 +10468,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->gro_max_size = GRO_MAX_SIZE;
 	dev->tso_ipv6_max_size = GSO_MAX_SIZE;
+	dev->gso_ipv6_max_size = GSO_MAX_SIZE;
 
 	dev->upper_level = 1;
 	dev->lower_level = 1;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ab51b18cdb5d46b87d4a11d2f66a68968ba737d6..172de404c595c89e30651a091242a75be8f786b7 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1028,6 +1028,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_GRO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_TSO_IPV6_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_GSO_IPV6_MAX_SIZE */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
 	       + nla_total_size(1) /* IFLA_LINKMODE */
 	       + nla_total_size(4) /* IFLA_CARRIER_CHANGES */
@@ -1734,6 +1735,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
 	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
 	    nla_put_u32(skb, IFLA_TSO_IPV6_MAX_SIZE, dev->tso_ipv6_max_size) ||
+	    nla_put_u32(skb, IFLA_GSO_IPV6_MAX_SIZE, dev->gso_ipv6_max_size) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
@@ -1888,6 +1890,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
 	[IFLA_GRO_MAX_SIZE]	= { .type = NLA_U32 },
 	[IFLA_TSO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_GSO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2774,6 +2777,15 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 	}
 
+	if (tb[IFLA_GSO_IPV6_MAX_SIZE]) {
+		u32 max_size = nla_get_u32(tb[IFLA_GSO_IPV6_MAX_SIZE]);
+
+		if (dev->gso_ipv6_max_size ^ max_size) {
+			netif_set_gso_ipv6_max_size(dev, max_size);
+			status |= DO_SETLINK_MODIFIED;
+		}
+	}
+
 	if (tb[IFLA_GSO_MAX_SEGS]) {
 		u32 max_segs = nla_get_u32(tb[IFLA_GSO_MAX_SEGS]);
 
@@ -3249,6 +3261,9 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 		netif_set_gso_max_segs(dev, nla_get_u32(tb[IFLA_GSO_MAX_SEGS]));
 	if (tb[IFLA_GRO_MAX_SIZE])
 		netif_set_gro_max_size(dev, nla_get_u32(tb[IFLA_GRO_MAX_SIZE]));
+	if (tb[IFLA_GSO_IPV6_MAX_SIZE])
+		netif_set_gso_ipv6_max_size(dev,
+			nla_get_u32(tb[IFLA_GSO_IPV6_MAX_SIZE]));
 
 	return dev;
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index 1180a0cb01104561befa1f96deb71f36efcf12da..e0858e82bc386eb2779a0d6af6063b2078e6ea7b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2279,6 +2279,12 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
 			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
+#if IS_ENABLED(CONFIG_IPV6)
+			if (sk->sk_family == AF_INET6 &&
+			    sk_is_tcp(sk) &&
+			    !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr))
+				sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_ipv6_max_size);
+#endif
 			sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
 			max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 441615c39f0a24eeeb6e27b4ca88031bcc234cf8..e40cd575607872d3bff3bc1971df8c6426290562 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -349,6 +349,7 @@ enum {
 	IFLA_PARENT_DEV_BUS_NAME,
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_IPV6_MAX_SIZE,
+	IFLA_GSO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
-- 
2.35.1.616.g0bdcbb4464-goog

