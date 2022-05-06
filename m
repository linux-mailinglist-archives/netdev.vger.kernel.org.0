Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A0C51DC2F
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443013AbiEFPfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443142AbiEFPfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:35:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6AB6D96C
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:31:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p6so7334972pjm.1
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 08:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0zLeWpNxSFVZ8VibuyqKCuhzPs7ZM+V0HJsd6yRZBis=;
        b=VXu/SBMOgWC+Q3nuCXeqJPC8ZUuRhS6bBm7L1XYYv0xAiBLrDAzXjwsAHXFcfXXbKZ
         a4Bm3Uz8AYvI1vVSbcR8JFZYrIopRdK7G6OoR0tla1aTg+Ws90kRnwGyfrXy+GbpX27L
         WNYxm6HrLRu2TqQj57RR2wbxCJ2difZ0ef+I6jsGE/R9YTsxikphVdiHfNBqVxlmG7ei
         hATt4b60zaY4AQe2BJqhRFzKhpTKVdQIEk75Kknf/3FoeKDYp0sjChaJ7izanbpbTjDd
         dc9P20lADu0eOND6ozYhazlJU1A6lB6MHST1/m0gpIlEgovO910HjsoeRxBC/9ntozrV
         8NxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0zLeWpNxSFVZ8VibuyqKCuhzPs7ZM+V0HJsd6yRZBis=;
        b=4TpB7i4hb9OQpajeTU2HNlLLPWxLGWtMm8ZBta9YrcmCb2dnBMhKTdFT65cYcE7EVr
         UNtn07Azg8E0h4Aa8JQXH7vfzt/JcS0hqDh5s0MrPflCsShRw68ZyOAuGn3zWtHCdfjv
         zPTD1x5upLHj1DjM9po/6Xm8C6e8bKmuhr+Cu/0TDzmWV/LYGL3TR/jsykrTNg3B3MVA
         NOUXfV+Fc1i0H76lRMguO8QLjb0UAk29NhKC04RzeGeVLs80/QNcdnm43ZqxUDRL2f9Q
         FgRAMoDa4CyjRvqX70ymNOuyuiQoCy5pD9N1lmM8nsJ/kA3Jt0zR1OeQU/avsg3baD67
         bvxA==
X-Gm-Message-State: AOAM532rBPI80SX4a3n7BMPNvWSndycZQjjMC3p9jIV1tgtqMcd44l4b
        5dWMiSrtlyaikq6LTE/qdfg=
X-Google-Smtp-Source: ABdhPJzgV1HsN0APRqM7wCXBFeBvZz625Dq1X0mMfzjGeusoga/TL8Uv8E9QvjcQPgHneSvaQhOgMA==
X-Received: by 2002:a17:90b:17c5:b0:1dc:e0a6:340b with SMTP id me5-20020a17090b17c500b001dce0a6340bmr2823580pjb.34.1651851076018;
        Fri, 06 May 2022 08:31:16 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:709e:d3d8:321b:df52])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902d70400b0015e8d4eb1bfsm1918612ply.9.2022.05.06.08.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:31:15 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 07/12] ipv6: add IFLA_GRO_IPV6_MAX_SIZE
Date:   Fri,  6 May 2022 08:30:43 -0700
Message-Id: <20220506153048.3695721-8-eric.dumazet@gmail.com>
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

Enable GRO to have IPv6 specific limit for max packet size.

This patch introduces new dev->gro_ipv6_max_size
that is modifiable through ip link.

ip link set dev eth0 gro_ipv6_max_size 185000

Note that this value is only considered if bigger than
gro_max_size, and for non encapsulated TCP/ipv6 packets.

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h          |  3 +++
 include/uapi/linux/if_link.h       |  1 +
 net/core/dev.c                     |  1 +
 net/core/gro.c                     | 20 ++++++++++++++++++--
 net/core/rtnetlink.c               | 22 ++++++++++++++++++++++
 tools/include/uapi/linux/if_link.h |  1 +
 6 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 47f413dac12e901700045f4b73d47ecdca0f4f3c..df12c9843d94cb847e0ce5ba1b3b36bde7d476ed 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1962,6 +1962,8 @@ enum netdev_ml_priv_type {
  *			keep a list of interfaces to be deleted.
  *	@gro_max_size:	Maximum size of aggregated packet in generic
  *			receive offload (GRO)
+ *	@gro_ipv6_max_size:	Maximum size of aggregated packet in generic
+ *				receive offload (GRO), for IPv6
  *
  *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
  *	@linkwatch_dev_tracker:	refcount tracker used by linkwatch.
@@ -2154,6 +2156,7 @@ struct net_device {
 	int			napi_defer_hard_irqs;
 #define GRO_MAX_SIZE		65536
 	unsigned int		gro_max_size;
+	unsigned int		gro_ipv6_max_size;
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index aa05fc9cc23f4ccf92f4cbba57f43472749cd42a..9ece3a391105c171057cc491c1458ee8a45e07e0 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -371,6 +371,7 @@ enum {
 	IFLA_TSO_MAX_SIZE,
 	IFLA_TSO_MAX_SEGS,
 	IFLA_GSO_IPV6_MAX_SIZE,
+	IFLA_GRO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index aa8757215b2a9f14683f95086732668eb99a875b..582b7fe052a6fb06437f95bd6a451b79e188cc57 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10608,6 +10608,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->tso_max_size = TSO_LEGACY_MAX_SIZE;
 	dev->tso_max_segs = TSO_MAX_SEGS;
 	dev->gso_ipv6_max_size = GSO_MAX_SIZE;
+	dev->gro_ipv6_max_size = GRO_MAX_SIZE;
 
 	dev->upper_level = 1;
 	dev->lower_level = 1;
diff --git a/net/core/gro.c b/net/core/gro.c
index 78110edf5d4b36d2fa6f8a2676096efe0112aa0e..8b35403dd7e909a8d7df591d952a4600c13f360b 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -161,11 +161,27 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
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
index 847cf80f81754451e5f220f846db734a7625695b..5fa3ff835aaf6601c31458ec88e88837d353eabd 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1067,6 +1067,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_TSO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_TSO_MAX_SEGS */
 	       + nla_total_size(4) /* IFLA_GSO_IPV6_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_GRO_IPV6_MAX_SIZE */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
 	       + nla_total_size(1) /* IFLA_LINKMODE */
 	       + nla_total_size(4) /* IFLA_CARRIER_CHANGES */
@@ -1775,6 +1776,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_TSO_MAX_SIZE, dev->tso_max_size) ||
 	    nla_put_u32(skb, IFLA_TSO_MAX_SEGS, dev->tso_max_segs) ||
 	    nla_put_u32(skb, IFLA_GSO_IPV6_MAX_SIZE, dev->gso_ipv6_max_size) ||
+	    nla_put_u32(skb, IFLA_GRO_IPV6_MAX_SIZE, dev->gro_ipv6_max_size) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
@@ -1931,6 +1933,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_TSO_MAX_SIZE]	= { .type = NLA_REJECT },
 	[IFLA_TSO_MAX_SEGS]	= { .type = NLA_REJECT },
 	[IFLA_GSO_IPV6_MAX_SIZE] = { .type = NLA_U32 },
+	[IFLA_GRO_IPV6_MAX_SIZE] = { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2655,6 +2658,13 @@ static void netif_set_gso_ipv6_max_size(struct net_device *dev,
 	WRITE_ONCE(dev->gso_ipv6_max_size, size);
 }
 
+static void netif_set_gro_ipv6_max_size(struct net_device *dev,
+					unsigned int size)
+{
+	/* This pairs with the READ_ONCE() in skb_gro_receive() */
+	WRITE_ONCE(dev->gro_ipv6_max_size, size);
+}
+
 #define DO_SETLINK_MODIFIED	0x01
 /* notify flag means notify + modified. */
 #define DO_SETLINK_NOTIFY	0x03
@@ -2840,6 +2850,15 @@ static int do_setlink(const struct sk_buff *skb,
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
 
@@ -3306,6 +3325,9 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 	if (tb[IFLA_GSO_IPV6_MAX_SIZE])
 		netif_set_gso_ipv6_max_size(dev,
 			nla_get_u32(tb[IFLA_GSO_IPV6_MAX_SIZE]));
+	if (tb[IFLA_GRO_IPV6_MAX_SIZE])
+		netif_set_gro_ipv6_max_size(dev,
+			nla_get_u32(tb[IFLA_GRO_IPV6_MAX_SIZE]));
 
 	return dev;
 }
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 443eddd285f37198566fa1357f0d394ec5270ab9..5aead1be6b99623fb6ffd31cfcfd44976eb8794f 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -351,6 +351,7 @@ enum {
 	IFLA_TSO_MAX_SIZE,
 	IFLA_TSO_MAX_SEGS,
 	IFLA_GSO_IPV6_MAX_SIZE,
+	IFLA_GRO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
-- 
2.36.0.512.ge40c2bad7a-goog

