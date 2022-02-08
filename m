Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2AE4AD0C4
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243915AbiBHFc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347038AbiBHEvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:51:02 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA666C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:51:00 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id e28so16827501pfj.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YocVE5eZik1tiPsP0ujFo28MkujqtR9FCp0qy4+Xms4=;
        b=Jg7bpGjxVkKtlil3CT0q2PQ8k/0d/bK4VgPxTrQIIOaHDuJ2FSNMGhqK9+O8sZHR44
         QQRzAJUUEhfIiOZjGjc+1WfZabwK045aoe6OZCGT0NUbH0Tl7h6BS72enQiTNoG2i28c
         8Ywcc7xEl9k1QPdYLCoVoXb26v5/zERzIMOUybFGsiuVRkE2+W1CrZLgt0sx1XyLJ4DB
         bk/z4nxm9oJq5kCxrfVx+BxFbnjQgfsA039GZ3nDqarobM95jOmz4OA8VxOfYRInhMBU
         Yvmha9F7uB9DwcJB88xiJWSkz8K1X44cvIC27V1kwWe1kX7S1L80FTJOLvCAGqbV/CjF
         ux/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YocVE5eZik1tiPsP0ujFo28MkujqtR9FCp0qy4+Xms4=;
        b=onmjEPD5ALK8A3DHGeaRAss4MxbKEOTp0Zzce0lFcVxTWXpnCyEUNrmbzID78Ddxbd
         6/W8w+805lojheofMRDA0T5Cz8c3BMho/Wf0mkJFR+++pBanrrhmsqtFFeP4szWubohL
         EjxHFMw6e3bHj2esUQl33YNhLi2S51rAMgsBqkZvW8FJS1AvCTQ0NtELs7TIpFwX4xs+
         JtvX/N9BQlw4ThH10ESPJAtPqZ0jV1jCMf6ded1grMjDAUpdCqn3tCdKENdKPD8dvWQK
         Kjp6m0F+vMk5FwaKG9xtvOyk+YHXpIF92m32uhA/nnwyCmfpSn0QKdLFswlTAEMRRi0H
         9Lbw==
X-Gm-Message-State: AOAM533pbs32aM7FGExTXtTwwz31THzhywEwfE38id90iQ9yH21Meflg
        rNWSVsSnwdq3uOOwaUjPZZc=
X-Google-Smtp-Source: ABdhPJzV4eojucbWFVJybAxdV/kpBzafUdb9sU0bRbCoK5m4A9zsDI6iGBDTVrPiDUhPq4fatRoMKA==
X-Received: by 2002:aa7:8a14:: with SMTP id m20mr2608173pfa.63.1644295860365;
        Mon, 07 Feb 2022 20:51:00 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id j23sm9810257pgb.75.2022.02.07.20.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 20:51:00 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 03/11] ipv6/addrconf: switch to per netns inet6_addr_lst hash table
Date:   Mon,  7 Feb 2022 20:50:30 -0800
Message-Id: <20220208045038.2635826-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220208045038.2635826-1-eric.dumazet@gmail.com>
References: <20220208045038.2635826-1-eric.dumazet@gmail.com>
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

IPv6 does not scale very well with the number of IPv6 addresses.
It uses a global (shared by all netns) hash table with 256 buckets.

Some functions like addrconf_verify_rtnl() and addrconf_ifdown()
have to iterate all addresses in the hash table.

I have seen addrconf_verify_rtnl() holding the cpu for 10ms or more.

Switch to the per netns hashtable (and spinlock) added
in prior patches.

This considerably speeds up netns dismantle times on hosts
with thousands of netns. This also has an impact
on regular (fast path) IPv6 processing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/ipv6/addrconf.c | 77 ++++++++++++++-------------------------------
 1 file changed, 23 insertions(+), 54 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index dab291cd39ba20c8dad29854297e8699c067b1e7..4f402bc38f056e08f3761e63a7bc7a51e54e9384 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -146,11 +146,6 @@ static int ipv6_generate_stable_address(struct in6_addr *addr,
 
 #define IN6_ADDR_HSIZE_SHIFT	8
 #define IN6_ADDR_HSIZE		(1 << IN6_ADDR_HSIZE_SHIFT)
-/*
- *	Configured unicast address hash table
- */
-static struct hlist_head inet6_addr_lst[IN6_ADDR_HSIZE];
-static DEFINE_SPINLOCK(addrconf_hash_lock);
 
 static void addrconf_verify(struct net *net);
 static void addrconf_verify_rtnl(struct net *net);
@@ -1009,9 +1004,7 @@ static bool ipv6_chk_same_addr(struct net *net, const struct in6_addr *addr,
 {
 	struct inet6_ifaddr *ifp;
 
-	hlist_for_each_entry(ifp, &inet6_addr_lst[hash], addr_lst) {
-		if (!net_eq(dev_net(ifp->idev->dev), net))
-			continue;
+	hlist_for_each_entry(ifp, &net->ipv6.inet6_addr_lst[hash], addr_lst) {
 		if (ipv6_addr_equal(&ifp->addr, addr)) {
 			if (!dev || ifp->idev->dev == dev)
 				return true;
@@ -1022,20 +1015,21 @@ static bool ipv6_chk_same_addr(struct net *net, const struct in6_addr *addr,
 
 static int ipv6_add_addr_hash(struct net_device *dev, struct inet6_ifaddr *ifa)
 {
-	unsigned int hash = inet6_addr_hash(dev_net(dev), &ifa->addr);
+	struct net *net = dev_net(dev);
+	unsigned int hash = inet6_addr_hash(net, &ifa->addr);
 	int err = 0;
 
-	spin_lock(&addrconf_hash_lock);
+	spin_lock(&net->ipv6.addrconf_hash_lock);
 
 	/* Ignore adding duplicate addresses on an interface */
-	if (ipv6_chk_same_addr(dev_net(dev), &ifa->addr, dev, hash)) {
+	if (ipv6_chk_same_addr(net, &ifa->addr, dev, hash)) {
 		netdev_dbg(dev, "ipv6_add_addr: already assigned\n");
 		err = -EEXIST;
 	} else {
-		hlist_add_head_rcu(&ifa->addr_lst, &inet6_addr_lst[hash]);
+		hlist_add_head_rcu(&ifa->addr_lst, &net->ipv6.inet6_addr_lst[hash]);
 	}
 
-	spin_unlock(&addrconf_hash_lock);
+	spin_unlock(&net->ipv6.addrconf_hash_lock);
 
 	return err;
 }
@@ -1259,9 +1253,10 @@ cleanup_prefix_route(struct inet6_ifaddr *ifp, unsigned long expires,
 
 static void ipv6_del_addr(struct inet6_ifaddr *ifp)
 {
-	int state;
 	enum cleanup_prefix_rt_t action = CLEANUP_PREFIX_RT_NOP;
+	struct net *net = dev_net(ifp->idev->dev);
 	unsigned long expires;
+	int state;
 
 	ASSERT_RTNL();
 
@@ -1273,9 +1268,9 @@ static void ipv6_del_addr(struct inet6_ifaddr *ifp)
 	if (state == INET6_IFADDR_STATE_DEAD)
 		goto out;
 
-	spin_lock_bh(&addrconf_hash_lock);
+	spin_lock_bh(&net->ipv6.addrconf_hash_lock);
 	hlist_del_init_rcu(&ifp->addr_lst);
-	spin_unlock_bh(&addrconf_hash_lock);
+	spin_unlock_bh(&net->ipv6.addrconf_hash_lock);
 
 	write_lock_bh(&ifp->idev->lock);
 
@@ -1918,10 +1913,8 @@ __ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
 	if (skip_dev_check)
 		dev = NULL;
 
-	hlist_for_each_entry_rcu(ifp, &inet6_addr_lst[hash], addr_lst) {
+	hlist_for_each_entry_rcu(ifp, &net->ipv6.inet6_addr_lst[hash], addr_lst) {
 		ndev = ifp->idev->dev;
-		if (!net_eq(dev_net(ndev), net))
-			continue;
 
 		if (l3mdev_master_dev_rcu(ndev) != l3mdev)
 			continue;
@@ -2025,9 +2018,7 @@ struct inet6_ifaddr *ipv6_get_ifaddr(struct net *net, const struct in6_addr *add
 	struct inet6_ifaddr *ifp, *result = NULL;
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(ifp, &inet6_addr_lst[hash], addr_lst) {
-		if (!net_eq(dev_net(ifp->idev->dev), net))
-			continue;
+	hlist_for_each_entry_rcu(ifp, &net->ipv6.inet6_addr_lst[hash], addr_lst) {
 		if (ipv6_addr_equal(&ifp->addr, addr)) {
 			if (!dev || ifp->idev->dev == dev ||
 			    !(ifp->scope&(IFA_LINK|IFA_HOST) || strict)) {
@@ -2094,7 +2085,7 @@ static int addrconf_dad_end(struct inet6_ifaddr *ifp)
 void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
 {
 	struct inet6_dev *idev = ifp->idev;
-	struct net *net = dev_net(ifp->idev->dev);
+	struct net *net = dev_net(idev->dev);
 
 	if (addrconf_dad_end(ifp)) {
 		in6_ifa_put(ifp);
@@ -3770,9 +3761,9 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 
 	/* Step 2: clear hash table */
 	for (i = 0; i < IN6_ADDR_HSIZE; i++) {
-		struct hlist_head *h = &inet6_addr_lst[i];
+		struct hlist_head *h = &net->ipv6.inet6_addr_lst[i];
 
-		spin_lock_bh(&addrconf_hash_lock);
+		spin_lock_bh(&net->ipv6.addrconf_hash_lock);
 restart:
 		hlist_for_each_entry_rcu(ifa, h, addr_lst) {
 			if (ifa->idev == idev) {
@@ -3788,7 +3779,7 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 				}
 			}
 		}
-		spin_unlock_bh(&addrconf_hash_lock);
+		spin_unlock_bh(&net->ipv6.addrconf_hash_lock);
 	}
 
 	write_lock_bh(&idev->lock);
@@ -4286,10 +4277,8 @@ static struct inet6_ifaddr *if6_get_first(struct seq_file *seq, loff_t pos)
 	}
 
 	for (; state->bucket < IN6_ADDR_HSIZE; ++state->bucket) {
-		hlist_for_each_entry_rcu(ifa, &inet6_addr_lst[state->bucket],
+		hlist_for_each_entry_rcu(ifa, &net->ipv6.inet6_addr_lst[state->bucket],
 					 addr_lst) {
-			if (!net_eq(dev_net(ifa->idev->dev), net))
-				continue;
 			/* sync with offset */
 			if (p < state->offset) {
 				p++;
@@ -4312,8 +4301,6 @@ static struct inet6_ifaddr *if6_get_next(struct seq_file *seq,
 	struct net *net = seq_file_net(seq);
 
 	hlist_for_each_entry_continue_rcu(ifa, addr_lst) {
-		if (!net_eq(dev_net(ifa->idev->dev), net))
-			continue;
 		state->offset++;
 		return ifa;
 	}
@@ -4321,9 +4308,7 @@ static struct inet6_ifaddr *if6_get_next(struct seq_file *seq,
 	state->offset = 0;
 	while (++state->bucket < IN6_ADDR_HSIZE) {
 		hlist_for_each_entry_rcu(ifa,
-				     &inet6_addr_lst[state->bucket], addr_lst) {
-			if (!net_eq(dev_net(ifa->idev->dev), net))
-				continue;
+				     &net->ipv6.inet6_addr_lst[state->bucket], addr_lst) {
 			return ifa;
 		}
 	}
@@ -4411,9 +4396,7 @@ int ipv6_chk_home_addr(struct net *net, const struct in6_addr *addr)
 	int ret = 0;
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(ifp, &inet6_addr_lst[hash], addr_lst) {
-		if (!net_eq(dev_net(ifp->idev->dev), net))
-			continue;
+	hlist_for_each_entry_rcu(ifp, &net->ipv6.inet6_addr_lst[hash], addr_lst) {
 		if (ipv6_addr_equal(&ifp->addr, addr) &&
 		    (ifp->flags & IFA_F_HOMEADDRESS)) {
 			ret = 1;
@@ -4451,9 +4434,7 @@ int ipv6_chk_rpl_srh_loop(struct net *net, const struct in6_addr *segs,
 		hash = inet6_addr_hash(net, addr);
 
 		hash_found = false;
-		hlist_for_each_entry_rcu(ifp, &inet6_addr_lst[hash], addr_lst) {
-			if (!net_eq(dev_net(ifp->idev->dev), net))
-				continue;
+		hlist_for_each_entry_rcu(ifp, &net->ipv6.inet6_addr_lst[hash], addr_lst) {
 
 			if (ipv6_addr_equal(&ifp->addr, addr)) {
 				hash_found = true;
@@ -4498,7 +4479,7 @@ static void addrconf_verify_rtnl(struct net *net)
 
 	for (i = 0; i < IN6_ADDR_HSIZE; i++) {
 restart:
-		hlist_for_each_entry_rcu_bh(ifp, &inet6_addr_lst[i], addr_lst) {
+		hlist_for_each_entry_rcu_bh(ifp, &net->ipv6.inet6_addr_lst[i], addr_lst) {
 			unsigned long age;
 
 			/* When setting preferred_lft to a value not zero or
@@ -7233,7 +7214,7 @@ static struct rtnl_af_ops inet6_ops __read_mostly = {
 int __init addrconf_init(void)
 {
 	struct inet6_dev *idev;
-	int i, err;
+	int err;
 
 	err = ipv6_addr_label_init();
 	if (err < 0) {
@@ -7280,9 +7261,6 @@ int __init addrconf_init(void)
 
 	ip6_route_init_special_entries();
 
-	for (i = 0; i < IN6_ADDR_HSIZE; i++)
-		INIT_HLIST_HEAD(&inet6_addr_lst[i]);
-
 	register_netdevice_notifier(&ipv6_dev_notf);
 
 	addrconf_verify(&init_net);
@@ -7343,7 +7321,6 @@ int __init addrconf_init(void)
 void addrconf_cleanup(void)
 {
 	struct net_device *dev;
-	int i;
 
 	unregister_netdevice_notifier(&ipv6_dev_notf);
 	unregister_pernet_subsys(&addrconf_ops);
@@ -7361,14 +7338,6 @@ void addrconf_cleanup(void)
 	}
 	addrconf_ifdown(init_net.loopback_dev, true);
 
-	/*
-	 *	Check hash table.
-	 */
-	spin_lock_bh(&addrconf_hash_lock);
-	for (i = 0; i < IN6_ADDR_HSIZE; i++)
-		WARN_ON(!hlist_empty(&inet6_addr_lst[i]));
-	spin_unlock_bh(&addrconf_hash_lock);
-
 	rtnl_unlock();
 
 	destroy_workqueue(addrconf_wq);
-- 
2.35.0.263.gb82422642f-goog

