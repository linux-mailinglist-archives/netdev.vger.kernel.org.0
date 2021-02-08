Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCD8313BE6
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhBHR62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbhBHRzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:55:36 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBACC06178C
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 09:54:55 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id g3so8243411plp.2
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 09:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1G74omdaQsQ2/mmAeXPu9UjWD9wFAQbtL5FxBsIfALA=;
        b=fTqtFq+marYNDUfImsYqesJ08IkqVWH2wHTrwATfcPux4etzzcuoWXExCWsT0EYNoF
         we3DkN0X/1Y2wB6y4dApumNMvUrmn0erSI8HZOywtTsGCLZGKeH9YdL02YgirQ+G9hog
         jmy3K9pg2/XX4EI9D07Qi5GKIhnjEVhwCQtKcUFnicBpSgh3XaKiQ5T6PWq71eUQxQnO
         +WHTHeSHVI0nAf0O+6X5FoKYtr0zHSNIlXrNbme30yaHEU2pddOIk2l0nW+O8TWAXPyc
         XkhhZGjw1CJHgYx/q9dZ7biHAMKFZuPl6a57K5LCO3Dj4v+9O4cFMvbXUjkuOXzdUI8S
         +aaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1G74omdaQsQ2/mmAeXPu9UjWD9wFAQbtL5FxBsIfALA=;
        b=Ka3PzzqnkMH4biZoSf/Bpml7+Hpn3dIy/aL3Xue5wnP6L1czagxaPCOi47QTJZBvfQ
         3vnDOmV+QZc5GD9pJwuIYxGxPIk+sHeYm4HKyKbIK85FKc4h79opqki6nMxjfzHrwCKA
         ReoLDLpkc5G5wkOr4egNfJiLpcHVU4x1gYfjKEdZSlU4qWJtqt3l/OWTGkVVlKTkN5vG
         cJP9G/Fhvj8sgoEYrFDkf4e63L/5anpPZ8+g211VBJh4ydlIRWv13sDfZx69s8raS1Hq
         kFEDMCDFcT2f3ASYpZ9IsMN4RxCljln34DDSR96zE3G/gt0Dsaecr/W8cWaYU8RxtGwr
         R9kA==
X-Gm-Message-State: AOAM5338DLLpEJKhN+xO7Z05zMukkkUBsZqe4NFzK/lRm4v+K8o25L+h
        GKZktQacjVNLQCSt46+qoxM=
X-Google-Smtp-Source: ABdhPJy3gRulY2HwMP+7/NfDnoVBWhu3K6aCvHDHK0i/2925SbmFlk0UBi02xzUS71KqX4Ehux4Cvw==
X-Received: by 2002:a17:902:d686:b029:de:7845:c0b2 with SMTP id v6-20020a170902d686b02900de7845c0b2mr17200090ply.11.1612806895300;
        Mon, 08 Feb 2021 09:54:55 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id hi15sm16926059pjb.19.2021.02.08.09.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 09:54:54 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, xiyou.wangcong@gmail.com
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 4/8] mld: convert from timer to delayed work
Date:   Mon,  8 Feb 2021 17:54:45 +0000
Message-Id: <20210208175445.5203-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mcast.c has several timers for delaying works.
Timer's expire handler is working under BH context so it can't use
sleepable things such as GFP_KERNEL, mutex, etc.
In order to use sleepable APIs, it converts from timers to delayed work.
But there are some critical sections, which is used by both process
and BH context. So that it still uses spin_lock_bh() and rwlock.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/net/if_inet6.h |   8 +--
 net/ipv6/mcast.c       | 141 ++++++++++++++++++++++++-----------------
 2 files changed, 86 insertions(+), 63 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index cd17b756a2a5..096c0554d199 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -120,7 +120,7 @@ struct ifmcaddr6 {
 	unsigned int		mca_sfmode;
 	unsigned char		mca_crcount;
 	unsigned long		mca_sfcount[2];
-	struct timer_list	mca_timer;
+	struct delayed_work	mca_work;
 	unsigned int		mca_flags;
 	int			mca_users;
 	refcount_t		mca_refcnt;
@@ -178,9 +178,9 @@ struct inet6_dev {
 	unsigned long		mc_qri;		/* Query Response Interval */
 	unsigned long		mc_maxdelay;
 
-	struct timer_list	mc_gq_timer;	/* general query timer */
-	struct timer_list	mc_ifc_timer;	/* interface change timer */
-	struct timer_list	mc_dad_timer;	/* dad complete mc timer */
+	struct delayed_work	mc_gq_work;	/* general query work */
+	struct delayed_work	mc_ifc_work;	/* interface change work */
+	struct delayed_work	mc_dad_work;	/* dad complete mc work */
 
 	struct ifacaddr6	*ac_list;
 	rwlock_t		lock;
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 45a983ed091e..ed31b3212b9e 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -29,7 +29,6 @@
 #include <linux/socket.h>
 #include <linux/sockios.h>
 #include <linux/jiffies.h>
-#include <linux/times.h>
 #include <linux/net.h>
 #include <linux/in.h>
 #include <linux/in6.h>
@@ -42,6 +41,7 @@
 #include <linux/slab.h>
 #include <linux/pkt_sched.h>
 #include <net/mld.h>
+#include <linux/workqueue.h>
 
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv6.h>
@@ -67,11 +67,12 @@ static int __mld2_query_bugs[] __attribute__((__unused__)) = {
 	BUILD_BUG_ON_ZERO(offsetof(struct mld2_grec, grec_mca) % 4)
 };
 
+static struct workqueue_struct *mld_wq;
 static struct in6_addr mld2_all_mcr = MLD2_ALL_MCR_INIT;
 
 static void igmp6_join_group(struct ifmcaddr6 *mc);
 static void igmp6_leave_group(struct ifmcaddr6 *mc);
-static void igmp6_timer_handler(struct timer_list *t);
+static void mld_mca_work(struct work_struct *work);
 
 static void mld_ifc_event(struct inet6_dev *idev);
 static bool mld_in_v1_mode(const struct inet6_dev *idev);
@@ -722,7 +723,7 @@ static void igmp6_group_dropped(struct ifmcaddr6 *mc)
 		igmp6_leave_group(mc);
 
 	spin_lock_bh(&mc->mca_lock);
-	if (del_timer(&mc->mca_timer))
+	if (cancel_delayed_work(&mc->mca_work))
 		mca_put(mc);
 	spin_unlock_bh(&mc->mca_lock);
 }
@@ -850,7 +851,7 @@ static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 	if (!mc)
 		return NULL;
 
-	timer_setup(&mc->mca_timer, igmp6_timer_handler, 0);
+	INIT_DELAYED_WORK(&mc->mca_work, mld_mca_work);
 
 	mc->mca_addr = *addr;
 	mc->idev = idev; /* reference taken by caller */
@@ -1030,48 +1031,51 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 	return rv;
 }
 
-static void mld_gq_start_timer(struct inet6_dev *idev)
+static void mld_gq_start_work(struct inet6_dev *idev)
 {
 	unsigned long tv = prandom_u32() % idev->mc_maxdelay;
 
 	idev->mc_gq_running = 1;
-	if (!mod_timer(&idev->mc_gq_timer, jiffies+tv+2))
+	if (!mod_delayed_work(mld_wq, &idev->mc_gq_work,
+			      msecs_to_jiffies(tv + 2)))
 		in6_dev_hold(idev);
 }
 
-static void mld_gq_stop_timer(struct inet6_dev *idev)
+static void mld_gq_stop_work(struct inet6_dev *idev)
 {
 	idev->mc_gq_running = 0;
-	if (del_timer(&idev->mc_gq_timer))
+	if (cancel_delayed_work(&idev->mc_gq_work))
 		__in6_dev_put(idev);
 }
 
-static void mld_ifc_start_timer(struct inet6_dev *idev, unsigned long delay)
+static void mld_ifc_start_work(struct inet6_dev *idev, unsigned long delay)
 {
 	unsigned long tv = prandom_u32() % delay;
 
-	if (!mod_timer(&idev->mc_ifc_timer, jiffies+tv+2))
+	if (!mod_delayed_work(mld_wq, &idev->mc_ifc_work,
+			      msecs_to_jiffies(tv + 2)))
 		in6_dev_hold(idev);
 }
 
-static void mld_ifc_stop_timer(struct inet6_dev *idev)
+static void mld_ifc_stop_work(struct inet6_dev *idev)
 {
 	idev->mc_ifc_count = 0;
-	if (del_timer(&idev->mc_ifc_timer))
+	if (cancel_delayed_work(&idev->mc_ifc_work))
 		__in6_dev_put(idev);
 }
 
-static void mld_dad_start_timer(struct inet6_dev *idev, unsigned long delay)
+static void mld_dad_start_work(struct inet6_dev *idev, unsigned long delay)
 {
 	unsigned long tv = prandom_u32() % delay;
 
-	if (!mod_timer(&idev->mc_dad_timer, jiffies+tv+2))
+	if (!mod_delayed_work(mld_wq, &idev->mc_dad_work,
+			      msecs_to_jiffies(tv + 2)))
 		in6_dev_hold(idev);
 }
 
-static void mld_dad_stop_timer(struct inet6_dev *idev)
+static void mld_dad_stop_work(struct inet6_dev *idev)
 {
-	if (del_timer(&idev->mc_dad_timer))
+	if (cancel_delayed_work(&idev->mc_dad_work))
 		__in6_dev_put(idev);
 }
 
@@ -1083,21 +1087,21 @@ static void igmp6_group_queried(struct ifmcaddr6 *mc, unsigned long resptime)
 {
 	unsigned long delay = resptime;
 
-	/* Do not start timer for these addresses */
+	/* Do not start work for these addresses */
 	if (ipv6_addr_is_ll_all_nodes(&mc->mca_addr) ||
 	    IPV6_ADDR_MC_SCOPE(&mc->mca_addr) < IPV6_ADDR_SCOPE_LINKLOCAL)
 		return;
 
-	if (del_timer(&mc->mca_timer)) {
+	if (cancel_delayed_work(&mc->mca_work)) {
 		mca_put(mc);
-		delay = mc->mca_timer.expires - jiffies;
+		delay = mc->mca_work.timer.expires - jiffies;
 	}
 
 	if (delay >= resptime)
 		delay = prandom_u32() % resptime;
 
-	mc->mca_timer.expires = jiffies + delay;
-	if (!mod_timer(&mc->mca_timer, jiffies + delay))
+	if (!mod_delayed_work(mld_wq, &mc->mca_work,
+			      msecs_to_jiffies(delay)))
 		mca_get(mc);
 	mc->mca_flags |= MAF_TIMER_RUNNING;
 }
@@ -1308,10 +1312,10 @@ static int mld_process_v1(struct inet6_dev *idev, struct mld_msg *mld,
 	if (v1_query)
 		mld_set_v1_mode(idev);
 
-	/* cancel MLDv2 report timer */
-	mld_gq_stop_timer(idev);
-	/* cancel the interface change timer */
-	mld_ifc_stop_timer(idev);
+	/* cancel MLDv2 report work */
+	mld_gq_stop_work(idev);
+	/* cancel the interface change work */
+	mld_ifc_stop_work(idev);
 	/* clear deleted report items */
 	mld_clear_delrec(idev);
 
@@ -1401,7 +1405,7 @@ int igmp6_event_query(struct sk_buff *skb)
 			if (mlh2->mld2q_nsrcs)
 				return -EINVAL; /* no sources allowed */
 
-			mld_gq_start_timer(idev);
+			mld_gq_start_work(idev);
 			return 0;
 		}
 		/* mark sources to include, if group & source-specific */
@@ -1485,14 +1489,14 @@ int igmp6_event_report(struct sk_buff *skb)
 		return -ENODEV;
 
 	/*
-	 *	Cancel the timer for this group
+	 *	Cancel the work for this group
 	 */
 
 	read_lock_bh(&idev->lock);
 	list_for_each_entry(mc, &idev->mc_list, list) {
 		if (ipv6_addr_equal(&mc->mca_addr, &mld->mld_mca)) {
 			spin_lock(&mc->mca_lock);
-			if (del_timer(&mc->mca_timer))
+			if (cancel_delayed_work(&mc->mca_work))
 				mca_put(mc);
 			mc->mca_flags &= ~(MAF_LAST_REPORTER | MAF_TIMER_RUNNING);
 			spin_unlock(&mc->mca_lock);
@@ -2109,21 +2113,23 @@ void ipv6_mc_dad_complete(struct inet6_dev *idev)
 		mld_send_initial_cr(idev);
 		idev->mc_dad_count--;
 		if (idev->mc_dad_count)
-			mld_dad_start_timer(idev,
-					    unsolicited_report_interval(idev));
+			mld_dad_start_work(idev,
+					   unsolicited_report_interval(idev));
 	}
 }
 
-static void mld_dad_timer_expire(struct timer_list *t)
+static void mld_dad_work(struct work_struct *work)
 {
-	struct inet6_dev *idev = from_timer(idev, t, mc_dad_timer);
+	struct inet6_dev *idev = container_of(to_delayed_work(work),
+					      struct inet6_dev,
+					      mc_dad_work);
 
 	mld_send_initial_cr(idev);
 	if (idev->mc_dad_count) {
 		idev->mc_dad_count--;
 		if (idev->mc_dad_count)
-			mld_dad_start_timer(idev,
-					    unsolicited_report_interval(idev));
+			mld_dad_start_work(idev,
+					   unsolicited_report_interval(idev));
 	}
 	in6_dev_put(idev);
 }
@@ -2445,12 +2451,13 @@ static void igmp6_join_group(struct ifmcaddr6 *mc)
 	delay = prandom_u32() % unsolicited_report_interval(mc->idev);
 
 	spin_lock_bh(&mc->mca_lock);
-	if (del_timer(&mc->mca_timer)) {
+	if (cancel_delayed_work(&mc->mca_work)) {
 		mca_put(mc);
-		delay = mc->mca_timer.expires - jiffies;
+		delay = mc->mca_work.timer.expires - jiffies;
 	}
 
-	if (!mod_timer(&mc->mca_timer, jiffies + delay))
+	if (!mod_delayed_work(mld_wq, &mc->mca_work,
+			      msecs_to_jiffies(delay)))
 		mca_get(mc);
 	mc->mca_flags |= MAF_TIMER_RUNNING | MAF_LAST_REPORTER;
 	spin_unlock_bh(&mc->mca_lock);
@@ -2487,25 +2494,27 @@ static void igmp6_leave_group(struct ifmcaddr6 *mc)
 	}
 }
 
-static void mld_gq_timer_expire(struct timer_list *t)
+static void mld_gq_work(struct work_struct *work)
 {
-	struct inet6_dev *idev = from_timer(idev, t, mc_gq_timer);
+	struct inet6_dev *idev = container_of(to_delayed_work(work),
+					      struct inet6_dev, mc_gq_work);
 
 	idev->mc_gq_running = 0;
 	mld_send_report(idev, NULL);
 	in6_dev_put(idev);
 }
 
-static void mld_ifc_timer_expire(struct timer_list *t)
+static void mld_ifc_work(struct work_struct *work)
 {
-	struct inet6_dev *idev = from_timer(idev, t, mc_ifc_timer);
+	struct inet6_dev *idev = container_of(to_delayed_work(work),
+					      struct inet6_dev, mc_ifc_work);
 
 	mld_send_cr(idev);
 	if (idev->mc_ifc_count) {
 		idev->mc_ifc_count--;
 		if (idev->mc_ifc_count)
-			mld_ifc_start_timer(idev,
-					    unsolicited_report_interval(idev));
+			mld_ifc_start_work(idev,
+					   unsolicited_report_interval(idev));
 	}
 	in6_dev_put(idev);
 }
@@ -2515,22 +2524,23 @@ static void mld_ifc_event(struct inet6_dev *idev)
 	if (mld_in_v1_mode(idev))
 		return;
 	idev->mc_ifc_count = idev->mc_qrv;
-	mld_ifc_start_timer(idev, 1);
+	mld_ifc_start_work(idev, 1);
 }
 
-static void igmp6_timer_handler(struct timer_list *t)
+static void mld_mca_work(struct work_struct *work)
 {
-	struct ifmcaddr6 *mc = from_timer(mc, t, mca_timer);
+	struct ifmcaddr6 *mc = container_of(to_delayed_work(work),
+					    struct ifmcaddr6, mca_work);
 
 	if (mld_in_v1_mode(mc->idev))
 		igmp6_send(&mc->mca_addr, mc->idev->dev, ICMPV6_MGM_REPORT);
 	else
 		mld_send_report(mc->idev, mc);
 
-	spin_lock(&mc->mca_lock);
+	spin_lock_bh(&mc->mca_lock);
 	mc->mca_flags |=  MAF_LAST_REPORTER;
 	mc->mca_flags &= ~MAF_TIMER_RUNNING;
-	spin_unlock(&mc->mca_lock);
+	spin_unlock_bh(&mc->mca_lock);
 	mca_put(mc);
 }
 
@@ -2566,12 +2576,12 @@ void ipv6_mc_down(struct inet6_dev *idev)
 	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list)
 		igmp6_group_dropped(mc);
 
-	/* Should stop timer after group drop. or we will
-	 * start timer again in mld_ifc_event()
+	/* Should stop work after group drop. or we will
+	 * start work again in mld_ifc_event()
 	 */
-	mld_ifc_stop_timer(idev);
-	mld_gq_stop_timer(idev);
-	mld_dad_stop_timer(idev);
+	mld_ifc_stop_work(idev);
+	mld_gq_stop_work(idev);
+	mld_dad_stop_work(idev);
 	read_unlock_bh(&idev->lock);
 }
 
@@ -2608,12 +2618,12 @@ void ipv6_mc_init_dev(struct inet6_dev *idev)
 	write_lock_bh(&idev->lock);
 	spin_lock_init(&idev->mc_tomb_lock);
 	idev->mc_gq_running = 0;
-	timer_setup(&idev->mc_gq_timer, mld_gq_timer_expire, 0);
+	INIT_DELAYED_WORK(&idev->mc_gq_work, mld_gq_work);
 	INIT_LIST_HEAD(&idev->mc_tomb_list);
 	INIT_LIST_HEAD(&idev->mc_list);
 	idev->mc_ifc_count = 0;
-	timer_setup(&idev->mc_ifc_timer, mld_ifc_timer_expire, 0);
-	timer_setup(&idev->mc_dad_timer, mld_dad_timer_expire, 0);
+	INIT_DELAYED_WORK(&idev->mc_ifc_work, mld_ifc_work);
+	INIT_DELAYED_WORK(&idev->mc_dad_work, mld_dad_work);
 	ipv6_mc_reset(idev);
 	write_unlock_bh(&idev->lock);
 }
@@ -2626,7 +2636,7 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *mc, *tmp;
 
-	/* Deactivate timers */
+	/* Deactivate works */
 	ipv6_mc_down(idev);
 	mld_clear_delrec(idev);
 
@@ -2799,7 +2809,7 @@ static int igmp6_mc_seq_show(struct seq_file *seq, void *v)
 		   &mc->mca_addr,
 		   mc->mca_users, mc->mca_flags,
 		   (mc->mca_flags & MAF_TIMER_RUNNING) ?
-		   jiffies_to_clock_t(mc->mca_timer.expires - jiffies) : 0);
+		   jiffies_to_clock_t(mc->mca_work.timer.expires - jiffies) : 0);
 	return 0;
 }
 
@@ -3062,7 +3072,19 @@ static struct pernet_operations igmp6_net_ops = {
 
 int __init igmp6_init(void)
 {
-	return register_pernet_subsys(&igmp6_net_ops);
+	int err;
+
+	err = register_pernet_subsys(&igmp6_net_ops);
+	if (err)
+		return err;
+
+	mld_wq = create_workqueue("mld");
+	if (!mld_wq) {
+		unregister_pernet_subsys(&igmp6_net_ops);
+		return -ENOMEM;
+	}
+
+	return err;
 }
 
 int __init igmp6_late_init(void)
@@ -3073,6 +3095,7 @@ int __init igmp6_late_init(void)
 void igmp6_cleanup(void)
 {
 	unregister_pernet_subsys(&igmp6_net_ops);
+	destroy_workqueue(mld_wq);
 }
 
 void igmp6_late_cleanup(void)
-- 
2.17.1

