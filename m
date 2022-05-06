Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEF251DC28
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443021AbiEFPfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379239AbiEFPfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:35:14 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC576EC50
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:31:04 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v10so6374010pgl.11
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 08:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ajs8Qst8iYNToP8OwD94MfSLvH2ZbhrQ/Qlzg71j/1Q=;
        b=dnXo6r8sEYyMpPfqcoZyl5kc+1Yaq+49FpD5qcI/kHnt8tkht5T5129RxUYfrQ9flM
         vLp77CX9u43iGghOFfpUAOdZr/u2hd+UaDolgYZlfQlA3NLoztOdNaHiw+e+6hBA3y3q
         ByIeyUs3uciapvuRkZoJQXwLuKEC3PEbuvZy1Vb0IF2jPp/9uoW6x+YrCCCxC3EBzfYe
         jGu+/mNox5WAS9Bztov5a+3fBzfO50wAvMe6NJ8CXLvZ0+8l659Uoo1AFHQBbrtY/fSF
         vpBUxb0iMqA31svcrF2kd/efoQ9MxyF9Fus1xuxeir9O0z6e+hg8g7cN9n0NbgPe89lJ
         cTgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ajs8Qst8iYNToP8OwD94MfSLvH2ZbhrQ/Qlzg71j/1Q=;
        b=4ogThgzqnNgfI1ydIKAj5Ktm69fxNUYXyYxxRGtR+4OU3ZXpMLbKi2OwczZsZfHK3i
         tFqSvOnKmfhBqyueyHN4liFDdaw3rRUhYTn3o/hOhFudqRJcmjO82Zgbgqo4P3F/4vpC
         N5k430AsxrCXfYstpCCX5qjzN2e6wK3Wxo24g5NVyXXsWc9LVMA/WNNQDBXTJP5YXthG
         YzRiAZg89w3+St3AtoDFrW7/l6AwKSeDIIPnhzgP15ygyruKp5ypF0u6jbjfO6WyLI91
         xA6yyUYFeaINLXEyEvYvFqrmXr/vEebZ6a7yVZeV1iEm90JIUA73+L2c7T1GO785eJiL
         gslg==
X-Gm-Message-State: AOAM531eVmZ/1/0aBxUvxFKtQ88Dx7dL7aHch9RomAW+/6rys0m0aJCG
        SaQiWQMcWKL6DRbOfDc7zVQ=
X-Google-Smtp-Source: ABdhPJzEQGfUwekktQmxzWdJzUUrKLe5aGNP6Ig97x26SXXYLd7llK8HpVsnQGDRBRGXsa9db8LT8Q==
X-Received: by 2002:a65:6794:0:b0:3c1:922b:2b1e with SMTP id e20-20020a656794000000b003c1922b2b1emr3225027pgr.370.1651851063806;
        Fri, 06 May 2022 08:31:03 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:709e:d3d8:321b:df52])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902d70400b0015e8d4eb1bfsm1918612ply.9.2022.05.06.08.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:31:03 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 02/12] ipv6: add IFLA_GSO_IPV6_MAX_SIZE
Date:   Fri,  6 May 2022 08:30:38 -0700
Message-Id: <20220506153048.3695721-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220506153048.3695721-1-eric.dumazet@gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
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

This enables ipv6/TCP stacks to build TSO packets bigger than
64KB if the driver is LSOv2 compatible.

This patch introduces new variable gso_ipv6_max_size
that is modifiable through ip link.

ip link set dev eth0 gso_ipv6_max_size 185000

User input is capped by driver limit (tso_max_size)

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h          |  2 ++
 include/uapi/linux/if_link.h       |  1 +
 net/core/dev.c                     |  2 ++
 net/core/rtnetlink.c               | 23 +++++++++++++++++++++++
 net/core/sock.c                    |  8 ++++++++
 tools/include/uapi/linux/if_link.h |  1 +
 6 files changed, 37 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8cf0ac616cb9b7279e643cf6630f42c807742244..47f413dac12e901700045f4b73d47ecdca0f4f3c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1917,6 +1917,7 @@ enum netdev_ml_priv_type {
  *	@rtnl_link_ops:	Rtnl_link_ops
  *
  *	@gso_max_size:	Maximum size of generic segmentation offload
+ *	@gso_ipv6_max_size:	Maximum size of IPv6 GSO packets (user/admin limit)
  *	@tso_max_size:	Device (as in HW) limit on the max TSO request size
  *	@gso_max_segs:	Maximum number of segments that can be passed to the
  *			NIC for GSO
@@ -2264,6 +2265,7 @@ struct net_device {
 	/* for setting kernel sock attribute on TCP connection setup */
 #define GSO_MAX_SIZE		65536
 	unsigned int		gso_max_size;
+	unsigned int		gso_ipv6_max_size;
 #define TSO_LEGACY_MAX_SIZE	65536
 #define TSO_MAX_SIZE		UINT_MAX
 	unsigned int		tso_max_size;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5f58dcfe2787f308bb2aa5777cca0816dd32bbb9..aa05fc9cc23f4ccf92f4cbba57f43472749cd42a 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -370,6 +370,7 @@ enum {
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_MAX_SIZE,
 	IFLA_TSO_MAX_SEGS,
+	IFLA_GSO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index f036ccb61da4da3ffc52c4f2402427054b831e8a..aa8757215b2a9f14683f95086732668eb99a875b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10607,6 +10607,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gro_max_size = GRO_MAX_SIZE;
 	dev->tso_max_size = TSO_LEGACY_MAX_SIZE;
 	dev->tso_max_segs = TSO_MAX_SEGS;
+	dev->gso_ipv6_max_size = GSO_MAX_SIZE;
+
 	dev->upper_level = 1;
 	dev->lower_level = 1;
 #ifdef CONFIG_LOCKDEP
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 512ed661204e0c66c8dcfaddc3001500d10f63ab..847cf80f81754451e5f220f846db734a7625695b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1066,6 +1066,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_GRO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_TSO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_TSO_MAX_SEGS */
+	       + nla_total_size(4) /* IFLA_GSO_IPV6_MAX_SIZE */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
 	       + nla_total_size(1) /* IFLA_LINKMODE */
 	       + nla_total_size(4) /* IFLA_CARRIER_CHANGES */
@@ -1773,6 +1774,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
 	    nla_put_u32(skb, IFLA_TSO_MAX_SIZE, dev->tso_max_size) ||
 	    nla_put_u32(skb, IFLA_TSO_MAX_SEGS, dev->tso_max_segs) ||
+	    nla_put_u32(skb, IFLA_GSO_IPV6_MAX_SIZE, dev->gso_ipv6_max_size) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
@@ -1928,6 +1930,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_GRO_MAX_SIZE]	= { .type = NLA_U32 },
 	[IFLA_TSO_MAX_SIZE]	= { .type = NLA_REJECT },
 	[IFLA_TSO_MAX_SEGS]	= { .type = NLA_REJECT },
+	[IFLA_GSO_IPV6_MAX_SIZE] = { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2644,6 +2647,14 @@ static int do_set_proto_down(struct net_device *dev,
 	return 0;
 }
 
+static void netif_set_gso_ipv6_max_size(struct net_device *dev,
+					unsigned int size)
+{
+	size = min(size, dev->tso_max_size);
+	/* Paired with READ_ONCE() in sk_setup_caps() */
+	WRITE_ONCE(dev->gso_ipv6_max_size, size);
+}
+
 #define DO_SETLINK_MODIFIED	0x01
 /* notify flag means notify + modified. */
 #define DO_SETLINK_NOTIFY	0x03
@@ -2820,6 +2831,15 @@ static int do_setlink(const struct sk_buff *skb,
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
 
@@ -3283,6 +3303,9 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 		netif_set_gso_max_segs(dev, nla_get_u32(tb[IFLA_GSO_MAX_SEGS]));
 	if (tb[IFLA_GRO_MAX_SIZE])
 		netif_set_gro_max_size(dev, nla_get_u32(tb[IFLA_GRO_MAX_SIZE]));
+	if (tb[IFLA_GSO_IPV6_MAX_SIZE])
+		netif_set_gso_ipv6_max_size(dev,
+			nla_get_u32(tb[IFLA_GSO_IPV6_MAX_SIZE]));
 
 	return dev;
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index 6b287eb5427b32865d25fc22122fefeff3a4ccf5..4a29c3bf6b95f76280d8e32e903a0916322d5c4f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2312,6 +2312,14 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
 			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
+#if IS_ENABLED(CONFIG_IPV6)
+			if (sk->sk_family == AF_INET6 &&
+			    sk_is_tcp(sk) &&
+			    !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr)) {
+				/* Paired with WRITE_ONCE() in netif_set_gso_ipv6_max_size() */
+				sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_ipv6_max_size);
+			}
+#endif
 			sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
 			max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index b339bf2196ca160ed3040615ae624b9a028562fb..443eddd285f37198566fa1357f0d394ec5270ab9 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -350,6 +350,7 @@ enum {
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_MAX_SIZE,
 	IFLA_TSO_MAX_SEGS,
+	IFLA_GSO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
-- 
2.36.0.512.ge40c2bad7a-goog

