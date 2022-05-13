Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79919526968
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383351AbiEMSel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383344AbiEMSe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:34:29 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B6F606CA
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:27 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id x23so8386886pff.9
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h111Jd0fEsyaNuBuwM5vMR/EcLnLT4J1EKVy63Lmq3U=;
        b=TBQXzkLLmP0KQ+PwH/FziIFnHsRyySXIPQZLjqTJsEdWyhEWh/jbexA5bfB0P/y6zk
         VXTuoryAPC2huVTapHYBEbH9jJySh/YeZYP62t53ZbYPioRdyGNETgn6qcLDmaEM44vF
         sx7O9ROVn2/ipUQ/+m8THDGVvBUKPO4cAuq1Qq2iOktVpVfa7XIfapgSmChyMw865fje
         rW71A1w1JuiJb+kDRn3c5ABjESZyQRMgXOz3wlgu/XxJUzd9U6jtr1Wgl/Pc9iEUHvAS
         PuJrMPmfbc6Limn1sjGxbC8BUiM1QGANqZQjJGzUxd/PrDNiRSwUlebKy2Nw+WgVP7t2
         chlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h111Jd0fEsyaNuBuwM5vMR/EcLnLT4J1EKVy63Lmq3U=;
        b=Z9chJwuP0SiKDZM7mdRIimtg1fhed395BM9trbc7d0OigcJq7Z7y/lCKWcFMi7mGYg
         psVizEsFIQz3z6SNz8kKs0AeTHHcmez+Sep8WysAmgHm637fNH5Z6ikVuYCaUIoSlmZF
         wKs31aV/M3NmCdqNn1na7pFLfxJrQbdeMTDJ+ZvIOkttofzhGC5OOeaq4uN89LyRbDvR
         usQaMpFkFtbsJN4i9sSrc/mjWWAsMgOCLclKxW1FN45Uy8mz6335vg1ku5zc2V3lsmwT
         34WVXpCymopFjo+99MqYZIEGG8PvM9pQ7DxRy9di0GjpCxDps4/0GSxjRZGBxEmVAPU8
         8GCQ==
X-Gm-Message-State: AOAM5335EIps3JqSXhP8FdzQJn74RMo75Dz6mkklmI6A5zKeRMeD6x1m
        gyI3vKQvVXaQde1vEJ17Fkc=
X-Google-Smtp-Source: ABdhPJzay2qRvo9EBPOk+xgVJT6IauHwSFVeNVz8B8sDHSVyVk+KjnV7wCZa7244LaRmxtzuvDXORQ==
X-Received: by 2002:a65:690d:0:b0:3c6:4106:8795 with SMTP id s13-20020a65690d000000b003c641068795mr5027856pgq.12.1652466866870;
        Fri, 13 May 2022 11:34:26 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7842d000000b0050dc76281cesm2053566pfn.168.2022.05.13.11.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:34:26 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v7 net-next 08/13] net: allow gro_max_size to exceed 65536
Date:   Fri, 13 May 2022 11:34:03 -0700
Message-Id: <20220513183408.686447-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513183408.686447-1-eric.dumazet@gmail.com>
References: <20220513183408.686447-1-eric.dumazet@gmail.com>
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

From: Alexander Duyck <alexanderduyck@fb.com>

Allow the gro_max_size to exceed a value larger than 65536.

There weren't really any external limitations that prevented this other
than the fact that IPv4 only supports a 16 bit length field. Since we have
the option of adding a hop-by-hop header for IPv6 we can allow IPv6 to
exceed this value and for IPv4 and non-TCP flows we can cap things at 65536
via a constant rather than relying on gro_max_size.

[edumazet] limit GRO_MAX_SIZE to (8 * 65535) to avoid overflows.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 include/linux/netdevice.h                       | 6 +++++-
 include/net/ipv6.h                              | 2 +-
 net/core/dev.c                                  | 2 +-
 net/core/gro.c                                  | 8 ++++++++
 net/core/rtnetlink.c                            | 8 --------
 6 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 838870bc6dbd6e3a3d8c9443ff4675a0e411006b..24de37b79f5a917b304c011fcebcd09748ee5c6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2038,7 +2038,7 @@ mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb, u16 data_bcnt)
 {
 	int nr_frags = skb_shinfo(skb)->nr_frags;
 
-	return PAGE_SIZE * nr_frags + data_bcnt <= GRO_MAX_SIZE;
+	return PAGE_SIZE * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
 }
 
 static void
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fd38847d0dc7e2c985646ac427d0131995e9c827..d57ce248004ca32d8a3e984e31ec40c7a7b9f51d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2161,7 +2161,11 @@ struct net_device {
 	struct bpf_prog __rcu	*xdp_prog;
 	unsigned long		gro_flush_timeout;
 	int			napi_defer_hard_irqs;
-#define GRO_MAX_SIZE		65536
+#define GRO_LEGACY_MAX_SIZE	65536u
+/* TCP minimal MSS is 8 (TCP_MIN_GSO_SIZE),
+ * and shinfo->gso_segs is a 16bit field.
+ */
+#define GRO_MAX_SIZE		(8 * 65535u)
 	unsigned int		gro_max_size;
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index b6df0314aa02dd1c4094620145ccb24da7195b2b..5b38bf1a586b9da55f43db30d140d364a70f6c11 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -477,7 +477,7 @@ static inline int ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
 	const struct hop_jumbo_hdr *jhdr;
 	const struct ipv6hdr *nhdr;
 
-	if (likely(skb->len <= GRO_MAX_SIZE))
+	if (likely(skb->len <= GRO_LEGACY_MAX_SIZE))
 		return 0;
 
 	if (skb->protocol != htons(ETH_P_IPV6))
diff --git a/net/core/dev.c b/net/core/dev.c
index 830beb05161a5763957007e5da39f65d506c726c..d93456c75b55c27166cf43cbd1d5d44d950ffc41 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10598,7 +10598,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 
 	dev->gso_max_size = GSO_LEGACY_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
-	dev->gro_max_size = GRO_MAX_SIZE;
+	dev->gro_max_size = GRO_LEGACY_MAX_SIZE;
 	dev->tso_max_size = TSO_LEGACY_MAX_SIZE;
 	dev->tso_max_segs = TSO_MAX_SEGS;
 	dev->upper_level = 1;
diff --git a/net/core/gro.c b/net/core/gro.c
index 78110edf5d4b36d2fa6f8a2676096efe0112aa0e..b4190eb084672fb4f2be8b437eccb4e8507ff63f 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -167,6 +167,14 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	if (unlikely(p->len + len >= gro_max_size || NAPI_GRO_CB(skb)->flush))
 		return -E2BIG;
 
+	if (unlikely(p->len + len >= GRO_LEGACY_MAX_SIZE)) {
+		if (p->protocol != htons(ETH_P_IPV6) ||
+		    skb_headroom(p) < sizeof(struct hop_jumbo_hdr) ||
+		    ipv6_hdr(p)->nexthdr != IPPROTO_TCP ||
+		    p->encapsulation)
+			return -E2BIG;
+	}
+
 	lp = NAPI_GRO_CB(p)->last;
 	pinfo = skb_shinfo(lp);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f2b0f747d3d298897a7f191363bfee632542257b..ac45328607f77af33cf51f85f9918376a9fe8ae0 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2360,14 +2360,6 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[],
 		}
 	}
 
-	if (tb[IFLA_GRO_MAX_SIZE]) {
-		u32 gro_max_size = nla_get_u32(tb[IFLA_GRO_MAX_SIZE]);
-
-		if (gro_max_size > GRO_MAX_SIZE) {
-			NL_SET_ERR_MSG(extack, "too big gro_max_size");
-			return -EINVAL;
-		}
-	}
 	return 0;
 }
 
-- 
2.36.0.550.gb090851708-goog

