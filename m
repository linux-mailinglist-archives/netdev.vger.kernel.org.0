Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9C15141BE
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 07:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243588AbiD2F25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 01:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbiD2F2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 01:28:55 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CD684EFB;
        Thu, 28 Apr 2022 22:25:36 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id t16so5010988qtr.9;
        Thu, 28 Apr 2022 22:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OAy3D8KG1WItCo1uWz9O7MRxic5ddgVF3Xz+AKLcLUY=;
        b=At6SVEC2gv812iSE4kuSDMTI+RBFdYYB10jFvxc8t3pGZ/KBr3kvnGKBKh7H8S/+kS
         Gm5gnYy1/nEqMO7mt2zPSEgsQc2bx8XP1SDmVWn26cVShMENDcUD9lPZQ6jsmgtV0QKk
         52gVj8SBhZ6ZHHrSpZIUyZIvI7n5xVRr/ztkX9pta1iUcD06qB7xsuYYGoVDFc5oJU18
         AcdSHHplpCdWse9CNq+nH+45rbM1DB+Pgp/IYDsoEIdBhVjPIc3xxmmvp2qyT0U3xIf9
         ftESFwfAlO+GZlN0ZFIXDRg+QQden6nbRIvmLvn+wglJ5vU6w98Q3DVPmgX3YmExpkIK
         vKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OAy3D8KG1WItCo1uWz9O7MRxic5ddgVF3Xz+AKLcLUY=;
        b=62SiHGHvTV0ReCl9NOueiq/uQB32gRMg32qvSYRJmtsUPkiI3GYVg6OI1YIE5Wf8Xs
         MjK9WEZPlGA9z/DtpJprhAsbkSx1iop+XGhw/Ld5bnEC/kjip1rZfzkB4Y/3hVxUa+fG
         d+5wZ+olfhPJGhXhqUdp/TOHc24aMrjGZtDqdbmrikIHYMgqSZflgArfUkMHqSCx9Nov
         p78FcEjWMasWriHvsP2Otpm5rgXc/6aQlyR4Mk/vwnwFmw82ktmWCOITvKNbDb2XHg9T
         gRIF1ULpCASJetMJEV1DQdSMYUzllWTU3CYZ+OHvWLejrNptChJQJJHj0vIvMET7h35t
         Z79g==
X-Gm-Message-State: AOAM530KPvz8iOYj0x7iJn3ErJ1ztTroiQpYAARiJA5vDTQYr6q+qSOc
        b2ngOtN+govd+xBY0iOtA26DL7gozw==
X-Google-Smtp-Source: ABdhPJxS3GgNNWmG4T2iFaq+IwKU8jIFjSmEMcLGLOXWZJB3RJ1uF6KGiKPBhEAJT3HLCIjRiDtpYQ==
X-Received: by 2002:ac8:5c0d:0:b0:2f3:6774:7496 with SMTP id i13-20020ac85c0d000000b002f367747496mr17325176qti.414.1651209935823;
        Thu, 28 Apr 2022 22:25:35 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id i68-20020a375447000000b006809e0adfffsm1041053qkb.25.2022.04.28.22.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 22:25:35 -0700 (PDT)
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
Subject: [PATCH v2 net-next 1/2] ip_gre: Make GRE and GRETAP devices always NETIF_F_LLTX
Date:   Thu, 28 Apr 2022 22:25:21 -0700
Message-Id: <9898b5249aa3c188cb02179aa7d6d4e7e831cbf9.1651207788.git.peilin.ye@bytedance.com>
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
always mark GRE[TAP] devices as NETIF_F_LLTX, since we no longer need
the TX lock (&txq->_xmit_lock).

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
change since v1:
  - deleted "depends on patch..." in commit message

 net/ipv4/ip_gre.c | 50 +++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 8cf86e42c1d1..a81c2964f70b 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -748,6 +748,7 @@ static netdev_tx_t gre_tap_xmit(struct sk_buff *skb,
 static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
+	__be16 flags;
 	int len;
 
 	len = tunnel->tun_hlen;
@@ -763,19 +764,15 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 	if (set_mtu)
 		dev->mtu = max_t(int, dev->mtu - len, 68);
 
-	if (!(tunnel->parms.o_flags & TUNNEL_SEQ)) {
-		if (!(tunnel->parms.o_flags & TUNNEL_CSUM) ||
-		    tunnel->encap.type == TUNNEL_ENCAP_NONE) {
-			dev->features |= NETIF_F_GSO_SOFTWARE;
-			dev->hw_features |= NETIF_F_GSO_SOFTWARE;
-		} else {
-			dev->features &= ~NETIF_F_GSO_SOFTWARE;
-			dev->hw_features &= ~NETIF_F_GSO_SOFTWARE;
-		}
-		dev->features |= NETIF_F_LLTX;
-	} else {
+	flags = tunnel->parms.o_flags;
+
+	if (flags & TUNNEL_SEQ ||
+	    (flags & TUNNEL_CSUM && tunnel->encap.type != TUNNEL_ENCAP_NONE)) {
+		dev->features &= ~NETIF_F_GSO_SOFTWARE;
 		dev->hw_features &= ~NETIF_F_GSO_SOFTWARE;
-		dev->features &= ~(NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE);
+	} else {
+		dev->features |= NETIF_F_GSO_SOFTWARE;
+		dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 	}
 }
 
@@ -949,6 +946,7 @@ static void ipgre_tunnel_setup(struct net_device *dev)
 static void __gre_tunnel_init(struct net_device *dev)
 {
 	struct ip_tunnel *tunnel;
+	__be16 flags;
 
 	tunnel = netdev_priv(dev);
 	tunnel->tun_hlen = gre_calc_hlen(tunnel->parms.o_flags);
@@ -957,25 +955,21 @@ static void __gre_tunnel_init(struct net_device *dev)
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen;
 	dev->needed_headroom = tunnel->hlen + sizeof(tunnel->parms.iph);
 
-	dev->features		|= GRE_FEATURES;
+	dev->features		|= GRE_FEATURES | NETIF_F_LLTX;
 	dev->hw_features	|= GRE_FEATURES;
 
-	if (!(tunnel->parms.o_flags & TUNNEL_SEQ)) {
-		/* TCP offload with GRE SEQ is not supported, nor
-		 * can we support 2 levels of outer headers requiring
-		 * an update.
-		 */
-		if (!(tunnel->parms.o_flags & TUNNEL_CSUM) ||
-		    (tunnel->encap.type == TUNNEL_ENCAP_NONE)) {
-			dev->features    |= NETIF_F_GSO_SOFTWARE;
-			dev->hw_features |= NETIF_F_GSO_SOFTWARE;
-		}
+	flags = tunnel->parms.o_flags;
 
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
+	if (flags & TUNNEL_CSUM && tunnel->encap.type != TUNNEL_ENCAP_NONE)
+		return;
+
+	dev->features |= NETIF_F_GSO_SOFTWARE;
+	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 }
 
 static int ipgre_tunnel_init(struct net_device *dev)
-- 
2.20.1

