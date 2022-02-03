Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36D94A7D8B
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348879AbiBCBvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348884AbiBCBvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:51:53 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A99C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:51:53 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 132so1020928pga.5
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T2yizJYKyp5DKiz2mhLs/cO5uDUOqJNGPWieyte672w=;
        b=oBmv1Mkl2V8VN5I8vEMmsZGTQ13E4zMgGS/gVMDjk1ljjuSlXvwXjrtIESG2wLmTos
         +wCAXJD1ezamJOwiy2/7fwu2oWlOvbWR+gFkt76Aa2N9Nq8se9xn64aw8i8ErRuBgMON
         hzNXMz5vkSjB5nmhnRcdyU6rA2RbJ8MmJUrpnAWBxRwNwPbGJD7RnjSeOoJ3idhFQyje
         js+N2P8UEIt/mpnbZjHzSPgiHlDpscbEBCh1bYK4cf7SYd2ixLYnptj3n5Gjf3W25E89
         Ct8sO4Hh4JVvYqO3oZV/wBXbASTsherWt2yLqxpSDEpuTbx/gcTF8J55kWsJ50wVMRw7
         vmHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T2yizJYKyp5DKiz2mhLs/cO5uDUOqJNGPWieyte672w=;
        b=H8Yz5Fg9gDEzDb/MHl3j2gfViDseP//B7vgTavNskil+mOYFZrh3Dr7kbPnS/3EoZR
         bFvigfdFirnRrsiylti4GIJeCWMmeWCHVySRZPoTeDhk69hSwwzjBJzpr7HkYym6cV0/
         HhF9KUmaX/zWSIH1SX92OMSP7Ns0gpbwjiWYhgz2X9SOqQTSRhI7MCJF+Z3Pns0fD2Ld
         fOa0xA5YWdD7kAFzjDhtrK0yTOyw7pRpyAMCXj03No2L9blFbCqyfYo2nHTXS4VTzoph
         u2KJKBaR9qieBz+5rdifEkrhdOKYdAamcsvs8aE/ql7P5JXJGRfiJ69qH9yZNBo6R4/P
         jW9w==
X-Gm-Message-State: AOAM532CbOcvXdnuaJ1CBufk3O8DD8+WSBPK0FkXyzO9GksT75fami4n
        C1uW4x3s9xHn8oHviQkETKw=
X-Google-Smtp-Source: ABdhPJzAEba67WsGc6WsPNQEdcD6/xf9VYV0MRH2MEdicPZEEOAJP5IcEI0N6IOSoxpnsfA0gijLFw==
X-Received: by 2002:a63:8a44:: with SMTP id y65mr26548928pgd.590.1643853112799;
        Wed, 02 Feb 2022 17:51:52 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:51:52 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 02/15] ipv6: add dev->gso_ipv6_max_size
Date:   Wed,  2 Feb 2022 17:51:27 -0800
Message-Id: <20220203015140.3022854-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This enable TCP stack to build TSO packets bigger than
64KB if the driver is LSOv2 compatible.

This patch introduces new variable gso_ipv6_max_size
that is modifiable through ip link.

ip link set dev eth0 gso_ipv6_max_size 185000

User input is capped by driver limit.

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
index b1f68df2b37bc4b623f61cc2c6f0c02ba2afbe02..2a563869ba44f7d48095d36b1395e3fbd8cfff87 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1949,6 +1949,7 @@ enum netdev_ml_priv_type {
  *	@linkwatch_dev_tracker:	refcount tracker used by linkwatch.
  *	@watchdog_dev_tracker:	refcount tracker used by watchdog.
  *	@tso_ipv6_max_size:	Maximum size of IPv6 TSO packets (driver/NIC limit)
+ *	@gso_ipv6_max_size:	Maximum size of IPv6 GSO packets (user/admin limit)
  *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
@@ -2284,6 +2285,7 @@ struct net_device {
 	netdevice_tracker	linkwatch_dev_tracker;
 	netdevice_tracker	watchdog_dev_tracker;
 	unsigned int		tso_ipv6_max_size;
+	unsigned int		gso_ipv6_max_size;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -4804,6 +4806,10 @@ static inline void netif_set_gso_max_size(struct net_device *dev,
 {
 	/* dev->gso_max_size is read locklessly from sk_setup_caps() */
 	WRITE_ONCE(dev->gso_max_size, size);
+
+	/* legacy drivers want to lower gso_max_size, regardless of family. */
+	size = min(size, dev->gso_ipv6_max_size);
+	WRITE_ONCE(dev->gso_ipv6_max_size, size);
 }
 
 static inline void netif_set_gso_max_segs(struct net_device *dev,
@@ -4827,6 +4833,12 @@ static inline void netif_set_tso_ipv6_max_size(struct net_device *dev,
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
index 79b9d399cd297a1f79dca5ce89762800c38ed4a8..024b3bd0467e1360917001dba6bcfd1f30391894 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -349,6 +349,7 @@ enum {
 	IFLA_PARENT_DEV_BUS_NAME,
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_IPV6_MAX_SIZE,
+	IFLA_GSO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index b6ca3c348d41a097baf210f2a5d966b71308c69b..53c947e6fdb7c47e6cc92fd4e38b71e9b90d921c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10189,6 +10189,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->gro_max_size = GRO_MAX_SIZE;
 	dev->tso_ipv6_max_size = GSO_MAX_SIZE;
+	dev->gso_ipv6_max_size = GSO_MAX_SIZE;
 
 	dev->upper_level = 1;
 	dev->lower_level = 1;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 4cefa07195ba3b67e7b724194b5d729d395ba466..0a0b26261f6d9e4e40bf9cfbda31a29c1f2e3aaa 100644
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
@@ -1732,6 +1733,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
 	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
 	    nla_put_u32(skb, IFLA_TSO_IPV6_MAX_SIZE, dev->tso_ipv6_max_size) ||
+	    nla_put_u32(skb, IFLA_GSO_IPV6_MAX_SIZE, dev->gso_ipv6_max_size) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
@@ -1886,6 +1888,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
 	[IFLA_GRO_MAX_SIZE]	= { .type = NLA_U32 },
 	[IFLA_TSO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_GSO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2772,6 +2775,15 @@ static int do_setlink(const struct sk_buff *skb,
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
 
@@ -3247,6 +3259,9 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 		netif_set_gso_max_segs(dev, nla_get_u32(tb[IFLA_GSO_MAX_SEGS]));
 	if (tb[IFLA_GRO_MAX_SIZE])
 		netif_set_gro_max_size(dev, nla_get_u32(tb[IFLA_GRO_MAX_SIZE]));
+	if (tb[IFLA_GSO_IPV6_MAX_SIZE])
+		netif_set_gso_ipv6_max_size(dev,
+			nla_get_u32(tb[IFLA_GSO_IPV6_MAX_SIZE]));
 
 	return dev;
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index 09d31a7dc68f88af42f75f3f445818fe273b04fb..aec1e156548ea0818f025fd8f448f5e353f79a3b 100644
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
index 79b9d399cd297a1f79dca5ce89762800c38ed4a8..024b3bd0467e1360917001dba6bcfd1f30391894 100644
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
2.35.0.rc2.247.g8bbb082509-goog

