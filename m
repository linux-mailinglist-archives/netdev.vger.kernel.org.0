Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1170A31AD74
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhBMRwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhBMRw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 12:52:28 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A77C061794
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:51:18 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id e9so1451950pjj.0
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O0go3ge/KxqBJRP2Lv98y/9NQktoO2Bv2W4Gj6Xz920=;
        b=rGEmDFflWNeyDh7klT0KtfB8azO5y6d7sUxx5npjzeTIP3Dzr66bpbO9UvYt9FjkrN
         TwThBs9ouAJBI6Sr7BCUKi49bQua/m+vQ7o7R3n8YJ8oMzQ8q8oPl1bFmNLXnP4COWiF
         upR7TnzmK6JlkUa33jxEol/wXzBDkLAtuf2e1qNjabzVwNnKNJJTfQiVLvmrHVA097MO
         wcCHr98rdLlCadOaybDZVFtaur0j0CWsBC3Ymg4kgIN/TTs6ubxsBuBVYfia10ovbH70
         MtVwkF+F8/10X88NH0Z7CGZEpJzzjeJU4QSPZ888xNgI/MS9bYxISOXI/6l6DcCdhf0+
         ys+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O0go3ge/KxqBJRP2Lv98y/9NQktoO2Bv2W4Gj6Xz920=;
        b=oRFUs9txAz/Ep/9ZBqpQk3Z1v7tMXN/zsi5aehSbn0pYzKfuuaMWdH6yc6gAN+N6p+
         v90WT6pDzrn5ZIJX7RnJs1eR+8BHwTzRPd2N2wELGGPCz8wYuXu4ei0GQpHW3ROYK/BI
         o5sdHEdAbWO6q0T5o7ljvGcCmkHVEl4htBtN7W6x4Gu9jUBLeg+JtyAQ4zCIjrIkcFAg
         VyL0Sq87k3yUOoj+c399bUpKCsS/iSxeiZHNcNWoV39P1vfLEVg5RV0NY55zf0H4DkKC
         yoQxQORV4qUe4iCZUdjgq2X00tYArdbQFlI+t8HMnCa8Zu8RiawrvGr5LmRoa/LIplkl
         D4Sg==
X-Gm-Message-State: AOAM530w5SgpEzaDoLvLqpJ3TE+tFzUJAQsM5O6vsINHwosNOOFdnQbb
        5CGByslEaPLwdWdDWOKDeck=
X-Google-Smtp-Source: ABdhPJz8mBo3RzpCtzgPflI/2vY5iRzbLHVbYu+D2+QH/yflgskTPkb9VVmQywzWAdvXA2HZhZQx+w==
X-Received: by 2002:a17:90b:46c5:: with SMTP id jx5mr7929921pjb.27.1613238677460;
        Sat, 13 Feb 2021 09:51:17 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 16sm11181894pjc.28.2021.02.13.09.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 09:51:16 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH net-next v2 1/7] mld: convert from timer to delayed work
Date:   Sat, 13 Feb 2021 17:51:02 +0000
Message-Id: <20210213175102.28227-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mcast.c has several timers for delaying works.
Timer's expire handler is working under atomic context so it can't use
sleepable things such as GFP_KERNEL, mutex, etc.
In order to use sleepable APIs, it converts from timers to delayed work.
But there are some critical sections, which is used by both process
and BH context. So that it still uses spin_lock_bh() and rwlock.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - Separated from previous big one patch.

 include/net/if_inet6.h |   8 +--
 net/ipv6/mcast.c       | 148 ++++++++++++++++++++++++-----------------
 2 files changed, 91 insertions(+), 65 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 8bf5906073bc..af5244c9ca5c 100644
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
@@ -179,9 +179,9 @@ struct inet6_dev {
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
index 6c8604390266..80597dc56f2a 100644
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
@@ -67,14 +67,13 @@ static int __mld2_query_bugs[] __attribute__((__unused__)) = {
 	BUILD_BUG_ON_ZERO(offsetof(struct mld2_grec, grec_mca) % 4)
 };
 
+static struct workqueue_struct *mld_wq;
 static struct in6_addr mld2_all_mcr = MLD2_ALL_MCR_INIT;
 
 static void igmp6_join_group(struct ifmcaddr6 *ma);
 static void igmp6_leave_group(struct ifmcaddr6 *ma);
-static void igmp6_timer_handler(struct timer_list *t);
+static void mld_mca_work(struct work_struct *work);
 
-static void mld_gq_timer_expire(struct timer_list *t);
-static void mld_ifc_timer_expire(struct timer_list *t);
 static void mld_ifc_event(struct inet6_dev *idev);
 static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *pmc);
 static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *pmc);
@@ -713,7 +712,7 @@ static void igmp6_group_dropped(struct ifmcaddr6 *mc)
 		igmp6_leave_group(mc);
 
 	spin_lock_bh(&mc->mca_lock);
-	if (del_timer(&mc->mca_timer))
+	if (cancel_delayed_work(&mc->mca_work))
 		refcount_dec(&mc->mca_refcnt);
 	spin_unlock_bh(&mc->mca_lock);
 }
@@ -854,7 +853,7 @@ static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 	if (!mc)
 		return NULL;
 
-	timer_setup(&mc->mca_timer, igmp6_timer_handler, 0);
+	INIT_DELAYED_WORK(&mc->mca_work, mld_mca_work);
 
 	mc->mca_addr = *addr;
 	mc->idev = idev; /* reference taken by caller */
@@ -1027,48 +1026,48 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 	return rv;
 }
 
-static void mld_gq_start_timer(struct inet6_dev *idev)
+static void mld_gq_start_work(struct inet6_dev *idev)
 {
 	unsigned long tv = prandom_u32() % idev->mc_maxdelay;
 
 	idev->mc_gq_running = 1;
-	if (!mod_timer(&idev->mc_gq_timer, jiffies+tv+2))
+	if (!mod_delayed_work(mld_wq, &idev->mc_gq_work, msecs_to_jiffies(tv + 2)))
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
+	if (!mod_delayed_work(mld_wq, &idev->mc_ifc_work, msecs_to_jiffies(tv + 2)))
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
+	if (!mod_delayed_work(mld_wq, &idev->mc_dad_work, msecs_to_jiffies(tv + 2)))
 		in6_dev_hold(idev);
 }
 
-static void mld_dad_stop_timer(struct inet6_dev *idev)
+static void mld_dad_stop_work(struct inet6_dev *idev)
 {
-	if (del_timer(&idev->mc_dad_timer))
+	if (cancel_delayed_work(&idev->mc_dad_work))
 		__in6_dev_put(idev);
 }
 
@@ -1080,21 +1079,20 @@ static void igmp6_group_queried(struct ifmcaddr6 *ma, unsigned long resptime)
 {
 	unsigned long delay = resptime;
 
-	/* Do not start timer for these addresses */
+	/* Do not start work for these addresses */
 	if (ipv6_addr_is_ll_all_nodes(&ma->mca_addr) ||
 	    IPV6_ADDR_MC_SCOPE(&ma->mca_addr) < IPV6_ADDR_SCOPE_LINKLOCAL)
 		return;
 
-	if (del_timer(&ma->mca_timer)) {
+	if (cancel_delayed_work(&ma->mca_work)) {
 		refcount_dec(&ma->mca_refcnt);
-		delay = ma->mca_timer.expires - jiffies;
+		delay = ma->mca_work.timer.expires - jiffies;
 	}
 
 	if (delay >= resptime)
 		delay = prandom_u32() % resptime;
 
-	ma->mca_timer.expires = jiffies + delay;
-	if (!mod_timer(&ma->mca_timer, jiffies + delay))
+	if (!mod_delayed_work(mld_wq, &ma->mca_work, msecs_to_jiffies(delay)))
 		refcount_inc(&ma->mca_refcnt);
 	ma->mca_flags |= MAF_TIMER_RUNNING;
 }
@@ -1305,10 +1303,10 @@ static int mld_process_v1(struct inet6_dev *idev, struct mld_msg *mld,
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
 
@@ -1398,7 +1396,7 @@ int igmp6_event_query(struct sk_buff *skb)
 			if (mlh2->mld2q_nsrcs)
 				return -EINVAL; /* no sources allowed */
 
-			mld_gq_start_timer(idev);
+			mld_gq_start_work(idev);
 			return 0;
 		}
 		/* mark sources to include, if group & source-specific */
@@ -1482,14 +1480,14 @@ int igmp6_event_report(struct sk_buff *skb)
 		return -ENODEV;
 
 	/*
-	 *	Cancel the timer for this group
+	 *	Cancel the work for this group
 	 */
 
 	read_lock_bh(&idev->lock);
 	for (ma = idev->mc_list; ma; ma = ma->next) {
 		if (ipv6_addr_equal(&ma->mca_addr, &mld->mld_mca)) {
 			spin_lock(&ma->mca_lock);
-			if (del_timer(&ma->mca_timer))
+			if (cancel_delayed_work(&ma->mca_work))
 				refcount_dec(&ma->mca_refcnt);
 			ma->mca_flags &= ~(MAF_LAST_REPORTER|MAF_TIMER_RUNNING);
 			spin_unlock(&ma->mca_lock);
@@ -2103,22 +2101,26 @@ void ipv6_mc_dad_complete(struct inet6_dev *idev)
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
 
+	rtnl_lock();
 	mld_send_initial_cr(idev);
 	if (idev->mc_dad_count) {
 		idev->mc_dad_count--;
 		if (idev->mc_dad_count)
-			mld_dad_start_timer(idev,
-					    unsolicited_report_interval(idev));
+			mld_dad_start_work(idev,
+					   unsolicited_report_interval(idev));
 	}
+	rtnl_unlock();
 	in6_dev_put(idev);
 }
 
@@ -2416,12 +2418,12 @@ static void igmp6_join_group(struct ifmcaddr6 *ma)
 	delay = prandom_u32() % unsolicited_report_interval(ma->idev);
 
 	spin_lock_bh(&ma->mca_lock);
-	if (del_timer(&ma->mca_timer)) {
+	if (cancel_delayed_work(&ma->mca_work)) {
 		refcount_dec(&ma->mca_refcnt);
-		delay = ma->mca_timer.expires - jiffies;
+		delay = ma->mca_work.timer.expires - jiffies;
 	}
 
-	if (!mod_timer(&ma->mca_timer, jiffies + delay))
+	if (!mod_delayed_work(mld_wq, &ma->mca_work, msecs_to_jiffies(delay)))
 		refcount_inc(&ma->mca_refcnt);
 	ma->mca_flags |= MAF_TIMER_RUNNING | MAF_LAST_REPORTER;
 	spin_unlock_bh(&ma->mca_lock);
@@ -2458,26 +2460,34 @@ static void igmp6_leave_group(struct ifmcaddr6 *ma)
 	}
 }
 
-static void mld_gq_timer_expire(struct timer_list *t)
+static void mld_gq_work(struct work_struct *work)
 {
-	struct inet6_dev *idev = from_timer(idev, t, mc_gq_timer);
+	struct inet6_dev *idev = container_of(to_delayed_work(work),
+					      struct inet6_dev,
+					      mc_gq_work);
 
 	idev->mc_gq_running = 0;
+	rtnl_lock();
 	mld_send_report(idev, NULL);
+	rtnl_unlock();
 	in6_dev_put(idev);
 }
 
-static void mld_ifc_timer_expire(struct timer_list *t)
+static void mld_ifc_work(struct work_struct *work)
 {
-	struct inet6_dev *idev = from_timer(idev, t, mc_ifc_timer);
+	struct inet6_dev *idev = container_of(to_delayed_work(work),
+					      struct inet6_dev,
+					      mc_ifc_work);
 
+	rtnl_lock();
 	mld_send_cr(idev);
 	if (idev->mc_ifc_count) {
 		idev->mc_ifc_count--;
 		if (idev->mc_ifc_count)
-			mld_ifc_start_timer(idev,
-					    unsolicited_report_interval(idev));
+			mld_ifc_start_work(idev,
+					   unsolicited_report_interval(idev));
 	}
+	rtnl_unlock();
 	in6_dev_put(idev);
 }
 
@@ -2486,22 +2496,25 @@ static void mld_ifc_event(struct inet6_dev *idev)
 	if (mld_in_v1_mode(idev))
 		return;
 	idev->mc_ifc_count = idev->mc_qrv;
-	mld_ifc_start_timer(idev, 1);
+	mld_ifc_start_work(idev, 1);
 }
 
-static void igmp6_timer_handler(struct timer_list *t)
+static void mld_mca_work(struct work_struct *work)
 {
-	struct ifmcaddr6 *ma = from_timer(ma, t, mca_timer);
+	struct ifmcaddr6 *ma = container_of(to_delayed_work(work),
+					    struct ifmcaddr6, mca_work);
 
+	rtnl_lock();
 	if (mld_in_v1_mode(ma->idev))
 		igmp6_send(&ma->mca_addr, ma->idev->dev, ICMPV6_MGM_REPORT);
 	else
 		mld_send_report(ma->idev, ma);
+	rtnl_unlock();
 
-	spin_lock(&ma->mca_lock);
+	spin_lock_bh(&ma->mca_lock);
 	ma->mca_flags |=  MAF_LAST_REPORTER;
 	ma->mca_flags &= ~MAF_TIMER_RUNNING;
-	spin_unlock(&ma->mca_lock);
+	spin_unlock_bh(&ma->mca_lock);
 	ma_put(ma);
 }
 
@@ -2537,12 +2550,12 @@ void ipv6_mc_down(struct inet6_dev *idev)
 	for (i = idev->mc_list; i; i = i->next)
 		igmp6_group_dropped(i);
 
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
 
@@ -2579,11 +2592,11 @@ void ipv6_mc_init_dev(struct inet6_dev *idev)
 	write_lock_bh(&idev->lock);
 	spin_lock_init(&idev->mc_lock);
 	idev->mc_gq_running = 0;
-	timer_setup(&idev->mc_gq_timer, mld_gq_timer_expire, 0);
+	INIT_DELAYED_WORK(&idev->mc_gq_work, mld_gq_work);
 	idev->mc_tomb = NULL;
 	idev->mc_ifc_count = 0;
-	timer_setup(&idev->mc_ifc_timer, mld_ifc_timer_expire, 0);
-	timer_setup(&idev->mc_dad_timer, mld_dad_timer_expire, 0);
+	INIT_DELAYED_WORK(&idev->mc_ifc_work, mld_ifc_work);
+	INIT_DELAYED_WORK(&idev->mc_dad_work, mld_dad_work);
 	ipv6_mc_reset(idev);
 	write_unlock_bh(&idev->lock);
 }
@@ -2596,7 +2609,7 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *i;
 
-	/* Deactivate timers */
+	/* Deactivate works */
 	ipv6_mc_down(idev);
 	mld_clear_delrec(idev);
 
@@ -2763,7 +2776,7 @@ static int igmp6_mc_seq_show(struct seq_file *seq, void *v)
 		   &im->mca_addr,
 		   im->mca_users, im->mca_flags,
 		   (im->mca_flags&MAF_TIMER_RUNNING) ?
-		   jiffies_to_clock_t(im->mca_timer.expires-jiffies) : 0);
+		   jiffies_to_clock_t(im->mca_work.timer.expires - jiffies) : 0);
 	return 0;
 }
 
@@ -3002,7 +3015,19 @@ static struct pernet_operations igmp6_net_ops = {
 
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
@@ -3013,6 +3038,7 @@ int __init igmp6_late_init(void)
 void igmp6_cleanup(void)
 {
 	unregister_pernet_subsys(&igmp6_net_ops);
+	destroy_workqueue(mld_wq);
 }
 
 void igmp6_late_cleanup(void)
-- 
2.17.1

