Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386225141BB
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 07:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344183AbiD2F3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 01:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbiD2F3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 01:29:22 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2D686E32;
        Thu, 28 Apr 2022 22:26:05 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id hf18so5048378qtb.0;
        Thu, 28 Apr 2022 22:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uhh8KkVQKj93He9mfBmvkNfU4S0Pc0yD3FtSa0pLqVA=;
        b=Mb/7wwh4831Z0tDdbn6KvWW0haocqyUf9NwCWIqttad4W4eQ58+8sNL7hc05f8pFb/
         BFWrIe7Iz17kU6XRHfrMHRuYgcamwFZH5lEUNhLs465dvrGd2bEPyQQIESz/WGZPWJ6v
         ng+OzSrK6vpm0f/0lJqwfzh5Yeoi041VwaYpNdR/+V+hx4G1Dp3dKNpsifoIFvqhyVPH
         CSW1vJdnDEig1tJdA8UyxI8/pXpxel5Ev/xonqQE3lPNZJpSrCJI+QE0oUjoEg1wd0Bt
         PaZpOnox5bqEQ9d3AbROMidRa/dN1XTYuzCUSIbGgyioeHG5tze4K3Hrovp7Rr1tUtS0
         J8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uhh8KkVQKj93He9mfBmvkNfU4S0Pc0yD3FtSa0pLqVA=;
        b=Eb+QzFL7zXXAl4cm3qI/TKu4EIyzjp6f4akilxcQdenV/BWx5HMM3WV6uBOXtx/Nqx
         XnFGx+Rvv3ysEoVEIkFZ1VCkN9YMOoJ0zjAD80bM/ONYTuWaFEAi3iCYYTTpFrFJL8Bo
         ZXMP9z0qX5pD3qwM0QYz6IsMJ8w9PnWRemq8aBqMaod/DGenIvn3Lq5lREh10JjxUU7S
         VuC5sm36YL4Q94MZQ9+SyepAO+r6JH6ixbScBnM/o32w6NdQDK/Uu2gmWgA2C3hSow+M
         j60xjehY0DDjYnhRfpmtdo7PfEPQ0l2GEtbB42fXIPDjGd4o0PzNS6CxdC6leZufFIL/
         n4Uw==
X-Gm-Message-State: AOAM533tbUwuz7oWSk2sPikzFIM8P2mvK7W5qTJod9IvnTe5vLj/RxaW
        bEbGrPJ4NPAObb9eSaDFzQ==
X-Google-Smtp-Source: ABdhPJx6ng4fNeivixfLu5EH2N9vzutg/NCqQjeNYY0mGmu8xNDkEgZzrgcOblRhQ1q5SraMraRswQ==
X-Received: by 2002:a05:622a:1113:b0:2f3:716a:1e04 with SMTP id e19-20020a05622a111300b002f3716a1e04mr14622930qty.388.1651209964767;
        Thu, 28 Apr 2022 22:26:04 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id v67-20020a376146000000b0069ec181a0c6sm995098qkb.10.2022.04.28.22.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 22:26:04 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        William Tu <u9012063@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH v2 net-next 2/2] ip6_gre: Make IP6GRE and IP6GRETAP devices always NETIF_F_LLTX
Date:   Thu, 28 Apr 2022 22:25:47 -0700
Message-Id: <f3d8ad04d0652fcbd95d3b22490123815cf66ba7.1651207788.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651207788.git.peilin.ye@bytedance.com>
References: <cover.1651207788.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Recently we made o_seqno atomic_t.  Stop special-casing TUNNEL_SEQ, and
always mark IP6GRE[TAP] devices as NETIF_F_LLTX, since we no longer need
the TX lock (&txq->_xmit_lock).

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
(no changes since v1)

 net/ipv6/ip6_gre.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 5136959b3dc5..4e37f7c29900 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -382,11 +382,6 @@ static struct ip6_tnl *ip6gre_tunnel_locate(struct net *net,
 		goto failed_free;
 
 	ip6gre_tnl_link_config(nt, 1);
-
-	/* Can use a lockless transmit, unless we generate output sequences */
-	if (!(nt->parms.o_flags & TUNNEL_SEQ))
-		dev->features |= NETIF_F_LLTX;
-
 	ip6gre_tunnel_link(ign, nt);
 	return nt;
 
@@ -1445,26 +1440,23 @@ static void ip6gre_tunnel_setup(struct net_device *dev)
 static void ip6gre_tnl_init_features(struct net_device *dev)
 {
 	struct ip6_tnl *nt = netdev_priv(dev);
+	__be16 flags;
 
-	dev->features		|= GRE6_FEATURES;
+	dev->features		|= GRE6_FEATURES | NETIF_F_LLTX;
 	dev->hw_features	|= GRE6_FEATURES;
 
-	if (!(nt->parms.o_flags & TUNNEL_SEQ)) {
-		/* TCP offload with GRE SEQ is not supported, nor
-		 * can we support 2 levels of outer headers requiring
-		 * an update.
-		 */
-		if (!(nt->parms.o_flags & TUNNEL_CSUM) ||
-		    nt->encap.type == TUNNEL_ENCAP_NONE) {
-			dev->features    |= NETIF_F_GSO_SOFTWARE;
-			dev->hw_features |= NETIF_F_GSO_SOFTWARE;
-		}
+	flags = nt->parms.o_flags;
 
-		/* Can use a lockless transmit, unless we generate
-		 * output sequences
-		 */
-		dev->features |= NETIF_F_LLTX;
-	}
+	/* TCP offload with GRE SEQ is not supported, nor can we support 2
+	 * levels of outer headers requiring an update.
+	 */
+	if (flags & TUNNEL_SEQ)
+		return;
+	if (flags & TUNNEL_CSUM && nt->encap.type != TUNNEL_ENCAP_NONE)
+		return;
+
+	dev->features |= NETIF_F_GSO_SOFTWARE;
+	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 }
 
 static int ip6gre_tunnel_init_common(struct net_device *dev)
-- 
2.20.1

