Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4337D520C1A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiEJDgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235487AbiEJDgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:36:33 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149B2179C01
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:32:36 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e5so13599492pgc.5
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rpwc7xh/8eoR1iuVrnrqpeL3VTTsd60sGp0FCBGNJ3k=;
        b=hmWva1U0bMFJqkMAbcuAWyPedwjQxWLyuxqteXLXOZmhCI8WbzZnFxQNqa7QX2V5J4
         8Ho9ggGFcQhAitKlT6wsJIZIe8QQLYoR58SNcgPXxjr/iCeSula3PIQ+1v7YTkKYZ7r5
         0IsfI1Gf27g2bdGBKlBPZbYOtiwbONuO4YffAD9kDiybn/VKO7lQsRHaWnppEjmi0VQD
         +VhtkCvwDVBwVrxM1urPCeHjSeHyuP3uhi2vhN5TU3CssV0aAtAHpovWrodu8jEAyj0/
         72XMZUHG+MBfPtKi189FKt2Z5LZl5UhfWXMRSv7KlmcrHDhZ0TX4kmswXuf3FWm9G0nA
         0r0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rpwc7xh/8eoR1iuVrnrqpeL3VTTsd60sGp0FCBGNJ3k=;
        b=6KTeto0qNnhi3gzYZ+C40G0XcgOKI0RFb+EglZjMxxuVXapv0/yI1G2DwRlbR4jM+z
         3TaAlbnbLT29LYEvZzE6nMzRVEJhm03U+qwWEDVFvVHZkesCaH5Qh1XmhvMGjDcQgIeb
         oNJuxYDS3PacK8T0NNszj1Z+76HaDU4sjfAM5idatdiZiXCl6eFvxls+bJvvxGarEIkj
         e7PJWe0KSCWmtemqoziXNsjhJ65t/7w2tOm5FQKjNXYYgJatfP41qXh7MMPjp2akDyeR
         sR8X9yeuUwPVDeMwsPNB7MfQTnXO4BPNyHyBOJ10qmy+mrJfR7cgLbhzgjL1GGkdi5ns
         As/A==
X-Gm-Message-State: AOAM532ZG/JUWcrW09QH4N52qSMxTGfR3vvCK4cbWnfx96YQhUjdNpWL
        XSEFpBkN+5i3MUnEVFYmjQg=
X-Google-Smtp-Source: ABdhPJy4EGIuBvRR5D/0m91iSwa9TMmRZNEDvOH0oBEmjU3K9H7Fa+Yr+6poVWu582ZJxlzUpWM1GQ==
X-Received: by 2002:a65:6946:0:b0:39d:a0c3:71f with SMTP id w6-20020a656946000000b0039da0c3071fmr15106994pgq.160.1652153555652;
        Mon, 09 May 2022 20:32:35 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id me16-20020a17090b17d000b001d77f392280sm538185pjb.30.2022.05.09.20.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:32:35 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v6 net-next 08/13] net: allow gro_max_size to exceed 65536
Date:   Mon,  9 May 2022 20:32:14 -0700
Message-Id: <20220510033219.2639364-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510033219.2639364-1-eric.dumazet@gmail.com>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
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
index 673c444aae874428b117df45dffcaf702ac72a47..69743188f639c5afd20f06a5e301edca00aedaef 100644
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
index 68b76b45a5ac5f2ea705bd3db5d1732b79034609..4be3695846520af18a687cdcaa70c5f327ba94e8 100644
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

