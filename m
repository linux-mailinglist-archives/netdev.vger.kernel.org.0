Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B55520790
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiEIW16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbiEIW0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:26:03 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7683F15E601
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:22:08 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id j6so13392047pfe.13
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G6qcLZIvblskoFgEnCuJMCztdD2PGCRP1LhslLrHAEQ=;
        b=X6pImyqtvd4eXWsV51cK8SvIMMiQAoox9+OjBvKGEeTdRSjJcyVO18tmNd02nbcO29
         EEyuGZbcimm+OXq/e9pGNdNSXLHKQZXCPmZu8nh7vM8QAwi+Hp8XLE4hT/5pidkcr7Kd
         s8Y1AYaSlz4HHSf/eomi1y+uFgEpNVlZHrIXAJ3v7muB9CM6q84RxzAsf93xcMYFVjwz
         PCpOh7/hr/fhTF1X9petkH0YDzebKyQkLDC07l5CN+31j1cBHZiGC0OAgIXlaitNDjO7
         bwQCXu5jfwbe86Cj8ozaGCESfHHEB9ozVkblteZkSa0VXjdqNQ48hsLViNmAd+BqkK1V
         q/gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G6qcLZIvblskoFgEnCuJMCztdD2PGCRP1LhslLrHAEQ=;
        b=EPggi5YOo0DS9A/krDeq8r3PS48VdbQu4GLgCVRQUs6hPWsnK/8vHJsAqLe/AIm/wM
         M9KStVteClTfW11NrB/moyXKJwRWcgiyReDHk5Z4mxYPYFcemQdDVMnafp9hbj4ypJZ+
         FzJyqITyUsdA0aqQklUeCbYs0q2GqNLyh+mNuI+WWHOTit/qOTuso8oSRG4f1mUxHVvG
         EwnPfXbWAbnHlNIbaJgue/3eOslv+N33CSCX7Ob/mYOk1ddrl9SyKp2GOvuSQdDYuQrf
         ZJoeJpMjPSIcv/h2sCRnWbOHbhpgAFDXMFuqcI3mXkvZsQodKNzfHpsYWJbXMNPkh33e
         wsfA==
X-Gm-Message-State: AOAM531U+AKidb5GU4IJILQX9sR4ihcf+k7FC3pJJuSm6f3qI3wjUu5i
        A2fuHBckYoPxvN4UCRWObE4=
X-Google-Smtp-Source: ABdhPJyhS3naDjcZwz76wxh+UwOALKI6+ognA+Vy84m2GW3Q4DREgFQtb76pZzT/fpS5rv7Jc2NAhg==
X-Received: by 2002:a05:6a00:2310:b0:4fa:7eb1:e855 with SMTP id h16-20020a056a00231000b004fa7eb1e855mr18005434pfh.14.1652134928188;
        Mon, 09 May 2022 15:22:08 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:22:07 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5 net-next 08/13] net: allow gro_max_size to exceed 65536
Date:   Mon,  9 May 2022 15:21:44 -0700
Message-Id: <20220509222149.1763877-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509222149.1763877-1-eric.dumazet@gmail.com>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
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
index 2ef9254a9d3a57403f510d32194d8be6730b1645..dfd57a647c97ed0f400ffe89c73919367a900f75 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2151,7 +2151,11 @@ struct net_device {
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
index a1bbe000953f9365b4419f2ddbef96ddada42d3a..7349f75891d5724a060781abc80a800bdf835f74 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10605,7 +10605,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 
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
index 823db8999a2c1d5959042393783492dbecf1352c..5d7d7fe1e63a972bbcbd5eed1404b2643c74cfcb 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2347,14 +2347,6 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[],
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
2.36.0.512.ge40c2bad7a-goog

