Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3917D4AA105
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 21:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbiBDUPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 15:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236890AbiBDUPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 15:15:53 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8944AC061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 12:15:52 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id p125so5911645pga.2
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 12:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dhc+/ADPzu/me6I7esuBYkkbR3V3HWLyeNBFpgRHsuc=;
        b=MNBK2cj6cWwrvrWHGl20osJod1i7I1qYkwxmw5XfIW2t9tzbKuvXsGwCXhGF0g6dK5
         WDR2A1TzWF9P2p+Q36LDQlE0hxxqnbTeWZsruk+krpnuQIvtuIymx6tp1P0xqx8vEiC6
         zvBtY/MQ0rXEDYvp0K4DY7/NEbEGFTed093xEHQqSRkyTqc5KM7ujFJfkK1OvzPjrtG6
         S3/vXVmzXY3Np6PAKwpcFgAoDvbj9+NlEnpN2jD8LwCI6qdzecCi7IUQP5UTUEfCXj63
         2QjejooS+zpintDTIRnc2qB6i6p1y/F9cfi5zMDa/zke2Ot7j1YfEwODe5D31Qh7Vunq
         SbHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dhc+/ADPzu/me6I7esuBYkkbR3V3HWLyeNBFpgRHsuc=;
        b=umJPIQgQ2sij0f56X3y6x+1fFlyhBPzW/BJaP7Aooq2KsoMi1XdD+2uaiNZGQjdUFi
         D9f/ZSUlxd7f95erpFLe4YznNegnrxIVmvEqdiilogy7ZIKQzPSb/R5qFNVX1Wjno9Ax
         oUkceVTNqRU/W4fnqITQpfUITSigOyD6lPUCYGp0tSA6K4r53qys7mUY6so+HjT9DEfq
         cuaV56p3uyjpnfa5TmxVD+TVf1tK2WV3IXRz4DOJuaUk3G0cTCoSkoEq5+NfRdsoqTGN
         zJ2NZbXeqGvCX2tYjH0oKCB121pgBmC+o17DPloNwgnU2FmOqxne+tny0Cry4EnRnSbO
         ZgiA==
X-Gm-Message-State: AOAM5324T8q7eLEG/eSFrTaohtnEq2tGWtb10ZjWde24DSgp8h1aHFm/
        DGnpV6yVqiyu9n3S1d1Jzpg=
X-Google-Smtp-Source: ABdhPJxdaiP19kRLhtn6Q09j+aOjui336v8eY95q6wXz8W/1f/Jqidu3TluaUKzRJRl5qu76rGhWBg==
X-Received: by 2002:a05:6a00:1a8d:: with SMTP id e13mr4699891pfv.10.1644005751996;
        Fri, 04 Feb 2022 12:15:51 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id d9sm3571417pfl.69.2022.02.04.12.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 12:15:51 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/2] ipv6: make mc_forwarding atomic
Date:   Fri,  4 Feb 2022 12:15:45 -0800
Message-Id: <20220204201546.2703267-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220204201546.2703267-1-eric.dumazet@gmail.com>
References: <20220204201546.2703267-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This fixes minor data-races in ip6_mc_input() and
batadv_mcast_mla_rtr_flags_softif_get_ipv6()

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/ipv6.h       | 2 +-
 net/batman-adv/multicast.c | 2 +-
 net/ipv6/addrconf.c        | 4 ++--
 net/ipv6/ip6_input.c       | 2 +-
 net/ipv6/ip6mr.c           | 8 ++++----
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 1e0f8a31f3de175659dca9ecee9f97d8b01e2b68..16870f86c74d3d1f5dfb7edac1e7db85f1ef6755 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -51,7 +51,7 @@ struct ipv6_devconf {
 	__s32		use_optimistic;
 #endif
 #ifdef CONFIG_IPV6_MROUTE
-	__s32		mc_forwarding;
+	atomic_t	mc_forwarding;
 #endif
 	__s32		disable_ipv6;
 	__s32		drop_unicast_in_l2_multicast;
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index f4004cf0ff6fbf8f586d68f33ff63d3192bc5ca9..9f311fddfaf9aa6d35cd1039699203b7aaccbfdf 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -134,7 +134,7 @@ static u8 batadv_mcast_mla_rtr_flags_softif_get_ipv6(struct net_device *dev)
 {
 	struct inet6_dev *in6_dev = __in6_dev_get(dev);
 
-	if (in6_dev && in6_dev->cnf.mc_forwarding)
+	if (in6_dev && atomic_read(&in6_dev->cnf.mc_forwarding))
 		return BATADV_NO_FLAGS;
 	else
 		return BATADV_MCAST_WANT_NO_RTR6;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f927c199a93c3ed1124be02eb32a20900980f337..ff1b2484b8ed8638e4d37eb21c67de4e5ac43dae 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -554,7 +554,7 @@ static int inet6_netconf_fill_devconf(struct sk_buff *skb, int ifindex,
 #ifdef CONFIG_IPV6_MROUTE
 	if ((all || type == NETCONFA_MC_FORWARDING) &&
 	    nla_put_s32(skb, NETCONFA_MC_FORWARDING,
-			devconf->mc_forwarding) < 0)
+			atomic_read(&devconf->mc_forwarding)) < 0)
 		goto nla_put_failure;
 #endif
 	if ((all || type == NETCONFA_PROXY_NEIGH) &&
@@ -5533,7 +5533,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_USE_OPTIMISTIC] = cnf->use_optimistic;
 #endif
 #ifdef CONFIG_IPV6_MROUTE
-	array[DEVCONF_MC_FORWARDING] = cnf->mc_forwarding;
+	array[DEVCONF_MC_FORWARDING] = atomic_read(&cnf->mc_forwarding);
 #endif
 	array[DEVCONF_DISABLE_IPV6] = cnf->disable_ipv6;
 	array[DEVCONF_ACCEPT_DAD] = cnf->accept_dad;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 80256717868e69766acb3b590680f34a4ed1c0e9..d4b1e2c5aa76dd09efc6c48bf7e281447fdf10c1 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -508,7 +508,7 @@ int ip6_mc_input(struct sk_buff *skb)
 	/*
 	 *      IPv6 multicast router mode is now supported ;)
 	 */
-	if (dev_net(skb->dev)->ipv6.devconf_all->mc_forwarding &&
+	if (atomic_read(&dev_net(skb->dev)->ipv6.devconf_all->mc_forwarding) &&
 	    !(ipv6_addr_type(&hdr->daddr) &
 	      (IPV6_ADDR_LOOPBACK|IPV6_ADDR_LINKLOCAL)) &&
 	    likely(!(IP6CB(skb)->flags & IP6SKB_FORWARDED))) {
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 7cf73e60e619ba92ea1eccc90c181ba7150225dd..541cd08871293eb5702e47e0645ea16394621e97 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -732,7 +732,7 @@ static int mif6_delete(struct mr_table *mrt, int vifi, int notify,
 
 	in6_dev = __in6_dev_get(dev);
 	if (in6_dev) {
-		in6_dev->cnf.mc_forwarding--;
+		atomic_dec(&in6_dev->cnf.mc_forwarding);
 		inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
 					     NETCONFA_MC_FORWARDING,
 					     dev->ifindex, &in6_dev->cnf);
@@ -900,7 +900,7 @@ static int mif6_add(struct net *net, struct mr_table *mrt,
 
 	in6_dev = __in6_dev_get(dev);
 	if (in6_dev) {
-		in6_dev->cnf.mc_forwarding++;
+		atomic_inc(&in6_dev->cnf.mc_forwarding);
 		inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
 					     NETCONFA_MC_FORWARDING,
 					     dev->ifindex, &in6_dev->cnf);
@@ -1551,7 +1551,7 @@ static int ip6mr_sk_init(struct mr_table *mrt, struct sock *sk)
 	} else {
 		rcu_assign_pointer(mrt->mroute_sk, sk);
 		sock_set_flag(sk, SOCK_RCU_FREE);
-		net->ipv6.devconf_all->mc_forwarding++;
+		atomic_inc(&net->ipv6.devconf_all->mc_forwarding);
 	}
 	write_unlock_bh(&mrt_lock);
 
@@ -1584,7 +1584,7 @@ int ip6mr_sk_done(struct sock *sk)
 			 * so the RCU grace period before sk freeing
 			 * is guaranteed by sk_destruct()
 			 */
-			net->ipv6.devconf_all->mc_forwarding--;
+			atomic_dec(&net->ipv6.devconf_all->mc_forwarding);
 			write_unlock_bh(&mrt_lock);
 			inet6_netconf_notify_devconf(net, RTM_NEWNETCONF,
 						     NETCONFA_MC_FORWARDING,
-- 
2.35.0.263.gb82422642f-goog

