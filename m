Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57C8699A05
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjBPQ3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBPQ3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:29:21 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7B34C3C9
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:19 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-532e96672b3so25759797b3.13
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G9WPmC9TZove/Rvk7SZkDPC7EExgnnVLdc+ac862vzE=;
        b=KROH6eTFjpVB4K+41bpVLiaAj7GdJsc2JSzK6OTRzO58V5v3l0qe9IJroqc6JpAxn6
         XGYqGN4+DSySPwLXsIPgHaKku8/uF6QpxxX3yIHkELnef0RVa3QfO0/SaUR9RYZhb75m
         U3f3xldUGFgu0gwh70d2TGffY51Mn1ymjVC6aOxFZkeJsGgxoRPw3LqYaVei34YGf7iU
         6FpdsZN0EZi+FLnT0jKNAVRHmIbbbwvx50PI7lIEgfmlmQG+X2/d4e+62hGsp16CLwFU
         kRuyBpWhexrpG0plVlzFiZiLZGznk+EkxA+cAhzGnMM7yaeG6siY/yW5ZkPRja1cqbb6
         PQKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9WPmC9TZove/Rvk7SZkDPC7EExgnnVLdc+ac862vzE=;
        b=2H2LjlX+oouBwI4qwXILGoya1lnRs3HVfuEGoT+BULajhFBXVBHm9ahZTVlfLW/hZ2
         V149bzEPok09soB5lUXkCg8SiFDI0AAiNY12ae6QT5d1XexUpcY3MUg6PQZ99GwmAjx3
         mxfc0cYjj3UdLq0c9qmL8kC+1jMEYkttaYPcpU1KKabqb+/yUJI337KaqZ09AdTAxHVr
         uaFFxni3SX4N8etOU2YI7GamzhQBBIltwtBFPhP7rEFgwGgOe6I6Daz71vcgZ3lTdLd3
         pCJ4LwWPMu73TzzqbZKBF7c3vIk81avgdwnfzfnlLI3TvE9I8wJziaHfDlt17pNIo6EF
         OICw==
X-Gm-Message-State: AO0yUKUr7nM/Y+ngazy5ZG+NCa8nquHb9+qbSlYlHdik+18roGs5FWk1
        mQbL+4349YbcHq/V+psdcukzEEEcocqpjw==
X-Google-Smtp-Source: AK7set8GFq6BJtbkQwP8VxtpxZzEfV8aY04OyXMCubXoLgIwsqhfln0BZ/tGcZY0rwNpP9MQCV6gzrO2BrNANw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:c842:0:b0:533:80fb:733d with SMTP id
 k63-20020a0dc842000000b0053380fb733dmr368822ywd.290.1676564959637; Thu, 16
 Feb 2023 08:29:19 -0800 (PST)
Date:   Thu, 16 Feb 2023 16:28:38 +0000
In-Reply-To: <20230216162842.1633734-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230216162842.1633734-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216162842.1633734-5-edumazet@google.com>
Subject: [PATCH net-next 4/8] ipv6: icmp6: add drop reason support to ndisc_router_discovery()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change ndisc_router_discovery() to return a drop reason.

For the moment, return PKT_TOO_SMALL, NOT_SPECIFIED
and SKB_CONSUMED.

More reasons are added later.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ndisc.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 514eb8cc78792445dedead3cf0b49df696ce2785..7c8ba308ea4979f46cb22d0132b559278b927a5f 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1231,20 +1231,21 @@ static void ndisc_ra_useropt(struct sk_buff *ra, struct nd_opt_hdr *opt)
 	rtnl_set_sk_err(net, RTNLGRP_ND_USEROPT, err);
 }
 
-static void ndisc_router_discovery(struct sk_buff *skb)
+static enum skb_drop_reason ndisc_router_discovery(struct sk_buff *skb)
 {
 	struct ra_msg *ra_msg = (struct ra_msg *)skb_transport_header(skb);
+	bool send_ifinfo_notify = false;
 	struct neighbour *neigh = NULL;
-	struct inet6_dev *in6_dev;
+	struct ndisc_options ndopts;
 	struct fib6_info *rt = NULL;
+	struct inet6_dev *in6_dev;
 	u32 defrtr_usr_metric;
+	unsigned int pref = 0;
+	__u32 old_if_flags;
 	struct net *net;
+	SKB_DR(reason);
 	int lifetime;
-	struct ndisc_options ndopts;
 	int optlen;
-	unsigned int pref = 0;
-	__u32 old_if_flags;
-	bool send_ifinfo_notify = false;
 
 	__u8 *opt = (__u8 *)(ra_msg + 1);
 
@@ -1256,17 +1257,15 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 		  __func__, skb->dev->name);
 	if (!(ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)) {
 		ND_PRINTK(2, warn, "RA: source address is not link-local\n");
-		return;
-	}
-	if (optlen < 0) {
-		ND_PRINTK(2, warn, "RA: packet too short\n");
-		return;
+		return reason;
 	}
+	if (optlen < 0)
+		return SKB_DROP_REASON_PKT_TOO_SMALL;
 
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	if (skb->ndisc_nodetype == NDISC_NODETYPE_HOST) {
 		ND_PRINTK(2, warn, "RA: from host or unauthorized router\n");
-		return;
+		return reason;
 	}
 #endif
 
@@ -1278,12 +1277,12 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	if (!in6_dev) {
 		ND_PRINTK(0, err, "RA: can't find inet6 device for %s\n",
 			  skb->dev->name);
-		return;
+		return reason;
 	}
 
 	if (!ndisc_parse_options(skb->dev, opt, optlen, &ndopts)) {
 		ND_PRINTK(2, warn, "RA: invalid ND options\n");
-		return;
+		return reason;
 	}
 
 	if (!ipv6_accept_ra(in6_dev)) {
@@ -1365,7 +1364,7 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 				  "RA: %s got default router without neighbour\n",
 				  __func__);
 			fib6_info_release(rt);
-			return;
+			return reason;
 		}
 	}
 	/* Set default route metric as specified by user */
@@ -1390,7 +1389,7 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 			ND_PRINTK(0, err,
 				  "RA: %s failed to add default route\n",
 				  __func__);
-			return;
+			return reason;
 		}
 
 		neigh = ip6_neigh_lookup(&rt->fib6_nh->fib_nh_gw6,
@@ -1401,7 +1400,7 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 				  "RA: %s got default router without neighbour\n",
 				  __func__);
 			fib6_info_release(rt);
-			return;
+			return reason;
 		}
 		neigh->flags |= NTF_ROUTER;
 	} else if (rt && IPV6_EXTRACT_PREF(rt->fib6_flags) != pref) {
@@ -1488,6 +1487,7 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 			     NEIGH_UPDATE_F_OVERRIDE_ISROUTER|
 			     NEIGH_UPDATE_F_ISROUTER,
 			     NDISC_ROUTER_ADVERTISEMENT, &ndopts);
+		reason = SKB_CONSUMED;
 	}
 
 	if (!ipv6_accept_ra(in6_dev)) {
@@ -1598,6 +1598,7 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	fib6_info_release(rt);
 	if (neigh)
 		neigh_release(neigh);
+	return reason;
 }
 
 static void ndisc_redirect_rcv(struct sk_buff *skb)
@@ -1850,7 +1851,7 @@ enum skb_drop_reason ndisc_rcv(struct sk_buff *skb)
 		break;
 
 	case NDISC_ROUTER_ADVERTISEMENT:
-		ndisc_router_discovery(skb);
+		reason = ndisc_router_discovery(skb);
 		break;
 
 	case NDISC_REDIRECT:
-- 
2.39.1.581.gbfd45094c4-goog

