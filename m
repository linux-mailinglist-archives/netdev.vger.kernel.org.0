Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE93218ED6
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgGHRrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:47:04 -0400
Received: from correo.us.es ([193.147.175.20]:34754 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728519AbgGHRqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:46:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A668E3066A8
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9405EDA797
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 87AD4DA791; Wed,  8 Jul 2020 19:46:22 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44A9ADA78E;
        Wed,  8 Jul 2020 19:46:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jul 2020 19:46:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 14AB24265A2F;
        Wed,  8 Jul 2020 19:46:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 04/12] ipvs: avoid expiring many connections from timer
Date:   Wed,  8 Jul 2020 19:46:01 +0200
Message-Id: <20200708174609.1343-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200708174609.1343-1-pablo@netfilter.org>
References: <20200708174609.1343-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

Add new functions ip_vs_conn_del() and ip_vs_conn_del_put()
to release many IPVS connections in process context.
They are suitable for connections found in table
when we do not want to overload the timers.

Currently, the change is useful for the dropentry delayed
work but it will be used also in following patch
when flushing connections to failed destinations.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 53 +++++++++++++++++++++++----------
 net/netfilter/ipvs/ip_vs_ctl.c  |  6 ++--
 2 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 02f2f636798d..b3921ae92740 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -807,6 +807,31 @@ static void ip_vs_conn_rcu_free(struct rcu_head *head)
 	kmem_cache_free(ip_vs_conn_cachep, cp);
 }
 
+/* Try to delete connection while not holding reference */
+static void ip_vs_conn_del(struct ip_vs_conn *cp)
+{
+	if (del_timer(&cp->timer)) {
+		/* Drop cp->control chain too */
+		if (cp->control)
+			cp->timeout = 0;
+		ip_vs_conn_expire(&cp->timer);
+	}
+}
+
+/* Try to delete connection while holding reference */
+static void ip_vs_conn_del_put(struct ip_vs_conn *cp)
+{
+	if (del_timer(&cp->timer)) {
+		/* Drop cp->control chain too */
+		if (cp->control)
+			cp->timeout = 0;
+		__ip_vs_conn_put(cp);
+		ip_vs_conn_expire(&cp->timer);
+	} else {
+		__ip_vs_conn_put(cp);
+	}
+}
+
 static void ip_vs_conn_expire(struct timer_list *t)
 {
 	struct ip_vs_conn *cp = from_timer(cp, t, timer);
@@ -827,14 +852,17 @@ static void ip_vs_conn_expire(struct timer_list *t)
 
 		/* does anybody control me? */
 		if (ct) {
+			bool has_ref = !cp->timeout && __ip_vs_conn_get(ct);
+
 			ip_vs_control_del(cp);
 			/* Drop CTL or non-assured TPL if not used anymore */
-			if (!cp->timeout && !atomic_read(&ct->n_control) &&
+			if (has_ref && !atomic_read(&ct->n_control) &&
 			    (!(ct->flags & IP_VS_CONN_F_TEMPLATE) ||
 			     !(ct->state & IP_VS_CTPL_S_ASSURED))) {
 				IP_VS_DBG(4, "drop controlling connection\n");
-				ct->timeout = 0;
-				ip_vs_conn_expire_now(ct);
+				ip_vs_conn_del_put(ct);
+			} else if (has_ref) {
+				__ip_vs_conn_put(ct);
 			}
 		}
 
@@ -1317,8 +1345,7 @@ void ip_vs_random_dropentry(struct netns_ipvs *ipvs)
 
 drop:
 			IP_VS_DBG(4, "drop connection\n");
-			cp->timeout = 0;
-			ip_vs_conn_expire_now(cp);
+			ip_vs_conn_del(cp);
 		}
 		cond_resched_rcu();
 	}
@@ -1341,19 +1368,15 @@ static void ip_vs_conn_flush(struct netns_ipvs *ipvs)
 		hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
 			if (cp->ipvs != ipvs)
 				continue;
-			/* As timers are expired in LIFO order, restart
-			 * the timer of controlling connection first, so
-			 * that it is expired after us.
-			 */
+			if (atomic_read(&cp->n_control))
+				continue;
 			cp_c = cp->control;
-			/* cp->control is valid only with reference to cp */
-			if (cp_c && __ip_vs_conn_get(cp)) {
+			IP_VS_DBG(4, "del connection\n");
+			ip_vs_conn_del(cp);
+			if (cp_c && !atomic_read(&cp_c->n_control)) {
 				IP_VS_DBG(4, "del controlling connection\n");
-				ip_vs_conn_expire_now(cp_c);
-				__ip_vs_conn_put(cp);
+				ip_vs_conn_del(cp_c);
 			}
-			IP_VS_DBG(4, "del connection\n");
-			ip_vs_conn_expire_now(cp);
 		}
 		cond_resched_rcu();
 	}
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 0eed388c960b..4af83f466dfc 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -224,7 +224,8 @@ static void defense_work_handler(struct work_struct *work)
 	update_defense_level(ipvs);
 	if (atomic_read(&ipvs->dropentry))
 		ip_vs_random_dropentry(ipvs);
-	schedule_delayed_work(&ipvs->defense_work, DEFENSE_TIMER_PERIOD);
+	queue_delayed_work(system_long_wq, &ipvs->defense_work,
+			   DEFENSE_TIMER_PERIOD);
 }
 #endif
 
@@ -4082,7 +4083,8 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	ipvs->sysctl_tbl = tbl;
 	/* Schedule defense work */
 	INIT_DELAYED_WORK(&ipvs->defense_work, defense_work_handler);
-	schedule_delayed_work(&ipvs->defense_work, DEFENSE_TIMER_PERIOD);
+	queue_delayed_work(system_long_wq, &ipvs->defense_work,
+			   DEFENSE_TIMER_PERIOD);
 
 	return 0;
 }
-- 
2.20.1

