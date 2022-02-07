Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82E04AC721
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbiBGRSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242434AbiBGRSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:18:10 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C31CC0401D5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:18:09 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso2997312pjh.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HBzIYM8OCfk6OS8NlZSUItfJ/dgQzZJu7sN803ms/H8=;
        b=oWEDxLkNFFpbd/9iNg78Gj4kQM6vwUYpsp/cL1809rgiNS4Wn4A1MBAEyQbKJahRU/
         5S2ec98bQq/Mp3QVUE2fXKa2kDF1dEXxdIV+hr6+LF17oCMk0ptnnmZbz9UE4nvUHXco
         5+VGdSJkUUuoG0hNqhSZWUaawD7J9NOR3qbd5iPzhwEOD/Eoe74B5Y2CAK6xDYHhxkjj
         QZdPJJmqxhDoLVFYn2RsykDaLyUN1nxHc0b8bYVkxCUeMZFuBA0K7ThOrPPpkjSWlEz1
         d3LdSNo8TxaEOdZni8orbJ8jsaKXQKPs77iPcqxZOrhycXMC2ZAztuiQquH5bjiuX9ib
         v0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HBzIYM8OCfk6OS8NlZSUItfJ/dgQzZJu7sN803ms/H8=;
        b=3K3DPtKZTXgdhbL1g+tdA3aZE2U3sQLtgLjAndz5KevHtwZvwt3Gat5FrqMXyaaC6Z
         CR5Pdc9juDA0KY73mAY4JOdUEQGepv7zK//EXzDBTdCWdHwdgkGTDxgRvzICGQYXQilW
         1jTzi+Mv/uvyaVK6oh5KcKLvpWdp1xC0Qht6etJQr4KM67jeXJiH4+aQ5FynAk/ChGVa
         9M2+h8n/ZOYvZK9tQfb1GzwPER3ABwky25N4Q/vMXT2N1UTXu3KbGbU9ybLh8lTO4lzi
         9wbkZgT4jD890kv+lWLz8ATiWu8juygYw7lzH5GNKVqu7CA120HOilvWxs3N3jGOFI1Y
         gNeg==
X-Gm-Message-State: AOAM532qqvG6n0/EvBuv9+IjojsfUQmiohVd6ctgg6FqV52v2H6X5GkB
        crUldvttB//lf67PQtbas8IFYte7MiQ=
X-Google-Smtp-Source: ABdhPJx/5ltYVLQKaIWUc+zMwcWSdRnUu4vGSCVtiNAeLbrdZUS2NmCzFPYZD3KUYh8DQ/IYXiC8tw==
X-Received: by 2002:a17:902:f1cb:: with SMTP id e11mr632262plc.48.1644254288682;
        Mon, 07 Feb 2022 09:18:08 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id lr8sm24415156pjb.11.2022.02.07.09.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:18:08 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 02/11] ipv6/addrconf: use one delayed work per netns
Date:   Mon,  7 Feb 2022 09:17:47 -0800
Message-Id: <20220207171756.1304544-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220207171756.1304544-1-eric.dumazet@gmail.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Next step for using per netns inet6_addr_lst
is to have per netns work item to ultimately
call addrconf_verify_rtnl() and addrconf_verify()
with a new 'struct net*' argument.

Everything is still using the global inet6_addr_lst[] table.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv6.h |  1 +
 net/ipv6/addrconf.c      | 44 ++++++++++++++++++++++------------------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 755f12001c8b2a73ad1895e73c7aebcba67c6728..d145f196668240bf5c3e509255f3f9b06f0e91bc 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -95,6 +95,7 @@ struct netns_ipv6 {
 
 	struct hlist_head	*inet6_addr_lst;
 	spinlock_t		addrconf_hash_lock;
+	struct delayed_work	addr_chk_work;
 
 #ifdef CONFIG_IPV6_MROUTE
 #ifndef CONFIG_IPV6_MROUTE_MULTIPLE_TABLES
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index cda9e59cab4343507f670e7f59e2b72fd3cded0f..dab291cd39ba20c8dad29854297e8699c067b1e7 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -152,12 +152,10 @@ static int ipv6_generate_stable_address(struct in6_addr *addr,
 static struct hlist_head inet6_addr_lst[IN6_ADDR_HSIZE];
 static DEFINE_SPINLOCK(addrconf_hash_lock);
 
-static void addrconf_verify(void);
-static void addrconf_verify_rtnl(void);
-static void addrconf_verify_work(struct work_struct *);
+static void addrconf_verify(struct net *net);
+static void addrconf_verify_rtnl(struct net *net);
 
 static struct workqueue_struct *addrconf_wq;
-static DECLARE_DELAYED_WORK(addr_chk_work, addrconf_verify_work);
 
 static void addrconf_join_anycast(struct inet6_ifaddr *ifp);
 static void addrconf_leave_anycast(struct inet6_ifaddr *ifp);
@@ -2675,7 +2673,7 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 				 create, now);
 
 		in6_ifa_put(ifp);
-		addrconf_verify();
+		addrconf_verify(net);
 	}
 
 	return 0;
@@ -2987,7 +2985,7 @@ static int inet6_addr_add(struct net *net, int ifindex,
 			manage_tempaddrs(idev, ifp, cfg->valid_lft,
 					 cfg->preferred_lft, true, jiffies);
 		in6_ifa_put(ifp);
-		addrconf_verify_rtnl();
+		addrconf_verify_rtnl(net);
 		return 0;
 	} else if (cfg->ifa_flags & IFA_F_MCAUTOJOIN) {
 		ipv6_mc_config(net->ipv6.mc_autojoin_sk, false,
@@ -3027,7 +3025,7 @@ static int inet6_addr_del(struct net *net, int ifindex, u32 ifa_flags,
 				manage_tempaddrs(idev, ifp, 0, 0, false,
 						 jiffies);
 			ipv6_del_addr(ifp);
-			addrconf_verify_rtnl();
+			addrconf_verify_rtnl(net);
 			if (ipv6_addr_is_multicast(pfx)) {
 				ipv6_mc_config(net->ipv6.mc_autojoin_sk,
 					       false, pfx, dev->ifindex);
@@ -4246,7 +4244,7 @@ static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
 	 * before this temporary address becomes deprecated.
 	 */
 	if (ifp->flags & IFA_F_TEMPORARY)
-		addrconf_verify_rtnl();
+		addrconf_verify_rtnl(dev_net(dev));
 }
 
 static void addrconf_dad_run(struct inet6_dev *idev, bool restart)
@@ -4484,7 +4482,7 @@ int ipv6_chk_rpl_srh_loop(struct net *net, const struct in6_addr *segs,
  *	Periodic address status verification
  */
 
-static void addrconf_verify_rtnl(void)
+static void addrconf_verify_rtnl(struct net *net)
 {
 	unsigned long now, next, next_sec, next_sched;
 	struct inet6_ifaddr *ifp;
@@ -4496,7 +4494,7 @@ static void addrconf_verify_rtnl(void)
 	now = jiffies;
 	next = round_jiffies_up(now + ADDR_CHECK_FREQUENCY);
 
-	cancel_delayed_work(&addr_chk_work);
+	cancel_delayed_work(&net->ipv6.addr_chk_work);
 
 	for (i = 0; i < IN6_ADDR_HSIZE; i++) {
 restart:
@@ -4599,20 +4597,23 @@ static void addrconf_verify_rtnl(void)
 
 	pr_debug("now = %lu, schedule = %lu, rounded schedule = %lu => %lu\n",
 		 now, next, next_sec, next_sched);
-	mod_delayed_work(addrconf_wq, &addr_chk_work, next_sched - now);
+	mod_delayed_work(addrconf_wq, &net->ipv6.addr_chk_work, next_sched - now);
 	rcu_read_unlock_bh();
 }
 
 static void addrconf_verify_work(struct work_struct *w)
 {
+	struct net *net = container_of(to_delayed_work(w), struct net,
+				       ipv6.addr_chk_work);
+
 	rtnl_lock();
-	addrconf_verify_rtnl();
+	addrconf_verify_rtnl(net);
 	rtnl_unlock();
 }
 
-static void addrconf_verify(void)
+static void addrconf_verify(struct net *net)
 {
-	mod_delayed_work(addrconf_wq, &addr_chk_work, 0);
+	mod_delayed_work(addrconf_wq, &net->ipv6.addr_chk_work, 0);
 }
 
 static struct in6_addr *extract_addr(struct nlattr *addr, struct nlattr *local,
@@ -4708,7 +4709,8 @@ static int modify_prefix_route(struct inet6_ifaddr *ifp,
 	return 0;
 }
 
-static int inet6_addr_modify(struct inet6_ifaddr *ifp, struct ifa6_config *cfg)
+static int inet6_addr_modify(struct net *net, struct inet6_ifaddr *ifp,
+			     struct ifa6_config *cfg)
 {
 	u32 flags;
 	clock_t expires;
@@ -4822,7 +4824,7 @@ static int inet6_addr_modify(struct inet6_ifaddr *ifp, struct ifa6_config *cfg)
 				 jiffies);
 	}
 
-	addrconf_verify_rtnl();
+	addrconf_verify_rtnl(net);
 
 	return 0;
 }
@@ -4909,7 +4911,7 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	    !(nlh->nlmsg_flags & NLM_F_REPLACE))
 		err = -EEXIST;
 	else
-		err = inet6_addr_modify(ifa, &cfg);
+		err = inet6_addr_modify(net, ifa, &cfg);
 
 	in6_ifa_put(ifa);
 
@@ -5794,7 +5796,7 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token,
 
 	write_unlock_bh(&idev->lock);
 	inet6_ifinfo_notify(RTM_NEWLINK, idev);
-	addrconf_verify_rtnl();
+	addrconf_verify_rtnl(dev_net(dev));
 	return 0;
 }
 
@@ -7112,6 +7114,7 @@ static int __net_init addrconf_init_net(struct net *net)
 	struct ipv6_devconf *all, *dflt;
 
 	spin_lock_init(&net->ipv6.addrconf_hash_lock);
+	INIT_DEFERRABLE_WORK(&net->ipv6.addr_chk_work, addrconf_verify_work);
 	net->ipv6.inet6_addr_lst = kcalloc(IN6_ADDR_HSIZE,
 					   sizeof(struct hlist_head),
 					   GFP_KERNEL);
@@ -7199,6 +7202,7 @@ static void __net_exit addrconf_exit_net(struct net *net)
 	kfree(net->ipv6.devconf_all);
 	net->ipv6.devconf_all = NULL;
 
+	cancel_delayed_work(&net->ipv6.addr_chk_work);
 	/*
 	 *	Check hash table, then free it.
 	 */
@@ -7281,7 +7285,7 @@ int __init addrconf_init(void)
 
 	register_netdevice_notifier(&ipv6_dev_notf);
 
-	addrconf_verify();
+	addrconf_verify(&init_net);
 
 	rtnl_af_register(&inet6_ops);
 
@@ -7364,7 +7368,7 @@ void addrconf_cleanup(void)
 	for (i = 0; i < IN6_ADDR_HSIZE; i++)
 		WARN_ON(!hlist_empty(&inet6_addr_lst[i]));
 	spin_unlock_bh(&addrconf_hash_lock);
-	cancel_delayed_work(&addr_chk_work);
+
 	rtnl_unlock();
 
 	destroy_workqueue(addrconf_wq);
-- 
2.35.0.263.gb82422642f-goog

