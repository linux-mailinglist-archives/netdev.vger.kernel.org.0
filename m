Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EBD52045D
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 20:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240144AbiEISVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 14:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240143AbiEISVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 14:21:37 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F472B24DA
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 11:17:43 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id e24so13876934pjt.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 11:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=sRqlEDN4w6GKvYxDsjvMTKHzyXhcrNTwEsTsxG4D8og=;
        b=dyCNuGiuxVohYJmtU7v87unfyZv64iVBdsXNtgvL2i//ZmGCGDOFNkgS/KbpBvT5c0
         oXorNPijH8yXnJtfdcnormcjQiW8pZgOCi+BhzOyEopP8TrL8nxqSSScEVaxwZe6T6wa
         MgfASmveByVRqId43sRZt79JIfRhxN0XZc72GdJO0PPNuR0yncV9O+1C8pgUlC+yNwMA
         c6AJfuJbNIAqBINm2S+KveS/6KFqRDnSyARAZWPFE0Vz13WAD8CqumGYKzytXShYy4fa
         YzlraZIynvgVXNb6esWb2/MJ5uRLdRlTx00lho21LPduwVoxOeW1mN2t+lg/ganfWiz1
         Kz6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=sRqlEDN4w6GKvYxDsjvMTKHzyXhcrNTwEsTsxG4D8og=;
        b=vYDyjtazNTSuPv3Tw9rlwzzsdGdWTwe708cTc/g0nIEenII571el2xENH86MSwoZGx
         R/etyKDqaxtWNOcodaK97i9RY4JQwjfFt/QSXsij0vsASmtJMD49N+29lEEAxDTEsbQT
         /lMjRNicQ5O9fKMuJPncZGV+OWyMFolkPLBj+xc5tQChC2ehIfhPhEK9LYRMcedyiOS7
         nOEGq80qfU5mZgDn6Jexn0NVUhyTz0LESOvA1VKksUwT8i3RZZ5WAnxz3jWaXZYkPUtD
         D/9P9icKXe3bOnugY64VgVSNJ67Y+1oLvuvJSr6+UFq1O7dPkSl4mMwcXPBfiVOL3Qs+
         8xOA==
X-Gm-Message-State: AOAM532mRLTyVaxJl7nuILkqH86IvDOnPnwIbGQavxWl2fYcFcYK13lZ
        uy1DVLQ6donKYAO5cGbOfJU=
X-Google-Smtp-Source: ABdhPJwOCksXAaDmCcxtuX1bQ/d6yAzDSW1tA58Ec4VsLXWASN7+a5hEctBfDb3SXxFvFUBqRelOnQ==
X-Received: by 2002:a17:902:e842:b0:15e:d449:fd03 with SMTP id t2-20020a170902e84200b0015ed449fd03mr17743330plg.60.1652120262717;
        Mon, 09 May 2022 11:17:42 -0700 (PDT)
Received: from localhost.localdomain ([98.97.39.30])
        by smtp.gmail.com with ESMTPSA id p21-20020a170902ead500b0015e8d4eb1c6sm215882pld.16.2022.05.09.11.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 11:17:42 -0700 (PDT)
Subject: [PATCH 2/2] net: Allow gro_max_size to exceed 65536
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     edumazet@google.com
Cc:     alexander.duyck@gmail.com, davem@davemloft.net,
        eric.dumazet@gmail.com, kuba@kernel.org, lixiaoyan@google.com,
        netdev@vger.kernel.org, pabeni@redhat.com
Date:   Mon, 09 May 2022 11:17:39 -0700
Message-ID: <165212025961.5729.17180695227155162299.stgit@localhost.localdomain>
In-Reply-To: <165212006050.5729.9059171256935942562.stgit@localhost.localdomain>
References: <165212006050.5729.9059171256935942562.stgit@localhost.localdomain>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |    2 +-
 include/linux/netdevice.h                       |    3 ++-
 include/net/ipv6.h                              |    2 +-
 net/core/dev.c                                  |    2 +-
 net/core/gro.c                                  |    8 ++++++++
 net/core/rtnetlink.c                            |    8 --------
 6 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 838870bc6dbd..24de37b79f5a 100644
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
index da063cb37759..b78c41e664bd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2151,7 +2151,8 @@ struct net_device {
 	struct bpf_prog __rcu	*xdp_prog;
 	unsigned long		gro_flush_timeout;
 	int			napi_defer_hard_irqs;
-#define GRO_MAX_SIZE		65536
+#define GRO_LEGACY_MAX_SIZE	65536u
+#define GRO_MAX_SIZE		UINT_MAX
 	unsigned int		gro_max_size;
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index b6df0314aa02..5b38bf1a586b 100644
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
index a1bbe000953f..7349f75891d5 100644
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
index 78110edf5d4b..b4190eb08467 100644
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
index c5b44de41088..15b1b3092a7f 100644
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
 


