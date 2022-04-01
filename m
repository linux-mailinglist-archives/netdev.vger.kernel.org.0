Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7024EF01B
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347416AbiDAOcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347324AbiDAObt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:31:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15B128CAA4;
        Fri,  1 Apr 2022 07:27:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DD8B61CA5;
        Fri,  1 Apr 2022 14:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C14C340EE;
        Fri,  1 Apr 2022 14:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823275;
        bh=IrewDgmQ0+Iv7XNlHAoqViPWLz2ILiPnvQpQVc3bLvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fiurYunOZC/LnT5F5SeMuQm2R4XEriNwtAD7V4xiZcDUFT9UIthmDzCSEXsrE/usS
         agDdCyFwZF4znY8mmxRxbUNhEk0qYTr2GQrxrI/TtL7grdGe8Pz75ok/wcYahG25Oo
         7isWLrst8Pu+8BMn/7TDXaTJX5AHwMN/LJJFAxW8Pe5DFul54k+UnHmG13/BkZD3KZ
         3Y/KoQ7PDg2zSODMONt+jPPAq/rUIQa+Fcv9oxwhPwr/8Bfg90O2n5cQID4n8QvaKB
         YDmRorY6eB6V7MDcv2FyAjJ2l9jkGKKyG9vp/a/CZcRUd/B1BjAddbyayorVYXDTDo
         KqzgtEuQTQp1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH AUTOSEL 5.17 044/149] ipv6: make mc_forwarding atomic
Date:   Fri,  1 Apr 2022 10:23:51 -0400
Message-Id: <20220401142536.1948161-44-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 145c7a793838add5e004e7d49a67654dc7eba147 ]

This fixes minor data-races in ip6_mc_input() and
batadv_mcast_mla_rtr_flags_softif_get_ipv6()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ipv6.h       | 2 +-
 net/batman-adv/multicast.c | 2 +-
 net/ipv6/addrconf.c        | 4 ++--
 net/ipv6/ip6_input.c       | 2 +-
 net/ipv6/ip6mr.c           | 8 ++++----
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index a59d25f19385..b8641dc0ee66 100644
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
index f4004cf0ff6f..9f311fddfaf9 100644
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
index f908e2fd30b2..4df84013c4e6 100644
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
@@ -5539,7 +5539,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_USE_OPTIMISTIC] = cnf->use_optimistic;
 #endif
 #ifdef CONFIG_IPV6_MROUTE
-	array[DEVCONF_MC_FORWARDING] = cnf->mc_forwarding;
+	array[DEVCONF_MC_FORWARDING] = atomic_read(&cnf->mc_forwarding);
 #endif
 	array[DEVCONF_DISABLE_IPV6] = cnf->disable_ipv6;
 	array[DEVCONF_ACCEPT_DAD] = cnf->accept_dad;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 80256717868e..d4b1e2c5aa76 100644
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
index 8a2db926b5eb..e3c884678dbe 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -734,7 +734,7 @@ static int mif6_delete(struct mr_table *mrt, int vifi, int notify,
 
 	in6_dev = __in6_dev_get(dev);
 	if (in6_dev) {
-		in6_dev->cnf.mc_forwarding--;
+		atomic_dec(&in6_dev->cnf.mc_forwarding);
 		inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
 					     NETCONFA_MC_FORWARDING,
 					     dev->ifindex, &in6_dev->cnf);
@@ -902,7 +902,7 @@ static int mif6_add(struct net *net, struct mr_table *mrt,
 
 	in6_dev = __in6_dev_get(dev);
 	if (in6_dev) {
-		in6_dev->cnf.mc_forwarding++;
+		atomic_inc(&in6_dev->cnf.mc_forwarding);
 		inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
 					     NETCONFA_MC_FORWARDING,
 					     dev->ifindex, &in6_dev->cnf);
@@ -1553,7 +1553,7 @@ static int ip6mr_sk_init(struct mr_table *mrt, struct sock *sk)
 	} else {
 		rcu_assign_pointer(mrt->mroute_sk, sk);
 		sock_set_flag(sk, SOCK_RCU_FREE);
-		net->ipv6.devconf_all->mc_forwarding++;
+		atomic_inc(&net->ipv6.devconf_all->mc_forwarding);
 	}
 	write_unlock_bh(&mrt_lock);
 
@@ -1586,7 +1586,7 @@ int ip6mr_sk_done(struct sock *sk)
 			 * so the RCU grace period before sk freeing
 			 * is guaranteed by sk_destruct()
 			 */
-			net->ipv6.devconf_all->mc_forwarding--;
+			atomic_dec(&net->ipv6.devconf_all->mc_forwarding);
 			write_unlock_bh(&mrt_lock);
 			inet6_netconf_notify_devconf(net, RTM_NEWNETCONF,
 						     NETCONFA_MC_FORWARDING,
-- 
2.34.1

